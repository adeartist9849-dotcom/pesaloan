# PesaLoan App - Run Instructions

This document provides step-by-step instructions to run the PesaLoan application with the new registration fee feature.

## Prerequisites

- **Node.js** >= 18.x
- **PostgreSQL** >= 14
- **Flutter** >= 3.16 (for mobile app)
- **Docker** & **Docker Compose** (optional, for containerized setup)
- **M-Pesa Daraja API credentials** (for payment integration)

## Project Structure

```
├── apps/
│   ├── api/          # Backend API (Node.js/Fastify)
│   ├── mobile/       # Mobile App (Flutter)
│   └── admin/        # Admin Panel (Next.js)
├── packages/
│   └── shared/       # Shared types and utilities
└── docker-compose.yml
```

---

## Quick Start (Docker)

The easiest way to run all services:

```bash
# 1. Copy environment file
cp apps/api/.env.example apps/api/.env
cp apps/admin/.env.example apps/admin/.env

# 2. Start all services
docker-compose up -d

# 3. Run database migrations
docker-compose exec api npx prisma migrate deploy

# 4. Seed database (optional)
docker-compose exec api npx prisma db seed

# 5. Access applications
# - API: http://localhost:3000
# - Admin Panel: http://localhost:3001
# - API Health: http://localhost:3000/health
```

---

## Manual Setup

### 1. Backend API Setup

```bash
cd apps/api

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Configure .env with your settings:
# - DATABASE_URL: PostgreSQL connection string
# - JWT_SECRET: Random secret for JWT tokens
# - MPESA_*: M-Pesa Daraja API credentials
# - REDIS_URL: Redis connection (optional)

# Generate Prisma client
npx prisma generate

# Run database migrations
npx prisma migrate deploy

# Seed database with default data (admin user, credit rules, registration fee)
npx prisma db seed

# Start development server
npm run dev
```

The API will be available at `http://localhost:3000/api/v1`

### 2. Admin Panel Setup

```bash
cd apps/admin

# Install dependencies
npm install

# Copy environment file
cp .env.example .env

# Configure .env:
# - NEXT_PUBLIC_API_URL: http://localhost:3000/api/v1
# - NEXTAUTH_SECRET: Random secret for NextAuth
# - NEXTAUTH_URL: http://localhost:3001

# Start development server
npm run dev
```

The Admin Panel will be available at `http://localhost:3001`

### 3. Mobile App Setup

```bash
cd apps/mobile

# Get Flutter dependencies
flutter pub get

# For Android
flutter run -d <device_id>

# For iOS (macOS only)
cd ios && pod install && cd ..
flutter run -d <device_id>

# For Web
flutter run -d chrome
```

---

## Configuration

### Backend API Environment Variables

Create `apps/api/.env`:

```env
# Database
DATABASE_URL="postgresql://postgres:password@localhost:5432/pesaloan?schema=public"

# JWT
JWT_SECRET="your-super-secret-jwt-key-min-32-chars"
JWT_EXPIRES_IN="15m"
REFRESH_TOKEN_EXPIRES_IN="90d"

# Server
PORT=3000
NODE_ENV=development

# M-Pesa (Safaricom Daraja API)
MPESA_CONSUMER_KEY="your-consumer-key"
MPESA_CONSUMER_SECRET="your-consumer-secret"
MPESA_PASSKEY="your-passkey"
MPESA_SHORTCODE="your-shortcode"
MPESA_TILL_NUMBER="1234567" # Default till number for registration fee (can be overridden in admin)
MPESA_CALLBACK_URL="https://your-domain.com/api/v1/mobile-money"
MPESA_ENVIRONMENT="sandbox" # or "production"

# Redis (optional, for rate limiting)
REDIS_URL="redis://localhost:6379"

# Email (optional)
SMTP_HOST="smtp.gmail.com"
SMTP_PORT=587
SMTP_USER="your-email@gmail.com"
SMTP_PASS="your-app-password"
```

### Admin Panel Environment Variables

