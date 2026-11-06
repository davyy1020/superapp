import json

with open('excel_baru/sheet6_pencairan_per_bank.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

items = data['rows']

lines = []
lines.append("import '../models/admin_models.dart';")
lines.append("")
lines.append("/// 12 Bank Superadmin Records dari Sheet 6: 6. Pencairan Per Bank")
lines.append("/// PT. SITEKUN ACADEMY PERDASA - BISPIRA HYPERLOCAL ECOSYSTEM")
lines.append("/// REKAPITULASI AKUMULASI PENCAIRAN DANA PER BANK OPERASIONAL SUPERADMIN")
lines.append("/// Total Mitra: 68 | Gross: Rp 30.342.050 | Biaya Trx: Rp 62.500 | Biaya Transfer: Rp 68.000 | Net: Rp 30.211.550")
lines.append("final List<PencairanPerBankModel> initialPencairanPerBankList = [")

for it in items:
    lines.append("  PencairanPerBankModel(")
    lines.append(f"    no: {it['no']},")
    lines.append(f"    namaBank: '{it['nama_bank']}',")
    lines.append(f"    jumlahMitra: {int(it['jumlah_mitra'])},")
    lines.append(f"    totalPencairanGross: {float(it['total_pencairan_gross'])},")
    lines.append(f"    totalBiayaLayananTrx: {float(it['total_biaya_layanan_trx'])},")
    lines.append(f"    totalBiayaPencairan: {float(it['total_biaya_pencairan'])},")
    lines.append(f"    netDisbursement: {float(it['net_disbursement'])},")
    lines.append("  ),")

lines.append("];")

with open('bispira_desktop_admin/lib/data/pencairan_per_bank_data.dart', 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines) + '\n')

print(f"Generated bispira_desktop_admin/lib/data/pencairan_per_bank_data.dart with {len(items)} items.")

