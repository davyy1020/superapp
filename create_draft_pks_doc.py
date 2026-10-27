import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import OxmlElement
from docx.oxml.ns import qn

def set_cell_margins(cell, top=80, bottom=80, left=140, right=140):
    tcPr = cell._element.get_or_add_tcPr()
    tcMar = OxmlElement('w:tcMar')
    for m, val in [('top', top), ('bottom', bottom), ('left', left), ('right', right)]:
        node = OxmlElement(f'w:{m}')
        node.set(qn('w:w'), str(val))
        node.set(qn('w:type'), 'dxa')
        tcMar.append(node)
    tcPr.append(tcMar)

def set_cell_bg(cell, hex_color):
    tcPr = cell._element.get_or_add_tcPr()
    shd = OxmlElement('w:shd')
    shd.set(qn('w:val'), 'clear')
    shd.set(qn('w:color'), 'auto')
    shd.set(qn('w:fill'), hex_color)
    tcPr.append(shd)

def set_table_borders(table, color_hex='94A3B8'):
    tblPr = table._element.xpath('w:tblPr')
    if tblPr:
        borders = OxmlElement('w:tblBorders')
        for border_name in ['top', 'left', 'bottom', 'right', 'insideH', 'insideV']:
            border = OxmlElement(f'w:{border_name}')
            border.set(qn('w:val'), 'single')
            border.set(qn('w:sz'), '4') # 0.5 pt
            border.set(qn('w:space'), '0')
            border.set(qn('w:color'), color_hex)
            borders.append(border)
        tblPr[0].append(borders)

def make_row_cant_split(row):
    trPr = row._element.get_or_add_trPr()
    trPr.append(OxmlElement('w:cantSplit'))

def make_row_header(row):
    trPr = row._element.get_or_add_trPr()
    trPr.append(OxmlElement('w:tblHeader'))

doc = docx.Document()

# Margins 1 inch (2.54 cm)
for section in doc.sections:
    section.top_margin = Inches(1)
    section.bottom_margin = Inches(1)
    section.left_margin = Inches(1)
    section.right_margin = Inches(1)

# Base Font Arial 10.5 pt
style = doc.styles['Normal']
font = style.font
font.name = 'Arial'
font.size = Pt(10.5)
font.color.rgb = RGBColor(0x1E, 0x29, 0x3B)

def add_p(text_runs, align=WD_ALIGN_PARAGRAPH.LEFT, space_before=0, space_after=4, left_indent=0.0, keep_with_next=False):
    p = doc.add_paragraph()
    p.alignment = align
    p.paragraph_format.line_spacing = 1.15
    p.paragraph_format.space_before = Pt(space_before)
    p.paragraph_format.space_after = Pt(space_after)
    if left_indent > 0:
        p.paragraph_format.left_indent = Inches(left_indent)
    if keep_with_next:
        p.paragraph_format.keep_with_next = True
    
    for item in text_runs:
        if isinstance(item, tuple):
            txt = item[0]
            fmt = item[1] if len(item) > 1 else ''
            is_bold = 'b' in fmt
            is_italic = 'i' in fmt
            r = p.add_run(txt)
            if is_bold: r.bold = True
            if is_italic: r.italic = True
        else:
            p.add_run(item)
    return p

def add_pasal_header(pasal_num, pasal_title=None):
    add_p([(pasal_num, 'b')], align=WD_ALIGN_PARAGRAPH.CENTER, space_before=14, space_after=2 if pasal_title else 6, keep_with_next=True)
    if pasal_title:
        add_p([(pasal_title, 'b')], align=WD_ALIGN_PARAGRAPH.CENTER, space_after=6, keep_with_next=True)

# HEADER TITLE
add_p([("PERJANJIAN KERJA SAMA ANTARA", 'b')], align=WD_ALIGN_PARAGRAPH.CENTER, space_after=2, keep_with_next=True)
add_p([("PT. Sitekun Academy Persada (BISPIRA) dengan Developer Independen", 'b')], align=WD_ALIGN_PARAGRAPH.CENTER, space_after=2, keep_with_next=True)
add_p([("Nomor: 01/PKS/SAP-BISPIRA/VII/2026", 'b')], align=WD_ALIGN_PARAGRAPH.CENTER, space_after=2, keep_with_next=True)
add_p([("Tentang", 'b')], align=WD_ALIGN_PARAGRAPH.CENTER, space_after=2, keep_with_next=True)
add_p([("PENGEMBANGAN PLATFORM\nDIGITAL (FULLSTACK & MULTI-APPLICATION)", 'b')], align=WD_ALIGN_PARAGRAPH.CENTER, space_after=14, keep_with_next=True)

# OPENING
add_p([
    ("Pada hari ini, "), ("Jumat", 'b'), (", tanggal "), ("24 Juli 2026", 'b'), (", bertempat di Brebes, kami yang bertandatangan di bawah ini:")
], space_after=6)


add_p([
    ("1. ", 'b'), ("PT. SITEKUN ACADEMY PERSADA", 'b'), (", sebuah perseroan terbatas yang didirikan berdasarkan hukum Negara Republik Indonesia, pemilik sah merek dagang "), ("BISPIRA", 'b'), (", dalam hal ini diwakili oleh Ibnu Athiyah bertindak selaku "), ("Direktur Utama", 'b'), (", selanjutnya disebut sebagai "), ('"PIHAK PERTAMA"', 'b'), (".")
], space_after=6, left_indent=0.25)

