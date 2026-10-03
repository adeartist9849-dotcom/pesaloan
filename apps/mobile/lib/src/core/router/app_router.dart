import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/features/auth/presentation/screens/splash_screen.dart';
import 'package:pesaloan/src/features/auth/presentation/screens/onboarding_screen.dart';
import 'package:pesaloan/src/features/auth/presentation/screens/login_screen.dart';
import 'package:pesaloan/src/features/auth/presentation/screens/register_screen.dart';
import 'package:pesaloan/src/features/auth/presentation/screens/otp_screen.dart';
import 'package:pesaloan/src/features/auth/presentation/screens/create_pin_screen.dart';
import 'package:pesaloan/src/features/auth/presentation/screens/registration_fee_screen.dart';
import 'package:pesaloan/src/features/kyc/presentation/screens/kyc_screen.dart';
import 'package:pesaloan/src/features/home/presentation/screens/home_screen.dart';
import 'package:pesaloan/src/features/loan/presentation/screens/loan_application_screen.dart';
import 'package:pesaloan/src/features/loan/presentation/screens/loan_offer_screen.dart';
import 'package:pesaloan/src/features/loan/presentation/screens/loan_detail_screen.dart';
import 'package:pesaloan/src/features/loan/presentation/screens/repayment_screen.dart';
import 'package:pesaloan/src/features/loan/presentation/screens/loan_history_screen.dart';
import 'package:pesaloan/src/features/profile/presentation/screens/profile_screen.dart';
import 'package:pesaloan/src/features/profile/presentation/screens/settings_screen.dart';
import 'package:pesaloan/src/features/profile/presentation/screens/change_pin_screen.dart';
import 'package:pesaloan/src/features/legal/presentation/screens/terms_screen.dart';
import 'package:pesaloan/src/features/legal/presentation/screens/privacy_policy_screen.dart';
import 'package:pesaloan/src/features/legal/presentation/screens/loan_agreement_screen.dart';
import 'package:pesaloan/src/features/legal/presentation/screens/crb_disclosure_screen.dart';
import 'package:pesaloan/src/features/legal/presentation/screens/regulatory_info_screen.dart';
import 'package:pesaloan/src/features/legal/presentation/screens/complaints_screen.dart';
import 'package:pesaloan/src/features/help/presentation/screens/help_screen.dart';
import 'package:pesaloan/src/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:pesaloan/src/features/support/presentation/screens/support_screen.dart';
import 'package:pesaloan/src/shared/widgets/main_scaffold.dart';
import 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: AppConstants.defaultRoute,
    debugLogDiagnostics: true,
    redirect: (context, state) {
      final isLoggedIn = authState.isAuthenticated;
      final isOnboardingComplete = authState.isOnboardingComplete;
      final isKycVerified = authState.isKycVerified;

      final publicRoutes = [
        AppConstants.routeSplash,
        AppConstants.routeOnboarding,
        AppConstants.routeLogin,
        AppConstants.routeRegister,
        AppConstants.routeOtp,
        AppConstants.routeCreatePin,
        AppConstants.routeRegistrationFee,
      ];

      final isPublicRoute = publicRoutes.contains(state.matchedLocation);

      // Not logged in - redirect to login unless on public route
      if (!isLoggedIn && !isPublicRoute) {
        return AppConstants.routeLogin;
      }

      // Logged in but onboarding not complete
      if (isLoggedIn && !isOnboardingComplete && state.matchedLocation != AppConstants.routeCreatePin) {
        return AppConstants.routeCreatePin;
      }

      // Logged in, onboarding complete, but KYC not verified - redirect to KYC
      if (isLoggedIn && isOnboardingComplete && !isKycVerified && state.matchedLocation != AppConstants.routeKyc) {
        // Allow access to home to see loan limit but not apply
        if (state.matchedLocation == AppConstants.routeLoanApply) {
          return AppConstants.routeKyc;
        }
      }

      // Logged in and on public route - redirect to home
      if (isLoggedIn && isPublicRoute && state.matchedLocation != AppConstants.routeSplash) {
        return AppConstants.routeHome;
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AppConstants.routeSplash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: AppConstants.routeOnboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppConstants.routeLogin,
        name: 'login',
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppConstants.routeRegister,
        name: 'register',
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppConstants.routeOtp,
        name: 'otp',
        builder: (context, state) => OtpScreen(
          phoneNumber: state.uri.queryParameters['phone'] ?? '',
          isRegistration: state.uri.queryParameters['type'] == 'register',
        ),
      ),
      GoRoute(
        path: AppConstants.routeCreatePin,
        name: 'create-pin',
        builder: (context, state) => const CreatePinScreen(),
      ),
      GoRoute(
        path: AppConstants.routeRegistrationFee,
        name: 'registration-fee',
        builder: (context, state) => RegistrationFeeScreen(
          phoneNumber: state.uri.queryParameters['phone'] ?? '',
        ),
      ),
      GoRoute(
        path: AppConstants.routeKyc,
        name: 'kyc',
        builder: (context, state) => const KycScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => MainScaffold(child: child),
        routes: [
          GoRoute(
            path: AppConstants.routeHome,
            name: 'home',
            builder: (context, state) => const HomeScreen(),
          ),
          GoRoute(
            path: AppConstants.routeLoanApply,
            name: 'loan-apply',
            builder: (context, state) => const LoanApplicationScreen(),
          ),
          GoRoute(
            path: AppConstants.routeLoanOffer,
            name: 'loan-offer',
            builder: (context, state) => LoanOfferScreen(
              loanId: state.uri.queryParameters['loanId'] ?? '',
            ),
          ),
          GoRoute(
            path: AppConstants.routeLoanDetail,
            name: 'loan-detail',
            builder: (context, state) => LoanDetailScreen(
              loanId: state.pathParameters['id']!,
            ),
          ),
          GoRoute(
            path: AppConstants.routeRepayment,
            name: 'repayment',
            builder: (context, state) => RepaymentScreen(
              loanId: state.uri.queryParameters['loanId'] ?? '',
            ),
          ),
          GoRoute(
            path: AppConstants.routeLoanHistory,
            name: 'loan-history',
            builder: (context, state) => const LoanHistoryScreen(),
          ),
          GoRoute(
            path: AppConstants.routeProfile,
            name: 'profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: AppConstants.routeSettings,
            name: 'settings',
            builder: (context, state) => const SettingsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeChangePin,
            name: 'change-pin',
            builder: (context, state) => const ChangePinScreen(),
          ),
          GoRoute(
            path: AppConstants.routeTerms,
            name: 'terms',
            builder: (context, state) => const TermsScreen(),
          ),
          GoRoute(
            path: AppConstants.routePrivacyPolicy,
            name: 'privacy-policy',
            builder: (context, state) => const PrivacyPolicyScreen(),
          ),
          GoRoute(
            path: AppConstants.routeLoanAgreement,
            name: 'loan-agreement',
            builder: (context, state) => const LoanAgreementScreen(),
          ),
          GoRoute(
            path: AppConstants.routeCrbDisclosure,
            name: 'crb-disclosure',
            builder: (context, state) => const CrbDisclosureScreen(),
          ),
          GoRoute(
            path: AppConstants.routeRegulatoryInfo,
            name: 'regulatory-info',
            builder: (context, state) => const RegulatoryInfoScreen(),
          ),
          GoRoute(
            path: AppConstants.routeComplaints,
            name: 'complaints',
            builder: (context, state) => const ComplaintsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeHelp,
            name: 'help',
            builder: (context, state) => const HelpScreen(),
          ),
          GoRoute(
            path: AppConstants.routeNotifications,
            name: 'notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: AppConstants.routeSupport,
            name: 'support',
            builder: (context, state) => const SupportScreen(),
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Page not found', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            Text(state.error.toString(), style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.routeHome),
              child: const Text('Go Home'),
            ),
          ],
        ),
      ),
    ),
  );
});
