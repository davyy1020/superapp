import 'dart:math';
import 'package:flutter/material.dart';
import '../models/admin_models.dart';
import '../data/detail_transaksi_data.dart';
import '../data/akumulasi_penjual_driver_data.dart';
import '../data/saldo_wallet_driver_data.dart';
import '../data/master_rekening_penjual_data.dart';
import '../data/akumulasi_dana_pencairan_data.dart';
import '../data/pencairan_per_bank_data.dart';
import '../data/bagi_hasil_pusat_daerah_data.dart';
import '../data/profil_lisensi_daerah_data.dart';

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

  // Master Detail Transaksi (Persis 21 Kolom Sheet 1: 1. Detail Transaksi)
  final List<DetailTransaksiModel> _ledgerTransactions = List.from(initialDetailTransaksiList);
  List<DetailTransaksiModel> get ledgerTransactions => List.unmodifiable(_ledgerTransactions);

  double get totalLedgerHargaDasar => _ledgerTransactions.fold(0.0, (s, e) => s + e.hargaDasar);
  double get totalLedgerHargaResmi => _ledgerTransactions.fold(0.0, (s, e) => s + e.hargaResmi);
  double get totalLedgerBayarPembeli => _ledgerTransactions.fold(0.0, (s, e) => s + e.totalBayarPembeli);
  double get totalLedgerKomisi => _ledgerTransactions.fold(0.0, (s, e) => s + e.komisiMarketplace);
  double get totalLedgerHakPenjual => _ledgerTransactions.fold(0.0, (s, e) => s + e.hakPenjualDriverNet);
  double get totalLedgerPusatNet => _ledgerTransactions.fold(0.0, (s, e) => s + e.pusatNetProfit);

  void addLedgerTransaction(DetailTransaksiModel tx) {
    _ledgerTransactions.insert(0, tx);
    addLog('[LEDGER] Transaksi Baru #${tx.no} (${tx.layananProduk}) berhasil dicatat ke Ledger Real-Time.', type: 'success');
    notifyListeners();
  }

  // Master Akumulasi Penjual & Driver (Persis 9 Kolom Sheet 2: 2. Akumulasi Penjual & Driver)
  final List<AkumulasiPenjualDriverModel> _akumulasiList = List.from(initialAkumulasiPenjualDriverList);
  List<AkumulasiPenjualDriverModel> get akumulasiList => List.unmodifiable(_akumulasiList);

  int get totalAkumulasiMitra => _akumulasiList.length;
  int get totalAkumulasiTrx => _akumulasiList.fold(0, (s, e) => s + e.totalTrx);
  double get totalAkumulasiHargaDasar => _akumulasiList.fold(0.0, (s, e) => s + e.akumulasiHargaDasar);
  double get totalAkumulasiBiayaAngkut => _akumulasiList.fold(0.0, (s, e) => s + e.akumulasiBiayaAngkut);
  double get totalAkumulasiKomisi => _akumulasiList.fold(0.0, (s, e) => s + e.akumulasiKomisiMarketplace);
  double get totalHakPenjualGross => _akumulasiList.fold(0.0, (s, e) => s + e.hakPenjualDriverGross);
  double get totalBiayaSkemaTrx => _akumulasiList.fold(0.0, (s, e) => s + e.biayaSkemaTrxBulanan);

  // Master Saldo Wallet Driver (Persis 8 Kolom Sheet 3: 3. Saldo Wallet Driver)
  final List<SaldoWalletDriverModel> _saldoWalletDriverList = List.from(initialSaldoWalletDriverList);
  List<SaldoWalletDriverModel> get saldoWalletDriverList => List.unmodifiable(_saldoWalletDriverList);

  int get totalDriverCount => _saldoWalletDriverList.length;
  double get totalDriverTopUp => _saldoWalletDriverList.fold(0.0, (s, e) => s + e.totalTopUp);
  double get totalDriverPotonganCicilan => _saldoWalletDriverList.fold(0.0, (s, e) => s + e.potonganCicilan);
  double get totalDriverPotonganCash => _saldoWalletDriverList.fold(0.0, (s, e) => s + e.potonganOrderCash);
  double get totalDriverKomisiPenghasilan => _saldoWalletDriverList.fold(0.0, (s, e) => s + e.komisiPenghasilan);
  double get totalDriverSaldoAkhir => _saldoWalletDriverList.fold(0.0, (s, e) => s + e.saldoAkhirWallet);

  int get totalDriverMinus => _saldoWalletDriverList.where((d) => d.isMinus).length;
  int get totalDriverBelowLimit => _saldoWalletDriverList.where((d) => d.isBelowMinOrderCash && !d.isMinus).length;
  int get totalDriverReady => _saldoWalletDriverList.where((d) => d.isReadyCash).length;

  void topUpSaldoWalletDriver(String namaDriver, double nominal) {
    final idx = _saldoWalletDriverList.indexWhere((d) => d.namaDriver.toLowerCase() == namaDriver.toLowerCase());
    if (idx != -1) {
      final current = _saldoWalletDriverList[idx];
      final newTopUp = current.totalTopUp + nominal;
      final newSaldo = current.saldoAkhirWallet + nominal;
      _saldoWalletDriverList[idx] = SaldoWalletDriverModel(
        no: current.no,
        namaDriver: current.namaDriver,
        modaTransportasi: current.modaTransportasi,
        totalTopUp: newTopUp,
        potonganCicilan: current.potonganCicilan,
        potonganOrderCash: current.potonganOrderCash,
        komisiPenghasilan: current.komisiPenghasilan,
        saldoAkhirWallet: newSaldo,
      );
      addLog('[WALLET DRIVER] Top up Rp ${nominal.toStringAsFixed(0)} untuk ${current.namaDriver} berhasil. Saldo Baru: Rp ${newSaldo.toStringAsFixed(0)}', type: 'success');
      notifyListeners();
    }
  }

  // Master Rekening Penjual (Persis 7 Kolom Sheet 4: 4. Master Rekening Penjual)
  final List<MasterRekeningPenjualModel> _masterRekeningList = List.from(initialMasterRekeningPenjualList);
  List<MasterRekeningPenjualModel> get masterRekeningList => List.unmodifiable(_masterRekeningList);

  int get totalMasterRekening => _masterRekeningList.length;
  int get totalRekeningMerchant => _masterRekeningList.where((r) => !r.isDriver).length;
  int get totalRekeningDriver => _masterRekeningList.where((r) => r.isDriver).length;
  List<String> get distinctMasterBanks => _masterRekeningList.map((r) => r.namaBank).toSet().toList();
  List<String> get distinctMasterKategori => _masterRekeningList.map((r) => r.kategoriEntitas).toSet().toList();

  void updateMasterRekening(int no, {String? namaBank, String? nomorRekening, String? namaPemilik, String? cabangKota}) {
    final idx = _masterRekeningList.indexWhere((r) => r.no == no);
    if (idx != -1) {
      final current = _masterRekeningList[idx];
      _masterRekeningList[idx] = MasterRekeningPenjualModel(
        no: current.no,
        namaTokoWarungDriver: current.namaTokoWarungDriver,
        namaPemilik: namaPemilik ?? current.namaPemilik,
        kategoriEntitas: current.kategoriEntitas,
        namaBank: namaBank ?? current.namaBank,
        nomorRekening: nomorRekening ?? current.nomorRekening,
        cabangKota: cabangKota ?? current.cabangKota,
      );
      addLog('[MASTER REKENING] Rekening #${current.no} (${current.namaTokoWarungDriver}) berhasil diperbarui ke ${namaBank ?? current.namaBank} - ${nomorRekening ?? current.nomorRekening}.', type: 'success');
      notifyListeners();
    }
  }

  // Master Akumulasi Dana Pencairan (Persis 8 Kolom Sheet 5: 5. Akumulasi Dana Pencairan)
  final List<AkumulasiDanaPencairanModel> _danaPencairanList = List.from(initialAkumulasiDanaPencairanList);
  List<AkumulasiDanaPencairanModel> get danaPencairanList => List.unmodifiable(_danaPencairanList);

  int get totalPencairanMitra => _danaPencairanList.length;
  double get totalPencairanGross => _danaPencairanList.fold(0.0, (s, e) => s + e.totalHakGross);
  double get totalPencairanBiayaLayananTrx => _danaPencairanList.fold(0.0, (s, e) => s + e.biayaLayananTrx);
  double get totalPencairanBiayaTransfer => _danaPencairanList.fold(0.0, (s, e) => s + e.biayaPencairan);
  double get totalPencairanNetDiterima => _danaPencairanList.fold(0.0, (s, e) => s + e.jumlahNetDiterima);

  int get totalPencairanPending => _danaPencairanList.where((p) => !p.isDisbursed).length;
  int get totalPencairanDisbursed => _danaPencairanList.where((p) => p.isDisbursed).length;

  void disburseSingleMitra(int no) {
    final idx = _danaPencairanList.indexWhere((p) => p.no == no);
    if (idx != -1) {
      final current = _danaPencairanList[idx];
      _danaPencairanList[idx] = AkumulasiDanaPencairanModel(
        no: current.no,
        namaPenjualDriver: current.namaPenjualDriver,
        bankTujuan: current.bankTujuan,
        totalHakGross: current.totalHakGross,
        biayaLayananTrx: current.biayaLayananTrx,
        biayaPencairan: current.biayaPencairan,
        jumlahNetDiterima: current.jumlahNetDiterima,
        statusEscrow: 'Disbursed / Sudah Ditransfer',
        disbursedAt: DateTime.now(),
      );
      addLog('[BATCH PAYOUT] Pencairan #${current.no} (${current.namaPenjualDriver}) ke ${current.bankTujuan} sebesar Rp ${current.jumlahNetDiterima.toStringAsFixed(0)} SUKSES DITRANSFER.', type: 'success');
      notifyListeners();
    }
  }

  void executeBatchPayoutAll() {
    int count = 0;
    for (int i = 0; i < _danaPencairanList.length; i++) {
      if (!_danaPencairanList[i].isDisbursed) {
        _danaPencairanList[i].statusEscrow = 'Disbursed / Sudah Ditransfer';
        _danaPencairanList[i].disbursedAt = DateTime.now();
        count++;
      }
    }
    addLog('[BATCH PAYOUT MASSAL] Jadwal Cair Senin & Kamis (17.00 - 23.59 WIB): Berhasil mentransfer $count mitra dengan total net Rp 30.211.550 melalui gateway perbankan.', type: 'success');
    notifyListeners();
  }

  // Master Pencairan Per Bank (Persis 7 Kolom Sheet 6: 6. Pencairan Per Bank)
  final List<PencairanPerBankModel> _pencairanPerBankList = List.from(initialPencairanPerBankList);
  List<PencairanPerBankModel> get pencairanPerBankList => List.unmodifiable(_pencairanPerBankList);

  int get totalBankOperasionalCount => _pencairanPerBankList.length;
  int get totalBankAktifCount => _pencairanPerBankList.where((b) => b.isActive).length;
  int get totalBankMitra => _pencairanPerBankList.fold(0, (s, e) => s + e.jumlahMitra);
  double get totalBankGrossDisbursement => _pencairanPerBankList.fold(0.0, (s, e) => s + e.totalPencairanGross);
  double get totalBankBiayaTrx => _pencairanPerBankList.fold(0.0, (s, e) => s + e.totalBiayaLayananTrx);
  double get totalBankBiayaTransfer => _pencairanPerBankList.fold(0.0, (s, e) => s + e.totalBiayaPencairan);
  double get totalBankNetDisbursement => _pencairanPerBankList.fold(0.0, (s, e) => s + e.netDisbursement);

  // Master Bagi Hasil Pusat & Daerah (Persis 8 Kolom Sheet 7: 7. Bagi Hasil Pusat & Daerah)
  final List<BagiHasilPusatDaerahModel> _bagiHasilList = List.from(initialBagiHasilList);
  List<BagiHasilPusatDaerahModel> get bagiHasilList => List.unmodifiable(_bagiHasilList);

  int get totalWilayahBagiHasil => _bagiHasilList.length;
  double get totalNetProfitSuperadmin => _bagiHasilList.fold(0.0, (s, e) => s + e.netProfitSuperadmin);
  double get totalPorsiPusat => _bagiHasilList.fold(0.0, (s, e) => s + e.porsiPusat);
  double get totalPorsiAdminDaerah => _bagiHasilList.fold(0.0, (s, e) => s + e.porsiAdminDaerah);

  // Master Profil Lisensi Daerah (Persis 11 Kolom Sheet 8: 8. Profil Lisensi Daerah)
  final List<ProfilLisensiDaerahModel> _profilLisensiDaerahList = List.from(initialProfilLisensiDaerahList);
  List<ProfilLisensiDaerahModel> get profilLisensiDaerahList => List.unmodifiable(_profilLisensiDaerahList);

  int get totalLisensiDaerahCount => _profilLisensiDaerahList.length;
  int get totalPenjualMitraDaerah => _profilLisensiDaerahList.fold(0, (s, e) => s + e.jumlahPenjualAktif);
  int get totalDriverMitraDaerah => _profilLisensiDaerahList.fold(0, (s, e) => s + e.jumlahDriverAktif);
  int get totalEventBispiraDaerah => _profilLisensiDaerahList.fold(0, (s, e) => s + e.jumlahEventBispira);
  int get totalEventKompetisiDaerah => _profilLisensiDaerahList.fold(0, (s, e) => s + e.jumlahEventKompetisi);
  int get totalEventEvotingDaerah => _profilLisensiDaerahList.fold(0, (s, e) => s + e.jumlahEventEvoting);
  int get totalSeluruhEventDaerah => _profilLisensiDaerahList.fold(0, (s, e) => s + e.totalEventAktif);

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
    double? tariffR4PerKm,
    double? minFareR4,
    double? commissionR4Percent,
    double? tariffFoodR2PerKm,
    double? minFareFoodR2,
    double? logistikTariffPerKm,
    double? logistikMinFare,
    double? logistikAngkutFee,
    double? trukL300BaseFee,
    double? driverMinWalletBalance,
    double? skemaKerjasamaPusatPct,
    double? skemaKerjasamaDaerahPct,
    double? skemaTanpaKerjasamaPusatPct,
    double? skemaTanpaKerjasamaDaerahPct,
    double? skemaEventMandiriPusatPct,
    double? skemaEventMandiriDaerahPct,
  }) {
    config.tariffR2PerKm = tariffPerKm;
    config.minFareR2 = minFare;
    config.appFee = appFee;
    config.serviceFee = serviceFee;
    config.markupPercent = markupPercent;
    config.disbursementFee = disbursementFee;
    config.driverChargeFee = driverChargeFee;
    config.ambulanceAntarFee = ambulanceAntarFee;
    config.ambulanceAngkutFee = ambulanceAngkutFee;
    config.profitShareCabang = profitShareCabang;
    config.uniqueCodeDurationMinutes = uniqueCodeDurationMinutes;

    if (tariffR4PerKm != null) config.tariffR4PerKm = tariffR4PerKm;
    if (minFareR4 != null) config.minFareR4 = minFareR4;
    if (commissionR4Percent != null) config.commissionR4Percent = commissionR4Percent;
    if (tariffFoodR2PerKm != null) config.tariffFoodR2PerKm = tariffFoodR2PerKm;
    if (minFareFoodR2 != null) config.minFareFoodR2 = minFareFoodR2;
    if (logistikTariffPerKm != null) config.logistikTariffPerKm = logistikTariffPerKm;
    if (logistikMinFare != null) config.logistikMinFare = logistikMinFare;
    if (logistikAngkutFee != null) config.logistikAngkutFee = logistikAngkutFee;
    if (trukL300BaseFee != null) config.trukL300BaseFee = trukL300BaseFee;
    if (driverMinWalletBalance != null) config.driverMinWalletBalance = driverMinWalletBalance;
    if (skemaKerjasamaPusatPct != null) config.skemaKerjasamaPusatPct = skemaKerjasamaPusatPct;
    if (skemaKerjasamaDaerahPct != null) config.skemaKerjasamaDaerahPct = skemaKerjasamaDaerahPct;
    if (skemaTanpaKerjasamaPusatPct != null) config.skemaTanpaKerjasamaPusatPct = skemaTanpaKerjasamaPusatPct;
    if (skemaTanpaKerjasamaDaerahPct != null) config.skemaTanpaKerjasamaDaerahPct = skemaTanpaKerjasamaDaerahPct;
    if (skemaEventMandiriPusatPct != null) config.skemaEventMandiriPusatPct = skemaEventMandiriPusatPct;
    if (skemaEventMandiriDaerahPct != null) config.skemaEventMandiriDaerahPct = skemaEventMandiriDaerahPct;

    addLog(
      '[FLUTTER DESKTOP ADMIN] Parameter Excel Baru Disimpan: Tarif R2=Rp${tariffPerKm.toInt()}, Tarif R4=Rp${config.tariffR4PerKm.toInt()} (Komisi 7.5%), Food R2=Rp${config.tariffFoodR2PerKm.toInt()}, Ambulance=Rp${config.ambulanceTariffPerKm.toInt()}, Logistik Box=Rp${config.logistikTariffPerKm.toInt()}, AppFee=Rp${appFee.toInt()}, Layanan=Rp${serviceFee.toInt()}, SaldoMin=Rp${config.driverMinWalletBalance.toInt()}',
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



