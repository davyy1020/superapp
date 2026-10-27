# Panduan Lengkap Ekosistem Go-Super (Interactive Simulation Suite)

Dokumen ini disusun untuk menjelaskan konsep, arsitektur, cara kerja, rumus perhitungan harga, serta kecocokan kode program aplikasi **Go-Super** dengan kebutuhan sistem perutean GIS (OSRM) skala produksi. 

Anda dapat menggunakan dokumen ini sebagai bahan presentasi langsung di depan **Customer** atau sebagai referensi portofolio pekerjaan.

---

## 1. Konsep Utama & Arsitektur Sistem

**Go-Super** adalah sebuah *Interactive Prototype Suite* yang mensimulasikan ekosistem aplikasi super (Super App) modern secara terintegrasi dan *realtime*. 

Tujuan utama prototipe ini adalah mendemonstrasikan bagaimana **Aplikasi Pelanggan (User)**, **Aplikasi Pengemudi (Driver)**, **Merchant Food (Restoran)**, **Merchant Health (Apotek/Klinik)**, dan **Website Admin** saling bertukar data secara instan dengan dukungan mesin perutean geografis (**OSRM GIS Engine**).

### Aliran Data Ekosistem Go-Super:
1. **User** memesan layanan (Ride, Food, atau Health).
2. Sistem menembak server **OSRM GIS Engine** untuk menghitung jarak rute nyata dan waktu tempuh.
3. **Web Admin** menerima data rute, memvalidasi tarif, dan membagikan order ke **Driver** terdekat.
4. **Driver** menerima order, menjalankan GPS (diikuti navigasi peta nyata), dan menyelesaikannya.
5. Dana saldo e-wallet **User** didistribusikan ke dompet **Driver** (80%) dan komisi **Platform** (20%).

---

## 2. Bedah Fitur 6 Portal Utama

Prototipe ini mencakup **5 Portal Bisnis Aktif** dan **1 Portal Engine Teknis** yang dapat dioperasikan secara bersamaan:

### 1. Aplikasi Desktop Admin Suite (Pusat Kontrol Operasional Desktop)
*   **Platform Desktop Native (Windows/macOS/Linux):** Aplikasi Desktop terdedikasi untuk tim operasional BISPIRA (Super Admin Pusat & Admin Cabang Wilayah).
*   **Live Tracking Map (Leaflet & OpenStreetMap):** Menampilkan posisi kurir/driver dan rute perjalanan secara dinamis dalam peta interaktif berbasis *dark-theme*.
*   **Statistik Realtime & Rekonsiliasi Keuangan:** Monitoring user aktif, driver online, merchant aktif, total pendapatan platform, dan antrean verifikasi pembayaran.
*   **Pusat Verifikasi Manual Pembayaran (Tanpa Upload Bukti Bayar):** Tim BISPIRA memverifikasi transaksi masuk secara manual dengan mencocokkan nominal dan **Kode Unik** 3-digit (berlaku 30 menit) langsung terhadap mutasi rekening bank BISPIRA. User **tidak perlu** mengunggah bukti bayar.
*   **Pencairan Dana Penjual (Batch 17:00 WIB):** Akumulasi dana transaksi (maksimal 2 hari) sebelum ditransfer ke penjual/mitra setiap pukul 17:00 WIB dengan potongan **Biaya Pencairan**.
*   **Dynamic Financial & Tariff Customization Center:** Semua parameter bisnis (Tarif/km, Biaya Minimum, Biaya Layanan, Biaya Aplikasi, Markup %, Biaya Pencairan, Charge Driver Rp500, Biaya Ambulance Antar & Angkut, Profit Share Cabang, Rekening Bank BISPIRA, dan Durasi Timer Kode Unik) dapat dikustomisasi secara penuh melalui Aplikasi Desktop Admin.
*   **System Event Logs:** Mencatat setiap aktivitas backend secara transparan detik-demi-detik.

### 2. Aplikasi User / Pelanggan (Simulasi Mobile App)
*   **Manajemen Saldo Go-Pay:** Fitur cek saldo dan simulasi Top-Up instan.
*   **Checkout & Instruksi Transfer Bank Multi-Rekening:** Penerbitan total bayar lengkap dengan **Kode Unik 3-digit** opsional (misal: Rp 100.123) dengan timer masa berlaku 30 menit. Pelanggan cukup melakukan transfer tanpa perlu mengunggah foto bukti bayar.
*   **Layanan Transportasi (Ride Hailing):** Memilih titik jemput dan tujuan dengan kalkulasi tarif dinamis berdasarkan integrasi API OSRM nyata.
*   **Layanan Makanan (Go-Food):** Memilih restoran mitra, menu, menambahkan ke keranjang, dan melakukan pemesanan dengan penyesuaian markup & biaya aplikasi.
*   **Layanan Medis & Ambulance (Go-Health):** Katalog apotek mitra, booking klinik, dan pemesanan **Ambulance** (Biaya Antar + Biaya Angkut Pasien).
*   **Realtime Order Tracking:** Peta mini di dalam *smartphone* pelanggan untuk memantau pergerakan driver yang sedang menuju lokasinya secara *live*.

