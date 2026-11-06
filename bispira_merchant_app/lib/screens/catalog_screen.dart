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
    final prepTimeCtrl = TextEditingController(text: '15');
    final weightCtrl = TextEditingController(text: '350 gram');
    final bpomCtrl = TextEditingController(text: 'BPOM TR. 182390111');
    final variantCtrl = TextEditingController(text: 'Standar / Original');

    String selectedCluster = 'B1. Food & Resto';
    String portionUnit = 'Porsi';
    String qualityGrade = 'Grade A';
    bool requiresPrescription = false;
    String obatCategory = 'Obat Bebas (Hijau)';

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: NeoColors.black, width: 2.2),
            ),
            title: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: NeoColors.brandSoft,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: NeoColors.black, width: 1.5),
                  ),
                  child: const Icon(Icons.add_business_rounded, color: NeoColors.black, size: 20),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Tambah Produk / Menu',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ],
            ),
            content: SizedBox(
              width: double.maxFinite,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // PILIHAN CLUSTER PRODUK BACK END SESUAI EXCEL SHEET 10
                    const Text('CLUSTER PRODUK PENJUAL (SHEET 10 EXCEL)',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: NeoColors.surface,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NeoColors.black, width: 1.8),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedCluster,
                          isExpanded: true,
                          items: const [
                            DropdownMenuItem(value: 'B1. Food & Resto', child: Text('🍲 1. Food & Fresh (Resto/Sayur/Daging)')),
                            DropdownMenuItem(value: 'B2. Fresh Fruit', child: Text('🍎 1. Fresh Fruit / Buah & Telor')),
                            DropdownMenuItem(value: 'B3. Sembako Mart', child: Text('🌾 1. Sembako & Bahan Pokok')),
                            DropdownMenuItem(value: 'B4. Apotek & Farmasi', child: Text('💊 3. Health & Farmasi / Apotek')),
                            DropdownMenuItem(value: 'C1. Tiket Wisata', child: Text('🎟️ 2. Tiket Event MICE & Wisata')),
                            DropdownMenuItem(value: 'C2. Homecare & Beauty', child: Text('💆 3. Homecare, Perawat, SPA & Barbershop')),
                            DropdownMenuItem(value: 'D1. Sewa Property', child: Text('🏢 5. Sewa Kost, Kontrakan & Working Space')),
                            DropdownMenuItem(value: 'D2. Edukasi & Service', child: Text('🛠️ 6. Edukasi, MC/Band & Teknisi Service')),
                            DropdownMenuItem(value: 'E1. Donasi & Iklan', child: Text('🤝 7 & 8. Program Donasi & Pasang Iklan')),
                            DropdownMenuItem(value: 'E2. Event & E-Voting', child: Text('🗳️ 9-12. Bispira Event & E-Voting')),
                          ],
                          onChanged: (val) {
                            if (val != null) {
                              setModalState(() {
                                selectedCluster = val;
                                if (val.contains('B1')) portionUnit = 'Porsi';
                                else if (val.contains('B2')) portionUnit = 'Kg';
                                else if (val.contains('B3')) portionUnit = 'Bungkus / Kemasan';
                                else if (val.contains('B4')) portionUnit = 'Strip / Botol';
                                else if (val.contains('C1')) portionUnit = 'Tiket';
                                else if (val.contains('C2')) portionUnit = 'Sesi / Jam';
                                else if (val.contains('D1')) portionUnit = 'Bulan / Hari';
                                else if (val.contains('D2')) portionUnit = 'Layanan / Jam';
                                else portionUnit = 'Paket';
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // NAMA PRODUK
                    const Text('NAMA PRODUK / MENU',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        hintText: selectedCluster.contains('B1')
                            ? 'Contoh: Ayam Bakar Madu'
                            : (selectedCluster.contains('B2') ? 'Contoh: Apel Malang Manis' : 'Contoh: Beras Organik 5Kg'),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // HARGA DASAR TOKO
                    const Text('HARGA DASAR MERCHANT (RP)',
                        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        hintText: 'Contoh: 25000',
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      '💡 Pendapatan bersih toko 100%. Sistem otomatis menambahkan Markup 10% untuk konsumen (Excel Sheet 1 & 9).',
                      style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: NeoColors.brand),
                    ),
                    const SizedBox(height: 12),

                    // FIELD KHUSUS FORMULIR B1 (FOOD)
                    if (selectedCluster.contains('B1')) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('WAKTU PREP (MENIT)',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                                const SizedBox(height: 4),
                                TextField(
                                  controller: prepTimeCtrl,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    hintText: '15',
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('SATUAN JUAL',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                                const SizedBox(height: 4),
                                DropdownButtonFormField<String>(
                                  value: portionUnit,
                                  isDense: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'Porsi', child: Text('Porsi')),
                                    DropdownMenuItem(value: 'Box / Kotak', child: Text('Box')),
                                    DropdownMenuItem(value: 'Cup / Gelas', child: Text('Cup')),
                                    DropdownMenuItem(value: 'Paket Hemat', child: Text('Paket')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => portionUnit = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Text('PILIHAN VARIAN / RASA (OPSIONAL)',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                      const SizedBox(height: 4),
                      TextField(
                        controller: variantCtrl,
                        decoration: InputDecoration(
                          hintText: 'Contoh: Level 1 (Sedang), Level 2 (Pedas)',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                    ],

                    // FIELD KHUSUS FORMULIR B2 (FRESH FRUIT)
                    if (selectedCluster.contains('B2')) ...[
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('GRADE KUALITAS',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                                const SizedBox(height: 4),
                                DropdownButtonFormField<String>(
                                  value: qualityGrade,
                                  isDense: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'Grade A (Super)', child: Text('Grade A (Super)')),
                                    DropdownMenuItem(value: 'Grade B (Standar)', child: Text('Grade B')),
                                    DropdownMenuItem(value: 'Grade C (Lokal)', child: Text('Grade C')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => qualityGrade = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('SATUAN BERAT',
                                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                                const SizedBox(height: 4),
                                DropdownButtonFormField<String>(
                                  value: portionUnit,
                                  isDense: true,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                                  ),
                                  items: const [
                                    DropdownMenuItem(value: 'Kg', child: Text('Per Kg')),
                                    DropdownMenuItem(value: '500 gram', child: Text('500 gr')),
                                    DropdownMenuItem(value: 'Keranjang / Box', child: Text('Box')),
                                  ],
                                  onChanged: (val) {
                                    if (val != null) setModalState(() => portionUnit = val);
                                  },
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],

                    // FIELD KHUSUS FORMULIR B3 (SEMBAKO)
                    if (selectedCluster.contains('B3')) ...[
                      const Text('SATUAN KEMASAN / DISTRIBUSI',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: portionUnit,
                        isDense: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Bungkus / Kemasan', child: Text('Bungkus / Kemasan')),
                          DropdownMenuItem(value: 'Kg', child: Text('Kilogram (Kg)')),
                          DropdownMenuItem(value: 'Liter', child: Text('Liter (L)')),
                          DropdownMenuItem(value: 'Karton / Dus', child: Text('Karton / Dus')),
                          DropdownMenuItem(value: 'Karung 5Kg / 25Kg', child: Text('Karung')),
                        ],
                        onChanged: (val) {
                          if (val != null) setModalState(() => portionUnit = val);
                        },
                      ),
                    ],

                    // FIELD KHUSUS FORMULIR B4 (APOTEK)
                    if (selectedCluster.contains('B4')) ...[
                      const Text('NO REGISTRASI BPOM / IZIN EDAR',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                      const SizedBox(height: 4),
                      TextField(
                        controller: bpomCtrl,
                        decoration: InputDecoration(
                          hintText: 'Contoh: BPOM DTL 9212345678A1',
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text('GOLONGAN OBAT',
                          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                      const SizedBox(height: 4),
                      DropdownButtonFormField<String>(
                        value: obatCategory,
                        isDense: true,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                        ),
                        items: const [
                          DropdownMenuItem(value: 'Obat Bebas (Hijau)', child: Text('🟢 Obat Bebas (Hijau)')),
                          DropdownMenuItem(value: 'Obat Bebas Terbatas (Biru)', child: Text('🔵 Obat Bebas Terbatas (Biru)')),
                          DropdownMenuItem(value: 'Obat Keras (Merah / K)', child: Text('🔴 Obat Keras (Merah / K)')),
                          DropdownMenuItem(value: 'Herbal & Suplemen (Jamu)', child: Text('🌿 Herbal / Suplemen')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setModalState(() {
                              obatCategory = val;
                              if (val.contains('Keras')) {
                                requiresPrescription = true;
                              }
                            });
                          }
                        },
                      ),
                      const SizedBox(height: 8),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Wajib Resep Dokter (Form B4 Kolom 12)',
                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                        value: requiresPrescription,
                        activeColor: NeoColors.red,
                        onChanged: (val) {
                          setModalState(() => requiresPrescription = val ?? false);
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Batal'),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: NeoColors.brand,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                    side: const BorderSide(color: NeoColors.black, width: 1.5),
                  ),
                ),
                onPressed: () {
                  final String name = nameCtrl.text.trim();
                  final int basePrice = int.tryParse(priceCtrl.text.trim()) ?? 0;
                  final int prepTime = int.tryParse(prepTimeCtrl.text.trim()) ?? 15;

                  if (name.isNotEmpty && basePrice > 0) {
                    String emoji = '🍲';
                    if (selectedCluster.contains('B2')) emoji = '🍎';
                    else if (selectedCluster.contains('B3')) emoji = '🌾';
                    else if (selectedCluster.contains('B4')) emoji = '💊';

                    merchant.addProduct(
                      name,
                      selectedCluster,
                      emoji,
                      basePrice,
                      portionUnit: portionUnit,
                      prepTimeMinutes: prepTime,
                      weightVolume: weightCtrl.text.trim(),
                      variantOptions: variantCtrl.text.trim(),
                      qualityGrade: qualityGrade,
                      bpomLicense: selectedCluster.contains('B4') ? bpomCtrl.text.trim() : '-',
                      requiresPrescription: requiresPrescription,
                    );
                    Navigator.pop(ctx);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: NeoColors.greenDark,
                        content: Text('✅ $name berhasil ditambahkan ke katalog toko!'),
                      ),
                    );
                  }
                },
                child: const Text('Simpan Produk', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900)),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final merchant = Provider.of<MerchantProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(
        title: const Text('Katalog Menu & Produk Toko'),
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
                border: Border.all(color: NeoColors.black, width: 1.8),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.receipt_long_rounded, color: NeoColors.black, size: 24),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Rincian Transparansi Excel Sheet 1 & Formulir B1-B4:\n'
                      '• Harga Dasar: 100% Hak Toko / Merchant (Tanpa Potongan)\n'
                      '• Harga Konsumen: Ditambah Markup Platform 10%\n'
                      '• Spesifikasi Teknis Sesuai 22 Formulir Pendaftaran Penjual',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: NeoColors.black, height: 1.35),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'DAFTAR PRODUK & STOK TOKO',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted),
                ),
                Text(
                  '${merchant.products.length} Item Terdaftar',
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: NeoColors.brand),
                ),
              ],
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
                  margin: const EdgeInsets.only(bottom: 14),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: NeoColors.black, width: 1.8),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13.5, color: NeoColors.black),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                                      decoration: BoxDecoration(
                                        color: NeoColors.bg,
                                        borderRadius: BorderRadius.circular(6),
                                        border: Border.all(color: NeoColors.black, width: 1),
                                      ),
                                      child: Text(
                                        product.category,
                                        style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w800, color: NeoColors.black),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  children: [
                                    Text(
                                      'Harga Toko: ${currencyFmt.format(product.basePriceMerchant)}',
                                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.greenDark),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '(${product.portionUnit})',
                                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.textMuted),
                                    ),
                                  ],
                                ),
                                Text(
                                  'Aplikasi Konsumen (+10%): ${currencyFmt.format(product.consumerPrice)}',
                                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.brand),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      // ATRIBUT FORMULIR B1-B4 SPESIFIKASI
                      Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: [
                          if (product.prepTimeMinutes > 0)
                            _buildAttrChip(Icons.timer_outlined, 'Prep: ${product.prepTimeMinutes} mnt', NeoColors.goldSoft),
                          if (product.qualityGrade.isNotEmpty && product.qualityGrade != '-')
                            _buildAttrChip(Icons.verified_outlined, product.qualityGrade, NeoColors.brandSoft),
                          if (product.bpomLicense.isNotEmpty && product.bpomLicense != '-')
                            _buildAttrChip(Icons.medical_services_outlined, product.bpomLicense, const Color(0xFFE0F2FE)),
                          if (product.requiresPrescription)
                            _buildAttrChip(Icons.warning_amber_rounded, 'Wajib Resep Dokter', const Color(0xFFFEE2E2)),
                          if (product.variantOptions.isNotEmpty && product.variantOptions != '-')
                            _buildAttrChip(Icons.tune_rounded, product.variantOptions, NeoColors.bg),
                        ],
                      ),
                      const SizedBox(height: 10),
                      const Divider(height: 1, thickness: 1, color: Color(0xFFE2E8F0)),
                      const SizedBox(height: 8),

                      // STOCK SWITCH & STATUS
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                product.isAvailable ? Icons.check_circle_rounded : Icons.cancel_rounded,
                                size: 16,
                                color: product.isAvailable ? NeoColors.greenDark : NeoColors.red,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                product.isAvailable ? 'STATUS: STOK TERSEDIA' : 'STATUS: STOK KOSONG',
                                style: TextStyle(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w900,
                                  color: product.isAvailable ? NeoColors.greenDark : NeoColors.red,
                                ),
                              ),
                            ],
                          ),
                          Switch(
                            value: product.isAvailable,
                            activeColor: NeoColors.brand,
                            activeTrackColor: NeoColors.brandSoft,
                            onChanged: (_) => merchant.toggleProductAvailability(product.id),
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

  Widget _buildAttrChip(IconData icon, String label, Color bgColor) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: NeoColors.black, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: NeoColors.black),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800, color: NeoColors.black),
          ),
        ],
      ),
    );
  }
}
