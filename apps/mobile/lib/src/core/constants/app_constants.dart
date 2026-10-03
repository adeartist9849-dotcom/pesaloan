class AppConstants {
  const AppConstants._();

  static const String appName = 'PesaLoan';
  static const String appVersion = '1.0.0';
  static const String defaultApiBaseUrl = 'http://10.0.2.2:3000/api/v1'; // Android emulator localhost
  static const String iOSApiBaseUrl = 'http://localhost:3000/api/v1'; // iOS simulator localhost

  static const String currencyCode = 'KES';
  static const String currencySymbol = 'KES ';
  static const String countryCode = 'KE';
  static const String defaultLanguage = 'en';

  static const int otpLength = 6;
  static const int otpExpiryMinutes = 5;
  static const int minPinLength = 4;
  static const int maxPinLength = 6;

  static const int minLoanAmount = 500;
  static const int maxLoanAmount = 50000;
  static const int minLoanTermDays = 7;
  static const int maxLoanTermDays = 90;

  static const int sessionTimeoutMinutes = 30;
  static const int maxFailedLoginAttempts = 5;
  static const int lockoutDurationMinutes = 15;

  // Validation patterns
  static const String phoneRegex = r'^254\d{9}$';
  static const String pinRegex = r'^\d{4,6}$';
  static const String nameRegex = r"^[a-zA-Z\s\-']+$";
  static const String nationalIdRegex = r'^\d{8}$';

  static const String keyUserToken = 'user_token';
  static const String keyRefreshToken = 'refresh_token';
  static const String keyUserProfile = 'user_profile';
  static const String keyBiometricEnabled = 'biometric_enabled';
  static const String keyOnboardingCompleted = 'onboarding_completed';
  static const String keyLastSyncTime = 'last_sync_time';

  static const String mpesaPaybillNumber = 'MKPOEXTRA';
  static const String supportPhone = '+254700000000';
  static const String supportEmail = 'support@PesaLoan.co.ke';
  static const String privacyPolicyUrl = 'https://PesaLoan.co.ke/privacy';
  static const String termsOfServiceUrl = 'https://PesaLoan.co.ke/terms';
  static const String loanAgreementUrl = 'https://PesaLoan.co.ke/loan-agreement';

  // Legal document versions
  static const String termsVersion = '1.0';
  static const String privacyPolicyVersion = '1.0';
  static const String loanAgreementVersion = '1.0';

  // Routes
  static const String defaultRoute = '/splash';
  static const String routeSplash = '/splash';
  static const String routeOnboarding = '/onboarding';
  static const String routeLogin = '/login';
  static const String routeRegister = '/register';
  static const String routeOtp = '/otp';
  static const String routeCreatePin = '/create-pin';
  static const String routeKyc = '/kyc';
  static const String routeHome = '/home';
  static const String routeLoanApply = '/loan/apply';
  static const String routeLoanOffer = '/loan/offer';
  static const String routeLoanDetail = '/loan/:id';
  static const String routeRepayment = '/loan/repay';
  static const String routeLoanHistory = '/loans/history';
  static const String routeProfile = '/profile';
  static const String routeSettings = '/settings';
  static const String routeChangePin = '/profile/change-pin';
  static const String routeRegistrationFee = '/registration-fee';

  // Legal routes
  static const String routeTerms = '/legal/terms';
  static const String routePrivacyPolicy = '/legal/privacy-policy';
  static const String routeLoanAgreement = '/legal/loan-agreement';
  static const String routeCrbDisclosure = '/legal/crb-disclosure';
  static const String routeRegulatoryInfo = '/legal/regulatory-info';
  static const String routeComplaints = '/legal/complaints';

  // Help & Support routes
  static const String routeHelp = '/help';
  static const String routeNotifications = '/notifications';
  static const String routeSupport = '/support';
}