### 3. Aplikasi Driver / Mitra Pengemudi (Simulasi Mobile App)
*   **Online/Offline Toggle:** Mengatur ketersediaan pengemudi untuk menerima pesanan baru.
*   **Penerimaan Order Efisien:** Popup interaktif "Order Masuk" dengan ringkasan titik jemput, titik antar, jarak tempuh, dan **Pendapatan Bersih**.
*   **Potongan Charge Driver per Transaksi:** Setiap transaksi berhasil memotong biaya komisi/platform sebesar **Rp 500** (dapat diatur di Desktop Admin).
*   **Sistem Navigasi Terintegrasi:** Menampilkan petunjuk arah jalan demi jalan (*turn-by-turn instruction*) dengan animasi pergerakan GPS driver di peta mini handphone.
*   **Manajemen Pendapatan:** Ringkasan jumlah orderan sukses hari ini beserta saldo dompet driver.

### 4. Merchant Food Portal (Dashboard Pemilik Restoran)
*   **Antrean Pesanan Realtime:** Menerima notifikasi instan ketika pelanggan memesan makanan.
*   **Alur Dapur Terintegrasi:** Tombol "Konfirmasi & Siapkan Pesanan" untuk memulai proses memasak di dapur, diikuti dengan tombol "Siap Diantar" yang secara otomatis menugaskan driver terdekat.
*   **Pencairan Dana (Batch 17:00 WIB):** Menerima akumulasi hasil penjualan (maksimal 2 hari) pada pukul 17:00 WIB setelah dipotong **Biaya Pencairan**.

### 5. Merchant Health Portal (Dashboard Apotek & Klinik)
*   **Verifikasi Resep & Obat:** Dashboard untuk apoteker mengemas obat pesanan pelanggan sebelum dicarikan kurir pengantar.
*   **Manajemen Booking Klinik & Ambulance:** Memproses reservasi konsultasi dokter atau pesanan unit Ambulance.

### 6. OSRM GIS Engine (Dapur Pacu Navigasi)
*   **Custom LUA Routing Profiles:** Memungkinkan admin mengubah aturan jalan untuk kendaraan berbeda (misalnya: Motor boleh melewati gang sempit, sedangkan Mobil dilarang masuk gang sempit dan disarankan menggunakan Jalan Tol).
*   **OSRM Compiler Simulator:** Menunjukkan visualisasi terminal kompilasi data mentah peta Indonesia (`.osm.pbf`) hingga siap dijalankan di dalam container Docker.
*   **API Client Playground:** Uji coba REST API untuk *Distance Matrix* (tabel waktu dan jarak antar titik) yang mengembalikan data format JSON asli secara instan.

---

## 3. Rumus Perhitungan Harga & Bagi Hasil (Format Teks Biasa)

Semua rumus ini diatur melalui Aplikasi Desktop Admin dan berjalan di backend javascript program (`app.js`):

### A. Komponen Harga Jual Konsumen (General Service)
Harga total yang dibayar oleh Pelanggan dihitung dengan rumus:

> **Total Harga Jual = Harga Dasar Penjual + Markup (%) + Biaya Layanan + Biaya Aplikasi + Kode Unik (3-Digit)**

*   **Harga Dasar Penjual:** Nilai bersih produk/layanan yang dipatok oleh mitra (misal: Rp 15.000).
*   **Biaya Markup (%):** Persentase kenaikan harga resmi platform yang ditentukan di Desktop Admin.
*   **Biaya Layanan & Biaya Aplikasi:** Biaya operasional platform BISPIRA (Default: Rp 2.000 & Rp 1.000).
*   **Kode Unik (3-Digit):** Nominal unik acak (misal Rp 123 pada total Rp 100.123) untuk mempermudah verifikasi manual di mutasi bank. Berlaku **30 menit**. Seluruh nominal kode unik masuk ke rekening BISPIRA.

---

### B. Rumus Pencairan Dana Penjual (Batch 17:00 WIB)
Penjual/mitra menerima pembayaran hasil akumulasi transaksi (maksimal 2 hari) yang ditransfer setiap pukul 17:00 WIB dengan rumus:

> **Nilai Pencairan Netto Penjual = Harga Dasar Penjual - Biaya Pencairan**

