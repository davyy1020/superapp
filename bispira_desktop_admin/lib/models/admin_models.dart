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

/// Admin Configuration Model
class AdminConfigModel {
  double tariffPerKm;
  double minFare;
  double appFee;
  double serviceFee;
  double markupPercent;
  double disbursementFee;
  double driverChargeFee;
  double ambulanceAntarFee;
  double ambulanceAngkutFee;
  double profitShareCabang;
  int uniqueCodeDurationMinutes;

  AdminConfigModel({
    this.tariffPerKm = 2500,
    this.minFare = 8000,
    this.appFee = 1000,
    this.serviceFee = 2000,
    this.markupPercent = 10,
    this.disbursementFee = 1000,
    this.driverChargeFee = 500,
    this.ambulanceAntarFee = 150000,
    this.ambulanceAngkutFee = 50000,
    this.profitShareCabang = 30,
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