Create `apps/admin/.env`:

```env
NEXT_PUBLIC_API_URL="http://localhost:3000/api/v1"
NEXTAUTH_SECRET="your-nextauth-secret-min-32-chars"
NEXTAUTH_URL="http://localhost:3001"
```

---

## Registration Fee Feature

### How It Works

1. **New User Registration**: User downloads app and registers
2. **OTP Verification**: User verifies phone number via OTP
3. **Registration Fee Payment**: Before first login, user must pay a one-time registration fee via M-Pesa STK Push
4. **Admin Control**: Admin can adjust the fee amount in Admin Panel → Registration Fee
5. **No Bypass**: Login is blocked until fee is paid (enforced at API level)

### Default Configuration

- **Amount**: KES 100.00 (10000 cents)
- **Currency**: KES
- **Status**: Active
- **Description**: "One-time account registration fee"
- **Destination Type**: M-Pesa Till
- **Destination Account**: From `MPESA_TILL_NUMBER` env var (default: 1234567)
- **Destination Name**: "PesaLoan Main Till"

### Admin Panel - Managing Registration Fee

1. Login to Admin Panel at `http://localhost:3001`
2. Navigate to **Registration Fee** in the sidebar
3. View current fee configuration including payment destination
4. Update amount, currency, description, or toggle active status
5. **Configure Payment Destination**:
   - **M-Pesa Till**: Enter till number (e.g., 1234567)
   - **M-Pesa Paybill**: Enter paybill number (e.g., 123456)
   - **Bank Account**: Enter account number, branch code, and account name
   - **Mobile Money**: Enter mobile money account identifier
6. Click **Save Registration Fee**
7. Changes take effect immediately for new registrations
8. Only one active fee configuration can exist at a time (previous ones auto-deactivated)

### API Endpoints

#### Public Endpoints
- `GET /api/v1/auth/registration-fee` - Get current fee info
- `POST /api/v1/auth/registration-fee/pay` - Initiate payment (STK Push)
- `GET /api/v1/auth/registration-fee/status/:phoneNumber` - Check payment status

#### Admin Endpoints (Require SUPER_ADMIN)
- `GET /api/v1/admin/registration-fee` - Get current fee
- `PUT /api/v1/admin/registration-fee` - Update fee

---

## Database Schema Changes

The following models were added:

```prisma
enum PaymentDestinationType {
  MPESA_TILL
  MPESA_PAYBILL
  BANK_ACCOUNT
  MOBILE_MONEY
}

model RegistrationFee {
  id                      String                @id @default(cuid())
  amount                  Int                   @default(10000)  // in cents
  currency                String                @default("KES")
  isActive                Boolean               @default(true)
  description             String?
  
  // Payment destination configuration
  destinationType         PaymentDestinationType @default(MPESA_TILL)
  destinationAccount      String                // Till number, Paybill number, or bank account number
  destinationName         String?               // e.g., "PesaLoan Main Till", "KCB Bank Account"
  destinationBranch       String?               // Bank branch code (for bank accounts)
  destinationReference    String?               // Account name or reference for bank transfers
  
  createdAt               DateTime              @default(now())
  updatedAt               DateTime              @updatedAt
  
  @@index([isActive])
}

model RegistrationFeePayment {
  id                String              @id @default(cuid())
  userId            String
  user              User                @relation(fields: [userId], references: [id], onDelete: Cascade)
  amount            Int
  currency          String              @default("KES")
  status            TransactionStatus   @default(PENDING)
  provider          MobileMoneyProvider?
  providerReference String?
  reference         String              @unique
  description       String
  metadata          Json
  processedAt       DateTime?
  createdAt         DateTime            @default(now())
  updatedAt         DateTime            @updatedAt
  @@index([userId])
  @@index([status])
  @@index([reference])
  @@index([providerReference])
}
```

User model extended with:
- `registrationFeePaid` Boolean @default(false)
- `registrationFeePaidAt` DateTime?
- `registrationFeePayments` RegistrationFeePayment[]

