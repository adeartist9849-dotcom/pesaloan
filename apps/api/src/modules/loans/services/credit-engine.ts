import { prisma } from '../../../database/client.js';
import { CreditRules } from '@prisma/client';

export interface CreditScoreInput {
  userId: string;
  requestedAmount: number;
  requestedTermDays: number;
  kycStatus: string;
  hasActiveLoan: boolean;
  previousLoansCount: number;
  repaidOnTimeCount: number;
  defaultedCount: number;
  daysSinceLastLoan: number;
}

export interface CreditDecision {
  approved: boolean;
  score: number;
  loanLimit: number;
  reason?: string;
  maxAmount?: number;
  recommendedTerm?: number;
}

export class CreditEngine {
  private rules: CreditRules | null = null;
  
  async getRules(): Promise<CreditRules> {
    if (this.rules) return this.rules;
    
    this.rules = await prisma.creditRules.findFirst();
    
    if (!this.rules) {
      // Create default rules
      this.rules = await prisma.creditRules.create({
        data: {
          minLoanAmount: 500,
          maxLoanAmount: 50000,
          minTermDays: 7,
          maxTermDays: 90,
          interestRate: 15.0,
          processingFeeRate: 5.0,
          lateFeeRate: 1.0,
          maxLoanToLimitRatio: 1.0,
          minCreditScore: 0,
          maxActiveLoans: 1,
        },
      });
    }
    
    return this.rules!;
  }
  
  async evaluate(input: CreditScoreInput): Promise<CreditDecision> {
    const rules = await this.getRules();
    
    // Hard rules (automatic decline)
    if (input.kycStatus !== 'VERIFIED') {
      return { approved: false, score: 0, loanLimit: 0, reason: 'KYC not verified' };
    }

    if (input.hasActiveLoan) {
      return { approved: false, score: 0, loanLimit: 0, reason: 'Has active loan' };
    }

    if (input.defaultedCount > 0) {
      return { approved: false, score: 0, loanLimit: 0, reason: 'Previous default' };
    }

    if (input.requestedAmount < rules.minLoanAmount || input.requestedAmount > rules.maxLoanAmount) {
      return { approved: false, score: 0, loanLimit: 0, reason: `Amount must be between ${rules.minLoanAmount} and ${rules.maxLoanAmount}` };
    }

    if (input.requestedTermDays < rules.minTermDays || input.requestedTermDays > rules.maxTermDays) {
      return { approved: false, score: 0, loanLimit: 0, reason: `Term must be between ${rules.minTermDays} and ${rules.maxTermDays} days` };
    }

    // Calculate score (0-1000)
    let score = 500; // Base score

    // Repayment history (+50 per repaid loan, max +300)
    score += Math.min(input.repaidOnTimeCount * 50, 300);

    // Relationship length (+20 per previous loan, max +100)
    score += Math.min(input.previousLoansCount * 20, 100);

    // Recent activity penalty
    if (input.daysSinceLastLoan < 7 && input.previousLoansCount > 0) {
      score -= 50;
    }

    score = Math.max(0, Math.min(1000, score));

    if (score < rules.minCreditScore) {
      return { approved: false, score, loanLimit: 0, reason: 'Credit score below threshold' };
    }

    // Calculate loan limit based on score
    const baseLimit = rules.minLoanAmount;
    const maxLimit = rules.maxLoanAmount;
    const loanLimit = Math.round(baseLimit + (score / 1000) * (maxLimit - baseLimit));

    const approved = input.requestedAmount <= loanLimit * rules.maxLoanToLimitRatio;

    return {
      approved,
      score,
      loanLimit,
      maxAmount: Math.min(loanLimit, rules.maxLoanAmount),
      recommendedTerm: input.requestedTermDays,
      reason: approved ? undefined : 'Requested amount exceeds calculated credit limit',
    };
  }

  async calculateLoanPricing(amount: number, termDays: number) {
    const rules = await this.getRules();
    const interest = Math.round(amount * (rules.interestRate / 100));
    const fees = Math.round(amount * (rules.processingFeeRate / 100));
    const totalPayable = amount + interest + fees;
    return { interest, fees, totalPayable };
  }
}

export const creditEngine = new CreditEngine();
