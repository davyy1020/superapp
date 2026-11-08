import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/health_provider.dart';
import '../theme/neo_theme.dart';

class HealthServicesCatalogScreen extends StatefulWidget {
  const HealthServicesCatalogScreen({Key? key}) : super(key: key);

  @override
  State<HealthServicesCatalogScreen> createState() => _HealthServicesCatalogScreenState();
}

class _HealthServicesCatalogScreenState extends State<HealthServicesCatalogScreen> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void _openAddServiceDialog(BuildContext context, HealthProvider provider) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '75000');
    VisitType selectedType = VisitType.chatTelemedicine;
    int duration = 30;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.black, width: 2)),
            title: const Row(
              children: [
                Icon(Icons.medical_services_rounded, color: NeoColors.health),
                SizedBox(width: 8),
                Text('Tambah Layanan Medis', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NAMA LAYANAN / TINDAKAN', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Contoh: Konsultasi Psikologi / Fisioterapi',
                      fillColor: NeoColors.bg,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text('JENIS KUNJUNGAN', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<VisitType>(
                    value: selectedType,
                    decoration: InputDecoration(
                      fillColor: NeoColors.bg,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
                    ),
                    items: const [
                      DropdownMenuItem(value: VisitType.chatTelemedicine, child: Text('💬 Telemedicine Chat')),
                      DropdownMenuItem(value: VisitType.clinicVisit, child: Text('🏥 Janji Temu di Klinik')),
                      DropdownMenuItem(value: VisitType.homeVisit, child: Text('🏡 Home Visit (Kunjungan Rumah)')),
                    ],
                    onChanged: (val) {
                      if (val != null) setModalState(() => selectedType = val);
                    },
                  ),
                  const SizedBox(height: 12),

                  const Text('TARIF DASAR TENAGA MEDIS (RP)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: priceCtrl,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    decoration: InputDecoration(
                      prefixText: 'Rp ',
                      fillColor: NeoColors.bg,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: NeoColors.healthSoft, borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      '💡 100% tarif ini masuk ke dompet Anda. Platform menambahkan 10% markup otomatis ke pasien.',
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
                  final price = int.tryParse(priceCtrl.text) ?? 50000;
                  if (nameCtrl.text.trim().isNotEmpty) {
                    provider.addService(HealthServiceItem(
                      id: 'HLT-${DateTime.now().millisecondsSinceEpoch % 10000}',
                      name: nameCtrl.text.trim(),
                      category: selectedType == VisitType.homeVisit ? 'Home Visit' : 'Klinik / Chat',
                      visitType: selectedType,
                      basePrice: price,
                      durationMinutes: duration,
                    ));
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Simpan Layanan', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<HealthProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(
        title: const Text('Katalog Tarif & Layanan Medis'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_rounded, color: NeoColors.black),
            onPressed: () => _openAddServiceDialog(context, provider),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(18),
        itemCount: provider.services.length,
        itemBuilder: (context, index) {
          final s = provider.services[index];
          final typeLabel = s.visitType == VisitType.chatTelemedicine
              ? '💬 Chat Medis'
              : s.visitType == VisitType.clinicVisit
                  ? '🏥 Tatap Muka Klinik'
                  : '🏡 Home Visit';

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.black, width: 1.8),
              boxShadow: const [BoxShadow(color: Colors.black, offset: Offset(3, 3), blurRadius: 0)],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: NeoColors.healthSoft,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: NeoColors.health, width: 1.2),
                      ),
                      child: Text(typeLabel, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.healthDark)),
                    ),
                    Switch(
                      value: s.isAvailable,
                      activeColor: NeoColors.health,
                      onChanged: (_) => provider.toggleServiceAvailability(s.id),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(s.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 4),
                Text(s.description, style: const TextStyle(fontSize: 11, color: NeoColors.textMuted)),
                const Divider(height: 20, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Tarif Dokter (100% Hak Anda):', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                        Text(currencyFmt.format(s.basePrice), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.greenDark)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Tarif Pasien (+10% Markup):', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                        Text(currencyFmt.format(s.consumerPrice), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12, color: NeoColors.black)),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
