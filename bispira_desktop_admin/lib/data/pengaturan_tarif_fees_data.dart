// Generated Master Data for Sheet 9: Pengaturan Tarif & Fees Revisi
// Source: Bispira_Hyperlocal_Marketplace_Ledger_Complete_November_2026.xlsx

class TariffZoneModel {
  final String zona;
  final double batasBawah;
  final double batasAtas;

  const TariffZoneModel({
    required this.zona,
    required this.batasBawah,
    required this.batasAtas,
  });
}

class RideHailingTariffModel {
  final String id;
  final String name;
  final String vehicleType;
  final double tarifPerKm;
  final double minFare;
  final double markupPercent;
  final List<TariffZoneModel> zonasi;
  final double chargeReguler;
  final double chargePremium30Hari;
  final String nominalKodeUnik;
  final double driverSharePercent;
  final double platformCommissionPercent;
  final double? biayaAngkut;
  final double? komisiAngkutPercent;

  const RideHailingTariffModel({
    required this.id,
    required this.name,
    required this.vehicleType,
    required this.tarifPerKm,
    required this.minFare,
    required this.markupPercent,
    this.zonasi = const [],
    required this.chargeReguler,
    required this.chargePremium30Hari,
    required this.nominalKodeUnik,
    required this.driverSharePercent,
    required this.platformCommissionPercent,
    this.biayaAngkut,
    this.komisiAngkutPercent,
  });
}

class MasterTariffAndFeesData {
  static const String sheetName = "9. Pengaturan Tarif & Fees";
  static const String sheetTitle = "PENGATURAN TARIF & FEES REVISI";

  // Section A: Parameter Perjalanan & Ride Hailing
  static const List<RideHailingTariffModel> rideHailingList = [
    RideHailingTariffModel(
      id: "r2_passenger",
      name: "Parameter Perjalanan & Ride Hailing roda 2",
      vehicleType: "MOTORCYCLE",
      tarifPerKm: 2500,
      minFare: 8000,
      markupPercent: 10.0,
      zonasi: [
        TariffZoneModel(zona: "Wilayah I (Sumatera, Jawa, Bali)", batasBawah: 2000, batasAtas: 2500),
        TariffZoneModel(zona: "Wilayah II (Jabodetabek)", batasBawah: 2500, batasAtas: 2800),
        TariffZoneModel(zona: "Wilayah III (Kalimantan, Sulawesi, NTT, NTB, Maluku, Papua)", batasBawah: 2300, batasAtas: 2750),
      ],
      chargeReguler: 500,
      chargePremium30Hari: 15000,
      nominalKodeUnik: "000-999",
      driverSharePercent: 95.0,
      platformCommissionPercent: 5.0,
    ),
    RideHailingTariffModel(
      id: "r4_passenger",
      name: "Parameter Perjalanan & Ride Hailing roda 4",
      vehicleType: "CAR",
      tarifPerKm: 4000,
      minFare: 15000,
      markupPercent: 10.0,
      zonasi: [
        TariffZoneModel(zona: "Wilayah I (Sumatera, Jawa, Bali)", batasBawah: 6000, batasAtas: 3500),
        TariffZoneModel(zona: "Wilayah II (Jabodetabek)", batasBawah: 6500, batasAtas: 3750),
      ],
      chargeReguler: 500,
      chargePremium30Hari: 15000,
      nominalKodeUnik: "000-999",
      driverSharePercent: 90.0,
      platformCommissionPercent: 10.0,
    ),
    RideHailingTariffModel(
      id: "r2_food_logistik",
      name: "Parameter Perjalanan & Ride Hailing FOOD & Logistik Barang Kecil roda 2",
      vehicleType: "MOTORCYCLE_FOOD",
      tarifPerKm: 3000,
      minFare: 10000,
      markupPercent: 10.0,
      chargeReguler: 500,
      chargePremium30Hari: 15000,
      nominalKodeUnik: "000-999",
      driverSharePercent: 95.0,
      platformCommissionPercent: 5.0,
    ),
    RideHailingTariffModel(
      id: "ambulance",
      name: "Layanan Darurat Khusus Ambulance",
      vehicleType: "AMBULANCE",
      tarifPerKm: 5000,
      minFare: 50000,
      markupPercent: 10.0,
      biayaAngkut: 50000,
      komisiAngkutPercent: 1.0,
      chargeReguler: 500,
      chargePremium30Hari: 15000,
      nominalKodeUnik: "000-999",
      driverSharePercent: 92.5,
      platformCommissionPercent: 7.5,
    ),
    RideHailingTariffModel(
      id: "logistik_barang_besar",
      name: "Layanan Logistik barang besar (mobil box, mobil bak)",
      vehicleType: "CAR_LOGISTICS",
      tarifPerKm: 4000,
      minFare: 50000,
      markupPercent: 10.0,
      biayaAngkut: 50000,
      komisiAngkutPercent: 1.0,
      chargeReguler: 500,
      chargePremium30Hari: 15000,
      nominalKodeUnik: "000-999",
      driverSharePercent: 92.5,
      platformCommissionPercent: 7.5,
    ),
  ];

  // Section B: Merchant
  static const double merchantMarkupPercent = 10.0;
  static const double merchantCommissionPercent = 5.0;
  static const double merchantNetSharePercent = 95.0;
  static const double merchantChargeReguler = 500.0;
  static const double merchantChargePremium30Hari = 15000.0;
  static const double merchantBranchSharePercent = 30.0;

  // Section C: Biaya Layanan Konsumen & Ekosistem
  static const double appFee = 500.0;
  static const double serviceFee = 500.0;
  static const String nominalKodeUnikRange = "000-999";
  static const int masaBerlakuKodeUnikMenit = 30;
  static const double payoutFee = 1000.0;

  // Section D: Bagi Hasil Cabang & Validasi Keuangan
  static const double profitShareCabangPercent = 25.0;
  static const double profitSharePusatPercent = 75.0;
  static const double eventMandiriCabangPercent = 80.0;
  static const double eventMandiriPusatPercent = 20.0;
  static const double eventNasionalCabangPercent = 10.0;
  static const double eventNasionalPusatPercent = 90.0;
  static const String jadwalPembayaran = "Tgl 1 Awal Bulan";
}
