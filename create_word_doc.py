import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT
from docx.oxml import OxmlElement
from docx.oxml.ns import qn

def set_cell_background(cell, fill_hex):
    tcPr = cell._element.get_or_add_tcPr()
    shd = OxmlElement('w:shd')
    shd.set(qn('w:val'), 'clear')
    shd.set(qn('w:color'), 'auto')
    shd.set(qn('w:fill'), fill_hex)
    tcPr.append(shd)

def set_cell_margins(cell, top=100, bottom=100, left=150, right=150):
    tcPr = cell._element.get_or_add_tcPr()
    tcMar = OxmlElement('w:tcMar')
    for m, val in [('top', top), ('bottom', bottom), ('left', left), ('right', right)]:
        node = OxmlElement(f'w:{m}')
        node.set(qn('w:w'), str(val))
        node.set(qn('w:type'), 'dxa')
        tcMar.append(node)
    tcPr.append(tcMar)

doc = docx.Document()

# Set Margins
for section in doc.sections:
    section.top_margin = Inches(1)
    section.bottom_margin = Inches(1)
    section.left_margin = Inches(1)
    section.right_margin = Inches(1)

# Set Normal Style Font
style = doc.styles['Normal']
font = style.font
font.name = 'Calibri'
font.size = Pt(11)
font.color.rgb = RGBColor(0x33, 0x33, 0x33)

# Title
title_p = doc.add_paragraph()
title_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
title_run = title_p.add_run("USULAN REVISI KONTRAK & ROADMAP DEVELOPMENT (7 BULAN)\nPLATFORM DIGITAL BISPIRA")
title_run.font.size = Pt(16)
title_run.font.bold = True
title_run.font.color.rgb = RGBColor(0x1A, 0x36, 0x5D) # Navy

sub_p = doc.add_paragraph()
sub_p.alignment = WD_ALIGN_PARAGRAPH.CENTER
sub_run = sub_p.add_run("Dokumen Tanggapan & Proposal Teknis Pengembangan Sistem")
sub_run.font.size = Pt(11)
sub_run.font.italic = True
sub_run.font.color.rgb = RGBColor(0x71, 0x80, 0x96)

doc.add_paragraph().paragraph_format.space_after = Pt(12)

# Metadata Table
meta_table = doc.add_table(rows=4, cols=2)
meta_table.alignment = WD_TABLE_ALIGNMENT.CENTER
meta_data = [
    ("Kepada Yth.", ": Direksi PT. Sitekun Academy Persada (BISPIRA) u.p. Bapak Ibnu Athiyah"),
    ("Dari", ": Davy Wahyu Saputra & Muhammad Daffa Athalia (Tim Developer)"),
    ("Tanggal", ": 20 Juli 2026"),
    ("Hal", ": Pengajuan Revisi Pasal Perjanjian & Rencana Kerja 7 Bulan")
]
for i, (label, val) in enumerate(meta_data):
    row = meta_table.rows[i]
    cell_lbl, cell_val = row.cells[0], row.cells[1]
    cell_lbl.width = Inches(1.5)
    cell_val.width = Inches(5.0)
    
    p_lbl = cell_lbl.paragraphs[0]
    r_lbl = p_lbl.add_run(label)
    r_lbl.bold = True
    r_lbl.font.color.rgb = RGBColor(0x2B, 0x6C, 0xB0)
    
    p_val = cell_val.paragraphs[0]
    p_val.add_run(val)

doc.add_paragraph().paragraph_format.space_after = Pt(12)

# Divider
p_div = doc.add_paragraph()
p_div.paragraph_format.space_after = Pt(18)
r_div = p_div.add_run("_________________________________________________________________________________")
r_div.font.color.rgb = RGBColor(0xCB, 0xD5, 0xE0)

