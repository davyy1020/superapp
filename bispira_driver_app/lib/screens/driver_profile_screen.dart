import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/driver_provider.dart';
import '../theme/neo_theme.dart';
import 'login_screen.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final driver = Provider.of<DriverProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(
        title: const Text('Profil & Kendaraan Mitra'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // PROFILE CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: NeoColors.black, width: 2.2),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: NeoColors.brandSoft,
                      shape: BoxShape.circle,
                      border: Border.all(color: NeoColors.brand, width: 2.2),
                    ),
                    child: const Center(
                      child: Text('👤', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              driver.driverName,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
                            ),
                            const SizedBox(width: 6),
                            const Icon(Icons.verified_rounded, color: NeoColors.brand, size: 18),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'ID Mitra: ${driver.driverId}',
                          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.textMuted),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                          decoration: BoxDecoration(
                            color: NeoColors.gold,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: NeoColors.black, width: 1.2),
                          ),
                          child: Text(
                            '★ ${driver.rating} • Super Driver Gacor',
                            style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.black),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // VEHICLE INFO TILE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NeoColors.black, width: 1.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('INFORMASI KENDARAAN', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted)),
                  const SizedBox(height: 12),

                  _buildInfoRow('Jenis Armada', driver.armada == DriverArmada.motor ? 'Motor (Bispira Ride & Food)' : driver.armada == DriverArmada.ambulance ? 'Ambulance Medevac' : 'Mobil Car'),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Nomor Plat Kendaraan', driver.licensePlate),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Masa Berlaku SIM C/A', '14 Agustus 2028 (Aktif)'),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Masa Berlaku STNK', '20 November 2027 (Aktif)'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // LOGOUT BUTTON
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DriverLoginScreen()),
                );
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: NeoColors.red,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: NeoColors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                  ],
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout_rounded, color: NeoColors.white, size: 18),
                    SizedBox(width: 8),
                    Text('KELUAR DARI AKUN DRIVER', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11.5, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
        Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.black)),
      ],
    );
  }
}
