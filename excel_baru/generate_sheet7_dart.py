import json
import openpyxl

wb = openpyxl.load_workbook('excel_baru/Bispira_Hyperlocal_Marketplace_Ledger_Complete_November_2026.xlsx', data_only=True)
ws = wb['7. Bagi Hasil Pusat & Daerah']

rows = []
for r in range(5, 34):
    no = ws.cell(r, 1).value
    kab = ws.cell(r, 2).value
    prov = ws.cell(r, 3).value
    status = ws.cell(r, 4).value
    net_profit = ws.cell(r, 5).value or 0
    porsi_pusat = ws.cell(r, 6).value or 0
    porsi_daerah = ws.cell(r, 7).value or 0
    jadwal = ws.cell(r, 8).value or 'Tgl 1 Awal Bulan'
    
    if no is not None and kab:
        rows.append({
            'no': int(no),
            'wilayahKabKota': str(kab).strip(),
            'provinsi': str(prov).strip(),
            'statusSkemaKerjasama': str(status).strip(),
            'netProfitSuperadmin': float(net_profit),
            'porsiPusat': float(porsi_pusat),
            'porsiAdminDaerah': float(porsi_daerah),
            'jadwalPembayaran': str(jadwal).strip()
        })

total_net = sum(x['netProfitSuperadmin'] for x in rows)
total_pusat = sum(x['porsiPusat'] for x in rows)
total_daerah = sum(x['porsiAdminDaerah'] for x in rows)

data = {
    'title': 'SKEMA BAGI HASIL NET PROFIT SUPERADMIN PUSAT DAN ADMIN DAERAH (75:25, 100:0, 20:80)',
    'subtitle': 'Kerjasama (75%:25%) | Tanpa Kerjasama (100%:0%) | Event Mandiri Daerah (20%:80%) | Dibayarkan Setiap Tanggal 1 Awal Bulan',
    'total': {
        'label': 'TOTAL',
        'total_net_profit_superadmin': total_net,
        'total_porsi_pusat': total_pusat,
        'total_porsi_admin_daerah': total_daerah,
        'total_wilayah': len(rows)
    },
    'skemaMaster': [
        {'id': 1, 'nama': 'Kerjasama Pusat & Daerah (75%:25%)', 'porsiPusat': 75, 'porsiDaerah': 25},
        {'id': 2, 'nama': 'Tanpa Kerjasama (100%:0%)', 'porsiPusat': 100, 'porsiDaerah': 0},
        {'id': 3, 'nama': 'Event Lomba Mandiri Daerah (20%:80%)', 'porsiPusat': 20, 'porsiDaerah': 80},
        {'id': 4, 'nama': 'Evoting Populer Pusat dan Daerah (60%:40%)', 'porsiPusat': 60, 'porsiDaerah': 40},
        {'id': 5, 'nama': 'Evoting Populer Mandiri Pusat (100%:0%)', 'porsiPusat': 100, 'porsiDaerah': 0}
    ],
    'rows': rows
}

# Write JSON seed in excel_baru
with open('excel_baru/sheet7_bagi_hasil_pusat_daerah.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

# Write JSON seed in bispira_admin_web/lib/data
with open('bispira_admin_web/lib/data/sheet7_bagi_hasil_pusat_daerah.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f"Generated {len(rows)} rows for Sheet 7 JSON! Total Net: Rp {total_net:,.2f}")

# Generate Dart data file
dart_lines = []
dart_lines.append("import '../models/admin_models.dart';")
dart_lines.append("")
dart_lines.append("/// 29 Wilayah Kabupaten / Kota dari Sheet 7: 7. Bagi Hasil Pusat & Daerah")
dart_lines.append("/// SKEMA BAGI HASIL NET PROFIT SUPERADMIN PUSAT DAN ADMIN DAERAH (75:25, 100:0, 20:80)")
dart_lines.append(f"/// Total Net Profit: Rp {total_net:,.0f} | Porsi Pusat: Rp {total_pusat:,.2f} | Porsi Daerah: Rp {total_daerah:,.2f}")
dart_lines.append("final List<BagiHasilPusatDaerahModel> initialBagiHasilList = [")

for item in rows:
    dart_lines.append("  BagiHasilPusatDaerahModel(")
    dart_lines.append(f"    no: {item['no']},")
    dart_lines.append(f"    wilayahKabKota: '{item['wilayahKabKota']}',")
    dart_lines.append(f"    provinsi: '{item['provinsi']}',")
    dart_lines.append(f"    statusSkemaKerjasama: '{item['statusSkemaKerjasama']}',")
    dart_lines.append(f"    netProfitSuperadmin: {item['netProfitSuperadmin']},")
    dart_lines.append(f"    porsiPusat: {item['porsiPusat']},")
    dart_lines.append(f"    porsiAdminDaerah: {item['porsiAdminDaerah']},")
    dart_lines.append(f"    jadwalPembayaran: '{item['jadwalPembayaran']}',")
    dart_lines.append("  ),")

dart_lines.append("];")
dart_lines.append("")

with open('bispira_desktop_admin/lib/data/bagi_hasil_pusat_daerah_data.dart', 'w', encoding='utf-8') as f:
    f.write("\n".join(dart_lines))

print("Updated bispira_desktop_admin/lib/data/bagi_hasil_pusat_daerah_data.dart successfully!")

