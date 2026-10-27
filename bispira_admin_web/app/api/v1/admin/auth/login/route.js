import { db } from '@/lib/db';
import { successResponse, errorResponse, handleOptions } from '@/lib/api-response';

export async function OPTIONS() {
  return handleOptions();
}

export async function POST(request) {
  try {
    const body = await request.json();
    const { email = '', password = '' } = body;

    const emailTrimmed = email.trim().toLowerCase();
    const admin = db.admins.find((a) => a.email.toLowerCase() === emailTrimmed);

    if (!admin) {
      return errorResponse('Email admin tidak terdaftar dalam sistem', 401);
    }

    if (password && admin.password !== password) {
      return errorResponse('Kata sandi yang Anda masukkan salah', 401);
    }

    // Mock secure JWT token
    const token = `bsp_adm_jwt_${Buffer.from(admin.id + ':' + Date.now()).toString('base64')}`;

    return successResponse(
      {
        token,
        admin: {
          id: admin.id,
          name: admin.name,
          email: admin.email,
          role: admin.role,
          roleTitle: admin.roleTitle,
          branchId: admin.branchId,
          branchName: admin.branchName,
          status: admin.status,
        },
      },
      `Selamat datang kembali, ${admin.name} (${admin.roleTitle})`
    );
  } catch (error) {
    return errorResponse(error.message, 500);
  }
}
