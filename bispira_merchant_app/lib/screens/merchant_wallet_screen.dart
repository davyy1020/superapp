import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../providers/merchant_provider.dart';
import '../theme/neo_theme.dart';

class MerchantWalletScreen extends StatefulWidget {
  const MerchantWalletScreen({Key? key}) : super(key: key);

  @override
  State<MerchantWalletScreen> createState() => _MerchantWalletScreenState();
}

class _MerchantWalletScreenState extends State<MerchantWalletScreen> {
  final currencyFmt = NumberFormat.currency(locale: 'id_ID', symbol: 'Rp ', decimalDigits: 0);
  final _amountController = TextEditingController(text: '500000');
  final _accountController = TextEditingController(text: '9876543210');
  String _selectedBank = 'BNI';

  final List<String> _bankList = ['BNI', 'BCA', 'Mandiri', 'BRI', 'Bank Jatim'];

  @override
  void dispose() {
    _amountController.dispose();
    _accountController.dispose();
    super.dispose();
  }

  void _openSettlementModal(BuildContext context, MerchantProvider merchant) {
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
                  const Text('🏦 Penarikan Saldo Settlement Resto', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16, color: NeoColors.black)),
                  GestureDetector(
                    onTap: () => Navigator.pop(ctx),
                    child: const Icon(Icons.close_rounded, color: NeoColors.black, size: 22),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              const Text('BANK REKENING OUTLET', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
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

              const Text('NOMOR REKENING OUTLET', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted)),
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
                  decoration: const InputDecoration(border: InputBorder.none, hintText: 'Nomor rekening toko'),
                ),
              ),
              const SizedBox(height: 12),

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

              GestureDetector(
                onTap: () {
                  final int amt = int.tryParse(_amountController.text) ?? 0;
                  final success = merchant.requestBatchSettlement(amt, _selectedBank, _accountController.text);
                  Navigator.pop(ctx);

                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: NeoColors.green,
                        content: Text('🏦 Permintaan Batch Settlement Rp ${currencyFmt.format(amt)} Berhasil Diajukan!'),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        backgroundColor: NeoColors.red,
                        content: Text('Nominal penarikan melebihi saldo settlement toko!'),
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
                      'AJUKAN PENARIKAN DANA 🏦',
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
    final merchant = Provider.of<MerchantProvider>(context);

    return Scaffold(
      backgroundColor: NeoColors.bg,
      appBar: AppBar(
        title: const Text('Dompet Settlement Merchant'),
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
                        'SALDO SIAP CAIR (100% BASE)',
                        style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w900, color: NeoColors.textMuted, letterSpacing: 0.8),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: NeoColors.green.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: NeoColors.green),
                        ),
                        child: const Text(
                          'Mitra Verifikasi 🟢',
                          style: TextStyle(color: NeoColors.greenSoft, fontSize: 10.5, fontWeight: FontWeight.w800),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    currencyFmt.format(merchant.walletBalance),
                    style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w900, color: NeoColors.white),
                  ),
                  const SizedBox(height: 16),

                  GestureDetector(
                    onTap: () => _openSettlementModal(context, merchant),
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
                          Icon(Icons.account_balance_rounded, color: NeoColors.white, size: 18),
                          SizedBox(width: 6),
                          Text('Cairkan Saldo ke Bank Resto', style: TextStyle(color: NeoColors.white, fontWeight: FontWeight.w900, fontSize: 12.5)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            const Text(
              'RINGKASAN FORMULA EXCEL SETTLEMENT',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900, letterSpacing: 0.8, color: NeoColors.textMuted),
            ),
            const SizedBox(height: 12),

            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: NeoColors.surface,
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: NeoColors.black, width: 1.8),
              ),
              child: const Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Hak Bersih Toko', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                      Text('100% Harga Dasar Merchant', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.greenDark)),
                    ],
                  ),
                  SizedBox(height: 8),
                  Divider(color: NeoColors.black, height: 1, thickness: 1),
                  SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Potongan Disbursment Fee Payout', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: NeoColors.textMuted)),
                      Text('Rp 1.000 / Batch', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w900, color: NeoColors.black)),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
