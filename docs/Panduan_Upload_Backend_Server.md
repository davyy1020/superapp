# 🚀 Panduan Lengkap Upload & Deployment Backend BISPIRA ke Server

Dokumen ini menjelaskan tata cara mengunggah, mengonfigurasi, dan menjalankan **Backend BISPIRA SuperApp** (`bispira_admin_web` + database MySQL `bispira_db`) pada server produksi agar dapat diakses oleh seluruh aplikasi mobile dan web admin.

---

## 🏗️ 1. Arsitektur Komponen Backend

| Komponen | Spesifikasi & Versi | Fungsi |
| :--- | :--- | :--- |
| **Framework Backend** | Next.js 16.4.5 (React 19, Node.js 20+) | Menyediakan 36 endpoint API (auth, order, ledger, routing OSRM, VA) & Web Admin Dashboard |
| **Database** | MySQL / MariaDB 10.4+ | Menyimpan 19 tabel relasional (Sheet 1–12 Excel & PKS) |
| **Process Manager** | PM2 (Cluster Mode) | Menjaga server backend tetap aktif 24/7 dan auto-restart saat reboot |
| **Web Server / Proxy** | Nginx | Menerima trafik HTTP/HTTPS (Port 80/443) dan meneruskan ke port 3000 |
| **Keamanan SSL** | Let's Encrypt (Certbot) | Enkripsi data transaksi & API dengan sertifikat SSL gratis |

---

## 🖥️ 2. Metode A: Deployment ke VPS Linux Ubuntu (Sangat Direkomendasikan)

*Metode ini paling optimal untuk menunjang performa routing peta, kalkulasi ledger, dan ribuan transaksi simultan.*

### Berkas Siap Pakai yang Telah Disiapkan di Workspace:
1. **`bispira_db_dump.sql`** (Dump lengkap 19 tabel & data Sheet 1–12).
2. **`bispira_admin_web/deploy.sh`** (Skrip automasi instalasi Node, MySQL, PM2, dan build).
3. **`bispira_admin_web/nginx_bispira.conf`** (Konfigurasi Nginx reverse proxy).
4. **`bispira_admin_web/ecosystem.config.js`** (Konfigurasi PM2 cluster).
5. **`upload_to_server.ps1`** (Skrip sync dari laptop/PC Windows ke VPS).

### Langkah-Langkah Eksekusi di VPS:

#### Langkah 1: Masuk ke VPS via SSH
Buka Terminal / PowerShell di PC Anda dan jalankan:
```bash
ssh root@145.79.15.101
# (Ganti IP dengan IP server Anda jika berbeda)
```

#### Langkah 2: Clone Repository BISPIRA
```bash
cd /var/www
git clone https://github.com/davyy1020/superapp.git bispira
cd /var/www/bispira
```

#### Langkah 3: Import Database MySQL
Jika MySQL sudah terinstall di server:
```bash
mysql -u root -p -e "CREATE DATABASE IF NOT EXISTS bispira_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root -p bispira_db < bispira_db_dump.sql
```

#### Langkah 4: Jalankan Skrip Deploy Otomatis
```bash
cd /var/www/bispira/bispira_admin_web
chmod +x deploy.sh
./deploy.sh
```
*Skrip ini akan otomatis memeriksa Node.js 20, menginstall dependensi `npm install`, melakukan `npm run build`, dan mengaktifkan service PM2 `bispira-backend`.*

#### Langkah 5: Setup Reverse Proxy Nginx
Salin konfigurasi Nginx yang sudah disiapkan:
```bash
sudo cp nginx_bispira.conf /etc/nginx/sites-available/bispira
sudo ln -s /etc/nginx/sites-available/bispira /etc/nginx/sites-enabled/
sudo nginx -t
sudo systemctl reload nginx
```

#### Langkah 6: Pasang Sertifikat SSL Gratis (HTTPS)
```bash
sudo apt install -y certbot python3-certbot-nginx
sudo certbot --nginx -d api.bispira.id -d bispira.id
```

---

## 🌐 3. Metode B: Deployment ke Hosting cPanel (Node.js Selector)

Jika Anda menggunakan hosting berbasis cPanel:

1. **Import Database:**
   - Buka cPanel > **MySQL® Databases Wizard**, buat database baru `user_bispiradb` dan user MySQL.
   - Buka **phpMyAdmin**, pilih database yang baru dibuat, klik tab **Import**, dan upload file `bispira_db_dump.sql`.
2. **Setup Node.js App:**
   - Di cPanel, klik menu **Setup Node.js App** > **Create Application**.
   - Pilih Node.js versi 20.x.
   - Application Mode: `Production`.
   - Application Root: `bispira_admin_web`.
   - Application Startup file: `server.js` atau `node_modules/next/dist/bin/next`.
3. **Upload File Backend:**
   - Kompres folder `bispira_admin_web` (tanpa folder `node_modules` dan `.next`).
   - Upload dan ekstrak di File Manager cPanel.
4. **Environment Variables:**
   - Di menu Node.js App, tambahkan variabel lingkungan:
     - `DB_HOST`: `localhost`
     - `DB_USER`: `user_bispiradb`
     - `DB_PASSWORD`: `password_database_anda`
     - `DB_NAME`: `user_bispiradb`
     - `NODE_ENV`: `production`
5. **Run NPM Install & Build:**
   - Masuk ke terminal cPanel atau klik **Run NPM Install** pada panel Node.js.

---

## 📱 4. Menghubungkan Aplikasi Flutter ke Server Baru

Setelah backend aktif di server (misalnya di domain `https://api.bispira.id` atau IP `http://145.79.15.101`):

Perbarui URL backend pada setiap aplikasi Flutter:

### 1. `bispira_user_app/lib/services/api_service.dart`
```dart
static const String baseUrl = 'https://api.bispira.id/api/v1'; 
// atau 'http://145.79.15.101/api/v1'
```

### 2. `bispira_driver_app/lib/utils/osrm_service.dart`
```dart
static const String backendApiUrl = 'https://api.bispira.id/api/v1';
```

---

## ✅ 5. Verifikasi Deployment Live

Uji apakah server sudah berjalan sempurna dengan membuka browser atau curl:

```bash
# 1. Cek status koneksi MySQL & Server
curl -X GET https://api.bispira.id/api/v1/db/status

# Expected Response:
# {"status":"success","message":"Koneksi database MySQL bispira_db aktif dan terhubung!","tablesCount":19,...}

# 2. Cek endpoint routing & OSRM
curl -X GET "https://api.bispira.id/api/v1/routing?origin_lat=-6.200000&origin_lng=106.816666&dest_lat=-6.210000&dest_lng=106.820000"
```
