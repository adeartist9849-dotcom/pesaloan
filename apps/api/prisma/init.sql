-- PesaLoan Database Initialization
-- This runs automatically when PostgreSQL container starts

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create custom types (enum alternatives for better compatibility)
-- Note: Prisma manages enums natively, this is for raw SQL access

-- Performance indexes (Prisma creates most, but these help common queries)
-- These will be created by Prisma migrations, but listed here for reference

-- User indexes
-- CREATE INDEX IF NOT EXISTS idx_user_phone_number ON "User"("phoneNumber");
-- CREATE INDEX IF NOT EXISTS idx_user_national_id ON "User"("nationalId");
-- CREATE INDEX IF NOT EXISTS idx_user_status ON "User"("status");
-- CREATE INDEX IF NOT EXISTS idx_user_kyc_status ON "User"("kycStatus");

-- Loan indexes
-- CREATE INDEX IF NOT EXISTS idx_loan_user_id ON "Loan"("userId");
-- CREATE INDEX IF NOT EXISTS idx_loan_status ON "Loan"("status");
-- CREATE INDEX IF NOT EXISTS idx_loan_due_date ON "Loan"("dueDate");

-- Transaction indexes
-- CREATE INDEX IF NOT EXISTS idx_transaction_user_id ON "Transaction"("userId");
-- CREATE INDEX IF NOT EXISTS idx_transaction_loan_id ON "Transaction"("loanId");
-- CREATE INDEX IF NOT EXISTS idx_transaction_type ON "Transaction"("type");
-- CREATE INDEX IF NOT EXISTS idx_transaction_status ON "Transaction"("status");
-- CREATE INDEX IF NOT EXISTS idx_transaction_created_at ON "Transaction"("createdAt");

-- Repayment indexes
-- CREATE INDEX IF NOT EXISTS idx_repayment_loan_id ON "Repayment"("loanId");
-- CREATE INDEX IF NOT EXISTS idx_repayment_user_id ON "Repayment"("userId");
-- CREATE INDEX IF NOT EXISTS idx_repayment_status ON "Repayment"("status");
-- CREATE INDEX IF NOT EXISTS idx_repayment_provider_txn_id ON "Repayment"("providerTransactionId");

-- Audit log indexes
-- CREATE INDEX IF NOT EXISTS idx_audit_user_id ON "AuditLog"("userId");
-- CREATE INDEX IF NOT EXISTS idx_audit_admin_id ON "AuditLog"("adminId");
-- CREATE INDEX IF NOT EXISTS idx_audit_action ON "AuditLog"("action");
-- CREATE INDEX IF NOT EXISTS idx_audit_entity ON "AuditLog"("entityType", "entityId");
-- CREATE INDEX IF NOT EXISTS idx_audit_created_at ON "AuditLog"("createdAt");

-- Notification indexes
-- CREATE INDEX IF NOT EXISTS idx_notification_user_id ON "Notification"("userId");
-- CREATE INDEX IF NOT EXISTS idx_notification_type ON "Notification"("type");
-- CREATE INDEX IF NOT EXISTS idx_notification_sent_at ON "Notification"("sentAt");

-- OTP indexes
-- CREATE INDEX IF NOT EXISTS idx_otp_phone_purpose ON "OTP"("phoneNumber", "purpose");
-- CREATE INDEX IF NOT EXISTS idx_otp_expires_at ON "OTP"("expiresAt");

-- Refresh token indexes
-- CREATE INDEX IF NOT EXISTS idx_refresh_token_user_id ON "RefreshToken"("userId");
-- CREATE INDEX IF NOT EXISTS idx_refresh_token_expires_at ON "RefreshToken"("expiresAt");

-- Credit rules - ensure single row
-- INSERT INTO "CreditRules" (id) VALUES ('default') ON CONFLICT DO NOTHING;

-- Admin user will be created by seed script

-- Grant permissions (adjust for your setup)
-- GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO postgres;
-- GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO postgres;
