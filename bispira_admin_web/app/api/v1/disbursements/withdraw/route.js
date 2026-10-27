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
      amount = 50000,
      bankCode = 'BNI',
      accountNumber = '9876543210',
      accountHolderName = 'DAVY WAHYU SAPUTRA',
    } = body;

    const user = db.users[userId] || db.users['BSP-2026-9042'];
    const withdrawAmount = Number(amount);
    const biFastFee = db.settings.rules.bifast_admin_fee || 2500;
    const totalDeduction = withdrawAmount + biFastFee;

    if (user.walletBalance < totalDeduction) {
      return errorResponse(
        `Saldo tidak mencukupi. Saldo Anda: Rp ${user.walletBalance.toLocaleString('id-ID')}, Dibutuhkan: Rp ${totalDeduction.toLocaleString('id-ID')} (Termasuk Biaya BI-Fast Rp ${biFastFee})`,
        400
      );
    }

    user.walletBalance -= totalDeduction;

    const txRecord = {
      txId: `disb_${Date.now()}`,
      userId: user.id,
      title: `Penarikan BI-Fast (${bankCode.toUpperCase()} - ${accountNumber})`,
      date: 'Hari Ini • Baru Saja',
      amount: withdrawAmount,
      fee: biFastFee,
      isPositive: false,
      status: 'Berhasil',
      referenceNumber: `BIF-${Date.now().toString().slice(-8)}`,
    };

    db.transactions.unshift(txRecord);

    return successResponse(
      {
        transaction: txRecord,
        newBalance: user.walletBalance,
        recipient: {
          bankCode: bankCode.toUpperCase(),
          accountNumber,
          accountHolderName,
        },
      },
      `Penarikan Rp ${withdrawAmount.toLocaleString('id-ID')} Berhasil via BI-Fast`
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
