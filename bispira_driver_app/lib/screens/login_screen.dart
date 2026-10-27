import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/driver_provider.dart';
import '../theme/neo_theme.dart';
import 'driver_home_screen.dart';

class DriverLoginScreen extends StatefulWidget {
  const DriverLoginScreen({Key? key}) : super(key: key);

  @override
  State<DriverLoginScreen> createState() => _DriverLoginScreenState();
}

class _DriverLoginScreenState extends State<DriverLoginScreen> {
  final _phoneController = TextEditingController(text: '081298765432');
  final _pinController = TextEditingController(text: '123456');
  DriverArmada _selectedArmada = DriverArmada.motor;
  bool _isLoading = false;

  @override
  void dispose() {
    _phoneController.dispose();
    _pinController.dispose();
    super.dispose();
  }

  void _handleLogin() {
    setState(() => _isLoading = true);

    Provider.of<DriverProvider>(context, listen: false).changeArmada(_selectedArmada);

    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _isLoading = false);
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (_) => const DriverHomeScreen()),
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
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // HEADER LOGO
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
                    child: const Icon(Icons.two_wheeler_rounded, color: NeoColors.black, size: 28),
                  ),
                  const SizedBox(width: 14),
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mitra BISPIRA',
                        style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: NeoColors.black),
                      ),
                      Text(
                        'Portal Driver & Medevac',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NeoColors.textMuted),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 32),

              const Text(
                'Masuk ke Akun Driver 🚀',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: NeoColors.black),
              ),
              const SizedBox(height: 6),
              const Text(
                'Pilih armada operasional dan masukkan nomor handphone terdaftar Anda.',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w600, color: NeoColors.textMuted),
              ),
              const SizedBox(height: 24),

              // ARMADA SELECTOR (4 CHOICES: MOTOR, MOBIL, SEND, AMBULANCE)
              const Text(
                'PILIH ARMADA KENDARAAN',
                style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted),
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  _buildArmadaTile(
                    armada: DriverArmada.motor,
                    title: 'Motor Ride',
                    emoji: '🛵',
                  ),
                  const SizedBox(width: 8),
                  _buildArmadaTile(
                    armada: DriverArmada.mobil,
                    title: 'Mobil Car',
                    emoji: '🚗',
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildArmadaTile(
                    armada: DriverArmada.send,
                    title: 'Kurir Send',
                    emoji: '📦',
                  ),
                  const SizedBox(width: 8),
                  _buildArmadaTile(
                    armada: DriverArmada.ambulance,
                    title: 'Ambulance Medevac',
                    emoji: '🚑',
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // PHONE NUMBER INPUT
              const Text(
                'NOMOR HANDPHONE',
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
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 14),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.phone_iphone_rounded, color: NeoColors.brand),
                    hintText: 'Contoh: 08123456789',
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // PIN INPUT
              const Text(
                'PIN KEAMANAN 6 DIGIT',
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
              const SizedBox(height: 28),

              // SUBMIT LOGIN BUTTON
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
                                'MASUK & GO ONLINE 🚀',
                                style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 14.5),
                              ),
                              SizedBox(width: 8),
                              Icon(Icons.arrow_forward_rounded, color: NeoColors.white, size: 20),
                            ],
                          ),
                  ),
                ),
              ),
              const SizedBox(height: 20),

              Center(
                child: TextButton(
                  onPressed: () {},
                  child: const Text(
                    'Belum jadi mitra? Daftar Driver Baru 📝',
                    style: TextStyle(color: NeoColors.brand, fontWeight: FontWeight.w900, fontSize: 12.5),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildArmadaTile({
    required DriverArmada armada,
    required String title,
    required String emoji,
  }) {
    final bool isSelected = _selectedArmada == armada;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedArmada = armada),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
          decoration: BoxDecoration(
            color: isSelected ? NeoColors.brandSoft : NeoColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? NeoColors.brand : NeoColors.black,
              width: isSelected ? 2.2 : 1.8,
            ),
            boxShadow: isSelected
                ? const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)]
                : null,
          ),
          child: Row(
            children: [
              Text(emoji, style: const TextStyle(fontSize: 20)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                    color: isSelected ? NeoColors.brand : NeoColors.black,
                  ),
                ),
              ),
              if (isSelected)
                const Icon(Icons.check_circle_rounded, color: NeoColors.brand, size: 18),
            ],
          ),
        ),
      ),
    );
  }
}