add_p([
    ("2. ", 'b'), ("A. Davy Wahyu Saputra", 'b'), (", bertindak sebagai profesional/developer independen, pemegang Kartu Tanda Penduduk No: 337405407050003, beralamat di Jl. Genuksari RT 008 RW 003 Genuksari, Genuk, Kota Semarang,\n"),
    ("    B. Muhammad Daffa Athalia", 'b'), (", bertindak sebagai profesional/developer independen, pemegang Kartu Tanda Penduduk No: 337405407050003, beralamat di Jl. Zebra Mukti Barat No. 99 RT 003 RW 002, Padurungan Kidul, Padurungan, Kota Semarang, selanjutnya disebut sebagai "), ('"PIHAK KEDUA"', 'b'), (".")
], space_after=8, left_indent=0.25)

# RECITALS
add_p([("PARA PIHAK terlebih dahulu menerangkan hal-hal sebagai berikut:")], space_after=4)
add_p([("•  Bahwa "), ("PIHAK PERTAMA", 'b'), (" adalah pemilik platform & aplikasi android bisnis BISPIRA yang memerlukan jasa pengembangan ekosistem digital terintegrasi skala nasional yang berbasis pembagian wilayah (Kabupaten/Kota).")], space_after=4, left_indent=0.25)
add_p([("•  Bahwa "), ("PIHAK KEDUA", 'b'), (" adalah penyedia jasa teknologi informasi independen yang memiliki keahlian, kapasitas, dan peralatan untuk membangun arsitektur teknologi yang dimaksud oleh PIHAK PERTAMA.")], space_after=8, left_indent=0.25)
add_p([("Oleh karena itu, PARA PIHAK sepakat untuk mengikatkan diri dalam Perjanjian Kerja Sama ini dengan ketentuan sebagai berikut:")], space_after=12)

# PASAL 1
add_pasal_header("PASAL 1: RUANG LINGKUP PEKERJAAN & TEKNOLOGI")
add_p([("PIHAK KEDUA berkewajiban membangun, menguji, dan menyerahkan arsitektur "), ("fullstack", 'i'), (" siap pakai yang terdiri dari:")], space_after=4)
add_p([("1. ", 'b'), ("Satu (1) Unit Web Portal Utama & Sistem Back-End Pusat (Multi-Tier Admin).", 'b')], space_after=4, left_indent=0.25)
add_p([("2. ", 'b'), ("Lima (5) Aplikasi Android Terintegrasi (Format .APK & .AAB) yang didownload secara mandiri melalui Google Play Store:", 'b')], space_after=2, left_indent=0.25)

sub_apps = [
    "Aplikasi User (Pelanggan)",
    "Aplikasi Driver/Logistik",
    "Aplikasi Mitra Kesehatan & Homecare",
    "Aplikasi Mitra Ahli, Edukasi & Hiburan",
    "Aplikasi Merchant Food & Fresh Sembako"
]
for app in sub_apps:
    add_p([(f"o  {app}")], space_after=2, left_indent=0.5)

add_p([
    ("3. ", 'b'), ("Integrasi OSRM Engine (Mandiri): ", 'b'), ("Fungsi penuh untuk "), ("Routing", 'i'), (", Estimasi Jarak, Estimasi Tarif (berdasarkan rumus "), ("markup", 'i'), (" platform), "), ("Nearby Driver Basic Matrix", 'i'), (", dan kalkulasi "), ("Estimated Time of Arrival (ETA)", 'i'), (" secara "), ("real-time", 'i'), (" pada aplikasi User dan Driver.")
], space_after=4, left_indent=0.25)

add_p([
    ("4. ", 'b'), ("Pengerjaan dilakukan secara bertahap ("), ("phasing", 'i'), (") selama "), ("7 (tujuh) bulan (28 minggu)", 'b'), (" sesuai dengan Roadmap Pengerjaan yang terlampir pada Lampiran B.")
], space_after=8, left_indent=0.25)

# PASAL 2
add_pasal_header("PASAL 2", "ARSITEKTUR FRONT-END WEBSITE PUSAT")
add_p([("PIHAK KEDUA wajib membangun tampilan muka ("), ("Front-End", 'i'), (") Website Pusat yang profesional, responsif, dan mencakup komponen sebagai berikut:")], space_after=4)
add_p([("1. ", 'b'), ("Halaman Utama (Home Page): ", 'b'), ("Memuat section tentang kami ("), ("About Us", 'i'), ("), kontak kami, Beli lisensi ("), ("Buy Licensee/Franchise", 'i'), ("), Layanan Kami, Kontak kami, tombol Registrasi, dan tombol Login.")], space_after=4, left_indent=0.25)
add_p([("2. ", 'b'), ("Halaman Blog & Tutorial: ", 'b'), ("Sub-bagian khusus yang memuat tutorial interaktif cara menggunakan menu atau produk di platform BISPIRA untuk mengedukasi pengguna dan mitra.")], space_after=4, left_indent=0.25)
add_p([("3. ", 'b'), ("Menu Layanan Integrasi (12 Menu Utama): ", 'b'), ("Menampilkan ekosistem bisnis yang dapat diakses oleh publik, yaitu: daftar jadi driver, mitra kesehatan & homecare, mitra ahli, edukasi & hiburan, merchant food & fresh sembako, mitra driver, serta tombol unduh aplikasi ("), ("User Download Link", 'i'), (") menuju Google Play Store.")], space_after=8, left_indent=0.25)

