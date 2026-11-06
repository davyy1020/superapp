import json
import os

with open('excel_baru/sheet1_detail_transaksi.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# 1. Save to bispira_admin_web/lib/data/
os.makedirs('bispira_admin_web/lib/data', exist_ok=True)
with open('bispira_admin_web/lib/data/sheet1_detail_transaksi.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2)
print('Saved to bispira_admin_web/lib/data/sheet1_detail_transaksi.json')

# 2. Generate Dart file for bispira_desktop_admin
os.makedirs('bispira_desktop_admin/lib/data', exist_ok=True)
lines = [
    "import '../models/admin_models.dart';",
    "",
    "final List<DetailTransaksiModel> initialDetailTransaksiList = [",
]

for item in data['rows']:
    buyer = item['namaPembeli'].replace("'", "\\'")
    product = item['layananProduk'].replace("'", "\\'")
    seller = item['penjualMerchantDriver'].replace("'", "\\'")
    kab = item['wilayahKabKota'].replace("'", "\\'")
    prov = item['provinsi'].replace("'", "\\'")
    bank = item['bank'].replace("'", "\\'")
    pay = item['metodeBayar'].replace("'", "\\'")

    lines.append("  DetailTransaksiModel(")
    lines.append(f"    no: {item['no']},")
    lines.append(f"    tanggal: '{item['tanggal']}',")
    lines.append(f"    jamWib: '{item['jam']}',")
    lines.append(f"    namaPembeli: '{buyer}',")
    lines.append(f"    layananProduk: '{product}',")
    lines.append(f"    penjualMerchantDriver: '{seller}',")
    lines.append(f"    wilayahKabKota: '{kab}',")
    lines.append(f"    provinsi: '{prov}',")
    lines.append(f"    bank: '{bank}',")
    lines.append(f"    metodeBayar: '{pay}',")
    lines.append(f"    hargaDasar: {item['hargaDasar']},")
    lines.append(f"    markup10: {item['markup10']},")
    lines.append(f"    hargaResmi: {item['hargaResmi']},")
    lines.append(f"    biayaLayanan: {item['biayaLayanan']},")
    lines.append(f"    biayaAplikasi: {item['biayaAplikasi']},")
    lines.append(f"    biayaAngkut: {item['biayaAngkut']},")
    lines.append(f"    kodeUnikBank: {item['kodeUnikBank']},")
    lines.append(f"    totalBayarPembeli: {item['totalBayarPembeli']},")
    lines.append(f"    komisiMarketplace: {item['komisiMarketplace']},")
    lines.append(f"    hakPenjualDriverNet: {item['hakPenjualDriverNet']},")
    lines.append(f"    pusatNetProfit: {item['pusatNetProfit']},")
    lines.append("  ),")

lines.append("];")
lines.append("")

with open('bispira_desktop_admin/lib/data/detail_transaksi_data.dart', 'w', encoding='utf-8') as f:
    f.write("\n".join(lines))
print('Generated bispira_desktop_admin/lib/data/detail_transaksi_data.dart')

