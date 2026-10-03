export const config = {
  nodeEnv: process.env.NODE_ENV || 'development',
  port: parseInt(process.env.PORT || '3000', 10),
  host: process.env.HOST || '0.0.0.0',
  logLevel: process.env.LOG_LEVEL || 'info',
  
  // Database
  databaseUrl: process.env.DATABASE_URL || 'postgresql://postgres:postgres@localhost:5432/pesaloan',
  
  // Redis
  redisUrl: process.env.REDIS_URL || 'redis://localhost:6379',
  
  // JWT
  jwtSecret: process.env.JWT_SECRET || 'dev-secret-change-in-production',
  jwtExpiry: process.env.JWT_EXPIRY || '15m',
  refreshTokenExpiry: process.env.REFRESH_TOKEN_EXPIRY || '90d',
  
  // Encryption
  encryptionKey: process.env.ENCRYPTION_KEY || 'dev-encryption-key-32-chars-long!!',
  
  // M-Pesa
  mpesa: {
    consumerKey: process.env.MPESA_CONSUMER_KEY || '',
    consumerSecret: process.env.MPESA_CONSUMER_SECRET || '',
    passkey: process.env.MPESA_PASSKEY || '',
    shortcode: process.env.MPESA_SHORTCODE || '',
    baseUrl: process.env.MPESA_BASE_URL || 'https://sandbox.safaricom.co.ke',
    callbackUrl: process.env.MPESA_CALLBACK_URL || 'http://localhost:3000/api/v1/mobile-money/mpesa/callback',
  },
  
  // Airtel Money
  airtel: {
    clientId: process.env.AIRTEL_CLIENT_ID || '',
    clientSecret: process.env.AIRTEL_CLIENT_SECRET || '',
    baseUrl: process.env.AIRTEL_BASE_URL || 'https://openapi-sandbox.airtel.africa',
    callbackUrl: process.env.AIRTEL_CALLBACK_URL || 'http://localhost:3000/api/v1/mobile-money/airtel/callback',
  },
  
  // KYC Provider
  kyc: {
    provider: process.env.KYC_PROVIDER || 'mock',
    apiKey: process.env.KYC_API_KEY || '',
    baseUrl: process.env.KYC_BASE_URL || '',
  },
  
  // SMS Provider
  sms: {
    provider: process.env.SMS_PROVIDER || 'mock',
    apiKey: process.env.SMS_API_KEY || '',
    senderId: process.env.SMS_SENDER_ID || 'PesaLoan',
  },
  
  // Push Notifications
  push: {
    provider: process.env.PUSH_PROVIDER || 'mock',
    apiKey: process.env.PUSH_API_KEY || '',
    projectId: process.env.PUSH_PROJECT_ID || '',
  },
  
  // App
  appName: 'PesaLoan',
  appVersion: '1.0.0',
  defaultCurrency: 'KES',
  defaultCountry: 'KE',
};
