import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/driver_provider.dart';
import '../theme/neo_theme.dart';

class DriverWalletScreen extends StatefulWidget {
  const DriverWalletScreen({Key? key}) : super(key: key);

  @override
  State<DriverWalletScreen> createState() => _DriverWalletScreenState();
}

class _DriverWalletScreenState extends State<DriverWalletScreen> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final _amountController = TextEditingController(text: '100000');
  final _accountController = TextEditingController(text: '8840192381');
  final _topUpAmountController = TextEditingController(text: '50000');
  String _selectedBank = 'BCA';
  String _selectedTopUpBank = 'BCA (088219920 - PT BISPIRA)';

  final List<String> _bankList = [
    'BCA',
    'Bank Mandiri',
    'BRI',
    'BNI',
    'BSI',
    'Bank Jateng',
    'Bank Jatim',
    'Bank DKI',
    'Bank BJB',
  ];

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    _topUpAmountController.dispose();
    super.dispose();
  }

  void _openWithdrawalModal(BuildContext context, DriverProvider driver) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('⚡ Penarikan Dana Rekening Driver', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black)),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close_rounded, color: NeoColors.black, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 10),

              // INFO BIAYA TRANSFER & JADWAL CAIR (SHEET 5)
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: NeoColors.brandSoft,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: NeoColors.brand, width: 1.2),
                ),
                child: const Text(
                  '💡 Biaya transfer pencairan: Rp 1.000 / batch (Excel Sheet 5).\nJadwal pencairan rutin: Senin & Kamis (17.00 - 23.59 WIB).',
                  style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w700, color: NeoColors.black, height: 1.3),
                ),
              ),
              const SizedBox(height: 14),

              // BANK SELECTOR DROPDOWN
              const Text('PILIK BANK TUJUAN', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: NeoColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: NeoColors.black, width: 1.8),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _selectedBank,
                    isExpanded: true,
                    items: _bankList.map((bank) {
                      return DropdownMenuItem(
                        value: bank,
                        child: Text('Bank $bank', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13)),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) setState(() => _selectedBank = val);
                    },
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ACCOUNT NUMBER
              const Text('NOMOR REKENING DRIVER', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: NeoColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: NeoColors.black, width: 1.8),
                ),
                child: TextField(
                  controller: _accountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13),
                  decoration: const InputDecoration(border: InputBorder.none, hintText: 'Masukkan no. rekening'),
                ),
              ),
              const SizedBox(height: 12),

              // AMOUNT TO WITHDRAW
              const Text('NOMINAL PENARIKAN (RP)', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: NeoColors.bg,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: NeoColors.black, width: 1.8),
                ),
                child: TextField(
                  controller: _amountController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.brand),
                  decoration: const InputDecoration(border: InputBorder.none, prefixText: 'Rp '),
                ),
              ),
              const SizedBox(height: 18),

              // SUBMIT WITHDRAWAL BUTTON
              GestureDetector(
                onTap: () {
                  final int amt = int.tryParse(_amountController.text) ?? 0;
                  final success = driver.requestBIFastWithdrawal(amt, _selectedBank, _accountController.text);
                  Navigator.pop(ctx);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: NeoColors.green,
                        content: Text('⚡ Penarikan Rp ${currencyFmt.format(amt)} via BI-FAST Berhasil Ditransfer!'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: NeoColors.red,
                        content: Text('Nominal penarikan melebihi saldo dompet Anda!'),
                      ),
                    );
                  }
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    color: NeoColors.green,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: NeoColors.black, width: 2),
                    boxShadow: const [
                      BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0),
                    ],
                  ),
                  child: const Center(
                    child: Text(
                      'PROSES PENARIKAN INSTAN ⚡',
                      style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
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

  void _openTopUpModal(BuildContext context, DriverProvider driver) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final int topUpNominal = int.tryParse(_topUpAmountController.text) ?? 50000;
            const int feeLayanan = 500;
            const int feeApp = 500;
            final int netMasuk = (topUpNominal >= 1000) ? topUpNominal - (feeLayanan + feeApp) : 0;

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
                        const Text('💳 Top Up Saldo Driver', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black)),
                        GestureDetector(
                          onTap: () => Navigator.pop(ctx),
                          child: const Icon(Icons.close_rounded, color: NeoColors.black, size: 22),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // PRESET CHIPS
                    const Text('PILIH NOMINAL TOP-UP CEPAT (MIN. RP 50.000):', style: TextStyle(fontSize: 10, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [50000, 100000, 200000, 300000].map((nom) {
                        final isSel = topUpNominal == nom;
                        return GestureDetector(
                          onTap: () {
                            setModalState(() {
                              _topUpAmountController.text = nom.toString();
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                            decoration: BoxDecoration(
                              color: isSel ? NeoColors.brand : NeoColors.bg,
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: NeoColors.black, width: 1.5),
                            ),
                            child: Text(
                              currencyFmt.format(nom),
                              style: TextStyle(
                                color: isSel ? NeoColors.white : NeoColors.black,
                                fontWeight: FontWeight.w800,
                                fontSize: 11.5,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 14),

                    // INPUT NOMINAL
                    const Text('NOMINAL TOP-UP LAINNYA', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _topUpAmountController,
                      keyboardType: TextInputType.number,
                      onChanged: (_) => setModalState(() {}),
                      style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
                      decoration: InputDecoration(
                        prefixText: 'Rp ',
                        prefixStyle: const TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black),
                        filled: true,
                        fillColor: NeoColors.bg,
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: NeoColors.black, width: 1.8)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(14), borderSide: const BorderSide(color: NeoColors.black, width: 1.8)),
                      ),
                    ),
                    const SizedBox(height: 12),

                    // RINCIAN BIAYA BOX
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: NeoColors.bg,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NeoColors.black, width: 1.2),
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Nominal Top-Up:', style: TextStyle(fontSize: 11.5, color: NeoColors.textMuted)),
                              Text(currencyFmt.format(topUpNominal), style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Biaya Layanan (Excel):', style: TextStyle(fontSize: 11.5, color: NeoColors.textMuted)),
                              Text('-Rp 500', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5, color: NeoColors.orange)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          const Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Biaya Aplikasi (Excel):', style: TextStyle(fontSize: 11.5, color: NeoColors.textMuted)),
                              Text('-Rp 500', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 11.5, color: NeoColors.orange)),
                            ],
                          ),
                          const Divider(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Estimasi Saldo Masuk:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900)),
                              Text(currencyFmt.format(netMasuk), style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.greenDark)),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),

                    // WARNING KODE UNIK
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: NeoColors.goldSoft,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: NeoColors.orange, width: 1.4),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_rounded, color: NeoColors.orange, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              '⚠️ PENTING: Mohon masukkan nominal sampai tiga angka terakhir (kode unik) secara benar saat pembayaran via m-Banking/ATM agar saldo terverifikasi otomatis.',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: NeoColors.black, height: 1.3),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),

                    // SUBMIT BUTTON
                    GestureDetector(
                      onTap: () {
                        if (topUpNominal < 50000) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Minimal top up saldo driver adalah Rp 50.000'), backgroundColor: NeoColors.red),
                          );
                          return;
                        }

                        final res = driver.requestDriverTopUp(topUpNominal, _selectedTopUpBank);
                        Navigator.pop(ctx);

                        if (res['success'] == true) {
                          showDialog(
                            context: context,
                            builder: (dCtx) => AlertDialog(
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18), side: const BorderSide(color: NeoColors.black, width: 2)),
                              title: const Row(
                                children: [
                                  Icon(Icons.check_circle_rounded, color: NeoColors.green, size: 24),
                                  SizedBox(width: 8),
                                  Text('Instruksi Transfer', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16)),
                                ],
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Silakan transfer tepat sesuai nominal berikut:', style: TextStyle(fontSize: 12)),
                                  const SizedBox(height: 10),
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: NeoColors.bg, borderRadius: BorderRadius.circular(10)),
                                    child: Column(
                                      children: [
                                        Text('Rp ${res['totalTransfer']}', style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w900, color: NeoColors.brand)),
                                        Text('(Termasuk 3 digit kode unik +${res['uniqueCode']})', style: const TextStyle(fontSize: 11, color: NeoColors.textMuted)),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Text('Saldo masuk bersih: Rp ${res['netSaldo']}', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NeoColors.greenDark)),
                                ],
                              ),
                              actions: [
                                ElevatedButton(
                                  onPressed: () => Navigator.pop(dCtx),
                                  style: ElevatedButton.styleFrom(backgroundColor: NeoColors.brand),
                                  child: const Text('Saya Mengerti', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800)),
                                ),
                              ],
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: NeoColors.brand,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: NeoColors.black, width: 2),
                          boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0)],
                        ),
                        child: const Center(
                          child: Text(
                            'BAYAR TOP-UP SEKARANG ⚡',
                            style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 13.5),
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
    final driver = Provider.of<DriverProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(
        title: const Text('Dompet BI-FAST Driver'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // MAIN SALDO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: NeoColors.cardDark,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: NeoColors.black, width: 2.2),
                boxShadow: const [
                  BoxShadow(color: NeoColors.black, offset: Offset(4, 4), blurRadius: 0),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'SALDO PENDAPATAN DRIVER',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, color: NeoColors.textMuted, letterSpacing: 0.8),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: NeoColors.brand.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: NeoColors.brand),
                        ),
                        child: const Text(
                          '⚡ BI-FAST Ready',
                          style: TextStyle(color: NeoColors.brandSoft, fontSize: 10.5, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFmt.format(driver.walletBalance),
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: NeoColors.white),
                  ),
                  const SizedBox(height: 16),

                  Row(
                    children: [
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _openTopUpModal(context, driver),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: NeoColors.brand,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: NeoColors.black, width: 1.8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.add_circle_outline_rounded, color: NeoColors.white, size: 18),
                                SizedBox(width: 6),
                                Text('Top Up Saldo', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: GestureDetector(
                          onTap: () => _openWithdrawalModal(context, driver),
                          child: Container(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            decoration: BoxDecoration(
                              color: NeoColors.green,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(color: NeoColors.black, width: 1.8),
                            ),
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.bolt_rounded, color: NeoColors.white, size: 18),
                                SizedBox(width: 6),
                                Text('Tarik Tunai Instant', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 12)),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // CASH ORDER ELIGIBILITY STATUS (RULE: MIN. RP 10.000)
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: driver.walletBalance >= 10000 ? NeoColors.green.withOpacity(0.2) : NeoColors.red.withOpacity(0.25),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: driver.walletBalance >= 10000 ? NeoColors.green : NeoColors.red,
                        width: 1.5,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          driver.walletBalance >= 10000 ? Icons.check_circle_rounded : Icons.cancel_rounded,
                          color: driver.walletBalance >= 10000 ? NeoColors.greenDark : NeoColors.red,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            driver.walletBalance >= 10000
                                ? 'Status Order Tunai: AKTIF (Saldo >= Rp 10.000)'
                                : 'Status Order Tunai: NONAKTIF (Saldo < Rp 10.000, Harap Top Up)',
                            style: TextStyle(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              color: driver.walletBalance >= 10000 ? NeoColors.white : NeoColors.red,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // CICILAN ATRIBUT CARD (MEETING POINT 9)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NeoColors.black, width: 1.8),
                boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.two_wheeler_rounded, color: NeoColors.brand, size: 20),
                          SizedBox(width: 8),
                          Text('Cicilan Harian Atribut Driver', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                        decoration: BoxDecoration(
                          color: NeoColors.goldSoft,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: NeoColors.black, width: 1),
                        ),
                        child: const Text('DP 50% Lunas', style: TextStyle(fontSize: 9.5, fontWeight: FontWeight.w800)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Sisa 50% tagihan atribut helm & jaket dicicil otomatis Rp 5.000/hari dari saldo wallet.',
                    style: TextStyle(fontSize: 11, color: NeoColors.textMuted, height: 1.3),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Tarif Potongan Harian:', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700)),
                      const Text('Rp 5.000 / hari', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.orange)),
                      GestureDetector(
                        onTap: () {
                          final ok = driver.deductDailyAttribute();
                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('✅ Berhasil potong cicilan atribut Rp 5.000 dari saldo wallet.'),
                                backgroundColor: NeoColors.green,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('⚠️ Saldo tidak mencukupi untuk cicilan atribut! Silakan top-up dahulu.'),
                                backgroundColor: NeoColors.red,
                              ),
                            );
                          }
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: NeoColors.bg,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: NeoColors.black, width: 1.2),
                          ),
                          child: const Text('Bayar Cicilan', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.brand)),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // 4 PILAR SALDO WALLET (SESUAI EXCEL SHEET 3: 3. SALDO WALLET DRIVER)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NeoColors.black, width: 1.8),
                boxShadow: const [BoxShadow(color: NeoColors.black, offset: Offset(2.5, 2.5), blurRadius: 0)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Row(
                    children: [
                      Icon(Icons.pie_chart_rounded, color: NeoColors.brand, size: 20),
                      SizedBox(width: 8),
                      Text('Rekapitulasi Wallet (Excel Sheet 3)',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 13, color: NeoColors.black)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildPilarRow('1. Total Top Up Saldo', currencyFmt.format(driver.totalTopUp), NeoColors.greenDark, '+'),
                  const SizedBox(height: 6),
                  _buildPilarRow('2. Potongan Cicilan Atribut', currencyFmt.format(driver.potonganCicilan), NeoColors.orange, '-'),
                  const SizedBox(height: 6),
                  _buildPilarRow('3. Potongan Order Cash', currencyFmt.format(driver.potonganOrderCash), NeoColors.red, '-'),
                  const SizedBox(height: 6),
                  _buildPilarRow('4. Komisi Non-Cash / Masuk', currencyFmt.format(driver.komisiPenghasilan), NeoColors.brand, '+'),
                  const Divider(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Sisa Saldo Akhir Wallet:', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
                      Text(currencyFmt.format(driver.walletBalance),
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                            color: driver.walletBalance < 0
                                ? NeoColors.red
                                : (driver.walletBalance < 10000 ? NeoColors.orange : NeoColors.greenDark),
                          )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            const Text(
              'MUTASI & HISTORI LEDGER DANA',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted),
            ),
            const SizedBox(height: 12),

            // TRANSACTION LEDGER LIST
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: driver.transactionHistory.length,
              itemBuilder: (context, index) {
                final item = driver.transactionHistory[index];
                final bool isInflow = item['type'] == 'inflow';

                return Container(
                  margin: const EdgeInsets.only(bottom: 10),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: NeoColors.surface,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: NeoColors.black, width: 1.8),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: isInflow ? NeoColors.greenSoft : NeoColors.goldSoft,
                          shape: BoxShape.circle,
                          border: Border.all(color: NeoColors.black, width: 1.2),
                        ),
                        child: Icon(
                          isInflow ? Icons.arrow_downward_rounded : Icons.arrow_upward_rounded,
                          color: isInflow ? NeoColors.greenDark : NeoColors.orange,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item['title'] as String,
                              style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12.5, color: NeoColors.black),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${item['time']} • ${item['note']}',
                              style: const TextStyle(fontSize: 10.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${isInflow ? "+" : ""}${currencyFmt.format(item['amount'])}',
                        style: TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 13,
                          color: isInflow ? NeoColors.greenDark : NeoColors.red,
                        ),
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

  Widget _buildPilarRow(String label, String value, Color color, String prefix) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: const TextStyle(fontSize: 11.5, color: NeoColors.textMuted, fontWeight: FontWeight.w600)),
        Text(
          '$prefix $value',
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 11.5, color: color),
        ),
      ],
    );
  }
}
