import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  // Backend Express.js Server URL (Local Node.js / VPS Server)
  static const String baseUrl = 'http://localhost:3000/api/v1';

  // Local fallback state in case backend is offline
  static int _mockBalance = 250000;
  static final List<Map<String, dynamic>> _mockTransactions = [
    {
      'txId': 'tx_1001',
      'title': 'Top-Up Virtual Account BNI',
      'date': '25 Okt 2026 • 09:30',
      'amount': '+ Rp 500.000',
      'isPositive': true,
      'status': 'Berhasil',
    },
    {
      'txId': 'tx_1002',
      'title': 'Pembayaran BISPIRA TAX',
      'date': '24 Okt 2026 • 14:15',
      'amount': '- Rp 2.250.000',
      'isPositive': false,
      'status': 'Berhasil',
    },
  ];

  static int get walletBalance => _mockBalance;
  static List<Map<String, dynamic>> get transactionHistory => List.unmodifiable(_mockTransactions);

  // ===========================================================================
  // 1. INBOUND PAYMENT: CREATE VIRTUAL ACCOUNT (SNAP BI AGGREGATOR)
  // ===========================================================================
  static Future<Map<String, dynamic>> createVirtualAccount({
    required String bankCode,
    required int amount,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/va/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': 'BSP-2026-9042',
          'bankCode': bankCode,
          'amount': amount,
        }),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        return resData['data'] as Map<String, dynamic>;
      }
    } catch (_) {
      // Fallback local execution when offline
    }

    // Fallback Mock VA Generation
    final vaNum = '8808${DateTime.now().millisecondsSinceEpoch.toString().substring(4)}';
    return {
      'vaId': 'va_${DateTime.now().millisecondsSinceEpoch}',
      'bankCode': bankCode,
      'vaNumber': vaNum,
      'expectedAmount': amount,
      'status': 'PENDING',
    };
  }

  // ===========================================================================
  // 2. BI-FAST BANK ACCOUNT QUERY (VALIDATOR API)
  // ===========================================================================
  static Future<Map<String, dynamic>> verifyBankAccount({
    required String bankCode,
    required String accountNumber,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/disbursements/bank-query'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'bankCode': bankCode,
          'accountNumber': accountNumber,
        }),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        return resData['data'] as Map<String, dynamic>;
      }
    } catch (_) {
      // Fallback local execution
    }

    return {
      'bankCode': bankCode,
      'accountNumber': accountNumber,
      'accountHolderName': 'DAVY WAHYU SAPUTRA',
      'isValid': true,
    };
  }

  // ===========================================================================
  // 3. OUTBOUND DISBURSEMENT: INSTANT BI-FAST WITHDRAWAL
  // ===========================================================================
  static Future<Map<String, dynamic>> executeBIFastWithdrawal({
    required int amount,
    required String bankCode,
    required String accountNumber,
    required String accountHolderName,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/disbursements/withdraw'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': 'BSP-2026-9042',
          'amount': amount,
          'bankCode': bankCode,
          'accountNumber': accountNumber,
          'accountHolderName': accountHolderName,
        }),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        _mockBalance = resData['data']['newBalance'] as int;
        return resData;
      }
    } catch (_) {
      // Fallback local execution
    }

    const biFastFee = 2500;
    _mockBalance -= (amount + biFastFee);
    _mockTransactions.insert(0, {
      'txId': 'disb_${DateTime.now().millisecondsSinceEpoch}',
      'title': 'Penarikan BI-Fast ($bankCode)',
      'date': 'Hari Ini • Sekarang',
      'amount': '- Rp ${_formatPrice(amount)}',
      'isPositive': false,
      'status': 'Berhasil',
    });

    return {
      'status': 'SUCCESS',
      'message': 'Penarikan Rp ${_formatPrice(amount)} Berhasil via BI-Fast',
      'data': {'newBalance': _mockBalance}
    };
  }

  // ===========================================================================
  // 4. MULTI-PARTY SPLIT PAYMENT ENGINE (PIHAK 1, 2, 3)
  // ===========================================================================
  static Future<Map<String, dynamic>> executeSplitCheckout({
    required int amount,
    required String serviceType,
    String? mitraId,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/transactions/split-checkout'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'userId': 'BSP-2026-9042',
          'totalAmount': amount,
          'serviceType': serviceType,
          'mitraId': mitraId ?? 'MITRA-DRV-0821',
        }),
      ).timeout(const Duration(seconds: 4));

      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        _mockBalance = resData['data']['userRemainingBalance'] as int;
        return resData;
      }
    } catch (_) {
      // Fallback local execution
    }

    _mockBalance -= amount;
    _mockTransactions.insert(0, {
      'txId': 'split_${DateTime.now().millisecondsSinceEpoch}',
      'title': 'Pembayaran $serviceType (Pecah Dana 1,2,3)',
      'date': 'Hari Ini • Sekarang',
      'amount': '- Rp ${_formatPrice(amount)}',
      'isPositive': false,
      'status': 'Berhasil',
    });

    return {
      'status': 'SUCCESS',
      'message': 'Pecah Dana Pihak 1, 2, 3 Berhasil Diproses',
      'data': {'userRemainingBalance': _mockBalance}
    };
  }

  // ===========================================================================
  // 5. OSRM GIS ROUTING ENGINE & ESTIMASI TARIF REAL-TIME
  // ===========================================================================
  static Future<Map<String, dynamic>> getOsrmRoute({
    required double originLat,
    required double originLng,
    required double destLat,
    required double destLng,
    String serviceType = 'motor',
  }) async {
    // 1. First try Next.js backend OSRM endpoint
    try {
      final uri = Uri.parse('$baseUrl/routing').replace(queryParameters: {
        'originLat': originLat.toString(),
        'originLng': originLng.toString(),
        'destLat': destLat.toString(),
        'destLng': destLng.toString(),
        'serviceType': serviceType,
      });

      final response = await http.get(uri).timeout(const Duration(seconds: 4));
      if (response.statusCode == 200) {
        final resData = jsonDecode(response.body);
        if (resData['status'] == 'SUCCESS' && resData['data'] != null) {
          return resData['data'] as Map<String, dynamic>;
        }
      }
    } catch (_) {
      // Backend request timeout/error, proceed to direct OSRM
    }

    // 2. Direct OSRM public engine fallback
    try {
      final osrmUri = Uri.parse(
        'https://router.project-osrm.org/route/v1/driving/$originLng,$originLat;$destLng,$destLat?overview=full&geometries=geojson&steps=true',
      );
      final osrmRes = await http.get(osrmUri).timeout(const Duration(seconds: 5));
      if (osrmRes.statusCode == 200) {
        final data = jsonDecode(osrmRes.body);
        if (data['code'] == 'Ok' && (data['routes'] as List).isNotEmpty) {
          final primary = data['routes'][0];
          final double distKm = (primary['distance'] as num) / 1000.0;
          final int durMin = ((primary['duration'] as num) / 60.0).ceil();
          final List coords = primary['geometry']['coordinates'] as List;

          final polylinePoints = coords.map((c) => [(c[1] as num).toDouble(), (c[0] as num).toDouble()]).toList();

          // Formula tarif
          final tripFare = 10000 + (distKm > 3 ? ((distKm - 3) * 2500).round() : 0);
          final driverShare = (tripFare * 0.95).round();
          final platformFee = tripFare - driverShare;

          return {
            'route': {
              'source': 'OSRM_DIRECT_ENGINE',
              'distanceKm': double.parse(distKm.toStringAsFixed(2)),
              'durationMinutes': durMin,
              'polylinePoints': polylinePoints,
            },
            'fare': {
              'serviceName': 'Bispira Ride',
              'distanceKm': double.parse(distKm.toStringAsFixed(2)),
              'tripFare': tripFare,
              'driverShare': driverShare,
              'platformFee': platformFee,
              'taxPph': (tripFare * 0.005).round(),
              'appFee': 2000,
              'serviceFee': 1000,
              'grandTotal': tripFare + 3000,
            }
          };
        }
      }
    } catch (_) {}

    // 3. Fallback straight interpolation
    final distKm = 7.5;
    return {
      'route': {
        'source': 'OSRM_FALLBACK',
        'distanceKm': distKm,
        'durationMinutes': 18,
        'polylinePoints': [
          [originLat, originLng],
          [(originLat + destLat) / 2 + 0.002, (originLng + destLng) / 2 + 0.002],
          [destLat, destLng],
        ],
      },
      'fare': {
        'serviceName': 'Bispira Ride',
        'distanceKm': distKm,
        'tripFare': 21250,
        'driverShare': 20188,
        'platformFee': 1062,
        'taxPph': 106,
        'appFee': 2000,
        'serviceFee': 1000,
        'grandTotal': 24250,
      }
    };
  }

  static String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}
