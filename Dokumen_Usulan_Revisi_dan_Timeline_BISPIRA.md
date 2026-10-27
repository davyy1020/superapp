# USULAN REVISI KONTRAK & ROADMAP DEVELOPMENT (7 BULAN)
## PLATFORM DIGITAL BISPIRA

**Dokumen Tanggapan & Proposal Teknis Pengembangan Sistem**

---

**INFORMASI DOKUMEN**
* **Kepada Yth.** : Direksi PT. Sitekun Academy Persada (BISPIRA) u.p. Bapak Ibnu Athiyah
* **Dari** : Davy Wahyu Saputra & Muhammad Daffa Athalia (Tim Developer)
* **Tanggal** : 20 Juli 2026
* **Hal** : Pengajuan Revisi Pasal Perjanjian & Rencana Kerja 7 Bulan

---

Dengan hormat,

Sebelumnya kami mengucapkan terima kasih atas kepercayaan PT. Sitekun Academy Persada (BISPIRA) kepada kami untuk berkolaborasi dalam pengembangan platform digital BISPIRA.

Setelah mempelajari dokumen *Draft Perjanjian Kerja Sama Pengembangan Platform Digital*, pada prinsipnya kami siap dan berkomitmen untuk mendukung terwujudnya sistem ini. Namun demikian, demi kelancaran operasional, kejelasan arsitektur sistem, serta perlindungan hak dan kewajiban kedua belah pihak secara adil (*fair*), berikut kami sampaikan daftar klarifikasi teknis, draf usulan revisi pasal, serta rencana kerja 7 bulan (28 minggu).

---

## BAGIAN I: DAFTAR PERTANYAAN KLARIFIKASI TEKNIS

* **Infrastruktur & Layanan Pihak Ketiga (Third-Party Services):**  
  Apakah biaya penyediaan Cloud Server/VPS (khususnya RAM besar untuk Engine OSRM Map & Database), domain, akun Google Play Console ($25), serta saldo OTP (SMS/WhatsApp Gateway) **sepenuhnya menjadi tanggung jawab Pihak Pertama** di luar nilai jasa pengembangan?
* **Aset Konten & Legalitas Operasional:**  
  Apakah Pihak Pertama sudah menyiapkan aset logo, banner promosi awal, serta draf dokumen hukum (Syarat & Ketentuan, Kebijakan Privasi) untuk tiap-tiap modul bisnis?
* **Detail Fitur Perpajakan (PPh Final 0.5%):**  
  Apakah integrasi perpajakan ini sebatas kalkulasi otomatis dan pencetakan laporan bukti potong internal (PDF/Excel), atau wajib terhubung langsung via API ke DJP Online / PJAP?
* **Mekanisme Auto Debet (Driver & Merchant):**  
  Apakah pemotongan cicilan/pinjaman dilakukan melalui pemotongan saldo e-wallet internal platform BISPIRA, atau melibatkan instruksi direct debit rekening bank eksternal?

---

## BAGIAN II: DRAFT PENGAJUAN REVISI PASAL KONTRAK

### **PASAL 1: Ruang Lingkup & Pelaksanaan Bertahap**
> 1. Pihak Kedua bertanggung jawab membangun ekosistem platform digital BISPIRA yang terdiri dari Website Pusat, 5 (lima) Aplikasi Android, Engine Routing OSRM, serta 12 modul operasional.  
> 2. Mengingat kompleksitas dan luasnya skala platform, pengerjaan dilakukan secara **bertahap (*phasing*) selama 7 (tujuh) bulan** sesuai dengan Roadmap Pengerjaan yang terlampir.

### **PASAL 5: Desain & Integrasi API Bank Digital**
> 1. Pihak Kedua bertugas menyiapkan skema arsitektur database, REST API Stub, alur UI/UX, serta form KYC yang siap dihubungkan (*Bank API-Ready*).

### **PASAL 6: Lama Pengerjaan & Ketentuan Denda**
> 1. Jangka waktu pelaksanaan pekerjaan ditetapkan selama **7 (tujuh) bulan** terhitung sejak penandatanganan kontrak dan diterimanya Pembayaran Termin 1 (DP).  
> 2. Ketentuan denda keterlambatan sebesar 0,1% per hari **dikecualikan** apabila keterlambatan disebabkan oleh:  
>    a. Keterlambatan penyerahan aset/data dari Pihak Pertama;  
>    b. Perubahan spesifikasi/fitur di luar kesepakatan awal;  
>    c. Kendala teknis server/layanan pihak ketiga yang ditanggung Pihak Pertama (*Force Majeure* Teknis).

### **PASAL 7: Skema Pembayaran Berbasis Milestone**
> Termin pembayaran disesuaikan dengan penambahan durasi dan milestone pengerjaan (7 bulan):  
> * **Termin 1 (20%):** Dibayarkan setelah Penandatanganan Kontrak & Kick-off Proyek.  
> * **Termin 2 (20%):** Dibayarkan setelah Penyelesaian Website Pusat, Back-End Core & Server OSRM (Bulan ke-1 s.d. Bulan ke-2).  
> * **Termin 3 (20%):** Dibayarkan setelah Penyelesaian Core Mobile Apps (Aplikasi User, Driver, Merchant & Core Food/Sembako) & MVP Testing (Bulan ke-3 s.d. Bulan ke-4).  
> * **Termin 4 (20%):** Dibayarkan setelah Penyelesaian Aplikasi Spesialis (Kesehatan, Ahli, Ads, Ticketing & Kost) (Bulan ke-5 s.d. Bulan ke-6).  
> * **Termin 5 (20%):** Dibayarkan setelah Penyelesaian Modul E-Voting, Tax Engine, UAT, Dokumentasi & Live Launching (Bulan ke-7).
> 
> **Ketentuan Rekening Pembayaran Transfer Termin (PIHAK KEDUA):**
> * **Nama Bank**      : Bank Negara Indonesia (BNI)
> * **Nomor Rekening** : `1888898006`
> * **Atas Nama (A/n)**: Davy Wahyu Saputra


