/// Model Detail Transaksi (Persis 21 Kolom Sheet 1: 1. Detail Transaksi)
/// PT. SITEKUN ACADEMY PERDASA - BISPIRA HYPERLOCAL ECOSYSTEM
class DetailTransaksiModel {
  final int no;
  final String tanggal;
  final String jamWib;
  final String namaPembeli;
  final String layananProduk;
  final String penjualMerchantDriver;
  final String wilayahKabKota;
  final String provinsi;
  final String bank;
  final String metodeBayar;
  final double hargaDasar;
  final double markup10;
  final double hargaResmi;
  final double biayaLayanan;
  final double biayaAplikasi;
  final double biayaAngkut;
  final int kodeUnikBank;
  final double totalBayarPembeli;
  final double komisiMarketplace;
  final double hakPenjualDriverNet;
  final double pusatNetProfit;

  DetailTransaksiModel({
    required this.no,
    required this.tanggal,
    required this.jamWib,
    required this.namaPembeli,
    required this.layananProduk,
    required this.penjualMerchantDriver,
    required this.wilayahKabKota,
    required this.provinsi,
    required this.bank,
    required this.metodeBayar,
    required this.hargaDasar,
    required this.markup10,
    required this.hargaResmi,
    required this.biayaLayanan,
    required this.biayaAplikasi,
    required this.biayaAngkut,
    required this.kodeUnikBank,
    required this.totalBayarPembeli,
    required this.komisiMarketplace,
    required this.hakPenjualDriverNet,
    required this.pusatNetProfit,
  });

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'tanggal': tanggal,
      'jamWib': jamWib,
      'namaPembeli': namaPembeli,
      'layananProduk': layananProduk,
      'penjualMerchantDriver': penjualMerchantDriver,
      'wilayahKabKota': wilayahKabKota,
      'provinsi': provinsi,
      'bank': bank,
      'metodeBayar': metodeBayar,
      'hargaDasar': hargaDasar,
      'markup10': markup10,
      'hargaResmi': hargaResmi,
      'biayaLayanan': biayaLayanan,
      'biayaAplikasi': biayaAplikasi,
      'biayaAngkut': biayaAngkut,
      'kodeUnikBank': kodeUnikBank,
      'totalBayarPembeli': totalBayarPembeli,
      'komisiMarketplace': komisiMarketplace,
      'hakPenjualDriverNet': hakPenjualDriverNet,
      'pusatNetProfit': pusatNetProfit,
    };
  }
}

/// Model Akumulasi Penjual & Driver (Persis 9 Kolom Sheet 2: 2. Akumulasi Penjual & Driver)
/// PT. SITEKUN ACADEMY PERDASA - BISPIRA HYPERLOCAL ECOSYSTEM
class AkumulasiPenjualDriverModel {
  final int no;
  final String namaPenjualMerchantDriver;
  final String kategoriBisnis;
  final int totalTrx;
  final double akumulasiHargaDasar;
  final double akumulasiBiayaAngkut;
  final double akumulasiKomisiMarketplace;
  final double hakPenjualDriverGross;
  final double biayaSkemaTrxBulanan;

  AkumulasiPenjualDriverModel({
    required this.no,
    required this.namaPenjualMerchantDriver,
    required this.kategoriBisnis,
    required this.totalTrx,
    required this.akumulasiHargaDasar,
    required this.akumulasiBiayaAngkut,
    required this.akumulasiKomisiMarketplace,
    required this.hakPenjualDriverGross,
    required this.biayaSkemaTrxBulanan,
  });

  double get netPayable => (hakPenjualDriverGross - biayaSkemaTrxBulanan) > 0
      ? (hakPenjualDriverGross - biayaSkemaTrxBulanan)
      : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'namaPenjualMerchantDriver': namaPenjualMerchantDriver,
      'kategoriBisnis': kategoriBisnis,
      'totalTrx': totalTrx,
      'akumulasiHargaDasar': akumulasiHargaDasar,
      'akumulasiBiayaAngkut': akumulasiBiayaAngkut,
      'akumulasiKomisiMarketplace': akumulasiKomisiMarketplace,
      'hakPenjualDriverGross': hakPenjualDriverGross,
      'biayaSkemaTrxBulanan': biayaSkemaTrxBulanan,
      'netPayable': netPayable,
    };
  }
}

