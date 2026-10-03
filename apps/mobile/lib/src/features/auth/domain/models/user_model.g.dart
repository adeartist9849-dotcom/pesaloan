// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserModelImpl _$$UserModelImplFromJson(Map<String, dynamic> json) =>
    _$UserModelImpl(
      id: json['id'] as String,
      phoneNumber: json['phoneNumber'] as String,
      fullName: json['fullName'] as String,
      dateOfBirth: json['dateOfBirth'] as String,
      nationalId: json['nationalId'] as String,
      email: json['email'] as String?,
      status: json['status'] as String,
      kycStatus: json['kycStatus'] as String,
      loanLimit: (json['loanLimit'] as num).toInt(),
      lastLoginAt: json['lastLoginAt'] as String?,
      failedLoginAttempts: (json['failedLoginAttempts'] as num).toInt(),
      lockedUntil: json['lockedUntil'] as String?,
      createdAt: json['createdAt'] as String,
      updatedAt: json['updatedAt'] as String,
    );

Map<String, dynamic> _$$UserModelImplToJson(_$UserModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'phoneNumber': instance.phoneNumber,
      'fullName': instance.fullName,
      'dateOfBirth': instance.dateOfBirth,
      'nationalId': instance.nationalId,
      'email': instance.email,
      'status': instance.status,
      'kycStatus': instance.kycStatus,
      'loanLimit': instance.loanLimit,
      'lastLoginAt': instance.lastLoginAt,
      'failedLoginAttempts': instance.failedLoginAttempts,
      'lockedUntil': instance.lockedUntil,
      'createdAt': instance.createdAt,
      'updatedAt': instance.updatedAt,
    };
