import { prisma } from '../../../database/client.js';
import { config } from '../../../config/index.js';
import { NotificationType, NotificationChannel } from '@prisma/client';

interface SendNotificationInput {
  userId: string;
  type: NotificationType;
  channel: NotificationChannel;
  title: string;
  body: string;
  data?: Record<string, unknown>;
}

export async function sendNotification(input: SendNotificationInput): Promise<void> {
  const notification = await prisma.notification.create({
    data: {
      userId: input.userId,
      type: input.type,
      channel: input.channel,
      title: input.title,
      body: input.body,
      data: (input.data || {}) as any,
    },
  });
  
  // Send based on channel
  switch (input.channel) {
    case 'SMS':
      await sendSms(input.userId, input.body);
      break;
    case 'PUSH':
      await sendPush(input.userId, input.title, input.body, input.data);
      break;
    case 'EMAIL':
      await sendEmail(input.userId, input.title, input.body);
      break;
    case 'IN_APP':
      // Already stored in DB
      break;
  }
  
  await prisma.notification.update({
    where: { id: notification.id },
    data: { sentAt: new Date() },
  });
}

async function sendSms(userId: string, body: string): Promise<void> {
  // TODO: Implement SMS provider integration
  console.log(`[SMS] To user ${userId}: ${body}`);
  
  // Example with Africa's Talking or similar:
  // await fetch('https://api.africastalking.com/version1/messaging', {
  //   method: 'POST',
  //   headers: { 'apiKey': config.sms.apiKey, 'Content-Type': 'application/x-www-form-urlencoded' },
  //   body: new URLSearchParams({ username: config.sms.senderId, to: phoneNumber, message: body })
  // });
}

async function sendPush(userId: string, title: string, body: string, data?: Record<string, unknown>): Promise<void> {
  // TODO: Implement push notification (Firebase/OneSignal)
  console.log(`[PUSH] To user ${userId}: ${title} - ${body}`);
}

async function sendEmail(userId: string, title: string, body: string): Promise<void> {
  // TODO: Implement email (SendGrid, etc.)
  console.log(`[EMAIL] To user ${userId}: ${title} - ${body}`);
}

export async function sendOtp(phoneNumber: string, code: string, purpose: string): Promise<void> {
  const message = `Your PesaLoan verification code is ${code}. Valid for 5 minutes. Do not share.`;
  
  if (config.sms.provider === 'mock' || !config.sms.apiKey) {
    console.log(`[MOCK SMS] To ${phoneNumber}: ${message}`);
    return;
  }
  
  // TODO: Implement actual SMS sending
  console.log(`[SMS] To ${phoneNumber}: ${message}`);
}

export async function sendLoanNotification(
  userId: string,
  type: NotificationType,
  data: Record<string, unknown>
): Promise<void> {
  const templates: Record<string, { title: string; body: string }> = {
    [NotificationType.APPLICATION_APPROVED]: {
      title: 'Loan Approved!',
      body: `Your loan of KES ${data.amount} has been approved. Tap to accept.`,
    },
    [NotificationType.APPLICATION_DECLINED]: {
      title: 'Loan Application Update',
      body: 'Your loan application was not approved at this time.',
    },
    [NotificationType.LOAN_DISBURSED]: {
      title: 'Funds Sent!',
      body: `KES ${data.amount} has been sent to your M-Pesa. Ref: ${data.reference}`,
    },
    [NotificationType.PAYMENT_RECEIVED]: {
      title: 'Payment Received',
      body: `KES ${data.amount} received. Outstanding: KES ${data.balance}. Ref: ${data.reference}`,
    },
    [NotificationType.UPCOMING_REPAYMENT]: {
      title: 'Repayment Due Soon',
      body: `Your loan repayment of KES ${data.amount} is due in ${data.days} days.`,
    },
    [NotificationType.LOAN_OVERDUE]: {
      title: 'Loan Overdue',
      body: `Your repayment of KES ${data.amount} was due on ${data.dueDate}. Pay now.`,
    },
    [NotificationType.LOAN_FULLY_REPAID]: {
      title: 'Loan Cleared!',
      body: 'Congratulations! Your loan has been fully repaid.',
    },
    [NotificationType.KYC_VERIFIED]: {
      title: 'KYC Verified',
      body: 'Your identity has been verified. You can now apply for loans.',
    },
    [NotificationType.KYC_REJECTED]: {
      title: 'KYC Rejected',
      body: 'Your KYC submission was rejected. Please try again with valid documents.',
    },
    [NotificationType.GENERAL]: {
      title: 'PesaLoan',
      body: 'You have a new notification.',
    },
  };
  
  const template = templates[type] || templates[NotificationType.GENERAL];
  
  // Send push notification
  await sendNotification({
    userId,
    type,
    channel: 'PUSH',
    title: template.title,
    body: template.body,
    data,
  });
  
  // Send SMS for critical notifications
  const criticalTypes: NotificationType[] = [
    NotificationType.LOAN_DISBURSED,
    NotificationType.PAYMENT_RECEIVED,
    NotificationType.LOAN_OVERDUE,
    NotificationType.LOAN_FULLY_REPAID,
  ];
  
  if (criticalTypes.includes(type)) {
    await sendNotification({
      userId,
      type,
      channel: 'SMS',
      title: template.title,
      body: template.body,
      data,
    });
  }
}
