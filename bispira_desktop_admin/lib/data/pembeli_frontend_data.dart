// Generated Master Data for Sheet 11: PEMBELI FRONT END
// Source: Bispira_Hyperlocal_Marketplace_Ledger_Complete_November_2026.xlsx

class FrontendClusterModel {
  final dynamic no;
  final String categoryName;
  final List<String> frontendItems;

  const FrontendClusterModel({
    required this.no,
    required this.categoryName,
    required this.frontendItems,
  });
}

class MasterPembeliFrontendData {
  static const String sheetName = "11. PEMBELI FRONT END";
  static const String sheetTitle = "SEBARAN PRODUK INDUK DAN ANAK (FRON END)";

  // Aturan Khusus Ekosistem Pembeli (Sheet 11)
  static const int donasiBiayaAplikasi = 0;
  static const int donasiBiayaLayanan = 0;
  static const String donasiKetentuan = "Tidak ada biaya layanan, aplikasi. Hanya kode unik 3 digit verifikasi otomatis.";
  static const String iklanCarouselBehavior = "Urutan teratas (1-30) auto-scroll bergeser kiri-kanan otomatis & swipe gestur pembeli.";

  static const List<FrontendClusterModel> clusters = [
    FrontendClusterModel(
      no: 1,
      categoryName: "FOOD & FRESH",
      frontendItems: ["Makanan", "Minuman", "Sayuran", "Buah", "Telor", "Daging (sapi, kambing, ayam)", "Ikan", "apotek"],
    ),    FrontendClusterModel(
      no: 2,
      categoryName: "TIKET EVENT & WISATA",
      frontendItems: ["Event MICE (apasaja)", "Wisata"],
    ),    FrontendClusterModel(
      no: 3,
      categoryName: "HEALTH & HOMECARE",
      frontendItems: ["HEALTH", "Psikiater", "Bidan", "Fisioterapi", "Psikolog", "HOMECARE", "Perawat", "Caregiver", "Child care", "Baby sitter", "Asisten rumah tangga", "BEUTY", "SPA", "BARBERSHOP"],
    ),    FrontendClusterModel(
      no: 4,
      categoryName: "RIDE HAILING",
      frontendItems: ["ANTAR JEMPUT", "Motor (Penumpang, Food,Delivery)", "Mobil (Penumpang)", "Mobil Logistik (Delivery)", "Mobil Logistik Barang Besar", "Mobil Ambulance", "ATRIBUT DRIVER", "Helm", "Jaket", "StIcker", "T-Shirt Polo", "Saldo Wallet", "topup"],
    ),    FrontendClusterModel(
      no: 5,
      categoryName: "SEWA PROPERTY",
      frontendItems: ["Kost", "Kontrakan", "Apartemen", "Working space", "Pakaian Event"],
    ),    FrontendClusterModel(
      no: 6,
      categoryName: "EDUKASI & ENTERTAINMENT, SERVICE",
      frontendItems: ["EDUKASI", "Tutor/Guru Les Privat Pelajaran", "Trainer let privat pelatihan", "Penceramah keagamaan", "ENTERTAINMENT", "MC", "Penyanyi", "Group Band", "SERVICE", "Teknisi AC", "Teknisi Barang Elektronik", "Montir"],
    ),    FrontendClusterModel(
      no: 7,
      categoryName: "DONASI",
      frontendItems: ["Program kegiatan yayasan sosial", "Program kegiatan yayasan Keagamaan", "Program", "Makan gratis anak yatim piatu Rp. 1.000", "Mulai dari : Rp. 2000", "tidak ada biaya layanan, aplikasi", "hanya kode unik"],
    ),    FrontendClusterModel(
      no: 8,
      categoryName: "IKLAN",
      frontendItems: ["Pasang Iklan Banner", "berada urutan teratas (1-30), bergeser dari kiri ke kanan otomatis atau bisa digeser tangan pembeli", "Pasang iklan logo"],
    ),    FrontendClusterModel(
      no: 9,
      categoryName: "BISPIRA EVENT DAERAH",
      frontendItems: ["KOMPETISI", "Pendidikan", "Budaya", "Kesenian"],
    ),    FrontendClusterModel(
      no: 10,
      categoryName: "BISPIRA E-VOTING DAERAH",
      frontendItems: ["E-VOTING", "Pendidikan", "Budaya", "Kesenian"],
    ),    FrontendClusterModel(
      no: 11,
      categoryName: "BISPIRA EVENT PUSAT/ PROVINSI",
      frontendItems: ["KOMPETISI", "Pendidikan", "Budaya", "Kesenian", "Pelatihan", "Sertifikasi Profesi"],
    ),    FrontendClusterModel(
      no: 12,
      categoryName: "BISPIRA E-VOTING PUSAT",
      frontendItems: ["E-VOTING", "Pendidikan", "Budaya", "Kesenian"],
    ),    FrontendClusterModel(
      no: 13,
      categoryName: "PAJAK PENJUAL  (Bulanan/Tahunan)",
      frontendItems: [],
    ),
  ];
}
