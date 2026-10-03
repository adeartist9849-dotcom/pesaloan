import { config } from '../src/config/index.js';

// Set test environment variables
process.env.NODE_ENV = 'test';
process.env.JWT_SECRET = 'test-jwt-secret-key-for-testing-only';
process.env.ENCRYPTION_KEY = 'test-encryption-key-32-chars-long!!';
process.env.DATABASE_URL = 'postgresql://postgres:postgres@localhost:5432/pesaloan_test';
process.env.REDIS_URL = 'redis://localhost:6379';
process.env.MPESA_CONSUMER_KEY = 'test';
process.env.MPESA_CONSUMER_SECRET = 'test';
process.env.MPESA_PASSKEY = 'test';
process.env.MPESA_SHORTCODE = 'test';
process.env.KYC_PROVIDER = 'mock';
process.env.SMS_PROVIDER = 'mock';
process.env.PUSH_PROVIDER = 'mock';

// Suppress console logs during tests unless debugging
if (!process.env.DEBUG_TESTS) {
  global.console = {
    ...console,
    log: () => {},
    debug: () => {},
    info: () => {},
    warn: () => {},
    error: () => {},
  };
}
