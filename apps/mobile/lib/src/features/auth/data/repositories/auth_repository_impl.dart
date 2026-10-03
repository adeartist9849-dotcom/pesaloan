import 'package:dio/dio.dart';
import 'package:pesaloan/src/core/network/dio_client.dart';
import 'package:pesaloan/src/core/errors/exceptions.dart';
import 'package:pesaloan/src/features/auth/domain/repositories/auth_repository.dart';
import 'package:pesaloan/src/features/auth/domain/models/user_model.dart';
import 'package:pesaloan/src/features/auth/domain/models/auth_tokens_model.dart';
import 'package:pesaloan/src/features/auth/domain/models/registration_fee_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<AuthTokensModel> login({
    required String phoneNumber,
    required String pin,
  }) async {
    try {
      final response = await DioClient.instance.post(
        '/auth/login',
        data: {
          'phoneNumber': phoneNumber,
          'pin': pin,
        },
      );
      
      return AuthTokensModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
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
    try {
      await DioClient.instance.post(
        '/auth/register',
        data: {
          'phoneNumber': phoneNumber,
          'fullName': fullName,
          'dateOfBirth': dateOfBirth,
          'nationalId': nationalId,
          'email': email,
          'pin': pin,
          'consentGiven': consentGiven,
          'consentVersion': consentVersion,
        },
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<void> requestOtp({required String phoneNumber}) async {
    try {
      await DioClient.instance.post(
        '/auth/otp/request',
        data: {'phoneNumber': phoneNumber},
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<void> verifyOtp({required String phoneNumber, required String code}) async {
    try {
      await DioClient.instance.post(
        '/auth/otp/verify',
        data: {
          'phoneNumber': phoneNumber,
          'code': code,
        },
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<void> createPin({required String pin}) async {
    try {
      await DioClient.instance.post(
        '/auth/pin',
        data: {'pin': pin},
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<UserModel> getProfile() async {
    try {
      final response = await DioClient.instance.get('/users/profile');
      return UserModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<void> logout() async {
    try {
      await DioClient.instance.post('/auth/logout');
    } on DioException catch (e) {
      // Ignore logout errors
    }
  }
  
  @override
  Future<void> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    try {
      await DioClient.instance.post(
        '/users/pin',
        data: {
          'currentPin': currentPin,
          'newPin': newPin,
        },
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<void> refreshToken() async {
    try {
      final refreshToken = await DioClient.getRefreshToken();
      if (refreshToken == null) throw const AuthenticationException();
      
      await DioClient.instance.post(
        '/auth/refresh',
        data: {'refreshToken': refreshToken},
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<RegistrationFeeModel> getRegistrationFee() async {
    try {
      final response = await DioClient.instance.get('/auth/registration-fee');
      return RegistrationFeeModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<String> initiateRegistrationFeePayment({required String phoneNumber}) async {
    try {
      final response = await DioClient.instance.post(
        '/auth/registration-fee/pay',
        data: {'phoneNumber': phoneNumber},
      );
      return response.data['checkoutRequestId'] as String;
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }

  @override
  Future<RegistrationFeeStatusModel> checkRegistrationFeeStatus({required String phoneNumber}) async {
    try {
      final response = await DioClient.instance.get('/auth/registration-fee/status/$phoneNumber');
      return RegistrationFeeStatusModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}