/// Model Saldo Wallet Driver (Persis 8 Kolom Sheet 3: 3. Saldo Wallet Driver)
/// PT. SITEKUN ACADEMY PERDASA - BISPIRA HYPERLOCAL ECOSYSTEM
/// CLUSTER AKUMULASI SALDO WALLET DRIVER BISPIRA
/// Mekanisme: Top Up Saldo, Potongan Cicilan Atribut (Rp 5.000/hari), dan Potongan Order Cash Pembeli
class SaldoWalletDriverModel {
  final int no;
  final String namaDriver;
  final String modaTransportasi;
  final double totalTopUp;
  final double potonganCicilan;
  final double potonganOrderCash;
  final double komisiPenghasilan;
  final double saldoAkhirWallet;

  SaldoWalletDriverModel({
    required this.no,
    required this.namaDriver,
    required this.modaTransportasi,
    required this.totalTopUp,
    required this.potonganCicilan,
    required this.potonganOrderCash,
    required this.komisiPenghasilan,
    required this.saldoAkhirWallet,
  });

  bool get isMinus => saldoAkhirWallet < 0;
  bool get isBelowMinOrderCash => saldoAkhirWallet < 10000;
  bool get isReadyCash => saldoAkhirWallet >= 10000;

  String get statusKesiapan {
    if (isMinus) return 'MINUS (Perlu Top-Up)';
    if (isBelowMinOrderCash) return 'DI BAWAH BATAS (< Rp 10.000)';
    return 'SIAP CASH & NON-CASH';
  }

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'namaDriver': namaDriver,
      'modaTransportasi': modaTransportasi,
      'totalTopUp': totalTopUp,
      'potonganCicilan': potonganCicilan,
      'potonganOrderCash': potonganOrderCash,
      'komisiPenghasilan': komisiPenghasilan,
      'saldoAkhirWallet': saldoAkhirWallet,
      'isMinus': isMinus,
      'isBelowMinOrderCash': isBelowMinOrderCash,
      'statusKesiapan': statusKesiapan,
    };
  }
}

/// Model Master Rekening Penjual / Toko / Warung / Merchant / Driver (Sheet 4: 4. Master Rekening Penjual)
/// PT. SITEKUN ACADEMY PERDASA - BISPIRA HYPERLOCAL ECOSYSTEM
/// CLUSTER MASTER REKENING TOKO / WARUNG / MERCHANT / DRIVER
class MasterRekeningPenjualModel {
  final int no;
  final String namaTokoWarungDriver;
  final String namaPemilik;
  final String kategoriEntitas;
  final String namaBank;
  final String nomorRekening;
  final String cabangKota;

  MasterRekeningPenjualModel({
    required this.no,
    required this.namaTokoWarungDriver,
    required this.namaPemilik,
    required this.kategoriEntitas,
    required this.namaBank,
    required this.nomorRekening,
    required this.cabangKota,
  });

  bool get isDriver => namaTokoWarungDriver.toLowerCase().contains('driver');

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'namaTokoWarungDriver': namaTokoWarungDriver,
      'namaPemilik': namaPemilik,
      'kategoriEntitas': kategoriEntitas,
      'namaBank': namaBank,
      'nomorRekening': nomorRekening,
      'cabangKota': cabangKota,
      'isDriver': isDriver,
    };
  }
}

