export const APP_CONFIG = {
  name: 'PesaLoan',
  version: '1.0.0',
  currency: 'KES',
  country: 'KE',
  defaultLanguage: 'en',
  supportedLanguages: ['en', 'sw'],
} as const;

export const LOAN_CONSTRAINTS = {
  minAmount: 500,
  maxAmount: 50000,
  minTermDays: 7,
  maxTermDays: 90,
  maxActiveLoans: 1,
} as const;

export const KYC_CONSTRAINTS = {
  minAge: 18,
  maxAge: 70,
  idExpiryBufferDays: 30,
} as const;

export const SECURITY_CONSTRAINTS = {
  pinLength: { min: 4, max: 6 },
  maxFailedLoginAttempts: 5,
  lockoutDurationMinutes: 15,
  otpLength: 6,
  otpExpiryMinutes: 5,
  sessionExpiryDays: 30,
  refreshTokenExpiryDays: 90,
} as const;

export const PAGINATION_DEFAULTS = {
  page: 1,
  limit: 20,
  maxLimit: 100,
} as const;

export const NOTIFICATION_TEMPLATES = {
  [NotificationType.OTP]: {
    push: { title: 'Your OTP Code', body: 'Your verification code is {{code}}. Valid for {{expiry}} minutes.' },
    sms: 'Your PesaLoan verification code is {{code}}. Valid for {{expiry}} minutes. Do not share.',
  },
  [NotificationType.APPLICATION_APPROVED]: {
    push: { title: 'Loan Approved!', body: 'Your loan of KES {{amount}} has been approved. Tap to accept.' },
    sms: 'PesaLoan: Your loan of KES {{amount}} approved. Open app to accept. Terms apply.',
  },
  [NotificationType.APPLICATION_DECLINED]: {
    push: { title: 'Loan Application Update', body: 'Your loan application was not approved at this time.' },
    sms: 'PesaLoan: Your loan application was declined. You can reapply after 30 days.',
  },
  [NotificationType.LOAN_DISBURSED]: {
    push: { title: 'Funds Sent!', body: 'KES {{amount}} has been sent to your M-Pesa.' },
    sms: 'PesaLoan: KES {{amount}} disbursed to your M-Pesa. Ref: {{ref}}. Due {{dueDate}}.',
  },
  [NotificationType.PAYMENT_RECEIVED]: {
    push: { title: 'Payment Received', body: 'KES {{amount}} received. Outstanding: KES {{balance}}.' },
    sms: 'PesaLoan: Payment of KES {{amount}} received. Balance: KES {{balance}}. Ref: {{ref}}.',
  },
  [NotificationType.UPCOMING_REPAYMENT]: {
    push: { title: 'Repayment Due Soon', body: 'Your loan repayment of KES {{amount}} is due in {{days}} days.' },
    sms: 'PesaLoan: Reminder - KES {{amount}} due on {{dueDate}}. Pay via app to avoid late fees.',
  },
  [NotificationType.LOAN_OVERDUE]: {
    push: { title: 'Loan Overdue', body: 'Your repayment of KES {{amount}} was due on {{dueDate}}. Pay now.' },
    sms: 'PesaLoan: URGENT - Loan overdue. KES {{amount}} due since {{dueDate}}. Pay now to avoid penalties.',
  },
  [NotificationType.LOAN_FULLY_REPAID]: {
    push: { title: 'Loan Cleared!', body: 'Congratulations! Your loan has been fully repaid.' },
    sms: 'PesaLoan: Your loan is fully repaid. You\'re now eligible for a new loan. Thank you!',
  },
} as const;

export const API_ENDPOINTS = {
  auth: {
    register: '/auth/register',
    login: '/auth/login',
    refresh: '/auth/refresh',
    logout: '/auth/logout',
    requestOtp: '/auth/otp/request',
    verifyOtp: '/auth/otp/verify',
  },
  users: {
    profile: '/users/profile',
    updateProfile: '/users/profile',
    changePin: '/users/pin',
  },
  kyc: {
    submit: '/kyc/submit',
    status: '/kyc/status',
  },
  loans: {
    apply: '/loans/apply',
    offer: '/loans/offer/:id',
    accept: '/loans/accept',
    dashboard: '/loans/dashboard',
    history: '/loans/history',
    detail: '/loans/:id',
    repay: '/loans/repay',
    repayCallback: '/loans/repay/callback',
  },
  notifications: {
    list: '/notifications',
    markRead: '/notifications/:id/read',
  },
} as const;

export const MOBILE_MONEY = {
  mpesa: {
    sandboxBaseUrl: 'https://sandbox.safaricom.co.ke',
    productionBaseUrl: 'https://api.safaricom.co.ke',
    stkPushEndpoint: '/mpesa/stkpush/v1/processrequest',
    b2cEndpoint: '/mpesa/b2c/v1/paymentrequest',
    callbackTimeoutSeconds: 30,
  },
  airtel: {
    sandboxBaseUrl: 'https://openapi-sandbox.airtel.africa',
    productionBaseUrl: 'https://openapi.airtel.africa',
  },
} as const;

export const REGEX_PATTERNS = {
  kenyanPhone: /^254[17]\d{8}$/,
  kenyanPhoneDisplay: /^0[17]\d{8}$/,
  nationalId: /^\d{8}$/,
  email: /^[^\s@]+@[^\s@]+\.[^\s@]+$/,
  pin: /^\d{4,6}$/,
  otp: /^\d{6}$/,
} as const;

