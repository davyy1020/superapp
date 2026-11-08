import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expert_provider.dart';
import '../theme/neo_theme.dart';

class BookingDetailScreen extends StatelessWidget {
  final ClientBooking booking;

  const BookingDetailScreen({Key? key, required this.booking}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpertProvider>(context);
    final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(title: const Text('Detail Pesanan Layanan')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // STATUS BADGE CARD
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: Colors.black, width: 2),
                boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0)],
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: NeoColors.expertSoft,
                      shape: BoxShape.circle,
                      border: Border.all(color: NeoColors.expert, width: 1.8),
                    ),
                    child: const Center(child: Text('📅', style: TextStyle(fontSize: 24))),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID: ${booking.id}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                        const SizedBox(height: 2),
                        Text(booking.serviceName, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: booking.status == 'confirmed'
                          ? NeoColors.greenSoft
                          : booking.status == 'completed'
                              ? Colors.grey[200]
                              : NeoColors.goldSoft,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.black, width: 1.2),
                    ),
                    child: Text(
                      booking.status.toUpperCase(),
                      style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),

            // CLIENT INFORMATION & SCHEDULE
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 1.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('INFORMASI KLIEN & JADWAL SESI', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                  const SizedBox(height: 12),
                  _buildRow('Nama Pemesan', booking.clientName),
                  const Divider(height: 16),
                  _buildRow('Nomor Kontak', booking.clientPhone),
                  const Divider(height: 16),
                  _buildRow('Waktu Pelaksanaan', booking.scheduleDate),
                  const Divider(height: 16),
                  _buildRow('Alamat Lokasi Klien', booking.locationAddress),
                  if (booking.clientNotes != null) ...[
                    const Divider(height: 16),
                    _buildRow('Catatan Tambahan', booking.clientNotes!),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 18),

            // HONORARIUM & FINANCIAL SUMMARY
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.black, width: 1.8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('HONORARIUM JASA MITRA (100%)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Diterima Mitra:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                      Text(currencyFmt.format(booking.fee), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: NeoColors.greenDark)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    '💡 Sesuai PKS Bispira: Honor jasa masuk utuh ke saldo dompet dan siap dicairkan pada jadwal batch 17:00 WIB.',
                    style: TextStyle(fontSize: 10.5, color: NeoColors.textMuted),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // ACTION BUTTONS
            if (booking.status == 'pending') ...[
              GestureDetector(
                onTap: () {
                  provider.updateBookingStatus(booking.id, 'confirmed');
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: NeoColors.expert,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2.5, 2.5), blurRadius: 0)],
                  ),
                  child: const Center(
                    child: Text('KONFIRMASI TERIMA JADWAL ✓', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                  ),
                ),
              ),
            ] else if (booking.status == 'confirmed') ...[
              GestureDetector(
                onTap: () {
                  provider.updateBookingStatus(booking.id, 'completed');
                  Navigator.pop(context);
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: NeoColors.greenDark,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: Colors.black, width: 2),
                    boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2.5, 2.5), blurRadius: 0)],
                  ),
                  child: const Center(
                    child: Text('SELESAIKAN SESI LAYANAN & TERIMA HONOR 🎉', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 13)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildRow(String label, String val) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.textMuted))),
        Expanded(child: Text(val, style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: NeoColors.black))),
      ],
    );
  }
}