# Intro
p_intro = doc.add_paragraph()
p_intro.paragraph_format.space_after = Pt(14)
p_intro.paragraph_format.line_spacing = 1.15
p_intro.add_run("Dengan hormat,\n\n"
                "Sebelumnya kami mengucapkan terima kasih atas kepercayaan PT. Sitekun Academy Persada (BISPIRA) kepada kami untuk berkolaborasi dalam pengembangan platform digital BISPIRA.\n\n"
                "Setelah mempelajari dokumen Draft Perjanjian Kerja Sama Pengembangan Platform Digital, pada prinsipnya kami siap dan berkomitmen untuk mendukung terwujudnya sistem ini. Namun demikian, demi kelancaran operasional, kejelasan arsitektur sistem, serta perlindungan hak dan kewajiban kedua belah pihak secara adil (fair), berikut kami sampaikan daftar klarifikasi teknis, draf usulan revisi pasal, serta rencana kerja 7 bulan (28 minggu).")

def add_heading_1(text):
    h = doc.add_paragraph()
    h.paragraph_format.space_before = Pt(18)
    h.paragraph_format.space_after = Pt(8)
    r = h.add_run(text)
    r.font.size = Pt(13)
    r.font.bold = True
    r.font.color.rgb = RGBColor(0x1A, 0x36, 0x5D)
    return h

# Section 1
add_heading_1("BAGIAN I: DAFTAR PERTANYAAN KLARIFIKASI TEKNIS")

questions = [
    ("Infrastruktur & Layanan Pihak Ketiga (Third-Party Services)",
     "Apakah biaya penyediaan Cloud Server/VPS (khususnya RAM besar untuk Engine OSRM Map & Database), domain, akun Google Play Console ($25), serta saldo OTP (SMS/WhatsApp Gateway) sepenuhnya menjadi tanggung jawab Pihak Pertama di luar nilai jasa pengembangan?"),
    ("Aset Konten & Legalitas Operasional",
     "Apakah Pihak Pertama sudah menyiapkan aset logo, banner promosi awal, serta draf dokumen hukum (Syarat & Ketentuan, Kebijakan Privasi) untuk tiap-tiap modul bisnis?"),
    ("Detail Fitur Perpajakan (PPh Final 0.5%)",
     "Apakah integrasi perpajakan ini sebatas kalkulasi otomatis dan pencetakan laporan bukti potong internal (PDF/Excel), atau wajib terhubung langsung via API ke DJP Online / PJAP?"),
    ("Mekanisme Auto Debet (Driver & Merchant)",
     "Apakah pemotongan cicilan/pinjaman dilakukan melalui pemotongan saldo e-wallet internal platform BISPIRA, atau melibatkan instruksi direct debit rekening bank eksternal?")
]

for q_title, q_desc in questions:
    p_q = doc.add_paragraph()
    p_q.paragraph_format.space_before = Pt(4)
    p_q.paragraph_format.space_after = Pt(6)
    p_q.paragraph_format.left_indent = Inches(0.25)
    
    r_t = p_q.add_run(f"•  {q_title}: ")
    r_t.bold = True
    r_t.font.color.rgb = RGBColor(0x2B, 0x6C, 0xB0)
    p_q.add_run(q_desc)

# Section 2
add_heading_1("BAGIAN II: DRAFT PENGAJUAN REVISI PASAL KONTRAK")

