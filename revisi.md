# 📑 DOKUMENTASI REVISI EKOSISTEM BISPIRA SUPERAPP
**Tanggal:** 25 November 2026  
**Status Implementasi:** Selesai 100% (Semua Modul Teruji & Terkompilasi)  
**Tujuan Dokumen:** Catatan resmi hasil penyesuaian bisnis, fitur, dan arsitektur aplikasi dari hasil meeting bersama Bpk. Wahyu & Bpk. Ibnu (BISPIRA).

---

## 📌 Ringkasan Eksekutif Perubahan
Seluruh 11 poin kebutuhan klien dari hasil rapat evaluasi telah berhasil diintegrasikan ke dalam seluruh ekosistem SuperApp BISPIRA:
1. **Aplikasi Pengguna (`bispira_user_app`)**
2. **Aplikasi Mitra Driver (`bispira_driver_app`)**
3. **Aplikasi Mitra Penjual (`bispira_merchant_app`)**
4. **Portal Web Landing Page (`bispira_web_portal`)**
5. **Desktop Superadmin (`bispira_desktop_admin`)**
6. **Paket Hosting Deployment cPanel (`bispira_web_suite_deploy.zip`)**

---

## 🚀 Rincian 11 Poin Revisi & Implementasi

### 1. 🚚 Penambahan Armada: Mobil Box & Bak Terbuka
- **Armada Baru yang Ditambahkan:**
  - **Bispira Mobil Box (🚚):** Kargo boks tertutup kapasitas besar, anti air/cuaca, untuk muatan barang aman, pindahan kantor/rumah tangga, dan suplai logistik toko.
  - **Bispira Bak Terbuka (🛻):** Mobil pickup bak terbuka untuk muatan barang berat, material, perabotan besar, dan ekspedisi lokal.
- **Implementasi pada Kode:**
  - `bispira_driver_app/lib/providers/driver_provider.dart`: Enum armada diperluas menjadi `DriverArmada { motor, mobil, send, mobilBox, bakTerbuka, ambulance }` lengkap dengan tarif dan skema bagi hasil 95% hak driver net.
  - `bispira_driver_app/lib/screens/login_screen.dart` & `driver_home_screen.dart`: Pilihan tile armada dan simulasi order kargo.
  - `bispira_user_app/lib/screens/ride_screen.dart` & `send_screen.dart`: Konsumen dapat langsung memilih Mobil Box dan Bak Terbuka saat memesan jasa antar barang.
  - `bispira_web_portal/index.html`: Form pendaftaran driver baru menyediakan opsi Mobil Box dan Bak Terbuka.

---

### 2. 💊 Merchant Food Ditambahkan Apotek & Farmasi
- **Kebutuhan Klien:** Menghadirkan apotek/obat pada kategori merchant makanan & kebutuhan harian.
- **Implementasi pada Kode:**
  - `bispira_user_app/lib/screens/food_screen.dart`:
    - Penambahan kategori chip **Apotek & Obat 💊**.
    - Mitra apotek terverifikasi (Kimia Farma, Apotek K-24, Apotek Generik Nusantara).
    - Katalog produk obat bebas, vitamin daya tahan tubuh, sirup demam, dan tebus resep dokter siap antar cepat via kurir motor.
  - `bispira_merchant_app/lib/screens/catalog_screen.dart`:
    - Formulir penambahan produk kluster `B4. Apotek & Farmasi` dengan input No. Registrasi BPOM, golongan obat (Bebas Hijau / Terbatas Biru / Keras Merah / Herbal), dan penanda *Wajib Resep Dokter*.

---

### 3. 👨‍⚕️ Rumah Medis & Homecare Lengkap Tenaga Kesehatan
- **Kebutuhan Klien:** Klasifikasi lengkap tenaga kesehatan yang dapat melayani panggilan ke rumah (*home visit*).
- **Implementasi pada Kode (`bispira_user_app/lib/screens/health_screen.dart`):**
  - 👩‍⚕️ **Perawat Homecare:** Perawatan lansia, ganti perban/luka pasca operasi, pasang infus/kateter di rumah.
  - 🤱 **Bidan:** Konsultasi kehamilan, senam hamil, imunisasi balita, dan pijat laktasi.
  - 🧠 **Psikolog & Konselor:** Konseling kesehatan mental, penanganan trauma, konseling keluarga dan anak.
  - 💆 **Terapis / Fisioterapi:** Terapi pemulihan pasca stroke, fisioterapi lansia, terapi cedera olahraga/otot.
  - 🩺 **Dokter Umum & Spesialis:** Kunjungan dokter ke rumah dan telekonsultasi.
  - 🧪 **Laboratorium Medis:** Pengambilan sampel darah/lab langsung ke rumah pasien.

