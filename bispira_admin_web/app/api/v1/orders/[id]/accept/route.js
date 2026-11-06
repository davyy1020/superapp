import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function POST(request, { params }) {
  try {
    const { id } = await params;
    const body = await request.json().catch(() => ({}));
    const {
      driverId = 'DRV-BSP-8821',
      driverName = 'BUDI SANTOSO',
      driverPlate = 'B 4982 BSP',
    } = body;

    const order = (db.orders || []).find((o) => o.id === id);
    if (!order) {
      return errorResponse(`Order dengan ID ${id} tidak ditemukan`, 404);
    }

    if (order.status !== 'LOOKING_FOR_DRIVER' && order.status !== 'incoming') {
      return errorResponse(`Order sudah tidak tersedia (status: ${order.status})`, 400);
    }

    order.status = 'ACCEPTED';
    order.driverId = driverId;
    order.driverName = driverName;
    order.driverPlate = driverPlate;
    order.acceptedAt = new Date().toISOString();

    return successResponse(order, `Order ${id} berhasil diterima oleh ${driverName}!`);
  } catch (error) {
    return errorResponse('Gagal menerima order: ' + error.message, 500);
  }
}