/// Model Akumulasi Dana Pencairan (Sheet 5: 5. Akumulasi Dana Pencairan)
/// PT. SITEKUN ACADEMY PERDASA - BISPIRA HYPERLOCAL ECOSYSTEM
/// Jadwal Cair: Senin & Kamis (17.00 - 23.59 WIB) | Biaya Transfer Pencairan: Rp 1.000
class AkumulasiDanaPencairanModel {
  final int no;
  final String namaPenjualDriver;
  final String bankTujuan;
  final double totalHakGross;
  final double biayaLayananTrx;
  final double biayaPencairan;
  final double jumlahNetDiterima;
  String statusEscrow; // 'Ready to Disburse (Escrow Safe)', 'Disbursed / Sudah Ditransfer'
  DateTime? disbursedAt;

  AkumulasiDanaPencairanModel({
    required this.no,
    required this.namaPenjualDriver,
    required this.bankTujuan,
    required this.totalHakGross,
    required this.biayaLayananTrx,
    required this.biayaPencairan,
    required this.jumlahNetDiterima,
    this.statusEscrow = 'Ready to Disburse (Escrow Safe)',
    this.disbursedAt,
  });

  bool get isDisbursed => statusEscrow.contains('Sudah') || statusEscrow.contains('Disbursed');
  bool get isDriver => namaPenjualDriver.toLowerCase().contains('driver');

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'namaPenjualDriver': namaPenjualDriver,
      'bankTujuan': bankTujuan,
      'totalHakGross': totalHakGross,
      'biayaLayananTrx': biayaLayananTrx,
      'biayaPencairan': biayaPencairan,
      'jumlahNetDiterima': jumlahNetDiterima,
      'statusEscrow': statusEscrow,
      'disbursedAt': disbursedAt?.toIso8601String(),
      'isDisbursed': isDisbursed,
      'isDriver': isDriver,
    };
  }
}

/// Model Rekapitulasi Pencairan Per Bank Operasional Superadmin (Sheet 6: 6. Pencairan Per Bank)
/// PT. SITEKUN ACADEMY PERDASA - BISPIRA HYPERLOCAL ECOSYSTEM
/// REKAPITULASI AKUMULASI PENCAIRAN DANA PER BANK OPERASIONAL SUPERADMIN
class PencairanPerBankModel {
  final int no;
  final String namaBank;
  final int jumlahMitra;
  final double totalPencairanGross;
  final double totalBiayaLayananTrx;
  final double totalBiayaPencairan;
  final double netDisbursement;

  PencairanPerBankModel({
    required this.no,
    required this.namaBank,
    required this.jumlahMitra,
    required this.totalPencairanGross,
    required this.totalBiayaLayananTrx,
    required this.totalBiayaPencairan,
    required this.netDisbursement,
  });

  bool get isActive => jumlahMitra > 0;

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'namaBank': namaBank,
      'jumlahMitra': jumlahMitra,
      'totalPencairanGross': totalPencairanGross,
      'totalBiayaLayananTrx': totalBiayaLayananTrx,
      'totalBiayaPencairan': totalBiayaPencairan,
      'netDisbursement': netDisbursement,
      'isActive': isActive,
    };
  }
}

/// Model Bagi Hasil Net Profit Superadmin Pusat dan Admin Daerah (Sheet 7: 7. Bagi Hasil Pusat & Daerah)
/// SKEMA BAGI HASIL NET PROFIT SUPERADMIN PUSAT DAN ADMIN DAERAH (75:25, 100:0, 20:80)
class BagiHasilPusatDaerahModel {
  final int no;
  final String wilayahKabKota;
  final String provinsi;
  final String statusSkemaKerjasama;
  final double netProfitSuperadmin;
  final double porsiPusat;
  final double porsiAdminDaerah;
  final String jadwalPembayaran;

  BagiHasilPusatDaerahModel({
    required this.no,
    required this.wilayahKabKota,
    required this.provinsi,
    required this.statusSkemaKerjasama,
    required this.netProfitSuperadmin,
    required this.porsiPusat,
    required this.porsiAdminDaerah,
    this.jadwalPembayaran = 'Tgl 1 Awal Bulan',
  });

