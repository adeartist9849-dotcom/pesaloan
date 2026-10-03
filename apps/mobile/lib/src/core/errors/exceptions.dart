abstract class AppException implements Exception {
  final String message;
  final String code;
  final int? statusCode;
  final Map<String, dynamic>? details;
  
  const AppException({
    required this.message,
    required this.code,
    this.statusCode,
    this.details,
  });
  
  @override
  String toString() => 'AppException: $code - $message';
}

class ValidationException extends AppException {
  const ValidationException({
    required String message,
    Map<String, dynamic>? details,
  }) : super(
    message: message,
    code: 'VALIDATION_ERROR',
    statusCode: 400,
    details: details,
  );
}

class AuthenticationException extends AppException {
  const AuthenticationException({
    String message = 'Authentication required',
    this.originalError,
  }) : super(
    message: message,
    code: 'AUTHENTICATION_ERROR',
    statusCode: 401,
  );
  
  final Exception? originalError;
}

class AuthorizationException extends AppException {
  const AuthorizationException({
    String message = 'Insufficient permissions',
  }) : super(
    message: message,
    code: 'AUTHORIZATION_ERROR',
    statusCode: 403,
  );
}

class NotFoundException extends AppException {
  const NotFoundException({
    required String resource,
  }) : super(
    message: '$resource not found',
    code: 'NOT_FOUND',
    statusCode: 404,
  );
}

class ConflictException extends AppException {
  const ConflictException({
    required String message,
  }) : super(
    message: message,
    code: 'CONFLICT',
    statusCode: 409,
  );
}

class RateLimitException extends AppException {
  const RateLimitException({
    String message = 'Too many requests. Please try again later.',
  }) : super(
    message: message,
    code: 'RATE_LIMIT_EXCEEDED',
    statusCode: 429,
  );
}

class ServerException extends AppException {
  const ServerException({
    String message = 'An unexpected error occurred. Please try again.',
  }) : super(
    message: message,
    code: 'INTERNAL_ERROR',
    statusCode: 500,
  );
}

class NetworkException extends AppException {
  const NetworkException({
    String message = 'Network error. Please check your connection.',
  }) : super(
    message: message,
    code: 'NETWORK_ERROR',
    statusCode: 0,
  );
}

class UnknownException extends AppException {
  const UnknownException({
    required String message,
    String code = 'UNKNOWN_ERROR',
    int? statusCode,
  }) : super(
    message: message,
    code: code,
    statusCode: statusCode,
  );
}

class SessionExpiredException extends AppException {
  const SessionExpiredException({
    String message = 'Your session has expired. Please log in again.',
  }) : super(
    message: message,
    code: 'SESSION_EXPIRED',
    statusCode: 401,
  );
}

class KycNotVerifiedException extends AppException {
  const KycNotVerifiedException({
    String message = 'Please complete KYC verification to access this feature.',
  }) : super(
    message: message,
    code: 'KYC_NOT_VERIFIED',
    statusCode: 403,
  );
}

class LoanException extends AppException {
  const LoanException({
    required String message,
    required String code,
  }) : super(
    message: message,
    code: code,
    statusCode: 400,
  );
  
  factory LoanException.limitExceeded() => const LoanException(
    message: 'Requested amount exceeds your loan limit',
    code: 'LOAN_LIMIT_EXCEEDED',
  );
  
  factory LoanException.activeLoanExists() => const LoanException(
    message: 'You already have an active loan. Please repay it first.',
    code: 'LOAN_ACTIVE_EXISTS',
  );
  
  factory LoanException.notEligible() => const LoanException(
    message: 'You are not eligible for a loan at this time',
    code: 'LOAN_NOT_ELIGIBLE',
  );
  
  factory LoanException.offerExpired() => const LoanException(
    message: 'This loan offer has expired',
    code: 'LOAN_OFFER_EXPIRED',
  );
}