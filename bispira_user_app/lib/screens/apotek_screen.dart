import 'dart:math';
import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';

class ApotekScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const ApotekScreen({
    Key? key,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<ApotekScreen> createState() => _ApotekScreenState();
}

class _ApotekScreenState extends State<ApotekScreen> {
  int _selectedCategoryIndex = 0;
  final Map<int, int> _cartItems = {}; // productId -> quantity
  bool _hasPrescriptionUploaded = false;
  String _uploadedPrescriptionName = '';

  final List<String> _categories = [
    'Semua',
    '💊 Obat Bebas & Flu',
    '🌿 Vitamin & Imun',
    '🩹 P3K & Luka',
    '🩺 Resep Dokter',
    '👶 Anak & Bayi',
  ];

  final List<Map<String, dynamic>> _medicines = [
    {
      'id': 201,
      'name': 'Paracetamol 500mg (10 Kaplet)',
      'brand': 'Sanbe Farma',
      'category': '💊 Obat Bebas & Flu',
      'price': 8500,
      'form': 'Tablet / Kaplet',
      'dose': '500 mg',
      'unit': 'Strip isi 10',
      'nie': 'DBL8814702304A1',
      'pharmacy': 'Apotek Kimia Farma Mitra BISPIRA',
      'rating': '4.9',
      'emoji': '💊',
      'bgGradient': [Color(0xFFBAE6FD), Color(0xFF0284C7)],
      'needsPrescription': false,
    },
    {
      'id': 202,
      'name': 'Vitamin C 500mg Plus Zinc',
      'brand': 'Enervon-C',
      'category': '🌿 Vitamin & Imun',
      'price': 42000,
      'form': 'Tablet Salut Selaput',
      'dose': '500 mg',
      'unit': 'Botol isi 30',
      'nie': 'SD011501141',
      'pharmacy': 'Apotek K-24 Mitra BISPIRA',
      'rating': '5.0',
      'emoji': '🍊',
      'bgGradient': [Color(0xFFFED7AA), Color(0xFFEA580C)],
      'needsPrescription': false,
    },
    {
      'id': 203,
      'name': 'Sirup Obat Batuk Herbal 100ml',
      'brand': 'OBH Combi Herbal',
      'category': '💊 Obat Bebas & Flu',
      'price': 22500,
      'form': 'Sirup Cair',
      'dose': '100 ml',
      'unit': 'Botol 100 ml',
      'nie': 'TR142681531',
      'pharmacy': 'Apotek Berkah Sehat',
      'rating': '4.8',
      'emoji': '🍯',
      'bgGradient': [Color(0xFFFEF08A), Color(0xFFCA8A04)],
      'needsPrescription': false,
    },
    {
      'id': 204,
      'name': 'Promag Obat Sakit Maag & Kembung',
      'brand': 'Kalbe Farma',
      'category': '💊 Obat Bebas & Flu',
      'price': 9000,
      'form': 'Tablet Kunyah',
      'dose': 'Hydrotalcite 200mg',
      'unit': 'Blister isi 10',
      'nie': 'DBL9111601963A1',
      'pharmacy': 'Apotek Kimia Farma Mitra BISPIRA',
      'rating': '4.9',
      'emoji': '🌿',
      'bgGradient': [Color(0xFFBBF7D0), Color(0xFF16A34A)],
      'needsPrescription': false,
    },
    {
      'id': 205,
      'name': 'Betadine Antiseptik Cair 30ml',
      'brand': 'Mundipharma',
      'category': '🩹 P3K & Luka',
      'price': 18500,
      'form': 'Cairan Antiseptik',
      'dose': 'Povidone Iodine 10%',
      'unit': 'Botol 30 ml',
      'nie': 'PKD20501710087',
      'pharmacy': 'Apotek K-24 Mitra BISPIRA',
      'rating': '4.9',
      'emoji': '🩹',
      'bgGradient': [Color(0xFFFECDD3), Color(0xFFE11D48)],
      'needsPrescription': false,
    },
    {
      'id': 206,
      'name': 'Amoxicillin 500mg (Antibiotik Resep)',
      'brand': 'Bernofarm',
      'category': '🩺 Resep Dokter',
      'price': 16000,
      'form': 'Kapsul / Kaplet',
      'dose': '500 mg',
      'unit': 'Strip isi 10',
      'nie': 'GKL9802324904A1',
      'pharmacy': 'Apotek Kimia Farma Mitra BISPIRA',
      'rating': '4.9',
      'emoji': '🩺',
      'bgGradient': [Color(0xFFE9D5FF), Color(0xFF9333EA)],
      'needsPrescription': true,
    },
  ];

  int get _totalCartItems {
    return _cartItems.values.fold(0, (sum, qty) => sum + qty);
  }

  int get _totalCartPrice {
    int total = 0;
    _cartItems.forEach((id, qty) {
      final med = _medicines.firstWhere((m) => m['id'] == id);
      total += (med['price'] as int) * qty;
    });
    return total;
  }

  void _addToCart(int id) {
    final med = _medicines.firstWhere((m) => m['id'] == id);
    if (med['needsPrescription'] == true && !_hasPrescriptionUploaded) {
      _showUploadPrescriptionDialog(requiredForId: id);
      return;
    }

    setState(() {
      _cartItems[id] = (_cartItems[id] ?? 0) + 1;
    });
  }

  void _removeFromCart(int id) {
    setState(() {
      if (_cartItems.containsKey(id)) {
        if (_cartItems[id]! > 1) {
          _cartItems[id] = _cartItems[id]! - 1;
        } else {
          _cartItems.remove(id);
        }
      }
    });
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }

  void _showUploadPrescriptionDialog({int? requiredForId}) {
    final noteController = TextEditingController();
    showDialog(
      context: context,
      builder: (dCtx) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: NeoColors.black, width: 2.2),
          ),
          title: const Row(
            children: [
              Icon(Icons.receipt_long_rounded, color: NeoColors.brand, size: 24),
              SizedBox(width: 8),
              Text('Unggah Resep Dokter', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Sesuai regulasi BPOM & Kementerian Kesehatan, pembelian obat keras wajib melampirkan foto resep dokter yang valid.',
                  style: TextStyle(fontSize: 11.5, color: NeoColors.textMuted, height: 1.3),
                ),
                const SizedBox(height: 14),

                // MOCK PHOTO UPLOADER BOX
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
                  decoration: BoxDecoration(
                    color: NeoColors.bg,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: NeoColors.black, width: 1.5, style: BorderStyle.solid),
                  ),
                  child: Column(
                    children: const [
                      Icon(Icons.add_a_photo_rounded, size: 36, color: NeoColors.brand),
                      SizedBox(height: 8),
                      Text('Ambil Foto atau Pilih dari Galeri', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                      SizedBox(height: 4),
                      Text('JPG, PNG, atau PDF (Maks. 5 MB)', style: TextStyle(fontSize: 10, color: NeoColors.textMuted)),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // NOTES INPUT
                const Text('Catatan untuk Apoteker (Opsional)', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
                const SizedBox(height: 6),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    hintText: 'Misal: nama pasien, alergi obat, dll.',
                    hintStyle: const TextStyle(fontSize: 11, color: NeoColors.textMuted),
                    filled: true,
                    fillColor: NeoColors.bg,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: const BorderSide(color: NeoColors.black, width: 1.2)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dCtx),
              child: const Text('Batal', style: TextStyle(color: NeoColors.textMuted, fontWeight: FontWeight.w700)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: NeoColors.brand,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              onPressed: () {
                Navigator.pop(dCtx);
                setState(() {
                  _hasPrescriptionUploaded = true;
                  _uploadedPrescriptionName = 'Resep_Dokter_DrAdrian_${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}.jpg';
                  if (requiredForId != null) {
                    _cartItems[requiredForId] = (_cartItems[requiredForId] ?? 0) + 1;
                  }
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('✅ Resep Dokter Berhasil Diunggah & Terverifikasi Apoteker!'),
                    backgroundColor: NeoColors.green,
                  ),
                );
              },
              child: const Text('Simpan & Lanjutkan', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900)),
            ),
          ],
        );
      },
    );
  }

  void _showCheckoutModal() {
    String selectedPayment = 'transfer'; // 'transfer', 'qris', 'cash'
    final int uniqueCode = 100 + Random().nextInt(899);
    const int deliveryFee = 8000;
    const int appFee = 500;
    const int serviceFee = 500;
    final int subtotal = _totalCartPrice;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final int baseTotal = subtotal + deliveryFee + appFee + serviceFee;
            final int grandTotal = (selectedPayment == 'transfer') ? baseTotal + uniqueCode : baseTotal;

            return Container(
              padding: EdgeInsets.only(
                left: 20,
                right: 20,
                top: 20,
                bottom: MediaQuery.of(ctx).viewInsets.bottom + 20,
              ),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
                border: Border.all(color: NeoColors.black, width: 2.5),
              ),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          '🛒 Checkout Apotek On-Demand',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
                        ),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close_rounded, color: NeoColors.black, size: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // ALAMAT ANTAR
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: NeoColors.bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NeoColors.black, width: 1.2),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.location_on_rounded, color: NeoColors.brand, size: 22),
                          SizedBox(width: 8),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Alamat Pengantaran (Kurir Motor R2)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                                SizedBox(height: 2),
                                Text('Jl. Thamrin No. 42, RT 02 / RW 05, Jakarta Pusat', style: TextStyle(fontSize: 10.5, color: NeoColors.textMuted)),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // STATUS RESEP DOKTER
                    if (_hasPrescriptionUploaded)
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: NeoColors.green.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: NeoColors.green, width: 1.2),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified_rounded, color: NeoColors.green, size: 18),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                'Resep terlampir: $_uploadedPrescriptionName',
                                style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.black),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // RINGKASAN ITEMS
                    const Text('RINCIAN OBAT / PRODUK:', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                    const SizedBox(height: 6),
                    ..._cartItems.entries.map((e) {
                      final med = _medicines.firstWhere((m) => m['id'] == e.key);
                      final int lineTotal = (med['price'] as int) * e.value;
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 2),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(child: Text('${e.value}x ${med['name']}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700))),
                            Text('Rp ${_formatPrice(lineTotal)}', style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800)),
                          ],
                        ),
                      );
                    }).toList(),

                    const Divider(height: 16),

                    // BIAYA BIAYA
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Ongkos Kirim Kurir Motor:', style: TextStyle(fontSize: 11, color: NeoColors.textMuted)),
                        Text('Rp ${_formatPrice(deliveryFee)}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya Aplikasi (Excel):', style: TextStyle(fontSize: 11, color: NeoColors.textMuted)),
                        Text('Rp 500', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    const SizedBox(height: 3),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Biaya Layanan (Excel):', style: TextStyle(fontSize: 11, color: NeoColors.textMuted)),
                        Text('Rp 500', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                      ],
                    ),
                    if (selectedPayment == 'transfer') ...[
                      const SizedBox(height: 3),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('3 Digit Kode Unik Rekonsiliasi:', style: TextStyle(fontSize: 11, color: NeoColors.brand, fontWeight: FontWeight.w700)),
                          Text('+$uniqueCode', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoColors.brand)),
                        ],
                      ),
                    ],
                    const Divider(height: 14),

                    // TOTAL
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total Tagihan Pembeli:', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900)),
                        Text('Rp ${_formatPrice(grandTotal)}', style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: NeoColors.brand)),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // PILIHAN METODE PEMBAYARAN (MEETING POINT 7 & 10: NO BUYER EWALLET)
                    const Text('PILIH METODE PEMBAYARAN PEMBELI:', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                    const SizedBox(height: 8),

                    // 1. Transfer ATM / M-Banking
                    GestureDetector(
                      onTap: () => setModalState(() => selectedPayment = 'transfer'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: selectedPayment == 'transfer' ? NeoColors.brandSoft : NeoColors.bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: selectedPayment == 'transfer' ? NeoColors.brand : NeoColors.black, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.account_balance_rounded, color: NeoColors.brand, size: 20),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Transfer Bank (ATM / M-Banking)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                                  Text('BCA / Mandiri / BRI / BNI + 3 Digit Kode Unik', style: TextStyle(fontSize: 10, color: NeoColors.textMuted)),
                                ],
                              ),
                            ),
                            Radio<String>(
                              value: 'transfer',
                              groupValue: selectedPayment,
                              onChanged: (val) => setModalState(() => selectedPayment = val!),
                              activeColor: NeoColors.brand,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 2. QRIS Pay
                    GestureDetector(
                      onTap: () => setModalState(() => selectedPayment = 'qris'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 8),
                        decoration: BoxDecoration(
                          color: selectedPayment == 'qris' ? NeoColors.brandSoft : NeoColors.bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: selectedPayment == 'qris' ? NeoColors.brand : NeoColors.black, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.qr_code_2_rounded, color: NeoColors.brand, size: 20),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('QRIS Dinamis', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                                  Text('Scan instan lewat BCA Mobile, GoPay, OVO, ShopeePay', style: TextStyle(fontSize: 10, color: NeoColors.textMuted)),
                                ],
                              ),
                            ),
                            Radio<String>(
                              value: 'qris',
                              groupValue: selectedPayment,
                              onChanged: (val) => setModalState(() => selectedPayment = val!),
                              activeColor: NeoColors.brand,
                            ),
                          ],
                        ),
                      ),
                    ),

                    // 3. Tunai kepada Driver
                    GestureDetector(
                      onTap: () => setModalState(() => selectedPayment = 'cash'),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: selectedPayment == 'cash' ? NeoColors.brandSoft : NeoColors.bg,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: selectedPayment == 'cash' ? NeoColors.brand : NeoColors.black, width: 1.5),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.payments_rounded, color: NeoColors.greenDark, size: 20),
                            const SizedBox(width: 10),
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Tunai Langsung ke Driver Kurir', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5)),
                                  Text('Sistem otomatis memotong saldo dompet driver', style: TextStyle(fontSize: 10, color: NeoColors.textMuted)),
                                ],
                              ),
                            ),
                            Radio<String>(
                              value: 'cash',
                              groupValue: selectedPayment,
                              onChanged: (val) => setModalState(() => selectedPayment = val!),
                              activeColor: NeoColors.brand,
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // MANDATORY WARNING BOX (MEETING POINT 11)
                    if (selectedPayment == 'transfer')
                      Container(
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: NeoColors.goldSoft,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: NeoColors.orange, width: 1.2),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.warning_amber_rounded, color: NeoColors.orange, size: 18),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '⚠️ Mohon masukkan nominal sampai tiga angka terakhir secara benar saat transfer agar otomatis terverifikasi sistem.',
                                style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.black),
                              ),
                            ),
                          ],
                        ),
                      ),

                    // SUBMIT BUTTON
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(ctx);
                        setState(() {
                          _cartItems.clear();
                        });

                        showDialog(
                          context: context,
                          builder: (okCtx) => AlertDialog(
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: NeoColors.black, width: 2)),
                            title: const Row(
                              children: [
                                Icon(Icons.check_circle_rounded, color: NeoColors.green, size: 24),
                                SizedBox(width: 8),
                                Text('Pesanan Diterima!', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                              ],
                            ),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Apotek mitra sedang menyiapkan obat Anda.'),
                                const SizedBox(height: 8),
                                Text('Total Bayar: Rp ${_formatPrice(grandTotal)}', style: const TextStyle(fontWeight: FontWeight.w900, color: NeoColors.brand)),
                                const SizedBox(height: 4),
                                Text('Metode: ${selectedPayment == "transfer" ? "Transfer Bank (+kode unik $uniqueCode)" : selectedPayment == "qris" ? "QRIS Pay" : "Tunai ke Driver Kurir"}', style: const TextStyle(fontSize: 12)),
                                const SizedBox(height: 8),
                                const Text('Kurir Motor BISPIRA akan segera mengantarkan ke alamat Anda. 🛵💨', style: TextStyle(fontSize: 11.5, color: NeoColors.textMuted)),
                              ],
                            ),
                            actions: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(backgroundColor: NeoColors.brand),
                                onPressed: () => Navigator.pop(okCtx),
                                child: const Text('OK', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w900)),
                              ),
                            ],
                          ),
                        );
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: NeoColors.green,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: NeoColors.black, width: 2),
                          boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0)],
                        ),
                        child: Center(
                          child: Text(
                            'BAYAR SEKARANG • Rp ${_formatPrice(grandTotal)} ⚡',
                            style: const TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _selectedCategoryIndex == 0
        ? _medicines
        : _medicines.where((m) => m['category'] == _categories[_selectedCategoryIndex]).toList();

    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // HEADER BAR
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          if (widget.onBackPressed != null) ...[
                            GestureDetector(
                              onTap: widget.onBackPressed,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: NeoColors.brandSoft,
                                  shape: BoxShape.circle,
                                  border: Border.all(color: NeoColors.black, width: 1.5),
                                ),
                                child: const Icon(Icons.arrow_back_rounded, size: 16, color: NeoColors.black),
                              ),
                            ),
                            const SizedBox(width: 8),
                          ],
                          const Icon(Icons.local_pharmacy_rounded, color: NeoColors.brand, size: 22),
                          const SizedBox(width: 6),
                          const Text(
                            'BISPIRA APOTEK',
                            style: TextStyle(
                              color: NeoColors.brand,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: NeoColors.green.withOpacity(0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: NeoColors.green, width: 1.2),
                        ),
                        child: const Text('🩺 Resmi & Berizin', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: NeoColors.greenDark)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // HERO CARD UPLOAD RESEP DOKTER
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF0F172A), Color(0xFF1E3A8A), Color(0xFF0284C7)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: NeoColors.black, width: 2),
                      boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0)],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: NeoColors.gold,
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: NeoColors.black, width: 1.2),
                              ),
                              child: const Text(
                                '💊 LAYANAN RESEP DOKTER',
                                style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 10),
                              ),
                            ),
                            if (_hasPrescriptionUploaded)
                              const Text('✅ Resep Terpasang', style: TextStyle(color: NeoColors.greenLight, fontSize: 10.5, fontWeight: FontWeight.w800)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Punya Resep dari Dokter?',
                          style: TextStyle(color: NeoColors.white, fontSize: 16, fontWeight: FontWeight.w900),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Unggah foto resep Anda. Apoteker mitra akan menebus obat & kurir motor mengantarkannya langsung.',
                          style: TextStyle(color: Colors.white70, fontSize: 11, height: 1.3),
                        ),
                        const SizedBox(height: 12),
                        GestureDetector(
                          onTap: _showUploadPrescriptionDialog,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: NeoColors.gold,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.camera_alt_rounded, size: 16, color: NeoColors.black),
                                const SizedBox(width: 6),
                                Text(
                                  _hasPrescriptionUploaded ? 'Ganti Foto Resep 🔄' : '+ Unggah Foto Resep Dokter',
                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: NeoColors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // CATEGORIES
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final isSel = _selectedCategoryIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategoryIndex = index),
                          child: Container(
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF0F172A) : NeoColors.white,
                              borderRadius: BorderRadius.circular(18),
                              border: Border.all(color: NeoColors.black, width: isSel ? 2 : 1.5),
                            ),
                            child: Center(
                              child: Text(
                                _categories[index],
                                style: TextStyle(
                                  color: isSel ? NeoColors.white : NeoColors.black,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),

                  // MEDICINES GRID
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Katalog Apotek On-Demand', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900)),
                      Text('Kurir Motor 15-30 Mnt 🛵', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: NeoColors.brand)),
                    ],
                  ),
                  const SizedBox(height: 12),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.65,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final med = filtered[index];
                      final int medId = med['id'] as int;
                      final int qty = _cartItems[medId] ?? 0;

                      return Container(
                        decoration: BoxDecoration(
                          color: NeoColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: NeoColors.black, width: 2),
                          boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0)],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              height: 90,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: med['bgGradient'] as List<Color>,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              child: Center(
                                child: Text(med['emoji'] as String, style: const TextStyle(fontSize: 42)),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    if (med['needsPrescription'] == true)
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                        margin: const EdgeInsets.only(bottom: 4),
                                        decoration: BoxDecoration(color: NeoColors.redSoft, borderRadius: BorderRadius.circular(4)),
                                        child: const Text('RESEP DOKTER', style: TextStyle(fontSize: 8.5, fontWeight: FontWeight.w900, color: NeoColors.red)),
                                      ),
                                    Text(
                                      med['name'] as String,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, height: 1.2),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '${med['brand']} • ${med['unit']}',
                                      style: const TextStyle(fontSize: 9.5, color: NeoColors.textMuted),
                                    ),
                                    const Spacer(),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          'Rp ${_formatPrice(med['price'] as int)}',
                                          style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.brand),
                                        ),
                                        if (qty == 0)
                                          GestureDetector(
                                            onTap: () => _addToCart(medId),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                              decoration: BoxDecoration(
                                                color: NeoColors.brand,
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                              child: const Text('+ Beli', style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.w900)),
                                            ),
                                          )
                                        else
                                          Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () => _removeFromCart(medId),
                                                child: const Text('-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: NeoColors.brand)),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(horizontal: 6),
                                                child: Text('$qty', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11)),
                                              ),
                                              GestureDetector(
                                                onTap: () => _addToCart(medId),
                                                child: const Text('+', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: NeoColors.brand)),
                                              ),
                                            ],
                                          ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 80),
                ],
              ),
            ),

            // FLOATING CART BAR
            if (_cartItems.isNotEmpty)
              Positioned(
                bottom: 16,
                left: 18,
                right: 18,
                child: GestureDetector(
                  onTap: _showCheckoutModal,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: NeoColors.black, width: 2),
                      boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0)],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: NeoColors.green,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                '$_totalCartItems Item',
                                style: const TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 11),
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'Rp ${_formatPrice(_totalCartPrice)}',
                              style: const TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 14),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text('Checkout Kurir Motor', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 12.5)),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_forward_rounded, color: NeoColors.white, size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
