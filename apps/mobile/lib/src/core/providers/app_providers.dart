export 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';
export 'package:pesaloan/src/features/kyc/presentation/providers/kyc_provider.dart';
export 'package:pesaloan/src/features/loan/presentation/providers/loan_provider.dart';
export 'package:pesaloan/src/features/profile/presentation/providers/profile_provider.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pesaloan/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:pesaloan/src/features/kyc/data/repositories/kyc_repository_impl.dart';
import 'package:pesaloan/src/features/kyc/domain/repositories/kyc_repository.dart';
import 'package:pesaloan/src/features/loan/data/repositories/loan_repository_impl.dart';
import 'package:pesaloan/src/features/loan/domain/repositories/loan_repository.dart';
import 'package:pesaloan/src/features/profile/data/repositories/profile_repository_impl.dart';
import 'package:pesaloan/src/features/profile/domain/repositories/profile_repository.dart';

// Repository providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final kycRepositoryProvider = Provider<KycRepository>((ref) {
  return KycRepositoryImpl();
});

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  return LoanRepositoryImpl();
});

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepositoryImpl();
});