  bool get isKerjasamaPusatDaerah => statusSkemaKerjasama.contains('75%:25%');
  bool get isTanpaKerjasama => statusSkemaKerjasama.contains('100%:0%');
  bool get isEventMandiri => statusSkemaKerjasama.contains('20%:80%');

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'wilayahKabKota': wilayahKabKota,
      'provinsi': provinsi,
      'statusSkemaKerjasama': statusSkemaKerjasama,
      'netProfitSuperadmin': netProfitSuperadmin,
      'porsiPusat': porsiPusat,
      'porsiAdminDaerah': porsiAdminDaerah,
      'jadwalPembayaran': jadwalPembayaran,
    };
  }
}

/// Model Master Profil Pembeli Lisensi Admin Daerah Bispira (Sheet 8: 8. Profil Lisensi Daerah)
/// MASTER PROFIL PEMBELI LISENSI ADMIN DAERAH BISPIRA
class ProfilLisensiDaerahModel {
  final int no;
  final String namaPembeliLisensi;
  final String kabupatenKota;
  final String noWaTelepon;
  final String rekeningBankAktif;
  final String namaPemilikRekening;
  final int jumlahPenjualAktif;
  final int jumlahDriverAktif;
  final int jumlahEventBispira;
  final int jumlahEventKompetisi;
  final int jumlahEventEvoting;

  ProfilLisensiDaerahModel({
    required this.no,
    required this.namaPembeliLisensi,
    required this.kabupatenKota,
    required this.noWaTelepon,
    required this.rekeningBankAktif,
    required this.namaPemilikRekening,
    required this.jumlahPenjualAktif,
    required this.jumlahDriverAktif,
    required this.jumlahEventBispira,
    required this.jumlahEventKompetisi,
    required this.jumlahEventEvoting,
  });

  int get totalEventAktif => jumlahEventBispira + jumlahEventKompetisi + jumlahEventEvoting;

  Map<String, dynamic> toMap() {
    return {
      'no': no,
      'namaPembeliLisensi': namaPembeliLisensi,
      'kabupatenKota': kabupatenKota,
      'noWaTelepon': noWaTelepon,
      'rekeningBankAktif': rekeningBankAktif,
      'namaPemilikRekening': namaPemilikRekening,
      'jumlahPenjualAktif': jumlahPenjualAktif,
      'jumlahDriverAktif': jumlahDriverAktif,
      'jumlahEventBispira': jumlahEventBispira,
      'jumlahEventKompetisi': jumlahEventKompetisi,
      'jumlahEventEvoting': jumlahEventEvoting,
    };
  }
}

/// Transaction Model for Manual Bank Reconciliation (Tanpa Upload Bukti Bayar)
class ManualTransaction {
  final String txId;
  final String customerName;
  final String serviceName;
  final String bankTarget;
  final double basePrice;
  final double markup;
  final double appFee;
  final double serviceFee;
  int uniqueCode;
  final double totalNominal;
  final DateTime createdAt;
  DateTime expiresAt;
  String status; // 'MENUNGGU_MUTASI_BANK', 'LUNAS', 'EXPIRED'

  ManualTransaction({
    required this.txId,
    required this.customerName,
    required this.serviceName,
    required this.bankTarget,
    required this.basePrice,
    required this.markup,
    required this.appFee,
    required this.serviceFee,
    required this.uniqueCode,
    required this.totalNominal,
    required this.createdAt,
    required this.expiresAt,
    this.status = 'MENUNGGU_MUTASI_BANK',
  });
}

/// Admin Configuration Model (Disinkronkan dengan Excel Sheet: 9. Pengaturan Tarif & Fees Revisi)
class AdminConfigModel {
  // 1. Roda 2 Ride Hailing (Motor Penumpang)
  double tariffR2PerKm;
  double minFareR2;
  double commissionR2Percent; // 5%

  // 2. Roda 4 Ride Hailing (Mobil Penumpang)
  double tariffR4PerKm;
  double minFareR4;
  double commissionR4Percent; // 7.5%

  // 3. Roda 2 Food & Logistik Barang Kecil
  double tariffFoodR2PerKm;
  double minFareFoodR2;
  double commissionFoodR2Percent; // 5%

