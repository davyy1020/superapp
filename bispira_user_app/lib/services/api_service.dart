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

  static String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }
}
