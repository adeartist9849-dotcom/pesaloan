// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kyc_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$KycModelImpl _$$KycModelImplFromJson(Map<String, dynamic> json) =>
    _$KycModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      status: json['status'] as String,
      provider: json['provider'] as String,
      providerReference: json['providerReference'] as String,
      verificationData: json['verificationData'] as Map<String, dynamic>,
      verifiedAt: json['verifiedAt'] as String?,
      rejectedAt: json['rejectedAt'] as String?,
      rejectionReason: json['rejectionReason'] as String?,
      expiresAt: json['expiresAt'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$KycModelImplToJson(_$KycModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'status': instance.status,
      'provider': instance.provider,
      'providerReference': instance.providerReference,
      'verificationData': instance.verificationData,
      'verifiedAt': instance.verifiedAt,
      'rejectedAt': instance.rejectedAt,
      'rejectionReason': instance.rejectionReason,
      'expiresAt': instance.expiresAt,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
