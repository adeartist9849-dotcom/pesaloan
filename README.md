# PesaLoan — Digital Lending Platform

A production-ready digital lending platform for the Kenyan market, built as a monorepo with Flutter (mobile), Fastify/TypeScript (API), and Next.js (admin dashboard).

## 🏗 Architecture

```
pesaloan/
├── apps/
│   ├── mobile/          # Flutter app (Android/iOS)
│   ├── api/             # Fastify + TypeScript + Prisma
│   └── admin/           # Next.js + React + Tailwind
├── packages/
│   └── shared/          # Shared types, constants, validation
├── docker-compose.yml   # Local development stack
└── .github/workflows/   # CI/CD pipelines
```

## 🚀 Quick Start

### Prerequisites
- Node.js 20+
- Flutter 3.16+
- Docker & Docker Compose
- PostgreSQL 16 (or use Docker)
- Redis 7 (or use Docker)

### 1. Clone & Install

```bash
git clone <repo-url>
cd pesaloan

# Install all dependencies
npm install

# Install Flutter dependencies
cd apps/mobile && flutter pub get && cd ../..

# Generate shared package
npm run build --workspace=packages/shared
```

### 2. Environment Setup

```bash
# Copy example env and configure
cp .env.example .env

# Edit .env with your credentials (M-Pesa, KYC, SMS, etc.)
# For local development, defaults work with Docker Compose
```

### 3. Start Infrastructure

```bash
# Start PostgreSQL, Redis, Mailhog
docker-compose up -d postgres redis mailhog

# Verify services are healthy
docker-compose ps
```

### 4. Database Setup

```bash
# Generate Prisma client
cd apps/api && npx prisma generate

# Run migrations
npx prisma migrate dev --name init

# Seed development data
npx prisma db seed
```

### 5. Start Development Servers

```bash
# Terminal 1: API server (port 3000)
npm run dev:api

# Terminal 2: Admin dashboard (port 3001)
npm run dev:admin

# Terminal 3: Flutter app
cd apps/mobile && flutter run
```

## 📱 Mobile App (Flutter)

### Structure
```
apps/mobile/lib/
├── main.dart
├── src/
│   ├── app.dart                 # App entry point
│   ├── core/
│   │   ├── constants/           # App constants
│   │   ├── errors/              # Custom exceptions
│   │   ├── network/             # Dio client + interceptors
│   │   ├── providers/           # Riverpod providers
│   │   └── router/              # GoRouter configuration
│   ├── features/
│   │   ├── auth/                # Login, register, OTP, PIN
│   │   ├── kyc/                 # KYC submission & status
│   │   ├── loan/                # Apply, offer, detail, repay, history
│   │   ├── profile/             # Profile, settings, change PIN
│   │   └── home/                # Dashboard
│   └── shared/
│       ├── theme/               # Light/dark theme
│       └── widgets/             # Reusable components
```

### Key Dependencies
- **State**: `flutter_riverpod` + `riverpod_generator`
- **Network**: `dio` + `pretty_dio_logger`
- **Storage**: `flutter_secure_storage` + `hive`
- **Routing**: `go_router`
- **Forms**: `reactive_forms`
- **Code Gen**: `freezed`, `json_serializable`, `build_runner`

### Generate Code
```bash
cd apps/mobile
flutter pub run build_runner build --delete-conflicting-outputs
```

### Build for Release
```bash
# Android
flutter build apk --release
flutter build appbundle --release

# iOS
flutter build ios --release
```

## 🔧 API (Fastify + TypeScript)

### Structure
```
apps/api/src/
├── main.ts                    # Entry point
├── config/                    # Configuration
├── plugins/                   # Fastify plugins (cors, helmet, jwt, swagger)
├── common/
│   ├── guards/                # Auth guards
│   ├── filters/               # Error handling
│   ├── interceptors/          # Request/response interceptors
│   ├── pipes/                 # Validation pipes
│   └── utils/                 # Crypto, audit, helpers
├── database/
│   ├── client.ts              # Prisma client
│   └── migrations/            # Database migrations
├── modules/
│   ├── auth/                  # Registration, login, OTP, tokens
│   ├── users/                 # Profile management
│   ├── kyc/                   # KYC submission & verification
│   ├── loans/                 # Application, approval, disbursement
│   ├── repayments/            # Repayment processing
│   ├── notifications/         # Push, SMS, email
│   └── mobile-money/          # M-Pesa, Airtel Money integration
└── routes/                    # Route registration
```

### Key Endpoints

| Method | Endpoint | Description |
|--------|----------|-------------|
| POST | `/api/v1/auth/register` | Register new user |
| POST | `/api/v1/auth/login` | Login with PIN |
| POST | `/api/v1/auth/otp/request` | Request OTP |
| POST | `/api/v1/auth/otp/verify` | Verify OTP |
| POST | `/api/v1/auth/pin` | Create PIN |
| GET | `/api/v1/users/profile` | Get user profile |
| POST | `/api/v1/kyc/submit` | Submit KYC documents |
| GET | `/api/v1/kyc/status` | Get KYC status |
| POST | `/api/v1/loans/apply` | Apply for loan |
| GET | `/api/v1/loans/offer/:id` | Get loan offer |
| POST | `/api/v1/loans/accept` | Accept loan offer |
| GET | `/api/v1/loans/dashboard` | Get dashboard data |
| GET | `/api/v1/loans/history` | Get loan history |
| GET | `/api/v1/loans/:id` | Get loan detail |
| POST | `/api/v1/loans/repay` | Initiate repayment |
| POST | `/api/v1/mobile-money/mpesa/callback` | M-Pesa STK callback |
| POST | `/api/v1/mobile-money/mpesa/b2c/callback` | M-Pesa B2C callback |

