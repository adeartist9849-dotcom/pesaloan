# PesaLoan - Development Commands
# Usage: make <command>

.PHONY: help install dev test build clean docker-up docker-down docker-logs db-setup db-seed

# Default target
help:
	@echo "PesaLoan - Development Commands"
	@echo ""
	@echo "Setup:"
	@echo "  make install        - Install all dependencies"
	@echo "  make db-setup       - Setup database (generate client, migrate, seed)"
	@echo ""
	@echo "Development:"
	@echo "  make dev            - Start all dev servers (API + Admin)"
	@echo "  make dev:api        - Start API server only"
	@echo "  make dev:admin      - Start Admin dashboard only"
	@echo "  make dev:mobile     - Start Flutter app"
	@echo ""
	@echo "Docker:"
	@echo "  make docker-up      - Start PostgreSQL, Redis, Mailhog"
	@echo "  make docker-down    - Stop all containers"
	@echo "  make docker-logs    - View container logs"
	@echo "  make docker-build   - Build Docker images"
	@echo ""
	@echo "Testing:"
	@echo "  make test           - Run all tests"
	@echo "  make test:api       - Run API tests"
	@echo "  make test:admin     - Run Admin tests"
	@echo "  make test:mobile    - Run Flutter tests"
	@echo ""
	@echo "Building:"
	@echo "  make build          - Build all packages"
	@echo "  build:api          - Build API"
	@echo "  build:admin        - Build Admin"
	@echo "  build:mobile       - Build Flutter APK/AAB"
	@echo ""
	@echo "Maintenance:"
	@echo "  make clean          - Clean build artifacts"
	@echo "  make lint           - Run linters"
	@echo "  make db-seed        - Seed database with test data"
	@echo "  make db-studio      - Open Prisma Studio"

# Install all dependencies
install:
	npm install
	cd apps/mobile && flutter pub get
	cd apps/api && npm install
	cd apps/admin && npm install

# Development servers
dev:
	npm run dev

dev-api:
	npm run dev:api

dev-admin:
	npm run dev:admin

dev-mobile:
	cd apps/mobile && flutter run

# Docker
docker-up:
	docker-compose up -d postgres redis mailhog

docker-down:
	docker-compose down

docker-down-v:
	docker-compose down -v

docker-logs:
	docker-compose logs -f

docker-build:
	docker-compose build

docker-ps:
	docker-compose ps

# Database
db-setup:
	cd apps/api && npx prisma generate && npx prisma migrate dev --name init

db-migrate:
	cd apps/api && npx prisma migrate dev

db-push:
	cd apps/api && npx prisma db push

db-seed:
	cd apps/api && npx prisma db seed

db-studio:
	cd apps/api && npx prisma studio

db-reset:
	cd apps/api && npx prisma migrate reset --force

# Testing
test:
	npm run test

test-api:
	cd apps/api && npm run test

test-admin:
	cd apps/admin && npm run test

test-mobile:
	cd apps/mobile && flutter test

test-coverage:
	cd apps/api && npm run test -- --coverage

# Building
build:
	npm run build

build-api:
	cd apps/api && npm run build

build-admin:
	cd apps/admin && npm run build

build-mobile:
	cd apps/mobile && flutter build apk --release && flutter build appbundle --release

build-mobile-ios:
	cd apps/mobile && flutter build ios --release

# Linting
lint:
	npm run lint

lint-api:
	cd apps/api && npm run lint

lint-admin:
	cd apps/admin && npm run lint

lint-mobile:
	cd apps/mobile && flutter analyze

# Code generation
generate:
	cd apps/mobile && flutter pub run build_runner build --delete-conflicting-outputs

generate-api:
	cd apps/api && npx prisma generate

# Clean
clean:
	rm -rf apps/api/dist apps/admin/.next apps/mobile/build
	rm -rf node_modules apps/api/node_modules apps/admin/node_modules apps/mobile/.dart_tool
	rm -rf apps/mobile/build

# Full reset
reset: clean docker-down-v install db-setup
	@echo "Full reset complete!"

# Production deploy (staging)
deploy-staging:
	@echo "Deploying to staging..."
	# Add your staging deployment commands here

# Production deploy (production)
deploy-production:
	@echo "Deploying to production..."
	# Add your production deployment commands here