---

### 4. 🎙️ Rumah Expert (Konsultan Ahli & Profesional)
- **Status:** Struktur konsultan profesional & expert tetap dipertahankan sesuai kebutuhan klien (Konsultan Hukum, Akuntansi/Pajak, Arsitek, MC/Event Host, Guru Les Privat, Sound Engineer, dan Teknisi Ahli).

---

### 5. 🎟️ Rumah Baru: "Bispira Tiket Mess dan Wisata"
- **Kebutuhan Klien:** Wadah pemesanan tiket terpadu untuk mess penginapan, destinasi wisata, serta kegiatan edukatif.
- **Implementasi pada Kode (`bispira_user_app/lib/screens/tickets_screen.dart`):**
  - 🏨 **Tiket Mess / Penginapan:** Mess Pemda, Wisma Atlet, Homestay Pariwisata.
  - 🏖️ **Tiket Wisata:** Destinasi wisata alam, waterpark, cagar budaya, dan museum.
  - 🎤 **Tiket Seminar & Talkshow:** Acara formal inspiratif bersertifikat.
  - 🏋️ **Latihan & Pelatihan:** Pelatihan kompetensi, pelatihan kejuruan, dan bootcamp kerja.
  - 📚 **Workshop & Kursus:** Kursus memasak, bahasa asing, digital marketing, coding.
  - 📝 **Ujian & Sertifikasi:** Tryout UTBK, sertifikasi BNSP, tes TOEFL/IELTS.
  - ⚽ **Tiket Pertandingan Olahraga:** Turnamen futsal, basket, sepakbola daerah.

---

### 6. 🏢 Rumah Baru: "Bispira Sewa Properti & Busana"
- **Kebutuhan Klien:** Mengakomodasi sewa kos, kontrakan, baju wisuda, baju pesta, dan kostum adat/karakter.
- **Implementasi pada Kode (`bispira_user_app/lib/screens/kost_screen.dart`):**
  - Judul modul diperbarui menjadi: **BISPIRA SEWA PROPERTI & BUSANA**.
  - Pilihan kategori filter dan unit aktif:
    1. 🛏️ **Sewa Kos:** Kamar executive kost harian/bulanan (AC, WiFi, kamar mandi dalam).
    2. 🏡 **Sewa Kontrakan:** Rumah tinggal keluarga 2 lantai, paviliun mandiri.
    3. 👗 **Sewa Baju Event:** Gaun pesta mewah, kebaya modern, jas tuxedo formal.
    4. 🎓 **Sewa Baju Wisuda / Toga:** Paket toga lengkap (jubah, topi, kalung, tabung) jenjang S1/S2/S3.
    5. 🎭 **Sewa Kostum:** Baju adat nusantara 38 provinsi, kostum karnaval, cosplay pahlawan & superhero.

---

### 7. 📢 Rumah Baru: "Bispira Iklan" (Jualan Iklan Banner & Logo)
- **Kebutuhan Klien:** Wadah monetisasi iklan promosi mandiri bagi para pelaku usaha mitra Bispira.
- **Implementasi pada Kode (`bispira_user_app/lib/screens/home_screen.dart`):**
  - **Modal Pemesanan Slot Iklan Mitra:**
    * 🖼️ **Iklan Banner Top Hero Carousel:** Banner raksasa di bagian paling atas Beranda pengguna yang bergeser otomatis (auto-slide) setiap 3 detik. Pilihan durasi: 7 hari (Rp 150.000) dan 30 hari (Rp 500.000).
    * 🏷️ **Iklan Banner Kategori Promo:** Banner penawaran diskon per vertikal layanan (Rp 100.000 / 7 hari).
    * 👑 **Iklan Logo Sponsor Mitra:** Penempatan logo usaha dengan badge khusus *"Verified Sponsor"* di etalase beranda (Rp 250.000 / 30 hari).

---

### 8. 🤝 Rumah Baru: "Bispira Donasi" (Khusus Yayasan Resmi)
- **Kebutuhan Klien:** Penyaluran donasi terfokus pada yayasan legal non-profit.
- **Implementasi pada Kode (`bispira_user_app/lib/screens/donation_screen.dart`):**
  - Judul modul diperbarui menjadi: **BISPIRA DONASI YAYASAN**.
  - Mitra yayasan terakreditasi:
    * 🍲 **Yayasan Panti Asuhan & Anak Yatim:** Program makan gratis bergizi (donasi mikro Rp 1.000 & Rp 2.000 tanpa potongan admin).
    * 🤝 **Yayasan Sosial Kemanusiaan:** Santunan panti jompo dan pemberdayaan tunawisma.
    * 🕌 **Yayasan ZISWAF & Masjid:** Renovasi sarana ibadah di pelosok dan air bersih.
    * 🎓 **Yayasan Pendidikan & Pesantren:** Beasiswa anak berprestasi di pelosok.
    * 🌋 **Tanggap Darurat Bencana:** Bantuan logistik dapur umum dan selimut bencana alam.

