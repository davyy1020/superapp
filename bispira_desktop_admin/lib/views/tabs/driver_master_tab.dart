import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/admin_models.dart';
import '../../providers/admin_provider.dart';
import '../../theme/neo_brutal_theme.dart';
import '../../widgets/bispira_charts.dart';

class DriverMasterTab extends StatefulWidget {
  const DriverMasterTab({Key? key}) : super(key: key);

  @override
  State<DriverMasterTab> createState() => _DriverMasterTabState();
}

class _DriverMasterTabState extends State<DriverMasterTab> {
  String _searchQuery = '';
  String _selectedKycFilter = 'SEMUA';
  String _selectedVehicleFilter = 'SEMUA';

  void _showAddDriverDialog(BuildContext context, AdminProvider provider, bool isDark) {
    final nameCtrl = TextEditingController();
    final vehicleCtrl = TextEditingController(text: 'Ride Hailing (Motor)');
    final plateCtrl = TextEditingController();
    final phoneCtrl = TextEditingController();
    final kabCtrl = TextEditingController(text: 'Jakarta Selatan');

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Tambah Driver Mitra Baru',
        subtitle: 'Input data identitas & kendaraan mitra driver BISPIRA.',
        icon: Icons.two_wheeler_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Nama Lengkap Driver',
                  controller: nameCtrl,
                  isDark: isDark,
                  icon: Icons.person_outline_rounded,
                  hint: 'Contoh: Ahmad Rizky',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Jenis Kendaraan',
                  controller: vehicleCtrl,
                  isDark: isDark,
                  icon: Icons.directions_bike_rounded,
                  hint: 'Motor / Mobil / Ambulance',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Plat Nomor Kendaraan',
                  controller: plateCtrl,
                  isDark: isDark,
                  icon: Icons.subtitles_rounded,
                  hint: 'Contoh: B 1234 ABC',
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nomor WhatsApp / Phone',
                  controller: phoneCtrl,
                  isDark: isDark,
                  icon: Icons.phone_rounded,
                  hint: 'Contoh: 081298765432',
                  isNumber: true,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Wilayah / Kabupaten Operational',
                  controller: kabCtrl,
                  isDark: isDark,
                  icon: Icons.location_on_rounded,
                  hint: 'Contoh: Jakarta Selatan',
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
            label: 'Simpan Driver',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              if (nameCtrl.text.isNotEmpty && plateCtrl.text.isNotEmpty) {
                final newId = 'DRV-00${provider.drivers.length + 1}';
                provider.addDriver(
                  DriverModel(
                    driverId: newId,
                    name: nameCtrl.text,
                    vehicleType: vehicleCtrl.text,
                    plateNumber: plateCtrl.text.toUpperCase(),
                    phone: phoneCtrl.text,
                    kabupaten: kabCtrl.text,
                    kycStatus: 'PENDING',
                    walletBalance: 50000,
                    helmetStatus: 'DICICIL',
                    jacketStatus: 'DICICIL',
                  ),
                );
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Driver #$newId (${nameCtrl.text}) berhasil ditambahkan!'), backgroundColor: NeoBrutalTheme.neoGreen),
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

  void _showEditDriverDialog(BuildContext context, AdminProvider provider, DriverModel driver, bool isDark) {
    final nameCtrl = TextEditingController(text: driver.name);
    final vehicleCtrl = TextEditingController(text: driver.vehicleType);
    final plateCtrl = TextEditingController(text: driver.plateNumber);
    final phoneCtrl = TextEditingController(text: driver.phone);
    final kabCtrl = TextEditingController(text: driver.kabupaten);

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Edit Data Driver #${driver.driverId}',
        subtitle: 'Perbarui rincian identitas & armada kendaraan driver.',
        icon: Icons.edit_rounded,
        content: SizedBox(
          width: 440,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                BispiraFormField(
                  label: 'Nama Lengkap Driver',
                  controller: nameCtrl,
                  isDark: isDark,
                  icon: Icons.person_outline_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Jenis Kendaraan',
                  controller: vehicleCtrl,
                  isDark: isDark,
                  icon: Icons.directions_bike_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Plat Nomor',
                  controller: plateCtrl,
                  isDark: isDark,
                  icon: Icons.subtitles_rounded,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Nomor Kontak / WA',
                  controller: phoneCtrl,
                  isDark: isDark,
                  icon: Icons.phone_rounded,
                  isNumber: true,
                ),
                const SizedBox(height: 14),
                BispiraFormField(
                  label: 'Kabupaten / Wilayah Operational',
                  controller: kabCtrl,
                  isDark: isDark,
                  icon: Icons.location_on_rounded,
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
              provider.editDriver(
                driver.driverId,
                name: nameCtrl.text,
                vehicleType: vehicleCtrl.text,
                plateNumber: plateCtrl.text.toUpperCase(),
                phone: phoneCtrl.text,
                kabupaten: kabCtrl.text,
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

  void _showTopUpDialog(BuildContext context, AdminProvider provider, DriverModel driver, bool isDark) {
    final amountCtrl = TextEditingController(text: '50000');

    showDialog(
      context: context,
      builder: (ctx) => BispiraModalDialog(
        isDark: isDark,
        title: 'Top Up Saldo Wallet Driver',
        subtitle: 'Proses pengisian saldo deposit driver ${driver.name} (Saldo: Rp ${driver.walletBalance.toInt()}).',
        icon: Icons.account_balance_wallet_rounded,
        content: SizedBox(
          width: 400,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              BispiraFormField(
                label: 'Nominal Top Up Saldo',
                controller: amountCtrl,
                isDark: isDark,
                icon: Icons.monetization_on_outlined,
                prefix: 'Rp',
                isNumber: true,
                hint: '50000',
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
            label: 'Proses Top Up',
            icon: Icons.check_circle_rounded,
            onPressed: () {
              final amt = double.tryParse(amountCtrl.text) ?? 0;
              if (amt > 0) {
                provider.topUpDriverWallet(driver.driverId, amt);
                Navigator.pop(ctx);
              }
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

    final filteredDrivers = provider.drivers.where((d) {
      final matchSearch = d.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.driverId.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.plateNumber.toLowerCase().contains(_searchQuery.toLowerCase()) ||
          d.kabupaten.toLowerCase().contains(_searchQuery.toLowerCase());

      final matchKyc = _selectedKycFilter == 'SEMUA' || d.kycStatus == _selectedKycFilter;
      final matchVehicle = _selectedVehicleFilter == 'SEMUA' || d.vehicleType.contains(_selectedVehicleFilter);

      return matchSearch && matchKyc && matchVehicle;
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
                        'Pusat Master Driver & Distribusi Atribut',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700, color: textPrimary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Data Pengemudi Ride-Hailing, Logistik & Ambulance. Verifikasi KYC, Saldo Wallet, Charge Rp500/tx, & Atribut.',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: textSecondary),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Row(
                  children: [
                    NeoBrutalBadge(text: '${filteredDrivers.length} Driver Tampil', bgColor: NeoBrutalTheme.bispiraBlue),
                    const SizedBox(width: 12),
                    NeoBrutalButton(
                      label: '+ Tambah Driver Baru',
                      onPressed: () => _showAddDriverDialog(context, provider, isDark),
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
                        hintText: 'Cari Nama Driver, ID Driver, Plat Nomor, atau Kabupaten...',
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

                  // KYC Filter Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderSubtle),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedKycFilter,
                        dropdownColor: cardBg,
                        style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                        items: const [
                          DropdownMenuItem(value: 'SEMUA', child: Text('KYC: Semua')),
                          DropdownMenuItem(value: 'TERVERIFIKASI', child: Text('KYC: Terverifikasi')),
                          DropdownMenuItem(value: 'PENDING', child: Text('KYC: Pending')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedKycFilter = val;
                            });
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Vehicle Type Dropdown
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: borderSubtle),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedVehicleFilter,
                        dropdownColor: cardBg,
                        style: TextStyle(color: textPrimary, fontSize: 13, fontWeight: FontWeight.w600),
                        items: const [
                          DropdownMenuItem(value: 'SEMUA', child: Text('Armada: Semua')),
                          DropdownMenuItem(value: 'Motor', child: Text('Motor')),
                          DropdownMenuItem(value: 'Mobil', child: Text('Mobil')),
                          DropdownMenuItem(value: 'Ambulance', child: Text('Ambulance')),
                        ],
                        onChanged: (val) {
                          if (val != null) {
                            setState(() {
                              _selectedVehicleFilter = val;
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

          // Master Table
          NeoBrutalCard(
              bgColor: cardBg,
              padding: const EdgeInsets.all(20),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Theme(
                  data: Theme.of(context).copyWith(dividerColor: borderSubtle),
                  child: DataTable(
                    headingRowColor: WidgetStateProperty.all(isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC)),
                    border: TableBorder.all(color: borderSubtle, width: 1.0),
                    columns: [
                      DataColumn(label: Text('ID Driver', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Nama Lengkap', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Jenis Kendaraan', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Plat Nomor', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('No WA / HP', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Wilayah', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('KYC Status', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Saldo Wallet', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Charge / Tx', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Status Helm', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Status Jaket', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                      DataColumn(label: Text('Aksi Kelola', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary, fontSize: 12.5))),
                    ],
                    rows: filteredDrivers.map((d) {
                      final isVerified = d.kycStatus == 'TERVERIFIKASI';
                      return DataRow(
                        color: WidgetStateProperty.all(cardBg),
                        cells: [
                          DataCell(Text(d.driverId, style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary))),
                          DataCell(Text(d.name, style: TextStyle(fontWeight: FontWeight.w600, color: textPrimary))),
                          DataCell(Text(d.vehicleType, style: TextStyle(color: textSecondary))),
                          DataCell(NeoBrutalBadge(text: d.plateNumber, bgColor: NeoBrutalTheme.bispiraBlue)),
                          DataCell(Text(d.phone, style: const TextStyle(fontWeight: FontWeight.w600, color: NeoBrutalTheme.bispiraBlue))),
                          DataCell(Text(d.kabupaten, style: TextStyle(color: textSecondary))),
                          DataCell(
                            NeoBrutalBadge(
                              text: d.kycStatus,
                              bgColor: isVerified ? NeoBrutalTheme.neoGreen : NeoBrutalTheme.neoOrange,
                            ),
                          ),
                          DataCell(Text('Rp ${d.walletBalance.toInt()}', style: TextStyle(fontWeight: FontWeight.w700, color: textPrimary))),
                          DataCell(Text('-Rp ${provider.currentConfig.driverChargeFee.toInt()}', style: const TextStyle(fontWeight: FontWeight.w900, color: NeoBrutalTheme.neoOrange))),
                          DataCell(NeoBrutalBadge(text: d.helmetStatus, bgColor: NeoBrutalTheme.neoYellow)),
                          DataCell(NeoBrutalBadge(text: d.jacketStatus, bgColor: NeoBrutalTheme.neoYellow)),
                          DataCell(
                            Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!isVerified)
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: NeoBrutalTheme.neoGreen,
                                      foregroundColor: Colors.white,
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                    ),
                                    onPressed: () {
                                      provider.verifyDriverKYC(d.driverId);
                                    },
                                    child: const Text('Approve', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                  ),
                                const SizedBox(width: 4),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: NeoBrutalTheme.bispiraBlue,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                                  ),
                                  onPressed: () {
                                    _showTopUpDialog(context, provider, d, isDark);
                                  },
                                  child: const Text('TopUp', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                                ),
                                const SizedBox(width: 4),
                                IconButton(
                                  icon: const Icon(Icons.edit_rounded, size: 16, color: NeoBrutalTheme.bispiraBlue),
                                  onPressed: () => _showEditDriverDialog(context, provider, d, isDark),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.delete_outline_rounded, size: 16, color: NeoBrutalTheme.neoRed),
                                  onPressed: () => provider.deleteDriver(d.driverId),
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
                      values: provider.drivers.map((d) => d.walletBalance / 1000).toList(),
                      labels: provider.drivers.map((d) => d.driverId).toList(),
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
