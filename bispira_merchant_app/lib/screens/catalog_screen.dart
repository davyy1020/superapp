import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/merchant_provider.dart';
import '../theme/neo_theme.dart';

class CatalogScreen extends StatefulWidget {
  const CatalogScreen({Key? key}) : super(key: key);

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  void _openAddProductDialog(BuildContext context, MerchantProvider merchant) {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    String category = 'Makanan Utama';
    String emoji = '🍲';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: NeoColors.black, width: 2.2),
        ),
        title: const Text('➕ Tambah Menu Baru', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('NAMA MENU / BARANG', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
            const SizedBox(height: 4),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                hintText: 'Contoh: Sate Ayam Madura',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 12),
            const Text('HARGA DASAR MERCHANT (RP)', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
            const SizedBox(height: 4),
            TextField(
              controller: priceCtrl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: 'Contoh: 20000',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              '💡 Sistem akan otomatis menambahkan Markup 20% pada aplikasi konsumen BISPIRA.',
              style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.brand),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: NeoColors.brand),
            onPressed: () {
              final String name = nameCtrl.text;
              final int basePrice = int.tryParse(priceCtrl.text) ?? 0;
              if (name.isNotEmpty && basePrice > 0) {
                merchant.addProduct(name, category, emoji, basePrice);
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Menu Baru Berhasil Ditambahkan!')),
                );
              }
            },
            child: const Text('Simpan Menu', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final merchant = Provider.of<MerchantProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(
        title: const Text('Katalog Menu & Stok Toko'),
        automaticallyImplyLeading: false,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: IconButton(
              icon: const Icon(Icons.add_circle_rounded, color: NeoColors.brand, size: 28),
              onPressed: () => _openAddProductDialog(context, merchant),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // EXCEL MARKUP EXPLANATION BANNER
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: NeoColors.goldSoft,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: NeoColors.gold, width: 1.8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_rounded, color: NeoColors.black, size: 22),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'Rincian Transparansi Excel:\n• Harga Dasar: Pendapatan Bersih Resto (100%)\n• Harga Konsumen: Ditambah Markup Platform 20%',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: NeoColors.black, height: 1.3),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'DAFTAR MENU & STOK TERSEDIA',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted),
            ),
            const SizedBox(height: 12),

            // PRODUCTS LIST
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: merchant.products.length,
              itemBuilder: (context, index) {
                final product = merchant.products[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: NeoColors.black, width: 1.8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: NeoColors.brandSoft,
                          borderRadius: BorderRadius.circular(14),
                          border: Border.all(color: NeoColors.black, width: 1.2),
                        ),
                        child: Text(product.emoji, style: const TextStyle(fontSize: 26)),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product.name,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5, color: NeoColors.black),
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Harga Toko: ${currencyFmt.format(product.basePriceMerchant)}',
                              style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: NeoColors.greenDark),
                            ),
                            Text(
                              'Tampil di User (+20%): ${currencyFmt.format(product.consumerPrice)}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.brand),
                            ),
                          ],
                        ),
                      ),

                      // Availability Switch
                      Column(
                        children: [
                          Text(
                            product.isAvailable ? 'STOK ADA' : 'HABIS ✖️',
                            style: TextStyle(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w900,
                              color: product.isAvailable ? NeoColors.greenDark : NeoColors.red,
                            ),
                          ),
                          Switch(
                            value: product.isAvailable,
                            activeColor: NeoColors.green,
                            onChanged: (val) => merchant.toggleProductAvailability(product.id),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
