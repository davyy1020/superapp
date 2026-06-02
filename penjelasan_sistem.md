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

### 1. Website Admin Dashboard (Pusat Kontrol Operasional)
*   **Live Tracking Map (Leaflet & OpenStreetMap):** Menampilkan posisi kurir/driver dan rute perjalanan secara dinamis dalam peta interaktif berbasis *dark-theme*.
*   **Statistik Realtime:** Monitoring jumlah user aktif, driver online, merchant aktif, dan total pendapatan platform (komisi) secara instan.
*   **Pusat Verifikasi Driver:** KTP, SIM, STNK, foto kendaraan driver disimulasikan dan disetujui secara realtime.
*   **Fleksibilitas Tarif:** Pengaturan tarif per kilometer, tarif minimum perjalanan, biaya layanan platform, dan komisi platform yang dapat diubah dan disimpan langsung.
*   **System Event Logs:** Mencatat setiap aktivitas backend secara transparan detik-demi-detik.

### 2. Aplikasi User / Pelanggan (Simulasi Mobile App)
*   **Manajemen Saldo Go-Pay:** Fitur cek saldo dan simulasi Top-Up instan.
*   **Layanan Transportasi (Ride Hailing):** Memilih titik jemput dan tujuan dengan kalkulasi tarif dinamis berdasarkan integrasi API OSRM nyata.
*   **Layanan Makanan (Go-Food):** Memilih restoran mitra, menu, menambahkan ke keranjang, dan melakukan pemesanan.
*   **Layanan Medis (Go-Health):** Katalog apotek mitra untuk pembelian obat booster atau penjadwalan (booking) klinik secara otomatis.
*   **Realtime Order Tracking:** Peta mini di dalam *smartphone* pelanggan untuk memantau pergerakan driver yang sedang menuju lokasinya secara *live*.

### 3. Aplikasi Driver / Mitra Pengemudi (Simulasi Mobile App)
*   **Online/Offline Toggle:** Mengatur ketersediaan pengemudi untuk menerima pesanan baru.
*   **Penerimaan Order Efisien:** Popup interaktif "Order Masuk" dengan ringkasan titik jemput, titik antar, jarak tempuh, dan **Pendapatan Bersih** (setelah dipotong komisi platform).
*   **Sistem Navigasi Terintegrasi:** Menampilkan petunjuk arah jalan demi jalan (*turn-by-turn instruction*) dengan animasi pergerakan GPS driver di peta mini handphone.
*   **Manajemen Pendapatan:** Ringkasan jumlah orderan sukses hari ini beserta saldo dompet driver yang terus bertambah secara otomatis setiap kali trip selesai.

### 4. Merchant Food Portal (Dashboard Pemilik Restoran)
*   **Antrean Pesanan Realtime:** Menerima notifikasi instan ketika pelanggan memesan makanan.
*   **Alur Dapur Terintegrasi:** Tombol "Konfirmasi & Siapkan Pesanan" untuk memulai proses memasak di dapur, diikuti dengan tombol "Siap Diantar" yang secara otomatis menugaskan driver terdekat untuk mengambil makanan.

### 5. Merchant Health Portal (Dashboard Apotek & Klinik)
*   **Verifikasi Resep & Obat:** Dashboard untuk apoteker mengemas obat pesanan pelanggan sebelum dicarikan kurir pengantar.
*   **Manajemen Booking Klinik:** Memproses reservasi konsultasi dokter umum atau spesialis gigi.

### 6. OSRM GIS Engine (Dapur Pacu Navigasi)
*   **Custom LUA Routing Profiles:** Memungkinkan admin mengubah aturan jalan untuk kendaraan berbeda (misalnya: Motor boleh melewati gang sempit, sedangkan Mobil dilarang masuk gang sempit dan disarankan menggunakan Jalan Tol).
*   **OSRM Compiler Simulator:** Menunjukkan visualisasi terminal kompilasi data mentah peta Indonesia (`.osm.pbf`) hingga siap dijalankan di dalam container Docker.
*   **API Client Playground:** Uji coba REST API untuk *Distance Matrix* (tabel waktu dan jarak antar titik) yang mengembalikan data format JSON asli secara instan.

---

## 3. Rumus Perhitungan Harga & Bagi Hasil (Format Teks Biasa)

Semua rumus ini berjalan otomatis di backend javascript program (`app.js`):

### A. Tarif Perjalanan (Ride Hailing)
Tarif perjalanan dihitung secara dinamis berdasarkan jarak tempuh nyata yang diperoleh dari OSRM GIS Router Server:

> **Total Tarif = (Jarak dalam KM * Tarif per KM) + Biaya Minimum + Biaya Layanan Platform**

*   **Tarif per KM:** Default: **Rp 2.500**.
*   **Biaya Minimum:** Batas tarif terendah untuk menghargai usaha driver pada jarak dekat (Default: **Rp 8.000**).
*   **Biaya Layanan Platform:** Biaya administrasi sistem aplikasi (Default: **Rp 2.000**).

*Contoh Perhitungan:*
Jika jarak perjalanan dari Sudirman ke Monas adalah **8.2 KM**:
*   Tarif Jarak = 8.2 KM * Rp 2.500 = Rp 20.500
*   Total Tarif = Rp 20.500 + Rp 8.000 + Rp 2.000 = **Rp 30.500**

#### Pembagian Pendapatan (Komisi Platform 20%):
*   **Pendapatan Bersih Driver (80%)** = Rp 30.500 * 80% = **Rp 24.400**
*   **Pendapatan Platform / Perusahaan (20%)** = Rp 30.500 * 20% = **Rp 6.100**

---

### B. Layanan Pesan Antar (Food & Health Delivery)
Harga total yang dibayar pelanggan adalah:

> **Total Pembayaran = Harga Produk + Ongkos Kirim + Biaya Layanan Platform**

*   **Harga Produk:** Harga makanan/obat dari restoran atau apotek (Contoh: Ayam Geprek = Rp 18.000).
*   **Ongkos Kirim (Delivery Fee):** Biaya flat untuk pengantaran kurir (Default: **Rp 8.000**).
*   **Biaya Layanan Platform:** Biaya administrasi sistem (Default: **Rp 2.000**).

*Contoh Perhitungan (Pesan Ayam Geprek):*
*   Total Pembayaran = Rp 18.000 + Rp 8.000 + Rp 2.000 = **Rp 28.000**

#### Pembagian Pendapatan Kurir (Diambil dari Ongkos Kirim + Biaya Layanan = Rp 10.000):
*   **Pendapatan Bersih Driver (80%)** = Rp 10.000 * 80% = **Rp 8.000**
*   **Pendapatan Platform (20%)** = Rp 10.000 * 20% = **Rp 2.000**
*   *Uang produk sebesar Rp 18.000 akan diteruskan ke saldo merchant restoran.*

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