*Contoh Perhitungan:*
*   Harga Jual Konsumen: **Rp 20.000** (sudah termasuk markup, biaya layanan, dan biaya aplikasi).
*   Harga Dasar Penjual: **Rp 15.000**.
*   Biaya Pencairan Platform (*Disbursement Fee*): **Rp 1.000**.
*   **Penerimaan Netto Penjual:** Rp 15.000 - Rp 1.000 = **Rp 14.000**.

---

### C. Tarif Layanan Ambulance
Pemesanan armada Ambulance dihitung secara khusus berdasarkan dua komponen biaya utama:

> **Total Biaya Ambulance = Biaya Antar Dasar + Biaya Angkut Pasien**

*   **Biaya Antar Dasar:** Tarif transportasi armada berdasarkan jarak/kategori (Default: Rp 150.000).
*   **Biaya Angkut Pasien:** Biaya penanganan dan pendampingan medis pasien (Default: Rp 50.000).
*   Kedua komponen biaya ini dapat disesuaikan (*customizable*) dari Aplikasi Desktop Admin.

---

### D. Potongan Charge Driver per Transaksi
Untuk setiap transaksi ride-hailing / delivery yang diselesaikan oleh Driver:

> **Biaya Charge Driver = Rp 500 / Transaksi**

*   Saldo dompet Driver dipotong otomatis sebesar **Rp 500** per trip yang dikonfirmasi.
*   Nilai potongan ini dapat diubah (*changeable*) melalui Aplikasi Desktop Admin.

---

### E. Profit Share Cabang Wilayah
*   Setiap transaksi menghasilkan komisi platform yang dibagi otomatis antara **Super Admin Pusat** dan **Admin Cabang Wilayah** berdasarkan wilayah asal lokasi transaksi (misal: 70% Pusat / 30% Cabang Wilayah).
*   Persentase profit share wilayah ini dapat dikustomisasi langsung melalui Aplikasi Desktop Admin.

---

## 4. Pemetaan Syarat Lowongan Fastwork dengan Kode Program

Berikut adalah bukti kesesuaian kode program Anda (`app.js` & `index.html`) dengan spesifikasi teknis yang diminta di lowongan Fastwork:

### 1. Pemrosesan Data OSM
*   **Kebutuhan:** Menguasai tools `osrm-extract`, `osrm-partition`, `osrm-customize`.
*   **Implementasi di Kode:** Fungsi `runOsmPipelineSimulator()` di `app.js` (Baris 1681 - 1754). Kode ini mensimulasikan langkah-demi-langkah *command-line pipeline* asli di server Linux untuk pemrosesan file peta `.osm.pbf` Indonesia dan pemuatan ulang Docker container.

### 2. Custom Scripting dengan Bahasa LUA
*   **Kebutuhan:** Menulis skrip LUA untuk membedakan rute kustom (kecepatan motor vs mobil, gang sempit).
*   **Implementasi di Kode:** Konstanta `LUA_PROFILES` di `app.js` (Baris 1569 - 1646). Berisi script LUA asli untuk profile `motorcycle` (diizinkan masuk gang sempit, jalan tol diblokir) dan profile `car` (gang sempit diblokir penuh dengan menyetel kecepatan ke 0, jalan tol diizinkan hingga 100km/jam).

### 3. Infrastruktur Server & Optimasi RAM
*   **Kebutuhan:** Docker & Linux, optimasi RAM server untuk data peta negara Indonesia.
*   **Implementasi di Kode:** Widget RAM Monitor di `index.html` dan logika status memori di `changeLuaProfile()` & `runOsmPipelineSimulator()`. Menggunakan visualisasi RAM yang memuncak saat build dan penjelasan metode **MLD (Multi-Level Dijkstra)** untuk menghemat pemakaian RAM server.

### 4. Integrasi Backend & API (Distance Matrix)
*   **Kebutuhan:** Menghubungkan output JSON OSRM ke aplikasi dan memahami konsep *Distance Matrix*.
*   **Implementasi di Kode:**
    *   **Distance Matrix:** Fungsi `sendMockDistanceMatrixRequest()` di `app.js` (Baris 1756 - 1791) mensimulasikan request ke `/table/v1/motorcycle` dan mengembalikan JSON matriks jarak & waktu $3 \times 3$ asli.
    *   **Live Route API:** Fungsi `calculateRideFareSim()` di `app.js` (Baris 381 - 470) yang memanggil real API router Project OSRM: `https://router.project-osrm.org/route/v1/driving/...` untuk mendapatkan geometri jalanan nyata secara realtime dan menggambarnya di peta Leaflet.

