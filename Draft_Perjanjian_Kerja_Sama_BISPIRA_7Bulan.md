# PERJANJIAN KERJA SAMA ANTARA
## PT. Sitekun Academy Persada (BISPIRA) dengan Developer Independen
### Nomor: 01/PKS/SAP-BISPIRA/VII/2026
### Tentang: PENGEMBANGAN PLATFORM DIGITAL (FULLSTACK & MULTI-APPLICATION)

---

Pada hari ini, **Jumat**, tanggal **24 Juli 2026**, bertempat di Brebes, kami yang bertandatangan di bawah ini:

1. **PT. SITEKUN ACADEMY PERSADA**, sebuah perseroan terbatas yang didirikan berdasarkan hukum Negara Republik Indonesia, pemilik sah merek dagang **BISPIRA**, dalam hal ini diwakili oleh Ibnu Athiyah bertindak selaku **Direktur Utama**, selanjutnya disebut sebagai **"PIHAK PERTAMA"**.
2. **A. Davy Wahyu Saputra**, bertindak sebagai profesional/developer independen, pemegang Kartu Tanda Penduduk No: 337405407050003, beralamat di Jl. Genuksari RT 008 RW 003 Genuksari, Genuk, Kota Semarang,  
   **B. Muhammad Daffa Athalia**, bertindak sebagai profesional/developer independen, pemegang Kartu Tanda Penduduk No: 337405407050003, beralamat di Jl. Zebra Mukti Barat No. 99 RT 003 RW 002, Padurungan Kidul, Padurungan, Kota Semarang, selanjutnya disebut sebagai **"PIHAK KEDUA"**.

PARA PIHAK terlebih dahulu menerangkan hal-hal sebagai berikut:
* Bahwa **PIHAK PERTAMA** adalah pemilik platform & aplikasi android bisnis BISPIRA yang memerlukan jasa pengembangan ekosistem digital terintegrasi skala nasional yang berbasis pembagian wilayah (Kabupaten/Kota).
* Bahwa **PIHAK KEDUA** adalah penyedia jasa teknologi informasi independen yang memiliki keahlian, kapasitas, dan peralatan untuk membangun arsitektur teknologi yang dimaksud oleh PIHAK PERTAMA.

Oleh karena itu, PARA PIHAK sepakat untuk mengikatkan diri dalam Perjanjian Kerja Sama ini dengan ketentuan sebagai berikut:

---

### PASAL 1: RUANG LINGKUP PEKERJAAN & TEKNOLOGI
PIHAK KEDUA berkewajiban membangun, menguji, dan menyerahkan arsitektur *fullstack* siap pakai yang terdiri dari:
1. **Satu (1) Unit Web Portal Utama & Sistem Back-End Pusat (Multi-Tier Admin).**
2. **Lima (5) Aplikasi Android Terintegrasi (Format .APK & .AAB) yang didownload secara mandiri melalui Google Play Store:**
   * Aplikasi User (Pelanggan)
   * Aplikasi Driver/Logistik
   * Aplikasi Mitra Kesehatan & Homecare
   * Aplikasi Mitra Ahli, Edukasi & Hiburan
   * Aplikasi Merchant Food & Fresh Sembako
3. **Integrasi OSRM Engine (Mandiri):** Fungsi penuh untuk *Routing*, Estimasi Jarak, Estimasi Tarif (berdasarkan rumus *markup* platform), *Nearby Driver Basic Matrix*, dan kalkulasi *Estimated Time of Arrival* (ETA) secara *real-time* pada aplikasi User dan Driver.
4. **Pengerjaan Bertahap (Phasing):** Mengingat kompleksitas dan luasnya skala platform, pengerjaan dilakukan secara bertahap (*phasing*) selama **7 (tujuh) bulan (28 minggu)** sesuai dengan Roadmap Pengerjaan yang terlampir pada Lampiran B.

---

### PASAL 2: ARSITEKTUR FRONT-END WEBSITE PUSAT
PIHAK KEDUA wajib membangun tampilan muka (*Front-End*) Website Pusat yang profesional, responsif, dan mencakup komponen sebagai berikut:
1. **Halaman Utama (Home Page):** Memuat section tentang kami (*About Us*), kontak kami, Beli lisensi (*Buy Licensee/Franchise*), Layanan Kami, Kontak kami, tombol Registrasi, dan tombol Login.
2. **Halaman Blog & Tutorial:** Sub-bagian khusus yang memuat tutorial interaktif cara menggunakan menu atau produk di platform BISPIRA untuk mengedukasi pengguna dan mitra.
3. **Menu Layanan Integrasi (12 Menu Utama):** Menampilkan ekosistem bisnis yang dapat diakses oleh publik, yaitu: daftar jadi driver, mitra kesehatan & homecare, mitra ahli, edukasi & hiburan, merchant food & fresh sembako, mitra driver, serta tombol unduh aplikasi (*User Download Link*) menuju Google Play Store.

