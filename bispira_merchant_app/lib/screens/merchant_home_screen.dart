import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/merchant_provider.dart';
import '../theme/neo_theme.dart';
import 'catalog_screen.dart';
import 'merchant_wallet_screen.dart';
import 'merchant_profile_screen.dart';

class MerchantHomeScreen extends StatefulWidget {
  const MerchantHomeScreen({Key? key}) : super(key: key);

  @override
  State<MerchantHomeScreen> createState() => _MerchantHomeScreenState();
}

class _MerchantHomeScreenState extends State<MerchantHomeScreen> {
  int _selectedTab = 0;
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedTab,
          children: [
            _buildOrderManagerTab(context),
            const CatalogScreen(),
            const MerchantWalletScreen(),
            const MerchantProfileScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildOrderManagerTab(BuildContext context) {
    final merchant = Provider.of<MerchantProvider>(context);

    return Column(
      children: [
        // 1. TOP HEADER STORE BANNER
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
          decoration: BoxDecoration(
            color: NeoColors.surface,
            border: const Border(bottom: BorderSide(color: NeoColors.black, width: 2)),
            boxShadow: const [
              BoxShadow(color: NeoColors.black, offset: Offset(0, 2), blurRadius: 0),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: merchant.isStoreOpen ? NeoColors.green : Colors.grey,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        merchant.storeName,
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: NeoColors.black),
                      ),
                      Text(
                        merchant.isStoreOpen ? 'TOKO BUKA (Menerima Order)' : 'TOKO TUTUP',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          color: merchant.isStoreOpen ? NeoColors.greenDark : NeoColors.red,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Switch(
                value: merchant.isStoreOpen,
                activeColor: NeoColors.green,
                onChanged: (val) => merchant.toggleStoreStatus(),
              ),
            ],
          ),
        ),

        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 2. TODAY SALES PERFORMANCE SUMMARY CARD
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: NeoColors.cardDark,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: NeoColors.black, width: 2.2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                    ],
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'PENJUALAN HARI INI (100% BASE)',
                            style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted, letterSpacing: 0.8),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: NeoColors.gold,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(
                              '★ ${merchant.storeRating}',
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoColors.black),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currencyFmt.format(merchant.todaySalesAmount),
                            style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900, color: NeoColors.white),
                          ),
                          Text(
                            '${merchant.todayOrdersCount} Orderan',
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: NeoColors.brandSoft),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 18),

                // SIMULATION BUTTON FOR DEMONSTRATION
                GestureDetector(
                  onTap: () {
                    if (!merchant.isStoreOpen) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Buka toko terlebih dahulu!')),
                      );
                      return;
                    }
                    merchant.simulateIncomingOrder();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: NeoColors.green,
                        content: Text('🔔 Orderan Makanan Baru Masuk ke Dapur!'),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: NeoColors.brand,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NeoColors.black, width: 2),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                      ],
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.bolt_rounded, color: NeoColors.white, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'SIMULASI ORDERAN MASUK ⚡',
                          style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 22),

                // ORDER QUEUE SECTION
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'ANTREAN ORDERAN MASUK',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted),
                    ),
                    Text(
                      '${merchant.orders.length} Transaksi',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoColors.brand),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // ORDERS LIST
                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: merchant.orders.length,
                  itemBuilder: (context, index) {
                    final order = merchant.orders[index];
                    return _buildOrderCard(context, merchant, order);
                  },
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildOrderCard(BuildContext context, MerchantProvider merchant, MerchantOrder order) {
    Color statusBg = NeoColors.goldSoft;
    Color statusBorder = NeoColors.gold;
    String statusLabel = 'ORDER BARU';

    if (order.status == 'preparing') {
      statusBg = NeoColors.brandSoft;
      statusBorder = NeoColors.brand;
      statusLabel = 'SEDANG DIMASAK 🍳';
    } else if (order.status == 'ready') {
      statusBg = NeoColors.greenSoft;
      statusBorder = NeoColors.green;
      statusLabel = 'SIAP DIAMBIL DRIVER 🛵';
    } else if (order.status == 'completed') {
      statusBg = const Color(0xFFF1F5F9);
      statusBorder = const Color(0xFFCBD5E1);
      statusLabel = 'SELESAI ✅';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NeoColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NeoColors.black, width: 2),
        boxShadow: const [
          BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order #${order.id}',
                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14, color: NeoColors.black),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: statusBg,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: statusBorder, width: 1.2),
                ),
                child: Text(
                  statusLabel,
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.black),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Pelanggan: ${order.customerName} • ${order.orderTime}',
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: NeoColors.textMuted),
          ),
          const SizedBox(height: 4),
          Text(
            'Driver: ${order.driverName}',
            style: const TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: NeoColors.brand),
          ),
          const SizedBox(height: 8),
          const Divider(color: NeoColors.black, height: 1, thickness: 1),
          const SizedBox(height: 8),

          Text(
            'Menu: ${order.itemsSummary}',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.black),
          ),
          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('SETTLEMENT MERCHANT (100%)', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                  Text(
                    currencyFmt.format(order.totalMerchantEarning),
                    style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.greenDark),
                  ),
                ],
              ),

              // ACTION BUTTON BASED ON ORDER STATUS
              if (order.status == 'incoming')
                GestureDetector(
                  onTap: () => merchant.updateOrderStatus(order.id, 'preparing'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: NeoColors.brand,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: NeoColors.black, width: 1.8),
                    ),
                    child: const Text('TERIMA & MASAK 🍳', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 12)),
                  ),
                )
              else if (order.status == 'preparing')
                GestureDetector(
                  onTap: () => merchant.updateOrderStatus(order.id, 'ready'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: NeoColors.green,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: NeoColors.black, width: 1.8),
                    ),
                    child: const Text('MAKANAN SIAP 🛵', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 12)),
                  ),
                )
              else if (order.status == 'ready')
                GestureDetector(
                  onTap: () => merchant.updateOrderStatus(order.id, 'completed'),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: NeoColors.gold,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: NeoColors.black, width: 1.8),
                    ),
                    child: const Text('SERAHKAN KE DRIVER ✅', style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 12)),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomBar() {
    return Container(
      decoration: const BoxDecoration(
        color: NeoColors.surface,
        border: Border(top: BorderSide(color: NeoColors.black, width: 2)),
      ),
      child: BottomNavigationBar(
        currentIndex: _selectedTab,
        onTap: (i) => setState(() => _selectedTab = i),
        selectedItemColor: NeoColors.brand,
        unselectedItemColor: NeoColors.textMuted,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11),
        unselectedLabelStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 11),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.receipt_long_rounded), label: 'Kasir Order'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu_rounded), label: 'Menu & Stok'),
          BottomNavigationBarItem(icon: Icon(Icons.account_balance_wallet_rounded), label: 'Dompet Settlement'),
          BottomNavigationBarItem(icon: Icon(Icons.store_rounded), label: 'Profil Outlet'),
        ],
      ),
    );
  }
}