### **PASAL 9: Hak Cipta & Pengalihan Source Code**
> 1. Pihak Kedua melakukan sinkronisasi *source code* secara berkala ke repositori Pihak Pertama untuk keperluan pemantauan (*review*).  
> 2. Pengalihan Hak Cipta dan Penyerahan Akses repositori utama (*Production Access*) secara penuh baru berlaku sah demi hukum **setelah Pihak Pertama melunasi 100% pembayaran proyek (Termin 5)**.

---

## BAGIAN III: ROADMAP & TIMELINE PENGERJAAN (7 BULAN / 28 MINGGU)

Berikut adalah rincian pembagian tahapan kerja selama 28 minggu (7 bulan) untuk memastikan platform dapat berjalan stabil, aman, dan lolos pengujian secara menyeluruh:

| Periode | Fase / Modul | Detail Ruang Lingkup Pekerjaan |
| :--- | :--- | :--- |
| **Bulan 1**<br>*(Minggu 1-4)* | **Infrastruktur & Web Pusat** | • W1: Setup DB PostgreSQL/MySQL, RESTful API Engine Core, & Server OSRM (Map Routing).<br>• W2: Sistem Otentikasi Multi-role (Super Admin, Admin Cabang, Merchant, Driver, User).<br>• W3: Web Pusat (Landing Page, Blog Tutorial, Page Buy License & Layanan).<br>• W4: Dashboard Super Admin & Dashboard Admin Cabang (Kontrol Wilayah & Revenue Sharing). |
| **Bulan 2**<br>*(Minggu 5-8)* | **Core Backend & Finance Engine** | • W5: Arsitektur Multi-App Android (Base Framework, State Management & UI Kit).<br>• W6: Engine Logika Keuangan Pusat (Rumus Harga: Harga Asli + Markup Platform, Bagi Hasil Wilayah).<br>• W7: Engine Auto-Debet Harian (Potongan Pinjaman Bank & Cicilan Atribut Driver).<br>• W8: Integrasi Payment Gateway / E-Wallet Interface & Transaction Logging System. |
| **Bulan 3**<br>*(Minggu 9-12)* | **Core Mobile Apps & MVP Release** | • W9: Aplikasi Android User (Alur Order, Routing OSRM Realtime, Estimasi Harga).<br>• W10: Aplikasi Android Driver (Terima Order, Bid System, Tracking GPS, Saldo Driver).<br>• W11: Aplikasi Android Merchant (Input Produk, Ubah Harga, Saldo Merchant).<br>• W12: Modul Food & Fresh Sembako, Auto Debet Cicilan, & Live Testing MVP Internal. |
| **Bulan 4**<br>*(Minggu 13-16)* | **Apps Spesialis & Commercial Modules** | • W13: Aplikasi Android Mitra Kesehatan & Modul Telemedicine Chat / Booking.<br>• W14: Sub-Modul Homecare & Praktik Mandiri (On-demand Visit Dokter/Nakes).<br>• W15: Aplikasi Android Mitra Ahli & Modul Edukasi / Hiburan.<br>• W16: Modul Mitra Ads (Carousel Fair Rotation & Brand Awareness Rotating Banner). |
| **Bulan 5**<br>*(Minggu 17-20)* | **Ticketing, Property & Donasi** | • W17: Modul Tiket MICE & Wisata (Penjualan & Penerbitan E-Tiket QR Code).<br>• W18: Modul Mitra Kost (Sewa Kamar, Galeri Foto, Peta Location, Management Jatuh Tempo).<br>• W19: Modul Mitra Donasi (Penggalangan Dana Digital Yayasan Sosial).<br>• W20: Testing Integrasi Modul Komersial & Optimalisasi Database Performance. |
| **Bulan 6**<br>*(Minggu 21-24)* | **Community, Tax Engine & Bank Ready** | • W21: Modul Bispira E-Voting (Cabang & Pusat dengan Counter Anti-manipulasi).<br>• W22: Modul Bispira Event Organizer / EO (Manajemen Pendaftaran & Bagan Lomba).<br>• W23: Tax Engine (Kalkulasi PPh Final 0.5% PMK 37/2025, Batas Rp500 Juta, & Bukti Potong).<br>• W24: Persiapan API Bank Digital (Bank-Ready Stub, Embedded KYC, Mock Integration). |
| **Bulan 7**<br>*(Minggu 25-28)* | **UAT, Hardening, Manual & Launching** | • W25: User Acceptance Testing (UAT) Komprehensif di Lingkungan Staging.<br>• W26: Stress Testing, Load Testing OSRM/API Engine, & Security Hardening.<br>• W27: Penyusunan Manual Book, Technical Deployment Guide, & OSRM Configuration Manual.<br>• W28: Upload 5 App ke Play Store Production, Cut-off Server Production, & Pelunasan Termin 5. |

---

Demikian berkas pengajuan ini kami buat untuk menjadi bahan pertimbangan utama Pihak Pertama. Kami percaya dengan kesepakatan yang berimbang, proyek platform BISPIRA dapat terealisasi secara sukses, stabil, dan berdaya saing tinggi.

Atas perhatian dan kerja samanya, kami ucapkan terima kasih.

**Pihak Pertama,**  
PT. Sitekun Academy Persada (BISPIRA)  


*( Ibnu Athiyah )*  
Direktur Utama  

**Pihak Kedua,**  
Tim Developer Independen  


*( Davy W. S. & M. Daffa Athalia )*  
Lead Developer  
