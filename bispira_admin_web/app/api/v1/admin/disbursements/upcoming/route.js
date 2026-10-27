import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function GET() {
  try {
    const list = db.disbursements;
    const totalGross = list.reduce((sum, item) => sum + item.grossAmount, 0);
    const totalNet = list.reduce((sum, item) => sum + item.netPayoutAmount, 0);
    const totalAdminFee = list.reduce((sum, item) => sum + item.adminFee, 0);

    return successResponse(
      {
        scheduleTime: '17:00 WIB',
        summary: {
          totalRecipients: list.length,
          totalGrossAmount: totalGross,
          totalNetPayoutAmount: totalNet,
          totalAdminFeeDeducted: totalAdminFee,
        },
        items: list,
      },
      'Daftar Batch Pencairan Dana Pukul 17:00 WIB Berhasil Diambil'
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
