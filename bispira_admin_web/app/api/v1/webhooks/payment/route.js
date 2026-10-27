import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function POST(request) {
  try {
    const body = await request.json();
    const { vaNumber, amount, paymentId, bankCode } = body;

    const vaRecord = db.virtualAccounts[vaNumber];

    if (vaRecord) {
      vaRecord.status = 'PAID';
      vaRecord.paidAt = new Date().toISOString();
      vaRecord.paymentReference = paymentId || `PAY-${Date.now()}`;

      const user = db.users[vaRecord.userId] || db.users['BSP-2026-9042'];
      user.walletBalance += Number(amount || vaRecord.expectedAmount);

      const txRecord = {
        txId: `pay_${Date.now()}`,
        userId: user.id,
        title: `Top-Up Virtual Account ${vaRecord.bankCode} (${vaNumber})`,
        date: 'Hari Ini • Baru Saja',
        amount: Number(amount || vaRecord.expectedAmount),
        isPositive: true,
        status: 'Berhasil',
      };
      db.transactions.unshift(txRecord);

      return successResponse(
        {
          vaNumber,
          status: 'SETTLED',
          userNewBalance: user.walletBalance,
        },
        'Webhook Notifikasi Pembayaran Berhasil Diproses (Saldo Dikreditkan)'
      );
    }

    // Fallback: Credit directly to main user
    const fallbackUser = db.users['BSP-2026-9042'];
    fallbackUser.walletBalance += Number(amount || 50000);

    return successResponse(
      {
        vaNumber: vaNumber || 'MOCK-VA',
        status: 'SETTLED_DEMO',
        userNewBalance: fallbackUser.walletBalance,
      },
      'Webhook Berhasil Diproses'
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