revisions = [
    ("PASAL 1", "Ruang Lingkup & Pelaksanaan Bertahap",
     "1. Pihak Kedua bertanggung jawab membangun ekosistem platform digital BISPIRA yang terdiri dari Website Pusat, 5 (lima) Aplikasi Android, Engine Routing OSRM, serta 12 modul operasional.\n"
     "2. Mengingat kompleksitas dan luasnya skala platform, pengerjaan dilakukan secara bertahap (phasing) selama 7 (tujuh) bulan sesuai dengan Roadmap Pengerjaan yang terlampir."),
    
    ("PASAL 5", "Desain & Integrasi API Bank Digital",
     "1. Pihak Kedua bertugas menyiapkan skema arsitektur database, REST API Stub, alur UI/UX, serta form KYC yang siap dihubungkan (Bank API-Ready)."),
    
    ("PASAL 6", "Lama Pengerjaan & Ketentuan Denda",
     "1. Jangka waktu pelaksanaan pekerjaan ditetapkan selama 7 (tujuh) bulan terhitung sejak penandatanganan kontrak dan diterimanya Pembayaran Termin 1 (DP).\n"
     "2. Ketentuan denda keterlambatan sebesar 0,1% per hari dikecualikan apabila keterlambatan disebabkan oleh:\n"
     "    a. Keterlambatan penyerahan aset/data dari Pihak Pertama;\n"
     "    b. Perubahan spesifikasi/fitur di luar kesepakatan awal;\n"
     "    c. Kendala teknis server/layanan pihak ketiga yang ditanggung Pihak Pertama (Force Majeure Teknis)."),
    
    ("PASAL 7", "Skema Pembayaran Berbasis Milestone",
     "Termin pembayaran disesuaikan dengan penambahan durasi dan milestone pengerjaan (7 bulan):\n"
     "•  Termin 1 (20%): Dibayarkan setelah Penandatanganan Kontrak & Kick-off Proyek.\n"
     "•  Termin 2 (20%): Dibayarkan setelah Penyelesaian Website Pusat, Back-End Core & Server OSRM (Bulan ke-1 s.d. Bulan ke-2).\n"
     "•  Termin 3 (20%): Dibayarkan setelah Penyelesaian Core Mobile Apps (Aplikasi User, Driver, Merchant & Core Food/Sembako) & MVP Testing (Bulan ke-3 s.d. Bulan ke-4).\n"
     "•  Termin 4 (20%): Dibayarkan setelah Penyelesaian Aplikasi Spesialis (Kesehatan, Ahli, Ads, Ticketing & Kost) (Bulan ke-5 s.d. Bulan ke-6).\n"
     "•  Termin 5 (20%): Dibayarkan setelah Penyelesaian Modul E-Voting, Tax Engine, UAT, Dokumentasi & Live Launching (Bulan ke-7).\n\n"
     "Ketentuan Rekening Pembayaran Transfer Termin (PIHAK KEDUA):\n"
     "•  Nama Bank      : Bank Negara Indonesia (BNI)\n"
     "•  Nomor Rekening : 1888898006\n"
     "•  Atas Nama (A/n): Davy Wahyu Saputra"),

    
    ("PASAL 9", "Hak Cipta & Pengalihan Source Code",
     "1. Pihak Kedua melakukan sinkronisasi source code secara berkala ke repositori Pihak Pertama untuk keperluan pemantauan (review).\n"
     "2. Pengalihan Hak Cipta dan Penyerahan Akses repositori utama (Production Access) secara penuh baru berlaku sah demi hukum setelah Pihak Pertama melunasi 100% pembayaran proyek (Termin 5).")
]

for p_num, p_title, p_content in revisions:
    p_header = doc.add_paragraph()
    p_header.paragraph_format.space_before = Pt(8)
    p_header.paragraph_format.space_after = Pt(2)
    r_h = p_header.add_run(f"{p_num}: {p_title}")
    r_h.bold = True
    r_h.font.size = Pt(11)
    r_h.font.color.rgb = RGBColor(0x2B, 0x6C, 0xB0)
    
    tbl = doc.add_table(rows=1, cols=1)
    tbl.alignment = WD_TABLE_ALIGNMENT.CENTER
    cell = tbl.cell(0, 0)
    cell.width = Inches(6.5)
    set_cell_background(cell, "F7FAFC")
    set_cell_margins(cell, top=120, bottom=120, left=180, right=180)
    
    p_box = cell.paragraphs[0]
    p_box.paragraph_format.line_spacing = 1.15
    p_box.paragraph_format.space_after = Pt(0)
    r_box = p_box.add_run(p_content)
    r_box.font.size = Pt(10)
    r_box.font.italic = True
    r_box.font.color.rgb = RGBColor(0x2D, 0x37, 0x48)
    
    doc.add_paragraph().paragraph_format.space_after = Pt(4)

# Section 3
add_heading_1("BAGIAN III: ROADMAP & TIMELINE PENGERJAAN (7 BULAN / 28 MINGGU)")

p_rm_desc = doc.add_paragraph()
p_rm_desc.paragraph_format.space_after = Pt(10)
p_rm_desc.add_run("Berikut adalah rincian pembagian tahapan kerja selama 28 minggu (7 bulan) untuk memastikan platform dapat berjalan stabil, aman, dan lolos pengujian secara menyeluruh:")

