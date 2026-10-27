import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function POST(request) {
  try {
    const body = await request.json();
    const {
      userId = 'BSP-2026-9042',
      totalAmount = 25000,
      serviceType = 'BISPIRA RIDE (Ojek Motor)',
      mitraId = 'drv_8801',
      branchId = 'BRN-001',
    } = body;

    const user = db.users[userId] || db.users['BSP-2026-9042'];
    const amount = Number(totalAmount);

    if (user.walletBalance < amount) {
      return errorResponse(
        `Saldo dompet Anda tidak cukup (Rp ${user.walletBalance.toLocaleString('id-ID')}). Silakan top-up terlebih dahulu.`,
        400
      );
    }

    // Split Payment Engine:
    // Pihak 1: User (Debited)
    // Pihak 2: Mitra Driver / Merchant (90% Hak dasar mitra)
    // Pihak 3: Platform Admin Fee (10%) -> Dibagi Pusat (70%) & Cabang (30%)
    const platformFeeRate = 0.10;
    const mitraShareRate = 0.90;

    const mitraAmount = Math.round(amount * mitraShareRate);
    const platformFee = amount - mitraAmount;

    const branchShareRate = (db.settings.rules.branch_profit_share_percent || 30.0) / 100;
    const branchShareAmount = Math.round(platformFee * branchShareRate);
    const hqShareAmount = platformFee - branchShareAmount;

    // Deduct User
    user.walletBalance -= amount;

    // Credit Mitra Driver / Merchant
    const driver = db.drivers.find((d) => d.id === mitraId);
    if (driver) {
      driver.walletBalance += mitraAmount;
      driver.completedTrips += 1;
    }

    // Accumulate Branch
    const branch = db.branches.find((b) => b.id === branchId);
    if (branch) {
      branch.totalSalesAccumulated += amount;
    }

    const txId = `split_${Date.now()}`;
    const txRecord = {
      txId,
      userId: user.id,
      title: `Pembayaran ${serviceType}`,
      date: 'Hari Ini • Baru Saja',
      amount,
      isPositive: false,
      status: 'Berhasil',
      splitDetails: {
        pihak1_userPaid: amount,
        pihak2_mitraShare: {
          mitraId,
          amount: mitraAmount,
          percent: '90%',
        },
        pihak3_platformRevenue: {
          totalFee: platformFee,
          percent: '10%',
          hqSharePusat: hqShareAmount,
          branchShareCabang: branchShareAmount,
        },
      },
    };

    db.transactions.unshift(txRecord);

    return successResponse(
      {
        orderId: `ORD-${Date.now().toString().slice(-6)}`,
        txId,
        userRemainingBalance: user.walletBalance,
        splitSummary: txRecord.splitDetails,
      },
      'Transaksi & Pembagian Dana 3 Pihak Berhasil Diproses Secara Realtime'
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
