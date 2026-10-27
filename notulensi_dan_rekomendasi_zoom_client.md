# 📋 Notulensi, Analisis Server, Draf Hukum, dan Logika Sistem (Hasil Meeting Zoom Client)

Dokumen ini memuat rangkuman eksekutif, perbandingan teknis server VPS, draf dokumen hukum Perjanjian Kerja Sama (PKS) Mitra UMKM, logika batas pajak UMKM (PP 55/2022), serta arsitektur pemotongan pinjaman perbankan berdasarkan hasil diskusi Zoom bersama Client.

---

## 1. 🖥️ Analisis & Perbandingan Server VPS (Biznet GIO vs Domainesia) + Email OTP & GCP

### A. Tabel Komparasi VPS: Biznet GIO vs Domainesia
*Spesifikasi Standar Proyek SuperApp / OSRM Engine (2-4 vCPU, 4-8 GB RAM, SSD Enterprise)*

| Parameter / Fitur | **Biznet GIO (NEO Virtual Compute)** | **Domainesia (Cloud VPS ID)** |
| :--- | :--- | :--- |
| **Kategori Server** | Enterprise Cloud Infrastructure | Managed / Unmanaged Cloud VPS |
| **Lokasi Datacenter** | Jakarta, Bogor, Bali (Tier 3) | Jakarta (IIX - OpenIXP) |
| **Bandwidth & Latensi** | Up to 10 Gbps IIX, Latensi < 5ms | Unmetered IIX, Shared Port 1 Gbps |
| **Keandalan / SLA** | **99.9% SLA** (Sangat cocok untuk OSRM & API) | 99.9% SLA |
| **Kapasitas CPU / IOPS** | High IOPS SSD (Dedicated Resources) | NVMe SSD (Burstable / Shared IOPS) |
| **Harga Bulanan (Estimasi)** | **Rp 180.000 – Rp 280.000** / bulan | **Rp 135.000 – Rp 220.000** / bulan |
| **Harga Tahunan (Estimasi)** | **Rp 1.950.000 – Rp 3.000.000** / tahun | **Rp 1.450.000 – Rp 2.300.000** / tahun |
| **Hemat Tahunan** | Diskon komitmen ~10-15% | Diskon tahunan ~15-20% |

> **Rekomendasi Infrastructure:**
> - **Biznet GIO (Pilihan Utama):** Sangat disarankan sebagai *Core Server* SuperApp & Mesin GIS OSRM karena didukung jaringan IIX Biznet yang ultra-cepat, latensi amat rendah (<5ms di Indonesia) untuk pelacakan lokasi GPS realtime, dan stabilitas server dedicated.
> - **Google Cloud Platform (GCP) via Google Pay:** Akun GCP bawaan (dengan billing Google Pay bapaknya) dapat dimanfaatkan untuk *Staging/Testing Environment* atau *Backup Server* di region `asia-southeast2` (Jakarta).

### B. Konfigurasi OTP via Gmail SMTP
- **Metode:** Menggunakan Nodemailer / SMTP Transport dengan **Gmail App Password**.
- **Kapasitas Gratis:** Maksimal 500 email/hari (sangat mencukupi untuk tahap MVP / UAT awal).
- **Skalabilitas:** Saat pengiriman OTP harian melebihi 500 email, sistem dapat dimigrasikan ke transactional email provider seperti SendGrid, Brevo, atau Mailgun.

---

## 2. 📜 Draf Dokumen Hukum & Perjanjian Kerja Sama (PKS) Mitra UMKM

Logo aplikasi sudah tersedia. Berikut draf **Surat Perjanjian Kerja Sama (PKS)** antara Pengelola Platform (BISPIRA/SuperApp) dan Mitra UMKM.

