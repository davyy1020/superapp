import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import 'merchant_home_screen.dart';

class MerchantLoginScreen extends StatefulWidget {
  const MerchantLoginScreen({Key? key}) : super(key: key);

  @override
  State<MerchantLoginScreen> createState() => _MerchantLoginScreenState();
}

class _MerchantLoginScreenState extends State<MerchantLoginScreen> {
  final _outletIdController = TextEditingController(text: 'MRC-FOOD-9021');
  final _pinController = TextEditingController(text: '123456');
  bool _isLoading = false;

  @override
  void dispose() {
    _outletIdController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _isLoading = true);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const MerchantHomeScreen()),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: NeoColors.gold,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: NeoColors.black, width: 2.2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                      ],
                    ),
                    child: const Icon(Icons.storefront_rounded, color: NeoColors.black, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mitra Toko BISPIRA',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: NeoColors.black),
                      ),
                      Text(
                        'Portal Merchant & Resto',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NeoColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 36),

              const Text(
                'Masuk ke Kasir Outlet 🏪',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: NeoColors.black),
              ),
              const SizedBox(height: 6),
              const Text(
                'Kelola orderan makanan/barang masuk, menu toko, dan pencairan saldo 100% Base Price.',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: NeoColors.textMuted),
              ),
              const SizedBox(height: 28),

              // OUTLET ID INPUT
              const Text(
                'ID OUTLET MERCHANT',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: NeoColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeoColors.black, width: 2),
                ),
                child: TextField(
                  controller: _outletIdController,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.badge_rounded, color: NeoColors.brand),
                    hintText: 'Contoh: MRC-FOOD-9021',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // PIN INPUT
              const Text(
                'PIN KEAMANAN KASIR 6 DIGIT',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted),
              ),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: NeoColors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeoColors.black, width: 2),
                ),
                child: TextField(
                  controller: _pinController,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14, letterSpacing: 3),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.lock_rounded, color: NeoColors.brand),
                    hintText: '******',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // LOGIN BUTTON
              GestureDetector(
                onTap: _isLoading ? null : _handleLogin,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: NeoColors.brand,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: NeoColors.black, width: 2.2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(color: NeoColors.white, strokeWidth: 2.5),
                          )
                        : const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'BUKA OUTLET & MASUK 🏪',
                                style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 14.5),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, color: NeoColors.white, size: 20),
                            ],
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
