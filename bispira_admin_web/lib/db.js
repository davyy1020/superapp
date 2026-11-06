// Central In-Memory Database Store for BISPIRA SuperApp Backend
// Accessible by both User App API and Desktop Admin API
// Persists in-memory during server runtime and ready for PostgreSQL pooling

import sheet1Data from './data/sheet1_detail_transaksi.json';
import sheet2Data from './data/sheet2_akumulasi_penjual_driver.json';
import sheet3Data from './data/sheet3_saldo_wallet_driver.json';
import sheet4Data from './data/sheet4_master_rekening_penjual.json';
import sheet5Data from './data/sheet5_akumulasi_dana_pencairan.json';
import sheet6Data from './data/sheet6_pencairan_per_bank.json';
import sheet7Data from './data/sheet7_bagi_hasil_pusat_daerah.json';
import sheet8Data from './data/sheet8_profil_lisensi_daerah.json';
import sheet9Data from './data/sheet9_pengaturan_tarif_fees.json';
import sheet1011Data from './data/sheet10_11_produk_katalog_ekosistem.json';
import sheet10BackendData from './data/sheet10_produk_penjual_backend.json';
import sheet12Data from './data/sheet12_pendapatan_superadmin_matrix.json';
import formulirPenjualMaster from './data/formulir_penjual_master.json';

const globalForDb = globalThis;

