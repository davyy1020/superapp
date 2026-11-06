import json

with open('excel_baru/sheet12_pendapatan_superadmin_matrix.json', 'r', encoding='utf-8') as f:
    data = json.load(f)

dart_code = """// Master Data Sheet PENDAPATAN SUPERADMIN&BAGIHASIL
// Generated automatically from Bispira_Hyperlocal_Marketplace_Ledger_Complete_November_2026.xlsx
// Pedoman Pendapatan Superadmin Per Transaksi & Peta Bagi Hasil Net Profit

class ClusterPendapatanItem {
  final int no;
  final String bidangCluster;
  final String penjual;
  final String hargaDasar;
  final double markup;
  final String markupLabel;
  final String biayaLayanan;
  final int biayaLayananNominal;
  final String biayaAplikasiReguler;
  final int biayaAplikasiRegulerNominal;
  final String biayaAplikasiPremium;
  final int biayaAplikasiPremiumNominal;
  final String kodeUnikBank;
  final String komisi;
  final String komisiLabel;
  final String biayaPencairan;
  final int biayaPencairanNominal;
  final double kerjasamaPusat;
  final double kerjasamaDaerah;
  final double tanpaKerjasamaPusat;
  final double tanpaKerjasamaDaerah;
  final double? eventMandiriPusat;
  final double? eventMandiriDaerah;
  final double? evotingKerjasamaPusat;
  final double? evotingKerjasamaDaerah;
  final double? evotingPusatPusat;
  final double? evotingPusatDaerah;

  const ClusterPendapatanItem({
    required this.no,
    required this.bidangCluster,
    required this.penjual,
    required this.hargaDasar,
    required this.markup,
    required this.markupLabel,
    required this.biayaLayanan,
    required this.biayaLayananNominal,
    required this.biayaAplikasiReguler,
    required this.biayaAplikasiRegulerNominal,
    required this.biayaAplikasiPremium,
    required this.biayaAplikasiPremiumNominal,
    required this.kodeUnikBank,
    required this.komisi,
    required this.komisiLabel,
    required this.biayaPencairan,
    required this.biayaPencairanNominal,
    required this.kerjasamaPusat,
    required this.kerjasamaDaerah,
    required this.tanpaKerjasamaPusat,
    required this.tanpaKerjasamaDaerah,
    this.eventMandiriPusat,
    this.eventMandiriDaerah,
    this.evotingKerjasamaPusat,
    this.evotingKerjasamaDaerah,
    this.evotingPusatPusat,
    this.evotingPusatDaerah,
  });
}

class PendapatanSuperadminMatrixData {
  static const String title = "PEDOMAN PENDAPATAN SUPERADMIN Per Transaksi";
  static const String subtitle = "PETA BAGI HASIL NET PROFIT PUSAT DAN DAERAH";
  static const String sheetName = "PENDAPATAN SUPERADMIN&BAGIHASIL";

  static const List<Map<String, String>> pilarPendapatan = [
    {"no": "1", "name": "MARKUP", "value": "10%", "desc": "Markup harga dari merchant / ride hailing"},
    {"no": "2", "name": "BIAYA LAYANAN", "value": "Rp 500", "desc": "Biaya layanan operasional sistem (bisa diatur per cluster)"},
    {"no": "3", "name": "BIAYA APLIKASI REGULER", "value": "Rp 500", "desc": "Biaya pemeliharaan aplikasi per transaksi reguler"},
    {"no": "4", "name": "BIAYA APLIKASI PREMIUM 30 HARI", "value": "Rp 15.000", "desc": "Langganan 30 hari, bisa pindah dadakan ke premium jika order ramai"},
    {"no": "5", "name": "KODE UNIK BANK", "value": "000-999", "desc": "Verifikasi otomatis 3 digit transfer rekening"},
    {"no": "6", "name": "KOMISI", "value": "1% s.d 7.5% (Donasi 8% akhir)", "desc": "Potongan komisi mitra merchant, driver, donasi"},
    {"no": "7", "name": "BIAYA PENCAIRAN AKUMULASI", "value": "Rp 1.000", "desc": "Biaya transfer penarikan dana per batch"}
  ];

  static const List<Map<String, dynamic>> skemaBagiHasil = [
    {"kode": "KERJASAMA", "pusat": 0.75, "daerah": 0.25, "rasio": "75% : 25%", "desc": "Kerjasama standar Superadmin Pusat & Daerah"},
    {"kode": "TIDAK_ADA_KERJASAMA", "pusat": 1.0, "daerah": 0.0, "rasio": "100% : 0%", "desc": "Tanpa pemegang lisensi daerah aktif (100% Pusat)"},
    {"kode": "EVENT_MANDIRI_DAERAH", "pusat": 0.20, "daerah": 0.80, "rasio": "20% : 80%", "desc": "Event, kompetisi & expo mandiri oleh admin daerah"},
    {"kode": "EVOTING_KERJASAMA", "pusat": 0.60, "daerah": 0.40, "rasio": "60% : 40%", "desc": "E-voting kerjasama kolaborasi pusat dan daerah"},
    {"kode": "EVOTING_PUSAT", "pusat": 1.0, "daerah": 0.0, "rasio": "100% : 0%", "desc": "E-voting skala nasional yang diselenggarakan pusat"}
  ];

  static const List<ClusterPendapatanItem> clusterItems = [
"""

