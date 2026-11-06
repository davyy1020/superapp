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

            // OUTLET DETAILS TILE (18 KOLOM FORMULIR A PENDAFTARAN MERCHANT)
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('18 KOLOM FORMULIR A - PENDAFTARAN MERCHANT',
                          style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.brand)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF10B981).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFF10B981)),
                        ),
                        child: const Text('TERVERIFIKASI', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: Color(0xFF10B981))),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  _buildInfoRow('1. Nama Pemilik Usaha', merchant.namaPemilikUsaha),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('2. NIK / KTP', '${merchant.nikKtp} (Dukcapil OK)'),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('3. Foto Pemilik', 'Foto Profil Terverifikasi'),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('4. Nomor HP (OTP)', merchant.nomorHp),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('5. Email Akun', merchant.email),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('6. Nama Toko/Usaha', merchant.storeName),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('7. Logo Toko', '🍗 Logo Utama Aktif'),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('8. Foto Tempat Usaha', 'Foto Outlet Utama Terverifikasi'),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('9. Deskripsi Usaha', merchant.deskripsiUsaha),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('10. Kategori Usaha', merchant.kategoriUsaha),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('11. Alamat Usaha', merchant.outletAddress),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('12. Lokasi Usaha (GPS)', merchant.lokasiGps),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('13. Jam Operasional', merchant.jamOperasional),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('14. Dokumen Legalitas', merchant.dokumenLegalitas),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('15. Nama Bank Operasional', 'Bank ${merchant.bankOperasional} (Sheet 4)'),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('16. Nomor Rekening', merchant.nomorRekening),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('17. Nama Pemilik Rekening', merchant.namaPemilik),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('18. Persetujuan Ketentuan', '✅ Syarat & Ketentuan Disetujui'),
                  const Divider(color: NeoColors.black, height: 14, thickness: 0.8),
                  _buildInfoRow('Jadwal Pencairan (Sheet 5)', merchant.payoutSchedule),
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
