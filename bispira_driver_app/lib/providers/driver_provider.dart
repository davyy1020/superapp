import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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

  // 4 Pilar Mutasi Saldo Driver Sesuai Excel Sheet 3 (3. Saldo Wallet Driver)
  int _totalTopUp = 300000;
  int _potonganCicilan = 0;
  int _potonganOrderCash = 0;
  int _komisiPenghasilan = 150000;

  // 17 Kolom Formulir C1 - Pendaftaran Transportasi Online (FORMULIR PENJUAL.xlsx)
  final String _nikKtp = '3374101988040003';
  final String _phoneRegistered = '0813-8821-9900 (OTP Terverifikasi)';
  final String _emailRegistered = 'budi.santoso@driver.bispira.id';
  final String _homeAddress = 'Jl. Pandanaran No. 45, Kota Semarang, Jawa Tengah';
  final String _simNumber = 'SIM C: 920811234901 (Exp: 14 Ags 2028)';
  final String _stnkNumber = 'STNK: 4982-BSP-2027 (Pajak Aktif)';
  final String _skckNumber = 'SKCK POLRESTABES: SKCK/2026/08/9912';
  final String _vehicleModel = 'Honda Vario 160 CBS (Hitam Matte)';
  final String _vehicleYear = '2023';
  final String _bankOperasional = 'Bank Jateng';
  final String _nomorRekeningBank = '1017753086';
  final int _cicilanAtributHarian = 5000; // Rp 5.000 / Hari Potongan Otomatis
  final String _jadwalPencairan = 'Senin & Kamis (17.00 - 23.59 WIB)';

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
  int get totalTopUp => _totalTopUp;
  int get potonganCicilan => _potonganCicilan;
  int get potonganOrderCash => _potonganOrderCash;
  int get komisiPenghasilan => _komisiPenghasilan;
  
  // Getters Formulir C1
  String get nikKtp => _nikKtp;
  String get phoneRegistered => _phoneRegistered;
  String get emailRegistered => _emailRegistered;
  String get homeAddress => _homeAddress;
  String get simNumber => _simNumber;
  String get stnkNumber => _stnkNumber;
  String get skckNumber => _skckNumber;
  String get vehicleModel => _vehicleModel;
  String get vehicleYear => _vehicleYear;
  String get bankOperasional => _bankOperasional;
  String get nomorRekeningBank => _nomorRekeningBank;
  int get cicilanAtributHarian => _cicilanAtributHarian;
  String get jadwalPencairan => _jadwalPencairan;
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

  // SIMULATE INCOMING ORDER FOR TESTING / DEMO (FETCH LIVE BACKEND OR OSRM SEMARANG ROUTE)
  Future<void> simulateIncomingOrder() async {
    if (!_isOnline || _activeOrder != null || _incomingOrder != null) return;

    // 1. Try to fetch live pending order from Backend Next.js (/api/v1/orders)
    try {
      final res = await http.get(Uri.parse('http://localhost:3000/api/v1/orders?status=LOOKING_FOR_DRIVER'))
          .timeout(const Duration(seconds: 2));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        if (data['status'] == 'SUCCESS' && data['data'] != null) {
          final List orders = data['data']['orders'] ?? [];
          if (orders.isNotEmpty) {
            final o = orders[0];
            _incomingOrder = DriverOrder(
              id: o['id'] ?? 'BSP-ORD-77192',
              serviceName: o['serviceName'] ?? 'BISPIRA Ride (Motor) 🛵',
              serviceEmoji: o['serviceEmoji'] ?? '🛵',
              customerName: o['customerName'] ?? 'Davy (User Bispira)',
              customerPhone: o['customerPhone'] ?? '0812-9876-5432',
              pickupAddress: o['pickupAddress'] ?? 'Jl. Kaligawe Raya No. 12, Genuk, Semarang',
              dropoffAddress: o['dropoffAddress'] ?? 'Jl. Prof. Soedarto (Undip), Tembalang, Semarang',
              pickupLat: (o['pickupLat'] as num?)?.toDouble() ?? -6.9622,
              pickupLng: (o['pickupLng'] as num?)?.toDouble() ?? 110.4682,
              dropoffLat: (o['dropoffLat'] as num?)?.toDouble() ?? -7.0545,
              dropoffLng: (o['dropoffLng'] as num?)?.toDouble() ?? 110.4358,
              distanceKm: (o['distanceKm'] as num?)?.toDouble() ?? 17.19,
              totalFareCustomer: (o['totalFareCustomer'] as num?)?.toInt() ?? 48478,
              netDriverEarning: (o['netDriverEarning'] as num?)?.toInt() ?? 43204, // 95% Sesuai Kontrak
              paymentMethod: o['paymentMethod'] ?? 'Transfer Bank (Kode Unik 247) 🏦',
              itemsDescription: 'Antar Penumpang Genuk ➔ Tembalang (${o['distanceKm'] ?? 17.2} km)',
            );
          }
        }
      }
    } catch (_) {}

    // 2. Default Fallback: Semarang Genuk to Tembalang (17.2 km OSRM)
    if (_incomingOrder == null) {
      if (_armada == DriverArmada.motor) {
        _incomingOrder = DriverOrder(
          id: 'BSP-ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          serviceName: 'BISPIRA Ride (Motor) 🛵',
          serviceEmoji: '🛵',
          customerName: 'Davy (User Bispira)',
          customerPhone: '0812-9876-5432',
          pickupAddress: 'Jl. Kaligawe Raya No. 12, Genuk, Semarang',
          dropoffAddress: 'Jl. Prof. Soedarto (Undip), Tembalang, Semarang',
          pickupLat: -6.9622,
          pickupLng: 110.4682,
          dropoffLat: -7.0545,
          dropoffLng: 110.4358,
          distanceKm: 17.19,
          totalFareCustomer: 48478,
          netDriverEarning: 43204, // 95% Sesuai Kontrak Pihak Kedua
          paymentMethod: 'Transfer Bank (Kode Unik 247) 🏦',
          itemsDescription: 'Antar Penumpang Genuk ➔ Tembalang (17.2 km OSRM)',
        );
      } else if (_armada == DriverArmada.ambulance) {
        _incomingOrder = DriverOrder(
          id: 'MED-ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          serviceName: 'Ambulance Medevac 🚑',
          serviceEmoji: '🚑',
          customerName: 'Keluarga Bp. Hendra',
          customerPhone: '081311223344',
          pickupAddress: 'Puskesmas Genuk, Jl. Kaligawe',
          dropoffAddress: 'RSUP Dr. Kariadi Semarang, Jl. Dr. Sutomo',
          pickupLat: -6.9610,
          pickupLng: 110.4670,
          dropoffLat: -6.9940,
          dropoffLng: 110.4080,
          distanceKm: 12.4,
          totalFareCustomer: 250000,
          netDriverEarning: 237500, // 95% of Ambulance Fare
          paymentMethod: 'Transfer Bank / QRIS 🏦',
          itemsDescription: 'Pengantaran Medevac Darurat Pasien',
        );
      } else {
        _incomingOrder = DriverOrder(
          id: 'RIDE-ORD-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
          serviceName: 'BISPIRA Car (Mobil) 🚗',
          serviceEmoji: '🚗',
          customerName: 'Ahmad Fauzi',
          customerPhone: '085711229988',
          pickupAddress: 'Jl. Raya Genuk No. 8, Semarang',
          dropoffAddress: 'Politeknik Negeri Semarang, Tembalang',
          pickupLat: -6.9622,
          pickupLng: 110.4682,
          dropoffLat: -7.0545,
          dropoffLng: 110.4358,
          distanceKm: 17.2,
          totalFareCustomer: 99500,
          netDriverEarning: 90250, // 95%
          paymentMethod: 'QRIS BISPIRA 📲',
          itemsDescription: 'Penumpang 3 Orang AC Dingin',
        );
      }
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

    // Notify backend
    try {
      final orderId = _activeOrder!.id;
      http.post(
        Uri.parse('http://localhost:3000/api/v1/orders/$orderId/accept'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'driverId': _driverId,
          'driverName': _driverName,
          'driverPlate': _licensePlate,
        }),
      );
    } catch (_) {}

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

  // Top Up Saldo Driver (Sesuai Regulasi Excel Baru: Min Rp 50.000, Layanan Rp 500, App Rp 500, Kode Unik 3 Digit)
  Map<String, dynamic> requestDriverTopUp(int amount, String bankTarget) {
    if (amount < 50000) {
      return {'success': false, 'message': 'Minimal top-up saldo driver adalah Rp 50.000'};
    }

    final uniqueCode = 100 + (DateTime.now().millisecondsSinceEpoch % 899);
    const serviceFee = 500;
    const appFee = 500;
    final totalTransfer = amount + uniqueCode;
    final netSaldo = amount - (serviceFee + appFee); // misal 50.000 - 1.000 = 49.000

    _walletBalance += netSaldo;
    _totalTopUp += netSaldo;
    _transactionHistory.insert(0, {
      'id': 'TOPUP-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
      'title': 'Top Up Saldo via Bank $bankTarget (+Kode $uniqueCode)',
      'time': 'Baru Saja',
      'type': 'inflow',
      'amount': netSaldo,
      'note': 'Gross: Rp $amount • Potongan: Layanan Rp 500 & App Rp 500',
    });

    notifyListeners();
    return {
      'success': true,
      'uniqueCode': uniqueCode,
      'totalTransfer': totalTransfer,
      'netSaldo': netSaldo,
    };
  }

  // Cicilan Atribut Harian Driver (Rp 5.000 / Hari Sesuai Regulasi Excel Sheet 3)
  bool deductDailyAttribute() {
    if (_walletBalance >= 5000) {
      _walletBalance -= 5000;
      _potonganCicilan += 5000;
      _transactionHistory.insert(0, {
        'id': 'ATR-${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}',
        'title': 'Cicilan Harian Atribut Driver',
        'time': 'Hari ini',
        'type': 'outflow',
        'amount': -5000,
        'note': 'Potongan harian DP 50% Helm & Jaket (1:1 tanpa biaya admin)',
      });
      notifyListeners();
      return true;
    }
    return false;
  }
}
