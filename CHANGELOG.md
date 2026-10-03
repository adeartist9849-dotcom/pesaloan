# Changelog

All notable changes to PesaLoan will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-09-30

### Added
- Initial release of PesaLoan digital lending platform
- Mobile app (Flutter) for Android and iOS
- REST API (Fastify + TypeScript) with Prisma ORM
- Admin dashboard (Next.js + React + Tailwind)
- Shared types package for type safety across apps

### Mobile App Features
- User registration with OTP verification
- PIN-based authentication with biometric support
- KYC verification with National ID document upload
- Loan application with transparent cost breakdown
- M-Pesa STK Push for disbursement and repayment
- Airtel Money integration
- Real-time loan tracking and repayment scheduling
- Push notifications for loan updates
- Biometric authentication (Face ID / Fingerprint)
- Secure PIN management
- Loan history and transaction history

### API Features
- JWT-based authentication with refresh tokens
- Rate limiting and CORS protection
- M-Pesa STK Push and B2C integration
- Airtel Money integration
- Credit scoring engine with configurable rules
- KYC verification workflow
- Audit logging for all sensitive operations
- Admin APIs for customer/loan/credit management
- Webhook handling for mobile money callbacks

### Admin Dashboard Features
- Customer management with KYC status
- Loan portfolio management
- Transaction monitoring and reconciliation
- Credit rules configuration with live calculator
- Manual loan review and approval
- Audit log viewer
- Fraud monitoring dashboard
- Analytics and reporting

### Infrastructure
- Docker Compose for local development
- GitHub Actions CI/CD pipeline
- PostgreSQL database with Prisma migrations
- Redis for caching and rate limiting
- Comprehensive test suites
- Automated deployment with Fastlane

### Security
- End-to-end encryption for sensitive data
- Certificate pinning for API communications
- Secure PIN storage with bcrypt
- JWT tokens with short expiry and refresh rotation
- Certificate pinning for mobile money providers
- Network security configuration (Android)
- App Transport Security (iOS)
- Privacy manifest for iOS 17+
- Export compliance declaration

[1.0.0]: https://github.com/pesaloan/pesaloan/releases/tag/v1.0.0