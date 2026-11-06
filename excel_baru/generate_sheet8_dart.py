import json
import openpyxl

wb = openpyxl.load_workbook('excel_baru/Bispira_Hyperlocal_Marketplace_Ledger_Complete_November_2026.xlsx', data_only=True)
ws = wb['8. Profil Lisensi Daerah']

rows = []
for r in range(5, 17):
    no = ws.cell(r, 1).value
    nama = ws.cell(r, 2).value
    kab = ws.cell(r, 3).value
    wa = ws.cell(r, 4).value or '6221'
    bank = ws.cell(r, 5).value
    pemilik = ws.cell(r, 6).value
    penjual = ws.cell(r, 7).value or 0
    driver = ws.cell(r, 8).value or 0
    event_bispira = ws.cell(r, 9).value or 0
    event_kompetisi = ws.cell(r, 10).value or 0
    event_evoting = ws.cell(r, 11).value or 0
    
    if no is not None and nama:
        rows.append({
            'no': int(no),
            'namaPembeliLisensi': str(nama).strip(),
            'kabupatenKota': str(kab).strip(),
            'noWaTelepon': str(wa).strip(),
            'rekeningBankAktif': str(bank).strip(),
            'namaPemilikRekening': str(pemilik).strip(),
            'jumlahPenjualAktif': int(penjual),
            'jumlahDriverAktif': int(driver),
            'jumlahEventBispira': int(event_bispira),
            'jumlahEventKompetisi': int(event_kompetisi),
            'jumlahEventEvoting': int(event_evoting),
            'totalEvent': int(event_bispira) + int(event_kompetisi) + int(event_evoting)
        })

total_penjual = sum(x['jumlahPenjualAktif'] for x in rows)
total_driver = sum(x['jumlahDriverAktif'] for x in rows)
total_event_bispira = sum(x['jumlahEventBispira'] for x in rows)
total_event_kompetisi = sum(x['jumlahEventKompetisi'] for x in rows)
total_event_evoting = sum(x['jumlahEventEvoting'] for x in rows)
total_event_all = sum(x['totalEvent'] for x in rows)

data = {
    'title': 'MASTER PROFIL PEMBELI LISENSI ADMIN DAERAH BISPIRA',
    'subtitle': 'Data Pemegang Lisensi Resmi Kabupaten/Kota Aktif',
    'total': {
        'label': 'TOTAL',
        'totalLisensi': len(rows),
        'totalPenjualAktif': total_penjual,
        'totalDriverAktif': total_driver,
        'totalEventBispira': total_event_bispira,
        'totalEventKompetisi': total_event_kompetisi,
        'totalEventEvoting': total_event_evoting,
        'totalSemuaEvent': total_event_all
    },
    'rows': rows
}

# Write JSON seed in excel_baru
with open('excel_baru/sheet8_profil_lisensi_daerah.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

# Write JSON seed in bispira_admin_web/lib/data
with open('bispira_admin_web/lib/data/sheet8_profil_lisensi_daerah.json', 'w', encoding='utf-8') as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

print(f"Generated {len(rows)} rows for Sheet 8 JSON! Penjual: {total_penjual}, Driver: {total_driver}, Total Event: {total_event_all}")

# Generate Dart data file
dart_lines = []
dart_lines.append("import '../models/admin_models.dart';")
dart_lines.append("")
dart_lines.append("/// 12 Lisensi Admin Daerah dari Sheet 8: 8. Profil Lisensi Daerah")
dart_lines.append("/// MASTER PROFIL PEMBELI LISENSI ADMIN DAERAH BISPIRA")
dart_lines.append(f"/// Total: {len(rows)} Lisensi • {total_penjual} Toko • {total_driver} Driver • {total_event_all} Event")
dart_lines.append("final List<ProfilLisensiDaerahModel> initialProfilLisensiDaerahList = [")

for item in rows:
    dart_lines.append("  ProfilLisensiDaerahModel(")
    dart_lines.append(f"    no: {item['no']},")
    dart_lines.append(f"    namaPembeliLisensi: '{item['namaPembeliLisensi']}',")
    dart_lines.append(f"    kabupatenKota: '{item['kabupatenKota']}',")
    dart_lines.append(f"    noWaTelepon: '{item['noWaTelepon']}',")
    dart_lines.append(f"    rekeningBankAktif: '{item['rekeningBankAktif']}',")
    dart_lines.append(f"    namaPemilikRekening: '{item['namaPemilikRekening']}',")
    dart_lines.append(f"    jumlahPenjualAktif: {item['jumlahPenjualAktif']},")
    dart_lines.append(f"    jumlahDriverAktif: {item['jumlahDriverAktif']},")
    dart_lines.append(f"    jumlahEventBispira: {item['jumlahEventBispira']},")
    dart_lines.append(f"    jumlahEventKompetisi: {item['jumlahEventKompetisi']},")
    dart_lines.append(f"    jumlahEventEvoting: {item['jumlahEventEvoting']},")
    dart_lines.append("  ),")

dart_lines.append("];")
dart_lines.append("")

with open('bispira_desktop_admin/lib/data/profil_lisensi_daerah_data.dart', 'w', encoding='utf-8') as f:
    f.write("\n".join(dart_lines))

print("Updated bispira_desktop_admin/lib/data/profil_lisensi_daerah_data.dart successfully!")
