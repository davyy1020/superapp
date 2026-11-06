import json
import os

sheet9_dict = {
    "sheet_name": "9. Pengaturan Tarif & Fees",
    "title": "PENGATURAN TARIF & FEES REVISI",
    "section_a_ride_hailing": [
        {
            "id": "r2_passenger",
            "name": "Parameter Perjalanan & Ride Hailing roda 2",
            "vehicle_type": "MOTORCYCLE",
            "tarif_per_km": 2500,
            "biaya_min_perjalanan_3km": 8000,
            "markup_persen": 10.0,
            "zonasi_wilayah": [
                {
                    "zona": "Wilayah I (Sumatera, Jawa, Bali)",
                    "batas_bawah": 2000,
                    "batas_atas": 2500
                },
                {
                    "zona": "Wilayah II (Jabodetabek)",
                    "batas_bawah": 2500,
                    "batas_atas": 2800
                },
                {
                    "zona": "Wilayah III (Kalimantan, Sulawesi, NTT, NTB, Maluku, Papua)",
                    "batas_bawah": 2300,
                    "batas_atas": 2750
                }
            ],
            "charge_driver_reguler": 500,
            "charge_driver_premium_30hari": 15000,
            "nominal_kode_unik": "000-999",
            "driver_share_percent": 95.0,
            "platform_commission_percent": 5.0
        },
        {
            "id": "r4_passenger",
            "name": "Parameter Perjalanan & Ride Hailing roda 4",
            "vehicle_type": "CAR",
            "tarif_per_km": 4000,
            "biaya_min_perjalanan_3km": 15000,
            "markup_persen": 10.0,
            "zonasi_wilayah": [
                {
                    "zona": "Wilayah I (Sumatera, Jawa, Bali)",
                    "batas_bawah": 6000,
                    "batas_atas": 3500
                },
                {
                    "zona": "Wilayah II (Jabodetabek)",
                    "batas_bawah": 6500,
                    "batas_atas": 3750
                }
            ],
            "charge_driver_reguler": 500,
            "charge_driver_premium_30hari": 15000,
            "nominal_kode_unik": "000-999",
            "driver_share_percent": 90.0,
            "platform_commission_percent": 10.0
        },
        {
            "id": "r2_food_logistik",
            "name": "Parameter Perjalanan & Ride Hailing FOOD & Logistik Barang Kecil roda 2",
            "vehicle_type": "MOTORCYCLE_FOOD",
            "tarif_per_km": 3000,
            "biaya_min_perjalanan_3km": 10000,
            "markup_persen": 10.0,
            "charge_driver_reguler": 500,
            "charge_driver_premium_30hari": 15000,
            "nominal_kode_unik": "000-999",
            "driver_share_percent": 95.0,
            "platform_commission_percent": 5.0
        },
        {
            "id": "ambulance",
            "name": "Layanan Darurat Khusus Ambulance",
            "vehicle_type": "AMBULANCE",
            "biaya_antar_dasar_per_km": 5000,
            "biaya_min_perjalanan_4km": 50000,
            "biaya_angkut_medis_pasien": 50000,
            "markup_persen": 10.0,
            "komisi_angkut_pasien_persen": 1.0,
            "charge_driver_reguler": 500,
            "charge_driver_premium_30hari": 15000,
            "nominal_kode_unik": "000-999",
            "driver_share_percent": 92.5,
            "platform_commission_percent": 7.5
        },
        {
            "id": "logistik_barang_besar",
            "name": "Layanan Logistik barang besar (mobil box, mobil bak)",
            "vehicle_type": "CAR_LOGISTICS",
            "biaya_antar_dasar_per_km": 4000,
            "biaya_min_perjalanan_4km": 50000,
            "biaya_angkut_barang": 50000,
            "markup_persen": 10.0,
            "komisi_angkut_barang_persen": 1.0,
            "charge_driver_reguler": 500,
            "charge_driver_premium_30hari": 15000,
            "nominal_kode_unik": "000-999",
            "driver_share_percent": 92.5,
            "platform_commission_percent": 7.5
        }
    ],
    "section_b_merchant": {
        "categories": [
            "Food & Fresh Sembako",
            "Event MICE & Wisata",
            "Sertifikasi Profesi",
            "Homecare & Beauty",
            "Sewa Property",
            "Edukasi, Entertainment & Service"
        ],
        "markup_harga_dasar_persen": 10.0,
        "komisi_penjualan_persen": 5.0,
        "hak_merchant_persen": 95.0,
        "charge_merchant_reguler": 500,
        "charge_merchant_premium_30hari": 15000,
        "porsi_cabang_wilayah_persen": 30.0
    },
    "section_c_biaya_layanan_konsumen_ekosistem": {
        "biaya_aplikasi_konsumen": 500,
        "biaya_layanan_platform": 500,
        "nominal_kode_unik_range": "000-999",
        "masa_berlaku_kode_unik_menit": 30,
        "biaya_pencairan_penjual_payout_fee": 1000,
        "charge_driver_merchant_reguler": 500,
        "charge_driver_merchant_premium_30hari": 15000,
        "biaya_komisi_driver_r2_merchant_persen": 5.0,
        "biaya_komisi_driver_r4_persen": 7.5
    },
    "section_d_bagi_hasil_cabang": {
        "profit_share_cabang_wilayah_persen": 25.0,
        "profit_share_pusat_persen": 75.0,
        "event_mandiri_cabang_wilayah_persen": 80.0,
        "event_mandiri_pusat_persen": 20.0,
        "event_nasional_cabang_persen": 10.0,
        "event_nasional_pusat_persen": 90.0,
        "jadwal_pembayaran": "Tgl 1 Awal Bulan",
        "masa_berlaku_kode_unik": "30 Menit"
    },
    "revenue_stream_matrix": {
        "pembeli": [
            { "item": "1. Markup", "keterangan": "10% dari Harga Dasar (Jarak / Produk)" },
            { "item": "2. Biaya Layanan", "keterangan": "Biaya Layanan (Rp 500) + Biaya Aplikasi (Rp 500)" }
        ],
        "penjual_driver_merchant": [
            { "item": "1. Komisi", "keterangan": "5% (R2 & Merchant), 7.5% (R4), 1% (Jasa Angkut Pasien/Barang)" },
            { "item": "2. Transaksi", "keterangan": "Reguler (Rp 500 / order) atau Opsi Premium (Rp 15.000 / 30 hari)" }
        ]
    }
}