---

### PASAL 3: INPUT DATA MULTI-PLATFORM (WEB & APLIKASI)
1. PARA PIHAK menyepakati bahwa untuk lima (5) Aplikasi Android Non-User (Aplikasi Driver, Mitra Kesehatan & Homecare, Mitra Ahli/Edukasi/Hiburan, dan Merchant Food/Sembako, User), manajemen operasionalnya harus bersifat *omnichannel*.
2. PIHAK KEDUA wajib membangun sistem sinkronisasi data di mana para mitra non-user tersebut dapat melakukan input data produk, harga asli, dokumen administrasi, serta profil usaha melalui dua jalur secara fleksibel:
   * Melalui Aplikasi Android masing-masing mitra; dan/atau
   * Melalui Web Portal (Dashboard Mitra di Website Utama).
3. Seluruh perubahan data dari salah satu jalur (Web atau Aplikasi) harus langsung ter-update secara *real-time* di dalam sistem basis data pusat tanpa jeda atau tumpang tindih (*data collision*).

---

### PASAL 4: MATRIKS FITUR UTAMA & SISTEM REKENING (BACK-END & MULTI-TIER DESKTOP ADMIN)
PIHAK KEDUA wajib memastikan sistem *Back-End* dan arsitektur basis data mendukung logika bisnis dan hak kontrol sebagai berikut:
1. **Logika Keuangan, Skema Harga, dan Rekonsiliasi Pembayaran:**
   * **Rumus Harga Jual Konsumen:** Harga Jual Konsumen = Harga Dasar Penjual (Mitra/Merchant/Driver) + Biaya Markup (%) + Biaya Layanan + Biaya Aplikasi + Kode Unik (3-digit).
   * **Verifikasi Manual Pembayaran:** Pelanggan ditagih sesuai nominal + Kode Unik (3-digit) yang berlaku selama 30 menit. Tim BISPIRA melakukan pencocokan manual pada mutasi bank melalui Aplikasi Desktop Admin tanpa mewajibkan pengunggahan bukti bayar dari pelanggan.
   * **Pencairan Dana Penjual (Batch 17:00 WIB):** Hasil transaksi diakumulasi maksimal 2 hari dan dicairkan ke penjual setiap pukul 17:00 WIB dengan rumus: `Nilai Pencairan Netto Penjual = Harga Dasar Penjual - Biaya Pencairan`.
   * **Biaya Khusus Service & Driver Charge:** Pengaturan biaya Ambulance (Biaya Antar + Biaya Angkut Pasien) dan potongan charge Driver tetap sebesar Rp 500 per transaksi yang dapat disesuaikan di Aplikasi Desktop Admin.
   * **Profit Share Wilayah:** Nilai komisi platform otomatis dibagi antara Super Admin Pusat dan Admin Cabang Wilayah berdasarkan lokasi transaksi.
2. **Modul Logika Iklan Dinamis (Dynamic Ad Engine) - Mitra Ads:**
   PIHAK KEDUA wajib membangun fungsionalitas periklanan pada sistem *Back-End* dan *Front-End* (Website & Aplikasi Android) khusus untuk menu layanan Mitra Ads dengan ketentuan teknis:
   * **Fitur 1: Iklan Brand Awareness (Papan Atas Kategori):** Sistem harus mampu menampilkan logo dan profil bisnis mitra secara bergantian (*rotating system*) di bagian atas halaman sesuai dengan kategori produk masing-masing setiap kali halaman dimuat (*page refresh*) atau dikunjungi oleh User.
   * **Fitur 2: Iklan Banner Produk & Harga (Top 10 Main Banner):** Sistem harus menyediakan slot iklan visual berupa banner produk yang mencantumkan foto produk beserta harganya secara jelas. Banner ini wajib dikunci untuk selalu muncul di papan atas/beranda utama secara bergantian otomatis (*carousel/sliding auto-rotation*) setiap kali User membuka atau mengunjungi platform.
   * **Algoritma Rotasi Adil (Fair Rotation Algorithm):** PIHAK KEDUA wajib memastikan pemunculan iklan bekerja secara berkala namun merata bagi semua mitra yang telah membayar paket iklan aktif, sehingga tidak ada satu merek/produk yang memonopoli slot atas secara terus-menerus.
