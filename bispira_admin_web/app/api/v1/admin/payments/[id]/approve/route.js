import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function POST(request, { params }) {
  try {
    const { id } = await params;
    const body = await request.json().catch(() => ({}));
    const { bank_mutation_reference = 'MUTASI_MANUAL_VALIDATED' } = body;

    const payment = db.pendingPayments.find((p) => p.id === id);
    if (!payment) {
      return errorResponse(`Transaksi pending #${id} tidak ditemukan`, 404);
    }

    payment.status = 'APPROVED';
    payment.verifiedAt = new Date().toISOString();
    payment.bankMutationReference = bank_mutation_reference;

    // Credit user if topup
    if (payment.serviceType === 'TOPUP_WALLET' && payment.userId) {
      const user = db.users[payment.userId];
      if (user) {
        user.walletBalance += payment.nominalBase;
        db.transactions.unshift({
          txId: `tx_apprv_${Date.now()}`,
          userId: user.id,
          title: `Top-Up Transfer Manual (${payment.nominalBase.toLocaleString('id-ID')})`,
          date: 'Hari Ini • Baru Saja',
          amount: payment.nominalBase,
          isPositive: true,
          status: 'Berhasil (Diverifikasi Admin)',
        });
      }
    }

    return successResponse(
      payment,
      `Pembayaran #${id} Senilai Rp ${payment.totalTransferRequired.toLocaleString('id-ID')} Berhasil Diverifikasi & Diterima`
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
