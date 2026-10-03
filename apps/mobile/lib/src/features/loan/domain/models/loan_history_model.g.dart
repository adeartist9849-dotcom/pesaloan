// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanHistoryModelImpl _$$LoanHistoryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LoanHistoryModelImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toInt(),
      status: json['status'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      disbursedAt: json['disbursedAt'] == null
          ? null
          : DateTime.parse(json['disbursedAt'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
    );

Map<String, dynamic> _$$LoanHistoryModelImplToJson(
        _$LoanHistoryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'status': instance.status,
      'dueDate': instance.dueDate.toIso8601String(),
      'disbursedAt': instance.disbursedAt?.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
    };
