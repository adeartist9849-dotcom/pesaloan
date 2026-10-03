import { z } from 'zod';

// ============================================
// Enums & Constants
// ============================================

export enum UserStatus {
  PENDING = 'PENDING',
  ACTIVE = 'ACTIVE',
  SUSPENDED = 'SUSPENDED',
  CLOSED = 'CLOSED',
  BLOCKED = 'BLOCKED',
}

export enum KycStatus {
  NOT_STARTED = 'NOT_STARTED',
  IN_PROGRESS = 'IN_PROGRESS',
  PENDING_REVIEW = 'PENDING_REVIEW',
  VERIFIED = 'VERIFIED',
  REJECTED = 'REJECTED',
  EXPIRED = 'EXPIRED',
}

export enum LoanApplicationStatus {
  DRAFT = 'DRAFT',
  SUBMITTED = 'SUBMITTED',
  UNDER_REVIEW = 'UNDER_REVIEW',
  APPROVED = 'APPROVED',
  DECLINED = 'DECLINED',
  CANCELLED = 'CANCELLED',
  EXPIRED = 'EXPIRED',
}

export enum LoanStatus {
  APPLICATION = 'APPLICATION',
  PENDING = 'PENDING',
  APPROVED = 'APPROVED',
  ACCEPTED = 'ACCEPTED',
  DISBURSEMENT_PENDING = 'DISBURSEMENT_PENDING',
  ACTIVE = 'ACTIVE',
  PAID = 'PAID',
  OVERDUE = 'OVERDUE',
  RESOLVED = 'RESOLVED',
  DEFAULTED = 'DEFAULTED',
  WRITTEN_OFF = 'WRITTEN_OFF',
}

export enum RepaymentStatus {
  PENDING = 'PENDING',
  PROCESSING = 'PROCESSING',
  COMPLETED = 'COMPLETED',
  FAILED = 'FAILED',
  REFUNDED = 'REFUNDED',
}

export enum TransactionType {
  DISBURSEMENT = 'DISBURSEMENT',
  REPAYMENT = 'REPAYMENT',
  FEE = 'FEE',
  PENALTY = 'PENALTY',
  REFUND = 'REFUND',
  ADJUSTMENT = 'ADJUSTMENT',
}

export enum TransactionStatus {
  PENDING = 'PENDING',
  PROCESSING = 'PROCESSING',
  COMPLETED = 'COMPLETED',
  FAILED = 'FAILED',
  REVERSED = 'REVERSED',
}

export enum NotificationType {
  OTP = 'OTP',
  APPLICATION_SUBMITTED = 'APPLICATION_SUBMITTED',
  APPLICATION_APPROVED = 'APPLICATION_APPROVED',
  APPLICATION_DECLINED = 'APPLICATION_DECLINED',
  LOAN_DISBURSED = 'LOAN_DISBURSED',
  PAYMENT_RECEIVED = 'PAYMENT_RECEIVED',
  UPCOMING_REPAYMENT = 'UPCOMING_REPAYMENT',
  LOAN_OVERDUE = 'LOAN_OVERDUE',
  LOAN_FULLY_REPAID = 'LOAN_FULLY_REPAID',
  KYC_VERIFIED = 'KYC_VERIFIED',
  KYC_REJECTED = 'KYC_REJECTED',
  ACCOUNT_SUSPENDED = 'ACCOUNT_SUSPENDED',
  GENERAL = 'GENERAL',
}

export enum NotificationChannel {
  PUSH = 'PUSH',
  SMS = 'SMS',
  EMAIL = 'EMAIL',
  IN_APP = 'IN_APP',
}

export enum MobileMoneyProvider {
  MPESA = 'MPESA',
  AIRTEL_MONEY = 'AIRTEL_MONEY',
}

export enum MobileMoneyTransactionType {
  STK_PUSH = 'STK_PUSH',
  B2C = 'B2C',
  C2B = 'C2B',
  B2B = 'B2B',
}

// ============================================
// Zod Schemas (for validation)
// ============================================

export const phoneNumberSchema = z.string().regex(/^254[17]\d{8}$/, 'Invalid Kenyan phone number format (254XXXXXXXXX)');

export const nationalIdSchema = z.string().regex(/^\d{8}$/, 'National ID must be 8 digits');

export const pinSchema = z.string().regex(/^\d{4,6}$/, 'PIN must be 4-6 digits');

export const amountSchema = z.number().positive('Amount must be positive').max(1000000, 'Amount exceeds maximum limit');

export const termDaysSchema = z.number().int().min(1).max(365);

// ============================================
// Core Entity Types
// ============================================

export interface BaseEntity {
  id: string;
  createdAt: Date;
  updatedAt: Date;
}

export interface User extends BaseEntity {
  phoneNumber: string;
  fullName: string;
  dateOfBirth: Date;
  nationalId: string;
  email?: string;
  pinHash: string;
  status: UserStatus;
  kycStatus: KycStatus;
  loanLimit: number;
  registrationFeePaid: boolean;
  registrationFeePaidAt?: Date;
  lastLoginAt?: Date;
  failedLoginAttempts: number;
  lockedUntil?: Date;
}

