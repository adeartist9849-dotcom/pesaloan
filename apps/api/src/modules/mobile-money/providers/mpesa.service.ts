import { config } from '../../../config/index.js';
import crypto from 'crypto';

interface StkPushRequest {
  phoneNumber: string;
  amount: number;
  accountReference: string;
  transactionDesc: string;
  callbackUrl: string;
  businessShortCode?: string; // Optional: override default shortcode (for till/paybill)
}

interface StkPushResponse {
  MerchantRequestID: string;
  CheckoutRequestID: string;
  ResponseCode: string;
  ResponseDescription: string;
  CustomerMessage: string;
}

interface B2CRequest {
  phoneNumber: string;
  amount: number;
  remarks: string;
  occasion: string;
}

interface B2CResponse {
  ConversationID: string;
  OriginatorConversationID: string;
  ResponseCode: string;
  ResponseDescription: string;
}

interface CallbackData {
  Body: {
    stkCallback: {
      MerchantRequestID: string;
      CheckoutRequestID: string;
      ResultCode: number;
      ResultDesc: string;
      CallbackMetadata?: {
        Item: Array<{ Name: string; Value: string | number }>;
      };
    };
  };
}

export class MpesaService {
  private accessToken: string | null = null;
  private tokenExpiry: number = 0;
  
  private async getAccessToken(): Promise<string> {
    if (this.accessToken && Date.now() < this.tokenExpiry) {
      return this.accessToken;
    }
    
    const auth = Buffer.from(`${config.mpesa.consumerKey}:${config.mpesa.consumerSecret}`).toString('base64');
    
    const response = await fetch(`${config.mpesa.baseUrl}/oauth/v1/generate?grant_type=client_credentials`, {
      method: 'GET',
      headers: { Authorization: `Basic ${auth}` },
    });
    
    if (!response.ok) {
      throw new Error('Failed to get M-Pesa access token');
    }
    
    const data = await response.json() as { access_token: string; expires_in: number };
    this.accessToken = data.access_token;
    this.tokenExpiry = Date.now() + (data.expires_in - 60) * 1000;
    
    return this.accessToken;
  }
  
  private generatePassword(): { password: string; timestamp: string } {
    const timestamp = new Date().toISOString().replace(/[-:T.]/g, '').slice(0, 14);
    const password = Buffer.from(`${config.mpesa.shortcode}${config.mpesa.passkey}${timestamp}`).toString('base64');
    return { password, timestamp };
  }
  
  async stkPush(request: StkPushRequest): Promise<StkPushResponse> {
    const token = await this.getAccessToken();
    const { password, timestamp } = this.generatePassword();
    
    // Use provided businessShortCode or default to config shortcode
    const businessShortCode = request.businessShortCode || config.mpesa.shortcode;
    
    const payload = {
      BusinessShortCode: businessShortCode,
      Password: password,
      Timestamp: timestamp,
      TransactionType: 'CustomerPayBillOnline',
      Amount: request.amount,
      PartyA: request.phoneNumber,
      PartyB: businessShortCode,
      PhoneNumber: request.phoneNumber,
      CallBackURL: request.callbackUrl,
      AccountReference: request.accountReference,
      TransactionDesc: request.transactionDesc,
    };
    
    const response = await fetch(`${config.mpesa.baseUrl}/mpesa/stkpush/v1/processrequest`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });
    
    if (!response.ok) {
      const error = await response.text();
      throw new Error(`M-Pesa STK Push failed: ${error}`);
    }
    
    return response.json() as Promise<StkPushResponse>;
  }
  
  async b2cPayment(request: B2CRequest): Promise<B2CResponse> {
    const token = await this.getAccessToken();
    const { password, timestamp } = this.generatePassword();
    
    const payload = {
      InitiatorName: (config.mpesa as any).initiatorName || 'testapi',
      SecurityCredential: (config.mpesa as any).securityCredential || '',
      CommandID: 'BusinessPayment',
      Amount: request.amount,
      PartyA: config.mpesa.shortcode,
      PartyB: request.phoneNumber,
      Remarks: request.remarks,
      QueueTimeOutURL: `${config.mpesa.callbackUrl}/b2c/timeout`,
      ResultURL: `${config.mpesa.callbackUrl}/b2c/result`,
      Occasion: request.occasion,
    };
    
    const response = await fetch(`${config.mpesa.baseUrl}/mpesa/b2c/v1/paymentrequest`, {
      method: 'POST',
      headers: {
        Authorization: `Bearer ${token}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify(payload),
    });
    
    if (!response.ok) {
      const error = await response.text();
      throw new Error(`M-Pesa B2C failed: ${error}`);
    }
    
    return response.json() as Promise<B2CResponse>;
  }
  
  verifyCallback(callback: CallbackData): { success: boolean; transactionId?: string; amount?: number; phoneNumber?: string } {
    const { stkCallback } = callback.Body;
    
    if (stkCallback.ResultCode !== 0) {
      return { success: false };
    }
    
    const metadata = stkCallback.CallbackMetadata?.Item || [];
    const getValue = (name: string) => metadata.find(item => item.Name === name)?.Value;
    
    const transactionId = getValue('MpesaReceiptNumber') as string;
    const amount = getValue('Amount') as number;
    const phoneNumber = getValue('PhoneNumber') as string;
    
    return {
      success: true,
      transactionId,
      amount,
      phoneNumber: phoneNumber.startsWith('254') ? phoneNumber : `254${phoneNumber.slice(1)}`,
    };
  }
  
  validateCallbackSignature(signature: string, body: string): boolean {
    // M-Pesa uses SHA256 with the consumer secret
    const expectedSignature = crypto
      .createHmac('sha256', config.mpesa.consumerSecret)
      .update(body)
      .digest('hex');
    
    return crypto.timingSafeEqual(Buffer.from(signature), Buffer.from(expectedSignature));
  }
}

export const mpesaService = new MpesaService();