import openpyxl
import json

wb = openpyxl.load_workbook('excel_baru/Bispira_Hyperlocal_Marketplace_Ledger_Complete_November_2026.xlsx', data_only=True)
ws = wb['PENDAPATAN SUPERADMIN&BAGIHASIL']

rows = []
for r in range(4, 20):
    no = ws.cell(r, 1).value
    cluster = ws.cell(r, 2).value
    penjual = ws.cell(r, 3).value
    harga_dasar = ws.cell(r, 4).value
    markup = ws.cell(r, 5).value
    biaya_layanan = ws.cell(r, 6).value
    biaya_aplikasi_reguler = ws.cell(r, 7).value
    biaya_aplikasi_premium = ws.cell(r, 8).value
    kode_unik = ws.cell(r, 9).value
    komisi = ws.cell(r, 10).value
    biaya_pencairan = ws.cell(r, 11).value
    
    # Bagi hasil columns
    # M4:N4 = KERJASAMA
    kerjasama_pusat = ws.cell(r, 13).value
    kerjasama_daerah = ws.cell(r, 14).value
    
    # O4:P4 = TIDAK ADA KERJASAMA
    tanpa_kerjasama_pusat = ws.cell(r, 15).value
    tanpa_kerjasama_daerah = ws.cell(r, 16).value
    
    # Q4:R4 = EVENT MANDIRI DAERAH
    event_mandiri_pusat = ws.cell(r, 17).value
    event_mandiri_daerah = ws.cell(r, 18).value
    
    # S4:T4 = EVOTING KERJASAMA PUSAT DAN DAERAH
    evoting_kerjasama_pusat = ws.cell(r, 19).value
    evoting_kerjasama_daerah = ws.cell(r, 20).value
    
    # U4:V4 = EVOTING PUSAT
    evoting_pusat_pusat = ws.cell(r, 21).value
    evoting_pusat_daerah = ws.cell(r, 22).value
    
    # For row 4 (Item 1), the cells M4:V4 in Excel were literal text 'PUSAT', 'DAERAH', but semantically item 1 follows standard kerjasama 75:25, 100:0.
    if no == 1:
        kerjasama_pusat = 0.75
        kerjasama_daerah = 0.25
        tanpa_kerjasama_pusat = 1.0
        tanpa_kerjasama_daerah = 0.0
    
    rows.append({
        "no": no,
        "bidang_cluster": str(cluster).strip() if cluster else "",
        "penjual": str(penjual).strip() if penjual else "",
        "harga_dasar": str(harga_dasar).strip() if harga_dasar else "",
        "markup": markup if markup is not None else 0.1,
        "markup_label": "10%" if markup == 0.1 else (str(markup) if markup else "-"),
        "biaya_layanan": str(biaya_layanan).strip() if biaya_layanan else "-",
        "biaya_layanan_nominal": 500 if biaya_layanan else 0,
        "biaya_aplikasi_reguler": str(biaya_aplikasi_reguler).strip() if biaya_aplikasi_reguler else "-",
        "biaya_aplikasi_reguler_nominal": 500 if biaya_aplikasi_reguler else 0,
        "biaya_aplikasi_premium_30hari": str(biaya_aplikasi_premium).strip() if biaya_aplikasi_premium else "-",
        "biaya_aplikasi_premium_nominal": 15000 if biaya_aplikasi_premium else 0,
        "kode_unik_bank": str(kode_unik).strip() if kode_unik else "-",
        "komisi": komisi if komisi is not None else "-",
        "komisi_label": "5%" if komisi == 0.05 else ("7.5%" if komisi in ['7,5%', 0.075] else ("1%" if komisi in ['1%', 0.01] else str(komisi))),
        "biaya_pencairan": str(biaya_pencairan).strip() if biaya_pencairan else "Rp. 1.000",
        "biaya_pencairan_nominal": 1000,
        "bagi_hasil_kerjasama": {
            "pusat": float(kerjasama_pusat) if isinstance(kerjasama_pusat, (int, float)) else 0.75,
            "daerah": float(kerjasama_daerah) if isinstance(kerjasama_daerah, (int, float)) else 0.25,
            "label": "75% : 25%"
        },
        "bagi_hasil_tanpa_kerjasama": {
            "pusat": float(tanpa_kerjasama_pusat) if isinstance(tanpa_kerjasama_pusat, (int, float)) else 1.0,
            "daerah": float(tanpa_kerjasama_daerah) if isinstance(tanpa_kerjasama_daerah, (int, float)) else 0.0,
            "label": "100% : 0%"
        },
        "bagi_hasil_event_mandiri": {
            "pusat": float(event_mandiri_pusat) if isinstance(event_mandiri_pusat, (int, float)) else (0.2 if no in [13, 15] else None),
            "daerah": float(event_mandiri_daerah) if isinstance(event_mandiri_daerah, (int, float)) else (0.8 if no in [13, 15] else None),
            "label": "20% : 80%" if no in [13, 15] or event_mandiri_pusat is not None else "-"
        },
        "bagi_hasil_evoting_kerjasama": {
            "pusat": float(evoting_kerjasama_pusat) if isinstance(evoting_kerjasama_pusat, (int, float)) else (0.6 if no in [14, 15, 16] else None),
            "daerah": float(evoting_kerjasama_daerah) if isinstance(evoting_kerjasama_daerah, (int, float)) else (0.4 if no in [14, 15, 16] else None),
            "label": "60% : 40%" if no in [14, 15, 16] or evoting_kerjasama_pusat is not None else "-"
        },
        "bagi_hasil_evoting_pusat": {
            "pusat": float(evoting_pusat_pusat) if isinstance(evoting_pusat_pusat, (int, float)) else (1.0 if no in [15, 16] else None),
            "daerah": float(evoting_pusat_daerah) if isinstance(evoting_pusat_daerah, (int, float)) else (0.0 if no in [15, 16] else None),
            "label": "100% : 0%" if no in [15, 16] or evoting_pusat_pusat is not None else "-"
        }
    })