for item in data["matrix"]:
    emp = f"{item['bagi_hasil_event_mandiri']['pusat']}" if item['bagi_hasil_event_mandiri']['pusat'] is not None else "null"
    emd = f"{item['bagi_hasil_event_mandiri']['daerah']}" if item['bagi_hasil_event_mandiri']['daerah'] is not None else "null"
    evkp = f"{item['bagi_hasil_evoting_kerjasama']['pusat']}" if item['bagi_hasil_evoting_kerjasama']['pusat'] is not None else "null"
    evkd = f"{item['bagi_hasil_evoting_kerjasama']['daerah']}" if item['bagi_hasil_evoting_kerjasama']['daerah'] is not None else "null"
    evpp = f"{item['bagi_hasil_evoting_pusat']['pusat']}" if item['bagi_hasil_evoting_pusat']['pusat'] is not None else "null"
    evpd = f"{item['bagi_hasil_evoting_pusat']['daerah']}" if item['bagi_hasil_evoting_pusat']['daerah'] is not None else "null"
    
    dart_code += f"""    ClusterPendapatanItem(
      no: {item['no']},
      bidangCluster: {json.dumps(item['bidang_cluster'])},
      penjual: {json.dumps(item['penjual'])},
      hargaDasar: {json.dumps(item['harga_dasar'])},
      markup: {item['markup']},
      markupLabel: {json.dumps(item['markup_label'])},
      biayaLayanan: {json.dumps(item['biaya_layanan'])},
      biayaLayananNominal: {item['biaya_layanan_nominal']},
      biayaAplikasiReguler: {json.dumps(item['biaya_aplikasi_reguler'])},
      biayaAplikasiRegulerNominal: {item['biaya_aplikasi_reguler_nominal']},
      biayaAplikasiPremium: {json.dumps(item['biaya_aplikasi_premium_30hari'])},
      biayaAplikasiPremiumNominal: {item['biaya_aplikasi_premium_nominal']},
      kodeUnikBank: {json.dumps(item['kode_unik_bank'])},
      komisi: {json.dumps(str(item['komisi']))},
      komisiLabel: {json.dumps(item['komisi_label'])},
      biayaPencairan: {json.dumps(item['biaya_pencairan'])},
      biayaPencairanNominal: {item['biaya_pencairan_nominal']},
      kerjasamaPusat: {item['bagi_hasil_kerjasama']['pusat']},
      kerjasamaDaerah: {item['bagi_hasil_kerjasama']['daerah']},
      tanpaKerjasamaPusat: {item['bagi_hasil_tanpa_kerjasama']['pusat']},
      tanpaKerjasamaDaerah: {item['bagi_hasil_tanpa_kerjasama']['daerah']},
      eventMandiriPusat: {emp},
      eventMandiriDaerah: {emd},
      evotingKerjasamaPusat: {evkp},
      evotingKerjasamaDaerah: {evkd},
      evotingPusatPusat: {evpp},
      evotingPusatDaerah: {evpd},
    ),
"""

dart_code += """  ];
}
"""

with open('bispira_desktop_admin/lib/data/pendapatan_superadmin_matrix_data.dart', 'w', encoding='utf-8') as f:
    f.write(dart_code)

print("Created pendapatan_superadmin_matrix_data.dart successfully.")
