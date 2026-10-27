import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const branchId = searchParams.get('branchId');
    const status = searchParams.get('status');

    let list = db.drivers;

    if (branchId && branchId !== 'BRN-HQ') {
      list = list.filter((d) => d.branchId === branchId);
    }

    if (status) {
      list = list.filter((d) => d.kycStatus === status.toUpperCase());
    } else {
      // Default verification-pending endpoint returns pending drivers
      const pendingList = list.filter((d) => d.kycStatus === 'PENDING');
      return successResponse(
        {
          totalPending: pendingList.length,
          drivers: pendingList,
          allDriversSummary: {
            total: list.length,
            online: list.filter((d) => d.isOnline).length,
          },
        },
        'Antrean Verifikasi Driver Berhasil Diambil'
      );
    }

    return successResponse(list, 'Data Driver Berhasil Diambil');
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
