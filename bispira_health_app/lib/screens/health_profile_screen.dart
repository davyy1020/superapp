import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/health_provider.dart';
import '../theme/neo_theme.dart';
import 'login_screen.dart';

class HealthProfileScreen extends StatelessWidget {
  const HealthProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(title: const Text('Profil & Dokumen STR/SIP Medis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          children: [
            // AVATAR & IDENTITY CARD
            Container(
              padding: const EdgeInsets.all(18),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0)],
              ),
              child: Row(
                children: [
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      color: NeoColors.healthSoft,
                      shape: BoxShape.circle,
                      border: Border.all(color: NeoColors.health, width: 2),
                    ),
                    child: const Center(child: Text('👨‍⚕️', style: TextStyle(fontSize: 32))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(provider.practitionerName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15)),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded, color: NeoColors.health, size: 16),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(provider.clinicHospital, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: NeoColors.goldSoft,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: NeoColors.gold, width: 1.2),
                          ),
                          child: Text('★ ${provider.rating} • ${provider.totalPatients} Pasien Dilayani', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // FORMULIR PENJUAL SHEET 'TENAGA KESEHATAN' VERIFIED LEGALITY
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 1.8),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2.5, 2.5), blurRadius: 0)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('DOKUMEN LEGALITAS MEDIS TERVERIFIKASI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5, color: NeoColors.textMuted)),
                  const SizedBox(height: 12),
                  _buildRow('Nomor STR Aktif', provider.strNumber),
                  const Divider(height: 16),
                  _buildRow('Nomor Izin Praktik (SIP)', provider.sipNumber),
                  const Divider(height: 16),
                  _buildRow('Alamat Praktik Mandiri', provider.practiceAddress),
                  const Divider(height: 16),
                  _buildRow('Rekening Penampungan', provider.bankAccount),
                  const Divider(height: 16),
                  _buildRow('Jadwal Pencairan Rutin', provider.payoutBatchInfo),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // LOGOUT BUTTON
            GestureDetector(
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const HealthLoginScreen()));
              },
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 14),
                decoration: BoxDecoration(
                  color: NeoColors.red,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.black, width: 2),
                  boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2.5, 2.5), blurRadius: 0)],
                ),
                child: const Center(
                  child: Text('KELUAR DARI AKUN PRAKTIK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String val) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.textMuted))),
        Expanded(child: Text(val, textAlign: TextAlign.end, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: NeoColors.black))),
      ],
    );
  }
}

