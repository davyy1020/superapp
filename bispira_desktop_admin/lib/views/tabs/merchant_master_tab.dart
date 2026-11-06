import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/admin_models.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';
import '../../widgets/bispira_charts.dart';
import '../../data/produk_penjual_backend_data.dart';

class MerchantMasterTab extends StatefulWidget {
  const MerchantMasterTab({Key? key}) : super(key: key);

  @override
  State<MerchantMasterTab> createState() => _MerchantMasterTabState();
}

class _MerchantMasterTabState extends State<MerchantMasterTab> {
  String _searchQuery = '';
  String _selectedCategoryFilter = 'SEMUA';
  String _selectedSubFilter = 'SEMUA';
  final ScrollController _horizontalScrollController = ScrollController();

  @override
  void dispose() {
    _horizontalScrollController.dispose();
    super.dispose();
  }

  void _showAddMerchantDialog(BuildContext context, AdminProvider provider, bool isDark) {
    final storeCtrl = TextEditingController();
    final ownerCtrl = TextEditingController();
    final categoryCtrl = TextEditingController(text: 'Food & Fresh Sembako');
    final kabCtrl = TextEditingController(text: 'Jakarta Selatan');
    final basePriceCtrl = TextEditingController(text: '20000');
    final markupCtrl = TextEditingController(text: '10');

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Daftarkan Merchant / Mitra Toko Baru',
        subtitle: 'Input data toko, kategori layanan & komisi markup platform.',
        icon: Icons.storefront_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Nama Toko / Resto / Apotek',
                  controller: storeCtrl,
                  isDark: isDark,
                  icon: Icons.store_rounded,
                  hint: 'Contoh: Resto Bebek Goreng Slamet',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nama Pemilik / Penjual',
                  controller: ownerCtrl,
                  isDark: isDark,
                  icon: Icons.person_rounded,
                  hint: 'Contoh: Slamet Rahardjo',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Kategori Layanan',
                  controller: categoryCtrl,
                  isDark: isDark,
                  icon: Icons.category_rounded,
                  hint: 'Food & Fresh / Go-Health / Sembako',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Kabupaten / Kota',
                  controller: kabCtrl,
                  isDark: isDark,
                  icon: Icons.location_on_rounded,
                  hint: 'Contoh: Jakarta Selatan',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Rata-rata Harga Dasar Produk',
                  controller: basePriceCtrl,
                  isDark: isDark,
                  icon: Icons.monetization_on_outlined,
                  prefix: 'Rp',
                  isNumber: true,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Markup Platform BISPIRA',
                  controller: markupCtrl,
                  isDark: isDark,
                  icon: Icons.percent_rounded,
                  hint: '10',
                  isNumber: true,
                ),
              ],
            ),
          ),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          NeoBrutalButton(
            label: 'Simpan Merchant',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              if (storeCtrl.text.isNotEmpty && ownerCtrl.text.isNotEmpty) {
                final newId = 'MCH-00${provider.merchants.length + 1}';
                provider.addMerchant(
                  MerchantModel(
                    merchantId: newId,
                    storeName: storeCtrl.text,
                    ownerName: ownerCtrl.text,
                    category: categoryCtrl.text,
                    kabupaten: kabCtrl.text,
                    basePriceAvg: double.tryParse(basePriceCtrl.text) ?? 20000,
                    markupPercent: double.tryParse(markupCtrl.text) ?? 10,
                    subscriptionStatus: 'LUNAS BULANAN',
                    accumulatedSales: 0,
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Merchant #$newId (${storeCtrl.text}) berhasil didaftarkan!'), backgroundColor: NeoBrutalTheme.neoGreen),
                );
              }
            },
            bgColor: NeoBrutalTheme.neoGreen,
            fontSize: 13,
          ),
        ],
      ),
    );
  }

  void _showEditMerchantDialog(BuildContext context, AdminProvider provider, MerchantModel merchant, bool isDark) {
    final storeCtrl = TextEditingController(text: merchant.storeName);
    final ownerCtrl = TextEditingController(text: merchant.ownerName);
    final categoryCtrl = TextEditingController(text: merchant.category);
    final kabCtrl = TextEditingController(text: merchant.kabupaten);
    final basePriceCtrl = TextEditingController(text: merchant.basePriceAvg.toInt().toString());

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Edit Data Merchant #${merchant.merchantId}',
        subtitle: 'Perbarui rincian toko & rata-rata harga dasar produk.',
        icon: Icons.edit_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Nama Toko / Resto',
                  controller: storeCtrl,
                  isDark: isDark,
                  icon: Icons.store_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nama Pemilik',
                  controller: ownerCtrl,
                  isDark: isDark,
                  icon: Icons.person_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Kategori Layanan',
                  controller: categoryCtrl,
                  isDark: isDark,
                  icon: Icons.category_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Kabupaten / Kota',
                  controller: kabCtrl,
                  isDark: isDark,
                  icon: Icons.location_on_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Rata-rata Harga Dasar (Rp)',
                  controller: basePriceCtrl,
                  isDark: isDark,
                  icon: Icons.monetization_on_outlined,
                  prefix: 'Rp',
                  isNumber: true,
                ),
              ],
            ),
          ),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          NeoBrutalButton(
            label: 'Simpan Perubahan',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              provider.editMerchant(
                merchant.merchantId,
                storeName: storeCtrl.text,
                ownerName: ownerCtrl.text,
                category: categoryCtrl.text,
                kabupaten: kabCtrl.text,
                basePriceAvg: double.tryParse(basePriceCtrl.text) ?? merchant.basePriceAvg,
              );
              Navigator.pop(ctx);
            },
            bgColor: NeoBrutalTheme.bispiraBlue,
            fontSize: 13,
          ),
        ],
      ),
    );
  }

  void _showFormulirPenjualDialog(BuildContext context, bool isDark) {
    final List<Map<String, String>> formList = [
      {'code': 'Form A', 'title': 'Pendaftaran Merchant', 'cols': '18 Kolom', 'desc': 'NIK Dukcapil, No HP (OTP SMS/WA), Alamat GPS, NIB/PIRT, Jam Operasional, Rekening 9 Bank.'},
      {'code': 'Form B1', 'title': 'Food & Minuman', 'cols': '16 Kolom', 'desc': 'Waktu persiapan (menit), satuan porsi/box, varian rasa/pedas, masa simpan (hari).'},
      {'code': 'Form B2', 'title': 'Fresh Fruit / Buah', 'cols': '13 Kolom', 'desc': 'Kualitas Grade A/B/C, tingkat kematangan, asal panen/lokal, satuan Kg/Gram.'},
      {'code': 'Form B3', 'title': 'Sembako & Mart', 'cols': '13 Kolom', 'desc': 'Min/Maks order, kondisi segar/kering/beku, kemasan karung/dus/liter, merek.'},
      {'code': 'Form B4', 'title': 'Apotek & Obat', 'cols': '14 Kolom', 'desc': 'Izin edar BPOM, golongan obat (bebas/keras), kewajiban resep dokter.'},
      {'code': 'Form C1', 'title': 'Transportasi Online', 'cols': '17 Kolom', 'desc': 'SIM A/C, STNK, SKCK Kepolisian, jenis armada R2/R4, cicilan atribut Rp 5.000/hari.'},
      {'code': 'Form D1', 'title': 'Tenaga Kesehatan', 'cols': '15 Kolom', 'desc': 'STR & SIP aktif, dokter/bidan/perawat/fisioterapi, tarif konsultasi medis.'},
      {'code': 'Form D2', 'title': 'Perawat Sakit & ART', 'cols': '14 Kolom', 'desc': 'Caregiver lansia, ART harian/bulanan, babysitter balita, sertifikat pelatihan.'},
      {'code': 'Form D3', 'title': 'Teknisi Service', 'cols': '15 Kolom', 'desc': 'Teknisi AC, kulkas, montir panggilan, durasi garansi pengerjaan & suku cadang.'},
      {'code': 'Form D4', 'title': 'Bimbel & Les Privat', 'cols': '14 Kolom', 'desc': 'Mata pelajaran SD-SMA, sertifikasi guru/tutor, durasi pertemuan/sesi.'},
      {'code': 'Form D5', 'title': 'Entertainment & MC', 'cols': '14 Kolom', 'desc': 'MC event, grup band, sound rider panggung, link portofolio video performance.'},
      {'code': 'Form E1', 'title': 'Sewa Property & Kost', 'cols': '15 Kolom', 'desc': 'Kost, kontrakan, apartemen, coworking space, deposit jaminan kerusakan.'},
      {'code': 'Form E2', 'title': 'Sewa Busana & Gaun', 'cols': '14 Kolom', 'desc': 'Baju adat Nusantara, gaun pengantin, jas resmi, jaminan identitas KTP.'},
      {'code': 'Form F', 'title': 'Iklan & Promosi Banner', 'cols': '12 Kolom', 'desc': 'Slot banner slider 1-30 pada home user app, dimensi pixel, URL tujuan.'},
      {'code': 'Form G', 'title': 'Donasi & Amal Sosial', 'cols': '12 Kolom', 'desc': 'Yayasan resmi, izin Kemensos/Kemenkumham, santunan yatim (Bebas Potongan Fee).'},
      {'code': 'Form H', 'title': 'MICE & Tiket Event', 'cols': '14 Kolom', 'desc': 'Event organizer, seminar, konser musik, kuota tiket & scan barcode tiket.'},
      {'code': 'Form I1', 'title': 'Sertifikasi Profesi', 'cols': '13 Kolom', 'desc': 'Lembaga Sertifikasi Profesi (LSP/BNSP), skema uji kompetensi & asesor.'},
      {'code': 'Form I2', 'title': 'Event Kompetisi Daerah', 'cols': '14 Kolom', 'desc': 'Turnamen futsal, e-sport daerah, tari kreasi, pendaftaran tim & hadiah.'},
      {'code': 'Form I3', 'title': 'Event Kompetisi Pusat', 'cols': '14 Kolom', 'desc': 'Kompetisi nasional, penayangan live streaming, dewan juri independen.'},
      {'code': 'Form J1', 'title': 'E-Voting Bispira Daerah', 'cols': '13 Kolom', 'desc': 'Voting duta wisata/pelajar daerah, tarif Rp 1.000/vote, live leaderboard.'},
      {'code': 'Form J2', 'title': 'E-Voting Bispira Pusat', 'cols': '13 Kolom', 'desc': 'Voting skala nasional, verifikasi no HP pemilih, transparansi audit sistem.'},
      {'code': 'Sistem Bayar', 'title': 'Matriks Kanal Pembayaran', 'cols': '12 Kolom', 'desc': 'QRIS dinamis, 9 Bank operasional, Escrow Safe, Payout Senin & Kamis 17.00.'},
    ];

    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 2.5),
        ),
        child: Container(
          width: 800,
          height: 650,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: NeoBrutalTheme.neoYellow,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.black, width: 2),
                        ),
                        child: const Icon(Icons.menu_book_rounded, color: Colors.black, size: 24),
                      ),
                      const SizedBox(width: 14),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Panduan Spesifikasi 22 Formulir Penjual (Excel)',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'FORMULIR PENJUAL.xlsx • Standar Registrasi & Input Produk Seluruh Ekosistem',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 24),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.black, thickness: 1.5),
              const SizedBox(height: 10),

              // LIST 22 FORMULIR
              Expanded(
                child: ListView.separated(
                  itemCount: formList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 10),
                  itemBuilder: (context, index) {
                    final item = formList[index];
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1), width: 1.5),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: 80,
                            padding: const EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                              color: item['code'] == 'Form A'
                                  ? NeoBrutalTheme.neoGreen
                                  : (item['code']!.startsWith('Form B')
                                      ? NeoBrutalTheme.bispiraBlue
                                      : (item['code']!.startsWith('Form C')
                                          ? NeoBrutalTheme.neoOrange
                                          : NeoBrutalTheme.neoYellow)),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: Colors.black, width: 1.2),
                            ),
                            child: Center(
                              child: Text(
                                item['code']!,
                                style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 11, color: Colors.black),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      item['title']!,
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: isDark ? Colors.white : Colors.black,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: Text(
                                        item['cols']!,
                                        style: TextStyle(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w800,
                                          color: isDark ? Colors.white70 : Colors.black87,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  item['desc']!,
                                  style: TextStyle(
                                    fontSize: 11.5,
                                    color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF475569),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NeoBrutalButton(
                    label: 'Tutup Panduan',
                    onPressed: () => Navigator.pop(ctx),
                    bgColor: NeoBrutalTheme.bispiraBlue,
                    fontSize: 13,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showSheet10Dialog(BuildContext context, bool isDark) {
    final clusters = MasterProdukPenjualBackendData.clusters;
    showDialog(
      context: context,
      builder: (ctx) => Dialog(
        backgroundColor: isDark ? const Color(0xFF1E293B) : Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.black, width: 2.5),
        ),
        child: Container(
          width: 960,
          height: 650,
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: const Color(0xFF6366F1), width: 1.5),
                        ),
                        child: const Icon(Icons.inventory_2_rounded, color: Color(0xFF6366F1), size: 24),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            MasterProdukPenjualBackendData.sheetTitle,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: isDark ? Colors.white : Colors.black,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Excel Sheet 10: 12 Cluster Sebaran Produk Induk & Anak (Back End Penjual)',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, size: 24),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Divider(color: Colors.black, thickness: 1.5),
              const SizedBox(height: 10),

              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: SingleChildScrollView(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: clusters.map((c) {
                        return Container(
                          width: 220,
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1),
                              width: 1.5,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFEF08A),
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(color: const Color(0xFFCA8A04)),
                                ),
                                child: Text(
                                  '${c.no}. ${c.categoryName}',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w900,
                                    color: Color(0xFF854D0E),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              ...c.backendItems.map((item) {
                                final isSub = [
                                  'HEALTH', 'HOMECARE', 'BEUTY', 'ANTAR JEMPUT',
                                  'ATRIBUT DRIVER', 'EDUKASI', 'ENTERTAINMENT',
                                  'SERVICE', 'KOMPETISI', 'E-VOTING'
                                ].contains(item.trim().toUpperCase());
                                return Container(
                                  margin: const EdgeInsets.only(bottom: 4),
                                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                                  decoration: isSub
                                      ? BoxDecoration(
                                          color: Colors.red.withValues(alpha: 0.12),
                                          borderRadius: BorderRadius.circular(4),
                                        )
                                      : null,
                                  child: Text(
                                    isSub ? '🔴 $item' : '• $item',
                                    style: TextStyle(
                                      fontSize: 11,
                                      fontWeight: isSub ? FontWeight.w800 : FontWeight.w500,
                                      color: isSub
                                          ? Colors.redAccent
                                          : (isDark ? Colors.white70 : const Color(0xFF334155)),
                                    ),
                                  ),
                                );
                              }).toList(),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  NeoBrutalButton(
                    label: 'Tutup Katalog Back End',
                    onPressed: () => Navigator.pop(ctx),
                    bgColor: NeoBrutalTheme.bispiraBlue,
                    fontSize: 13,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditMarkupDialog(BuildContext context, AdminProvider provider, MerchantModel merchant, bool isDark) {
    final markupCtrl = TextEditingController(text: merchant.markupPercent.toInt().toString());

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Ubah Markup Platform',
        subtitle: 'Atur persentase komisi platform untuk ${merchant.storeName} (#${merchant.merchantId}).',
        icon: Icons.percent_rounded,
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BispiraFormField(
                label: 'Persentase Markup Baru (%)',
                controller: markupCtrl,
                isDark: isDark,
                icon: Icons.percent_rounded,
                isNumber: true,
                hint: '10',
              ),
            ],
          ),
        ),
        actions: [
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B),
              side: BorderSide(color: isDark ? const Color(0xFF334155) : const Color(0xFFCBD5E1)),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal', style: TextStyle(fontWeight: FontWeight.w700)),
          ),
          NeoBrutalButton(
            label: 'Simpan Markup',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              final newMarkup = double.tryParse(markupCtrl.text) ?? 10;
              provider.updateMerchantMarkup(merchant.merchantId, newMarkup);
              Navigator.pop(ctx);
            },
            bgColor: NeoBrutalTheme.bispiraBlue,
            fontSize: 13,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AdminProvider>(context);
    final isDark = provider.isDarkMode;

    final cardBg = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : const Color(0xFF0F172A);
    final textSecondary = isDark ? const Color(0xFF94A3B8) : const Color(0xFF64748B);
    final borderSubtle = isDark ? const Color(0xFF334155) : const Color(0xFFE2E8F0);

    final filteredMerchants = provider.merchants.where((m) {
      final matchSearch = m.storeName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.merchantId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.ownerName.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          m.kabupaten.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchCategory = _selectedCategoryFilter == 'SEMUA' || m.category.contains(_selectedCategoryFilter);
      final matchSub = _selectedSubFilter == 'SEMUA' || m.subscriptionStatus == _selectedSubFilter;

      return matchSearch && matchCategory && matchSub;
    }).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pusat Merchant Makanan, Fresh Sembako & Health',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Data Mitra Penjual, Harga Produk Dasar, Skema Markup %, Status Subscribe Bulanan, & Akumulasi Penjualan Batch 17:00.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    NeoBrutalBadge(text: '${filteredMerchants.length} Merchant Tampil', bgColor: NeoBrutalTheme.bispiraBlue),
                    const SizedBox(width: 10),
                    NeoBrutalButton(
                      label: '📦 10. Sebaran Produk Back End',
                      onPressed: () => _showSheet10Dialog(context, isDark),
                      bgColor: const Color(0xFF6366F1),
                      fontSize: 13,
                    ),
                    const SizedBox(width: 10),
                    NeoBrutalButton(
                      label: '📋 22 Formulir Penjual',
                      onPressed: () => _showFormulirPenjualDialog(context, isDark),
                      bgColor: NeoBrutalTheme.neoYellow,
                      fontSize: 13,
                    ),
                    const SizedBox(width: 12),
                    NeoBrutalButton(
                      label: '+ Tambah Merchant Baru',
                      onPressed: () => _showAddMerchantDialog(context, provider, isDark),
                      bgColor: NeoBrutalTheme.neoGreen,
                      fontSize: 13,
                    ),
                  ],
                ),
              ],
            ),
          const SizedBox(height: 20),

          // Search & Filter Toolbar
          NeoBrutalCard(
              bgColor: cardBg,
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      onChanged: (val) {
                        setState(() {
                          _searchQuery = val;
                        });
                      },
                      style: TextStyle(color: textPrimary, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Cari Toko, ID Merchant, Pemilik, atau Kabupaten...',
                        hintStyle: TextStyle(color: textSecondary, fontSize: 13),
                        prefixIcon: Icon(Icons.search_rounded, color: textSecondary, size: 20),
                        isDense: true,
                        filled: true,
                        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderSubtle)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide(color: borderSubtle)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Category Filter Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderSubtle),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedCategoryFilter,
                        dropdownColor: cardBg,
                        style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                        items: const [
                          DropdownMenuItem(value: 'SEMUA', child: Text('Kategori: Semua')),
                          DropdownMenuItem(value: 'Food', child: Text('Food & Sembako')),
                          DropdownMenuItem(value: 'Sehat', child: Text('Mitra Sehat & Apotek')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedCategoryFilter = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Subscription Status Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderSubtle),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedSubFilter,
                        dropdownColor: cardBg,
                        style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                        items: const [
                          DropdownMenuItem(value: 'SEMUA', child: Text('Subscribe: Semua')),
                          DropdownMenuItem(value: 'LUNAS BULANAN', child: Text('Lunas Bulanan')),
                          DropdownMenuItem(value: 'PENDING', child: Text('Pending')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedSubFilter = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 20),

          // Master Table with Interactive Horizontal Scrollbar
          NeoBrutalCard(
              bgColor: cardBg,
              padding: const EdgeInsets.all(20),
              child: Scrollbar(
                controller: _horizontalScrollController,
                thumbVisibility: true,
                trackVisibility: true,
                child: SingleChildScrollView(
                  controller: _horizontalScrollController,
                  scrollDirection: Axis.horizontal,
                  child: Theme(
                    data: Theme.of(context).copyWith(dividerColor: borderSubtle),
                    child: DataTable(
                    headingRowColor: WidgetStateProperty.all(isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                    border: TableBorder.all(color: borderSubtle, width: 1.0),
                    columns: [
                      DataColumn(label: Text('ID Merchant', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Nama Toko / Warung', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Pemilik / Penjual', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Kategori Layanan', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Kabupaten', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Rata2 Harga Dasar', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Markup (%)', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Subscribe Bulanan', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Akumulasi Penjualan', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Aksi Kelola', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                    ],
                    rows: filteredMerchants.map((m) {
                      return DataRow(
                        color: WidgetStateProperty.all(cardBg),
                        cells: [
                          DataCell(Text(m.merchantId, style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary))),
                          DataCell(Text(m.storeName, style: TextStyle(fontWeight: FontWeight.w600, color: textPrimary))),
                          DataCell(Text(m.ownerName, style: TextStyle(color: textSecondary))),
                          DataCell(NeoBrutalBadge(text: m.category, bgColor: NeoBrutalTheme.bispiraBlue)),
                          DataCell(Text(m.kabupaten, style: TextStyle(color: textSecondary))),
                          DataCell(Text('Rp ${m.basePriceAvg.toInt()}', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary))),
                          DataCell(Text('${m.markupPercent.toInt()}%', style: const TextStyle(fontWeight: FontWeight.w700, color: NeoBrutalTheme.bispiraBlue))),
                          DataCell(NeoBrutalBadge(text: m.subscriptionStatus, bgColor: NeoBrutalTheme.neoGreen)),
                          DataCell(Text('Rp ${m.accumulatedSales.toInt()}', style: const TextStyle(fontWeight: FontWeight.w700, color: NeoBrutalTheme.neoGreen))),
                          DataCell(
                            Row(
                              children: [
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: NeoBrutalTheme.bispiraBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onPressed: () {
                                    _showEditMarkupDialog(context, provider, m, isDark);
                                  },
                                  child: const Text('Markup', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, size: 16, color: NeoBrutalTheme.bispiraBlue),
                                  onPressed: () => _showEditMerchantDialog(context, provider, m, isDark),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: NeoBrutalTheme.neoRed),
                                  onPressed: () => provider.deleteMerchant(m.merchantId),
                                ),
                              ],
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 28),

          // Visual Analytics Charts Section
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 6,
                  child: NeoBrutalCard(
                    bgColor: cardBg,
                    padding: const EdgeInsets.all(20),
                    child: BispiraBarChart(
                      isDark: isDark,
                      values: provider.merchants.map((m) => m.accumulatedSales / 10000).toList(),
                      labels: provider.merchants.map((m) => m.merchantId).toList(),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 5,
                  child: NeoBrutalCard(
                    bgColor: cardBg,
                    padding: const EdgeInsets.all(20),
                    child: BispiraDonutChart(isDark: isDark),
                  ),
                ),
              ],
            ),
          ],
      ),
    );
  }
}