---

### 9. 🏆 & 🗳️ 4 Rumah Baru Event & E-Voting
- **Kebutuhan Klien:** Pemisahan kluster Event dan E-Voting ke tingkat Pusat (Nasional) dan Daerah (Kota/Kabupaten) dengan 4 pilar lomba:
  1. **Lomba Pendidikan** (Olimpiade, Cerdas Cermat, Hackathon, Riset Ilmiah)
  2. **Lomba Kesenian** (Tari Kreasi Tradisional, Paduan Suara, Musik Akustik)
  3. **Lomba Kebudayaan** (Pawai Budaya Adat 38 Provinsi, Busana Daerah, Sastra Puisi)
  4. **Lomba Olahraga** (Turnamen Futsal, Silat Kejurnas/Kejurda, Basket 3x3)
- **Implementasi pada Kode:**
  - `bispira_user_app/lib/screens/eo_screen.dart`:
    * Segmented switch: **👑 Bispira Event Pusat (Nasional)** vs **📍 Bispira Event Daerah (Lokal)**.
    * Filter chips 4 pilar lengkap dengan bagan bracket turnamen dan formulir pendaftaran kontingen.
  - `bispira_user_app/lib/screens/evoting_screen.dart`:
    * Segmented switch: **👑 Bispira E-Voting Pusat** vs **📍 Bispira E-Voting Daerah**.
    * Filter 4 pilar pemilihan kandidat/atlet/duta seni terfavorit dengan audit log terverifikasi teknologi kriptografi.

---

### 10. 🏪 Sistem CRUD Penjual / Merchant Sesuai Bidang Usaha
- **Kebutuhan Klien:** Form penambahan produk di Kasir Merchant harus spesifik mengikuti jenis tokonya (tidak disamaratakan).
- **Implementasi pada Kode (`bispira_merchant_app/lib/screens/catalog_screen.dart`):**
  - Dropdown kluster usaha:
    1. `B1. Food & Resto` -> Satuan porsi/box, waktu estimasi masak (prep time), varian rasa.
    2. `B4. Apotek & Farmasi` -> Nomor BPOM/izin edar, golongan obat (bebas/keras/vitamin), checklist wajib resep dokter.
    3. `B3. Sembako Mart` -> Satuan distribusi (Kg, Liter, Dus, Karung), berat bersih.
    4. `D1. Sewa Properti & Busana` -> Tipe unit (kos/kontrakan/baju wisuda/kostum), fasilitas sewa, satuan sewa (bulan/hari/event).
    5. `C1. Tiket Mess dan Wisata` -> Kategori tiket, lokasi acara, kuota kursi/tiket.
    6. `E1. Bispira Iklan` -> Pilihan slot iklan (carousel/logo), durasi tayang.
    7. `E2. Donasi Yayasan` -> Kategori yayasan pengelola.
    8. `E3. Event & E-Voting` -> 4 Pilar lomba.

---

### 11. 🌐 Landing Page Pendaftaran Mitra & Superadmin Approval + WhatsApp 1-Arah (Gratis)
- **Alur Bisnis Sesuai Permintaan Klien:**
  ```
  1. Calon Penjual / Driver / Cabang mengisi formulir di Web Landing Page
       ↓
  2. Data otomatis terkirim dan tersimpan di Antrean Superadmin
       ↓
  3. Admin Bispira memeriksa berkas & mengklik "ACC & Terbitkan Akun"
       ↓
  4. Akun aktif otomatis diterbitkan (ID Mitra resmi & PIN awal 123456)
       ↓
  5. Admin mengklik tombol "Kirim Konfirmasi WA (Gratis)"
       ↓
  6. WhatsApp langsung terbuka dengan format template pesan resmi SATU ARAH
  (Calon mitra tahu akun sudah siap pakai dan tidak bisa membalas/menelpon pesan tersebut)
  ```