if (!globalForDb._bispiraDb) {
  globalForDb._bispiraDb = {
    // 1. Tariffs & Financial Platform Config (Disinkronkan dengan Excel Sheet 9, 10, 11, 12 & 1)
    settings: {
      tariffs: {
        ride_motor_per_km: 2500,
        ride_motor_min_fare: 8000,
        ride_car_per_km: 4000,
        ride_car_min_fare: 15000,
        food_r2_per_km: 3000,
        food_r2_min_fare: 10000,
        service_fee: 500,
        application_fee: 500,
        driver_charge_per_trip: 500,
        driver_charge_premium_30hari: 15000,
        driver_min_wallet_balance: 10000,
        ambulance_base_fee: 50000,
        ambulance_min_fare: 50000,
        ambulance_per_km: 5000,
        ambulance_angkut_fee: 50000,
        ambulance_angkut_commission_percent: 1.0,
        logistik_per_km: 4000,
        logistik_min_fare: 50000,
        logistik_angkut_fee: 50000,
        logistik_angkut_commission_percent: 1.0,
        truk_l300_base_fee: 100000,
        default_markup_percent: 10.0,
        car_commission_percent: 7.5,
        r2_commission_percent: 5.0,
        merchant_commission_percent: 5.0,
        payout_fee: 1000,
      },
      rules: {
        branch_profit_share_percent: 25.0,
        headquarters_profit_share_percent: 75.0,
        event_mandiri_branch_share_percent: 80.0,
        event_mandiri_headquarters_share_percent: 20.0,
        unique_code_timer_minutes: 30,
        batch_payout_schedule_wib: '17:00-00:00 (Senin & Kamis)',
        min_withdrawal_bifast: 10000,
        bifast_admin_fee: 2500,
        min_driver_topup: 50000,
        driver_attribute_installment_daily: 5000,
      },
    },

    // 2. Admins (Super Admin & Admin Cabang)
    admins: [
      {
        id: 'ADM-001',
        email: 'admin@bispira.id',
        password: 'admin123',
        name: 'Davy Wahyu Saputra',
        role: 'SUPER_ADMIN',
        roleTitle: 'Super Admin Pusat',
        branchId: 'BRN-HQ',
        branchName: 'Pusat (HQ)',
        status: 'ACTIVE',
      },
      {
        id: 'ADM-002',
        email: 'admin.jakarta@bispira.id',
        password: 'PasswordSuperRahasia123!',
        name: 'Super Admin Jakarta',
        role: 'SUPER_ADMIN',
        roleTitle: 'Super Admin Pusat',
        branchId: 'BRN-HQ',
        branchName: 'Pusat (HQ)',
        status: 'ACTIVE',
      },
      {
        id: 'ADM-003',
        email: 'cabang@bispira.id',
        password: 'admin123',
        name: 'Budi Branch Manager',
        role: 'REGIONAL_ADMIN',
        roleTitle: 'Admin Cabang Wilayah',
        branchId: 'BRN-001',
        branchName: 'Cabang Jakarta Selatan',
        status: 'ACTIVE',
      },
      {
        id: 'ADM-004',
        email: 'cabang.bandung@bispira.id',
        password: 'admin123',
        name: 'Rian Priangan',
        role: 'REGIONAL_ADMIN',
        roleTitle: 'Admin Cabang Wilayah',
        branchId: 'BRN-002',
        branchName: 'Cabang Kota Bandung',
        status: 'ACTIVE',
      },
    ],

    // 3. Users & End-Customer Wallets
    users: {
      'BSP-2026-9042': {
        id: 'BSP-2026-9042',
        name: 'Davy Wahyu Saputra',
        phone: '081298765432',
        email: 'davy.user@bispira.id',
        walletBalance: 250000,
        bankCode: 'BNI',
        bankAccountNo: '9876543210',
        status: 'ACTIVE',
      },
      'BSP-2026-1102': {
        id: 'BSP-2026-1102',
        name: 'Siti Nurhaliza',
        phone: '085711223344',
        email: 'siti@gmail.com',
        walletBalance: 120000,
        bankCode: 'BCA',
        bankAccountNo: '1102938475',
        status: 'ACTIVE',
      },
      'BSP-2026-3391': {
        id: 'BSP-2026-3391',
        name: 'Budi Santoso',
        phone: '081377889900',
        email: 'budi.santoso@yahoo.com',
        walletBalance: 85000,
        bankCode: 'MANDIRI',
        bankAccountNo: '144001928374',
        status: 'ACTIVE',
      },
    },

    // 4. Drivers
    drivers: [
      {
        id: 'drv_8801',
        name: 'Ahmad Fauzi',
        phone: '081234567890',
        vehicleType: 'MOTORCYCLE',
        licensePlate: 'B 4521 SXZ',
        branchId: 'BRN-001',
        branchName: 'Cabang Jakarta Selatan',
        kycStatus: 'APPROVED',
        isOnline: true,
        rating: 4.9,
        walletBalance: 180000,
        completedTrips: 142,
      },
      {
        id: 'drv_8802',
        name: 'Bambang Hermanto',
        phone: '081987654321',
        vehicleType: 'CAR',
        licensePlate: 'D 1928 AB',
        branchId: 'BRN-002',
        branchName: 'Cabang Kota Bandung',
        kycStatus: 'APPROVED',
        isOnline: true,
        rating: 4.8,
        walletBalance: 420000,
        completedTrips: 89,
      },
      {
        id: 'drv_9921',
        name: 'Rizky Ramadhan',
        phone: '087811223399',
        vehicleType: 'MOTORCYCLE',
        licensePlate: 'B 3341 TYU',
        branchId: 'BRN-001',
        branchName: 'Cabang Jakarta Selatan',
        kycStatus: 'PENDING',
        isOnline: false,
        rating: 0.0,
        walletBalance: 0,
        completedTrips: 0,
        submittedAt: '2026-10-26T14:20:00Z',
        documents: {
          ktp: 'https://bispira.id/docs/ktp_9921.jpg',
          sim: 'https://bispira.id/docs/sim_9921.jpg',
          stnk: 'https://bispira.id/docs/stnk_9921.jpg',
          skck: 'https://bispira.id/docs/skck_9921.jpg',
        },
      },
    ],

    // 5. Merchants & Catalog
    merchants: [
      {
        id: 'MCH-001',
        storeName: 'Senopati Resto (Ayam Geprek)',
        ownerName: 'Ibu Ratna',
        category: 'Food & Fresh Sembako',
        kabupaten: 'Jakarta Selatan',
        branchId: 'BRN-001',
        basePriceAvg: 18000, // Rata-rata harga dasar item produk
        markupPercent: 10,
        subscriptionStatus: 'LUNAS BULANAN',
        accumulatedSales: 450000,
        walletBalance: 450000,
        bankName: 'BCA',
        bankAccountNo: '1283921020',
      },
      {
        id: 'MCH-002',
        storeName: 'Apotek Kimia Farma Benhil',
        ownerName: 'Apoteker Farida',
        category: 'Mitra Sehat & Apotek',
        kabupaten: 'Jakarta Pusat',
        branchId: 'BRN-HQ',
        basePriceAvg: 45000,
        markupPercent: 10,
        subscriptionStatus: 'LUNAS BULANAN',
        accumulatedSales: 890000,
        walletBalance: 890000,
        bankName: 'MANDIRI',
        bankAccountNo: '8820192311',
      },
      {
        id: 'MCH-003',
        storeName: 'Toko Sembako Berkah Utama',
        ownerName: 'Pak Haji Kohar',
        category: 'Food & Fresh Sembako',
        kabupaten: 'Kota Bandung',
        branchId: 'BRN-002',
        basePriceAvg: 25000,
        markupPercent: 10,
        subscriptionStatus: 'LUNAS BULANAN',
        accumulatedSales: 1200000,
        walletBalance: 1200000,
        bankName: 'BRI',
        bankAccountNo: '33100293847',
      },
    ],

    // 6. Branches (Pusat Cabang & Lisensi Franchise)
    branches: [
      {
        id: 'BRN-HQ',
        code: 'HQ-PST',
        name: 'Kantor Pusat BISPIRA (HQ)',
        kabupaten: 'Pusat Nasional',
        licenseStatus: 'PERMANENT',
        partnerCompany: 'PT Bispira Nusantara Teknologi',
        profitSharePercent: 70.0,
        activeDrivers: 450,
        activeMerchants: 120,
        totalSalesAccumulated: 25400000,
      },
      {
        id: 'BRN-001',
        code: 'CBG-JKT-SEL',
        name: 'Cabang Jakarta Selatan',
        kabupaten: 'Jakarta Selatan',
        licenseStatus: 'AKTIF',
        partnerCompany: 'PT Bispira Jaya Selatan',
        profitSharePercent: 30.0,
        activeDrivers: 180,
        activeMerchants: 45,
        totalSalesAccumulated: 8950000,
      },
      {
        id: 'BRN-002',
        code: 'CBG-BDG-KOTA',
        name: 'Cabang Kota Bandung',
        kabupaten: 'Kota Bandung',
        licenseStatus: 'AKTIF',
        partnerCompany: 'CV Berkah Priangan',
        profitSharePercent: 30.0,
        activeDrivers: 120,
        activeMerchants: 38,
        totalSalesAccumulated: 6420000,
      },
    ],

    // 7. Manual Payments Pending Verification (Kode Unik)
    pendingPayments: [
      {
        id: 'pay_77210',
        userId: 'BSP-2026-3391',
        userName: 'Budi Santoso',
        serviceType: 'TOPUP_WALLET',
        nominalBase: 100000,
        uniqueCode: 342,
        totalTransferRequired: 100342,
        bankDestination: 'BCA (014-9988-2211 a.n PT BISPIRA)',
        status: 'PENDING_VERIFICATION',
        createdAt: '2026-10-26T16:10:00Z',
        expiresAt: '2026-10-26T16:40:00Z',
      },
      {
        id: 'pay_77211',
        userId: 'BSP-2026-1102',
        userName: 'Siti Nurhaliza',
        serviceType: 'PEMBAYARAN_PESANAN',
        nominalBase: 50000,
        uniqueCode: 189,
        totalTransferRequired: 50189,
        bankDestination: 'MANDIRI (144-00-9988-1122 a.n PT BISPIRA)',
        status: 'PENDING_VERIFICATION',
        createdAt: '2026-10-26T16:25:00Z',
        expiresAt: '2026-10-26T16:55:00Z',
      },
    ],

    // 8. Upcoming Batch Disbursements (Pukul 17:00 WIB)
    disbursements: [
      {
        id: 'PAYOUT-8801',
        merchantId: 'MCH-001',
        recipientName: 'Senopati Resto (Ayam Geprek)',
        category: 'Food & Fresh Sembako',
        bankName: 'BCA',
        accountNumber: '1283921020',
        grossAmount: 450000,
        adminFee: 2500,
        netPayoutAmount: 447500,
        status: 'SCHEDULED_17WIB',
        scheduledDate: '27 Okt 2026',
      },
      {
        id: 'PAYOUT-8802',
        merchantId: 'MCH-002',
        recipientName: 'Apotek Kimia Farma Benhil',
        category: 'Mitra Sehat & Apotek',
        bankName: 'MANDIRI',
        accountNumber: '8820192311',
        grossAmount: 890000,
        adminFee: 2500,
        netPayoutAmount: 887500,
        status: 'SCHEDULED_17WIB',
        scheduledDate: '27 Okt 2026',
      },
      {
        id: 'PAYOUT-8803',
        merchantId: 'MCH-003',
        recipientName: 'Toko Sembako Berkah Utama',
        category: 'Food & Fresh Sembako',
        bankName: 'BRI',
        accountNumber: '33100293847',
        grossAmount: 1200000,
        adminFee: 2500,
        netPayoutAmount: 1197500,
        status: 'SCHEDULED_17WIB',
        scheduledDate: '27 Okt 2026',
      },
    ],

    // 9. Virtual Accounts SNAP BI
    virtualAccounts: {},

    // 10. Audit Transactions
    transactions: [
      {
        txId: 'tx_1001',
        userId: 'BSP-2026-9042',
        title: 'Top-Up Virtual Account BNI',
        date: '25 Okt 2026 • 09:30',
        amount: 500000,
        isPositive: true,
        status: 'Berhasil',
      },
      {
        txId: 'tx_1002',
        userId: 'BSP-2026-9042',
        title: 'Pembayaran BISPIRA TAX',
        date: '24 Okt 2026 • 14:15',
        amount: 2250000,
        isPositive: false,
        status: 'Berhasil',
      },
    ],

    // 11. Live Orders & Trips (User <-> Driver Dispatch Engine)
    orders: [
      {
        id: 'BSP-ORD-77192',
        serviceType: 'ride_motor',
        serviceName: 'BISPIRA Ride (Motor) 🛵',
        serviceEmoji: '🛵',
        customerName: 'Davy (User Bispira)',
        customerPhone: '0812-9876-5432',
        pickupAddress: 'Jl. Kaligawe Raya No. 12, Genuk, Semarang',
        dropoffAddress: 'Jl. Prof. Soedarto (Undip), Tembalang, Semarang',
        pickupLat: -6.9622,
        pickupLng: 110.4682,
        dropoffLat: -7.0545,
        dropoffLng: 110.4358,
        distanceKm: 17.19,
        durationMin: 18,
        totalFareCustomer: 48478,
        netDriverEarning: 43204, // 95% of Trip Fare (Rp 45.478 * 0.95 = Rp 43.204)
        platformFee: 2274,       // 5% Platform Fee
        taxPph: 227,             // PMK 37/2025 0.5%
        appFee: 2000,
        serviceFee: 1000,
        uniqueCode: 247,
        paymentMethod: 'Transfer Bank (Kode Unik 247) 🏦',
        paymentStatus: 'PENDING_MANUAL_VERIFICATION',
        status: 'LOOKING_FOR_DRIVER',
        createdAt: new Date().toISOString(),
      },
    ],

    // 12. Master Ledger Real-Time (Persis 21 Kolom Sheet 1: 1. Detail Transaksi)
    ledgerTransactions: [...sheet1Data.rows],
    ledgerSummary: sheet1Data.total,

    // 13. Master Akumulasi Penjual & Driver (Persis 9 Kolom Sheet 2: 2. Akumulasi Penjual & Driver)
    sellerDriverAccumulations: [...sheet2Data.rows],
    sellerDriverAccumulationsSummary: sheet2Data.total,

    // 14. Master Saldo Wallet Driver (Persis 8 Kolom Sheet 3: 3. Saldo Wallet Driver)
    driverWalletBalances: [...sheet3Data.rows],
    driverWalletBalancesSummary: sheet3Data.total,

    // 15. Master Rekening Penjual / Driver (Persis 7 Kolom Sheet 4: 4. Master Rekening Penjual)
    masterBankAccounts: [...sheet4Data.rows],
    masterBankAccountsSummary: sheet4Data.total,

    // 16. Master Akumulasi Dana Pencairan (Persis 8 Kolom Sheet 5: 5. Akumulasi Dana Pencairan)
    disbursementAccumulations: [...sheet5Data.rows],
    disbursementAccumulationsSummary: sheet5Data.total,

    // 17. Master Rekapitulasi Pencairan Per Bank (Persis 7 Kolom Sheet 6: 6. Pencairan Per Bank)
    disbursementsPerBank: [...sheet6Data.rows],
    disbursementsPerBankSummary: sheet6Data.total,
  };
}

