import 'package:dio/dio.dart';
import 'package:pesaloan/src/core/network/dio_client.dart';
import 'package:pesaloan/src/core/errors/exceptions.dart';
import 'package:pesaloan/src/features/loan/domain/repositories/loan_repository.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_application_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_offer_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_detail_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/repayment_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_history_model.dart';

class LoanRepositoryImpl implements LoanRepository {
  @override
  Future<LoanApplicationModel> applyForLoan({
    required int amount,
    required int termDays,
  }) async {
    try {
      final response = await DioClient.instance.post(
        '/loans/apply',
        data: {
          'amount': amount,
          'termDays': termDays,
        },
      );
      return LoanApplicationModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<LoanOfferModel> getLoanOffer(String loanId) async {
    try {
      final response = await DioClient.instance.get('/loans/offer/$loanId');
      return LoanOfferModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<void> acceptLoan({
    required String loanId,
    required String agreementVersion,
  }) async {
    try {
      await DioClient.instance.post(
        '/loans/accept',
        data: {
          'loanId': loanId,
          'agreementVersion': agreementVersion,
        },
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<LoanDetailModel> getLoanDetail(String loanId) async {
    try {
      final response = await DioClient.instance.get('/loans/$loanId');
      return LoanDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<RepaymentDetailModel> getRepaymentDetail(String loanId) async {
    try {
      final response = await DioClient.instance.get('/loans/repay/$loanId');
      return RepaymentDetailModel.fromJson(response.data);
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<void> initiateRepayment({
    required String loanId,
    required int amount,
  }) async {
    try {
      await DioClient.instance.post(
        '/loans/repay',
        data: {
          'loanId': loanId,
          'amount': amount,
        },
      );
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
  
  @override
  Future<List<LoanHistoryModel>> getLoanHistory({
    required int page,
    required int limit,
  }) async {
    try {
      final response = await DioClient.instance.get(
        '/loans/history',
        queryParameters: {
          'page': page,
          'limit': limit,
        },
      );
      
      final List data = response.data['data'] ?? [];
      return data.map((json) => LoanHistoryModel.fromJson(json)).toList();
    } on DioException catch (e) {
      throw e.toAppException();
    }
  }
}