# PASAL 3
add_pasal_header("PASAL 3", "INPUT DATA MULTI-PLATFORM (WEB & APLIKASI)")
add_p([("1. ", 'b'), ("PARA PIHAK menyepakati bahwa untuk "), ("lima (5) Aplikasi Android Non-User", 'b'), (" (Aplikasi Driver, Mitra Kesehatan & Homecare, Mitra Ahli/Edukasi/Hiburan, dan Merchant Food/Sembako, User), manajemen operasionalnya harus bersifat "), ("omnichannel", 'i'), (".")], space_after=4, left_indent=0.25)
add_p([("2. ", 'b'), ("PIHAK KEDUA wajib membangun sistem sinkronisasi data di mana para mitra non-user tersebut dapat melakukan input data produk, harga asli, dokumen administrasi, serta profil usaha "), ("melalui dua jalur secara fleksibel:", 'b')], space_after=2, left_indent=0.25)
add_p([("o  Melalui Aplikasi Android masing-masing mitra; "), ("dan/atau", 'b')], space_after=2, left_indent=0.5)
add_p([("o  Melalui Web Portal (Dashboard Mitra di Website Utama).")], space_after=4, left_indent=0.5)
add_p([("3. ", 'b'), ("Seluruh perubahan data dari salah satu jalur (Web atau Aplikasi) harus langsung ter-update secara "), ("real-time", 'i'), (" di dalam sistem basis data pusat tanpa jeda atau tumpang tindih ("), ("data collision", 'i'), (".")], space_after=8, left_indent=0.25)

# PASAL 4
add_pasal_header("PASAL 4", "MATRIKS FITUR UTAMA & SISTEM REKENING (BACK-END & MULTI-TIER)")
add_p([("PIHAK KEDUA wajib memastikan sistem "), ("Back-End", 'i'), (" dan arsitektur basis data mendukung logika bisnis dan hak kontrol sebagai berikut:")], space_after=4)

add_p([("1. Logika Keuangan & Skema Harga Platform:", 'b')], space_after=2, left_indent=0.25)
add_p([("•  ", 'b'), ("Rumus Harga: ", 'b'), ("Harga Resmi Platform (ke User) = Harga Asli Penjual (Mitra/Merchant/Driver) + Biaya Markup Platform.")], space_after=2, left_indent=0.5)
add_p([("•  ", 'b'), ("Pembagian Hasil: ", 'b'), ("Penjual menerima 100% Harga Asli di Dompet Digital mereka. Nilai "), ("Markup", 'i'), (" sepenuhnya masuk ke rekening PIHAK PERTAMA (Pusat) dan dibagi secara otomatis ke Admin Cabang sesuai wilayah transaksi.")], space_after=2, left_indent=0.5)
add_p([("•  ", 'b'), ("Sistem Auto-Debet Harian:", 'b')], space_after=2, left_indent=0.5)
add_p([("o  Pemotongan otomatis 1 hari 1 kali pada transaksi ke-2 bagi Merchant/Mitra/Driver yang memiliki cicilan pinjaman Bank Digital (Direct Bank Settlement).")], space_after=2, left_indent=0.75)
add_p([("o  Pemotongan otomatis 1 hari 1 kali pada transaksi ke-1 khusus bagi Driver yang menyicil Atribut Driver ke Super Admin Pusat.")], space_after=4, left_indent=0.75)

add_p([("2. Modul Logika Iklan Dinamis (Dynamic Ad Engine) - Mitra Ads:", 'b')], space_after=2, left_indent=0.25)
add_p([("PIHAK KEDUA wajib membangun fungsionalitas periklanan pada sistem "), ("Back-End", 'i'), (" dan "), ("Front-End", 'i'), (" (Website & Aplikasi Android) khusus untuk menu layanan Mitra Ads dengan ketentuan teknis:")], space_after=2, left_indent=0.25)
add_p([("•  ", 'b'), ("Fitur 1: Iklan Brand Awareness (Papan Atas Kategori): ", 'b'), ("Sistem harus mampu menampilkan logo dan profil bisnis mitra secara bergantian ("), ("rotating system", 'i'), (") di bagian atas halaman sesuai dengan kategori produk masing-masing setiap kali halaman dimuat ("), ("page refresh", 'i'), (") atau dikunjungi oleh User.")], space_after=2, left_indent=0.5)
add_p([("•  ", 'b'), ("Fitur 2: Iklan Banner Produk & Harga (Top 10 Main Banner): ", 'b'), ("Sistem harus menyediakan slot iklan visual berupa banner produk yang mencantumkan foto produk beserta harganya secara jelas. Banner ini wajib dikunci untuk selalu muncul di papan atas/beranda utama secara bergantian otomatis ("), ("carousel/sliding auto-rotation", 'i'), (") setiap kali User membuka atau mengunjungi platform.")], space_after=2, left_indent=0.5)
add_p([("•  ", 'b'), ("Algoritma Rotasi Adil (Fair Rotation Algorithm): ", 'b'), ("PIHAK KEDUA wajib memastikan pemunculan iklan bekerja secara berkala namun merata bagi semua mitra yang telah membayar paket iklan aktif, sehingga tidak ada satu merek/produk yang memonopoli slot atas secara terus-menerus.")], space_after=4, left_indent=0.5)

