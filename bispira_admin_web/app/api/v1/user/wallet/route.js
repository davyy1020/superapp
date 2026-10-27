import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function GET(request) {
  try {
    const { searchParams } = new URL(request.url);
    const userId = searchParams.get('userId') || 'BSP-2026-9042';

    const user = db.users[userId] || db.users['BSP-2026-9042'];
    const userTxs = db.transactions.filter((tx) => !tx.userId || tx.userId === user.id);

    return successResponse({
      user: {
        id: user.id,
        name: user.name,
        phone: user.phone,
        email: user.email,
        walletBalance: user.walletBalance,
        bankCode: user.bankCode,
        bankAccountNo: user.bankAccountNo,
      },
      transactions: userTxs,
    });
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}

export async function POST(request) {
  try {
    const body = await request.json();
    const { userId = 'BSP-2026-9042', amount = 100000, description = 'Top-Up Saldo' } = body;

    const user = db.users[userId] || db.users['BSP-2026-9042'];
    const topupAmount = Number(amount);

    user.walletBalance += topupAmount;

    const txRecord = {
      txId: `tx_${Date.now()}`,
      userId: user.id,
      title: description,
      date: 'Hari Ini • Baru Saja',
      amount: topupAmount,
      isPositive: true,
      status: 'Berhasil',
    };

    db.transactions.unshift(txRecord);

    return successResponse(
      {
        newBalance: user.walletBalance,
        transaction: txRecord,
      },
      `Top-Up Sebesar Rp ${topupAmount.toLocaleString('id-ID')} Berhasil Diterapkan`
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
