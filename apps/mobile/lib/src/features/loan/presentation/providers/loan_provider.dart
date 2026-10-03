import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/core/errors/exceptions.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_application_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_offer_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_detail_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/repayment_model.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_history_model.dart';
import 'package:pesaloan/src/features/loan/domain/repositories/loan_repository.dart';
import 'package:pesaloan/src/features/loan/data/repositories/loan_repository_impl.dart';

class LoanState {
  final bool isLoading;
  final String? error;
  final LoanApplicationModel? application;
  final LoanOfferModel? offer;
  final LoanDetailModel? detail;
  final RepaymentDetailModel? repaymentDetail;
  final List<LoanHistoryModel> history;
  
  const LoanState({
    this.isLoading = false,
    this.error,
    this.application,
    this.offer,
    this.detail,
    this.repaymentDetail,
    this.history = const [],
  });
  
  LoanState copyWith({
    bool? isLoading,
    String? error,
    LoanApplicationModel? application,
    LoanOfferModel? offer,
    LoanDetailModel? detail,
    RepaymentDetailModel? repaymentDetail,
    List<LoanHistoryModel>? history,
  }) {
    return LoanState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      application: application ?? this.application,
      offer: offer ?? this.offer,
      detail: detail ?? this.detail,
      repaymentDetail: repaymentDetail ?? this.repaymentDetail,
      history: history ?? this.history,
    );
  }
}

class LoanNotifier extends StateNotifier<LoanState> {
  final LoanRepository _repository;
  
  LoanNotifier(this._repository) : super(const LoanState());
  
  Future<void> applyForLoan({
    required int amount,
    required int termDays,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final application = await _repository.applyForLoan(
        amount: amount,
        termDays: termDays,
      );
      
      state = state.copyWith(
        isLoading: false,
        application: application,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }
  
  Future<LoanOfferModel> getLoanOffer(String loanId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final offer = await _repository.getLoanOffer(loanId);
      state = state.copyWith(isLoading: false, offer: offer);
      return offer;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }
  
  Future<void> acceptLoan({
    required String loanId,
    required String agreementVersion,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.acceptLoan(
        loanId: loanId,
        agreementVersion: agreementVersion,
      );
      
      state = state.copyWith(isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }
  
  Future<LoanDetailModel> getLoanDetail(String loanId) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final detail = await _repository.getLoanDetail(loanId);
      state = state.copyWith(isLoading: false, detail: detail);
      return detail;
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }
  
  Future<RepaymentDetailModel> getRepaymentDetail(String loanId) async {
    try {
      final detail = await _repository.getRepaymentDetail(loanId);
      state = state.copyWith(repaymentDetail: detail);
      return detail;
    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }
  
  Future<void> initiateRepayment({
    required String loanId,
    required int amount,
  }) async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      await _repository.initiateRepayment(loanId: loanId, amount: amount);
      state = state.copyWith(isLoading: false);
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
      rethrow;
    }
  }
  
  Future<List<LoanHistoryModel>> getLoanHistory({
    required int page,
    required int limit,
  }) async {
    try {
      final history = await _repository.getLoanHistory(page: page, limit: limit);
      return history;
    } on AppException catch (e) {
      state = state.copyWith(error: e.message);
      rethrow;
    }
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final loanRepositoryProvider = Provider<LoanRepository>((ref) {
  return LoanRepositoryImpl();
});

final loanProvider = StateNotifierProvider<LoanNotifier, LoanState>((ref) {
  final repository = ref.watch(loanRepositoryProvider);
  return LoanNotifier(repository);
});