### 5. Pengalaman Industri Logistik / Ride-Hailing
*   **Kebutuhan:** Pengalaman di alur kerja bisnis ride-hailing/logistik.
*   **Implementasi di Kode:** Logika transaksional di `app.js` (Baris 472 - 1148) yang mengotomatisasi siklus pemesanan, pencarian driver, konfirmasi restoran, pergerakan GPS, penyelesaian transaksi, pembagian hasil, dan fitur **Keamanan Anti Fake-GPS** yang memblokir akun driver nakal.

---

## 5. Langkah Demonstrasi Live di Depan Customer

1.  **Aktifkan Mode Ekosistem Live:** Di sidebar kiri atas, klik tombol **"Ekosistem Live"** agar customer melihat kelima portal (Admin, User, Driver, Merchant) berjalan sinkron dalam satu layar.
2.  **Jalankan Simulasi Ride Hailing:** Klik tombol biru **"⚡ Simulasikan Ride Hailing"**, lalu ikuti alur: pesan di HP User -> terima di HP Driver -> amati motor bergerak di peta navigasi -> klik selesaikan perjalanan -> tunjukkan pembagian komisi 80/20 di dashboard keuangan Admin.
3.  **Demosikan Fitur Anti Fake GPS:** Klik tombol merah **"🚨 Tes Proteksi Fake GPS"** untuk menunjukkan kesiapan fitur keamanan platform Anda. Akun driver Budi akan langsung ditangguhkan secara otomatis.
4.  **Tunjukkan Panel Teknis OSRM GIS Engine:** Buka menu navigasi sebelah kiri, pilih **6. OSRM GIS Engine**. Tunjukkan skrip LUA kustom, jalankan simulator kompilasi Docker, dan tunjukkan hasil JSON Distance Matrix asli.

---

## 6. Server Infrastructure Assessment (Asesmen Infrastruktur Server)

Untuk menjalankan ekosistem backend skala produksi dengan andal, sistem memerlukan infrastruktur server terdistribusi yang efisien. Berikut adalah hasil asesmen kebutuhan spesifikasi resource server:

### A. Arsitektur Layanan Inti
Sistem produksi dirancang menggunakan containerization berbasis Docker yang terdiri dari:
1.  **Backend (REST API):** Layer bisnis utama, menangani auth, session, real-time socket connection, assignment driver, dan gateway pembayaran.
2.  **OSRM GIS Engine:** Mesin perutean yang memuat file grafik rute hasil kompilasi langsung ke memori (in-memory routing).
3.  **Redis:** In-memory key-value store untuk tracking koordinat driver secara realtime (GPS tracking), caching, dan state management sementara.
4.  **Database (PostgreSQL/PostGIS):** Penyimpanan jangka panjang data persisten untuk transaksi, riwayat perjalanan, dan data spatial GIS.
5.  **Worker Service:** Menangani antrean tugas latar belakang (*background workers*) seperti notifikasi push, rekonsiliasi pembayaran, dan pembuatan laporan.

### B. Estimasi Kebutuhan RAM OSRM per Wilayah (Peta Indonesia)
RAM OSRM bergantung penuh pada ukuran peta yang telah diproses (*preprocessed routing graph*). Berikut perbandingannya:

| Wilayah (Region) | Ukuran File PBF Mentah | Estimasi Ukuran Preprocessed | Kebutuhan RAM Minimum |
| :--- | :--- | :--- | :--- |
| **Jawa** | 851 MB | 2.5 - 6.8 GB | **4 - 8 GB** |
| **Sumatra** | 267 MB | 0.8 - 2.1 GB | **2 - 4 GB** |
| **Nusa Tenggara** | 164 MB | 0.4 - 1.3 GB | **2 - 4 GB** |
| **Sulawesi** | 150 MB | 0.4 - 1.2 GB | **2 - 4 GB** |
| **Kalimantan** | 139 MB | 0.4 - 1.1 GB | **2 - 4 GB** |
| **Papua** | 32.4 MB | 0.1 - 0.3 GB | **1 - 2 GB** |
| **Maluku** | 25.4 MB | 0.08 - 0.2 GB | **1 - 2 GB** |

*Catatan: Ukuran total file peta Indonesia secara keseluruhan dari Geofabrik adalah sekitar **1.9 GB PBF (compressed)**. Setelah dikompilasi oleh OSRM, graf jalanan membengkak 3 - 8x lipat menjadi sekitar **15 - 16 GB**, sehingga memerlukan RAM minimum **16 - 24 GB** jika ingin melayani rute seluruh Indonesia dalam satu server.*

