import 'dart:async';
import 'package:flutter/material.dart';

enum DriverArmada { motor, mobil, send, ambulance }

class DriverOrder {
  final String id;
  final String serviceName;
  final String serviceEmoji;
  final String customerName;
  final String customerPhone;
  final String pickupAddress;
  final String dropoffAddress;
  final double pickupLat;
  final double pickupLng;
  final double dropoffLat;
  final double dropoffLng;
  final double distanceKm;
  final int totalFareCustomer;
  final int netDriverEarning; // 95% of Base Fare or Delivery Fee
  final String paymentMethod; // BispiraPay, Cash, QRIS
  final String itemsDescription;
  String status; // 'incoming', 'accepted', 'at_pickup', 'on_trip', 'completed', 'cancelled'

  DriverOrder({
    required this.id,
    required this.serviceName,
    required this.serviceEmoji,
    required this.customerName,
    required this.customerPhone,
    required this.pickupAddress,
    required this.dropoffAddress,
    required this.pickupLat,
    required this.pickupLng,
    required this.dropoffLat,
    required this.dropoffLng,
    required this.distanceKm,
    required this.totalFareCustomer,
    required this.netDriverEarning,
    required this.paymentMethod,
    required this.itemsDescription,
    this.status = 'incoming',
  });
}

class DriverProvider with ChangeNotifier {
  // Driver Status
  bool _isOnline = true;
  DriverArmada _armada = DriverArmada.motor;
  String _driverName = 'BUDI SANTOSO';
  String _driverId = 'DRV-BSP-8821';
  String _licensePlate = 'B 4982 BSP';
  double _rating = 4.96;
  int _todayTrips = 8;
  int _todayEarnings = 245000;
  int _walletBalance = 450000;
  int _acceptanceRate = 98;

  // Active & Incoming Orders
  DriverOrder? _incomingOrder;
  DriverOrder? _activeOrder;
  Timer? _orderTimer;
  int _countdownSeconds = 15;

  // History Ledger
  final List<Map<String, dynamic>> _transactionHistory = [
    {
      'id': 'TRX-9011',
      'title': 'BISPIRA Food Order #F-8812',
      'time': 'Hari ini, 13:40',
      'type': 'inflow',
      'amount': 14250,
      'note': 'Net 95% Delivery Ongkir',
    },
    {
      'id': 'TRX-9008',
      'title': 'BISPIRA Ride Trip #R-4410',
      'time': 'Hari ini, 11:15',
      'type': 'inflow',
      'amount': 22800,
      'note': 'Net 95% Tarif Perjalanan',
    },
    {
      'id': 'WD-3001',
      'title': 'Pencairan BI-FAST ke Bank BCA',
      'time': 'Kemarin, 19:20',
      'type': 'outflow',
      'amount': -150000,
      'note': 'Nomor Rek: 8840192381 (Selesai)',
    },
  ];

  // Getters
  bool get isOnline => _isOnline;
  DriverArmada get armada => _armada;
  String get driverName => _driverName;
  String get driverId => _driverId;
  String get licensePlate => _licensePlate;
  double get rating => _rating;
  int get todayTrips => _todayTrips;
  int get todayEarnings => _todayEarnings;
  int get walletBalance => _walletBalance;
  int get acceptanceRate => _acceptanceRate;
  DriverOrder? get incomingOrder => _incomingOrder;
  DriverOrder? get activeOrder => _activeOrder;
  int get countdownSeconds => _countdownSeconds;
  List<Map<String, dynamic>> get transactionHistory => List.unmodifiable(_transactionHistory);

  void toggleOnline() {
    _isOnline = !_isOnline;
    if (!_isOnline) {
      _clearIncomingOrder();
    }
    notifyListeners();
  }

  void changeArmada(DriverArmada newArmada) {
    _armada = newArmada;
    notifyListeners();
  }