3. **Matriks Hak Akses & Kontrol Akses via Aplikasi Desktop Admin (Multi-Tier):**
   * **Super Admin Pusat (PIHAK PERTAMA):** Menggunakan Aplikasi Desktop Admin dengan hak mutlak pengelolaan seluruh ekosistem global, menyetujui pendaftaran, verifikasi manual mutasi bank, mengubah skema markup global, biaya layanan, biaya aplikasi, biaya pencairan, charge driver Rp500, biaya ambulance, masa berlaku kode unik (30m), membuat promo/diskon platform, suspensi/pemulihan akun driver, penempatan iklan banner top 10/kategori, serta menyalurkan bagi hasil bersih ke jaringan cabang.
   * **Admin Cabang (Franchisee Wilayah):** Menggunakan Aplikasi Desktop Admin khusus cabang untuk memantau transaksi wilayahnya, menyelenggarakan Bispira EO & E-Voting skala lokal, mengajukan perpanjangan lisensi, menerima bagi hasil dari *markup/admin fee*, serta mengelola dan mendistribusikan stok fisik atribut driver di daerahnya.
   * **Dashboard Mitra Bisnis (Merchant/Mitra/Driver):** Manajemen katalog, input harga asli, riwayat finansial (pemasukan/pengeluaran), pemantauan saldo dompet digital, pencairan dana batch 17.00 WIB, membayar *subscription fee* bulanan, dan modul pemasangan paket iklan mandiri (*Mitra Ads*).

---

### PASAL 5: INTEGRASI PINJAMAN & API BANK DIGITAL TERTUNDA
1. PARA PIHAK memahami dan menyepakati bahwa pada saat Perjanjian ini ditandatangani, PIHAK PERTAMA belum memiliki kemitraan resmi (*partnership*) dengan penyedia Bank Digital.
2. PIHAK KEDUA berkewajiban merancang arsitektur database, skema *flow*, dan komponen visual pada form (*Embedded Form & KYC Interface*) agar siap dipasangkan (*Bank API-Ready*) kapan saja.
3. **Kewajiban Pasca-Peluncuran:** Apabila di kemudian hari (baik selama masa kontrak berjalan atau setelah aplikasi dirilis/serah terima dilakukan) PIHAK PERTAMA telah mendapatkan kemitraan resmi dengan Bank Digital, maka PIHAK KEDUA **wajib secara hukum** melakukan setup, koneksi, pengujian, dan integrasi penuh API Bank Digital tersebut ke dalam website dan kelima (5) aplikasi Android tanpa dikenakan biaya tambahan lagi (*Include dalam nilai kontrak ini*).
4. Integrasi tertunda ini mencakup fungsionalitas: Pembuatan rekening digital via aplikasi, *Know Your Customer* (KYC), transaksi antar-dompet, penarikan dana (*withdrawal*), serta pencairan dan skema potong cicilan kredit modal kerja secara otomatis (*Direct Bank Settlement*).

---

### PASAL 6: JANGKA WAKTU PENGEMBANGAN
1. PIHAK KEDUA wajib menyelesaikan seluruh ruang lingkup pekerjaan dalam Pasal 1 sampai Pasal 3, serta Lampiran A & B dalam kurun waktu **7 (tujuh) bulan** terhitung sejak penandatanganan Perjanjian ini dan pembayaran Termin I dilakukan.
2. Keterlambatan penyelesaian pekerjaan yang bukan diakibatkan oleh keadaan memaksa (*Force Majeure*) akan dikenakan sanksi denda keterlambatan sebesar 0,1% per hari dari nilai total kontrak kepada PIHAK KEDUA, dengan batas maksimal denda sebesar 10%.
3. Ketentuan denda keterlambatan **dikecualikan** apabila keterlambatan disebabkan oleh:
   * a. Keterlambatan penyerahan aset/data dari Pihak Pertama;
   * b. Perubahan spesifikasi/fitur di luar kesepakatan awal;
   * c. Kendala teknis server/layanan pihak ketiga yang ditanggung Pihak Pertama (*Force Majeure Teknis*).

---

