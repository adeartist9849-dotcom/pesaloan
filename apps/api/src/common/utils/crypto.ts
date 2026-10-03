import bcrypt from 'bcryptjs';
import crypto from 'crypto';
import { config } from '../../config/index.js';

const SALT_ROUNDS = 12;

export async function hashPin(pin: string): Promise<string> {
  return bcrypt.hash(pin, SALT_ROUNDS);
}

export async function verifyPin(pin: string, hash: string): Promise<boolean> {
  return bcrypt.compare(pin, hash);
}

export function generateToken(payload: object): string {
  // In production, use proper JWT library
  // This is a simplified version for the scaffold
  const header = Buffer.from(JSON.stringify({ alg: 'HS256', typ: 'JWT' })).toString('base64url');
  const body = Buffer.from(JSON.stringify({ ...payload, iat: Math.floor(Date.now() / 1000), exp: Math.floor(Date.now() / 1000) + 15 * 60 })).toString('base64url');
  const signature = crypto.createHmac('sha256', config.jwtSecret).update(`${header}.${body}`).digest('base64url');
  return `${header}.${body}.${signature}`;
}

export function generateRefreshToken(): string {
  return crypto.randomBytes(64).toString('hex');
}

export async function hashToken(token: string): Promise<string> {
  return crypto.createHash('sha256').update(token).digest('hex');
}

export function generateId(): string {
  return crypto.randomUUID();
}

export function generateReference(prefix: string): string {
  const timestamp = Date.now().toString(36).toUpperCase();
  const random = crypto.randomBytes(4).toString('hex').toUpperCase();
  return `${prefix}${timestamp}${random}`;
}