export const ERROR_CODES = {
  // Auth
  INVALID_CREDENTIALS: 'INVALID_CREDENTIALS',
  ACCOUNT_LOCKED: 'ACCOUNT_LOCKED',
  ACCOUNT_SUSPENDED: 'ACCOUNT_SUSPENDED',
  OTP_EXPIRED: 'OTP_EXPIRED',
  OTP_INVALID: 'OTP_INVALID',
  OTP_MAX_ATTEMPTS: 'OTP_MAX_ATTEMPTS',
  TOKEN_EXPIRED: 'TOKEN_EXPIRED',
  TOKEN_INVALID: 'TOKEN_INVALID',

  // KYC
  KYC_ALREADY_SUBMITTED: 'KYC_ALREADY_SUBMITTED',
  KYC_NOT_VERIFIED: 'KYC_NOT_VERIFIED',
  KYC_EXPIRED: 'KYC_EXPIRED',
  KYC_REJECTED: 'KYC_REJECTED',

  // Loans
  LOAN_LIMIT_EXCEEDED: 'LOAN_LIMIT_EXCEEDED',
  LOAN_TERM_INVALID: 'LOAN_TERM_INVALID',
  LOAN_AMOUNT_INVALID: 'LOAN_AMOUNT_INVALID',
  LOAN_ACTIVE_EXISTS: 'LOAN_ACTIVE_EXISTS',
  LOAN_NOT_ELIGIBLE: 'LOAN_NOT_ELIGIBLE',
  LOAN_OFFER_EXPIRED: 'LOAN_OFFER_EXPIRED',
  LOAN_ALREADY_ACCEPTED: 'LOAN_ALREADY_ACCEPTED',
  LOAN_NOT_FOUND: 'LOAN_NOT_FOUND',
  LOAN_NOT_ACTIVE: 'LOAN_NOT_ACTIVE',
  LOAN_OVERDUE: 'LOAN_OVERDUE',

  // Repayments
  REPAYMENT_AMOUNT_INVALID: 'REPAYMENT_AMOUNT_INVALID',
  REPAYMENT_PROCESSING: 'REPAYMENT_PROCESSING',
  REPAYMENT_FAILED: 'REPAYMENT_FAILED',

  // General
  VALIDATION_ERROR: 'VALIDATION_ERROR',
  UNAUTHORIZED: 'UNAUTHORIZED',
  FORBIDDEN: 'FORBIDDEN',
  NOT_FOUND: 'NOT_FOUND',
  CONFLICT: 'CONFLICT',
  RATE_LIMITED: 'RATE_LIMITED',
  INTERNAL_ERROR: 'INTERNAL_ERROR',
  SERVICE_UNAVAILABLE: 'SERVICE_UNAVAILABLE',
} as const;

export const AUDIT_ACTIONS = {
  // Auth
  USER_REGISTERED: 'USER_REGISTERED',
  USER_LOGIN: 'USER_LOGIN',
  USER_LOGOUT: 'USER_LOGOUT',
  PIN_CHANGED: 'PIN_CHANGED',
  PASSWORD_RESET: 'PASSWORD_RESET',

  // KYC
  KYC_SUBMITTED: 'KYC_SUBMITTED',
  KYC_VERIFIED: 'KYC_VERIFIED',
  KYC_REJECTED: 'KYC_REJECTED',
  KYC_MANUAL_REVIEW: 'KYC_MANUAL_REVIEW',

  // Loans
  LOAN_APPLICATION_SUBMITTED: 'LOAN_APPLICATION_SUBMITTED',
  LOAN_APPLICATION_APPROVED: 'LOAN_APPLICATION_APPROVED',
  LOAN_APPLICATION_DECLINED: 'LOAN_APPLICATION_DECLINED',
  LOAN_APPLICATION_MANUAL_REVIEW: 'LOAN_APPLICATION_MANUAL_REVIEW',
  LOAN_OFFER_ACCEPTED: 'LOAN_OFFER_ACCEPTED',
  LOAN_OFFER_DECLINED: 'LOAN_OFFER_DECLINED',
  LOAN_DISBURSED: 'LOAN_DISBURSED',
  LOAN_REPAYMENT_INITIATED: 'LOAN_REPAYMENT_INITIATED',
  LOAN_REPAYMENT_COMPLETED: 'LOAN_REPAYMENT_COMPLETED',
  LOAN_REPAYMENT_FAILED: 'LOAN_REPAYMENT_FAILED',
  LOAN_OVERDUE: 'LOAN_OVERDUE',
  LOAN_SETTLED: 'LOAN_SETTLED',
  LOAN_DEFAULTED: 'LOAN_DEFAULTED',

  // Admin
  ADMIN_LOGIN: 'ADMIN_LOGIN',
  CUSTOMER_SUSPENDED: 'CUSTOMER_SUSPENDED',
  CUSTOMER_REACTIVATED: 'CUSTOMER_REACTIVATED',
  LOAN_MANUALLY_APPROVED: 'LOAN_MANUALLY_APPROVED',
  LOAN_MANUALLY_DECLINED: 'LOAN_MANUALLY_DECLINED',
  CREDIT_RULES_UPDATED: 'CREDIT_RULES_UPDATED',
  REFUND_PROCESSED: 'REFUND_PROCESSED',
} as const;

// Import NotificationType for use in NOTIFICATION_TEMPLATES
import { NotificationType } from '../types';