### C. Estimasi Penggunaan Resource per Komponen
| Komponen Layanan | Kebutuhan CPU | Kebutuhan RAM | Karakteristik Beban |
| :--- | :--- | :--- | :--- |
| **Backend API** | 2 Core | 4 GB | Dipengaruhi oleh concurency request user dan socket.io |
| **OSRM Engine** | 4 - 8 Core | 10 - 16 GB | Sangat memakan RAM untuk loading data graph rute jalan |
| **Redis Store** | 2 Core | 4 - 8 GB | Menyimpan status GPS realtime driver di dalam RAM |
| **Database Spatial** | 2 - 4 Core | 4 - 8 GB | Fokus pada I/O disk untuk write order dan log transaksi |
| **Total Minimum** | **8 Core** | **24 - 32 GB** | *Spesifikasi gabungan dalam satu server atau terdistribusi* |

### D. Perbandingan Provider VPS
Berikut adalah hasil analisis tiga opsi provider VPS untuk deploy sistem:

1.  **Biznet Neo Lite Pro ML 24.8**
    *   **Spesifikasi:** 8 Core CPU, 24 GB RAM, 100 GB NVMe Storage
    *   **Harga:** Rp 1.429.000 / bulan
    *   **Kelebihan:** Lokasi data center Indonesia (latency sangat rendah untuk pengguna lokal), menggunakan storage NVMe cepat, tagihan IDR tetap.
    *   **Kekurangan:** Kapasitas RAM 24 GB relatif pas-pasan jika OSRM seluruh Indonesia diletakkan di server yang sama dengan Redis dan DB. Upgrade tier berikutnya cukup mahal.

2.  **Rumahweb VPS X3L**
    *   **Spesifikasi:** 8 Core CPU, 32 GB RAM, 600 GB Storage
    *   **Harga:** Rp 1.875.000 / bulan
    *   **Kelebihan:** RAM besar (32 GB) aman untuk OSRM & Redis, storage ekstra longgar untuk backup data peta dan log. Lokasi data center Indonesia.
    *   **Kekurangan:** Kurang fleksibel jika ingin menerapkan sistem autoscaling horizontal.

3.  **Hetzner CCX33**
    *   **Spesifikasi:** 8 Core vCPU (Dedicated), 32 GB RAM, 240 GB SSD Storage
    *   **Harga:** $74.59 / bulan (Sekitar Rp 1.349.467 / bulan)
    *   **Kelebihan:** *Price-to-performance* terbaik, CPU dedicated stabil, RAM besar, infrastruktur sangat matang dengan scaling cloud fleksibel.
    *   **Kekurangan:** Server berada di luar Indonesia (AS/Eropa), latency koneksi sedikit lebih tinggi, biaya berfluktuasi mengikuti kurs dolar.

---

## 7. Rencana Anggaran Biaya (RAB) & Estimasi Proyek

Berdasarkan scope pekerjaan dan kebutuhan fitur ekosistem aplikasi Go-Super, berikut adalah estimasi biaya pengembangan software dan peluncuran produk:

| No | Komponen Pekerjaan | Deskripsi Cakupan Fitur | Durasi Kerja | Biaya Pengembangan |
| :---: | :--- | :--- | :---: | :--- |
| 1 | **Aplikasi User (Mobile)** | Fitur Login/Register, pemesanan Ride Hailing, Food Delivery, Layanan Kesehatan, Pelacakan Pesanan realtime dasar. | 12 Hari | Rp 1.500.000 |
| 2 | **Aplikasi Driver (Mitra)** | Manajemen Terima/Tolak order, toggle status online/offline, navigasi peta dasar (OSRM), live tracking lokasi. | 10 Hari | Rp 1.500.000 |
| 3 | **Merchant Food Portal** | Kelola menu restoran mitra, penyesuaian harga, kontrol stok, dan terima pesanan order masuk. | 5 Hari | Rp 700.000 |
| 4 | **Merchant Kesehatan Portal** | Manajemen katalog apotek, verifikasi resep dokter, transaksi obat-obatan, dan update status order. | 5 Hari | Rp 700.000 |
| 5 | **Website Admin Fullstack** | Dashboard pemantauan peta live driver, monitoring transaksi keuangan, kelola akun user/driver/merchant. | 10 Hari | Rp 1.500.000 |
| 6 | **Backend API & Database** | Pengembangan REST API, sistem otentikasi token JWT, integrasi database spatial relasional. | 7 Hari | Rp 800.000 |
| 7 | **OSRM GIS Integration** | Routing rute jalan, estimasi jarak dan waktu tempuh dinamis, pencarian driver terdekat (*nearby driver*). | 4 Hari | Rp 400.000 |
| 8 | **Security System Core** | Pengamanan otentikasi token, proteksi fraud transaksi dasar, proteksi modul anti-Fake GPS. | 4 Hari | Rp 445.000 |
| 9 | **Aplikasi Private (Scheduled)** | Penjadwalan order otomatis untuk Merchant Food & Ride Hailing (booking order terjadwal). | - | Rp 500.000 |
| 10 | **Biaya Publish Google Play Store** | Pembelian akun developer Google Play Store ($25 USD × Rp 18.200). | - | Rp 455.000 |
| 11 | **OSRM Full Setup & Integrasi Server**| Setup container Docker Linux, kompilasi data peta, optimasi file LUA motor/mobil, matriks jarak (Distance Matrix), ETA driver. | 5 Hari | Rp 1.000.000 |
| | **TOTAL KESELURUHAN** | **Ekosistem Super App Terpadu & GIS OSRM Engine** | **62 Hari** | **Rp 9.500.000** |

