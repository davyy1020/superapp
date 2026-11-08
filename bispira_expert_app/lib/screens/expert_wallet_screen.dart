import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expert_provider.dart';
import '../theme/neo_theme.dart';

class ExpertWalletScreen extends StatelessWidget {
  const ExpertWalletScreen({super.key});

  void _showWithdrawModal(BuildContext context, ExpertProvider provider) {
    final amountCtrl = TextEditingController(text: '500000');
    final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Container(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          border: Border(top: BorderSide(color: Colors.black, width: 2.5)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: NeoColors.expertSoft,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 1.5),
                  ),
                  child: const Icon(Icons.outbox_rounded, color: NeoColors.expert, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Tarik Saldo Honorarium', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                      Text('Sesuai PKS Bispira: Batch 17:00 WIB', style: TextStyle(fontSize: 11, color: NeoColors.textMuted)),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Text('NOMINAL PENARIKAN (MIN. RP 50.000)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
            const SizedBox(height: 6),
            TextField(
              controller: amountCtrl,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
              decoration: InputDecoration(
                prefixText: 'Rp ',
                fillColor: NeoColors.bg,
                filled: true,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.black, width: 1.8)),
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: NeoColors.bg,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 1.2),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Rekening Tujuan:', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      Text(provider.bankAccount.split(' - ')[0], style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Biaya Transfer Bank (Sheet 5):', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      Text('Rp 1.000', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoColors.redDark)),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final amt = int.tryParse(amountCtrl.text.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
                  if (amt >= 50000 && amt <= provider.walletBalance) {
                    provider.withdrawFunds(amt);
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: NeoColors.greenDark,
                        content: Text('Permintaan penarikan ${currencyFmt.format(amt)} dijadwalkan pada batch 17:00 WIB.'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: NeoColors.red,
                        content: Text('Saldo tidak mencukupi atau nominal di bawah batas minimum.'),
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: NeoColors.expert,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14), side: const BorderSide(color: Colors.black, width: 2)),
                ),
                child: const Text('KONFIRMASI PENCAIRAN SALDO', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.white, fontSize: 13)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpertProvider>(context);
    final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(title: const Text('Dompet & Saldo Mitra Ahli')),
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
                      const Text('SALDO PENDAPATAN MITRA', style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w800)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: NeoColors.green,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text('100% Hak Mitra ✓', style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w900)),
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
                          Text(currencyFmt.format(provider.totalWithdrawn), style: const TextStyle(color: Color(0xFFC4B5FD), fontSize: 13, fontWeight: FontWeight.w900)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: () => _showWithdrawModal(context, provider),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: NeoColors.expert,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 1.5),
                      ),
                      child: const Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.payments_rounded, color: Colors.white, size: 18),
                            SizedBox(width: 8),
                            Text('Tarik Saldo ke Rekening Bank', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // JADWAL PENCAIRAN SHEET 5 EXCEL BANNER
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NeoColors.expertSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NeoColors.expert, width: 1.5),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.schedule_rounded, color: NeoColors.expertDark, size: 20),
                      SizedBox(width: 8),
                      Text('Jadwal Pencairan Rutin Bispira (Sheet 5)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.expertDark)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Pencairan dana otomatis diproses setiap hari Senin & Kamis pukul 17:00 - 23:59 WIB langsung ke rekening bank terdaftar mitra. Biaya transfer bank tetap Rp 1.000.',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: NeoColors.black),
                  ),
                  const SizedBox(height: 8),
                  Text('Rekening Tujuan: ${provider.bankAccount}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: NeoColors.black)),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // RECENT TRANSACTION HISTORY
            const Text('RIWAYAT BOOKING & HONORARIUM MITRA', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, letterSpacing: 0.5)),
            const SizedBox(height: 10),
            ...provider.bookings.map((b) {
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
                        color: b.status == 'completed' ? NeoColors.greenSoft : NeoColors.expertSoft,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text('🎓', style: TextStyle(fontSize: 20)),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(b.clientName, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                          const SizedBox(height: 2),
                          Text('${b.serviceName} • ${b.scheduleDate}', style: const TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w700), maxLines: 1, overflow: TextOverflow.ellipsis),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '+${currencyFmt.format(b.fee)}',
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
