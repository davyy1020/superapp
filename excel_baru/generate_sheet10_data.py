import openpyxl
import json

wb = openpyxl.load_workbook('excel_baru/Bispira_Hyperlocal_Marketplace_Ledger_Complete_November_2026.xlsx', data_only=True)
ws10 = wb['10.PRODUK PENJUAL BACK END']
ws11 = wb['11. PEMBELI FRONT END']

# 1. Parse Sheet 10 (Back End)
sheet10_columns = []
for c in range(1, 14):
    col_num = ws10.cell(2, c).value
    col_title = ws10.cell(3, c).value
    if col_title:
        items = []
        for r in range(4, 25):
            val = ws10.cell(r, c).value
            if val is not None and str(val).strip():
                items.append(str(val).strip())
        sheet10_columns.append({
            "col_index": c,
            "no": col_num,
            "category_name": str(col_title).strip(),
            "items": items
        })

# 2. Parse Sheet 11 (Front End)
sheet11_columns = []
for c in range(1, 14):
    col_num = ws11.cell(2, c).value
    col_title = ws11.cell(3, c).value
    if col_title:
        items = []
        for r in range(4, 25):
            val = ws11.cell(r, c).value
            if val is not None and str(val).strip():
                items.append(str(val).strip())
        sheet11_columns.append({
            "col_index": c,
            "no": col_num,
            "category_name": str(col_title).strip(),
            "items": items
        })

sheet10_data = {
    "sheet_name": "10.PRODUK PENJUAL BACK END",
    "title": "SEBARAN PRODUK INDUK DAN ANAK (BACK END)",
    "columns_count": len(sheet10_columns),
    "clusters": sheet10_columns
}

sheet10_11_combined = {
    "title": "SEBARAN PRODUK INDUK DAN ANAK HYPERLOCAL BISPIRA",
    "description": "Katalog Terpadu Front End Pembeli dan Back End Penjual (Sheet 10 & 11)",
    "sheet10_backend": sheet10_data,
    "sheet11_frontend": {
        "sheet_name": "11. PEMBELI FRONT END",
        "title": "SEBARAN PRODUK INDUK DAN ANAK (FRON END)",
        "columns_count": len(sheet11_columns),
        "clusters": sheet11_columns
    }
}

# Save json to excel_baru and bispira_admin_web/lib/data
with open('excel_baru/sheet10_produk_penjual_backend.json', 'w', encoding='utf-8') as f:
    json.dump(sheet10_data, f, indent=2, ensure_ascii=False)
print("Saved excel_baru/sheet10_produk_penjual_backend.json")

with open('bispira_admin_web/lib/data/sheet10_produk_penjual_backend.json', 'w', encoding='utf-8') as f:
    json.dump(sheet10_data, f, indent=2, ensure_ascii=False)
print("Saved bispira_admin_web/lib/data/sheet10_produk_penjual_backend.json")

# Generate Dart Master Data for bispira_desktop_admin
dart_clusters = []
for cl in sheet10_columns:
    items_str = ", ".join([f'"{it}"' for it in cl["items"]])
    no_val = cl["no"] if cl["no"] is not None else 13
    dart_clusters.append(f'''    ProductClusterModel(
      no: {no_val},
      categoryName: "{cl['category_name']}",
      backendItems: [{items_str}],
    ),''')

dart_code = f'''// Generated Master Data for Sheet 10: PRODUK PENJUAL BACK END
// Source: Bispira_Hyperlocal_Marketplace_Ledger_Complete_November_2026.xlsx

class ProductClusterModel {{
  final dynamic no;
  final String categoryName;
  final List<String> backendItems;

  const ProductClusterModel({{
    required this.no,
    required this.categoryName,
    required this.backendItems,
  }});
}}

class MasterProdukPenjualBackendData {{
  static const String sheetName = "10.PRODUK PENJUAL BACK END";
  static const String sheetTitle = "SEBARAN PRODUK INDUK DAN ANAK (BACK END)";

  static const List<ProductClusterModel> clusters = [
{''.join(dart_clusters)}
  ];
}}
'''

with open('bispira_desktop_admin/lib/data/produk_penjual_backend_data.dart', 'w', encoding='utf-8') as f:
    f.write(dart_code)
print("Saved bispira_desktop_admin/lib/data/produk_penjual_backend_data.dart")