---

## 8. Analisis Komparatif: Go-Super vs Gojek, Grab, dan Shopee

Bagian ini menyajikan analisis mendalam mengenai bagaimana modul-modul simulasi di dalam prototype **Go-Super** memetakan fitur-fitur nyata dari tiga raksasa teknologi Asia Tenggara: **Gojek**, **Grab**, dan **Shopee**. Mengingat sistem Go-Super saat ini berfungsi sebagai media simulasi (prototipe), dokumen ini juga menjelaskan perbedaan pemrosesan teknis antara visualisasi simulasi kami dengan sistem produksi berskala jutaan transaksi harian.

### A. Tabel Pemetaan Fitur (Feature Mapping)

| Modul / Layanan | Gojek (Production) | Grab (Production) | Shopee (Production) | Simulator Go-Super (Simulasi) |
| :--- | :--- | :--- | :--- | :--- |
| **Transportasi** | GoRide / GoCar | GrabBike / GrabCar | - | **Ride Hailing (Transportasi)**: Simulasi rute nyata Monas-Sudirman via API Live OSRM, tarif dinamis, tracking pergerakan GPS driver di peta mini, dan penyelesaian trip. |
| **Pesan Antar Makanan** | GoFood | GrabFood | ShopeeFood | **Food Delivery (Pesan Antar)**: Alur checkout makanan, sinkronisasi notifikasi order masuk ke Merchant Food, update status memasak di dapur, auto-dispatch kurir terdekat. |
| **Kesehatan / Obat** | GoMed (Halodoc) | GrabHealth (Good Doctor) | Apotek Shopee | **Go-Health**: Fitur checkout obat apotek mitra secara instan dan penjadwalan (booking) klinik dokter spesialis secara otomatis. |
| **Dompet Digital** | GoPay | OVO | ShopeePay | **Wallet Simulation**: Pengurangan saldo Go-Pay user, pengisian (Top-Up) instan, transfer dana trip ke Driver (80%), dan komisi Platform (20%). |
| **Dashboard Mitra** | Go-Biz (Merchant) / GoPartner (Driver) | GrabMerchant / GrabDriver | Shopee Partner / Shopee Driver | **Merchant & Driver Portal**: Terintegrasi langsung dalam tab simulasi untuk memproses pesanan dapur, mengaktifkan status online driver, dan melihat navigasi peta. |
| **GIS & Routing** | Google Maps API / Custom Engine | Mapbox / Enterprise Routing | Google Maps / Local Router | **OSRM GIS Engine**: Peta interaktif Leaflet + OpenStreetMap, visualisasi pipeline kompilasi peta `.osm.pbf`, custom LUA profiles motor vs mobil, dan client API Distance Matrix JSON. |
| **Keamanan Platform** | SHIELD (Anti-Fraud & Root detection) | Grab Defense (Device integrity) | Shopee Security Core | **Anti-Fake GPS Protection**: Tombol simulator pendeteksi anomali telemetri koordinat GPS yang membekukan akun driver seketika. |

---

### B. Bedah Teknis Modul: Perbandingan Simulasi vs Produksi

#### 1. Modul Transportasi (Ride Hailing)
*   **Simulasi Go-Super:** User memilih titik penjemputan dan tujuan dari daftar stasioner (Sudirman, Monas, Senayan, dll.). Script `app.js` menembak API publik OSRM (`router.project-osrm.org`) secara asinkron untuk mendapatkan rute jalan nyata, kemudian menggerakkan marker driver di atas peta Leaflet menggunakan fungsi animasi berbasis interval waktu (`animateDriverMovement`).
*   **Sistem Produksi (Gojek / Grab):**
    *   **Geofencing & Map SDK:** Menggunakan SDK peta berbayar (Google Maps SDK atau Mapbox) yang diintegrasikan langsung ke aplikasi Android/iOS dengan dukungan geofencing presisi tinggi untuk mendeteksi koordinat lintang/bujur aktual user secara realtime.
    *   **Matchmaking & Dispatching:** Pencarian driver dilakukan menggunakan indeks spasial (seperti **Uber H3 Spatial Index** atau **Google S2 Library**) untuk membagi bumi menjadi sel-sel heksagonal/persegi kecil. Sistem mencocokkan pesanan dengan driver terdekat yang berstatus bebas menggunakan algoritma pencocokan graf bipartite (*Hungarian Algorithm*) yang mempertimbangkan arah hadap driver, kemacetan, dan histori pembatalan order.
    *   **GPS Streaming:** Telemetri GPS dikirimkan setiap 1-3 detik dari aplikasi driver ke server backend melalui protokol **MQTT** atau **WebSockets** berlatensi sangat rendah, yang kemudian disiarkan langsung ke aplikasi pelanggan.

