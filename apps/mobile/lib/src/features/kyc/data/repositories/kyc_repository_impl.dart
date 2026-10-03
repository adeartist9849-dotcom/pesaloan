import 'package:dio/dio.dart';
import 'package:pesaloan/src/core/network/dio_client.dart';
import 'package:pesaloan/src/core/errors/exceptions.dart';
import 'package:pesaloan/src/features/kyc/domain/repositories/kyc_repository.dart';
import 'package:pesaloan/src/features/kyc/domain/models/kyc_model.dart';

class KycRepositoryImpl implements KycRepository {
  @override
  Future<KycModel?> getKycStatus() async {
    try {
      final response = await DioClient.instance.get('/kyc/status');
      if (response.data == null) return null;
      return KycModel.fromJson(response.data);
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) return null;
      throw e.toAppException();
    }
  }
  
  @override
  Future<void> submitKyc({
    required String nationalId,
    String? idFrontImage,
    String? idBackImage,
    String? selfieImage,
  }) async {
    try {
      await DioClient.instance.post(
        '/kyc/submit',
        data: {
          'nationalId': nationalId,
          'idFrontImage': idFrontImage,
          'idBackImage': idBackImage,
          'selfieImage': selfieImage,
        },
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}