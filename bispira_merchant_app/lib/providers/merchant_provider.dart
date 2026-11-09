import 'package:flutter/material.dart';

class MerchantProduct {
  final String id;
  String name;
  String category;
  String emoji;
  int basePriceMerchant; // Harga Toko Dasar
  bool isAvailable;

  // Spesifikasi Kolom Berdasarkan FORMULIR PENJUAL.xlsx (Sheet B1, B2, B3, B4)
  String portionUnit; // Porsi, bungkus, botol, kotak, kg, dll
  int prepTimeMinutes; // Waktu persiapan makanan/barang (menit)
  String weightVolume; // Berat/volume (gram, kg, ml, liter)
  String variantOptions; // Pilihan ukuran / rasa / varietas
  String qualityGrade; // Grade A/B/C (Buah/Sembako)
  String bpomLicense; // No BPOM / Izin Edar (Apotek)
  bool requiresPrescription; // Resep dokter (Apotek)

  MerchantProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.basePriceMerchant,
    this.isAvailable = true,
    this.portionUnit = 'Porsi',
    this.prepTimeMinutes = 15,
    this.weightVolume = '350 gram',
    this.variantOptions = 'Pedas / Sedang',
    this.qualityGrade = 'Grade A',
    this.bpomLicense = '-',
    this.requiresPrescription = false,
  });

  // Excel Sheet 1 & 9: Mark Up 10% calculation for consumer app display
  int get consumerPrice => (basePriceMerchant * 1.10).round();
  int get platformMarkupAmount => consumerPrice - basePriceMerchant;
}

class MerchantOrder {
  final String id;
  final String customerName;
  final String driverName;
  final String itemsSummary;
  final int totalMerchantEarning; // 100% Base Merchant Price
  final String orderTime;
  final String orderType; // 'delivery' or 'pickup'
  String status; // 'incoming', 'preparing', 'ready', 'completed'

  MerchantOrder({
    required this.id,
    required this.customerName,
    required this.driverName,
    required this.itemsSummary,
    required this.totalMerchantEarning,
    required this.orderTime,
    this.orderType = 'delivery',
    this.status = 'incoming',
  });
}

class MerchantProvider with ChangeNotifier {
  // Store Details
  bool _isStoreOpen = true;
  String _storeName = 'Ayam Goreng Pak Bareng';
  String _storeId = 'MRC-FOOD-9021';
  String _outletAddress = 'SCBD Lot 8, Jakarta Selatan';
  double _storeRating = 4.92;
  int _todaySalesAmount = 680000;
  int _todayOrdersCount = 14;
  int _walletBalance = 1250000;

  // 18 Kolom Formulir A - Pendaftaran Merchant (FORMULIR PENJUAL.xlsx)
  final String _namaPemilikUsaha = 'H. Ahmad Bareng';
  final String _nikKtp = '3324081985010002';
  final String _nomorHp = '0812-9876-5432 (OTP Terverifikasi)';
  final String _email = 'resto.bareng@bispira.id';
  final String _kategoriUsaha = 'B1. Merchant Food – Makanan dan Minuman';
  final String _deskripsiUsaha = 'Kuliner Tradisional Rempah Pilihan khas Nusantara dengan standar higienis.';
  final String _jamOperasional = 'Senin - Minggu (08:00 - 22:00 WIB)';
  final String _dokumenLegalitas = 'NIB: 9120003418291 • PIRT/BPOM Terdaftar';
  final String _lokasiGps = '-6.2255, 106.8098 (Peta Digital Terverifikasi)';
  final bool _persetujuanKetentuan = true;

  // Financial & Bank Account Settings Sesuai Excel Sheet 2, 4, 5, 6 & Sheet 9
  String _bankOperasional = 'BCA';
  String _nomorRekening = '1026629629';
  String _namaPemilik = 'Bpk/Ibu Bareng';
  final String _payoutSchedule = 'Senin & Kamis (17.00 - 23.59 WIB)';
  final int _biayaLayananPerTrx = 500; // Sheet 2 & 5: Rp 500 / Trx
  final int _biayaPencairanPerBatch = 1000; // Sheet 5: Rp 1.000 / Batch transfer

  // Status Keanggotaan Sesuai Excel Sheet 9 (Charge Merchant: Reguler Rp 500 vs Premium Rp 15.000 / 30 Hari)
  bool _isPremiumMerchant = false;
  final int _biayaPremium30Hari = 15000;
  String _statusLangganan = 'Reguler (Potongan Rp 500 / order)';

  // Catalog Items
  final List<MerchantProduct> _products = [
    MerchantProduct(
      id: 'PRD-01',
      name: 'Ayam Goreng Sambal Ijo Spesial',
      category: 'Makanan Utama',
      emoji: '🍗',
      basePriceMerchant: 25000,
      isAvailable: true,
    ),
    MerchantProduct(
      id: 'PRD-02',
      name: 'Nasi Goreng Kampung Extra Telur',
      category: 'Makanan Utama',
      emoji: '🍳',
      basePriceMerchant: 22000,
      isAvailable: true,
    ),
    MerchantProduct(
      id: 'PRD-03',
      name: 'Es Teh Manis Jumbo',
      category: 'Minuman',
      emoji: '🍹',
      basePriceMerchant: 6000,
      isAvailable: true,
    ),
    MerchantProduct(
      id: 'PRD-04',
      name: 'Tahu & Tempe Goreng Crispy',
      category: 'Camilan / Side',
      emoji: '🧈',
      basePriceMerchant: 10000,
      isAvailable: true,
    ),
  ];