### PASAL 7: SKEMA PEMBAYARAN DAN TERMIN (5 KALI BAYAR)
Pembayaran dilakukan oleh PIHAK PERTAMA kepada PIHAK KEDUA menggunakan metode berbasis pencapaian hasil (*Deliverable-Based*) yang dibagi ke dalam 5 (lima) termin berikut:
* **Termin I (DP - 20%):** Dibayarkan setelah penandatanganan kontrak ini sebagai tanda jadi dan modal awal pengembangan arsitektur dasar.
* **Termin II (Progress 40% - Frontend & Core Web):** Dibayarkan setelah PIHAK KEDUA menyelesaikan Front-End Website Pusat, 12 portal menu layanan, Back-End Core API, dan Server OSRM Engine (Bulan ke-1 s.d. Bulan ke-2).
* **Termin III (Progress 60% - Android Apps & OSRM):** Dibayarkan setelah 5 Aplikasi Android (User, Driver, Mitra Sehat, Mitra Ahli, Merchant) selesai dibuat dan fungsi OSRM (ETA, routing, tarif, auto-suspend driver) berfungsi stabil pada lingkungan *staging/testing* (Bulan ke-3 s.d. Bulan ke-4).
* **Termin IV (Progress 80% - Deploy & Integrasi Sistem):** Dibayarkan setelah penyelesaian Aplikasi Spesialis (Kesehatan, Ahli, Ads, Ticketing & Kost) serta integrasi modul komersial terverifikasi (Bulan ke-5 s.d. Bulan ke-6).
* **Termin V (Pelunasan - 20% / Retensi & Dokumentasi):** Dibayarkan setelah pemenuhan dokumen syarat administrasi teknis (Pasal 8), integrasi Tax Engine, Bispira E-Voting, Bank-Ready Stub, UAT, upload Play Store, serta berlalunya masa uji coba operasional (*live test*) tanpa kendala kritikal selama 14 hari kerja (Bulan ke-7).

> **Ketentuan Rekening Pembayaran Transfer Termin (PIHAK KEDUA):**
> * **Nama Bank**      : Bank Negara Indonesia (BNI)
> * **Nomor Rekening** : `1888898006`
> * **Atas Nama (A/n)**: Davy Wahyu Saputra


---

### PASAL 8: SYARAT DOKUMENTASI TEKNIS & SERAH TERIMA
Sebagai prasyarat wajib sebelum dilakukannya pelunasan kontrak (Termin V), PIHAK KEDUA wajib menyerahkan dokumen administrasi teknis yang lengkap dan jelas berupa:
1. **Manual Book Penggunaan Sistem:** Panduan operasional fitur untuk User, Driver, Merchant, Admin Cabang, dan Super Admin Pusat baik via aplikasi maupun via web browser.
2. **Technical Deployment Guide:** Panduan langkah-demi-langkah cara melakukan instalasi, *build*, dan penyebaran (*deploy*) seluruh *source code* aplikasi ke server (*Play Store* dan *Cloud Server*).
3. **OSRM Server Configuration Manual:** Panduan teknis terperinci mengenai cara menjalankan server OSRM, konfigurasi *script* profil kendaraan (`.lua`), cara memasukkan potongan peta wilayah baru (*map clipping*), serta cara memperbarui data peta OpenStreetMap (OSM) secara mandiri oleh tim internal PT. SITEKUN.

---

### PASAL 9: KEPEMILIKAN HAK CIPTA DAN KEKAYAAN INTELEKTUAL
1. Seluruh hasil pekerjaan yang dilakukan oleh PIHAK KEDUA dalam proyek ini, termasuk namun tidak terbatas pada: *source code* (kumpulan kode program), hak cipta aplikasi, desain grafis, arsitektur database, algoritma penyesuaian, dan hak paten industri adalah **Milik Mutlak dan Sepenuhnya dari PIHAK PERTAMA (PT. Sitekun Academy Persada)**.
2. PIHAK KEDUA tidak memiliki hak apa pun untuk menjual kembali, menggandakan, mendistribusikan, atau menggunakan sebagian atau seluruh *source code* platform ini untuk kepentingan pribadi maupun pihak ketiga lainnya.
3. Seluruh berkas kode sumber wajib diserahkan secara transparan melalui repositori kode (seperti GitHub/GitLab milik PIHAK PERTAMA) setiap minggunya selama masa pengembangan. Pengalihan Hak Cipta dan Penyerahan Akses repositori utama (*Production Access*) secara penuh baru berlaku sah demi hukum **setelah PIHAK PERTAMA melunasi 100% pembayaran proyek (Termin V)**.

