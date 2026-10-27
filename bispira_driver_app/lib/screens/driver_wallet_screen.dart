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
  String _selectedBank = 'BCA';

  final List<String> _bankList = ['BCA', 'Mandiri', 'BRI', 'BNI', 'Bank Jatim', 'CIMB Niaga', 'Permata'];

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
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
                  const Text('⚡ Penarikan BI-FAST 24 Jam', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black)),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close_rounded, color: NeoColors.black, size: 22),
                  ),
                ],
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
                ],
              ),
            ),
            const SizedBox(height: 24),

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
}
