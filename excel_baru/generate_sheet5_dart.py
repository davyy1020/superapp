import json

with open('excel_baru/sheet5_akumulasi_dana_pencairan.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

items = data['rows']

lines = []
lines.append("import '../models/admin_models.dart';")
lines.append("")
lines.append("/// 68 Master Pencairan Records dari Sheet 5: 5. Akumulasi Dana Pencairan")
lines.append("/// PT. SITEKUN ACADEMY PERDASA - BISPIRA HYPERLOCAL ECOSYSTEM")
lines.append("/// Jadwal Cair: Senin & Kamis (17.00 - 23.59 WIB) | Biaya Transfer: Rp 1.000")
lines.append("/// Total Gross: Rp 30.342.050 | Biaya Trx: Rp 62.500 | Biaya Transfer: Rp 68.000 | Net Diterima: Rp 30.211.550")
lines.append("final List<AkumulasiDanaPencairanModel> initialAkumulasiDanaPencairanList = [")

for it in items:
    lines.append("  AkumulasiDanaPencairanModel(")
    lines.append(f"    no: {it['no']},")
    lines.append(f"    namaPenjualDriver: '{it['nama_penjual_driver']}',")
    lines.append(f"    bankTujuan: '{it['bank_tujuan']}',")
    lines.append(f"    totalHakGross: {float(it['total_hak_gross'])},")
    lines.append(f"    biayaLayananTrx: {float(it['biaya_layanan_trx'])},")
    lines.append(f"    biayaPencairan: {float(it['biaya_pencairan'])},")
    lines.append(f"    jumlahNetDiterima: {float(it['jumlah_net_diterima'])},")
    lines.append(f"    statusEscrow: '{it['status_escrow']}',")
    lines.append("  ),")

lines.append("];")

with open('bispira_desktop_admin/lib/data/akumulasi_dana_pencairan_data.dart', 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines) + '\n')

print(f"Generated bispira_desktop_admin/lib/data/akumulasi_dana_pencairan_data.dart with {len(items)} items.")

