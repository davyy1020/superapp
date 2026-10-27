import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function POST(request) {
  try {
    const body = await request.json().catch(() => ({}));
    const { payout_ids = [] } = body;

    let targets = db.disbursements;
    if (payout_ids.length > 0) {
      targets = targets.filter((d) => payout_ids.includes(d.id));
    }

    const executedAt = new Date().toISOString();
    const results = targets.map((p) => {
      p.status = 'PAID_OUT';
      p.executedAt = executedAt;
      p.disbursementRef = `DISB-BIF-${Date.now()}-${Math.floor(Math.random() * 9000 + 1000)}`;

      // Deduct merchant accumulated balance
      const merchant = db.merchants.find((m) => m.id === p.merchantId);
      if (merchant) {
        merchant.accumulatedSales = Math.max(0, merchant.accumulatedSales - p.grossAmount);
      }

      return {
        id: p.id,
        recipient: p.recipientName,
        netPayout: p.netPayoutAmount,
        bank: `${p.bankName} - ${p.accountNumber}`,
        reference: p.disbursementRef,
        status: 'SUCCESS',
      };
    });

    return successResponse(
      {
        totalExecuted: results.length,
        executionTimestamp: executedAt,
        details: results,
      },
      `Batch Pencairan Dana 17:00 WIB Sukses Dieksekusi untuk ${results.length} Mitra/Merchant`
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
