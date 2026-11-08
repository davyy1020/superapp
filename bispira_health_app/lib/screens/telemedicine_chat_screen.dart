import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/health_provider.dart';
import '../theme/neo_theme.dart';

class TelemedicineChatScreen extends StatefulWidget {
  final PatientConsultation consultation;

  const TelemedicineChatScreen({super.key, required this.consultation});

  @override
  State<TelemedicineChatScreen> createState() => _TelemedicineChatScreenState();
}

class _TelemedicineChatScreenState extends State<TelemedicineChatScreen> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final TextEditingController _msgCtrl = TextEditingController();
  final TextEditingController _diagCtrl = TextEditingController();
  final TextEditingController _rxCtrl = TextEditingController();

  final List<Map<String, dynamic>> _messages = [
    {
      'isDoctor': false,
      'text': 'Halo Dok, selamat pagi. Badan saya demam sudah 3 hari, menggigil tiap malam dan batuk kering.',
      'time': '09:32 WIB',
    },
    {
      'isDoctor': true,
      'text': 'Selamat pagi Pak Budi. Sudah diukur suhu tubuhnya? Ada riwayat nyeri tenggorokan atau sesak napas?',
      'time': '09:33 WIB',
    },
    {
      'isDoctor': false,
      'text': 'Semalam suhunya 38.6°C Dok. Tidak sesak, tapi tenggorokan terasa gatal dan badan lemas sekali.',
      'time': '09:35 WIB',
    },
  ];

  void _sendMessage() {
    if (_msgCtrl.text.trim().isEmpty) return;
    setState(() {
      _messages.add({
        'isDoctor': true,
        'text': _msgCtrl.text.trim(),
        'time': '${DateFormat('HH:mm').format(DateTime.now())} WIB',
      });
      _msgCtrl.clear();
    });
  }

  void _showPrescriptionDialog(BuildContext context, HealthProvider provider) {
    _diagCtrl.text = widget.consultation.diagnosis ?? 'Suspek ISPA Akut Febris';
    _rxCtrl.text = widget.consultation.ePrescription ?? 'Paracetamol 500mg (3x1 tab p.c.)\nN-Acetylcysteine 200mg (3x1 caps)\nVitamin C 500mg (1x1 tab)';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.black, width: 2)),
        title: const Row(
          children: [
            Icon(Icons.receipt_long_rounded, color: NeoColors.health),
            SizedBox(width: 8),
            Text('Resep Digital (e-Prescription)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('DIAGNOSA KLINIS', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
              const SizedBox(height: 4),
              TextField(
                controller: _diagCtrl,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                decoration: InputDecoration(
                  fillColor: NeoColors.bg,
                  filled: true,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
                ),
              ),
              const SizedBox(height: 14),
              const Text('DAFTAR OBAT & ATURAN PAKAI', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
              const SizedBox(height: 4),
              TextField(
                controller: _rxCtrl,
                maxLines: 4,
                style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                decoration: InputDecoration(
                  fillColor: NeoColors.bg,
                  filled: true,
                  hintText: 'Nama obat, dosis, frekuensi minum...',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: NeoColors.healthSoft, borderRadius: BorderRadius.circular(10)),
                child: const Text(
                  '💡 Resep ini langsung terhubung ke modul Apotek Bispira agar obat dapat ditebus & diantar via kurir express.',
                  style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: NeoColors.healthDark),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w800, color: Colors.black)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: NeoColors.health, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            onPressed: () {
              provider.updateConsultationStatus(
                widget.consultation.id,
                'completed',
                diagnosis: _diagCtrl.text.trim(),
                prescription: _rxCtrl.text.trim(),
              );
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('✅ Resep digital & diagnosa berhasil diterbitkan! Sesi selesai.'), backgroundColor: NeoColors.greenDark),
              );
            },
            child: const Text('Terbitkan Resep & Selesaikan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.consultation.patientName, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900)),
            Text('${widget.consultation.patientAge} th • ${widget.consultation.gender} • Telemedicine', style: const TextStyle(fontSize: 11, color: NeoColors.textMuted)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.receipt_long_rounded, color: NeoColors.health),
            tooltip: 'Resep Digital',
            onPressed: () => _showPrescriptionDialog(context, provider),
          ),
        ],
      ),
      body: Column(
        children: [
          // PATIENT COMPLAINT SUMMARY BAR
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0x1A0F172A), width: 1.5)),
            ),
            child: Row(
              children: [
                const Icon(Icons.medical_information_rounded, size: 20, color: NeoColors.health),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Keluhan: ${widget.consultation.complaint}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700),
                  ),
                ),
              ],
            ),
          ),

          // CHAT MESSAGES
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final m = _messages[index];
                final bool isDoc = m['isDoctor'] as bool;
                return Align(
                  alignment: isDoc ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                    decoration: BoxDecoration(
                      color: isDoc ? NeoColors.health : Colors.white,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.black, width: 1.5),
                      boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(2, 2), blurRadius: 0)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          m['text'] as String,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: isDoc ? Colors.white : Colors.black,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          m['time'] as String,
                          style: TextStyle(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: isDoc ? Colors.white70 : NeoColors.textMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          // CHAT INPUT BAR
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black, width: 1.8)),
            ),
            child: SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _msgCtrl,
                      decoration: InputDecoration(
                        hintText: 'Tulis anjuran / instruksi dokter...',
                        hintStyle: const TextStyle(fontSize: 12, color: NeoColors.textMuted),
                        filled: true,
                        fillColor: NeoColors.bg,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20), borderSide: const BorderSide(color: Colors.black, width: 1.2)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _sendMessage,
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: NeoColors.health,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.black, width: 1.5),
                      ),
                      child: const Icon(Icons.send_rounded, color: Colors.white, size: 18),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
