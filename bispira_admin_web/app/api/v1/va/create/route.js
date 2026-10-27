import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function POST(request) {
  try {
    const body = await request.json().catch(() => ({}));
    const { userId = 'BSP-2026-9042', bankCode = 'BNI', amount = 50000 } = body || {};

    const user = (db.users && db.users[userId]) || {
      id: userId || 'BSP-2026-9042',
      name: 'Davy Wahyu Saputra',
    };
    const randomSuffix = Math.floor(100000000 + Math.random() * 900000000);
    const vaNumber = `8808${randomSuffix}`;
    const vaId = `va_${Date.now()}`;

    const vaData = {
      vaId,
      userId: user.id,
      customerName: user.name,
      bankCode: (bankCode || 'BNI').toUpperCase(),
      vaNumber,
      expectedAmount: Number(amount) || 50000,
      status: 'PENDING',
      createdAt: new Date().toISOString(),
      expiresAt: new Date(Date.now() + 24 * 60 * 60 * 1000).toISOString(),
    };

    if (!db.virtualAccounts) db.virtualAccounts = {};
    db.virtualAccounts[vaNumber] = vaData;

    return successResponse(vaData, 'Virtual Account SNAP BI Berhasil Diterbitkan');
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
