# Go-Super - Interactive Simulation Suite & GIS OSRM Engine Showcase

Go-Super adalah prototipe ekosistem aplikasi super (Super App) interaktif yang dirancang khusus untuk memvisualisasikan cara kerja **OSRM (Open Source Routing Machine)** GIS Engine, rumus perhitungan tarif perjalanan dinamis, skema bagi hasil otomatis (Revenue Split), serta visualisasi multi-portal secara realtime.

Proyek ini dibuat untuk kebutuhan demonstrasi klien professional, memetakan kompetensi teknis dari pemrosesan data peta OpenStreetMap (OSM) hingga kustomisasi rute jalan di Indonesia menggunakan skrip LUA.

---

## 🚀 Fitur Utama & Portal Simulasi

Aplikasi ini menyajikan **6 Portal Simulasi Utama** ditambah **1 Modul Kalkulator Interaktif**:

1. **Website Admin Portal (Dashboard Sentral):**
   * Peta utama berbasis LeafletJS yang memonitor pergerakan driver secara langsung.
   * Panel metrik finansial, pendapatan platform, dan total order.
   * Terminal visual simulator build data OSRM (extract, partition, customize).
   * Konfigurasi parameter tarif (Tarif/KM, Min Fare, Biaya Layanan, Komisi).
   
2. **Aplikasi User (Mobile View):**
   * Antarmuka pemesanan layanan transportasi (Go-Ride/Go-Car), makanan (Go-Food), dan kesehatan (Go-Health).
   * Sistem e-wallet realtime yang terintegrasi dengan saldo pembayaran tarif.
   
3. **Aplikasi Driver (Mobile View):**
   * Sistem penerimaan order (Accept/Decline).
   * Simulasi GPS palsu (*Anti-Fake GPS Fraud*) untuk demonstrasi sistem keamanan.
   * Penarikan pendapatan bersih (withdraw wallet) yang terdistribusi otomatis dari bagi hasil perjalanan.

4. **Merchant Food Portal (Senopati Resto):**
   * Dashboard manajemen pesanan makanan.
   * Tombol penyelesaian pesanan dan pelaporan grafik omzet penjualan merchant.

5. **Merchant Health Portal (Apotek Kimia Farma):**
   * Dashboard pemesanan obat-obatan dengan integrasi logistik kurir pengiriman.

6. **OSRM GIS Engine Playground:**
   * Compiler pipeline simulator untuk mendemonstrasikan commands `osrm-extract`, `osrm-partition`, dan `osrm-customize`.
   * Pilihan profil rute LUA (Car vs Bicycle vs Foot).
   * Uji coba API Distance Matrix (`/table`) untuk pencarian rute multi-destinasi.

7. **Edukasi & Kalkulator Tarif Interaktif:**
   * Kalkulator simulasi pembagian hasil pendapatan realtime.
   * Bar visualisasi pembagian proporsi pendapatan (Driver vs Platform vs Merchant).
   * Lembar pemetaan kompetensi teknis developer GIS OSRM.

---

## 🛠️ Tech Stack & Integrasi
* **Frontend UI:** HTML5 & Vanilla CSS (Desain Premium Dark-mode & Glassmorphism).
* **Logical Engine:** Vanilla Javascript (State Management, Event-driven Simulation, Route Interpolation).
* **Mapping GIS:** [LeafletJS Map Library](https://leafletjs.com/) terintegrasi dengan ubin peta [CartoDB Dark Matter](https://carto.com/).
* **Routing API:** Open Source Routing Machine (OSRM) Router API untuk rute jalan nyata berdasarkan data jalan Jakarta.

---

## 💻 Cara Menjalankan Aplikasi Secara Lokal

Aplikasi ini berjalan sepenuhnya di sisi klien (*client-side*), tanpa memerlukan database eksternal untuk demonstrasi instan yang aman dan stabil.

1. Clone repositori ini:
   ```bash
   git clone https://github.com/davyy1020/superapp.git
   ```
2. Buka direktori proyek:
   ```bash
   cd superapp
   ```
3. Buka file `index.html` langsung di browser favorit Anda atau jalankan local development server (seperti VS Code Live Server).
