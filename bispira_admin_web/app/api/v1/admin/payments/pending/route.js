import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function GET() {
  try {
    const pending = db.pendingPayments.filter((p) => p.status === 'PENDING_VERIFICATION');

    return successResponse(
      {
        totalPending: pending.length,
        items: pending,
      },
      'Daftar Pembayaran Pending Kode Unik Berhasil Diambil'
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