add_p([("3. Matriks Hak Akses & Kontrol Akses (Multi-Tier):", 'b')], space_after=2, left_indent=0.25)
add_p([("•  ", 'b'), ("Super Admin Pusat (PIHAK PERTAMA): ", 'b'), ("Hak mutlak pengelolaan seluruh ekosistem global, menyetujui seluruh pendaftaran ("), ("approve register", 'i'), ("), mengubah skema "), ("markup", 'i'), (" harga global, membuat promo/diskon platform (dengan memotong jatah markup hingga 100% dari harga resmi yang sudah dinaikkan 100% oleh platform), suspensi/pemulihan akun driver, penempatan iklan banner top 10/kategori, serta menyalurkan bagi hasil bersih ("), ("netto/bruto", 'i'), (") ke jaringan cabang.")], space_after=2, left_indent=0.5)
add_p([("•  ", 'b'), ("Admin Cabang (Franchisee Wilayah): ", 'b'), ("Eksklusivitas 1 Cabang untuk 1 Kabupaten/Kota. Memiliki dashboard khusus untuk memantau transaksi wilayahnya, menyelenggarakan Bispira EO & E-Voting skala lokal, mengajukan perpanjangan lisensi, menerima bagi hasil dari "), ("markup/admin fee", 'i'), (", serta mengelola dan mendistribusikan stok fisik atribut driver di daerahnya.")], space_after=2, left_indent=0.5)
add_p([("•  ", 'b'), ("Dashboard Mitra Bisnis (Merchant/Mitra/Driver): ", 'b'), ("Manajemen katalog, input harga asli, riwayat finansial (pemasukan/pengeluaran), pemantauan saldo dompet digital, membayar "), ("subscription fee", 'i'), (" bulanan, dan modul pemasangan serta pembayaran paket iklan mandiri ("), ("Mitra Ads", 'i'), (").")], space_after=8, left_indent=0.5)

# PASAL 5
add_pasal_header("PASAL 5", "INTEGRASI PINJAMAN & API BANK DIGITAL TERTUNDA")
add_p([("1. ", 'b'), ("PARA PIHAK memahami dan menyepakati bahwa pada saat Perjanjian ini ditandatangani, PIHAK PERTAMA "), ("belum memiliki", 'b'), (" kemitraan resmi ("), ("partnership", 'i'), (") dengan penyedia Bank Digital.")], space_after=4, left_indent=0.25)
add_p([("2. ", 'b'), ("PIHAK KEDUA berkewajiban merancang arsitektur database, skema "), ("flow", 'i'), (", dan komponen visual pada form ("), ("Embedded Form & KYC Interface", 'i'), (") agar siap dipasangkan ("), ("API-Ready", 'i'), (") kapan saja.")], space_after=4, left_indent=0.25)
add_p([("3. ", 'b'), ("Kewajiban Pasca-Peluncuran: ", 'b'), ("Apabila di kemudian hari (baik selama masa kontrak berjalan atau setelah aplikasi dirilis/serah terima dilakukan) PIHAK PERTAMA telah mendapatkan kemitraan resmi dengan Bank Digital, maka PIHAK KEDUA "), ("wajib secara hukum", 'b'), (" melakukan setup, koneksi, pengujian, dan integrasi penuh API Bank Digital tersebut ke dalam website dan kelima (5) aplikasi Android tanpa dikenakan biaya tambahan lagi ("), ("Include dalam nilai kontrak ini", 'i'), (").")], space_after=4, left_indent=0.25)
add_p([("4. ", 'b'), ("Integrasi tertunda ini mencakup fungsionalitas: Pembuatan rekening digital via aplikasi, "), ("Know Your Customer (KYC)", 'i'), (", transaksi antar-dompet, penarikan dana ("), ("withdrawal", 'i'), ("), serta pencairan dan skema potong cicilan kredit modal kerja secara otomatis (Direct Bank Settlement).")], space_after=8, left_indent=0.25)

# PASAL 6
add_pasal_header("PASAL 6", "JANGKA WAKTU PENGEMBANGAN")
add_p([("1. ", 'b'), ("PIHAK KEDUA wajib menyelesaikan seluruh ruang lingkup pekerjaan dalam Pasal 1 sampai Pasal 3, serta Lampiran A & B dalam kurun waktu minimal "), ("1 (satu) bulan", 'b'), (" hingga maksimal "), ("7 (tujuh) bulan", 'b'), (" terhitung sejak penandatanganan Perjanjian ini dan pembayaran Termin I dilakukan.")], space_after=4, left_indent=0.25)
add_p([("2. ", 'b'), ("Keterlambatan penyelesaian pekerjaan yang bukan diakibatkan oleh keadaan memaksa ("), ("Force Majeure", 'i'), (") akan dikenakan sanksi denda keterlambatan sebesar 0,1% per hari dari nilai total kontrak kepada PIHAK KEDUA, dengan batas maksimal denda sebesar 10%.")], space_after=4, left_indent=0.25)
add_p([("3. ", 'b'), ("Ketentuan denda keterlambatan dikecualikan apabila keterlambatan disebabkan oleh:")], space_after=2, left_indent=0.25)
add_p([("a. Keterlambatan penyerahan aset/data dari Pihak Pertama;")], space_after=2, left_indent=0.5)
add_p([("b. Perubahan spesifikasi/fitur di luar kesepakatan awal;")], space_after=2, left_indent=0.5)
add_p([("c. Kendala teknis server/layanan pihak ketiga yang ditanggung Pihak Pertama (Force Majeure Teknis).")], space_after=8, left_indent=0.5)

