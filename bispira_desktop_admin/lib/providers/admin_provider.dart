import 'dart:math';
import 'package:flutter/material.dart';
import '../models/admin_models.dart';

class AdminProvider with ChangeNotifier {
  final AdminConfigModel config = AdminConfigModel();

  bool _isDarkMode = false;
  bool get isDarkMode => _isDarkMode;

  Color _accentColor = const Color(0xFF0066FF); // Default BISPIRA Blue
  Color get accentColor => _accentColor;
  String _themePresetName = 'Royal Blue';
  String get themePresetName => _themePresetName;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    addLog('[THEME] Mode tampilan diubah ke ${_isDarkMode ? 'Mode Gelap (Dark Mode)' : 'Mode Terang (Light Mode)'}', type: 'info');
    notifyListeners();
  }

  void setAccentTheme(String name, Color color) {
    _accentColor = color;
    _themePresetName = name;
    addLog('[THEME] Warna Aksen Aplikasi diubah ke $name', type: 'info');
    notifyListeners();
  }

  final double _userWalletBalance = 150000;
  double _driverWalletBalance = 120000;
  final double _platformRevenue = 48250000;
  double _sellerAccumulatedFunds = 450000;

  final int _totalUsers = 12450;
  final int _totalDrivers = 1840;
  final int _driversOnline = 245;

  // 1. Data Verifikasi Mutasi Bank (Manual Reconciliation)
  final List<ManualTransaction> _pendingTransactions = [
    ManualTransaction(
      txId: 'TX-9901',
      customerName: 'Davy Wahyu',
      serviceName: 'Go-Food (Ayam Geprek)',
      bankTarget: 'BNI 1888898006 (a/n BISPIRA)',
      basePrice: 18000,
      markup: 1800,
      appFee: 1000,
      serviceFee: 2000,
      uniqueCode: 123,
      totalNominal: 22923,
      createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
      expiresAt: DateTime.now().add(const Duration(minutes: 25)),
      status: 'MENUNGGU_MUTASI_BANK',
    ),
    ManualTransaction(
      txId: 'TX-9902',
      customerName: 'Rina Kartika',
      serviceName: 'Ride Hailing (Sudirman-Monas)',
      bankTarget: 'BCA 778009988 (a/n BISPIRA)',
      basePrice: 25000,
      markup: 2500,
      appFee: 1000,
      serviceFee: 2000,
      uniqueCode: 456,
      totalNominal: 30956,
      createdAt: DateTime.now().subtract(const Duration(minutes: 12)),
      expiresAt: DateTime.now().add(const Duration(minutes: 18)),
      status: 'MENUNGGU_MUTASI_BANK',
    ),
    ManualTransaction(
      txId: 'TX-9903',
      customerName: 'Ahmad Fauzi',
      serviceName: 'Go-Health (Apotek Obat)',
      bankTarget: 'Mandiri 1370098877 (a/n BISPIRA)',
      basePrice: 45000,
      markup: 4500,
      appFee: 1000,
      serviceFee: 2000,
      uniqueCode: 789,
      totalNominal: 53289,
      createdAt: DateTime.now().subtract(const Duration(minutes: 20)),
      expiresAt: DateTime.now().add(const Duration(minutes: 10)),
      status: 'MENUNGGU_MUTASI_BANK',
    ),
    ManualTransaction(
      txId: 'TX-9899',
      customerName: 'Maya Indah',
      serviceName: 'Ambulance Call Service',
      bankTarget: 'BRI 0206010099 (a/n BISPIRA)',
      basePrice: 200000,
      markup: 0,
      appFee: 1000,
      serviceFee: 2000,
      uniqueCode: 105,
      totalNominal: 203105,
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
      expiresAt: DateTime.now().subtract(const Duration(minutes: 30)),
      status: 'LUNAS',
    ),
  ];

  // 2. Data Cabang Lisensi Franchise (Pusat Admin Cabang)
  final List<BranchModel> _branches = [
    BranchModel(
      branchNo: 'CBG-001',
      kabupaten: 'Jakarta Selatan',
      provinsi: 'DKI Jakarta',
      ownerName: 'H. Bambang Sugianto',
      contact: '0812-9876-5432',
      joinDate: DateTime(2025, 1, 15),
      expireDate: DateTime(2027, 1, 15),
      daysLeftAlarm: 310,
      saranaStatus: 'Lengkap (Kantor, Komputer, Gudang, Meja CS)',
      licenseStatus: 'AKTIF',
    ),
    BranchModel(
      branchNo: 'CBG-002',
      kabupaten: 'Kota Surabaya',
      provinsi: 'Jawa Timur',
      ownerName: 'Ir. Hendro Wijaya',
      contact: '0813-1122-3344',
      joinDate: DateTime(2025, 2, 10),
      expireDate: DateTime(2026, 10, 10),
      daysLeftAlarm: 30,
      saranaStatus: 'Lengkap (Kantor, Komputer, Gudang, QRIS Stand)',
      licenseStatus: 'PENDING_RENEWAL',
    ),
    BranchModel(
      branchNo: 'CBG-003',
      kabupaten: 'Kota Bandung',
      provinsi: 'Jawa Barat',
      ownerName: 'Drs. Asep Sunandar',
      contact: '0815-5566-7788',
      joinDate: DateTime(2025, 3, 5),
      expireDate: DateTime(2027, 3, 5),
      daysLeftAlarm: 358,
      saranaStatus: 'Lengkap (Kantor, Komputer, Gudang)',
      licenseStatus: 'AKTIF',
    ),
    BranchModel(
      branchNo: 'CBG-004',
      kabupaten: 'Kota Medan',
      provinsi: 'Sumatera Utara',
      ownerName: 'Torkis Harahap, SE',
      contact: '0821-4433-2211',
      joinDate: DateTime(2025, 4, 20),
      expireDate: DateTime(2027, 4, 20),
      daysLeftAlarm: 404,
      saranaStatus: 'Lengkap (Kantor, Komputer, Gudang, QRIS)',
      licenseStatus: 'AKTIF',
    ),
  ];

  // 3. Data Driver Nasional
  final List<DriverModel> _drivers = [
    DriverModel(
      driverId: 'DRV-001',
      name: 'Budi Santoso',
      vehicleType: 'Ride Hailing (Motor)',
      plateNumber: 'B 4567 TKR',
      phone: '0812-3456-7890',
      kabupaten: 'Jakarta Selatan',
      kycStatus: 'TERVERIFIKASI',
      walletBalance: 120000,
      helmetStatus: 'LUNAS',
      jacketStatus: 'LUNAS',
    ),
    DriverModel(
      driverId: 'DRV-002',
      name: 'Anto Wijaya',
      vehicleType: 'Ride Hailing (Motor)',
      plateNumber: 'B 1234 ABC',
      phone: '0813-9988-7766',
      kabupaten: 'Jakarta Selatan',
      kycStatus: 'PENDING',
      walletBalance: 50000,
      helmetStatus: 'DICICIL',
      jacketStatus: 'DICICIL',
    ),
    DriverModel(
      driverId: 'DRV-003',
      name: 'Rahmat Hidayat',
      vehicleType: 'Mobil Penumpang (Car)',
      plateNumber: 'B 8899 XYZ',
      phone: '0857-1122-3344',
      kabupaten: 'Kota Surabaya',
      kycStatus: 'TERVERIFIKASI',
      walletBalance: 350000,
      helmetStatus: 'N/A',
      jacketStatus: 'LUNAS',
    ),
    DriverModel(
      driverId: 'DRV-004',
      name: 'Dr. Slamet (Ambulance)',
      vehicleType: 'Ambulance Medis',
      plateNumber: 'B 9110 AMB',
      phone: '0811-911-911',
      kabupaten: 'Jakarta Selatan',
      kycStatus: 'TERVERIFIKASI',
      walletBalance: 500000,
      helmetStatus: 'N/A',
      jacketStatus: 'N/A',
    ),
  ];

  // 4. Data Merchant Food & Health
  final List<MerchantModel> _merchants = [
    MerchantModel(
      merchantId: 'MCH-001',
      storeName: 'Senopati Resto (Ayam Geprek)',
      ownerName: 'Ibu Ratna',
      category: 'Food & Fresh Sembako',
      kabupaten: 'Jakarta Selatan',
      basePriceAvg: 18000,
      markupPercent: 10,
      subscriptionStatus: 'LUNAS BULANAN',
      accumulatedSales: 450000,
    ),
    MerchantModel(
      merchantId: 'MCH-002',
      storeName: 'Apotek Kimia Farma Benhil',
      ownerName: 'Apoteker Farida',
      category: 'Mitra Sehat & Apotek',
      kabupaten: 'Jakarta Pusat',
      basePriceAvg: 45000,
      markupPercent: 10,
      subscriptionStatus: 'LUNAS BULANAN',
      accumulatedSales: 890000,
    ),
    MerchantModel(
      merchantId: 'MCH-003',
      storeName: 'Toko Sembako Berkah Utama',
      ownerName: 'Pak Haji Kohar',
      category: 'Food & Fresh Sembako',
      kabupaten: 'Kota Bandung',
      basePriceAvg: 25000,
      markupPercent: 10,
      subscriptionStatus: 'LUNAS BULANAN',
      accumulatedSales: 1200000,
    ),
  ];

  // 4b. Data Pencairan Dana Merchant (Batch Payout 17:00 WIB per Toko)
  final List<StorePayoutModel> _storePayouts = [
    StorePayoutModel(
      payoutId: 'PAY-8801',
      merchantId: 'MCH-001',
      storeName: 'Senopati Resto (Ayam Geprek)',
      ownerName: 'Ibu Ratna',
      category: 'Food & Fresh Sembako',
      kabupaten: 'Jakarta Selatan',
      bankName: 'BCA',
      accountNumber: '883-0918-293',
      accountHolder: 'a/n Senopati Resto',
      accumulatedSales2Days: 450000,
      disbursementFee: 1000,
      status: 'PENDING_1700',
    ),
    StorePayoutModel(
      payoutId: 'PAY-8802',
      merchantId: 'MCH-002',
      storeName: 'Apotek Kimia Farma Benhil',
      ownerName: 'Apoteker Farida',
      category: 'Mitra Sehat & Apotek',
      kabupaten: 'Jakarta Pusat',
      bankName: 'Bank Mandiri',
      accountNumber: '137-0098-877',
      accountHolder: 'a/n Kimia Farma Benhil',
      accumulatedSales2Days: 890000,
      disbursementFee: 1000,
      status: 'PENDING_1700',
    ),
    StorePayoutModel(
      payoutId: 'PAY-8803',
      merchantId: 'MCH-003',
      storeName: 'Toko Sembako Berkah Utama',
      ownerName: 'Pak Haji Kohar',
      category: 'Food & Fresh Sembako',
      kabupaten: 'Kota Bandung',
      bankName: 'Bank BRI',
      accountNumber: '0206-0100-888',
      accountHolder: 'a/n Berkah Utama Sembako',
      accumulatedSales2Days: 1200000,
      disbursementFee: 1000,
      status: 'PENDING_1700',
    ),
    StorePayoutModel(
      payoutId: 'PAY-8804',
      merchantId: 'MCH-004',
      storeName: 'Kedai Kopi Bispira Specialty',
      ownerName: 'Hendra Wijaya',
      category: 'Food & Fresh Sembako',
      kabupaten: 'Kota Surabaya',
      bankName: 'Bank BNI',
      accountNumber: '0891-2345-678',
      accountHolder: 'a/n Kedai Kopi Bispira',
      accumulatedSales2Days: 650000,
      disbursementFee: 1000,
      status: 'PENDING_1700',
    ),
    StorePayoutModel(
      payoutId: 'PAY-8805',
      merchantId: 'MCH-005',
      storeName: 'Warung Madura Bispira Express',
      ownerName: 'Pak Cak Mat',
      category: 'Food & Fresh Sembako',
      kabupaten: 'Jakarta Selatan',
      bankName: 'BCA',
      accountNumber: '7780-0998-11',
      accountHolder: 'a/n Warung Madura Express',
      accumulatedSales2Days: 320000,
      disbursementFee: 1000,
      status: 'SUDAH_DITRANSFER',
      transferredAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
  ];


  // 5. Data User Nasional
  final List<UserModel> _users = [
    UserModel(
      userId: 'USR-001',
      fullName: 'Davy Wahyu Saputra',
      phone: '0818-8888-9999',
      email: 'davy@bispira.id',
      kabupaten: 'Jakarta Selatan',
      provinsi: 'DKI Jakarta',
      status: 'e-KYC Verified',
    ),
    UserModel(
      userId: 'USR-002',
      fullName: 'Rina Kartika',
      phone: '0812-4455-6677',
      email: 'rina@gmail.com',
      kabupaten: 'Jakarta Pusat',
      provinsi: 'DKI Jakarta',
      status: 'e-KYC Verified',
    ),
    UserModel(
      userId: 'USR-003',
      fullName: 'Ahmad Fauzi',
      phone: '0813-7788-9900',
      email: 'fauzi@yahoo.com',
      kabupaten: 'Kota Surabaya',
      provinsi: 'Jawa Timur',
      status: 'e-KYC Verified',
    ),
  ];

  // Audit Logs
  final List<Map<String, String>> _auditLogs = [
    {
      'time': '07:35:10',
      'text': 'Bispira Desktop Admin Suite v2.4 (Flutter Native) diinisialisasi.',
      'type': 'info'
    },
    {
      'time': '07:35:12',
      'text': 'Data Master Excel loaded: 4 Cabang Lisensi, 4 Driver, 3 Merchant, 3 User, 4 Transaksi Pending.',
      'type': 'success'
    },
  ];

  // Getters
  AdminConfigModel get currentConfig => config;
  double get userWalletBalance => _userWalletBalance;
  double get driverWalletBalance => _driverWalletBalance;
  double get platformRevenue => _platformRevenue;
  double get sellerAccumulatedFunds => _sellerAccumulatedFunds;
  int get totalUsers => _totalUsers;
  int get totalDrivers => _totalDrivers;
  int get driversOnline => _driversOnline;

  List<ManualTransaction> get pendingTransactions => List.unmodifiable(_pendingTransactions);
  List<BranchModel> get branches => List.unmodifiable(_branches);
  List<DriverModel> get drivers => List.unmodifiable(_drivers);
  List<MerchantModel> get merchants => List.unmodifiable(_merchants);
  List<StorePayoutModel> get storePayouts => List.unmodifiable(_storePayouts);
  List<UserModel> get users => List.unmodifiable(_users);
  List<Map<String, String>> get auditLogs => List.unmodifiable(_auditLogs);

  void addLog(String message, {String type = 'info'}) {
    final now = DateTime.now();
    final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
    _auditLogs.insert(0, {'time': timeStr, 'text': message, 'type': type});
    notifyListeners();
  }

  void updateConfig({
    required double tariffPerKm,
    required double minFare,
    required double appFee,
    required double serviceFee,
    required double markupPercent,
    required double disbursementFee,
    required double driverChargeFee,
    required double ambulanceAntarFee,
    required double ambulanceAngkutFee,
    required double profitShareCabang,
    required int uniqueCodeDurationMinutes,
  }) {
    config.tariffPerKm = tariffPerKm;
    config.minFare = minFare;
    config.appFee = appFee;
    config.serviceFee = serviceFee;
    config.markupPercent = markupPercent;
    config.disbursementFee = disbursementFee;
    config.driverChargeFee = driverChargeFee;
    config.ambulanceAntarFee = ambulanceAntarFee;
    config.ambulanceAngkutFee = ambulanceAngkutFee;
    config.profitShareCabang = profitShareCabang;
    config.uniqueCodeDurationMinutes = uniqueCodeDurationMinutes;

    addLog(
      '[FLUTTER DESKTOP ADMIN] Parameter disimpam: Tarif/KM=Rp${tariffPerKm.toInt()}, AppFee=Rp${appFee.toInt()}, ServiceFee=Rp${serviceFee.toInt()}, Markup=$markupPercent%, DisbursementFee=Rp${disbursementFee.toInt()}, DriverCharge=Rp${driverChargeFee.toInt()}, AmbulanceAntar=Rp${ambulanceAntarFee.toInt()}, AmbulanceAngkut=Rp${ambulanceAngkutFee.toInt()}, ProfitCabang=$profitShareCabang%, TimerKode=${uniqueCodeDurationMinutes}m',
      type: 'success',
    );
    notifyListeners();
  }

  void confirmManualPayment(String txId) {
    final index = _pendingTransactions.indexWhere((tx) => tx.txId == txId);
    if (index != -1) {
      final tx = _pendingTransactions[index];
      tx.status = 'LUNAS';

      // Potong Charge Driver Rp 500
      _driverWalletBalance = max(0, _driverWalletBalance - config.driverChargeFee);
      // Akumulasi Saldo Penjual (Harga Dasar)
      _sellerAccumulatedFunds += tx.basePrice;

      addLog(
        '[FLUTTER DESKTOP ADMIN RECONCILIATION] Pembayaran #${tx.txId} sebesar Rp ${tx.totalNominal.toInt()} TERVERIFIKASI MANUAL via Mutasi Bank. Charge Driver Rp ${config.driverChargeFee.toInt()} dipotong. Saldo dasar penjual (+Rp ${tx.basePrice.toInt()}) diakumulasi untuk batch 17:00 WIB.',
        type: 'success',
      );
      notifyListeners();
    }
  }

  void refreshUniqueCode(String txId) {
    final index = _pendingTransactions.indexWhere((tx) => tx.txId == txId);
    if (index != -1) {
      final newCode = 100 + Random().nextInt(899);
      _pendingTransactions[index].uniqueCode = newCode;
      _pendingTransactions[index].expiresAt = DateTime.now().add(Duration(minutes: config.uniqueCodeDurationMinutes));

      addLog(
        '[FLUTTER DESKTOP ADMIN] Kode Unik transaksi #$txId diperbarui menjadi +$newCode. Timer ${config.uniqueCodeDurationMinutes}m direset.',
        type: 'info',
      );
      notifyListeners();
    }
  }

  void confirmStorePayout(String payoutId) {
    final index = _storePayouts.indexWhere((p) => p.payoutId == payoutId);
    if (index != -1) {
      final payout = _storePayouts[index];
      payout.status = 'SUDAH_DITRANSFER';
      payout.transferredAt = DateTime.now();
      _sellerAccumulatedFunds = max(0, _sellerAccumulatedFunds - payout.accumulatedSales2Days);

      addLog(
        '[MANUAL STORE PAYOUT] Transfer manual ke ${payout.storeName} (${payout.bankName} ${payout.accountNumber}) sebesar Netto Rp ${payout.netPayable.toInt()} (Gross: Rp ${payout.accumulatedSales2Days.toInt()} - Fee: Rp ${payout.disbursementFee.toInt()}) BERHASIL DIKONFIRMASI.',
        type: 'success',
      );
      notifyListeners();
    }
  }

  void confirmAllPendingStorePayouts() {
    int count = 0;
    double totalNet = 0;
    for (var payout in _storePayouts) {
      if (payout.status == 'PENDING_1700') {
        payout.status = 'SUDAH_DITRANSFER';
        payout.transferredAt = DateTime.now();
        totalNet += payout.netPayable;
        count++;
      }
    }
    _sellerAccumulatedFunds = 0;

    if (count > 0) {
      addLog(
        '[BATCH STORE PAYOUT 17:00 WIB] Transfer massal $count Toko/Mitra berhasil diproses! Total Netto Ditransaksikan: Rp ${totalNet.toInt()}.',
        type: 'success',
      );
    }
    notifyListeners();
  }

  Map<String, double>? triggerBatchPayout1700() {
    if (_sellerAccumulatedFunds <= 0) return null;

    final gross = _sellerAccumulatedFunds;
    final fee = config.disbursementFee;
    final net = max(0.0, gross - fee);

    confirmAllPendingStorePayouts();

    return {'gross': gross, 'fee': fee, 'net': net};
  }

  void clearLogs() {
    _auditLogs.clear();
    notifyListeners();
  }

  // --- Manual Transaction CRUD ---
  void addManualTx(ManualTransaction tx) {
    _pendingTransactions.insert(0, tx);
    addLog('[MANUAL RECONCILIATION] Transaksi baru #${tx.txId} (${tx.customerName} - ${tx.serviceName}) sebesar Rp ${tx.totalNominal.toInt()} ditambahkan.', type: 'info');
    notifyListeners();
  }

  void editManualTx(String txId, {required String customerName, required String serviceName, required double basePrice, required String bankTarget}) {
    final idx = _pendingTransactions.indexWhere((t) => t.txId == txId);
    if (idx != -1) {
      final old = _pendingTransactions[idx];
      final newTotal = basePrice + old.markup + old.appFee + old.serviceFee + old.uniqueCode;
      _pendingTransactions[idx] = ManualTransaction(
        txId: old.txId,
        customerName: customerName,
        serviceName: serviceName,
        bankTarget: bankTarget,
        basePrice: basePrice,
        markup: old.markup,
        appFee: old.appFee,
        serviceFee: old.serviceFee,
        uniqueCode: old.uniqueCode,
        totalNominal: newTotal,
        createdAt: old.createdAt,
        expiresAt: old.expiresAt,
        status: old.status,
      );
      addLog('[MANUAL RECONCILIATION] Detail transaksi #$txId diperbarui. Total baru: Rp ${newTotal.toInt()}.', type: 'info');
      notifyListeners();
    }
  }

  void deleteManualTx(String txId) {
    _pendingTransactions.removeWhere((t) => t.txId == txId);
    addLog('[MANUAL RECONCILIATION] Transaksi #$txId telah dihapus dari daftar.', type: 'warning');
    notifyListeners();
  }

  // --- Store Payout CRUD ---
  void addStorePayout(StorePayoutModel payout) {
    _storePayouts.insert(0, payout);
    addLog('[BATCH PAYOUT] Pengajuan payout baru #${payout.payoutId} (${payout.storeName}) sebesar Rp ${payout.accumulatedSales2Days.toInt()} dibuat.', type: 'info');
    notifyListeners();
  }

  void editStorePayout(String payoutId, {required String bankName, required String accountNumber, required String accountHolder, required double grossSales}) {
    final idx = _storePayouts.indexWhere((p) => p.payoutId == payoutId);
    if (idx != -1) {
      final old = _storePayouts[idx];
      _storePayouts[idx] = StorePayoutModel(
        payoutId: old.payoutId,
        merchantId: old.merchantId,
        storeName: old.storeName,
        ownerName: old.ownerName,
        category: old.category,
        kabupaten: old.kabupaten,
        bankName: bankName,
        accountNumber: accountNumber,
        accountHolder: accountHolder,
        accumulatedSales2Days: grossSales,
        disbursementFee: old.disbursementFee,
        status: old.status,
        transferredAt: old.transferredAt,
      );
      addLog('[BATCH PAYOUT] Payout #$payoutId (${old.storeName}) diperbarui: $bankName $accountNumber.', type: 'info');
      notifyListeners();
    }
  }

  void deleteStorePayout(String payoutId) {
    _storePayouts.removeWhere((p) => p.payoutId == payoutId);
    addLog('[BATCH PAYOUT] Data payout #$payoutId telah dihapus.', type: 'warning');
    notifyListeners();
  }

  // --- Driver Management Actions ---
  void addDriver(DriverModel driver) {
    _drivers.add(driver);
    addLog('[MASTER DRIVER] Driver baru #${driver.driverId} (${driver.name} - ${driver.vehicleType}) berhasil ditambahkan.', type: 'success');
    notifyListeners();
  }

  void editDriver(String driverId, {required String name, required String vehicleType, required String plateNumber, required String phone, required String kabupaten}) {
    final idx = _drivers.indexWhere((d) => d.driverId == driverId);
    if (idx != -1) {
      final old = _drivers[idx];
      _drivers[idx] = DriverModel(
        driverId: old.driverId,
        name: name,
        vehicleType: vehicleType,
        plateNumber: plateNumber,
        phone: phone,
        kabupaten: kabupaten,
        kycStatus: old.kycStatus,
        walletBalance: old.walletBalance,
        helmetStatus: old.helmetStatus,
        jacketStatus: old.jacketStatus,
      );
      addLog('[MASTER DRIVER] Data driver #$driverId ($name) berhasil diperbarui.', type: 'info');
      notifyListeners();
    }
  }

  void deleteDriver(String driverId) {
    final idx = _drivers.indexWhere((d) => d.driverId == driverId);
    if (idx != -1) {
      final name = _drivers[idx].name;
      _drivers.removeAt(idx);
      addLog('[MASTER DRIVER] Driver #$driverId ($name) telah dihapus dari sistem.', type: 'warning');
      notifyListeners();
    }
  }

  void verifyDriverKYC(String driverId) {
    final idx = _drivers.indexWhere((d) => d.driverId == driverId);
    if (idx != -1) {
      final old = _drivers[idx];
      _drivers[idx] = DriverModel(
        driverId: old.driverId,
        name: old.name,
        vehicleType: old.vehicleType,
        plateNumber: old.plateNumber,
        phone: old.phone,
        kabupaten: old.kabupaten,
        kycStatus: 'TERVERIFIKASI',
        walletBalance: old.walletBalance,
        helmetStatus: old.helmetStatus,
        jacketStatus: old.jacketStatus,
      );
      addLog('[MASTER DRIVER] Verification e-KYC driver #${old.driverId} (${old.name}) DISETUJUI.', type: 'success');
      notifyListeners();
    }
  }

  void topUpDriverWallet(String driverId, double amount) {
    final idx = _drivers.indexWhere((d) => d.driverId == driverId);
    if (idx != -1) {
      final old = _drivers[idx];
      final newBal = old.walletBalance + amount;
      _drivers[idx] = DriverModel(
        driverId: old.driverId,
        name: old.name,
        vehicleType: old.vehicleType,
        plateNumber: old.plateNumber,
        phone: old.phone,
        kabupaten: old.kabupaten,
        kycStatus: old.kycStatus,
        walletBalance: newBal,
        helmetStatus: old.helmetStatus,
        jacketStatus: old.jacketStatus,
      );
      addLog('[MASTER DRIVER] Top up saldo driver #${old.driverId} (${old.name}) sebesar Rp ${amount.toInt()} berhasil. Saldo baru: Rp ${newBal.toInt()}.', type: 'success');
      notifyListeners();
    }
  }

  void updateDriverAttributes(String driverId, String helmetStatus, String jacketStatus) {
    final idx = _drivers.indexWhere((d) => d.driverId == driverId);
    if (idx != -1) {
      final old = _drivers[idx];
      _drivers[idx] = DriverModel(
        driverId: old.driverId,
        name: old.name,
        vehicleType: old.vehicleType,
        plateNumber: old.plateNumber,
        phone: old.phone,
        kabupaten: old.kabupaten,
        kycStatus: old.kycStatus,
        walletBalance: old.walletBalance,
        helmetStatus: helmetStatus,
        jacketStatus: jacketStatus,
      );
      addLog('[MASTER DRIVER] Status atribut driver #${old.driverId} diperbarui: Helm=$helmetStatus, Jaket=$jacketStatus.', type: 'info');
      notifyListeners();
    }
  }

  // --- Merchant Management Actions ---
  void addMerchant(MerchantModel merchant) {
    _merchants.add(merchant);
    addLog('[MASTER MERCHANT] Merchant baru #${merchant.merchantId} (${merchant.storeName}) berhasil didaftarkan.', type: 'success');
    notifyListeners();
  }

  void editMerchant(String merchantId, {required String storeName, required String ownerName, required String category, required String kabupaten, required double basePriceAvg}) {
    final idx = _merchants.indexWhere((m) => m.merchantId == merchantId);
    if (idx != -1) {
      final old = _merchants[idx];
      _merchants[idx] = MerchantModel(
        merchantId: old.merchantId,
        storeName: storeName,
        ownerName: ownerName,
        category: category,
        kabupaten: kabupaten,
        basePriceAvg: basePriceAvg,
        markupPercent: old.markupPercent,
        subscriptionStatus: old.subscriptionStatus,
        accumulatedSales: old.accumulatedSales,
      );
      addLog('[MASTER MERCHANT] Data merchant #$merchantId ($storeName) diperbarui.', type: 'info');
      notifyListeners();
    }
  }

  void deleteMerchant(String merchantId) {
    final idx = _merchants.indexWhere((m) => m.merchantId == merchantId);
    if (idx != -1) {
      final name = _merchants[idx].storeName;
      _merchants.removeAt(idx);
      addLog('[MASTER MERCHANT] Merchant #$merchantId ($name) telah dihapus.', type: 'warning');
      notifyListeners();
    }
  }

  void updateMerchantMarkup(String merchantId, double newMarkup) {
    final idx = _merchants.indexWhere((m) => m.merchantId == merchantId);
    if (idx != -1) {
      final old = _merchants[idx];
      _merchants[idx] = MerchantModel(
        merchantId: old.merchantId,
        storeName: old.storeName,
        ownerName: old.ownerName,
        category: old.category,
        kabupaten: old.kabupaten,
        basePriceAvg: old.basePriceAvg,
        markupPercent: newMarkup,
        subscriptionStatus: old.subscriptionStatus,
        accumulatedSales: old.accumulatedSales,
      );
      addLog('[MASTER MERCHANT] Markup merchant #${old.merchantId} (${old.storeName}) diubah ke $newMarkup%.', type: 'info');
      notifyListeners();
    }
  }

  // --- Branch Management Actions ---
  void addBranch(BranchModel branch) {
    _branches.add(branch);
    addLog('[CABANG FRANCHISE] Cabang baru #${branch.branchNo} (${branch.kabupaten}) berhasil diaktifkan.', type: 'success');
    notifyListeners();
  }

  void editBranch(String branchNo, {required String kabupaten, required String provinsi, required String ownerName, required String contact, required String saranaStatus}) {
    final idx = _branches.indexWhere((b) => b.branchNo == branchNo);
    if (idx != -1) {
      final old = _branches[idx];
      _branches[idx] = BranchModel(
        branchNo: old.branchNo,
        kabupaten: kabupaten,
        provinsi: provinsi,
        ownerName: ownerName,
        contact: contact,
        joinDate: old.joinDate,
        expireDate: old.expireDate,
        daysLeftAlarm: old.daysLeftAlarm,
        saranaStatus: saranaStatus,
        licenseStatus: old.licenseStatus,
      );
      addLog('[CABANG FRANCHISE] Cabang #$branchNo ($kabupaten) diperbarui.', type: 'info');
      notifyListeners();
    }
  }

  void deleteBranch(String branchNo) {
    final idx = _branches.indexWhere((b) => b.branchNo == branchNo);
    if (idx != -1) {
      final kab = _branches[idx].kabupaten;
      _branches.removeAt(idx);
      addLog('[CABANG FRANCHISE] Cabang #$branchNo ($kab) telah dihapus.', type: 'warning');
      notifyListeners();
    }
  }

  void renewBranchLicense(String branchNo, int years) {
    final idx = _branches.indexWhere((b) => b.branchNo == branchNo);
    if (idx != -1) {
      final old = _branches[idx];
      final newExp = DateTime(old.expireDate.year + years, old.expireDate.month, old.expireDate.day);
      final newDaysLeft = newExp.difference(DateTime.now()).inDays;
      _branches[idx] = BranchModel(
        branchNo: old.branchNo,
        kabupaten: old.kabupaten,
        provinsi: old.provinsi,
        ownerName: old.ownerName,
        contact: old.contact,
        joinDate: old.joinDate,
        expireDate: newExp,
        daysLeftAlarm: newDaysLeft,
        saranaStatus: old.saranaStatus,
        licenseStatus: 'AKTIF',
      );
      addLog('[CABANG FRANCHISE] Perpanjangan lisensi #${old.branchNo} (${old.kabupaten}) selama $years tahun sukses. Kadaluarsa baru: ${newExp.day}/${newExp.month}/${newExp.year}.', type: 'success');
      notifyListeners();
    }
  }

  // --- User Management Actions ---
  void addUser(UserModel user) {
    _users.add(user);
    addLog('[MASTER USER] User baru #${user.userId} (${user.fullName}) berhasil ditambahkan.', type: 'success');
    notifyListeners();
  }

  void editUser(String userId, {required String fullName, required String phone, required String email, required String kabupaten, required String provinsi}) {
    final idx = _users.indexWhere((u) => u.userId == userId);
    if (idx != -1) {
      final old = _users[idx];
      _users[idx] = UserModel(
        userId: old.userId,
        fullName: fullName,
        phone: phone,
        email: email,
        kabupaten: kabupaten,
        provinsi: provinsi,
        status: old.status,
      );
      addLog('[MASTER USER] Data user #$userId ($fullName) diperbarui.', type: 'info');
      notifyListeners();
    }
  }

  void deleteUser(String userId) {
    final idx = _users.indexWhere((u) => u.userId == userId);
    if (idx != -1) {
      final name = _users[idx].fullName;
      _users.removeAt(idx);
      addLog('[MASTER USER] Pelanggan #$userId ($name) dihapus dari sistem.', type: 'warning');
      notifyListeners();
    }
  }

  void toggleUserKYC(String userId) {
    final idx = _users.indexWhere((u) => u.userId == userId);
    if (idx != -1) {
      final old = _users[idx];
      final newStatus = old.status == 'e-KYC Verified' ? 'e-KYC Pending' : 'e-KYC Verified';
      _users[idx] = UserModel(
        userId: old.userId,
        fullName: old.fullName,
        phone: old.phone,
        email: old.email,
        kabupaten: old.kabupaten,
        provinsi: old.provinsi,
        status: newStatus,
      );
      addLog('[MASTER USER] Status e-KYC user #${old.userId} (${old.fullName}) diubah menjadi $newStatus.', type: 'info');
      notifyListeners();
    }
  }

  // --- GIS Fraud Simulation ---
  void triggerFakeGPSAlert(String driverId) {
    addLog('[SUSPENDED / FAKE GPS] TERDETEKSI LOKASI PALSU (Fake GPS) pada Driver #$driverId! Akses order ditangguhkan secara otomatis oleh sistem GIS.', type: 'warning');
    notifyListeners();
  }
}



