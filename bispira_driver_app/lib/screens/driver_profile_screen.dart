import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/driver_provider.dart';
import '../theme/neo_theme.dart';
import 'login_screen.dart';

class DriverProfileScreen extends StatelessWidget {
  const DriverProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final driver = Provider.of<DriverProvider>(context);
    final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(
        title: const Text('Profil & Dokumen Mitra Driver'),
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
                      child: Text('🛵', style: TextStyle(fontSize: 32)),
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
                          'ID Mitra: ${driver.driverId} • Formulir C1 Terverifikasi',
                          style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.textMuted),
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
            const SizedBox(height: 16),

            // FORMULIR C1: IDENTITAS LEGALITAS PENGEMUDI
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NeoColors.black, width: 1.8),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: NeoColors.brandSoft,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: NeoColors.black, width: 1.2),
                        ),
                        child: const Icon(Icons.badge_rounded, color: NeoColors.black, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'DATA IDENTITAS DUKCAPIL (FORM C1)',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('NIK KTP', driver.nikKtp),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('No HP & OTP SMS/WA', driver.phoneRegistered),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Email Terdaftar', driver.emailRegistered),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Alamat Domisili', driver.homeAddress),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // FORMULIR C1: DOKUMEN LEGALITAS KENDARAAN & KEPOLISIAN
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NeoColors.black, width: 1.8),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: NeoColors.goldSoft,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: NeoColors.black, width: 1.2),
                        ),
                        child: const Icon(Icons.assignment_turned_in_rounded, color: NeoColors.black, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'LEGALITAS DOKUMEN & KEPOLISIAN',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Surat Izin Mengemudi', driver.simNumber),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Surat Tanda Nomor Kendaraan', driver.stnkNumber),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('SKCK Kepolisian', driver.skckNumber),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // FORMULIR C1: SPESIFIKASI ARMADA
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NeoColors.black, width: 1.8),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: NeoColors.brandSoft,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: NeoColors.black, width: 1.2),
                        ),
                        child: const Icon(Icons.two_wheeler_rounded, color: NeoColors.black, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'SPESIFIKASI ARMADA TERDAFTAR',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Jenis Armada', driver.armada == DriverArmada.motor ? 'R2 Sepeda Motor (Ride, Food, Send)' : driver.armada == DriverArmada.ambulance ? 'Ambulance Medevac' : 'R4 Mobil Penumpang'),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Nomor Plat Kendaraan', driver.licensePlate),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Tipe Kendaraan', driver.vehicleModel),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Tahun Perakitan', driver.vehicleYear),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // ATRIBUT RESMI MITRA DRIVER (EXCEL SHEET 11 CLUSTER 4)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NeoColors.black, width: 1.8),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: NeoColors.brandSoft,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: NeoColors.black, width: 1.2),
                        ),
                        child: const Icon(Icons.sports_motorsports_rounded, color: NeoColors.black, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'ATRIBUT RESMI DRIVER (SHEET 11)',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('1. Helm SNI Bispira', 'Terverifikasi & Diterima ✓'),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('2. Jaket Driver Bispira', 'Ukuran L - Aktif Digunakan ✓'),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('3. Sticker Reflektif Lambung', 'Terpasang Pada Kendaraan ✓'),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('4. T-Shirt Polo Bispira', 'Seragam Resmi Event / Operasional ✓'),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('5. Saldo Wallet & Top Up', 'Aktif Terhubung Ke Ledger Superadmin'),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // FORMULIR C1 & EXCEL SHEET 3-5: OPERASIONAL KEUANGAN BISPIRA
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF3C7),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NeoColors.black, width: 1.8),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: NeoColors.black, width: 1.2),
                        ),
                        child: const Icon(Icons.account_balance_wallet_rounded, color: NeoColors.black, size: 18),
                      ),
                      const SizedBox(width: 10),
                      const Text(
                        'OPERASIONAL KEUANGAN & WALLET (EXCEL)',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.black),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInfoRow('Bank Operasional', driver.bankOperasional),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Nomor Rekening Penerima', driver.nomorRekeningBank),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Potongan Cicilan Atribut', '${currencyFmt.format(driver.cicilanAtributHarian)} / hari (Sheet 3)'),
                  const Divider(color: NeoColors.black, height: 16, thickness: 1),
                  _buildInfoRow('Jadwal Pencairan Dana', driver.jadwalPencairan),
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
        Expanded(
          flex: 4,
          child: Text(label, style: const TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
        ),
        Expanded(
          flex: 6,
          child: Text(
            val,
            textAlign: TextAlign.end,
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: NeoColors.black),
          ),
        ),
      ],
    );
  }
}
