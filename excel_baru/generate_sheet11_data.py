import openpyxl
import json

wb = openpyxl.load_workbook('excel_baru/Bispira_Hyperlocal_Marketplace_Ledger_Complete_November_2026.xlsx', data_only=True)
ws11 = wb['11. PEMBELI FRONT END']

columns_11 = []
for c in range(1, 14):
    col_num = ws11.cell(2, c).value
    col_title = ws11.cell(3, c).value
    items = []
    for r in range(4, 25):
        val = ws11.cell(r, c).value
        if val is not None and str(val).strip():
            items.append(str(val).strip())
    columns_11.append({
        "col_index": c,
        "no": col_num if col_num is not None else 13,
        "category_name": str(col_title).strip() if col_title else "",
        "items": items
    })

sheet11_data = {
    "sheet_name": "11. PEMBELI FRONT END",
    "title": "SEBARAN PRODUK INDUK DAN ANAK (FRON END)",
    "description": "Katalog Front End Tampilan Aplikasi Konsumen (Sheet 11)",
    "columns_count": len(columns_11),
    "clusters": columns_11,
    "special_rules": {
        "donasi": {
            "biaya_aplikasi": 0,
            "biaya_layanan": 0,
            "kode_unik": "000-999",
            "minimal_donasi": 1000,
            "program_populer": "Makan gratis anak yatim piatu Rp 1.000 (Mulai dari Rp 2.000)"
        },
        "iklan": {
            "posisi": "Urutan teratas (1-30) di Homepage Pembeli",
            "navigasi": "Bergeser dari kiri ke kanan otomatis (Auto-slide) atau swipe gestur tangan pembeli",
            "jenis": ["Pasang Iklan Banner", "Pasang Iklan Logo"]
        }
    }
}

# 1. Save to excel_baru/sheet11_pembeli_frontend.json
with open('excel_baru/sheet11_pembeli_frontend.json', 'w', encoding='utf-8') as f:
    json.dump(sheet11_data, f, indent=2, ensure_ascii=False)
print("Saved excel_baru/sheet11_pembeli_frontend.json")

# 2. Save to bispira_admin_web/lib/data/sheet11_pembeli_frontend.json
with open('bispira_admin_web/lib/data/sheet11_pembeli_frontend.json', 'w', encoding='utf-8') as f:
    json.dump(sheet11_data, f, indent=2, ensure_ascii=False)
print("Saved bispira_admin_web/lib/data/sheet11_pembeli_frontend.json")

# 3. Generate Dart Master Data for bispira_desktop_admin
dart_clusters = []
for cl in columns_11:
    items_str = ", ".join([f'"{it}"' for it in cl["items"]])
    dart_clusters.append(f'''    FrontendClusterModel(
      no: {cl['no']},
      categoryName: "{cl['category_name']}",
      frontendItems: [{items_str}],
    ),''')

dart_code = f'''// Generated Master Data for Sheet 11: PEMBELI FRONT END
// Source: Bispira_Hyperlocal_Marketplace_Ledger_Complete_November_2026.xlsx

class FrontendClusterModel {{
  final dynamic no;
  final String categoryName;
  final List<String> frontendItems;

  const FrontendClusterModel({{
    required this.no,
    required this.categoryName,
    required this.frontendItems,
  }});
}}

class MasterPembeliFrontendData {{
  static const String sheetName = "11. PEMBELI FRONT END";
  static const String sheetTitle = "SEBARAN PRODUK INDUK DAN ANAK (FRON END)";

  // Aturan Khusus Ekosistem Pembeli (Sheet 11)
  static const int donasiBiayaAplikasi = 0;
  static const int donasiBiayaLayanan = 0;
  static const String donasiKetentuan = "Tidak ada biaya layanan, aplikasi. Hanya kode unik 3 digit verifikasi otomatis.";
  static const String iklanCarouselBehavior = "Urutan teratas (1-30) auto-scroll bergeser kiri-kanan otomatis & swipe gestur pembeli.";

  static const List<FrontendClusterModel> clusters = [
{''.join(dart_clusters)}
  ];
}}
'''

with open('bispira_desktop_admin/lib/data/pembeli_frontend_data.dart', 'w', encoding='utf-8') as f:
    f.write(dart_code)
print("Saved bispira_desktop_admin/lib/data/pembeli_frontend_data.dart")
