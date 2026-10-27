import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function GET() {
  try {
    return successResponse(
      db.settings,
      'Parameter Tarif & Biaya Finansial Berhasil Diambil'
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}

export async function PUT(request) {
  try {
    const body = await request.json();
    const { tariffs, rules } = body;

    if (tariffs) {
      db.settings.tariffs = {
        ...db.settings.tariffs,
        ...tariffs,
      };
    }

    if (rules) {
      db.settings.rules = {
        ...db.settings.rules,
        ...rules,
      };
    }

    return successResponse(
      db.settings,
      'Pengaturan Tarif & Rules Finansial Berhasil Diperbarui Secara Realtime'
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
