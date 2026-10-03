import { NextRequest, NextResponse } from 'next/server';
import { getServerSession } from 'next-auth';
import { authOptions } from '@/lib/auth/auth-options';

const API_BASE_URL = process.env.NEXT_PUBLIC_API_URL || 'http://localhost:3000/api/v1';

async function getAuthHeaders() {
  const session = await getServerSession(authOptions);
  if (!session?.user) {
    return null;
  }
  // Get the access token from session
  const accessToken = (session as any).accessToken;
  if (!accessToken) {
    return null;
  }
  return { Authorization: `Bearer ${accessToken}` };
}

export async function GET() {
  try {
    const headers = await getAuthHeaders();
    if (!headers) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 403 });
    }

    const response = await fetch(`${API_BASE_URL}/admin/registration-fee`, {
      headers: {
        'Content-Type': 'application/json',
        ...headers,
      },
    });

    if (response.status === 404) {
      return NextResponse.json({ error: 'Not found' }, { status: 404 });
    }

    if (!response.ok) {
      return NextResponse.json({ error: 'Failed to fetch' }, { status: response.status });
    }

    const data = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    console.error('Error fetching registration fee:', error);
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}

export async function PUT(request: NextRequest) {
  try {
    const headers = await getAuthHeaders();
    if (!headers) {
      return NextResponse.json({ error: 'Unauthorized' }, { status: 403 });
    }

    const body = await request.json();
    const { amount, currency = 'KES', isActive = true, description } = body;

    if (!amount || amount <= 0) {
      return NextResponse.json({ error: 'Invalid amount' }, { status: 400 });
    }

    const response = await fetch(`${API_BASE_URL}/admin/registration-fee`, {
      method: 'PUT',
      headers: {
        'Content-Type': 'application/json',
        ...headers,
      },
      body: JSON.stringify({ amount, currency, isActive, description }),
    });

    if (!response.ok) {
      const errorData = await response.json();
      return NextResponse.json({ error: errorData.message || 'Failed to save' }, { status: response.status });
    }

    const data = await response.json();
    return NextResponse.json(data);
  } catch (error) {
    console.error('Error updating registration fee:', error);
    return NextResponse.json({ error: 'Internal server error' }, { status: 500 });
  }
}