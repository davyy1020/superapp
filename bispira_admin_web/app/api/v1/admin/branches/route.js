import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function GET() {
  try {
    return successResponse(
      {
        total: db.branches.length,
        items: db.branches,
      },
      'Data Pusat Cabang & Lisensi Franchise Berhasil Diambil'
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}

export async function POST(request) {
  try {
    const body = await request.json();
    const { name, kabupaten, partnerCompany, profitSharePercent = 30.0 } = body;

    if (!name || !kabupaten) {
      return errorResponse('Nama Cabang dan Wilayah Kabupaten wajib diisi', 400);
    }

    const newBranch = {
      id: `BRN-00${db.branches.length + 1}`,
      code: `CBG-${kabupaten.replace(/\s+/g, '').toUpperCase().slice(0, 7)}`,
      name,
      kabupaten,
      licenseStatus: 'AKTIF',
      partnerCompany: partnerCompany || 'Mitra Franchise Daerah',
      profitSharePercent: Number(profitSharePercent),
      activeDrivers: 0,
      activeMerchants: 0,
      totalSalesAccumulated: 0,
      createdAt: new Date().toISOString(),
    };

    db.branches.push(newBranch);

    return successResponse(
      newBranch,
      `Lisensi Cabang Baru #${newBranch.id} (${newBranch.name}) Berhasil Diterbitkan!`
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