data = {
    "title": "PEDOMAN PENDAPATAN SUPERADMIN PER TRANSAKSI & PETA BAGI HASIL NET PROFIT",
    "sheet_name": "PENDAPATAN SUPERADMIN&BAGIHASIL",
    "description": "Pedoman 16 cluster pendapatan platform Bispira: 7 Pilar Pendapatan (Markup 10%, Biaya Layanan Rp 500, Biaya Aplikasi Reguler Rp 500, Biaya Aplikasi Premium Rp 15.000/30hr, Kode Unik Bank 000-999, Komisi 1%-7.5%, Biaya Pencairan Rp 1.000) dan Matriks 5 Skema Bagi Hasil (Kerjasama 75:25, Tanpa Kerjasama 100:0, Event Mandiri Daerah 20:80, EVoting Kerjasama 60:40, EVoting Pusat 100:0)",
    "pilar_pendapatan": [
        {"no": 1, "name": "MARKUP", "value": "10%", "desc": "Markup harga dari merchant / ride hailing"},
        {"no": 2, "name": "BIAYA LAYANAN", "value": "Rp 500", "desc": "Biaya layanan operasional sistem (bisa diatur per cluster)"},
        {"no": 3, "name": "BIAYA APLIKASI REGULER", "value": "Rp 500", "desc": "Biaya pemeliharaan aplikasi per transaksi reguler"},
        {"no": 4, "name": "BIAYA APLIKASI PREMIUM 30 HARI", "value": "Rp 15.000", "desc": "Langganan 30 hari, bisa pindah dadakan ke premium jika order ramai"},
        {"no": 5, "name": "KODE UNIK BANK", "value": "000-999", "desc": "Verifikasi otomatis 3 digit transfer rekening"},
        {"no": 6, "name": "KOMISI", "value": "1% s.d 7.5% (Donasi 8% di akhir)", "desc": "Potongan komisi mitra merchant, driver, donasi"},
        {"no": 7, "name": "BIAYA PENCAIRAN AKUMULASI", "value": "Rp 1.000", "desc": "Biaya transfer penarikan dana per batch"}
    ],
    "skema_bagi_hasil": [
        {"kode": "KERJASAMA", "pusat": 0.75, "daerah": 0.25, "rasio": "75% : 25%", "desc": "Kerjasama standar Superadmin Pusat & Pemegang Lisensi Daerah"},
        {"kode": "TIDAK_ADA_KERJASAMA", "pusat": 1.0, "daerah": 0.0, "rasio": "100% : 0%", "desc": "Wilayah tanpa pemegang lisensi daerah aktif (100% Superadmin Pusat)"},
        {"kode": "EVENT_MANDIRI_DAERAH", "pusat": 0.20, "daerah": 0.80, "rasio": "20% : 80%", "desc": "Penyelenggaraan event, kompetisi & expo mandiri oleh admin daerah"},
        {"kode": "EVOTING_KERJASAMA", "pusat": 0.60, "daerah": 0.40, "rasio": "60% : 40%", "desc": "E-voting kerjasama kolaborasi pusat dan daerah"},
        {"kode": "EVOTING_PUSAT", "pusat": 1.0, "daerah": 0.0, "rasio": "100% : 0%", "desc": "E-voting skala nasional yang diselenggarakan pusat"}
    ],
    "matrix": rows
}

# Save output
with open('excel_baru/sheet12_pendapatan_superadmin_matrix.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

with open('bispira_admin_web/lib/data/sheet12_pendapatan_superadmin_matrix.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f"Generated Sheet 12 JSON successfully with {len(rows)} cluster rows.")