- **Implementasi pada Kode:**
  - `bispira_web_portal/index.html` & `app.js`:
    * Formulir pendaftaran online untuk **Mitra Driver** (dengan pilihan Mobil Box & Bak Terbuka), **Mitra Penjual / Merchant** (Kuliner, Apotek, Sembako, Sewa Properti/Busana, Tiket, Iklan), dan **Lisensi Cabang**.
    * Penyimpanan otomatis pendaftar ke `localStorage` (`bispira_pending_registrations`).
  - `bispira_desktop_admin/lib/views/tabs/mitra_approval_tab.dart`:
    * Tab baru di menu samping: **"Persetujuan Mitra & Kirim WA (Gratis)"**.
    * Tabel verifikasi pendaftar dengan filter per peran dan kolom pencarian.
    * Tombol **"ACC & Terbitkan Akun"**: Otomatis menghasilkan ID Mitra unik (contoh: `MRC-APT-4091`, `DRV-BOX-1022`, `CAB-SMG-001`) dan PIN default `123456`.
    * Tombol **"Kirim Konfirmasi WA (Gratis)"**:
      Menggunakan protokol tautan resmi `https://wa.me/{nomor}?text={template}` via `url_launcher`. **100% GRATIS tanpa biaya vendor API SMS/WA pihak ketiga.**
    * **Template Pesan WhatsApp Resmi (Satu Arah):**
      ```text
      *BISPIRA SUPERAPP INDONESIA - KONFIRMASI RESMI AKUN MITRA*
      --------------------------------------------------
      Halo Yth. Bpk/Ibu [Nama Pemilik] ([Nama Usaha/Driver]),

      Selamat! Pendaftaran kemitraan Anda telah DISETUJUI (ACC) oleh Superadmin BISPIRA Pusat. Akun resmi Anda kini telah AKTIF.

      *Rincian Akun Resmi Anda:*
      • Peran: [Penjual / Driver / Cabang]
      • Bidang / Armada: [Kategori / Armada]
      • Wilayah: [Kota / Wilayah]
      • ID Mitra Resmi: [ID Mitra]
      • PIN Keamanan Kasir: 123456
      • Status: AKTIF & TERVERIFIKASI

      *Tautan Akses Aplikasi:*
      https://agungtrijayaabadi.com/superapp/

      *PENTING (NOTIFIKASI RESMI SATU ARAH):*
      Pesan ini dikirimkan secara otomatis oleh sistem Superadmin BISPIRA Pusat. Nomor ini TIDAK DAPAT menerima balasan pesan chat maupun panggilan telepon.
      Silakan segera login ke aplikasi BISPIRA dan ubah PIN kasir demi keamanan privasi akun Anda.

      Terima kasih telah bergabung bersama Ekosistem BISPIRA Indonesia! 🚀
      --------------------------------------------------
      ```

---

## 📁 Struktur File Hasil Build & Rilis Siap Pakai

| No | Nama Paket File | Ukuran | Lokasi File | Keterangan |
|:---:|:---|:---:|:---|:---|
| 1 | **bispira_web_suite_deploy.zip** | 77.0 MB | [bispira_web_suite_deploy.zip](file:///c:/Users/Davy/Documents/superapp/bispira_web_suite_deploy.zip) | Paket zip seluruh aplikasi web (User, Merchant, Driver, Superadmin, Health, Expert, Portal) dengan `<base href>` dinamis siap upload ke cPanel. |
| 2 | **Bispira_Superadmin_Windows_Setup.exe** | 11.3 MB | [Bispira_Superadmin_Windows_Setup.exe](file:///c:/Users/Davy/Documents/superapp/BISPIRA_BINARIES_RELEASE/Bispira_Superadmin_Windows_Setup.exe) | Installer Windows Superadmin desktop tunggal dengan tab approval mitra & WA gratis. |
| 3 | **Bispira_Desktop_Admin_Windows.zip** | 12.9 MB | [Bispira_Desktop_Admin_Windows.zip](file:///c:/Users/Davy/Documents/superapp/BISPIRA_BINARIES_RELEASE/Bispira_Desktop_Admin_Windows.zip) | Versi portable tanpa install untuk laptop/PC Windows. |
| 4 | **Bispira_User_App.apk** | 52.8 MB | `BISPIRA_BINARIES_RELEASE/Bispira_User_App.apk` | Aplikasi Android Pengguna. |
| 5 | **Bispira_Driver_App.apk** | 50.7 MB | `BISPIRA_BINARIES_RELEASE/Bispira_Driver_App.apk` | Aplikasi Android Driver. |
| 6 | **Bispira_Merchant_App.apk** | 48.3 MB | `BISPIRA_BINARIES_RELEASE/Bispira_Merchant_App.apk` | Aplikasi Android Kasir Toko. |

---

## 🛠️ Status Sinkronisasi Git
Seluruh source code telah tersimpan dan ter-push ke GitHub:
- **Repository Remote:** `https://github.com/davyy1020/superapp.git`
- **Branch:** `main`
- **Commit Terakhir:** `373612d`
- **Pesan Commit:** `feat: complete business ecosystem update from client meet (armada box/bak, apotek, tiket mess, sewa properti/busana, iklan, donasi yayasan, event/evoting pusat & daerah, landing registration, superadmin approval & free 1-way WA notification)`
