import { NextResponse } from 'next/server';

export const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'GET, POST, PUT, DELETE, OPTIONS, PATCH',
  'Access-Control-Allow-Headers': 'Content-Type, Authorization, x-callback-token, X-Requested-With',
};

export function successResponse(data, message = 'Success', status = 200) {
  return NextResponse.json(
    {
      status: 'SUCCESS',
      message,
      data,
      timestamp: new Date().toISOString(),
    },
    {
      status,
      headers: corsHeaders,
    }
  );
}

export function errorResponse(message = 'An error occurred', status = 400, details = null) {
  console.error('[API-ERROR]', message, details);
  return NextResponse.json(
    {
      status: 'ERROR',
      message,
      details,
      timestamp: new Date().toISOString(),
    },
    {
      status,
      headers: corsHeaders,
    }
  );
}

export function handleOptions() {
  return new NextResponse(null, {
    status: 204,
    headers: corsHeaders,
  });
}