```markdown
PERJANJIAN KERJA SAMA (PKS) MITRA UMKM
Nomor: PKS/BSP/2026/07/001

Pada hari ini, Kamis, tanggal 23 Juli 2026, kami yang bertanda tangan di bawah ini:
1. PIHAK I  : Pengelola Platform SuperApp (BISPIRA), bertindak sebagai PENGELOLA PLATFORM.
2. PIHAK II : [Nama Toko / Resto / Mitra UMKM], bertindak sebagai MITRA USAHA.

PASAL 1: RUANG LINGKUP KERJA SAMA
Pihak I menyediakan platform digital layanan pemesanan dan sistem pembayaran elektronik, sedangkan Pihak II menyediakan produk/jasa yang dijual kepada konsumen melalui platform.

PASAL 2: HAK DAN KEWAJIBAN PERPAJAKAN (PP 55/2022 & PMK 164/2023)
1. Pihak II (Mitra UMKM) bertindak sebagai Wajib Pajak Mandiri.
2. Pihak II bertanggung jawab penuh atas kewajiban perhitungan, pelaporan, dan penyetoran Pajak Penghasilan (PPh Final 0.5%) sesuai ketentuan perundang-undangan perpajakan yang berlaku.
3. Pihak I menyediakan Invoice dan Rekapitulasi Laporan Penjualan (Omzet) bulanan melalui Dashboard Mitra untuk membantu Pihak II menghitung akumulasi peredaran bruto.

PASAL 3: PEMOTONGAN BIAYA LAYANAN & ANGSURAN
1. Pihak I berhak melakukan pemotongan komisi platform dari setiap transaksi yang berhasil diselesaikan.
2. Apabila Pihak II memiliki fasilitas pinjaman dari Lembaga Perbankan Mitra, mekanisme pemotongan kewajiban angsuran akan diproses secara langsung oleh Pihak Bank (Direct Bank Settlement).

PASAL 4: KERAHASIAAN DAN PERLINDUNGAN DATA (UU PDP NO. 27/2022)
Para Pihak sepakat menjaga kerahasiaan data transaksi dan data pribadi pengguna sesuai peraturan undang-undang yang berlaku di Republik Indonesia.
```

---

## 3. ⚖️ Logika Sistem Perpajakan UMKM (Batas Omzet Rp 500 Juta - PP 55/2022)

Sesuai aturan **PP No. 55 Tahun 2022** & **PMK 164/2023**:
- Wajib Pajak Orang Pribadi (WP OP) UMKM dengan peredaran bruto (omzet) akumulasi sampai dengan **Rp 500.000.000,- per tahun pajak** **TIDAK DIKENAKAN PPh Final (0%)**.
- Jika akumulasi omzet per tahun telah **melebihi Rp 500.000.000,-**, maka bagian omzet setelah melebihi batas tersebut dikenakan **PPh Final 0,5%** yang disetor sendiri oleh Mitra.

### Workflow & Fitur "Sambil Berjalan" pada Platform

```
[Transaksi Merchant Berhasil]
               │
               ▼
[Tambahkan Nilai ke Omzet Akumulasi Tahun Ini]
               │
               ▼
   {Akumulasi Omzet >= Rp 400 Juta?}
        │                      │
     (Tidak)                  (Ya)
        │                      │
        ▼                      ▼
[Status: Aman]     [Kirim Warning Alert 80%: Mendekati Limit]
                               │
                               ▼
                   {Akumulasi Omzet > Rp 500 Juta?}
                        │                      │
                     (Tidak)                  (Ya)
                        │                      │
                        ▼                      ▼
                  [Status: Aman]    [Trigger Alert Pajak Aktif (0.5%)]
                                               │
                                               ▼
                                    [Terbitkan Invoice Rekap Bulanan]
                                               │
                                               ▼
                                    [Merchant Setor Mandiri ke DJP]
```

