import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/merchant_provider.dart';
import '../theme/neo_theme.dart';
import 'login_screen.dart';

class MerchantProfileScreen extends StatelessWidget {
  const MerchantProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final merchant = Provider.of<MerchantProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(
        title: const Text('Profil & Pengaturan Outlet'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // OUTLET PROFILE CARD
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
                      color: NeoColors.goldSoft,
                      shape: BoxShape.circle,
                      border: Border.all(color: NeoColors.gold, width: 2.2),
                    ),
                    child: const Center(
                      child: Text('🍗', style: TextStyle(fontSize: 32)),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                merchant.storeName,
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
                              ),
                            ),
                            const Icon(Icons.verified_rounded, color: NeoColors.brand, size: 18),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(
                          'ID Merchant: ${merchant.storeId}',
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
                            '★ ${merchant.storeRating} • Resto Rekomendasi BISPIRA',
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

            // OUTLET DETAILS TILE
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
                  const Text('INFORMASI OUTLET', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted)),
                  const SizedBox(height: 12),

                  _buildInfoRow('Kategori Layanan', 'BISPIRA Food 🍔'),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Alamat Outlet', merchant.outletAddress),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Jam Operasional', '08:00 - 22:00 WIB'),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Lisensi Cabang Regional', 'Cabang Jakarta Selatan (Aktif)'),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // LOGOUT BUTTON
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const MerchantLoginScreen()),
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
                    Text('TUTUP OUTLET & KELUAR', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13)),
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
        Flexible(
          child: Text(
            val,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.black),
          ),
        ),
      ],
    );
  }
}
