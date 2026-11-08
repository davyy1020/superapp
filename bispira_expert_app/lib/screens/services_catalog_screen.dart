import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/expert_provider.dart';
import '../theme/neo_theme.dart';

class ExpertServicesCatalogScreen extends StatefulWidget {
  const ExpertServicesCatalogScreen({Key? key}) : super(key: key);

  @override
  State<ExpertServicesCatalogScreen> createState() => _ExpertServicesCatalogScreenState();
}

class _ExpertServicesCatalogScreenState extends State<ExpertServicesCatalogScreen> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void _openAddServiceDialog(BuildContext context, ExpertProvider provider) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '100000');
    final unitCtrl = TextEditingController(text: 'per Sesi (90 Menit)');
    String selectedCategory = 'Edukasi & Bimbel Privat';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20), side: const BorderSide(color: Colors.black, width: 2)),
            title: const Row(
              children: [
                Icon(Icons.post_add_rounded, color: NeoColors.expert),
                SizedBox(width: 8),
                Text('Tambah Paket / Layanan', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
              ],
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('NAMA LAYANAN / KEAHLIAN', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: nameCtrl,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    decoration: InputDecoration(
                      hintText: 'Contoh: Les Privat Kimia / MC Wedding',
                      fillColor: NeoColors.bg,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text('KATEGORI KEAHLIAN', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                  const SizedBox(height: 4),
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategory,
                    decoration: InputDecoration(
                      fillColor: NeoColors.bg,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
                    ),
                    items: const [
                      DropdownMenuItem(value: 'Edukasi & Bimbel Privat', child: Text('📚 Edukasi & Bimbel Privat')),
                      DropdownMenuItem(value: 'Trainer Pelatihan Kejuruan', child: Text('💻 Trainer IT & Pelatihan')),
                      DropdownMenuItem(value: 'Entertainment & Acara', child: Text('🎤 MC & Group Band')),
                      DropdownMenuItem(value: 'Teknisi Service Panggilan', child: Text('🔧 Teknisi AC & Elektronik')),
                      DropdownMenuItem(value: 'Konsultan Ahli & Legal', child: Text('⚖️ Konsultan Pajak & Bisnis')),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setModalState(() {
                          selectedCategory = val;
                          if (val.contains('Edukasi')) unitCtrl.text = 'per Sesi (90 Menit)';
                          else if (val.contains('Entertainment')) unitCtrl.text = 'per Event / Acara';
                          else if (val.contains('Teknisi')) unitCtrl.text = 'per Unit / Pengerjaan';
                        });
                      }
                    },
                  ),
                  const SizedBox(height: 12),

                  const Text('SATUAN TARIF', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                  const SizedBox(height: 4),
                  TextField(
                    controller: unitCtrl,
                    style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 12),
                    decoration: InputDecoration(
                      fillColor: NeoColors.bg,
                      filled: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: Colors.black, width: 1.5)),
                    ),
                  ),
                  const SizedBox(height: 12),

                  const Text('HONORARIUM MITRA (RP)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
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
                    decoration: BoxDecoration(color: NeoColors.expertSoft, borderRadius: BorderRadius.circular(10)),
                    child: const Text(
                      '💡 100% honor ini masuk ke dompet Anda. Platform menambahkan 10% markup otomatis ke murid/klien.',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: NeoColors.expertDark),
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
                style: ElevatedButton.styleFrom(backgroundColor: NeoColors.expert, shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  final price = int.tryParse(priceCtrl.text) ?? 100000;
                  if (nameCtrl.text.trim().isNotEmpty) {
                    provider.addService(ExpertServiceItem(
                      id: 'EXP-${DateTime.now().millisecondsSinceEpoch % 10000}',
                      name: nameCtrl.text.trim(),
                      category: selectedCategory,
                      unitLabel: unitCtrl.text.trim(),
                      basePrice: price,
                    ));
                    Navigator.pop(ctx);
                  }
                },
                child: const Text('Simpan Paket Jasa', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ExpertProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(
        title: const Text('Katalog Jasa, Les & Paket Tarif'),
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
                        color: NeoColors.expertSoft,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: NeoColors.expert, width: 1.2),
                      ),
                      child: Text(s.category, style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.expertDark)),
                    ),
                    Switch(
                      value: s.isAvailable,
                      activeThumbColor: NeoColors.expert,
                      onChanged: (_) => provider.toggleServiceAvailability(s.id),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(s.name, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14)),
                const SizedBox(height: 4),
                Text(s.description, style: const TextStyle(fontSize: 11, color: NeoColors.textMuted)),
                const SizedBox(height: 8),
                Text('Satuan: ${s.unitLabel}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: NeoColors.black)),
                const Divider(height: 20, thickness: 1),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Honor Bersih Mitra:', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                        Text(currencyFmt.format(s.basePrice), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.greenDark)),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Harga ke Murid (+10%):', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
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

