import docx
from docx.shared import Inches, Pt, RGBColor
from docx.enum.text import WD_ALIGN_PARAGRAPH
from docx.enum.table import WD_TABLE_ALIGNMENT, WD_ALIGN_VERTICAL
from docx.oxml import OxmlElement, parse_xml
from docx.oxml.ns import nsdecls, qn

def set_cell_background(cell, hex_color):
    tcPr = cell._tc.get_or_add_tcPr()
    shd = parse_xml(f'<w:shd {nsdecls("w")} w:fill="{hex_color}"/>')
    tcPr.append(shd)

def set_cell_margins(cell, top=100, bottom=100, left=150, right=150):
    tcPr = cell._tc.get_or_add_tcPr()
    tcMar = parse_xml(f'<w:tcMar {nsdecls("w")}><w:top w:w="{top}" w:type="dxa"/><w:bottom w:w="{bottom}" w:type="dxa"/><w:left w:w="{left}" w:type="dxa"/><w:right w:w="{right}" w:type="dxa"/></w:tcMar>')
    tcPr.append(tcMar)

def create_master_document():
    doc = docx.Document()

    # Set page margins
    sections = doc.sections
    for section in sections:
        section.top_margin = Inches(0.8)
        section.bottom_margin = Inches(0.8)
        section.left_margin = Inches(0.9)
        section.right_margin = Inches(0.9)

    # Color Palette - BISPIRA Royal Theme
    PRIMARY_COLOR = RGBColor(0, 64, 184)     # Royal Blue (#0040B8)
    SECONDARY_COLOR = RGBColor(212, 160, 23) # Royal Gold (#D4A017)
    TEXT_DARK = RGBColor(30, 41, 59)        # Slate Dark (#1E293B)
    MUTED_GRAY = RGBColor(100, 116, 139)    # Slate Gray (#64748B)

    # ---------------------------------------------------------
    # COVER / HEADER
    # ---------------------------------------------------------
    p_title = doc.add_paragraph()
    p_title.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run_title = p_title.add_run("PROPOSAL TEKNIS & INTEGRASI MASTER\nSISTEM PEMBAYARAN, BANK, & BISPIRA WALLET")
    run_title.font.name = "Arial"
    run_title.font.size = Pt(20)
    run_title.font.bold = True
    run_title.font.color.rgb = PRIMARY_COLOR

    p_sub = doc.add_paragraph()
    p_sub.alignment = WD_ALIGN_PARAGRAPH.CENTER
    run_sub = p_sub.add_run("Panduan Lengkap Arsitektur Payment Gateway, BISPIRA Pay, Rincian Biaya, & Standar SNAP BI")
    run_sub.font.name = "Arial"
    run_sub.font.size = Pt(11)
    run_sub.font.italic = True
    run_sub.font.color.rgb = SECONDARY_COLOR

    doc.add_paragraph().paragraph_format.space_after = Pt(10)

    # ---------------------------------------------------------
    # EXECUTIVE SUMMARY BOX
    # ---------------------------------------------------------
    tbl_exec = doc.add_table(rows=1, cols=1)
    tbl_exec.alignment = WD_TABLE_ALIGNMENT.CENTER
    cell_exec = tbl_exec.cell(0, 0)
    cell_exec.width = Inches(6.5)
    set_cell_background(cell_exec, "F0F4FF")
    set_cell_margins(cell_exec, top=140, bottom=140, left=180, right=180)

    p_exec = cell_exec.paragraphs[0]
    r_exec_title = p_exec.add_run("📌 Ringkasan Eksekutif & Rencana Kerja Master:\n")
    r_exec_title.font.bold = True
    r_exec_title.font.size = Pt(11)
    r_exec_title.font.color.rgb = PRIMARY_COLOR

    r_exec_body = p_exec.add_run(
        "Dokumen ini merangkum secara komprehensif strategi integrasi sistem keuangan BISPIRA SuperApp. "
        "Memanfaatkan jembatan Payment Gateway terdaftar BI/OJK (Xendit & Midtrans), ekosistem BISPIRA Pay "
        "dapat melayani Top Up Virtual Account (BCA, Mandiri, BRI, BNI), QRIS, Transfer Antar-Pengguna, "
        "serta Penarikan Saldo Driver/Mitra via BI-Fast secara instan, legal, aman, dan tanpa biaya pendaftaran/bulanan."
    )
    r_exec_body.font.size = Pt(9.5)
    r_exec_body.font.color.rgb = TEXT_DARK

    doc.add_paragraph().paragraph_format.space_after = Pt(12)

    # ---------------------------------------------------------
    # SECTION 1: PEMILIHAN STRATEGI INTEGRASI
    # ---------------------------------------------------------
    h1 = doc.add_heading(level=1)
    r_h1 = h1.add_run("1. Strategi Integrasi: Payment Gateway vs Direct API Bank")
    r_h1.font.name = "Arial"
    r_h1.font.color.rgb = PRIMARY_COLOR
    r_h1.font.bold = True

    tbl_comp = doc.add_table(rows=5, cols=3)
    tbl_comp.alignment = WD_TABLE_ALIGNMENT.CENTER
    headers = ["Kriteria Evaluasi", "API Bank Resmi Direct", "Agregator Payment Gateway (Rekomendasi)"]
    for j, text in enumerate(headers):
        cell = tbl_comp.cell(0, j)
        set_cell_background(cell, "0040B8")
        set_cell_margins(cell, top=120, bottom=120, left=120, right=120)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run(text)
        r.font.bold = True
        r.font.color.rgb = RGBColor(255, 255, 255)
        r.font.size = Pt(9.5)

    data_comp = [
        ("Syarat Legalitas", "Wajib PT, Lisensi BI/OJK, Audit Keamanan", "Mode Sandbox Cepat tanpa syarat rumit"),
        ("Biaya & Modal Awal", "Biaya integrasi mahal & deposit ratusan juta", "Gratis pendaftaran / Pay-per-transaction"),
        ("Cakupan Bank & E-Wallet", "Hanya 1 bank spesifik per kerjasama", "1 API mencakup BCA, Mandiri, BRI, BNI, QRIS"),
        ("Waktu Peluncuran (Go-Live)", "3 - 6 Bulan masa pengurusan", "1 - 3 Hari siap transaksi penuh"),
    ]

    for row_idx, row_data in enumerate(data_comp, start=1):
        bg = "F8FAFC" if row_idx % 2 == 1 else "FFFFFF"
        for col_idx, cell_value in enumerate(row_data):
            cell = tbl_comp.cell(row_idx, col_idx)
            set_cell_background(cell, bg)
            set_cell_margins(cell, top=100, bottom=100, left=120, right=120)
            p = cell.paragraphs[0]
            r = p.add_run(cell_value)
            r.font.size = Pt(9.5)
            r.font.color.rgb = TEXT_DARK
            if col_idx == 0:
                r.font.bold = True

    doc.add_paragraph().paragraph_format.space_after = Pt(14)

    # ---------------------------------------------------------
    # SECTION 2: OPERASIONAL BISPIRA WALLET (BISPIRA PAY)
    # ---------------------------------------------------------
    h2 = doc.add_heading(level=1)
    r_h2 = h2.add_run("2. Operasional & Alur Kerja BISPIRA Wallet (BISPIRA Pay)")
    r_h2.font.name = "Arial"
    r_h2.font.color.rgb = PRIMARY_COLOR
    r_h2.font.bold = True

    p_w1 = doc.add_paragraph()
    r = p_w1.add_run("A. Alur Top Up Saldo (Virtual Account & QRIS)\n")
    r.font.bold = True
    r.font.color.rgb = SECONDARY_COLOR
    r2 = p_w1.add_run(
        "1. Pengguna membuka menu Top Up di aplikasi dan memilih bank tujuan (BCA, Mandiri, BRI, BNI) atau QRIS.\n"
        "2. Sistem meminta nomor Virtual Account (VA) unik dari Xendit/Midtrans.\n"
        "3. Pengguna mentransfer melalui m-Banking / ATM.\n"
        "4. Server BISPIRA menerima notifikasi Webhook otomatis dan saldo bertambah instan secara real-time."
    )
    r2.font.size = Pt(9.5)

    p_w2 = doc.add_paragraph()
    r = p_w2.add_run("B. Alur Pembayaran Layanan 1-Klik (Ride, Food, Send, Ticket)\n")
    r.font.bold = True
    r.font.color.rgb = SECONDARY_COLOR
    r2 = p_w2.add_run(
        "1. Pengguna memesan layanan (misal Ride Rp 15.000).\n"
        "2. Saldo BISPIRA Pay terpotong otomatis secara instant tanpa perlu keluar ke aplikasi m-Banking.\n"
        "3. Komisi platform otomatis masuk ke kas BISPIRA, dan sisa pembayaran dialokasikan ke saldo Driver/Mitra."
    )
    r2.font.size = Pt(9.5)

    p_w3 = doc.add_paragraph()
    r = p_w3.add_run("C. Alur Transfer Antar Pengguna & Driver\n")
    r.font.bold = True
    r.font.color.rgb = SECONDARY_COLOR
    r2 = p_w3.add_run(
        "• Pengguna dapat mengirim saldo BISPIRA Pay ke sesama pengguna atau driver cukup dengan memasukkan Nomor HP.\n"
        "• Transaksi berjalan instan (0 detik) dan bebas biaya administrasi."
    )
    r2.font.size = Pt(9.5)

    p_w4 = doc.add_paragraph()
    r = p_w4.add_run("D. Alur Penarikan Saldo / Cash Out (BI-Fast Payout)\n")
    r.font.bold = True
    r.font.color.rgb = SECONDARY_COLOR
    r2 = p_w4.add_run(
        "1. Driver atau Pengguna memilih menu Tarik Saldo ke Rekening Bank Pribadi.\n"
        "2. API Bank Account Validator mengecek keaslian nama pemilik rekening.\n"
        "3. Sistem mengeksekusi transfer keluar via jaringan BI-Fast nasional (< 15 menit sampai)."
    )
    r2.font.size = Pt(9.5)

    doc.add_paragraph().paragraph_format.space_after = Pt(14)

    # ---------------------------------------------------------
    # SECTION 3: TABEL RINCIAN TARIF & BIAYA TRANSAKSI
    # ---------------------------------------------------------
    h3 = doc.add_heading(level=1)
    r_h3 = h3.add_run("3. Rincian Potongan Biaya Transaksi (Xendit & Midtrans)")
    r_h3.font.name = "Arial"
    r_h3.font.color.rgb = PRIMARY_COLOR
    r_h3.font.bold = True

    tbl_fee = doc.add_table(rows=6, cols=4)
    tbl_fee.alignment = WD_TABLE_ALIGNMENT.CENTER
    headers_fee = ["Metode Pembayaran", "Biaya Xendit", "Biaya Midtrans", "Keterangan Pembebanan"]
    for j, text in enumerate(headers_fee):
        cell = tbl_fee.cell(0, j)
        set_cell_background(cell, "0040B8")
        set_cell_margins(cell, top=120, bottom=120, left=100, right=100)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run(text)
        r.font.bold = True
        r.font.color.rgb = RGBColor(255, 255, 255)
        r.font.size = Pt(9.0)

    data_fee = [
        ("Virtual Account (BCA, Mandiri, BRI, BNI)", "Rp 4.000 - Rp 4.500 / trx", "Rp 4.000 - Rp 4.500 / trx", "Flat per transaksi (Diteruskan ke pengguna)"),
        ("QRIS (GoPay, OVO, DANA, m-Banking)", "0,7% per transaksi", "0,7% per transaksi", "Sesuai regulasi MDR Bank Indonesia"),
        ("E-Wallet Direct (ShopeePay, OVO)", "1,5% - 2,0% per trx", "1,5% - 2,0% per trx", "Potongan persentase transaksi"),
        ("Transfer Keluar (Disbursement / Payout)", "Rp 5.000 / transfer", "Rp 5.000 / transfer", "Pencairan saldo driver/user via BI-Fast"),
        ("Biaya Pendaftaran & Bulanan", "GRATIS (Rp 0)", "GRATIS (Rp 0)", "Bebas biaya langganan/pemeliharaan"),
    ]

    for row_idx, row_data in enumerate(data_fee, start=1):
        bg = "F8FAFC" if row_idx % 2 == 1 else "FFFFFF"
        for col_idx, cell_value in enumerate(row_data):
            cell = tbl_fee.cell(row_idx, col_idx)
            set_cell_background(cell, bg)
            set_cell_margins(cell, top=90, bottom=90, left=100, right=100)
            p = cell.paragraphs[0]
            r = p.add_run(cell_value)
            r.font.size = Pt(9.0)
            r.font.color.rgb = TEXT_DARK
            if col_idx == 0:
                r.font.bold = True

    doc.add_paragraph().paragraph_format.space_after = Pt(14)

    # ---------------------------------------------------------
    # SECTION 4: SPESIFIKASI API (STANDAR SNAP BI)
    # ---------------------------------------------------------
    h4 = doc.add_heading(level=1)
    r_h4 = h4.add_run("4. Spesifikasi Teknis Open API (Standar SNAP BI)")
    r_h4.font.name = "Arial"
    r_h4.font.color.rgb = PRIMARY_COLOR
    r_h4.font.bold = True

    tbl_api = doc.add_table(rows=5, cols=3)
    tbl_api.alignment = WD_TABLE_ALIGNMENT.CENTER

    headers_api = ["Nama API Endpoint", "Tipe / Method", "Fungsi Operasional Sistem"]
    for j, text in enumerate(headers_api):
        cell = tbl_api.cell(0, j)
        set_cell_background(cell, "0040B8")
        set_cell_margins(cell, top=120, bottom=120, left=120, right=120)
        p = cell.paragraphs[0]
        p.alignment = WD_ALIGN_PARAGRAPH.CENTER
        r = p.add_run(text)
        r.font.bold = True
        r.font.color.rgb = RGBColor(255, 255, 255)
        r.font.size = Pt(9.5)

    data_api = [
        ("Create Virtual Account API", "POST /callback_virtual_accounts", "Membuat nomor rekening VA unik per pengguna secara otomatis"),
        ("Payment Webhook API", "POST /webhook-penerimaan", "Endpoint penerima notifikasi otomatis saat pembayaran selesai"),
        ("Account Validator API", "POST /disbursements/bank_query", "Pengecekan nama asli pemilik rekening sebelum dana dikirim"),
        ("Disbursement / Payout API", "POST /disbursements", "Perintah eksekusi transfer balik saldo ke rekening bank pengguna"),
    ]

    for row_idx, row_data in enumerate(data_api, start=1):
        bg = "F8FAFC" if row_idx % 2 == 1 else "FFFFFF"
        for col_idx, cell_value in enumerate(row_data):
            cell = tbl_api.cell(row_idx, col_idx)
            set_cell_background(cell, bg)
            set_cell_margins(cell, top=100, bottom=100, left=120, right=120)
            p = cell.paragraphs[0]
            r = p.add_run(cell_value)
            r.font.size = Pt(9.5)
            r.font.color.rgb = TEXT_DARK
            if col_idx == 0:
                r.font.bold = True

    doc.add_paragraph().paragraph_format.space_after = Pt(14)

    # ---------------------------------------------------------
    # SECTION 5: INFRASTRUKTUR & KEUNTUNGAN BISNIS
    # ---------------------------------------------------------
    h5 = doc.add_heading(level=1)
    r_h5 = h5.add_run("5. Infrastruktur Server & Manfaat Bisnis bagi BISPIRA")
    r_h5.font.name = "Arial"
    r_h5.font.color.rgb = PRIMARY_COLOR
    r_h5.font.bold = True

    p_inf = doc.add_paragraph()
    p_inf.add_run(
        "• Rekening Penampungan Escrow: Seluruh dana fisik Top Up disimpan aman di Rekening Escrow Penampungan Resmi BISPIRA.\n"
        "• Database Relasional Financial (ACID Compliant): Menjamin keakuratan data saldo (Double-Entry Bookkeeping) agar tidak pernah ganda/eror.\n"
        "• Retensi Pengguna Tinggi: Keberadaan BISPIRA Pay terbukti meningkatkan frekuensi transaksi pengguna hingga 3x lipat.\n"
        "• Float Fund (Dana Mengendap): Memberikan likuiditas modal kerja yang sehat bagi pertumbuhan ekosistem bisnis BISPIRA."
    )
    p_inf.runs[0].font.size = Pt(9.5)
    p_inf.runs[0].font.color.rgb = TEXT_DARK

    doc.add_paragraph().paragraph_format.space_after = Pt(18)

    # FOOTER / SIGNATURE BOX
    p_foot = doc.add_paragraph()
    p_foot.alignment = WD_ALIGN_PARAGRAPH.RIGHT
    r_foot = p_foot.add_run("Disiapkan oleh: Tim Pengembang BISPIRA SuperApp\nTanggal: 25 Agustus 2026")
    r_foot.font.size = Pt(9.5)
    r_foot.font.italic = True
    r_foot.font.color.rgb = MUTED_GRAY

    doc.save("c:/Users/Davy/Documents/superapp/Proposal_Integrasi_Sistem_Pembayaran_BISPIRA.docx")
    print("Master Document successfully created!")

if __name__ == "__main__":
    create_master_document()
