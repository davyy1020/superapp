# 🌐 Panduan Lengkap Upload & Deployment Backend BISPIRA ke Hosting cPanel

Panduan ini disusun khusus untuk hosting cPanel menggunakan fitur **Setup Node.js App** (Phusion Passenger) dan database **MySQL phpMyAdmin**.

Semua berkas paket telah disiapkan dan dikompres sehingga Anda tidak perlu melakukan compile Next.js yang berat di server cPanel.

---

## 📦 Berkas yang Digunakan:
1. **`bispira_cpanel_backend.zip`** (14.5 MB - berada di folder root proyek `c:\Users\Davy\Documents\superapp\bispira_cpanel_backend.zip`).
   - Berisi seluruh API backend Next.js 16, dashboard admin, dan file `server.js` siap jalan.
2. **`bispira_db_dump.sql`** (141 KB - berada di folder root proyek `c:\Users\Davy\Documents\superapp\bispira_db_dump.sql`).
   - Berisi 19 tabel relasional dan data awal Sheet 1 s.d. 12 Excel & PKS.

---

## 🛠️ Langkah Demi Langkah Deployment ke cPanel

### 🔹 LANGKAH 1: Setup Database MySQL di cPanel

1. Login ke cPanel Anda (`https://namadomain.com:2083`).
2. Masuk ke menu **MySQL® Databases** (atau **MySQL® Database Wizard**):
   - **Create New Database**: Buat database baru, misalnya `usercpanel_bispiradb`.
   - **Add New User**: Buat user baru, misalnya `usercpanel_bispirauser` dengan password yang kuat. *(Catat username dan password ini!)*.
   - **Add User To Database**: Hubungkan user ke database tersebut, centang **ALL PRIVILEGES**, lalu klik **Make Changes**.
3. Buka **phpMyAdmin** dari dashboard cPanel:
   - Di kolom kiri, klik nama database Anda (`usercpanel_bispiradb`).
   - Klik tab **Import** di menu atas.
   - Klik **Choose File** dan pilih berkas `bispira_db_dump.sql` dari komputer Anda.
   - Scroll ke bawah dan klik tombol **Import** (atau **Go**).
   - *Hasil:* 19 tabel database relasional BISPIRA berhasil terisi.

---

### 🔹 LANGKAH 2: Upload File Backend ke File Manager

1. Buka menu **File Manager** di cPanel.
2. Di folder root akun hosting (sejajar dengan folder `public_html`, atau di folder subdomain Anda), buat folder baru bernama:
   `bispira_backend`
3. Masuk ke dalam folder `bispira_backend` tersebut.
4. Klik tombol **Upload** di toolbar atas cPanel.
5. Upload berkas **`bispira_cpanel_backend.zip`** (14.5 MB).
6. Setelah upload selesai 100% (indikator hijau), tutup tab upload dan kembali ke File Manager.
7. Klik kanan pada `bispira_cpanel_backend.zip` > pilih **Extract** > **Extract Files**.
8. Setelah file terekstrak, Anda dapat menghapus file `bispira_cpanel_backend.zip` dari File Manager.

---

### 🔹 LANGKAH 3: Konfigurasi "Setup Node.js App"

1. Kembali ke halaman utama cPanel, buka menu **Setup Node.js App** (di kategori *Software*).
2. Klik tombol biru **Create Application**:
   - **Node.js version**: Pilih versi **20.x** (atau minimal 18.x).
   - **Application mode**: Pilih **Production**.
   - **Application root**: Ketik `bispira_backend` (sesuai nama folder di Langkah 2).
   - **Application URL**: Pilih domain atau subdomain Anda (misalnya `api.domainanda.com`).
   - **Application startup file**: Ketik `server.js` *(Sudah disediakan di dalam zip)*.
3. Scroll ke bagian **Environment variables** (Variabel Lingkungan), lalu klik **Add Variable** satu per satu:
   - `DB_HOST` : `localhost`
   - `DB_PORT` : `3306`
   - `DB_NAME` : `usercpanel_bispiradb` *(Nama database Anda)*
   - `DB_USER` : `usercpanel_bispirauser` *(User database Anda)*
   - `DB_PASSWORD` : `password_database_anda`
   - `NODE_ENV` : `production`
4. Klik tombol **Create** di pojok kanan atas.

---

### 🔹 LANGKAH 4: Install Dependencies & Start App

1. Setelah aplikasi tersimpan, klik tombol **Run NPM Install** pada panel aplikasi Node.js.
   *(Proses ini akan mengunduh paket dependensi seperti `next`, `react`, `mysql2`, dan `lucide-react`)*.
2. Setelah instalasi selesai, klik tombol **Restart** di bagian atas panel Node.js App.
3. Klik tombol **Open** (atau buka link subdomain di tab baru browser).

---

### 🔹 LANGKAH 5: Verifikasi Status Live Backend

Buka endpoint pemeriksaan status di browser:
```
https://api.domainanda.com/api/v1/db/status
```

**Respon Sukses yang Muncul:**
```json
{
  "status": "success",
  "message": "Koneksi database MySQL bispira_db aktif dan terhubung!",
  "tablesCount": 19,
  "tables": [
    "admins",
    "buyer_catalog",
    "disbursement_accumulations",
    "disbursements_per_bank",
    "driver_wallets",
    "drivers",
    "merchants",
    "orders",
    "profit_sharing",
    "regional_licenses",
    "revenue_sharing_matrix",
    "seller_bank_accounts",
    "seller_driver_accumulations",
    "tariffs_and_fees",
    "transactions",
    "users"
  ]
}
```

---

### 🔹 LANGKAH 6: Menghubungkan Aplikasi Flutter ke Server cPanel

Perbarui konstanta URL server pada seluruh aplikasi Flutter di workspace:

1. **`bispira_user_app/lib/services/api_service.dart`**:
   ```dart
   static const String baseUrl = 'https://api.domainanda.com/api/v1';
   ```

2. **`bispira_driver_app/lib/utils/osrm_service.dart`**:
   ```dart
   static const String backendApiUrl = 'https://api.domainanda.com/api/v1';
   ```

3. Lakukan hal yang sama untuk `bispira_health_app`, `bispira_expert_app`, dan `bispira_merchant_app`.
