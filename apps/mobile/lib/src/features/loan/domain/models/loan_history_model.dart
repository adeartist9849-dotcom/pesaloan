import 'package:freezed_annotation/freezed_annotation.dart';

part 'loan_history_model.freezed.dart';
part 'loan_history_model.g.dart';

@freezed
class LoanHistoryModel with _$LoanHistoryModel {
  const factory LoanHistoryModel({
    required String id,
    required int amount,
    required String status,
    required DateTime dueDate,
    DateTime? disbursedAt,
    DateTime? paidAt,
  }) = _LoanHistoryModel;
  
  factory LoanHistoryModel.fromJson(Map<String, dynamic> json) => _$LoanHistoryModelFromJson(json);
}