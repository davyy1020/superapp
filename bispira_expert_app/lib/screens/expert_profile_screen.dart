import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/expert_provider.dart';
import '../theme/neo_theme.dart';
import 'login_screen.dart';

class ExpertProfileScreen extends StatelessWidget {
  const ExpertProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpertProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(title: const Text('Profil & Portofolio Mitra Ahli')),
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
                      color: NeoColors.expertSoft,
                      shape: BoxShape.circle,
                      border: Border.all(color: NeoColors.expert, width: 2),
                    ),
                    child: const Center(child: Text('👨‍🏫', style: TextStyle(fontSize: 32))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                provider.expertName,
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            const SizedBox(width: 4),
                            const Icon(Icons.verified_rounded, color: NeoColors.expert, size: 16),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Text(provider.professionTitle, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: NeoColors.goldSoft,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: NeoColors.gold, width: 1.2),
                          ),
                          child: Text('★ ${provider.rating} • ${provider.totalSessionsCompleted} Sesi Selesai', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // FORMULIR PENJUAL SHEET 'BIMBELPRIVAT' & 'ENTERTAINMENT' DOKUMEN MITRA
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
                  const Text('DOKUMEN & KOMPETENSI MITRA AHLI (PKS)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.5, color: NeoColors.textMuted)),
                  const SizedBox(height: 12),
                  _buildRow('Sertifikasi / Ijazah', provider.degreeCertification),
                  const Divider(height: 16),
                  _buildRow('Wilayah Jangkauan Layanan', provider.operationalCity),
                  const Divider(height: 16),
                  _buildRow('Status Kemitraan', 'Mitra Terverifikasi Bispira Gold'),
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
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const ExpertLoginScreen()));
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
                  child: Text('KELUAR DARI AKUN MITRA', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
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