export interface KycRecord extends BaseEntity {
  userId: string;
  status: KycStatus;
  provider: string;
  providerReference: string;
  verificationData: Record<string, unknown>;
  verifiedAt?: Date;
  rejectedAt?: Date;
  rejectionReason?: string;
  expiresAt?: Date;
}

export interface LoanApplication extends BaseEntity {
  userId: string;
  requestedAmount: number;
  requestedTermDays: number;
  status: LoanApplicationStatus;
  score?: number;
  decisionReason?: string;
  reviewedBy?: string;
  reviewedAt?: Date;
  expiresAt: Date;
}

export interface Loan extends BaseEntity {
  userId: string;
  applicationId: string;
  principal: number;
  interest: number;
  fees: number;
  totalPayable: number;
  termDays: number;
  disbursedAmount: number;
  outstandingBalance: number;
  status: LoanStatus;
  disbursedAt?: Date;
  dueDate: Date;
  paidAt?: Date;
  agreementVersion: string;
  agreementAcceptedAt?: Date;
}

export interface Repayment extends BaseEntity {
  loanId: string;
  userId: string;
  amount: number;
  transactionReference: string;
  provider: MobileMoneyProvider;
  providerTransactionId?: string;
  status: RepaymentStatus;
  paidAt?: Date;
  failedReason?: string;
  metadata: Record<string, unknown>;
}

export interface Transaction extends BaseEntity {
  loanId?: string;
  userId: string;
  type: TransactionType;
  amount: number;
  status: TransactionStatus;
  reference: string;
  provider?: MobileMoneyProvider;
  providerReference?: string;
  description: string;
  metadata: Record<string, unknown>;
  processedAt?: Date;
}

export interface Notification extends BaseEntity {
  userId: string;
  type: NotificationType;
  channel: NotificationChannel;
  title: string;
  body: string;
  data: Record<string, unknown>;
  sentAt?: Date;
  readAt?: Date;
  failedReason?: string;
  retryCount: number;
}

export interface AuditLog extends BaseEntity {
  userId?: string;
  adminId?: string;
  action: string;
  entityType: string;
  entityId: string;
  oldValues?: Record<string, unknown>;
  newValues?: Record<string, unknown>;
  ipAddress?: string;
  userAgent?: string;
  metadata: Record<string, unknown>;
}

// ============================================
// API Request/Response Types
// ============================================

export interface AuthTokens {
  accessToken: string;
  refreshToken: string;
  expiresIn: number;
}

export interface RegisterRequest {
  phoneNumber: string;
  fullName: string;
  dateOfBirth: string; // ISO date
  nationalId: string;
  email?: string;
  pin: string;
  consentGiven: boolean;
  consentVersion: string;
}

export interface LoginRequest {
  phoneNumber: string;
  pin: string;
}

export interface OtpRequest {
  phoneNumber: string;
}

export interface OtpVerifyRequest {
  phoneNumber: string;
  code: string;
}

export interface KycSubmitRequest {
  nationalId: string;
  idFrontImage?: string; // base64
  idBackImage?: string; // base64
  selfieImage?: string; // base64
}

export interface LoanApplicationRequest {
  amount: number;
  termDays: number;
}

export interface LoanOfferResponse {
  loanId: string;
  amount: number;
  termDays: number;
  interest: number;
  fees: number;
  totalPayable: number;
  dueDate: string; // ISO date
  agreementVersion: string;
  agreementUrl: string;
  expiresAt: string; // ISO date
}

export interface LoanAcceptRequest {
  loanId: string;
  agreementVersion: string;
}

export interface RepaymentRequest {
  loanId: string;
  amount: number;
}

export interface RepaymentInitiateResponse {
  transactionId: string;
  status: RepaymentStatus;
  message: string;
}

export interface DashboardResponse {
  user: {
    id: string;
    fullName: string;
    loanLimit: number;
    kycStatus: KycStatus;
  };
  availableLimit: number;
  currentLoan?: {
    id: string;
    outstandingBalance: number;
    dueDate: string;
    status: LoanStatus;
  };
  recentLoans: Array<{
    id: string;
    amount: number;
    status: LoanStatus;
    dueDate: string;
  }>;
}

export interface LoanHistoryItem {
  id: string;
  amount: number;
  status: LoanStatus;
  dueDate: string;
  disbursedAt?: string;
  paidAt?: string;
}

export interface LoanDetail extends Loan {
  application: LoanApplication;
  repayments: Repayment[];
  transactions: Transaction[];
}

// ============================================
// Registration Fee Types
// ============================================

export enum PaymentDestinationType {
  MPESA_TILL = 'MPESA_TILL',
  MPESA_PAYBILL = 'MPESA_PAYBILL',
  BANK_ACCOUNT = 'BANK_ACCOUNT',
  MOBILE_MONEY = 'MOBILE_MONEY',
}

