import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import 'expert_home_screen.dart';

class ExpertLoginScreen extends StatefulWidget {
  const ExpertLoginScreen({Key? key}) : super(key: key);

  @override
  State<ExpertLoginScreen> createState() => _ExpertLoginScreenState();
}

class _ExpertLoginScreenState extends State<ExpertLoginScreen> {
  final _phoneCtrl = TextEditingController(text: '0813-9988-7766');
  final _nikCtrl = TextEditingController(text: '3374052901840002');
  bool _isLoading = false;

  void _handleLogin() {
    setState(() => _isLoading = true);
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const ExpertHomeScreen()),
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
                  color: NeoColors.expertSoft,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeoColors.black, width: 2),
                ),
                child: const Center(child: Text('🎤', style: TextStyle(fontSize: 32))),
              ),
              const SizedBox(height: 18),
              const Text(
                'Portal Mitra Ahli & Entertainment',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: NeoColors.black),
              ),
              const SizedBox(height: 6),
              const Text(
                'Masuk untuk menerima jadwal booking les privat, jasa MC/Band, kursus pelatihan, dan servis teknisi panggilan.',
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

              // NIK / KTA FIELD
              const Text('NIK KTP / NOMOR ANGGOTA PROFESI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoColors.black)),
              const SizedBox(height: 6),
              TextField(
                controller: _nikCtrl,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  filled: true,
                  prefixIcon: const Icon(Icons.badge_rounded, color: NeoColors.expert, size: 20),
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
                    color: NeoColors.expert,
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
                            'MASUK KE DASHBOARD MITRA 🚀',
                            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 14),
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // PKS COMPLIANCE NOTICE
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
                    Icon(Icons.workspace_premium_rounded, size: 20, color: Color(0xFFB45309)),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'PKS Bispira: 100% honor jasa les privat, fee penampilan MC/Band, dan servis teknisi langsung masuk ke dompet mitra tanpa potongan.',
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

