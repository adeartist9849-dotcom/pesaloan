// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'loan_detail_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$LoanDetailModelImpl _$$LoanDetailModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LoanDetailModelImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      applicationId: json['applicationId'] as String,
      principal: (json['principal'] as num).toInt(),
      interest: (json['interest'] as num).toInt(),
      fees: (json['fees'] as num).toInt(),
      totalPayable: (json['totalPayable'] as num).toInt(),
      termDays: (json['termDays'] as num).toInt(),
      disbursedAmount: (json['disbursedAmount'] as num).toInt(),
      outstandingBalance: (json['outstandingBalance'] as num).toInt(),
      status: json['status'] as String,
      disbursedAt: json['disbursedAt'] == null
          ? null
          : DateTime.parse(json['disbursedAt'] as String),
      dueDate: DateTime.parse(json['dueDate'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      agreementVersion: json['agreementVersion'] as String,
      agreementAcceptedAt: json['agreementAcceptedAt'] == null
          ? null
          : DateTime.parse(json['agreementAcceptedAt'] as String),
      transactions: (json['transactions'] as List<dynamic>)
          .map((e) => TransactionModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      repayments: (json['repayments'] as List<dynamic>)
          .map((e) => RepaymentModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$LoanDetailModelImplToJson(
        _$LoanDetailModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'applicationId': instance.applicationId,
      'principal': instance.principal,
      'interest': instance.interest,
      'fees': instance.fees,
      'totalPayable': instance.totalPayable,
      'termDays': instance.termDays,
      'disbursedAmount': instance.disbursedAmount,
      'outstandingBalance': instance.outstandingBalance,
      'status': instance.status,
      'disbursedAt': instance.disbursedAt?.toIso8601String(),
      'dueDate': instance.dueDate.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'agreementVersion': instance.agreementVersion,
      'agreementAcceptedAt': instance.agreementAcceptedAt?.toIso8601String(),
      'transactions': instance.transactions,
      'repayments': instance.repayments,
    };

_$TransactionModelImpl _$$TransactionModelImplFromJson(
        Map<String, dynamic> json) =>
    _$TransactionModelImpl(
      id: json['id'] as String,
      loanId: json['loanId'] as String,
      userId: json['userId'] as String,
      type: json['type'] as String,
      amount: (json['amount'] as num).toInt(),
      status: json['status'] as String,
      reference: json['reference'] as String,
      provider: json['provider'] as String?,
      providerReference: json['providerReference'] as String?,
      description: json['description'] as String,
      metadata: json['metadata'] as Map<String, dynamic>,
      processedAt: json['processedAt'] == null
          ? null
          : DateTime.parse(json['processedAt'] as String),
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$TransactionModelImplToJson(
        _$TransactionModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loanId': instance.loanId,
      'userId': instance.userId,
      'type': instance.type,
      'amount': instance.amount,
      'status': instance.status,
      'reference': instance.reference,
      'provider': instance.provider,
      'providerReference': instance.providerReference,
      'description': instance.description,
      'metadata': instance.metadata,
      'processedAt': instance.processedAt?.toIso8601String(),
      'createdAt': instance.createdAt.toIso8601String(),
    };

_$RepaymentModelImpl _$$RepaymentModelImplFromJson(Map<String, dynamic> json) =>
    _$RepaymentModelImpl(
      id: json['id'] as String,
      loanId: json['loanId'] as String,
      userId: json['userId'] as String,
      amount: (json['amount'] as num).toInt(),
      transactionReference: json['transactionReference'] as String,
      provider: json['provider'] as String,
      providerTransactionId: json['providerTransactionId'] as String?,
      status: json['status'] as String,
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      failedReason: json['failedReason'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$RepaymentModelImplToJson(
        _$RepaymentModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'loanId': instance.loanId,
      'userId': instance.userId,
      'amount': instance.amount,
      'transactionReference': instance.transactionReference,
      'provider': instance.provider,
      'providerTransactionId': instance.providerTransactionId,
      'status': instance.status,
      'paidAt': instance.paidAt?.toIso8601String(),
      'failedReason': instance.failedReason,
      'metadata': instance.metadata,
      'createdAt': instance.createdAt.toIso8601String(),
    };
