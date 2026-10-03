import 'package:pesaloan/src/features/kyc/domain/models/kyc_model.dart';

abstract class KycRepository {
  Future<KycModel?> getKycStatus();
  Future<void> submitKyc({
    required String nationalId,
    String? idFrontImage,
    String? idBackImage,
    String? selfieImage,
  });
}