# 1. Write to excel_baru
with open('excel_baru/sheet9_pengaturan_tarif_fees.json', 'w', encoding='utf-8') as f:
    json.dump(sheet9_dict, f, indent=2, ensure_ascii=False)
print("Saved excel_baru/sheet9_pengaturan_tarif_fees.json")

# 2. Write to bispira_admin_web/lib/data
with open('bispira_admin_web/lib/data/sheet9_pengaturan_tarif_fees.json', 'w', encoding='utf-8') as f:
    json.dump(sheet9_dict, f, indent=2, ensure_ascii=False)
print("Saved bispira_admin_web/lib/data/sheet9_pengaturan_tarif_fees.json")

# 3. Generate bispira_desktop_admin/lib/data/pengaturan_tarif_fees_data.dart
dart_code = f'''// Generated Master Data for Sheet 9: Pengaturan Tarif & Fees Revisi
// Source: Bispira_Hyperlocal_Marketplace_Ledger_Complete_November_2026.xlsx

class TariffZoneModel {{
  final String zona;
  final double batasBawah;
  final double batasAtas;

  const TariffZoneModel({{
    required this.zona,
    required this.batasBawah,
    required this.batasAtas,
  }});
}}

class RideHailingTariffModel {{
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

  const RideHailingTariffModel({{
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
  }});
}}

class MasterTariffAndFeesData {{
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
}}
'''

with open('bispira_desktop_admin/lib/data/pengaturan_tarif_fees_data.dart', 'w', encoding='utf-8') as f:
    f.write(dart_code)
print("Saved bispira_desktop_admin/lib/data/pengaturan_tarif_fees_data.dart")