  // SIMULATE INCOMING ORDER FOR TESTING / DEMO
  void simulateIncomingOrder() {
    if (!_isOnline || _activeOrder != null || _incomingOrder != null) return;

    if (_armada == DriverArmada.motor) {
      _incomingOrder = DriverOrder(
        id: 'BSP-ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        serviceName: 'BISPIRA Food 🍔',
        serviceEmoji: '🛵',
        customerName: 'Siti Rahmawati',
        customerPhone: '081298765432',
        pickupAddress: 'Ayam Goreng Pak Bareng, SCBD',
        dropoffAddress: 'Gedung Wisma Mandiri Lt 12, Sudirman',
        pickupLat: -6.2240,
        pickupLng: 106.8090,
        dropoffLat: -6.2088,
        dropoffLng: 106.8456,
        distanceKm: 3.8,
        totalFareCustomer: 28000,
        netDriverEarning: 14250, // 95% of Ongkir
        paymentMethod: 'BISPIRA Pay 💳',
        itemsDescription: '2x Paket Ayam Bakar Spesial, 2x Es Teh Manis',
      );
    } else if (_armada == DriverArmada.ambulance) {
      _incomingOrder = DriverOrder(
        id: 'MED-ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        serviceName: 'Ambulance Medevac 🚑',
        serviceEmoji: '🚑',
        customerName: 'Keluarga Bp. Hendra',
        customerPhone: '081311223344',
        pickupAddress: 'Rumah Duka Gatot Subroto No. 45',
        dropoffAddress: 'RSUPN Cipto Mangunkusumo (RSCM)',
        pickupLat: -6.2300,
        pickupLng: 106.8200,
        dropoffLat: -6.1980,
        dropoffLng: 106.8480,
        distanceKm: 6.2,
        totalFareCustomer: 250000,
        netDriverEarning: 237500, // 95% of Ambulance Fare
        paymentMethod: 'Tunai / Cash 💵',
        itemsDescription: 'Pengantaran Medevac Darurat + Tim Medis',
      );
    } else {
      _incomingOrder = DriverOrder(
        id: 'RIDE-ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        serviceName: 'BISPIRA Ride 🛵',
        serviceEmoji: '🛵',
        customerName: 'Ahmad Fauzi',
        customerPhone: '085711229988',
        pickupAddress: 'Stasiun Gambir Pintu Timur',
        dropoffAddress: 'Mall Grand Indonesia Pintu West',
        pickupLat: -6.1767,
        pickupLng: 106.8306,
        dropoffLat: -6.1950,
        dropoffLng: 106.8200,
        distanceKm: 4.5,
        totalFareCustomer: 18000,
        netDriverEarning: 15200,
        paymentMethod: 'QRIS NISP 📲',
        itemsDescription: 'Penumpang 1 Orang',
      );
    }

    _countdownSeconds = 15;
    _orderTimer?.cancel();
    _orderTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_countdownSeconds > 0) {
        _countdownSeconds--;
        notifyListeners();
      } else {
        _rejectOrder();
      }
    });

    notifyListeners();
  }

  void acceptOrder() {
    if (_incomingOrder == null) return;
    _orderTimer?.cancel();
    _activeOrder = _incomingOrder;
    _activeOrder!.status = 'accepted';
    _incomingOrder = null;
    notifyListeners();
  }

  void _rejectOrder() {
    _orderTimer?.cancel();
    _incomingOrder = null;
    notifyListeners();
  }

  void rejectOrder() => _rejectOrder();

  void updateOrderStatus(String newStatus) {
    if (_activeOrder != null) {
      _activeOrder!.status = newStatus;
      if (newStatus == 'completed') {
        _todayTrips += 1;
        _todayEarnings += _activeOrder!.netDriverEarning;
        _walletBalance += _activeOrder!.netDriverEarning;

        _transactionHistory.insert(0, {
          'id': 'TRX-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          'title': '${_activeOrder!.serviceName} Order #${_activeOrder!.id}',
          'time': 'Baru Saja',
          'type': 'inflow',
          'amount': _activeOrder!.netDriverEarning,
          'note': 'Net 95% Split Settlement Driver',
        });

        _activeOrder = null;
      }
      notifyListeners();
    }
  }

  void _clearIncomingOrder() {
    _orderTimer?.cancel();
    _incomingOrder = null;
  }

  // BI-FAST Instant Withdrawal Function
  bool requestBIFastWithdrawal(int amount, String bankCode, String accountNumber) {
    if (amount <= 0 || amount > _walletBalance) return false;

    _walletBalance -= amount;
    _transactionHistory.insert(0, {
      'id': 'WD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'title': 'Pencairan BI-FAST ke Bank $bankCode',
      'time': 'Baru Saja',
      'type': 'outflow',
      'amount': -amount,
      'note': 'Rek: $accountNumber (Sukses Real-Time ⚡)',
    });
    notifyListeners();
    return true;
  }
}