# PASAL 7
add_pasal_header("PASAL 7", "SKEMA PEMBAYARAN DAN TERMIN (5 KALI BAYAR)")
add_p([("Pembayaran dilakukan oleh PIHAK PERTAMA kepada PIHAK KEDUA menggunakan metode berbasis pencapaian hasil ("), ("Deliverable-Based", 'i'), (") yang dibagi ke dalam 5 (lima) termin berikut:")], space_after=4)
add_p([("Termin I (DP - 20%): ", 'b'), ("Dibayarkan setelah penandatanganan kontrak ini sebagai tanda jadi dan modal awal pengembangan arsitektur dasar.")], space_after=4, left_indent=0.25)
add_p([("Termin II (Progress 40% - Frontend & Core Web): ", 'b'), ("Dibayarkan setelah PIHAK KEDUA menyelesaikan Front-End Website Pusat, 12 portal menu layanan, Back-End Core API, dan Server OSRM Engine (Bulan ke-1 s.d. Bulan ke-2).")], space_after=4, left_indent=0.25)
add_p([("Termin III (Progress 60% - Android Apps & OSRM): ", 'b'), ("Dibayarkan setelah 5 Aplikasi Android (User, Driver, Mitra Sehat, Mitra Ahli, Merchant) selesai dibuat dan fungsi OSRM (ETA, routing, tarif, auto-suspend driver) berfungsi stabil pada lingkungan staging/testing (Bulan ke-3 s.d. Bulan ke-4).")], space_after=4, left_indent=0.25)
add_p([("Termin IV (Progress 80% - Deploy & Integrasi Sistem): ", 'b'), ("Dibayarkan setelah penyelesaian Aplikasi Spesialis (Kesehatan, Ahli, Ads, Ticketing & Kost) serta integrasi modul komersial terverifikasi (Bulan ke-5 s.d. Bulan ke-6).")], space_after=4, left_indent=0.25)
add_p([("Termin V (Pelunasan - 20% / Retensi & Dokumentasi): ", 'b'), ("Dibayarkan setelah pemenuhan dokumen syarat administrasi teknis (Pasal 8), integrasi Tax Engine, Bispira E-Voting, Bank-Ready Stub, UAT, upload Play Store, serta berlalunya masa uji coba operasional (live test) tanpa kendala kritikal selama 14 hari kerja (Bulan ke-7).")], space_after=6, left_indent=0.25)

# ELEGANT BANK ACCOUNT CALLOUT BOX UNDER PASAL 7
add_p([("Ketentuan Rekening Pembayaran Transfer Termin (PIHAK KEDUA):", 'b')], space_before=4, space_after=4, left_indent=0.25, keep_with_next=True)

bank_tbl = doc.add_table(rows=3, cols=2)
bank_tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
set_table_borders(bank_tbl, 'CBD5E1')

bank_data = [
    ("Nama Bank", ": Bank Negara Indonesia (BNI)"),
    ("Nomor Rekening", ": 1888898006"),
    ("Atas Nama (A/n)", ": Davy Wahyu Saputra")
]

for idx, (label, val) in enumerate(bank_data):
    row = bank_tbl.rows[idx]
    make_row_cant_split(row)
    c_lbl, c_val = row.cells[0], row.cells[1]
    c_lbl.width = Inches(1.8)
    c_val.width = Inches(4.2)
    set_cell_bg(c_lbl, "F8FAFC")
    set_cell_bg(c_val, "F8FAFC")
    set_cell_margins(c_lbl, top=60, bottom=60, left=100, right=100)
    set_cell_margins(c_val, top=60, bottom=60, left=100, right=100)
    
    p0 = c_lbl.paragraphs[0]
    r0 = p0.add_run(label)
    r0.bold = True
    r0.font.size = Pt(9.5)
    
    p1 = c_val.paragraphs[0]
    r1 = p1.add_run(val)
    r1.bold = True
    r1.font.size = Pt(9.5)

doc.add_paragraph().paragraph_format.space_after = Pt(8)

# PASAL 8
add_pasal_header("PASAL 8", "SYARAT DOKUMENTASI TEKNIS & SERAH TERIMA")
add_p([("Sebagai prasyarat wajib sebelum dilakukannya pelunasan kontrak (Termin V), PIHAK KEDUA wajib menyerahkan dokumen administrasi teknis yang lengkap dan jelas berupa:")], space_after=4)
add_p([("1. ", 'b'), ("Manual Book Penggunaan Sistem: ", 'b'), ("Panduan operasional fitur untuk User, Driver, Merchant, Admin Cabang, dan Super Admin Pusat baik via aplikasi maupun via web browser.")], space_after=4, left_indent=0.25)
add_p([("2. ", 'b'), ("Technical Deployment Guide: ", 'b'), ("Panduan langkah-demi-langkah cara melakukan instalasi, "), ("build", 'i'), (", dan penyebaran ("), ("deploy", 'i'), (") seluruh "), ("source code", 'i'), (" aplikasi ke server ("), ("Play Store", 'i'), (" dan "), ("Cloud Server", 'i'), (").")], space_after=4, left_indent=0.25)
add_p([("3. ", 'b'), ("OSRM Server Configuration Manual: ", 'b'), ("Panduan teknis terperinci mengenai cara menjalankan server OSRM, konfigurasi "), ("script", 'i'), (" profil kendaraan (.lua), cara memasukkan potongan peta wilayah baru ("), ("map clipping", 'i'), ("), serta cara memperbarui data peta OpenStreetMap (OSM) secara mandiri oleh tim internal PT. SITEKUN.")], space_after=8, left_indent=0.25)

