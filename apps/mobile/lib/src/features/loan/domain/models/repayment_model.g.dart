// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'repayment_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$RepaymentDetailModelImpl _$$RepaymentDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$RepaymentDetailModelImpl(
      loanId: json['loanId'] as String,
      outstandingBalance: (json['outstandingBalance'] as num).toInt(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      status: json['status'] as String,
      principal: (json['principal'] as num).toInt(),
      interest: (json['interest'] as num).toInt(),
      fees: (json['fees'] as num).toInt(),
      totalPayable: (json['totalPayable'] as num).toInt(),
    );

Map<String, dynamic> _$$RepaymentDetailModelImplToJson(
        _$RepaymentDetailModelImpl instance) =>
    <String, dynamic>{
      'loanId': instance.loanId,
      'outstandingBalance': instance.outstandingBalance,
      'dueDate': instance.dueDate.toIso8601String(),
      'status': instance.status,
      'principal': instance.principal,
      'interest': instance.interest,
      'fees': instance.fees,
      'totalPayable': instance.totalPayable,
    };
