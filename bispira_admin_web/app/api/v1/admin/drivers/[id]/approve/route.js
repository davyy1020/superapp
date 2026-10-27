import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function POST(request, { params }) {
  try {
    const { id } = await params;
    const body = await request.json().catch(() => ({}));
    const { approval_note = 'Dokumen KTP, SIM, STNK lengkap dan terverifikasi sah.' } = body;

    const driver = db.drivers.find((d) => d.id === id);
    if (!driver) {
      return errorResponse(`Driver dengan ID #${id} tidak ditemukan`, 404);
    }

    driver.kycStatus = 'APPROVED';
    driver.approvedAt = new Date().toISOString();
    driver.approvalNote = approval_note;

    return successResponse(
      driver,
      `Pendaftaran Driver #${id} (${driver.name}) Resmi Disetujui & Diaktifkan`
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
