import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function POST(request, { params }) {
  try {
    const { id } = await params;
    const body = await request.json().catch(() => ({}));
    const { reason = 'Dana tidak ditemukan di mutasi rekening bank setelah dicek.' } = body;

    const payment = db.pendingPayments.find((p) => p.id === id);
    if (!payment) {
      return errorResponse(`Transaksi pending #${id} tidak ditemukan`, 404);
    }

    payment.status = 'REJECTED';
    payment.rejectedAt = new Date().toISOString();
    payment.rejectionReason = reason;

    return successResponse(
      payment,
      `Pembayaran #${id} Ditolak. Alasan: ${reason}`
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
