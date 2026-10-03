// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_offer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanOfferModelImpl _$$LoanOfferModelImplFromJson(Map<String, dynamic> json) =>
    _$LoanOfferModelImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toInt(),
      termDays: (json['termDays'] as num).toInt(),
      interest: (json['interest'] as num).toInt(),
      fees: (json['fees'] as num).toInt(),
      totalPayable: (json['totalPayable'] as num).toInt(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      agreementVersion: json['agreementVersion'] as String,
      agreementUrl: json['agreementUrl'] as String,
      expiresAt: json['expiresAt'] as String,
    );

Map<String, dynamic> _$$LoanOfferModelImplToJson(
        _$LoanOfferModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'termDays': instance.termDays,
      'interest': instance.interest,
      'fees': instance.fees,
      'totalPayable': instance.totalPayable,
      'dueDate': instance.dueDate.toIso8601String(),
      'agreementVersion': instance.agreementVersion,
      'agreementUrl': instance.agreementUrl,
      'expiresAt': instance.expiresAt,
    };
