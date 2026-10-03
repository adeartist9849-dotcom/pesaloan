// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_application_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanApplicationModelImpl _$$LoanApplicationModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LoanApplicationModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      requestedAmount: (json['requestedAmount'] as num).toInt(),
      requestedTermDays: (json['requestedTermDays'] as num).toInt(),
      status: json['status'] as String,
      score: (json['score'] as num?)?.toInt(),
      decisionReason: json['decisionReason'] as String?,
      createdAt: json['createdAt'] as String,
      expiresAt: json['expiresAt'] as String,
    );

Map<String, dynamic> _$$LoanApplicationModelImplToJson(
        _$LoanApplicationModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'requestedAmount': instance.requestedAmount,
      'requestedTermDays': instance.requestedTermDays,
      'status': instance.status,
      'score': instance.score,
      'decisionReason': instance.decisionReason,
      'createdAt': instance.createdAt,
      'expiresAt': instance.expiresAt,
    };