if (!globalForDb._bispiraDb.ledgerTransactions) {
  globalForDb._bispiraDb.ledgerTransactions = [...sheet1Data.rows];
  globalForDb._bispiraDb.ledgerSummary = sheet1Data.total;
}

if (!globalForDb._bispiraDb.sellerDriverAccumulations) {
  globalForDb._bispiraDb.sellerDriverAccumulations = [...sheet2Data.rows];
  globalForDb._bispiraDb.sellerDriverAccumulationsSummary = sheet2Data.total;
}

if (!globalForDb._bispiraDb.driverWalletBalances) {
  globalForDb._bispiraDb.driverWalletBalances = [...sheet3Data.rows];
  globalForDb._bispiraDb.driverWalletBalancesSummary = sheet3Data.total;
}

if (!globalForDb._bispiraDb.masterBankAccounts) {
  globalForDb._bispiraDb.masterBankAccounts = [...sheet4Data.rows];
  globalForDb._bispiraDb.masterBankAccountsSummary = sheet4Data.total;
}

if (!globalForDb._bispiraDb.disbursementAccumulations) {
  globalForDb._bispiraDb.disbursementAccumulations = [...sheet5Data.rows];
  globalForDb._bispiraDb.disbursementAccumulationsSummary = sheet5Data.total;
}

