import { PrismaClient, UserStatus, KycStatus, LoanStatus, CreditRules } from '@prisma/client';
import { hashPin } from '../src/common/utils/crypto.js';

const prisma = new PrismaClient();

async function main() {
  console.log('Starting database seed...');

  // Create default credit rules
  const creditRules = await prisma.creditRules.upsert({
    where: { id: 'default' },
    update: {},
    create: {
      id: 'default',
      minLoanAmount: 500,
      maxLoanAmount: 50000,
      minTermDays: 7,
      maxTermDays: 90,
      interestRate: 15.0,
      processingFeeRate: 5.0,
      lateFeeRate: 1.0,
      maxLoanToLimitRatio: 1.0,
      minCreditScore: 300,
      maxActiveLoans: 1,
    },
  });
  console.log('Credit rules created:', creditRules.id);

  // Create default registration fee (KES 100)
  const registrationFee = await prisma.registrationFee.upsert({
    where: { id: 'default' },
    update: {},
    create: {
      id: 'default',
      amount: 10000, // 100.00 KES in cents
      currency: 'KES',
      isActive: true,
      description: 'One-time account registration fee',
      destinationType: 'MPESA_TILL',
      destinationAccount: process.env.MPESA_TILL_NUMBER || '1234567', // Default till number
      destinationName: 'PesaLoan Main Till',
    },
  });
  console.log('Registration fee created:', registrationFee.id, `(${registrationFee.amount / 100} ${registrationFee.currency})`);

  // Create admin user
  const adminPasswordHash = await hashPin('admin123');
  const admin = await prisma.adminUser.upsert({
    where: { email: 'admin@PesaLoan.co.ke' },
    update: {},
    create: {
      email: 'admin@PesaLoan.co.ke',
      passwordHash: adminPasswordHash,
      fullName: 'System Administrator',
      role: 'SUPER_ADMIN',
      permissions: [
        'customers:read',
        'customers:write',
        'customers:delete',
        'loans:read',
        'loans:write',
        'loans:approve',
        'loans:decline',
        'payments:read',
        'payments:write',
        'payments:reconcile',
        'credit:read',
        'credit:write',
        'operations:read',
        'operations:write',
        'reports:read',
        'audit:read',
        'admin:manage',
      ],
    },
  });
  console.log('Admin user created:', admin.email);

  // Create test users (only in development)
  if (process.env.NODE_ENV !== 'production') {
    const testUsers = [
      {
        phoneNumber: '254712345678',
        fullName: 'John Kamau',
        dateOfBirth: new Date('1990-05-15'),
        nationalId: '12345678',
        email: 'john.kamau@example.com',
        pin: '1234',
        loanLimit: 50000,
        kycStatus: KycStatus.VERIFIED,
      },
      {
        phoneNumber: '254723456789',
        fullName: 'Mary Wanjiku',
        dateOfBirth: new Date('1985-08-22'),
        nationalId: '23456789',
        email: 'mary.wanjiku@example.com',
        pin: '1234',
        loanLimit: 30000,
        kycStatus: KycStatus.VERIFIED,
      },
      {
        phoneNumber: '254734567890',
        fullName: 'Peter Ochieng',
        dateOfBirth: new Date('1995-12-10'),
        nationalId: '34567890',
        email: 'peter.ochieng@example.com',
        pin: '1234',
        loanLimit: 0,
        kycStatus: KycStatus.PENDING_REVIEW,
      },
    ];

    for (const userData of testUsers) {
      const pinHash = await hashPin(userData.pin);
      const user = await prisma.user.upsert({
        where: { phoneNumber: userData.phoneNumber },
        update: {},
        create: {
          ...userData,
          pinHash,
          status: UserStatus.ACTIVE,
          registrationFeePaid: true, // Test users already paid
        },
      });
      console.log(`Test user created: ${user.phoneNumber}`);

      // Create KYC record for verified users
      if (userData.kycStatus === KycStatus.VERIFIED) {
        await prisma.kycRecord.upsert({
          where: { userId: user.id },
          update: {},
          create: {
            userId: user.id,
            status: KycStatus.VERIFIED,
            provider: 'mock',
            providerReference: `KYC-${user.id}`,
            verificationData: { nationalId: userData.nationalId },
            verifiedAt: new Date(),
          },
        });
      }
    }

    // Create sample loans
    const users = await prisma.user.findMany({
      where: { phoneNumber: { in: testUsers.map(u => u.phoneNumber) } },
    });

    const john = users.find(u => u.phoneNumber === '254712345678');
    const mary = users.find(u => u.phoneNumber === '254723456789');

    if (john) {
      // Active loan for John
      const loan1 = await prisma.loan.create({
        data: {
          userId: john.id,
          principal: 15000,
          interest: 1849,
          fees: 750,
          totalPayable: 17599,
          termDays: 30,
          disbursedAmount: 15000,
          outstandingBalance: 17599,
          status: LoanStatus.ACTIVE,
          dueDate: new Date(Date.now() + 10 * 24 * 60 * 60 * 1000),
          agreementVersion: '1.0',
          agreementAcceptedAt: new Date(),
          disbursedAt: new Date(),
        },
      });

      await prisma.transaction.create({
        data: {
          loanId: loan1.id,
          userId: john.id,
          type: 'DISBURSEMENT',
          amount: 15000,
          status: 'COMPLETED',
          reference: 'MPESA-20241201-001',
          provider: 'MPESA',
          providerReference: 'OEI2345678',
          description: 'Loan disbursement to M-Pesa',
          metadata: {},
          processedAt: new Date(),
        },
      });
    }

    if (mary) {
      // Paid loan for Mary
      const loan2 = await prisma.loan.create({
        data: {
          userId: mary.id,
          principal: 10000,
          interest: 1233,
          fees: 500,
          totalPayable: 11733,
          termDays: 30,
          disbursedAmount: 10000,
          outstandingBalance: 0,
          status: LoanStatus.PAID,
          dueDate: new Date('2024-11-30'),
          agreementVersion: '1.0',
          agreementAcceptedAt: new Date('2024-10-31'),
          disbursedAt: new Date('2024-10-31'),
          paidAt: new Date('2024-11-28'),
        },
      });

      await prisma.transaction.create({
        data: {
          loanId: loan2.id,
          userId: mary.id,
          type: 'DISBURSEMENT',
          amount: 10000,
          status: 'COMPLETED',
          reference: 'MPESA-20241031-001',
          provider: 'MPESA',
          providerReference: 'OEI2345679',
          description: 'Loan disbursement to M-Pesa',
          metadata: {},
          processedAt: new Date('2024-10-31'),
        },
      });

      await prisma.repayment.create({
        data: {
          loanId: loan2.id,
          userId: mary.id,
          amount: 11733,
          transactionReference: 'REPAY-20241128-001',
          provider: 'MPESA',
          providerTransactionId: 'OEI2345680',
          status: 'COMPLETED',
          paidAt: new Date('2024-11-28'),
          metadata: {},
        },
      });

      await prisma.transaction.create({
        data: {
          loanId: loan2.id,
          userId: mary.id,
          type: 'REPAYMENT',
          amount: 11733,
          status: 'COMPLETED',
          reference: 'REPAY-20241128-001',
          provider: 'MPESA',
          providerReference: 'OEI2345680',
          description: 'Loan repayment from M-Pesa',
          metadata: {},
          processedAt: new Date('2024-11-28'),
        },
      });
    }
  }

  console.log('Database seed completed!');
}

main()
  .catch((e) => {
    console.error('Seed failed:', e);
    process.exit(1);
  })
  .finally(async () => {
    await prisma.$disconnect();
  });