---

### PASAL 10: PERLINDUNGAN KERAHASIAAN DAN NON-DISCLOSURE (NDA)
1. **Definisi Informasi Rahasia:** Segala bentuk data, algoritma bisnis, skema *markup* harga, kode program (*source code*), struktur basis data, strategi distribusi waralaba wilayah, serta informasi finansial atau operasional yang diberikan oleh PIHAK PERTAMA kepada PIHAK KEDUA atau yang dihasilkan selama pelaksanaan proyek ini merupakan **Informasi Rahasia**.
2. **Kewajiban PIHAK KEDUA:** PIHAK KEDUA dilarang keras, baik sengaja maupun tidak sengaja, membocorkan, membagikan, menyebarluaskan, memperlihatkan, atau memanfaatkan Informasi Rahasia dan algoritma bisnis platform BISPIRA kepada pihak ketiga mana pun dengan alasan apa pun tanpa izin tertulis dari PIHAK PERTAMA.
3. **Dampak Pelanggaran (Sanksi & Ganti Rugi):** Apabila PIHAK KEDUA terbukti melakukan kebocoran informasi atau menyalahgunakan kode sumber BISPIRA, maka PIHAK PERTAMA berhak untuk:
   * a. Menghentikan Perjanjian ini secara sepihak tanpa kewajiban membayar sisa termin kontrak yang belum terbayar.
   * b. Menuntut ganti rugi materiil dan imateriil secara penuh atas kerugian yang dialami perusahaan melalui jalur hukum pidana maupun perdata (berdasarkan UU No. 30 Tahun 2000 tentang Rahasia Dagang).
4. **Masa Berlaku NDA:** Kewajiban menjaga kerahasiaan ini tetap mengikat PIHAK KEDUA untuk jangka waktu selamanya, meskipun Perjanjian Kerja Sama ini telah berakhir, selesai, atau dibatalkan.

---

### PASAL 11: PENYELESAIAN SENGKETA
Apabila terjadi perselisihan atau perbedaan penafsiran dalam pelaksanaan Perjanjian ini, PARA PIHAK sepakat untuk menyelesaikannya secara musyawarah mufakat. Jika dalam waktu 30 (tiga puluh) hari kalender tidak tercapai kesepakatan, maka perselisihan akan diselesaikan melalui Kepaniteraan **Pengadilan Negeri Brebes**.

Demikian Perjanjian ini dibuat dalam rangkap 2 (dua), masing-masing bermeterai cukup dan memiliki kekuatan hukum yang sama, untuk dipegang oleh PIHAK PERTAMA dan PIHAK KEDUA.

---

### PARA PIHAK

| PIHAK PERTAMA | PIHAK KEDUA | PIHAK KEDUA |
| :---: | :---: | :---: |
| **PT. Sitekun Academy Persada** | **Developer Independen** | **Developer Independen** |
| <br><br><br> | <br><br><br> | <br><br><br> |
| **Ibnu Athiyah**<br>Direktur Utama | **Davy Wahyu Saputra**<br>Developer Independen | **Muhammad Daffa Athalia**<br>Developer Independen |

---

### LAMPIRAN A: RINCIAN JELAS 12 MENU LAYANAN PLATFORM BISPIRA
*(Menjadi satu kesatuan utuh dan tidak terpisahkan dari Surat Perjanjian Kerja Sama)*

