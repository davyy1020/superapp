import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const branchId = searchParams.get('branchId');

    const totalMerchants = db.merchants.length;
    const totalDrivers = db.drivers.length;
    const onlineDrivers = db.drivers.filter((d) => d.isOnline).length;
    const pendingKycDrivers = db.drivers.filter((d) => d.kycStatus === 'PENDING').length;
    const pendingManualPayments = db.pendingPayments.filter((p) => p.status === 'PENDING_VERIFICATION').length;

    // Gross GMV calculation
    const totalGrossSales = db.branches.reduce((acc, b) => acc + b.totalSalesAccumulated, 0);
    const totalPlatformFee = Math.round(totalGrossSales * 0.10);
    const totalHqShare = Math.round(totalPlatformFee * 0.70);
    const totalBranchShare = totalPlatformFee - totalHqShare;

    return successResponse(
      {
        filterBranch: branchId || 'ALL_HQ',
        financialOverview: {
          totalGmv: totalGrossSales,
          platformNetRevenue: totalPlatformFee,
          hqHeadquartersRevenue: totalHqShare,
          regionalBranchShareRevenue: totalBranchShare,
          upcomingBatchDisbursement17Wib: db.disbursements.reduce((sum, d) => sum + d.netPayoutAmount, 0),
        },
        operationsSummary: {
          totalActiveBranches: db.branches.length,
          totalRegisteredMerchants: totalMerchants,
          totalDrivers: totalDrivers,
          activeOnlineDrivers: onlineDrivers,
          pendingDriverKycQueue: pendingKycDrivers,
          pendingManualBankMutationQueue: pendingManualPayments,
        },
        currentTariffSnapshot: db.settings.tariffs,
      },
      'Statistik Dashboard Admin BISPIRA Berhasil Diperbarui'
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
