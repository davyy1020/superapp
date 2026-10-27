import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';

class MartScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const MartScreen({
    Key? key,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<MartScreen> createState() => _MartScreenState();
}

class _MartScreenState extends State<MartScreen> {
  int _userBalance = 250000;
  int _selectedCategoryIndex = 0;
  Map<int, int> _cartItems = {}; // productId -> quantity

  final List<String> _categories = [
    'Semua',
    '🥦 Buah & Sayur',
    '🌾 Sembako',
    '🥛 Dairy & Susu',
    '🍗 Daging Segar',
    '🍿 Snack & Drink',
    '🧼 Perawatan Diri'
  ];

  final List<Map<String, dynamic>> _products = [
    {
      'id': 101,
      'name': 'Beras Premium Ramos 5kg',
      'category': '🌾 Sembako',
      'price': 72500,
      'originalPrice': 85000,
      'unit': '5 kg',
      'merchant': 'BISPIRA Fresh Market',
      'rating': '4.9',
      'emoji': '🌾',
      'bgGradient': [const Color(0xFFFEF08A), const Color(0xFFCA8A04)],
    },
    {
      'id': 102,
      'name': 'Minyak Goreng Tropical 2L',
      'category': '🌾 Sembako',
      'price': 34500,
      'originalPrice': 39000,
      'unit': '2 Litre',
      'merchant': 'Indomaret Partner',
      'rating': '4.8',
      'emoji': '🍾',
      'bgGradient': [const Color(0xFFFDE047), const Color(0xFFEAB308)],
    },
    {
      'id': 103,
      'name': 'Apel Fuji Super Fresh',
      'category': '🥦 Buah & Sayur',
      'price': 28000,
      'originalPrice': 35000,
      'unit': '1 kg (isi 4-5)',
      'merchant': 'Toko Buah Segar Jaya',
      'rating': '4.9',
      'emoji': '🍎',
      'bgGradient': [const Color(0xFFFCA5A5), const Color(0xFFDC2626)],
    },
    {
      'id': 104,
      'name': 'Susu UHT Full Cream 1L',
      'category': '🥛 Dairy & Susu',
      'price': 18500,
      'originalPrice': 21000,
      'unit': '1000 ml',
      'merchant': 'BISPIRA Mart Hub',
      'rating': '4.9',
      'emoji': '🥛',
      'bgGradient': [const Color(0xFFBAE6FD), const Color(0xFF0284C7)],
    },
    {
      'id': 105,
      'name': 'Daging Sapi Slice Premium',
      'category': '🍗 Daging Segar',
      'price': 58000,
      'originalPrice': 65000,
      'unit': '500 gram',
      'merchant': 'Meatland Express',
      'rating': '5.0',
      'emoji': '🥩',
      'bgGradient': [const Color(0xFFF87171), const Color(0xFF991B1B)],
    },
    {
      'id': 106,
      'name': 'Sabun Mandi Lifebuoy Pack',
      'category': '🧼 Perawatan Diri',
      'price': 22500,
      'originalPrice': 26000,
      'unit': '4 x 110g',
      'merchant': 'Superindo Partner',
      'rating': '4.8',
      'emoji': '🧼',
      'bgGradient': [const Color(0xFFA7F3D0), const Color(0xFF059669)],
    },
  ];

  String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  int get _totalCartItems {
    int total = 0;
    _cartItems.forEach((_, qty) => total += qty);
    return total;
  }

  int get _totalCartPrice {
    int sum = 0;
    _cartItems.forEach((productId, qty) {
      final product = _products.firstWhere((p) => p['id'] == productId);
      sum += (product['price'] as int) * qty;
    });
    return sum;
  }

  void _addToCart(int productId) {
    setState(() {
      _cartItems[productId] = (_cartItems[productId] ?? 0) + 1;
    });
  }

  void _removeFromCart(int productId) {
    setState(() {
      if (_cartItems.containsKey(productId)) {
        if (_cartItems[productId]! > 1) {
          _cartItems[productId] = _cartItems[productId]! - 1;
        } else {
          _cartItems.remove(productId);
        }
      }
    });
  }

  void _showCheckoutModal() {
    if (_cartItems.isEmpty) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Container(
          padding: const EdgeInsets.all(22),
          decoration: const BoxDecoration(
            color: NeoColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            border: Border(top: BorderSide(color: NeoColors.black, width: 2.5)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Checkout BISPIRA Mart 🛒',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: NeoColors.brandSoft, shape: BoxShape.circle),
                      child: const Icon(Icons.close, size: 18, color: NeoColors.black),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Delivery Address Info
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: NeoColors.white,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: NeoColors.black, width: 1.5),
                ),
                child: Row(
                  children: const [
                    Icon(Icons.location_on_rounded, color: NeoColors.brand, size: 22),
                    SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Alamat Pengantaran (Instant 15 Mins)', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black)),
                          SizedBox(height: 2),
                          Text('Kost Menteng Heritage, Unit 402B • Jakarta Pusat', style: TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 14),

              // Item Summary
              const Text('Ringkasan Belanja', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black)),
              const SizedBox(height: 8),

              ..._cartItems.entries.map((entry) {
                final product = _products.firstWhere((p) => p['id'] == entry.key);
                final itemTotal = (product['price'] as int) * entry.value;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${entry.value}x  ${product['name']}',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: NeoColors.black),
                      ),
                      Text(
                        'Rp ${_formatPrice(itemTotal)}',
                        style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: NeoColors.black),
                      ),
                    ],
                  ),
                );
              }).toList(),

              const Divider(color: NeoColors.black, thickness: 1.2),
              const SizedBox(height: 6),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text('Ongkos Kirim Instant', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w600, color: NeoColors.black)),
                  Text('Rp 8.000', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w800, color: NeoColors.black)),
                ],
              ),
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total Pembayaran', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w900, color: NeoColors.black)),
                  Text(
                    'Rp ${_formatPrice(_totalCartPrice + 8000)}',
                    style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: NeoColors.brand),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Confirm Button
              GestureDetector(
                onTap: () {
                  Navigator.pop(ctx);
                  final grandTotal = _totalCartPrice + 8000;
                  setState(() {
                    _userBalance -= grandTotal;
                    _cartItems.clear();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Pesanan Mart Berhasil Dipesan! Kurir Instan BISPIRA sedang Meluncur 🛵💨'),
                      backgroundColor: NeoColors.brand,
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: NeoColors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      'Pesan Sekarang • Rp ${_formatPrice(_totalCartPrice + 8000)} 🛒',
                      style: const TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  // ============================================================
                  // 1. TOP HEADER BAR
                  // ============================================================
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
                          const Icon(Icons.shopping_bag_rounded, color: NeoColors.brand, size: 20),
                          const SizedBox(width: 4),
                          const Text(
                            'BISPIRA MART',
                            style: TextStyle(
                              color: NeoColors.brand,
                              fontWeight: FontWeight.w900,
                              fontSize: 18,
                              letterSpacing: 1.0,
                            ),
                          ),
                        ],
                      ),

                      // Balance Pill
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
                        decoration: BoxDecoration(
                          color: NeoColors.brandSoft,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: NeoColors.brand, width: 1.5),
                        ),
                        child: Text(
                          '💳 Rp ${_formatPrice(_userBalance)}',
                          style: const TextStyle(
                            color: NeoColors.brand,
                            fontWeight: FontWeight.w900,
                            fontSize: 11.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ============================================================
                  // 2. SEARCH & LOCATION BAR
                  // ============================================================
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: NeoColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NeoColors.black, width: 2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                      ],
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.search_rounded, color: NeoColors.black, size: 20),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Cari beras, minyak, buah, snack...',
                            style: TextStyle(color: NeoColors.textMuted, fontSize: 12, fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(Icons.tune_rounded, color: NeoColors.brand, size: 18),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // ============================================================
                  // 3. FLASH SALE MART BANNER
                  // ============================================================
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFFE11D48), Color(0xFF991B1B), Color(0xFF0F172A)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: NeoColors.black, width: 2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                      ],
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
                                color: const Color(0xFFFEF08A),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: NeoColors.black, width: 1.2),
                              ),
                              child: const Text(
                                '⚡ FLASH SALE MART',
                                style: TextStyle(
                                  color: NeoColors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 10,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            const Text(
                              'Berakhir dlm 02:45:10',
                              style: TextStyle(color: NeoColors.white, fontSize: 10.5, fontWeight: FontWeight.w800),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          'Diskon s/d 50% Sembako & Buah Segar! 🍎🌾',
                          style: TextStyle(
                            color: NeoColors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'Pengantaran Instan 15 Mins via BISPIRA Express Driver.',
                          style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ============================================================
                  // 4. CATEGORY CHIPS
                  // ============================================================
                  SizedBox(
                    height: 38,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      physics: const BouncingScrollPhysics(),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final bool isSel = _selectedCategoryIndex == index;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedCategoryIndex = index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            margin: const EdgeInsets.only(right: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? const Color(0xFF0F172A) : NeoColors.white,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: NeoColors.black,
                                width: isSel ? 2 : 1.5,
                              ),
                              boxShadow: isSel
                                  ? const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)]
                                  : null,
                            ),
                            child: Center(
                              child: Text(
                                _categories[index],
                                style: TextStyle(
                                  color: isSel ? NeoColors.white : NeoColors.black,
                                  fontWeight: FontWeight.w900,
                                  fontSize: 11.5,
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 18),

                  // ============================================================
                  // 5. PRODUCTS GRID SHOWCASE
                  // ============================================================
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Text(
                        'Produk Pilihan Harian',
                        style: TextStyle(
                          color: NeoColors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        'Mitra Terdekat 📍',
                        style: TextStyle(
                          color: NeoColors.brand,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 14,
                      childAspectRatio: 0.68,
                    ),
                    itemCount: _products.length,
                    itemBuilder: (context, index) {
                      final product = _products[index];
                      final int productId = product['id'] as int;
                      final int qtyInCart = _cartItems[productId] ?? 0;

                      return Container(
                        decoration: BoxDecoration(
                          color: NeoColors.surface,
                          borderRadius: BorderRadius.circular(18),
                          border: Border.all(color: NeoColors.black, width: 2),
                          boxShadow: const [
                            BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Header Banner Emoji Gradient
                            Container(
                              height: 100,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: product['bgGradient'] as List<Color>,
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                              ),
                              child: Center(
                                child: Text(product['emoji'] as String, style: const TextStyle(fontSize: 48)),
                              ),
                            ),

                            // Product Details Body
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      product['name'] as String,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: NeoColors.black,
                                        fontWeight: FontWeight.w900,
                                        fontSize: 12.5,
                                        height: 1.2,
                                      ),
                                    ),
                                    const SizedBox(height: 2),

                                    Text(
                                      '${product['unit']} • ${product['merchant']}',
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: NeoColors.textMuted,
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const Spacer(),

                                    // Price Row
                                    Row(
                                      children: [
                                        Text(
                                          'Rp ${_formatPrice(product['price'] as int)}',
                                          style: const TextStyle(
                                            color: NeoColors.black,
                                            fontWeight: FontWeight.w900,
                                            fontSize: 12.5,
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${_formatPrice(product['originalPrice'] as int)}',
                                          style: const TextStyle(
                                            color: NeoColors.textMuted,
                                            fontSize: 9.5,
                                            decoration: TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 8),

                                    // Cart Action Button / Counter
                                    qtyInCart == 0
                                        ? GestureDetector(
                                            onTap: () => _addToCart(productId),
                                            child: Container(
                                              width: double.infinity,
                                              padding: const EdgeInsets.symmetric(vertical: 6),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF0F172A),
                                                borderRadius: BorderRadius.circular(10),
                                                border: Border.all(color: NeoColors.black, width: 1.2),
                                              ),
                                              child: const Center(
                                                child: Text(
                                                  '+ Tambah',
                                                  style: TextStyle(
                                                    color: NeoColors.white,
                                                    fontWeight: FontWeight.w900,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          )
                                        : Container(
                                            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
                                            decoration: BoxDecoration(
                                              color: NeoColors.brandSoft,
                                              borderRadius: BorderRadius.circular(10),
                                              border: Border.all(color: NeoColors.brand, width: 1.2),
                                            ),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                GestureDetector(
                                                  onTap: () => _removeFromCart(productId),
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                                    child: Text('-', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.brand)),
                                                  ),
                                                ),
                                                Text(
                                                  '$qtyInCart',
                                                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black),
                                                ),
                                                GestureDetector(
                                                  onTap: () => _addToCart(productId),
                                                  child: const Padding(
                                                    padding: EdgeInsets.symmetric(horizontal: 6),
                                                    child: Text('+', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: NeoColors.brand)),
                                                  ),
                                                ),
                                              ],
                                            ),
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
                  const SizedBox(height: 80), // Space for floating cart bar
                ],
              ),
            ),

            // ============================================================
            // 6. FLOATING CART BAR (WHEN ITEMS IN CART)
            // ============================================================
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
                      border: Border.all(color: NeoColors.black, width: 2.2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
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
                        Row(
                          children: const [
                            Text('Checkout', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13)),
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
