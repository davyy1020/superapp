import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/health_provider.dart';
import '../theme/neo_theme.dart';

class HealthWalletScreen extends StatelessWidget {
  const HealthWalletScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthProvider>(context);
    final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(title: const Text('Dompet & Saldo Tenaga Medis')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // WALLET MAIN CARD
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: NeoColors.cardDark,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: Colors.black, width: 2.2),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(4, 4), blurRadius: 0)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('SALDO PRAKTIK AKTIF', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w800)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: NeoColors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('100% Hak Medis ✓', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    currencyFmt.format(provider.walletBalance),
                    style: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 14),
                  const Divider(color: Colors.white24, height: 1),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Pendapatan Hari Ini', style: TextStyle(color: Colors.white60, fontSize: 10)),
                          Text(currencyFmt.format(provider.todayEarnings), style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w900)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('Total Dicairkan', style: TextStyle(color: Colors.white60, fontSize: 10)),
                          Text(currencyFmt.format(provider.totalWithdrawn), style: const TextStyle(color: Color(0xFF67E8F9), fontSize: 13, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // JADWAL PENCAIRAN SHEET 5 EXCEL BANNER
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NeoColors.healthSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NeoColors.health, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.schedule_rounded, color: NeoColors.healthDark, size: 20),
                      SizedBox(width: 8),
                      Text('Jadwal Pencairan Rutin Bispira (Sheet 5)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.healthDark)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pencairan dana otomatis diproses setiap hari Senin & Kamis pukul 17:00 - 23:59 WIB langsung ke rekening bank terdaftar Anda. Biaya transfer bank tetap Rp 1.000.',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: NeoColors.black),
                  ),
                  const SizedBox(height: 8),
                  Text('Rekening Tujuan: ${provider.bankAccount}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: NeoColors.black)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // RECENT TRANSACTION HISTORY
            const Text('RIWAYAT TRANSAKSI KONSULTASI MEDIS', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            ...provider.consultations.map((c) {
              return Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.black, width: 1.5),
                ),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: c.status == 'completed' ? NeoColors.greenSoft : NeoColors.healthSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(c.visitType == VisitType.homeVisit ? '🏡' : '💬', style: const TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.patientName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text('${c.scheduleTime} • ${c.status.toUpperCase()}', style: const TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                    Text(
                      '+${currencyFmt.format(c.fee)}',
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.greenDark),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

