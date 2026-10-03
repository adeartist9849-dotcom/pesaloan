import 'package:freezed_annotation/freezed_annotation.dart';

part 'repayment_model.freezed.dart';
part 'repayment_model.g.dart';

@freezed
class RepaymentDetailModel with _$RepaymentDetailModel {
  const factory RepaymentDetailModel({
    required String loanId,
    required int outstandingBalance,
    required DateTime dueDate,
    required String status,
    required int principal,
    required int interest,
    required int fees,
    required int totalPayable,
  }) = _RepaymentDetailModel;
  
  factory RepaymentDetailModel.fromJson(Map<String, dynamic> json) => _$RepaymentDetailModelFromJson(json);
}