### Formulasi Logika Backend (`Node.js / Express` Pseudocode):
```javascript
function checkMerchantTaxStatus(merchantId, currentTransactionAmount) {
    const currentYear = new Date().getFullYear();
    let merchantStats = getMerchantYearlyOmset(merchantId, currentYear);
    
    // Akumulasi Omzet
    merchantStats.totalOmset += currentTransactionAmount;
    
    const TAX_FREE_LIMIT = 500000000; // Rp 500 Juta
    const WARNING_THRESHOLD = 400000000; // Rp 400 Juta (80%)
    
    if (merchantStats.totalOmset > TAX_FREE_LIMIT) {
        let taxableOmset = merchantStats.totalOmset - TAX_FREE_LIMIT;
        let estimatedTax = taxableOmset * 0.005; // PPh Final 0.5%
        
        return {
            status: "TAXABLE",
            warning: true,
            message: "Omzet tahunan Anda telah melebihi Rp 500.000.000. Anda dikenakan PPh Final 0.5% atas kelebihan omzet.",
            totalOmset: merchantStats.totalOmset,
            taxableOmset: taxableOmset,
            estimatedTaxThisMonth: estimatedTax,
            action: "Invoice Rekap Pajak diterbitkan. Silakan setor mandiri ke DJP Online."
        };
    } else if (merchantStats.totalOmset >= WARNING_THRESHOLD) {
        return {
            status: "WARNING_LIMIT",
            warning: true,
            message: `Akumulasi omzet Anda tahun ini mencapai Rp ${merchantStats.totalOmset.toLocaleString('id-ID')}. Mendekati batas non-pajak Rp 500 Juta.`,
            totalOmset: merchantStats.totalOmset
        };
    }
    
    return { status: "NON_TAXABLE", totalOmset: merchantStats.totalOmset };
}
```

---

## 4. 💳 Arsitektur Pemotongan Pinjaman (Platform vs Bank)

### Keputusan Hasil Zoom: *"Jika Merchant ke Bank aja ya Pak"*

Dalam ekosistem SuperApp, terdapat 2 jenis potensi fasilitas pembiayaan/pinjaman:
1. **Pinjaman Platform (Internal / Fintech P2P):** Potongan angsuran dilakukan langsung oleh saldo wallet platform.
2. **Pinjaman Bank (KUR / Partner Banking):** Potongan angsuran **TIDAK** diproses di saldo platform, melainkan ditangani langsung oleh **Pihak Bank** (*Direct Bank Settlement*).

### Skema Alur Penyelesaian (Direct Bank Settlement Flow):

```
 Merchant / UMKM              Platform SuperApp            Payment Gateway             Partner Bank
        │                             │                           │                         │
        │── Transaksi Penjualan ─────►│                           │                         │
        │                             │── Menerima Webhook ──────►│                         │
        │                             │   (Gross Settlement)      │                         │
        │                             │                           │                         │
        │                             │── Potong Komisi Platform─►│                         │
        │                             │   (misal 5%)              │                         │
        │                             │                           │                         │
        │                             │── Disburse Net Revenue ────────────────────────────►│
        │                             │   ke Rekening Bank Merchant                         │
        │                             │                                                     │
        │                             │                                                     │── Auto-Debit Angsuran
        │                             │                                                     │   Pinjaman Merchant
        │◄────────────────────────────┴─────────────────────────────────────────────────────│
        │                      Sisa Dana Masuk ke Rekening Merchant
```

> **Keuntungan Skema Direct Bank Settlement:**
> 1. **Kepatuhan Regulasi (Compliance):** Platform terhindar dari beban lisensi perbankan/OJK terkait penahanan dan pemotongan dana angsuran pihak ketiga.
> 2. **Transparansi:** Merchant melihat laporan pemotongan pinjaman secara resmi pada rekening koran bank mereka.
> 3. **Kemudahan Operasional:** Platform hanya bertugas mentransfer pencairan omzet bersih (setelah komisi platform) ke rekening bank merchant.

---

## 📊 Matriks Ringkasan & Action Plan

| No | Komponen | Keputusan Zoom | Action Item |
| :---: | :--- | :--- | :--- |
| **1** | **Server VPS** | Biznet GIO (Core) + Gmail OTP | Menyiapkan server 2 vCPU 4GB RAM di Biznet GIO, konfigurasi Nodemailer SMTP Gmail. |
| **2** | **Legal & Logo** | Logo Siap, Draf PKS Disiapkan | Mengintegrasikan draf PKS ke registrasi merchant & halaman Syarat & Ketentuan. |
| **3** | **Pajak UMKM** | Setor Sendiri + Warning >500 Juta | Menambahkan *Yearly Accumulative Tracker* di backend & widget *Tax Alert* di Merchant Dashboard. |
| **4** | **Potongan Bank** | Direct Bank Settlement | Menyiapkan API Payout / Disbursal ke rekening bank merchant tanpa memotong angsuran di platform. |