if (!globalForDb._bispiraDb.disbursementsPerBank) {
  globalForDb._bispiraDb.disbursementsPerBank = [...sheet6Data.rows];
  globalForDb._bispiraDb.disbursementsPerBankSummary = sheet6Data.total;
}

if (!globalForDb._bispiraDb.bagiHasilPusatDaerah) {
  globalForDb._bispiraDb.bagiHasilPusatDaerah = [...sheet7Data.rows];
  globalForDb._bispiraDb.bagiHasilPusatDaerahSummary = sheet7Data.total;
}

if (!globalForDb._bispiraDb.profilLisensiDaerah) {
  globalForDb._bispiraDb.profilLisensiDaerah = [...sheet8Data.rows];
  globalForDb._bispiraDb.profilLisensiDaerahSummary = sheet8Data.total;
}

if (!globalForDb._bispiraDb.tariffAndFeesSettings) {
  globalForDb._bispiraDb.tariffAndFeesSettings = sheet9Data;
}

if (!globalForDb._bispiraDb.catalogEcosystem) {
  globalForDb._bispiraDb.catalogEcosystem = sheet1011Data;
}

if (!globalForDb._bispiraDb.productsBackend) {
  globalForDb._bispiraDb.productsBackend = sheet10BackendData;
}

if (!globalForDb._bispiraDb.revenueSharingMatrix) {
  globalForDb._bispiraDb.revenueSharingMatrix = sheet12Data;
}