| No | Nama Layanan | Deskripsi Operasional & Integrasi Sistem (Wajib Dibangun PIHAK KEDUA) |
| :-: | :--- | :--- |
| **1** | **Merchant Food & Fresh Sembako** | Penjualan makanan siap saji dan bahan pokok. Input data via App/Web. Terintegrasi dengan OSRM untuk penentuan lokasi merchant dan jarak pengantaran ke lokasi User. |
| **2** | **Mitra Ahli & Edukasi/Hiburan** | Modul reservasi/pemesanan untuk Konsultan (Pajak, Bisnis), Edukasi (Guru, Dosen, Instruktur), dan Hiburan (Penyanyi, MC, Band) baik untuk layanan daring maupun luring. Input data via App/Web. |
| **3** | **Mitra Kesehatan & Homecare** | 1. **Khusus Dokter:** Fitur chat medis (*telemedicine*) dan sistem booking janji periksa di klinik dokter.<br>2. **Homecare & Praktik Mandiri:** Sistem panggil ke rumah (*on-demand home visit*) atau kunjungan tempat praktik untuk Fisioterapis, Bidan, Caregiver, Psikolog, Psikiater, Spa Terapi, Barbershop, dan Apotek. Input data via App/Web. |
| **4** | **Mitra Driver** | Sistem *ride-hailing* (ojek motor), *delivery* (kurir), logistik (pengiriman barang besar/kargo), dan pemanggilan Ambulance. Wajib terintegrasi ETA *real-time* OSRM. Input administrasi via App/Web. |
| **5** | **Mitra Tiket MICE & Wisata** | Sistem penjualan dan penerbitan e-tiket (*QR Code*) untuk Seminar, Workshop, Pelatihan, Uji Sertifikasi, Pameran, Konferensi, serta Tiket Destinasi Wisata. |
| **6** | **Mitra Kost** | Ekosistem sewa kamar kost bulanan/tahunan lengkap dengan galeri foto, fasilitas, lokasi peta, dan manajemen jatuh tempo pembayaran sewa. |
| **7** | **Mitra Ads (Sistem Iklan Mandiri)** | 1. **Brand Awareness:** Menampilkan profil/brand sesuai kategori produk di papan atas secara bergantian.<br>2. **Banner Produk & Harga:** Menampilkan foto produk + harga di spanduk utama (*top tier banner*) secara bergantian otomatis setiap kali dikunjungi User. |
| **8** | **Mitra Donasi** | Wadah penggalangan dana digital khusus untuk program-program sosial dan kemanusiaan yang dikelola oleh Yayasan resmi yang bermitra. |
| **9** | **Bispira E-Voting Cabang** | Sistem pemungutan suara digital (*voter*) berbasis validasi akun untuk kompetisi/lomba kebudayaan pemuda-pemudi di tingkat Kabupaten/Kota. |
| **10** | **Bispira E-Voting Pusat** | Sistem pemungutan suara skala besar nasional/provinsi untuk lomba kebudayaan, dilengkapi dengan *real-time counter* yang aman dari manipulasi data. |
| **11** | **Bispira EO Cabang** | Modul manajemen pendaftaran, skema bagan pertandingan, dan operasional lomba/kompetisi pendidikan serta olahraga di tingkat Kabupaten/Kota. |
> **\*Dibuatkan form potongan pajak PPh 0,5% jika transaksi bruto > Rp. 500 juta.**

#### **Aturan Pajak Penjual Marketplace**
Ketentuan ini diatur dalam **PMK Nomor 37 Tahun 2025** dan berlaku efektif melalui sistem pemungutan langsung oleh *e-commerce*. Rincian peran dan mekanismenya meliputi:
* **Tarif PPh Pasal 22:** Dipungut sebesar 0,5% dari total omzet (peredaran bruto), tidak termasuk PPN dan PPnBM.
* **Bebas Pajak untuk Omzet Tertentu:** Penjual perorangan dengan omzet di bawah Rp500 juta per tahun tidak dikenai pajak. Anda hanya perlu menyampaikan surat pernyataan kepada pihak *marketplace*.
* **Bukan Pajak Baru:** Kebijakan ini bukan pajak tambahan baru. Pajak ini sama dengan PPh Final UMKM yang sebelumnya dibayar sendiri oleh penjual ke kas negara, namun kini pembayarannya dialihkan secara otomatis via platform.
* **Kredit Pajak:** Potongan PPh yang dilakukan *marketplace* akan menjadi bukti potong yang dapat diklaim sebagai kredit pajak atau bagian pelunasan PPh di akhir tahun.

#### **Peran Pemilik Platform E-commerce**
Sesuai penunjukan resmi DJP, empat platform *marketplace* besar di Indonesia berperan penuh sebagai pemungut pajak. Tugas dan tanggung jawab mereka mencakup:
1. **Pemotongan Otomatis:** Saat transaksi terjadi, sistem platform akan langsung memotong dana dari pembayaran pembeli untuk porsi pajak tersebut.
2. **Penyetoran dan Pelaporan:** Marketplace wajib menyetorkan dana pajak yang terkumpul ke kas negara secara berkala dan melaporkannya ke Direktorat Jenderal Pajak (DJP).
3. **Penerbitan Bukti Potong:** Platform wajib memberikan bukti potong pajak kepada masing-masing pedagang online yang dipotong transaksinya.
4. **Validasi Omzet:** Pihak platform menggunakan rekapitulasi data penjualan di dalam sistem mereka untuk memverifikasi apakah akun penjual telah melewati batas omzet Rp500 juta/tahun atau belum.