  // Live Orders List
  final List<MerchantOrder> _orders = [
    MerchantOrder(
      id: 'F-8812',
      customerName: 'Siti Rahmawati',
      driverName: 'Budi Santoso (B 4982 BSP)',
      itemsSummary: '2x Ayam Goreng Sambal Ijo, 2x Es Teh Manis',
      totalMerchantEarning: 62000,
      orderTime: '13:40',
      status: 'preparing',
    ),
    MerchantOrder(
      id: 'F-8809',
      customerName: 'Davy Wahyu',
      driverName: 'Ahmad Fauzi (B 1234 XYZ)',
      itemsSummary: '1x Nasi Goreng Kampung, 1x Tahu Tempe',
      totalMerchantEarning: 32000,
      orderTime: '12:15',
      status: 'completed',
    ),
  ];

  // Getters
  bool get isStoreOpen => _isStoreOpen;
  String get storeName => _storeName;
  String get storeId => _storeId;
  String get outletAddress => _outletAddress;
  double get storeRating => _storeRating;
  int get todaySalesAmount => _todaySalesAmount;
  int get todayOrdersCount => _todayOrdersCount;
  int get walletBalance => _walletBalance;
  String get bankOperasional => _bankOperasional;
  String get nomorRekening => _nomorRekening;
  String get namaPemilik => _namaPemilik;
  String get payoutSchedule => _payoutSchedule;
  int get biayaLayananPerTrx => _biayaLayananPerTrx;
  int get biayaPencairanPerBatch => _biayaPencairanPerBatch;
  String get namaPemilikUsaha => _namaPemilikUsaha;
  String get nikKtp => _nikKtp;
  String get nomorHp => _nomorHp;
  String get email => _email;
  String get kategoriUsaha => _kategoriUsaha;
  String get deskripsiUsaha => _deskripsiUsaha;
  String get jamOperasional => _jamOperasional;
  String get dokumenLegalitas => _dokumenLegalitas;
  String get lokasiGps => _lokasiGps;
  bool get persetujuanKetentuan => _persetujuanKetentuan;
  List<MerchantProduct> get products => List.unmodifiable(_products);
  List<MerchantOrder> get orders => List.unmodifiable(_orders);

  // Getters Keanggotaan Merchant (Sheet 9)
  bool get isPremiumMerchant => _isPremiumMerchant;
  int get chargePerTransaksi => _isPremiumMerchant ? 0 : 500;
  int get biayaPremium30Hari => _biayaPremium30Hari;
  String get statusLangganan => _statusLangganan;

  bool subscribePremium() {
    if (_walletBalance < _biayaPremium30Hari) return false;
    _walletBalance -= _biayaPremium30Hari;
    _isPremiumMerchant = true;
    _statusLangganan = 'Premium 30 Hari Aktif (Bebas Potongan Per Order)';
    notifyListeners();
    return true;
  }

  void updateBankAccount(String bank, String rekening, String pemilik) {
    _bankOperasional = bank;
    _nomorRekening = rekening;
    _namaPemilik = pemilik;
    notifyListeners();
  }

  void toggleStoreStatus() {
    _isStoreOpen = !_isStoreOpen;
    notifyListeners();
  }

  void toggleProductAvailability(String productId) {
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index].isAvailable = !_products[index].isAvailable;
      notifyListeners();
    }
  }

  void addProduct(
    String name,
    String category,
    String emoji,
    int basePrice, {
    String portionUnit = 'Porsi',
    int prepTimeMinutes = 15,
    String weightVolume = '350 gram',
    String variantOptions = 'Normal / Standar',
    String qualityGrade = 'Grade A',
    String bpomLicense = '-',
    bool requiresPrescription = false,
  }) {
    _products.add(
      MerchantProduct(
        id: 'PRD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        name: name,
        category: category,
        emoji: emoji,
        basePriceMerchant: basePrice,
        isAvailable: true,
        portionUnit: portionUnit,
        prepTimeMinutes: prepTimeMinutes,
        weightVolume: weightVolume,
        variantOptions: variantOptions,
        qualityGrade: qualityGrade,
        bpomLicense: bpomLicense,
        requiresPrescription: requiresPrescription,
      ),
    );
    notifyListeners();
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index].status = newStatus;
      if (newStatus == 'completed') {
        _todayOrdersCount += 1;
        _todaySalesAmount += _orders[index].totalMerchantEarning;
        _walletBalance += _orders[index].totalMerchantEarning;
      }
      notifyListeners();
    }
  }

  void simulateIncomingOrder() {
    final newOrd = MerchantOrder(
      id: 'F-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
      customerName: 'Pelanggan BISPIRA baru',
      driverName: 'Driver BISPIRA Express (Meluncur 🛵)',
      itemsSummary: '1x Ayam Sambal Ijo, 1x Es Teh Jumbo',
      totalMerchantEarning: 31000,
      orderTime: 'Baru Saja',
      status: 'incoming',
    );
    _orders.insert(0, newOrd);
    notifyListeners();
  }

  bool requestBatchSettlement(int amount, String bankName, String bankAccount) {
    if (amount <= 0 || amount > _walletBalance) return false;
    _walletBalance -= amount;
    notifyListeners();
    return true;
  }
}