if (!globalForDb._bispiraDb.formulirPenjualMaster) {
  globalForDb._bispiraDb.formulirPenjualMaster = formulirPenjualMaster;
}

if (!globalForDb._bispiraDb.orders) {
  globalForDb._bispiraDb.orders = [
    {
      id: 'BSP-ORD-77192',
      serviceType: 'ride_motor',
      serviceName: 'BISPIRA Ride (Motor) 🛵',
      serviceEmoji: '🛵',
      customerName: 'Davy (User Bispira)',
      customerPhone: '0812-9876-5432',
      pickupAddress: 'Jl. Kaligawe Raya No. 12, Genuk, Semarang',
      dropoffAddress: 'Jl. Prof. Soedarto (Undip), Tembalang, Semarang',
      pickupLat: -6.9622,
      pickupLng: 110.4682,
      dropoffLat: -7.0545,
      dropoffLng: 110.4358,
      distanceKm: 17.19,
      durationMin: 18,
      totalFareCustomer: 48478,
      netDriverEarning: 43204,
      platformFee: 2274,
      taxPph: 227,
      appFee: 2000,
      serviceFee: 1000,
      uniqueCode: 247,
      paymentMethod: 'Transfer Bank (Kode Unik 247) 🏦',
      paymentStatus: 'PENDING_MANUAL_VERIFICATION',
      status: 'LOOKING_FOR_DRIVER',
      createdAt: new Date().toISOString(),
    },
  ];
}

export const db = globalForDb._bispiraDb;
