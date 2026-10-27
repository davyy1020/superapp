import 'package:flutter/material.dart';
import '../theme/neo_theme.dart';
import '../widgets/neo_widgets.dart';

class TaxScreen extends StatefulWidget {
  final VoidCallback? onBackPressed;

  const TaxScreen({
    Key? key,
    this.onBackPressed,
  }) : super(key: key);

  @override
  State<TaxScreen> createState() => _TaxScreenState();
}

class _TaxScreenState extends State<TaxScreen> {
  int _userBalance = 250000;
  int _sisaKewajiban = 2250000;
  int _totalSetoran = 10000000;

  final List<Map<String, dynamic>> _taxTransactions = [
    {
      'title': 'Top-Up Virtual Account BNI',
      'date': '24 Okt 2026 • 14:20',
      'amount': '+ Rp 5.000.000',
      'isPositive': true,
      'status': 'Berhasil',
      'icon': Icons.account_balance_wallet_rounded,
    },
    {
      'title': 'Bayar PPh Final Masa Sept',
      'date': '20 Okt 2026 • 09:15',
      'amount': '- Rp 1.450.000',
      'isPositive': false,
      'status': 'Berhasil',
      'icon': Icons.receipt_long_rounded,
    },
    {
      'title': 'Withdrawal ke Bank Mandiri',
      'date': '15 Okt 2026 • 17:45',
      'amount': '- Rp 10.000.000',
      'isPositive': false,
      'status': 'Berhasil',
      'icon': Icons.account_balance_rounded,
    },
    {
      'title': 'Bayar PPh Final Masa Agust',
      'date': '18 Sep 2026 • 11:30',
      'amount': '- Rp 1.300.000',
      'isPositive': false,
      'status': 'Berhasil',
      'icon': Icons.receipt_long_rounded,
    },
  ];