# PASAL 9
add_pasal_header("PASAL 9", "KEPEMILIKAN HAK CIPTA DAN KEKAYAAN INTELEKTUAL")
add_p([("1. ", 'b'), ("Seluruh hasil pekerjaan yang dilakukan oleh PIHAK KEDUA dalam proyek ini, termasuk namun tidak terbatas pada: "), ("source code", 'i'), (" (kumpulan kode program), hak cipta aplikasi, desain grafis, arsitektur database, algoritma penyesuaian, dan hak paten industri adalah "), ("Milik Mutlak dan Sepenuhnya dari PIHAK PERTAMA (PT. Sitekun Academy Persada)", 'b'), (".")], space_after=4, left_indent=0.25)
add_p([("2. ", 'b'), ("PIHAK KEDUA tidak memiliki hak apa pun untuk menjual kembali, menggandakan, mendistribusikan, atau menggunakan sebagian atau seluruh "), ("source code", 'i'), (" platform ini untuk kepentingan pribadi maupun pihak ketiga lainnya.")], space_after=4, left_indent=0.25)
add_p([("3. ", 'b'), ("Seluruh berkas kode sumber wajib diserahkan secara transparan melalui repositori kode (seperti GitHub/GitLab milik PIHAK PERTAMA) setiap minggunya selama masa pengembangan. Pengalihan Hak Cipta dan Penyerahan Akses repositori utama ("), ("Production Access", 'i'), (") secara penuh baru berlaku sah demi hukum "), ("setelah PIHAK PERTAMA melunasi 100% pembayaran proyek (Termin V)", 'b'), (".")], space_after=8, left_indent=0.25)

# PASAL 10
add_pasal_header("PASAL 10", "PERLINDUNGAN KERAHASIAAN DAN NON-DISCLOSURE (NDA)")
add_p([("1. ", 'b'), ("Definisi Informasi Rahasia: ", 'b'), ("Segala bentuk data, algoritma bisnis, skema "), ("markup", 'i'), (" harga, kode program ("), ("source code", 'i'), ("), struktur basis data, strategi distribusi waralaba wilayah, serta informasi finansial atau operasional yang diberikan oleh PIHAK PERTAMA kepada PIHAK KEDUA atau yang dihasilkan selama pelaksanaan proyek ini merupakan "), ("Informasi Rahasia", 'b'), (".")], space_after=4, left_indent=0.25)
add_p([("2. ", 'b'), ("Kewajiban PIHAK KEDUA: ", 'b'), ("PIHAK KEDUA dilarang keras, baik sengaja maupun tidak sengaja, membocorkan, membagikan, menyebarluaskan, memperlihatkan, atau memanfaatkan Informasi Rahasia dan algoritma bisnis platform BISPIRA kepada pihak ketiga mana pun dengan alasan apa pun tanpa izin tertulis dari PIHAK PERTAMA.")], space_after=4, left_indent=0.25)
add_p([("3. ", 'b'), ("Dampak Pelanggaran (Sanksi & Ganti Rugi): ", 'b'), ("Apabila PIHAK KEDUA terbukti melakukan kebocoran informasi atau menyalahgunakan kode sumber BISPIRA, maka PIHAK PERTAMA berhak untuk:")], space_after=2, left_indent=0.25)
add_p([("a. Menghentikan Perjanjian ini secara sepihak tanpa kewajiban membayar sisa termin kontrak yang belum terbayar.")], space_after=2, left_indent=0.5)
add_p([("b. Menuntut ganti rugi materiil dan imateriil secara penuh atas kerugian yang dialami perusahaan melalui jalur hukum pidana maupun perdata (berdasarkan UU No. 30 Tahun 2000 tentang Rahasia Dagang).")], space_after=4, left_indent=0.5)
add_p([("4. ", 'b'), ("Masa Berlaku NDA: ", 'b'), ("Kewajiban menjaga kerahasiaan ini tetap mengikat PIHAK KEDUA untuk jangka waktu selamanya, meskipun Perjanjian Kerja Sama ini telah berakhir, selesai, atau dibatalkan.")], space_after=8, left_indent=0.25)

# PASAL 11
add_pasal_header("PASAL 11: PENYELESAIAN SENGKETA")
add_p([("Apabila terjadi perselisihan atau perbedaan penafsiran dalam pelaksanaan Perjanjian ini, PARA PIHAK sepakat untuk menyelesaikannya secara musyawarah mufakat. Jika dalam waktu 30 (tiga puluh) hari kalender tidak tercapai kesepakatan, maka perselisihan akan diselesaikan melalui Kepaniteraan Pengadilan Negeri Brebes.")], space_after=4)
add_p([("Demikian Perjanjian ini dibuat dalam rangkap 2 (dua), masing-masing bermeterai cukup dan memiliki kekuatan hukum yang sama, untuk dipegang oleh PIHAK PERTAMA dan PIHAK KEDUA.")], space_after=12)

# SIGNATURE TABLE WITH EMBEDDED STAMP & SIGNATURE IMAGE FOR PIHAK PERTAMA
add_p([("PARA PIHAK,", 'b')], align=WD_ALIGN_PARAGRAPH.CENTER, space_after=14, keep_with_next=True)

sign_table = doc.add_table(rows=1, cols=3)
sign_table.alignment = WD_TABLE_ALIGNMENT.CENTER
make_row_cant_split(sign_table.rows[0])

c0 = sign_table.cell(0, 0)
c1 = sign_table.cell(0, 1)
c2 = sign_table.cell(0, 2)

c0.width = Inches(2.3)
c1.width = Inches(2.1)
c2.width = Inches(2.1)

# PIHAK PERTAMA (with meterai + signature image)
p0 = c0.paragraphs[0]
p0.paragraph_format.line_spacing = 1.15
r0_hdr = p0.add_run("PIHAK PERTAMA\nPT. Sitekun Academy Persada\n\n")
r0_hdr.bold = True
r0_hdr.font.size = Pt(10)

