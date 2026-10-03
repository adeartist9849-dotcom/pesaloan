import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/core/network/dio_client.dart';
import 'package:pesaloan/src/core/errors/exceptions.dart';
import 'package:pesaloan/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:pesaloan/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:pesaloan/src/features/auth/domain/models/user_model.dart';
import 'package:pesaloan/src/features/auth/domain/models/auth_tokens_model.dart';
import 'package:pesaloan/src/features/auth/domain/models/registration_fee_model.dart';

// Auth state
class AuthState {
  final bool isAuthenticated;
  final bool isLoading;
  final UserModel? user;
  final String? error;
  final bool isOnboardingComplete;
  final bool isKycVerified;
  final bool registrationFeeRequired;
  final RegistrationFeeModel? registrationFee;
  final RegistrationFeeStatusModel? registrationFeeStatus;
  
  const AuthState({
    this.isAuthenticated = false,
    this.isLoading = true,
    this.user,
    this.error,
    this.isOnboardingComplete = false,
    this.isKycVerified = false,
    this.registrationFeeRequired = false,
    this.registrationFee,
    this.registrationFeeStatus,
  });
  
  AuthState copyWith({
    bool? isAuthenticated,
    bool? isLoading,
    UserModel? user,
    String? error,
    bool? isOnboardingComplete,
    bool? isKycVerified,
    bool? registrationFeeRequired,
    RegistrationFeeModel? registrationFee,
    RegistrationFeeStatusModel? registrationFeeStatus,
  }) {
    return AuthState(
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: error,
      isOnboardingComplete: isOnboardingComplete ?? this.isOnboardingComplete,
      isKycVerified: isKycVerified ?? this.isKycVerified,
      registrationFeeRequired: registrationFeeRequired ?? this.registrationFeeRequired,
      registrationFee: registrationFee ?? this.registrationFee,
      registrationFeeStatus: registrationFeeStatus ?? this.registrationFeeStatus,
    );
  }
}

// Auth notifier
class AuthNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  final FlutterSecureStorage _storage;
  
  AuthNotifier(this._repository, this._storage) : super(const AuthState()) {
    _checkAuthStatus();
  }
  
  Future<void> _checkAuthStatus() async {
    try {
      final token = await _storage.read(key: AppConstants.keyUserToken);
      final refreshToken = await _storage.read(key: AppConstants.keyRefreshToken);
      final userJson = await _storage.read(key: AppConstants.keyUserProfile);
      final onboardingComplete = await _storage.read(key: AppConstants.keyOnboardingCompleted);
      
      if (token != null && refreshToken != null && userJson != null) {
        final user = UserModel.fromJsonString(userJson);
        state = state.copyWith(
          isAuthenticated: true,
          isLoading: false,
          user: user,
          isOnboardingComplete: onboardingComplete == 'true',
          isKycVerified: user.kycStatus == 'VERIFIED',
        );
      } else {
        state = state.copyWith(isLoading: false);
      }
    } catch (_) {
      state = state.copyWith(isLoading: false);
    }
  }
  
  Future<void> register({
    required String phoneNumber,
    required String fullName,
    required String dateOfBirth,
    required String nationalId,
    String? email,
    required String pin,
    required bool consentGiven,
    required String consentVersion,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final response = await _repository.register(
        phoneNumber: phoneNumber,
        fullName: fullName,
        dateOfBirth: dateOfBirth,
        nationalId: nationalId,
        email: email,
        pin: pin,
        consentGiven: consentGiven,
        consentVersion: consentVersion,
      );
      
      // Navigate to OTP screen
      state = state.copyWith(isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }
  
  Future<void> login({
    required String phoneNumber,
    required String pin,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final authTokens = await _repository.login(phoneNumber: phoneNumber, pin: pin);
      
      await DioClient.setAuthTokens(
        accessToken: authTokens.accessToken,
        refreshToken: authTokens.refreshToken,
      );
      
      final user = await _repository.getProfile();
      
      await _storage.write(key: AppConstants.keyUserProfile, value: user.toJsonString());
      
      state = state.copyWith(
        isAuthenticated: true,
        isLoading: false,
        user: user,
        isOnboardingComplete: true,
        isKycVerified: user.kycStatus == 'VERIFIED',
        registrationFeeRequired: false,
      );
    } on AppException catch (e) {
      // Check if registration fee is required
      if (e.code == 'REGISTRATION_FEE_REQUIRED') {
        final feeStatus = await _repository.checkRegistrationFeeStatus(phoneNumber: phoneNumber);
        final fee = await _repository.getRegistrationFee();
        state = state.copyWith(
          isLoading: false,
          error: e.message,
          registrationFeeRequired: true,
          registrationFee: fee,
          registrationFeeStatus: feeStatus,
        );
      } else {
        state = state.copyWith(isLoading: false, error: e.message);
      }
      rethrow;
    }
  }
  
  Future<void> loadRegistrationFee() async {
    try {
      final fee = await _repository.getRegistrationFee();
      state = state.copyWith(registrationFee: fee);
    } catch (_) {
      // Ignore error
    }
  }
  
  Future<String> initiateRegistrationFeePayment({required String phoneNumber}) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final checkoutRequestId = await _repository.initiateRegistrationFeePayment(phoneNumber: phoneNumber);
      state = state.copyWith(isLoading: false);
      return checkoutRequestId;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }
  
  Future<void> checkRegistrationFeeStatus({required String phoneNumber}) async {
    try {
      final feeStatus = await _repository.checkRegistrationFeeStatus(phoneNumber: phoneNumber);
      state = state.copyWith(registrationFeeStatus: feeStatus);
    } catch (_) {
      // Ignore error
    }
  }
  
  Future<void> requestOtp({
    required String phoneNumber,
    required bool isRegistration,
  }) async {
    try {
      await _repository.requestOtp(phoneNumber: phoneNumber);
    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }
  
  Future<void> verifyOtp({
    required String phoneNumber,
    required String code,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.verifyOtp(phoneNumber: phoneNumber, code: code);
      state = state.copyWith(isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }
  
  Future<void> createPin({required String pin}) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.createPin(pin: pin);
      await _storage.write(key: AppConstants.keyOnboardingCompleted, value: 'true');
      
      final user = await _repository.getProfile();
      await _storage.write(key: AppConstants.keyUserProfile, value: user.toJsonString());
      
      state = state.copyWith(
        isLoading: false,
        user: user,
        isOnboardingComplete: true,
        isKycVerified: user.kycStatus == 'VERIFIED',
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }
  
  Future<void> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      await _repository.changePin(currentPin: currentPin, newPin: newPin);
      state = state.copyWith(isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }

  Future<void> logout() async {
    try {
      await _repository.logout();
    } finally {
      await DioClient.clearAuth();
      await _storage.delete(key: AppConstants.keyUserProfile);
      await _storage.delete(key: AppConstants.keyOnboardingCompleted);
      
      state = const AuthState(isLoading: false);
    }
  }
  
  Future<void> refreshUser() async {
    try {
      final user = await _repository.getProfile();
      await _storage.write(key: AppConstants.keyUserProfile, value: user.toJsonString());
      
      state = state.copyWith(
        user: user,
        isKycVerified: user.kycStatus == 'VERIFIED',
      );
    } catch (_) {
      // Ignore refresh errors
    }
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}

// Providers
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final authStateProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  const storage = FlutterSecureStorage();
  return AuthNotifier(repository, storage);
});