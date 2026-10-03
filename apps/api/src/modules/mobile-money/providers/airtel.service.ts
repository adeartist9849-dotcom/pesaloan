import { config } from '../../../config/index.js';
import crypto from 'crypto';

interface AirtelAuthResponse {
  access_token: string;
  token_type: string;
  expires_in: number;
}

interface AirtelPaymentRequest {
  reference: string;
  subscriber: {
    country: string;
    currency: string;
    msisdn: string;
  },
  transaction: {
    amount: string;
    currency: string;
    id: string;
    type: string;
  }
}

interface AirtelPaymentResponse {
  status: {
    code: string;
    reason: string;
  },
  transaction: {
    id: string;
    status: string;
  }
}

interface AirtelDisbursementRequest {
  reference: string;
  subscriber: {
    country: string;
    currency: string;
    msisdn: string;
  },
  transaction: {
    amount: string;
    currency: string;
    id: string;
    type: string;
  }
}

export class AirtelMoneyService {
  private accessToken: string | null = null;
  private tokenExpiry: number = 0;

  private async getAccessToken(): Promise<string> {
    if (this.accessToken && Date.now() < this.tokenExpiry) {
      return this.accessToken;
    }

    const auth = Buffer.from(`${config.airtel.clientId}:${config.airtel.clientSecret}`).toString('base64');

    const response = await fetch(`${config.airtel.baseUrl}/auth/oauth2/token`, {
      method: 'POST',
      headers: {
        Authorization: `Basic ${auth}`,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`Airtel Money auth failed: ${error}`);
    }

    const data = await response.json() as AirtelAuthResponse;
    this.accessToken = data.access_token;
    this.tokenExpiry = Date.now() + (data.expires_in - 60) * 1000;

    return this.accessToken;
  }

  async collectionPayment(request: AirtelPaymentRequest): Promise<AirtelPaymentResponse> {
    const token = await this.getAccessToken();

    const response = await fetch(`${config.airtel.baseUrl}/merchant/v2/payments/`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
        'X-Country': 'KE',
        'X-Currency': 'KES',
      },
      body: JSON.stringify(request),
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`Airtel Money payment failed: ${error}`);
    }

    return response.json() as Promise<AirtelPaymentResponse>;
  }

  async disbursementPayment(request: AirtelDisbursementRequest): Promise<AirtelPaymentResponse> {
    const token = await this.getAccessToken();

    const response = await fetch(`${config.airtel.baseUrl}/merchant/v2/disbursements/`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
        'X-Country': 'KE',
        'X-Currency': 'KES',
      },
      body: JSON.stringify(request),
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`Airtel Money disbursement failed: ${error}`);
    }

    return response.json() as Promise<AirtelPaymentResponse>;
  }

  async getTransactionStatus(transactionId: string): Promise<any> {
    const token = await this.getAccessToken();

    const response = await fetch(`${config.airtel.baseUrl}/merchant/v2/transactions/${transactionId}`, {
      method: 'GET',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
    });

    if (!response.ok) {
      const error = await response.text();
      throw new Error(`Airtel Money status check failed: ${error}`);
    }

    return response.json();
  }

  generateReference(prefix: string): string {
    const timestamp = Date.now().toString(36).toUpperCase();
    const random = crypto.randomBytes(4).toString('hex').toUpperCase();
    return `${prefix}${timestamp}${random}`;
  }
}

export const airtelMoneyService = new AirtelMoneyService();