### Database Schema (Prisma)
Key models: `User`, `KycRecord`, `LoanApplication`, `Loan`, `Repayment`, `Transaction`, `Notification`, `AuditLog`, `CreditRules`, `OTP`, `RefreshToken`, `AdminUser`

### Run Commands
```bash
cd apps/api

# Development
npm run dev

# Database
npm run db:generate    # Generate Prisma client
npm run db:push        # Push schema changes
npm run db:migrate     # Run migrations
npm run db:studio      # Open Prisma Studio
npm run db:seed        # Seed development data

# Testing
npm run test
npm run lint
```

## 🖥 Admin Dashboard (Next.js)

### Structure
```
apps/admin/src/
├── app/
│   ├── (dashboard)/           # Protected dashboard routes
│   │   ├── layout.tsx         # Sidebar + header layout
│   │   ├── page.tsx           # Dashboard overview
│   │   ├── customers/         # Customer management
│   │   ├── loans/             # Loan management
│   │   ├── payments/          # Transaction management
│   │   ├── credit/            # Credit rules configuration
│   │   ├── operations/        # Manual review, support, audit, fraud
│   │   └── reports/           # Analytics & reporting
│   ├── globals.css            # Tailwind + custom styles
│   └── layout.tsx             # Root layout
├── components/
│   ├── ui/                    # Base UI components
│   ├── forms/                 # Form components
│   └── tables/                # Data table components
├── lib/
│   ├── api/                   # Axios instance + API calls
│   ├── auth/                  # Auth utilities
│   └── utils/                 # Helpers (clsx, formatters)
└── hooks/                     # Custom React hooks
```

### Pages

| Route | Description |
|-------|-------------|
| `/dashboard` | Overview KPIs, charts, recent activity |
| `/dashboard/customers` | Customer list with KYC/status filters |
| `/dashboard/loans` | Loan portfolio with status filters |
| `/dashboard/payments` | Transaction history & reconciliation |
| `/dashboard/credit` | Live credit rules editor with calculator |
| `/dashboard/operations` | Manual review, support tickets, audit logs, fraud |
| `/dashboard/reports` | Analytics, trends, funnel, segment performance |

### Run Commands
```bash
cd apps/admin

# Development
npm run dev

# Production build
npm run build
npm start

# Linting
npm run lint
```

## 🐳 Docker Development

```bash
# Start all services
docker-compose up -d

# View logs
docker-compose logs -f api
docker-compose logs -f admin

# Stop all
docker-compose down

# Reset database
docker-compose down -v
docker-compose up -d postgres redis
# Then run migrations & seed
```

## 🧪 Testing

```bash
# All tests
npm run test

# API tests (with testcontainers)
cd apps/api && npm run test

# Admin tests
cd apps/admin && npm run test

# Mobile tests
cd apps/mobile && flutter test

# Shared package tests
npm run test --workspace=packages/shared
```

## 🔐 Security Checklist

- [ ] Change all default secrets in `.env`
- [ ] Use strong JWT secret (32+ chars)
- [ ] Enable HTTPS in production
- [ ] Configure CORS for production domains
- [ ] Set up rate limiting
- [ ] Enable audit logging
- [ ] Configure M-Pesa production credentials
- [ ] Set up KYC provider (Smile Identity, Prembly)
- [ ] Configure SMS provider (Africa's Talking)
- [ ] Set up push notifications (Firebase)
- [ ] Run penetration testing
- [ ] Enable database encryption at rest
- [ ] Set up backup & disaster recovery

## 📋 Kenya Compliance (Pre-Launch)

Before accepting customers, ensure:

1. **CBK Digital Credit Provider License** — Apply early (3-6 months)
2. **ODPC Registration** — Data Protection Act compliance
3. **M-Pesa Business Onboarding** — Safaricom sandbox → production (4-8 weeks)
4. **Consumer Protection** — Transparent pricing, cooling-off period
5. **AML/CFT** — Customer due diligence, transaction monitoring
6. **Credit Reference Bureau** — Data sharing agreements
7. **Dispute Resolution** — Complaints handling process

## 📦 Deployment

### Production Build
```bash
# Build all packages
npm run build

# Build Docker images
docker build -t pesaloan-api:latest -f apps/api/Dockerfile .
docker build -t pesaloan-admin:latest -f apps/admin/Dockerfile .
```

### Kubernetes (Helm chart recommended)
```yaml
# Key production considerations:
# - PostgreSQL: Managed (RDS, Cloud SQL) with read replicas
# - Redis: Managed (ElastiCache) with clustering
# - API: Horizontal scaling with load balancer
# - Admin: Static export or SSR with CDN
# - Mobile: CodePush for OTA updates
# - Secrets: Vault/Sealed Secrets
# - Monitoring: Prometheus + Grafana + Loki
# - Logging: ELK/Loki
```

## 🤝 Contributing

1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

### Code Style
- **TypeScript**: ESLint + Prettier (run `npm run lint`)
- **Dart**: `flutter analyze` + `dart format`
- **Commits**: Conventional Commits (`feat:`, `fix:`, `docs:`, etc.)

## 📄 License

Proprietary — All rights reserved. PesaLoan is a trademark of PesaLoan Limited.

## 🏆 Support

- **Documentation**: `/docs`
- **API Docs**: `http://localhost:3000/docs` (Swagger)
- **Issues**: GitHub Issues
- **Email**: support@PesaLoan.co.ke

---

**Built for Kenya** 🇰🇪 | **PesaLoan** — Fast, transparent digital credit