export interface RegistrationFee {
  id: string;
  amount: number; // in cents
  currency: string;
  isActive: boolean;
  description?: string;
  destinationType: PaymentDestinationType;
  destinationAccount: string; // Till number, Paybill number, or bank account number
  destinationName?: string; // e.g., "PesaLoan Main Till", "KCB Bank Account"
  destinationBranch?: string; // Bank branch code (for bank accounts)
  destinationReference?: string; // Account name or reference for bank transfers
  createdAt: Date;
  updatedAt: Date;
}

export interface RegistrationFeePayment extends BaseEntity {
  userId: string;
  amount: number;
  currency: string;
  status: TransactionStatus;
  provider?: MobileMoneyProvider;
  providerReference?: string;
  reference: string;
  description: string;
  metadata: Record<string, unknown>;
  processedAt?: Date;
}

export interface RegistrationFeeConfig {
  amount: number;
  currency: string;
  isActive: boolean;
  description?: string;
  destinationType: PaymentDestinationType;
  destinationAccount: string;
  destinationName?: string;
  destinationBranch?: string;
  destinationReference?: string;
}

// ============================================
// Admin Types
// ============================================

export interface AdminUser {
  id: string;
  email: string;
  fullName: string;
  role: AdminRole;
  permissions: string[];
  lastLoginAt?: Date;
  createdAt: Date;
  updatedAt: Date;
}

export enum AdminRole {
  SUPER_ADMIN = 'SUPER_ADMIN',
  CREDIT_MANAGER = 'CREDIT_MANAGER',
  OPERATIONS = 'OPERATIONS',
  SUPPORT = 'SUPPORT',
  VIEWER = 'VIEWER',
}

export interface CustomerListItem {
  id: string;
  phoneNumber: string;
  fullName: string;
  kycStatus: KycStatus;
  accountStatus: UserStatus;
  loanLimit: number;
  currentLoanStatus?: LoanStatus;
  createdAt: Date;
  lastActiveAt?: Date;
}

export interface LoanListItem {
  id: string;
  customerId: string;
  customerName: string;
  customerPhone: string;
  principal: number;
  outstandingBalance: number;
  status: LoanStatus;
  dueDate: Date;
  createdAt: Date;
}

export interface CreditRulesConfig {
  minLoanAmount: number;
  maxLoanAmount: number;
  minTermDays: number;
  maxTermDays: number;
  interestRate: number; // percentage
  processingFeeRate: number; // percentage
  lateFeeRate: number; // percentage per day
  maxLoanToLimitRatio: number; // 0-1
  minCreditScore: number;
  maxActiveLoans: number;
}

export interface PaginatedResponse<T> {
  data: T[];
  total: number;
  page: number;
  limit: number;
  totalPages: number;
}

// ============================================
// Mobile Money Types
// ============================================

export interface MpesaStkPushRequest {
  phoneNumber: string;
  amount: number;
  accountReference: string;
  transactionDesc: string;
  callbackUrl: string;
}

export interface MpesaStkPushResponse {
  merchantRequestId: string;
  checkoutRequestId: string;
  responseCode: string;
  responseDescription: string;
  customerMessage: string;
}

export interface MpesaCallbackData {
  merchantRequestId: string;
  checkoutRequestId: string;
  resultCode: number;
  resultDesc: string;
  callbackMetadata?: {
    item: Array<{
      name: string;
      value: string | number;
    }>;
  };
}

export interface MobileMoneyDisbursementRequest {
  phoneNumber: string;
  amount: number;
  reference: string;
  description: string;
}

export interface MobileMoneyDisbursementResponse {
  transactionId: string;
  status: TransactionStatus;
  providerReference: string;
}

// ============================================
// Error Types
// ============================================

export class AppError extends Error {
  constructor(
    message: string,
    public readonly code: string,
    public readonly statusCode: number = 400,
    public readonly details?: Record<string, unknown>
  ) {
    super(message);
    this.name = 'AppError';
  }
}

export class ValidationError extends AppError {
  constructor(message: string, details?: Record<string, unknown>) {
    super(message, 'VALIDATION_ERROR', 400, details);
    this.name = 'ValidationError';
  }
}

export class AuthenticationError extends AppError {
  constructor(message: string = 'Authentication required') {
    super(message, 'AUTHENTICATION_ERROR', 401);
    this.name = 'AuthenticationError';
  }
}

export class AuthorizationError extends AppError {
  constructor(message: string = 'Insufficient permissions') {
    super(message, 'AUTHORIZATION_ERROR', 403);
    this.name = 'AuthorizationError';
  }
}

export class NotFoundError extends AppError {
  constructor(resource: string) {
    super(`${resource} not found`, 'NOT_FOUND', 404);
    this.name = 'NotFoundError';
  }
}

export class ConflictError extends AppError {
  constructor(message: string) {
    super(message, 'CONFLICT', 409);
    this.name = 'ConflictError';
  }
}

export class RateLimitError extends AppError {
  constructor(message: string = 'Too many requests') {
    super(message, 'RATE_LIMIT_EXCEEDED', 429);
    this.name = 'RateLimitError';
  }
}

// ============================================
// Type Guards
// ============================================

export function isAppError(error: unknown): error is AppError {
  return error instanceof AppError;
}

export function isZodError(error: unknown): error is z.ZodError {
  return error instanceof z.ZodError;
}