---

## Testing the Registration Fee Flow

### 1. Register a New User
```bash
curl -X POST http://localhost:3000/api/v1/auth/register \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "254712345678",
    "fullName": "Test User",
    "dateOfBirth": "1990-01-01T00:00:00.000Z",
    "nationalId": "12345678",
    "email": "test@example.com",
    "pin": "1234",
    "consentGiven": true,
    "consentVersion": "1.0"
  }'
```

### 2. Verify OTP
```bash
curl -X POST http://localhost:3000/api/v1/auth/otp/verify \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "254712345678",
    "code": "123456"
  }'
```

### 3. Create PIN
```bash
curl -X POST http://localhost:3000/api/v1/auth/pin \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer <access_token>" \
  -d '{"pin": "1234"}'
```

### 4. Try Login (Should Fail - Fee Required)
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "254712345678",
    "pin": "1234"
  }'
# Returns: REGISTRATION_FEE_REQUIRED
```

### 5. Get Fee Info
```bash
curl http://localhost:3000/api/v1/auth/registration-fee
```

### 6. Initiate Payment
```bash
curl -X POST http://localhost:3000/api/v1/auth/registration-fee/pay \
  -H "Content-Type: application/json" \
  -d '{"phoneNumber": "254712345678"}'
```

### 7. Check Payment Status
```bash
curl http://localhost:3000/api/v1/auth/registration-fee/status/254712345678
```

### 8. After Payment - Login Works
```bash
curl -X POST http://localhost:3000/api/v1/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "phoneNumber": "254712345678",
    "pin": "1234"
  }'
# Returns: accessToken, refreshToken
```

---

## Production Deployment

### Using Docker Compose (Recommended)

```bash
# Production environment
docker-compose -f docker-compose.yml -f docker-compose.prod.yml up -d

# Run migrations
docker-compose exec api npx prisma migrate deploy

# Scale API if needed
docker-compose up -d --scale api=3
```

### Environment-Specific Configs

- **Development**: `docker-compose.yml`
- **Staging**: `docker-compose.staging.yml`
- **Production**: `docker-compose.prod.yml`

### SSL/TLS

Configure reverse proxy (Nginx/Traefik) for HTTPS termination.

### Monitoring

- Health checks: `GET /health`
- Metrics: Available via Prometheus endpoint (if configured)
- Logs: Structured JSON logging

---

## Troubleshooting

### Database Connection Issues
```bash
# Check PostgreSQL is running
pg_isready -h localhost -p 5432

# Check connection string
npx prisma db pull
```

### M-Pesa Payment Not Working
1. Verify credentials in `.env`
2. Check callback URL is accessible publicly (use ngrok for dev)
3. Check Safaricom Daraja dashboard for errors
4. Ensure shortcode is activated for STK Push

### Registration Fee Not Enforced
1. Verify `registrationFeePaid` field in User model
2. Check login endpoint returns `REGISTRATION_FEE_REQUIRED`
3. Ensure mobile app handles the error code correctly

### Admin Panel Can't Save Fee
1. Verify admin user has SUPER_ADMIN role
2. Check NextAuth session includes accessToken
3. Verify API_BASE_URL is correct

---

## Useful Commands

```bash
# View API logs
docker-compose logs -f api

# View admin panel logs
docker-compose logs -f admin

# Reset database (DANGER: deletes all data)
docker-compose exec api npx prisma migrate reset --force

# Generate Prisma client after schema changes
cd apps/api && npx prisma generate

# Create new migration
cd apps/api && npx prisma migrate dev --name migration_name

# Run tests
cd apps/api && npm test
cd apps/admin && npm test
cd apps/mobile && flutter test
```

---

## Support

For issues or questions:
- Check logs: `docker-compose logs -f`
- Review API documentation at `http://localhost:3000/documentation` (if Swagger enabled)
- Admin panel: `http://localhost:3001`

## License

MIT License - See LICENSE file for details