  // 4. Layanan Darurat Khusus Ambulance (0-100KM)
  double ambulanceTariffPerKm; // Rp 5.000 / KM
  double ambulanceMinFare; // Rp 50.000 (< 4 KM)
  double ambulanceAngkutFee; // Rp 50.000
  double ambulanceAngkutCommissionPercent; // 1%

  // 5. Layanan Logistik Barang Besar (Mobil Box, Mobil Bak, Truk L300) (0-100KM)
  double logistikTariffPerKm; // Rp 4.000 / KM
  double logistikMinFare; // Rp 50.000 (< 4 KM)
  double logistikAngkutFee; // Rp 50.000 (jasa angkut / porter ke mobil)
  double logistikAngkutCommissionPercent; // 1%
  double trukL300BaseFee; // Rp 100.000

  // Biaya Layanan Konsumen & Ekosistem
  double appFee; // Rp 500 (Excel baru: Rp 500)
  double serviceFee; // Rp 500 (Excel baru: Rp 500)
  double markupPercent; // 10%
  double merchantCommissionPercent; // 5% (Merchant dapat 95% Barang Dasar)
  double disbursementFee; // Rp 1.000 (Payout Fee)
  double driverChargeFee; // Rp 500 (Reguler per transaksi)
  double driverChargePremiumFee; // Rp 15.000 (Bulanan 30 hari)
  double driverMinWalletBalance; // Rp 10.000 (Syarat minimal saldo terima order cash)

  // Skema Bagi Hasil Wilayah (Dinamis: 75:25, 100:0, 20:80)
  double profitShareCabang; // 25% default
  double skemaKerjasamaPusatPct; // 75%
  double skemaKerjasamaDaerahPct; // 25%
  double skemaTanpaKerjasamaPusatPct; // 100%
  double skemaTanpaKerjasamaDaerahPct; // 0%
  double skemaEventMandiriPusatPct; // 20%
  double skemaEventMandiriDaerahPct; // 80%

  int uniqueCodeDurationMinutes; // 30 Menit

  // Backward compatibility getters & setters
  double get tariffPerKm => tariffR2PerKm;
  set tariffPerKm(double val) => tariffR2PerKm = val;
  double get minFare => minFareR2;
  set minFare(double val) => minFareR2 = val;
  double get ambulanceAntarFee => ambulanceMinFare;
  set ambulanceAntarFee(double val) => ambulanceMinFare = val;

  AdminConfigModel({
    this.tariffR2PerKm = 2500,
    this.minFareR2 = 8000,
    this.commissionR2Percent = 5.0,
    this.tariffR4PerKm = 4000,
    this.minFareR4 = 15000,
    this.commissionR4Percent = 7.5,
    this.tariffFoodR2PerKm = 3000,
    this.minFareFoodR2 = 10000,
    this.commissionFoodR2Percent = 5.0,
    this.ambulanceTariffPerKm = 5000,
    this.ambulanceMinFare = 50000,
    this.ambulanceAngkutFee = 50000,
    this.ambulanceAngkutCommissionPercent = 1.0,
    this.logistikTariffPerKm = 4000,
    this.logistikMinFare = 50000,
    this.logistikAngkutFee = 50000,
    this.logistikAngkutCommissionPercent = 1.0,
    this.trukL300BaseFee = 100000,
    this.appFee = 500,
    this.serviceFee = 500,
    this.markupPercent = 10,
    this.merchantCommissionPercent = 5.0,
    this.disbursementFee = 1000,
    this.driverChargeFee = 500,
    this.driverChargePremiumFee = 15000,
    this.driverMinWalletBalance = 10000,
    this.profitShareCabang = 25,
    this.skemaKerjasamaPusatPct = 75,
    this.skemaKerjasamaDaerahPct = 25,
    this.skemaTanpaKerjasamaPusatPct = 100,
    this.skemaTanpaKerjasamaDaerahPct = 0,
    this.skemaEventMandiriPusatPct = 20,
    this.skemaEventMandiriDaerahPct = 80,
    this.uniqueCodeDurationMinutes = 30,
  });
}

