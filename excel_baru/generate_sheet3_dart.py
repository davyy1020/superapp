import json

with open('excel_baru/sheet3_saldo_wallet_driver.json', 'r', encoding='utf-8') as f:
    items = json.load(f)

lines = []
lines.append("import '../models/admin_models.dart';")
lines.append("")
lines.append("/// 50 Master Driver Records dari Sheet 3: 3. Saldo Wallet Driver")
lines.append("/// PT. SITEKUN ACADEMY PERDASA - BISPIRA HYPERLOCAL ECOSYSTEM")
lines.append("/// CLUSTER AKUMULASI SALDO WALLET DRIVER BISPIRA")
lines.append("/// Total Top Up: Rp 1.750.000 | Cicilan: Rp 45.000 | Cash: Rp 873.075 | Komisi: Rp 4.491.050 | Saldo Akhir: Rp 5.322.975")
lines.append("final List<SaldoWalletDriverModel> initialSaldoWalletDriverList = [")

for it in items:
    lines.append("  SaldoWalletDriverModel(")
    lines.append(f"    no: {it['no']},")
    lines.append(f"    namaDriver: '{it['nama_driver']}',")
    lines.append(f"    modaTransportasi: '{it['moda_transportasi']}',")
    lines.append(f"    totalTopUp: {float(it['total_topup'])},")
    lines.append(f"    potonganCicilan: {float(it['potongan_cicilan'])},")
    lines.append(f"    potonganOrderCash: {float(it['potongan_order_cash'])},")
    lines.append(f"    komisiPenghasilan: {float(it['komisi_penghasilan'])},")
    lines.append(f"    saldoAkhirWallet: {float(it['saldo_akhir_wallet'])},")
    lines.append("  ),")

lines.append("];")

with open('bispira_desktop_admin/lib/data/saldo_wallet_driver_data.dart', 'w', encoding='utf-8') as f:
    f.write('\n'.join(lines) + '\n')

print(f"Generated bispira_desktop_admin/lib/data/saldo_wallet_driver_data.dart with {len(items)} items.")

