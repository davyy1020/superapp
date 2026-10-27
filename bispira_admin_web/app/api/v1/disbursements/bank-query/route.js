import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function POST(request) {
  try {
    const body = await request.json();
    const { bankCode = 'BNI', accountNumber = '' } = body;

    if (!accountNumber) {
      return errorResponse('Nomor rekening bank wajib diisi', 400);
    }

    // Mock account holder lookup
    const names = ['DAVY WAHYU SAPUTRA', 'SITI NURHALIZA', 'BUDI SANTOSO', 'AHMAD FAUZI'];
    const chosenName = names[Math.abs(accountNumber.split('').reduce((a, b) => a + b.charCodeAt(0), 0)) % names.length];

    const data = {
      bankCode: bankCode.toUpperCase(),
      accountNumber,
      accountHolderName: chosenName,
      routingMethod: 'BI-FAST (SKNBI/FAST)',
      status: 'ACCOUNT_VALIDATED',
      isValid: true,
      inquiryTimestamp: new Date().toISOString(),
    };

    return successResponse(data, 'Verifikasi Rekening Tujuan Sukses (BI-Fast)');
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