# Add Meterai + Signature image
import os
img_path = r"c:\Users\Davy\Documents\superapp\ttd_meterai_complete.png"
if os.path.exists(img_path):
    p0_img = p0.add_run()
    p0_img.add_picture(img_path, width=Inches(1.9))
    p0.add_run("\n\n")
else:
    p0.add_run("\n\n\n\n")

r0_ftr = p0.add_run("Ibnu Athiyah\nDirektur Utama")
r0_ftr.bold = True
r0_ftr.font.size = Pt(10)

# PIHAK KEDUA - Davy
p1 = c1.paragraphs[0]
p1.paragraph_format.line_spacing = 1.15
r1_hdr = p1.add_run("PIHAK KEDUA\nDeveloper Independen\n\n\n\n\n\n")
r1_hdr.bold = True
r1_hdr.font.size = Pt(10)
r1_ftr = p1.add_run("Davy Wahyu Saputra\nDeveloper Independen")
r1_ftr.bold = True
r1_ftr.font.size = Pt(10)

# PIHAK KEDUA - Daffa
p2 = c2.paragraphs[0]
p2.paragraph_format.line_spacing = 1.15
r2_hdr = p2.add_run("PIHAK KEDUA\nDeveloper Independen\n\n\n\n\n\n")
r2_hdr.bold = True
r2_hdr.font.size = Pt(10)
r2_ftr = p2.add_run("Muhammad Daffa Athalia\nDeveloper Independen")
r2_ftr.bold = True
r2_ftr.font.size = Pt(10)

doc.add_paragraph().paragraph_format.space_after = Pt(20)

# LAMPIRAN A
add_p([("LAMPIRAN A: RINCIAN JELAS 12 MENU LAYANAN PLATFORM BISPIRA", 'b')], align=WD_ALIGN_PARAGRAPH.CENTER, space_after=2, keep_with_next=True)
add_p([("(Menjadi satu kesatuan utuh dan tidak terpisahkan dari Surat Perjanjian Kerja Sama)", 'i')], align=WD_ALIGN_PARAGRAPH.CENTER, space_after=12, keep_with_next=True)

tbl_a = doc.add_table(rows=1, cols=3)
tbl_a.alignment = WD_TABLE_ALIGNMENT.CENTER
set_table_borders(tbl_a)
make_row_header(tbl_a.rows[0])
make_row_cant_split(tbl_a.rows[0])

hdr_a = tbl_a.rows[0].cells
hdr_a[0].width = Inches(0.5)
hdr_a[1].width = Inches(2.0)
hdr_a[2].width = Inches(4.0)

headers_a = ["No", "Nama Layanan", "Deskripsi Operasional & Integrasi Sistem\n(Wajib Dibangun PIHAK KEDUA)"]
for i, htext in enumerate(headers_a):
    set_cell_bg(hdr_a[i], "F1F5F9")
    set_cell_margins(hdr_a[i], top=80, bottom=80, left=100, right=100)
    p = hdr_a[i].paragraphs[0]
    p.alignment = WD_ALIGN_PARAGRAPH.CENTER if i == 0 else WD_ALIGN_PARAGRAPH.LEFT
    r = p.add_run(htext)
    r.bold = True
    r.font.size = Pt(9.5)

services = [
    ("1", "Merchant Food & Fresh Sembako", "Penjualan makanan siap saji dan bahan pokok. Input data via App/Web. Terintegrasi dengan OSRM untuk penentuan lokasi merchant dan jarak pengantaran ke lokasi User."),
    ("2", "Mitra Ahli & Edukasi/Hiburan", "Modul reservasi/pemesanan untuk Konsultan (Pajak, Bisnis), Edukasi (Guru, Dosen, Instruktur), dan Hiburan (Penyanyi, MC, Band) baik untuk layanan daring maupun luring. Input data via App/Web."),
    ("3", "Mitra Kesehatan & Homecare", "1. Khusus Dokter: Fitur chat medis (telemedicine) dan sistem booking janji periksa di klinik dokter.\n2. Homecare & Praktik Mandiri: Sistem panggil ke rumah (on-demand home visit) atau kunjungan tempat praktik untuk Fisioterapis, Bidan, Caregiver, Psikolog, Psikiater, Spa Terapi, Barbershop, dan Apotek. Input data via App/Web."),
    ("4", "Mitra Driver", "Sistem ride-hailing (ojek motor), delivery (kurir), logistik (pengiriman barang besar/kargo), dan pemanggilan Ambulance. Wajib terintegrasi ETA real-time OSRM. Input administrasi via App/Web."),
    ("5", "Mitra Tiket MICE & Wisata", "Sistem penjualan dan penerbitan e-tiket (QR Code) untuk Seminar, Workshop, Pelatihan, Uji Sertifikasi, Pameran, Konferensi, serta Tiket Destinasi Wisata."),
    ("6", "Mitra Kost", "Ekosistem sewa kamar kost bulanan/tahunan lengkap dengan galeri foto, fasilitas, lokasi peta, dan manajemen jatuh tempo pembayaran sewa."),
    ("7", "Mitra Ads (Sistem Iklan Mandiri)", "1. Brand Awareness: Menampilkan profil/brand sesuai kategori produk di papan atas secara bergantian.\n2. Banner Produk & Harga: Menampilkan foto produk + harga di spanduk utama (top tier banner) secara bergantian otomatis setiap kali dikunjungi User."),
    ("8", "Mitra Donasi", "Wadah penggalangan dana digital khusus untuk program-program sosial dan kemanusiaan yang dikelola oleh Yayasan resmi yang bermitra."),
    ("9", "Bispira E-Voting Cabang", "Sistem pemungutan suara digital (voter) berbasis validasi akun untuk kompetisi/lomba kebudayaan pemuda-pemudi di tingkat Kabupaten/Kota."),
    ("10", "Bispira E-Voting Pusat", "Sistem pemungutan suara skala besar nasional/provinsi untuk lomba kebudayaan, dilengkapi dengan real-time counter yang aman dari manipulasi data."),
    ("11", "Bispira EO Cabang", "Modul manajemen pendaftaran, skema bagan pertandingan, dan operasional lomba/kompetisi pendidikan serta olahraga di tingkat Kabupaten/Kota."),
    ("12", "Bispira EO Pusat", "Modul manajemen dan pendaftaran turnamen/lomba berskala besar untuk tingkat Provinsi hingga tingkat Nasional.")
]

