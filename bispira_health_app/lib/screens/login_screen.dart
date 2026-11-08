import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import 'health_home_screen.dart';

class HealthLoginScreen extends StatefulWidget {
  const HealthLoginScreen({Key? key}) : super(key: key);

  @override
  State<HealthLoginScreen> createState() => _HealthLoginScreenState();
}

class _HealthLoginScreenState extends State<HealthLoginScreen> {
  final _phoneCtrl = TextEditingController(text: '0812-8877-6655');
  final _strCtrl = TextEditingController(text: 'STR-IDI-3374-2026-8891');
  bool _isLoading = false;

  void _handleLogin() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const HealthHomeScreen()),
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
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 30),
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: NeoColors.healthSoft,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeoColors.black, width: 2),
                ),
                child: const Center(child: Text('👨‍⚕️', style: TextStyle(fontSize: 32))),
              ),
              const SizedBox(height: 18),
              const Text(
                'Portal Mitra Medis & Homecare',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: NeoColors.black),
              ),
              const SizedBox(height: 6),
              const Text(
                'Masuk untuk melayani konsultasi chat, jadwal janji klinik, dan kunjungan home visit pasien.',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: NeoColors.textMuted),
              ),
              const SizedBox(height: 30),

              // PHONE FIELD
              const Text('NOMOR TELEPON / WA TERDAFTAR', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoColors.black)),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneCtrl,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(Icons.phone_rounded, color: NeoColors.black, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: NeoColors.black, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // STR / SIP FIELD (FORMULIR TENAGA KESEHATAN)
              const Text('NOMOR REGISTRASI STR / SIP MEDIS', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoColors.black)),
              const SizedBox(height: 6),
              TextField(
                controller: _strCtrl,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(Icons.verified_user_rounded, color: NeoColors.health, size: 20),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: NeoColors.black, width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // LOGIN BUTTON
              GestureDetector(
                onTap: _isLoading ? null : _handleLogin,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: NeoColors.health,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: NeoColors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                    ],
                  ),
                  child: Center(
                    child: _isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                        : const Text(
                            'MASUK KE RUANG PRAKTIK 🚀',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // INFO LEGALITAS PMK & FORMULIR PENJUAL
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: const Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(Icons.info_outline_rounded, size: 20, color: Color(0xFFB45309)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'PKS Bispira: Seluruh tenaga medis (Dokter, Bidan, Fisioterapis, Perawat) berhak atas 100% tarif konsultasi langsung tanpa potongan liar platform.',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: Color(0xFF92400E)),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