rm_table = doc.add_table(rows=1, cols=3)
rm_table.alignment = WD_TABLE_ALIGNMENT.CENTER
hdr_cells = rm_table.rows[0].cells
hdr_cells[0].width = Inches(1.2)
hdr_cells[1].width = Inches(1.5)
hdr_cells[2].width = Inches(3.8)

headers = ["Periode", "Fase / Modul", "Detail Ruang Lingkup Pekerjaan"]
for i, h_text in enumerate(headers):
    set_cell_background(hdr_cells[i], "1A365D")
    set_cell_margins(hdr_cells[i], top=100, bottom=100, left=120, right=120)
    p = hdr_cells[i].paragraphs[0]
    p.alignment = WD_ALIGN_PARAGRAPH.LEFT
    r = p.add_run(h_text)
    r.bold = True
    r.font.color.rgb = RGBColor(0xFF, 0xFF, 0xFF)

timeline_data = [
    ("Bulan 1\n(Minggu 1-4)", "Infrastruktur & Web Pusat", 
     "• W1: Setup DB PostgreSQL/MySQL, RESTful API Engine Core, & Server OSRM (Map Routing).\n"
     "• W2: Sistem Otentikasi Multi-role (Super Admin, Admin Cabang, Merchant, Driver, User).\n"
     "• W3: Web Pusat (Landing Page, Blog Tutorial, Page Buy License & Layanan).\n"
     "• W4: Dashboard Super Admin & Dashboard Admin Cabang (Kontrol Wilayah & Revenue Sharing)."),
    
    ("Bulan 2\n(Minggu 5-8)", "Core Backend & Finance Engine", 
     "• W5: Arsitektur Multi-App Android (Base Framework, State Management & UI Kit).\n"
     "• W6: Engine Logika Keuangan Pusat (Rumus Harga: Harga Asli + Markup Platform, Bagi Hasil Wilayah).\n"
     "• W7: Engine Auto-Debet Harian (Potongan Pinjaman Bank & Cicilan Atribut Driver).\n"
     "• W8: Integrasi Payment Gateway / E-Wallet Interface & Transaction Logging System."),
    
    ("Bulan 3\n(Minggu 9-12)", "Core Mobile Apps & MVP Release", 
     "• W9: Aplikasi Android User (Alur Order, Routing OSRM Realtime, Estimasi Harga).\n"
     "• W10: Aplikasi Android Driver (Terima Order, Bid System, Tracking GPS, Saldo Driver).\n"
     "• W11: Aplikasi Android Merchant (Input Produk, Ubah Harga, Saldo Merchant).\n"
     "• W12: Modul Food & Fresh Sembako, Auto Debet Cicilan, & Live Testing MVP Internal."),
    
    ("Bulan 4\n(Minggu 13-16)", "Apps Spesialis & Commercial Modules", 
     "• W13: Aplikasi Android Mitra Kesehatan & Modul Telemedicine Chat / Booking.\n"
     "• W14: Sub-Modul Homecare & Praktik Mandiri (On-demand Visit Dokter/Nakes).\n"
     "• W15: Aplikasi Android Mitra Ahli & Modul Edukasi / Hiburan.\n"
     "• W16: Modul Mitra Ads (Carousel Fair Rotation & Brand Awareness Rotating Banner)."),
    
    ("Bulan 5\n(Minggu 17-20)", "Ticketing, Property & Donasi", 
     "• W17: Modul Tiket MICE & Wisata (Penjualan & Penerbitan E-Tiket QR Code).\n"
     "• W18: Modul Mitra Kost (Sewa Kamar, Galeri Foto, Peta Location, Management Jatuh Tempo).\n"
     "• W19: Modul Mitra Donasi (Penggalangan Dana Digital Yayasan Sosial).\n"
     "• W20: Testing Integrasi Modul Komersial & Optimalisasi Database Performance."),
    
    ("Bulan 6\n(Minggu 21-24)", "Community, Tax Engine & Bank Ready", 
     "• W21: Modul Bispira E-Voting (Cabang & Pusat dengan Counter Anti-manipulasi).\n"
     "• W22: Modul Bispira Event Organizer / EO (Manajemen Pendaftaran & Bagan Lomba).\n"
     "• W23: Tax Engine (Kalkulasi PPh Final 0.5% PMK 37/2025, Batas Rp500 Juta, & Bukti Potong).\n"
     "• W24: Persiapan API Bank Digital (Bank-Ready Stub, Embedded KYC, Mock Integration)."),
    
    ("Bulan 7\n(Minggu 25-28)", "UAT, Hardening, Manual & Launching", 
     "• W25: User Acceptance Testing (UAT) Komprehensif di Lingkungan Staging.\n"
     "• W26: Stress Testing, Load Testing OSRM/API Engine, & Security Hardening.\n"
     "• W27: Penyusunan Manual Book, Technical Deployment Guide, & OSRM Configuration Manual.\n"
     "• W28: Upload 5 App ke Play Store Production, Cut-off Server Production, & Pelunasan Termin 5.")
]

