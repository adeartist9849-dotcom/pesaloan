// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'dashboard_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$DashboardModelImpl _$$DashboardModelImplFromJson(Map<String, dynamic> json) =>
    _$DashboardModelImpl(
      user: UserSummaryModel.fromJson(json['user'] as Map<String, dynamic>),
      availableLimit: (json['availableLimit'] as num).toInt(),
      currentLoan: json['currentLoan'] == null
          ? null
          : LoanSummaryModel.fromJson(
              json['currentLoan'] as Map<String, dynamic>),
      recentLoans: (json['recentLoans'] as List<dynamic>)
          .map((e) => LoanSummaryModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$DashboardModelImplToJson(
        _$DashboardModelImpl instance) =>
    <String, dynamic>{
      'user': instance.user,
      'availableLimit': instance.availableLimit,
      'currentLoan': instance.currentLoan,
      'recentLoans': instance.recentLoans,
    };

_$UserSummaryModelImpl _$$UserSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$UserSummaryModelImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      loanLimit: (json['loanLimit'] as num).toInt(),
      kycStatus: json['kycStatus'] as String,
    );

Map<String, dynamic> _$$UserSummaryModelImplToJson(
        _$UserSummaryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'loanLimit': instance.loanLimit,
      'kycStatus': instance.kycStatus,
    };

_$LoanSummaryModelImpl _$$LoanSummaryModelImplFromJson(
        Map<String, dynamic> json) =>
    _$LoanSummaryModelImpl(
      id: json['id'] as String,
      amount: (json['amount'] as num).toInt(),
      status: json['status'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      outstandingBalance: (json['outstandingBalance'] as num).toInt(),
      disbursedAt: json['disbursedAt'] == null
          ? null
          : DateTime.parse(json['disbursedAt'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
    );

Map<String, dynamic> _$$LoanSummaryModelImplToJson(
        _$LoanSummaryModelImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'amount': instance.amount,
      'status': instance.status,
      'dueDate': instance.dueDate.toIso8601String(),
      'outstandingBalance': instance.outstandingBalance,
      'disbursedAt': instance.disbursedAt?.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
    };
