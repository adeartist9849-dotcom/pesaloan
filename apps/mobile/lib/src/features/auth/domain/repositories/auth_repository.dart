import 'package:pesaloan/src/features/auth/domain/models/user_model.dart';
import 'package:pesaloan/src/features/auth/domain/models/auth_tokens_model.dart';
import 'package:pesaloan/src/features/auth/domain/models/registration_fee_model.dart';

abstract class AuthRepository {
  Future<AuthTokensModel> login({
    required String phoneNumber,
    required String pin,
  });
  
  Future<void> register({
    required String phoneNumber,
    required String fullName,
    required String dateOfBirth,
    required String nationalId,
    String? email,
    required String pin,
    required bool consentGiven,
    required String consentVersion,
  });
  
  Future<void> requestOtp({required String phoneNumber});
  
  Future<void> verifyOtp({required String phoneNumber, required String code});
  
  Future<void> createPin({required String pin});
  
  Future<UserModel> getProfile();
  
  Future<void> logout();
  
  Future<void> changePin({required String currentPin, required String newPin});
  
  Future<void> refreshToken();
  
  // Registration Fee methods
  Future<RegistrationFeeModel> getRegistrationFee();
  
  Future<String> initiateRegistrationFeePayment({required String phoneNumber});
  
  Future<RegistrationFeeStatusModel> checkRegistrationFeeStatus({required String phoneNumber});
}