#### 2. Modul Pesan Antar Makanan (Food Delivery)
*   **Simulasi Go-Super:** Pembelian Ayam Geprek disimulasikan dari keranjang belanja user ke antrean dapur Merchant Food. Setelah restoran menekan tombol "Siap Diantar", sistem secara otomatis memicu popup order baru ke aplikasi Driver tanpa perlu pencarian rumit.
*   **Sistem Produksi (Gojek / Grab / Shopee):**
    *   **Integrasi Merchant POS:** Aplikasi merchant (seperti Go-Biz atau GrabMerchant) berjalan pada tablet Android khusus yang terhubung ke printer struk thermal dan sistem kasir restoran.
    *   **Order Batching:** Sistem alokasi cerdas dapat menggabungkan 2 pesanan makanan dari restoran yang sama (atau restoran yang berdekatan) untuk diantarkan oleh 1 driver guna memaksimalkan pendapatan driver dan menghemat ongkos kirim pelanggan (*multi-stop routing*).
    *   **Dynamic ETA:** Waktu estimasi makanan tiba dihitung secara berlapis: Waktu persiapan makanan oleh merchant (berdasarkan jenis makanan dan tingkat keramaian dapur) + Waktu tempuh driver menuju merchant + Waktu pengiriman driver ke konsumen berdasarkan kondisi lalu lintas saat itu.

#### 3. Modul Kesehatan (Go-Health)
*   **Simulasi Go-Super:** Menyediakan katalog pemesanan obat apotek dan form penjadwalan klinik dokter.
*   **Sistem Produksi (Gojek GoMed / GrabHealth):**
    *   **Telekonsultasi Dokter:** Terintegrasi langsung dengan platform telemedicine mitra (seperti Halodoc atau Good Doctor). Pengguna melakukan chat atau panggilan video terenkripsi dengan dokter berlisensi.
    *   **Digital Prescription (Resep Digital):** Dokter mengeluarkan resep digital resmi yang secara otomatis dikirimkan ke apotek mitra berlisensi terdekat (seperti Apotek Kimia Farma atau Century) yang memiliki stok obat tersebut.
    *   **Regulasi & Keamanan Farmasi:** Sistem harus mematuhi regulasi ketat Kementerian Kesehatan dan BPOM terkait distribusi obat keras (obat dengan lingkaran merah wajib resep dokter tidak boleh diproses otomatis tanpa verifikasi resep dokter oleh apoteker berwenang).

#### 4. Dompet Digital & Bagi Hasil (Go-Pay / OVO / ShopeePay)
*   **Simulasi Go-Super:** Skema pembagian hasil 80% untuk driver dan 20% untuk platform langsung dikurangi dari saldo virtual pengguna dan didistribusikan secara instan ke dompet driver dan revenue platform begitu tombol "Selesaikan Trip" ditekan.
*   **Sistem Produksi (Gojek / Grab / Shopee):**
    *   **PCI-DSS Compliance:** Transaksi keuangan asli harus mengikuti standar keamanan kartu internasional (PCI-DSS) dan memerlukan lisensi uang elektronik resmi dari Bank Indonesia (seperti lisensi GoPay, ShopeePay, atau LinkAja).
    *   **Escrow & Settlement Ledger:** Dana dari pengguna tidak langsung ditransfer ke rekening pribadi driver seketika. Saldo ditampung sementara di akun penampung (*escrow account*). Driver dan merchant dapat melakukan penarikan dana (*payout/withdrawal*) ke rekening bank mereka masing-masing sekali sehari melalui integrasi API *Disbursement* pihak ketiga (seperti Midtrans, Xendit, atau FasaPay) yang memakan waktu 1x24 jam untuk kliring perbankan.
    *   **Pajak & Potongan:** Pembagian pendapatan juga harus memperhitungkan potongan pajak (PPn/PPh pasal 21) bagi hasil mitra pengemudi dan komisi merchant secara otomatis.