for row_idx, (per, fase, det) in enumerate(timeline_data):
    row_cells = rm_table.add_row().cells
    row_cells[0].width = Inches(1.2)
    row_cells[1].width = Inches(1.5)
    row_cells[2].width = Inches(3.8)
    
    bg_color = "FFFFFF" if row_idx % 2 == 0 else "F7FAFC"
    for cell in row_cells:
        set_cell_background(cell, bg_color)
        set_cell_margins(cell, top=100, bottom=100, left=120, right=120)
    
    p0 = row_cells[0].paragraphs[0]
    r0 = p0.add_run(per)
    r0.bold = True
    r0.font.size = Pt(9.5)
    
    p1 = row_cells[1].paragraphs[0]
    r1 = p1.add_run(fase)
    r1.bold = True
    r1.font.color.rgb = RGBColor(0x2B, 0x6C, 0xB0)
    r1.font.size = Pt(9.5)
    
    p2 = row_cells[2].paragraphs[0]
    r2 = p2.add_run(det)
    r2.font.size = Pt(9.5)

doc.add_paragraph().paragraph_format.space_after = Pt(16)

# Closing
p_close = doc.add_paragraph()
p_close.paragraph_format.line_spacing = 1.15
p_close.paragraph_format.space_after = Pt(24)
p_close.add_run("Demikian berkas pengajuan ini kami buat untuk menjadi bahan pertimbangan utama Pihak Pertama. Kami percaya dengan kesepakatan yang berimbang, proyek platform BISPIRA dapat terealisasi secara sukses, stabil, dan berdaya saing tinggi.\n\n"
                "Atas perhatian dan kerja samanya, kami ucapkan terima kasih.")

# Signatures
sign_table = doc.add_table(rows=2, cols=2)
sign_table.alignment = WD_TABLE_ALIGNMENT.CENTER

c0, c1 = sign_table.rows[0].cells
c0.width = Inches(3.25)
c1.width = Inches(3.25)

p_s0 = c0.paragraphs[0]
p_s0.add_run("Pihak Pertama,\nPT. Sitekun Academy Persada (BISPIRA)\n\n\n\n\n( Ibnu Athiyah )\nDirektur Utama").font.size = Pt(10)

p_s1 = c1.paragraphs[0]
p_s1.add_run("Pihak Kedua,\nTim Developer Independen\n\n\n\n\n( Davy W. S. & M. Daffa Athalia )\nLead Developer").font.size = Pt(10)

output_filename = r"c:\Users\Davy\Documents\superapp\Dokumen_Usulan_Revisi_dan_Timeline_BISPIRA.docx"
try:
    doc.save(output_filename)
    print("Successfully generated Word document:", output_filename)
except Exception as e:
    print(f"Primary save failed: {e}. Trying fallback or killing word process...")
    import os
    os.system("taskkill /f /im WINWORD.EXE >nul 2>&1")
    try:
        doc.save(output_filename)
        print("Successfully generated Word document after killing Word process:", output_filename)
    except Exception as e2:
        alt_filename = r"c:\Users\Davy\Documents\superapp\Dokumen_Usulan_Revisi_dan_Timeline_BISPIRA_7Bulan.docx"
        doc.save(alt_filename)
        print("Successfully generated Word document at alternate path:", alt_filename)

