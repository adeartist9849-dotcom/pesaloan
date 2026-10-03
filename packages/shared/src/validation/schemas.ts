import { z } from 'zod';
import {
  phoneNumberSchema,
  nationalIdSchema,
  pinSchema,
  amountSchema,
  termDaysSchema,
} from '../types';

export const registerSchema = z.object({
  phoneNumber: phoneNumberSchema,
  fullName: z.string().min(2).max(100).regex(/^[a-zA-Z\s'-]+$/, 'Invalid name format'),
  dateOfBirth: z.string().refine((date) => {
    const dob = new Date(date);
    const today = new Date();
    const age = today.getFullYear() - dob.getFullYear();
    const monthDiff = today.getMonth() - dob.getMonth();
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < dob.getDate())) {
      return age - 1 >= 18;
    }
    return age >= 18;
  }, 'Must be at least 18 years old'),
  nationalId: nationalIdSchema,
  email: z.string().email().optional().nullable(),
  pin: pinSchema,
  consentGiven: z.literal(true, { errorMap: () => ({ message: 'Consent is required' }) }),
  consentVersion: z.string().min(1),
});

export const loginSchema = z.object({
  phoneNumber: phoneNumberSchema,
  pin: pinSchema,
});

export const otpRequestSchema = z.object({
  phoneNumber: phoneNumberSchema,
});

export const otpVerifySchema = z.object({
  phoneNumber: phoneNumberSchema,
  code: z.string().regex(/^\d{6}$/, 'OTP must be 6 digits'),
});

export const kycSubmitSchema = z.object({
  nationalId: nationalIdSchema,
  idFrontImage: z.string().optional(),
  idBackImage: z.string().optional(),
  selfieImage: z.string().optional(),
});

export const loanApplicationSchema = z.object({
  amount: amountSchema,
  termDays: termDaysSchema,
});

export const loanAcceptSchema = z.object({
  loanId: z.string().uuid('Invalid loan ID'),
  agreementVersion: z.string().min(1),
});

export const repaymentSchema = z.object({
  loanId: z.string().uuid('Invalid loan ID'),
  amount: amountSchema,
});

export const changePinSchema = z.object({
  currentPin: pinSchema,
  newPin: pinSchema,
}).refine((data) => data.currentPin !== data.newPin, {
  message: 'New PIN must be different from current PIN',
  path: ['newPin'],
});

export const adminLoginSchema = z.object({
  email: z.string().email(),
  password: z.string().min(8).max(128),
});

export const creditRulesSchema = z.object({
  minLoanAmount: z.number().positive(),
  maxLoanAmount: z.number().positive(),
  minTermDays: z.number().int().positive(),
  maxTermDays: z.number().int().positive(),
  interestRate: z.number().min(0).max(100),
  processingFeeRate: z.number().min(0).max(100),
  lateFeeRate: z.number().min(0).max(100),
  maxLoanToLimitRatio: z.number().min(0).max(1),
  minCreditScore: z.number().int().min(0).max(1000),
  maxActiveLoans: z.number().int().positive(),
});

// Type inference helpers
export type RegisterInput = z.infer<typeof registerSchema>;
export type LoginInput = z.infer<typeof loginSchema>;
export type OtpRequestInput = z.infer<typeof otpRequestSchema>;
export type OtpVerifyInput = z.infer<typeof otpVerifySchema>;
export type KycSubmitInput = z.infer<typeof kycSubmitSchema>;
export type LoanApplicationInput = z.infer<typeof loanApplicationSchema>;
export type LoanAcceptInput = z.infer<typeof loanAcceptSchema>;
export type RepaymentInput = z.infer<typeof repaymentSchema>;
export type ChangePinInput = z.infer<typeof changePinSchema>;
export type AdminLoginInput = z.infer<typeof adminLoginSchema>;
export type CreditRulesInput = z.infer<typeof creditRulesSchema>;