#### 5. Keamanan & Proteksi Fraud (Anti Fake-GPS)
*   **Simulasi Go-Super:** Menyediakan tombol simulasi deteksi kecurangan yang memicu status penangguhan akun driver Budi dan mencatat insiden tersebut di log admin.
*   **Sistem Produksi (Gojek SHIELD / Grab Defense):**
    *   **Device Attestation:** Aplikasi driver mendeteksi apakah sistem operasi ponsel telah dimodifikasi (Rooted Android atau Jailbroken iOS) menggunakan Google Play Integrity API atau Apple DeviceCheck.
    *   **Mock Location Detection:** Mendeteksi penggunaan aplikasi pihak ketiga pembaca lokasi palsu (*tuyul/fake GPS*) dengan memeriksa API sistem Android (`Location.isFromMockProvider()`) dan mendeteksi package aplikasi terlarang yang berjalan di latar belakang (seperti GPS Spoofer).
    *   **Analisis Anomali Kecepatan (Telemetry Jumps):** Sistem menganalisis lompatan koordinat GPS kurir. Jika seorang driver berpindah sejauh 5 KM dalam waktu 2 detik (melebihi kecepatan motor maksimum), sistem AI secara otomatis menandai adanya kecurangan manipulasi koordinat dan langsung memblokir akun driver secara permanen.

#### 6. Routing & Maps Engine (OSRM vs Google Maps / Mapbox)
*   **Simulasi Go-Super:** Menggunakan OSRM open-source publik untuk melakukan routing jalan nyata Jakarta. Konfigurasi LUA diintegrasikan di simulator untuk menunjukkan bagaimana sistem membedakan jalur motor (yang diizinkan masuk gang lebar <2 meter) dan jalur mobil (wajib tol jika jarak jauh).
*   **Sistem Produksi (Gojek / Grab / Shopee):**
    *   **Commercial Map Providers:** Layanan komersial skala besar seringkali menggabungkan penyedia peta seperti Google Maps API (untuk visualisasi dan pencarian alamat/geocoding) dengan mesin routing kustom internal (berbasis OSRM, Valhalla, atau GraphHopper yang dideploy sendiri) untuk menekan biaya tagihan API Google Maps yang sangat mahal.
    *   **Real-time Traffic Integration:** Mesin routing produksi memproses data lalu lintas langsung (*live traffic speed*) yang diperbarui setiap menit dari data GPS jutaan pengemudi aktif di jalanan, sehingga rute alternatif tercepat selalu disesuaikan secara dinamis untuk menghindari kemacetan parah.
    *   **Matrix Routing Scalability:** Untuk mencocokkan 100 driver dengan 50 orderan secara realtime, server GIS harus mampu menghitung matriks jarak $100 \times 50$ secara instan (Distance Matrix API). OSRM sangat unggul di bagian ini karena memanfaatkan memori heap server secara maksimal untuk proses kalkulasi berlatensi mikrodetik.

---

### C. Analisis Kesenjangan Produksi (Roadmap Gap Analysis)

Apabila Anda berencana meluncurkan sistem **Go-Super** dari status prototipe saat ini menjadi aplikasi siap produksi di pasar nyata, berikut adalah daftar kesenjangan arsitektur yang wajib dikembangkan:

1.  **State Persistence & Relational Database:** Mengganti penyimpanan state memori di Javascript (`app.js`) menjadi database relasional tangguh (seperti PostgreSQL dengan ekstensi **PostGIS** untuk query data spasial) guna menyimpan riwayat transaksi, user profile, dan log transaksi secara permanen.
2.  **WebSocket Connection Server:** Membangun server WebSockets terdedikasi (menggunakan Node.js/Socket.io, Go, atau Elixir) untuk menangani komunikasi dua arah secara realtime antara aplikasi driver, user, dan dashboard admin tanpa membebani server REST API utama.
3.  **Authentication & Security:** Menerapkan otentikasi standar industri berbasis JWT (JSON Web Tokens) dengan enkripsi HTTPS/TLS di seluruh endpoint API, serta otentikasi dua arah (2FA) menggunakan SMS OTP (seperti Twilio atau Infobip) saat login atau penarikan saldo.
4.  **Payment Gateway Integration:** Mengintegrasikan SDK Payment Gateway resmi Indonesia (Midtrans, Xendit, atau Doku) agar pengguna dapat melakukan top-up Go-Pay menggunakan transfer bank virtual account, kartu kredit, QRIS, atau jaringan minimarket (Indomaret/Alfamart) secara otomatis.
5.  **Daftar Distribusi Server (Production VPS Infrastructure):** Memisahkan server database, server REST API backend, server Redis Cache tracker, dan server OSRM Routing Engine ke dalam instance VPS terpisah untuk mencegah kemacetan server tunggal (*single point of failure*). OSRM wajib ditaruh di VPS RAM besar terdedikasi (minimal 16-32 GB RAM) agar caching graf peta berjalan optimal tanpa mengganggu performa server API transaksi.