  String _formatPrice(int amount) {
    return amount.toString().replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]}.',
        );
  }

  void _showTopUpModal() {
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
                    'Top-Up Saldo BISPIRA Tax 💳',
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

              const Text('Pilih Nominal Top-Up Virtual Account (BNI/Mandiri):',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NeoColors.black)),
              const SizedBox(height: 12),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [500000, 1000000, 2500000].map((amt) {
                  return GestureDetector(
                    onTap: () {
                      Navigator.pop(ctx);
                      setState(() {
                        _userBalance += amt;
                        _taxTransactions.insert(0, {
                          'title': 'Top-Up Virtual Account BNI',
                          'date': 'Hari Ini • Sekarang',
                          'amount': '+ Rp ${_formatPrice(amt)}',
                          'isPositive': true,
                          'status': 'Berhasil',
                          'icon': Icons.account_balance_wallet_rounded,
                        });
                      });
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Top-Up Rp ${_formatPrice(amt)} Berhasil Ditambahkan ke Saldo BISPIRA! 💳'),
                          backgroundColor: NeoColors.brand,
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      decoration: BoxDecoration(
                        color: NeoColors.brandSoft,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: NeoColors.black, width: 1.5),
                        boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)],
                      ),
                      child: Text(
                        'Rp ${_formatPrice(amt)}',
                        style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: NeoColors.black),
                      ),
                    ),
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }

  void _showDownloadToast(String fileType) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Dokumen Bukti Potong Tax ($fileType) Berhasil Diunduh ke HP Anda! 📥'),
        backgroundColor: const Color(0xFF10B981),
      ),
    );
  }

  void _payRemainingTax() {
    if (_userBalance < _sisaKewajiban) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Saldo BISPIRA Anda tidak cukup. Silakan Lakukan Top-Up terlebih dahulu!'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    setState(() {
      _userBalance -= _sisaKewajiban;
      _totalSetoran += _sisaKewajiban;
      _sisaKewajiban = 0;
      _taxTransactions.insert(0, {
        'title': 'Pelunasan PPh Final 2024',
        'date': 'Hari Ini • Sekarang',
        'amount': '- Rp 2.250.000',
        'isPositive': false,
        'status': 'Berhasil',
        'icon': Icons.verified_rounded,
      });
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Pembayaran Pajak PPh Final Berhasil! Status Pajak Anda: 100% PATUH PAJAK 🏆'),
        backgroundColor: NeoColors.brand,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: NeoColors.bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ============================================================
              // 1. TOP HEADER BAR WITH SOFT NEO BACK BUTTON
              // ============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      SoftNeoBackButton(onBackPressed: widget.onBackPressed),
                      if (widget.onBackPressed != null) const SizedBox(width: 10),

                      // Brand Logo & Title
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: NeoColors.brandSoft,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: NeoColors.brand, width: 1.5),
                        ),
                        child: const Icon(Icons.account_balance_rounded, color: NeoColors.brand, size: 18),
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'BISPIRA TAX',
                        style: TextStyle(
                          color: NeoColors.brand,
                          fontWeight: FontWeight.w900,
                          fontSize: 18,
                          letterSpacing: 1.0,
                        ),
                      ),
                    ],
                  ),

                  // Wallet Balance Pill
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: NeoColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NeoColors.black, width: 1.8),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text('Wallet Balance', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                        Text('Rp ${_formatPrice(_userBalance)}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.black)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ============================================================
              // 2. GREETING & ACTION BUTTONS
              // ============================================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: NeoColors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: NeoColors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Halo, Merchant BISPIRA 👋', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: NeoColors.black)),
                    const SizedBox(height: 2),
                    Row(
                      children: const [
                        Text('Update pajak tahunan Anda hari ini: ', style: TextStyle(fontSize: 11.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
                        Text('Patuh Pajak 🟢', style: TextStyle(fontSize: 11.5, color: Color(0xFF10B981), fontWeight: FontWeight.w900)),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Action Buttons Row (Top-Up & Withdraw)
                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: _showTopUpModal,
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF0EA5E9),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: NeoColors.black, width: 1.8),
                                boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.add_circle_outline_rounded, color: NeoColors.white, size: 16),
                                  SizedBox(width: 6),
                                  Text('+ Top-Up BNI', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Withdrawal saldo merchant sedang diproses ke rekening bank terdaftar.'),
                                  backgroundColor: NeoColors.brand,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: NeoColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: NeoColors.black, width: 1.8),
                                boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.account_balance_wallet_rounded, color: NeoColors.black, size: 16),
                                  SizedBox(width: 6),
                                  Text('Withdraw', style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 12)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ============================================================
              // 3. ANNUAL OMZET TRACKER CARD (TAHUN FISKAL 2024)
              // ============================================================
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: NeoColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: NeoColors.black, width: 2.2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text('Annual Omzet Tracker', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: NeoColors.black)),
                            Text('Tahun Fiskal 2026', style: TextStyle(fontSize: 11, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFCCFBF1),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: NeoColors.black, width: 1.2),
                          ),
                          child: const Text(
                            'UMKM PPh Final 0.5%',
                            style: TextStyle(color: Color(0xFF0F766E), fontWeight: FontWeight.w900, fontSize: 10.5),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Progress Trend Card
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: NeoColors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(color: NeoColors.black, width: 1.5),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text('Status Omzet: Rp 2.450.000.000', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, color: NeoColors.black)),
                              Text('Threshold: Rp 4.8M', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11, color: NeoColors.textMuted)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: const LinearProgressIndicator(
                              value: 0.51,
                              minHeight: 8,
                              backgroundColor: Color(0xFFE2E8F0),
                              valueColor: AlwaysStoppedAnimation<Color>(NeoColors.brand),
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Text('Anda masih berada dalam kategori UMKM PPh Final 0.5%.', style: TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Metrics Breakdown Row
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text('PPh Final Terutang', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                              SizedBox(height: 2),
                              Text('Rp 12.250.000', style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: NeoColors.brand)),
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Total Setoran', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                              const SizedBox(height: 2),
                              Text('Rp ${_formatPrice(_totalSetoran)}', style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w900, color: NeoColors.black)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const Divider(color: NeoColors.black, thickness: 1.2),
                    const SizedBox(height: 8),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Sisa Kewajiban', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.black)),
                        Text(
                          'Rp ${_formatPrice(_sisaKewajiban)}',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w900,
                            color: _sisaKewajiban > 0 ? Colors.redAccent : const Color(0xFF10B981),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Pay Remaining Button
                    if (_sisaKewajiban > 0)
                      GestureDetector(
                        onTap: _payRemainingTax,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: NeoColors.black, width: 1.8),
                            boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)],
                          ),
                          child: Center(
                            child: Text(
                              'Bayar Sisa Kewajiban (Rp ${_formatPrice(_sisaKewajiban)}) 💳',
                              style: const TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 12.5),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ============================================================
              // 4. BUKTI POTONG & PELAPORAN CARD (PDF & EXCEL EXPORT)
              // ============================================================
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: NeoColors.black, width: 2.2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3.5, 3.5), blurRadius: 0),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: const [
                        Icon(Icons.description_rounded, color: Color(0xFF38BDF8), size: 24),
                        SizedBox(width: 10),
                        Text(
                          'Bukti Potong & Pelaporan',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15, color: NeoColors.white),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Unduh dokumen resmi untuk keperluan pelaporan pajak tahunan Anda.',
                      style: TextStyle(fontSize: 11.5, color: Colors.white70, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 16),

                    Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showDownloadToast('PDF Bukti Potong'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: NeoColors.white,
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: NeoColors.black, width: 1.8),
                                boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.picture_as_pdf_rounded, color: Colors.redAccent, size: 16),
                                  SizedBox(width: 6),
                                  Text('Download PDF', style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 11.5)),
                                ],
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => _showDownloadToast('Excel .xlsx'),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: const Color(0xFFFEF08A),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(color: NeoColors.black, width: 1.8),
                                boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2, 2), blurRadius: 0)],
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Icon(Icons.table_chart_rounded, color: Color(0xFF15803D), size: 16),
                                  SizedBox(width: 6),
                                  Text('Export Excel', style: TextStyle(color: NeoColors.black, fontWeight: FontWeight.w900, fontSize: 11.5)),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // ============================================================
              // 5. PREMIUM SUPPORT CARD
              // ============================================================
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF08A),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(color: NeoColors.black, width: 2),
                  boxShadow: const [
                    BoxShadow(color: NeoColors.black, offset: Offset(3, 3), blurRadius: 0),
                  ],
                ),
                child: Row(
                  children: const [
                    Text('⭐', style: TextStyle(fontSize: 22)),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Premium Support Pakar Pajak', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black)),
                          SizedBox(height: 2),
                          Text('Konsultasi gratis dengan pakar pajak untuk omzet di atas Rp 2M.', style: TextStyle(fontSize: 10.5, color: NeoColors.black, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // ============================================================
              // 6. HISTORY TRANSAKSI LIST
              // ============================================================
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  Text(
                    'History Transaksi',
                    style: TextStyle(color: NeoColors.black, fontSize: 15, fontWeight: FontWeight.w900),
                  ),
                  Text(
                    'Lihat Semua',
                    style: TextStyle(color: NeoColors.brand, fontSize: 12, fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _taxTransactions.length,
                itemBuilder: (context, index) {
                  final tx = _taxTransactions[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 10),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: NeoColors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: NeoColors.black, width: 1.8),
                      boxShadow: const [
                        BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: NeoColors.brandSoft,
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: NeoColors.brand, width: 1.2),
                          ),
                          child: Icon(tx['icon'] as IconData, color: NeoColors.brand, size: 20),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tx['title'] as String,
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.black),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                tx['date'] as String,
                                style: const TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              tx['amount'] as String,
                              style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 12,
                                color: (tx['isPositive'] as bool) ? const Color(0xFF10B981) : Colors.redAccent,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              tx['status'] as String,
                              style: const TextStyle(fontSize: 10, fontWeight: FontWeight.w800, color: NeoColors.textMuted),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}
