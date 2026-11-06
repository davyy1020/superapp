import json
import os

with open('excel_baru/sheet2_akumulasi_penjual_driver.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

# 1. Save to bispira_admin_web/lib/data/
os.makedirs('bispira_admin_web/lib/data', exist_ok=True)
with open('bispira_admin_web/lib/data/sheet2_akumulasi_penjual_driver.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2)
print('Saved to bispira_admin_web/lib/data/sheet2_akumulasi_penjual_driver.json')

# 2. Generate Dart file for bispira_desktop_admin
os.makedirs('bispira_desktop_admin/lib/data', exist_ok=True)
lines = [
    "import '../models/admin_models.dart';",
    "",
    "final List<AkumulasiPenjualDriverModel> initialAkumulasiPenjualDriverList = [",
]

for item in data['rows']:
    nama = item['namaPenjualMerchantDriver'].replace("'", "\\'")
    kat = item['kategoriBisnis'].replace("'", "\\'")

    lines.append("  AkumulasiPenjualDriverModel(")
    lines.append(f"    no: {item['no']},")
    lines.append(f"    namaPenjualMerchantDriver: '{nama}',")
    lines.append(f"    kategoriBisnis: '{kat}',")
    lines.append(f"    totalTrx: {item['totalTrx']},")
    lines.append(f"    akumulasiHargaDasar: {item['akumulasiHargaDasar']},")
    lines.append(f"    akumulasiBiayaAngkut: {item['akumulasiBiayaAngkut']},")
    lines.append(f"    akumulasiKomisiMarketplace: {item['akumulasiKomisiMarketplace']},")
    lines.append(f"    hakPenjualDriverGross: {item['hakPenjualDriverGross']},")
    lines.append(f"    biayaSkemaTrxBulanan: {item['biayaSkemaTrxBulanan']},")
    lines.append("  ),")

lines.append("];")
lines.append("")

with open('bispira_desktop_admin/lib/data/akumulasi_penjual_driver_data.dart', 'w', encoding='utf-8') as f:
    f.write("\n".join(lines))
print('Generated bispira_desktop_admin/lib/data/akumulasi_penjual_driver_data.dart')

