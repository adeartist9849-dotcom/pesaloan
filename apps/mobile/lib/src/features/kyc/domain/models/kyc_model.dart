import 'package:freezed_annotation/freezed_annotation.dart';

part 'kyc_model.freezed.dart';
part 'kyc_model.g.dart';

@freezed
class KycModel with _$KycModel {
  const factory KycModel({
    required String id,
    required String userId,
    required String status,
    required String provider,
    required String providerReference,
    required Map<String, dynamic> verificationData,
    String? verifiedAt,
    String? rejectedAt,
    String? rejectionReason,
    String? expiresAt,
    required String createdAt,
    required String updatedAt,
  }) = _KycModel;
  
  factory KycModel.fromJson(Map<String, dynamic> json) => _$KycModelFromJson(json);
}