/// Model Data Cabang & Lisensi Franchise (Dari Excel Sheet: Pusat Admin Cabang)
class BranchModel {
  final String branchNo;
  final String kabupaten;
  final String provinsi;
  final String ownerName;
  final String contact;
  final DateTime joinDate;
  final DateTime expireDate;
  final int daysLeftAlarm;
  final String saranaStatus;
  final String licenseStatus; // 'AKTIF', 'PENDING_RENEWAL', 'PUTUS'

  BranchModel({
    required this.branchNo,
    required this.kabupaten,
    required this.provinsi,
    required this.ownerName,
    required this.contact,
    required this.joinDate,
    required this.expireDate,
    required this.daysLeftAlarm,
    required this.saranaStatus,
    required this.licenseStatus,
  });
}

/// Model Data Driver & Atribut (Dari Excel Sheet: Pusat Driver)
class DriverModel {
  final String driverId;
  final String name;
  final String vehicleType; // 'Ride Hailing (Motor)', 'Mobil Penumpang', 'Ambulance'
  final String plateNumber;
  final String phone;
  final String kabupaten;
  final String kycStatus; // 'TERVERIFIKASI', 'PENDING'
  final double walletBalance;
  final String helmetStatus; // 'LUNAS', 'DICICIL'
  final String jacketStatus; // 'LUNAS', 'DICICIL'

  DriverModel({
    required this.driverId,
    required this.name,
    required this.vehicleType,
    required this.plateNumber,
    required this.phone,
    required this.kabupaten,
    required this.kycStatus,
    required this.walletBalance,
    required this.helmetStatus,
    required this.jacketStatus,
  });
}

/// Model Data Merchant (Dari Excel Sheet: Pusat Merchant Food & Health)
class MerchantModel {
  final String merchantId;
  final String storeName;
  final String ownerName;
  final String category; // 'Food & Fresh Sembako', 'Mitra Sehat & Apotek'
  final String kabupaten;
  final double basePriceAvg;
  final double markupPercent;
  final String subscriptionStatus; // 'LUNAS BULANAN', 'PENDING'
  final double accumulatedSales;

  MerchantModel({
    required this.merchantId,
    required this.storeName,
    required this.ownerName,
    required this.category,
    required this.kabupaten,
    required this.basePriceAvg,
    required this.markupPercent,
    required this.subscriptionStatus,
    required this.accumulatedSales,
  });
}

/// Model Data User Pelanggan (Dari Excel Sheet: Pusat User)
class UserModel {
  final String userId;
  final String fullName;
  final String phone;
  final String email;
  final String kabupaten;
  final String provinsi;
  final String status;

  UserModel({
    required this.userId,
    required this.fullName,
    required this.phone,
    required this.email,
    required this.kabupaten,
    required this.provinsi,
    required this.status,
  });
}

/// Model Pencairan Dana Merchant / Toko (Batch Payout 17:00 WIB)
class StorePayoutModel {
  final String payoutId;
  final String merchantId;
  final String storeName;
  final String ownerName;
  final String category;
  final String kabupaten;
  final String bankName;
  final String accountNumber;
  final String accountHolder;
  final double accumulatedSales2Days;
  final double disbursementFee;
  String status; // 'PENDING_1700', 'SUDAH_DITRANSFER'
  DateTime? transferredAt;

  StorePayoutModel({
    required this.payoutId,
    required this.merchantId,
    required this.storeName,
    required this.ownerName,
    required this.category,
    required this.kabupaten,
    required this.bankName,
    required this.accountNumber,
    required this.accountHolder,
    required this.accumulatedSales2Days,
    required this.disbursementFee,
    this.status = 'PENDING_1700',
    this.transferredAt,
  });

  double get netPayable => (accumulatedSales2Days - disbursementFee) > 0
      ? (accumulatedSales2Days - disbursementFee)
      : 0.0;
}

