import 'package:flutter/material.dart';

class MerchantProduct {
  final String id;
  String name;
  String category;
  String emoji;
  int basePriceMerchant; // Harga Toko
  bool isAvailable;

  MerchantProduct({
    required this.id,
    required this.name,
    required this.category,
    required this.emoji,
    required this.basePriceMerchant,
    this.isAvailable = true,
  });

  // Excel 20% Markup calculation for consumer app display
  int get consumerPrice => (basePriceMerchant * 1.20).round();
  int get platformMarkupAmount => consumerPrice - basePriceMerchant;
}

class MerchantOrder {
  final String id;
  final String customerName;
  final String driverName;
  final String itemsSummary;
  final int totalMerchantEarning; // 100% Base Merchant Price
  final String orderTime;
  String status; // 'incoming', 'preparing', 'ready', 'completed'

  MerchantOrder({
    required this.id,
    required this.customerName,
    required this.driverName,
    required this.itemsSummary,
    required this.totalMerchantEarning,
    required this.orderTime,
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
  List<MerchantProduct> get products => List.unmodifiable(_products);
  List<MerchantOrder> get orders => List.unmodifiable(_orders);

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

  void addProduct(String name, String category, String emoji, int basePrice) {
    _products.add(
      MerchantProduct(
        id: 'PRD-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
        name: name,
        category: category,
        emoji: emoji,
        basePriceMerchant: basePrice,
        isAvailable: true,
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