for no_s, name_s, desc_s in services:
    r_row = tbl_a.add_row()
    make_row_cant_split(r_row)
    r_cells = r_row.cells
    r_cells[0].width = Inches(0.5)
    r_cells[1].width = Inches(2.0)
    r_cells[2].width = Inches(4.0)
    
    for cell in r_cells:
        set_cell_margins(cell, top=60, bottom=60, left=80, right=80)
    
    p0 = r_cells[0].paragraphs[0]
    p0.alignment = WD_ALIGN_PARAGRAPH.CENTER
    p0.add_run(no_s).font.size = Pt(9.5)
    
    p1 = r_cells[1].paragraphs[0]
    r1 = p1.add_run(name_s)
    r1.bold = True
    r1.font.size = Pt(9.5)
    
    p2 = r_cells[2].paragraphs[0]
    p2.add_run(desc_s).font.size = Pt(9.5)

doc.add_paragraph().paragraph_format.space_after = Pt(12)

# TAX & E-COMMERCE
p_tax = doc.add_paragraph()
p_tax.paragraph_format.line_spacing = 1.15
p_tax.paragraph_format.space_after = Pt(10)

r_tr = p_tax.add_run("*Dibuatkan form potongan pajak PPh 0,5% jika transaksi bruto > Rp. 500 juta.\n")
r_tr.font.color.rgb = RGBColor(0xDC, 0x26, 0x26)
r_tr.bold = True

r_th = p_tax.add_run("Aturan Pajak Penjual Marketplace\n")
r_th.bold = True
p_tax.add_run("Ketentuan ini diatur dalam PMK Nomor 37 Tahun 2025 dan berlaku efektif melalui sistem pemungutan langsung oleh e-commerce. Rincian peran dan mekanismenya meliputi:\n"
          "•  Tarif PPh Pasal 22: Dipungut sebesar 0,5% dari total omzet (peredaran bruto), tidak termasuk PPN dan PPnBM.\n"
          "•  Bebas Pajak untuk Omzet Tertentu: Penjual perorangan dengan omzet di bawah Rp500 juta per tahun tidak dikenai pajak. Anda hanya perlu menyampaikan surat pernyataan kepada pihak marketplace.\n"
          "•  Bukan Pajak Baru: Kebijakan ini bukan pajak tambahan baru. Pajak ini sama dengan PPh Final UMKM yang sebelumnya dibayar sendiri oleh penjual ke kas negara, namun kini pembayarannya dialihkan secara otomatis via platform.\n"
          "•  Kredit Pajak: Potongan PPh yang dilakukan marketplace akan menjadi bukti potong yang dapat diklaim sebagai kredit pajak atau bagian pelunasan PPh di akhir tahun.\n\n")

r_eh = p_tax.add_run("Peran Pemilik Platform E-commerce\n")
r_eh.bold = True
p_tax.add_run("Sesuai penunjukan resmi DJP, empat platform marketplace besar di Indonesia berperan penuh sebagai pemungut pajak. Tugas dan tanggung jawab mereka mencakup:\n"
          "1. Pemotongan Otomatis: Saat transaksi terjadi, sistem platform akan langsung memotong dana dari pembayaran pembeli untuk porsi pajak tersebut.\n"
          "2. Penyetoran dan Pelaporan: Marketplace wajib menyetorkan dana pajak yang terkumpul ke kas negara secara berkala dan melaporkannya ke Direktorat Jenderal Pajak (DJP).\n"
          "3. Penerbitan Bukti Potong: Platform wajib memberikan bukti potong pajak kepada masing-masing pedagang online yang dipotong transaksinya.\n"
          "4. Validasi Omzet: Pihak platform menggunakan rekapitulasi data penjualan di dalam sistem mereka untuk memverifikasi apakah akun penjual telah melewati batas omzet Rp500 juta/tahun atau belum.")

doc.add_paragraph().paragraph_format.space_after = Pt(14)



# End of Document


output_filename1 = r"c:\Users\Davy\Documents\superapp\Draft_Perjanjian_Kerja_Sama_BISPIRA.docx"
output_filename2 = r"c:\Users\Davy\Documents\superapp\Draft_Perjanjian_Kerja_Sama_BISPIRA_7Bulan.docx"

import os
os.system("taskkill /f /im WINWORD.EXE >nul 2>&1")

try:
    doc.save(output_filename1)
    print("Saved successfully to:", output_filename1)
except Exception as e:
    print("Error saving 1:", e)

try:
    doc.save(output_filename2)
    print("Saved successfully to:", output_filename2)
except Exception as e:
    print("Error saving 2:", e)
