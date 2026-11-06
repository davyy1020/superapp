import json

with open('excel_baru/sheet4_master_rekening_penjual.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

items = data['rows']

lines = []
lines.append("import '../models/admin_models.dart';")
lines.append("")
lines.append("/// 68 Master Rekening Records dari Sheet 4: 4. Master Rekening Penjual")
lines.append("/// PT. SITEKUN ACADEMY PERDASA - BISPIRA HYPERLOCAL ECOSYSTEM")
lines.append("/// CLUSTER MASTER REKENING TOKO / WARUNG / MERCHANT / DRIVER")
lines.append("final List<MasterRekeningPenjualModel> initialMasterRekeningPenjualList = [")

for it in items:
    lines.append("  MasterRekeningPenjualModel(")
    lines.append(f"    no: {it['no']},")
    lines.append(f"    namaTokoWarungDriver: '{it['nama_toko_warung_driver']}',")
    lines.append(f"    namaPemilik: '{it['nama_pemilik']}',")
    lines.append(f"    kategoriEntitas: '{it['kategori_entitas']}',")
    lines.append(f"    namaBank: '{it['nama_bank']}',")
    lines.append(f"    nomorRekening: '{it['nomor_rekening']}',")
    lines.append(f"    cabangKota: '{it['cabang_kota']}',")
    lines.append("  ),")

lines.append("];")

with open('bispira_desktop_admin/lib/data/master_rekening_penjual_data.dart', 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines) + '\n')

print(f"Generated bispira_desktop_admin/lib/data/master_rekening_penjual_data.dart with {len(items)} items.")

