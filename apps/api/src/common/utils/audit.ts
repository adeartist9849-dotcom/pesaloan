import { prisma } from '../../database/client.js';
import { AuditAction } from '@prisma/client';

export interface AuditLogInput {
  userId?: string;
  adminId?: string;
  action: AuditAction | string;
  entityType: string;
  entityId: string;
  oldValues?: Record<string, unknown>;
  newValues?: Record<string, unknown>;
  ipAddress?: string;
  userAgent?: string;
  metadata?: Record<string, unknown>;
}

export async function createAuditLog(input: AuditLogInput): Promise<void> {
  try {
    await prisma.auditLog.create({
      data: {
        userId: input.userId,
        adminId: input.adminId,
        action: input.action as AuditAction,
        entityType: input.entityType,
        entityId: input.entityId,
        oldValues: input.oldValues as any,
        newValues: input.newValues as any,
        ipAddress: input.ipAddress,
        userAgent: input.userAgent,
        metadata: (input.metadata || {}) as any,
      },
    });
  } catch (error) {
    // Don't throw - audit logging should never break the main flow
    console.error('Failed to create audit log:', error);
  }
}
