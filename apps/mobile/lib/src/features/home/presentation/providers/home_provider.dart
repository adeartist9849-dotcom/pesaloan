import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/core/errors/exceptions.dart';
import 'package:pesaloan/src/features/home/domain/models/dashboard_model.dart';
import 'package:pesaloan/src/features/home/domain/repositories/home_repository.dart';
import 'package:pesaloan/src/features/home/data/repositories/home_repository_impl.dart';

class HomeState {
  final bool isLoading;
  final String? error;
  final DashboardModel? dashboard;
  final UserSummaryModel? user;
  final LoanSummaryModel? currentLoan;
  final int availableLimit;
  final List<LoanSummaryModel> recentLoans;
  
  const HomeState({
    this.isLoading = false,
    this.error,
    this.dashboard,
    this.user,
    this.currentLoan,
    this.availableLimit = 0,
    this.recentLoans = const [],
  });
  
  HomeState copyWith({
    bool? isLoading,
    String? error,
    DashboardModel? dashboard,
    UserSummaryModel? user,
    LoanSummaryModel? currentLoan,
    int? availableLimit,
    List<LoanSummaryModel>? recentLoans,
  }) {
    return HomeState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      dashboard: dashboard ?? this.dashboard,
      user: user ?? this.user,
      currentLoan: currentLoan ?? this.currentLoan,
      availableLimit: availableLimit ?? this.availableLimit,
      recentLoans: recentLoans ?? this.recentLoans,
    );
  }
}

class HomeNotifier extends StateNotifier<HomeState> {
  final HomeRepository _repository;
  
  HomeNotifier(this._repository) : super(const HomeState());
  
  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);
    
    try {
      final dashboard = await _repository.getDashboard();
      
      state = state.copyWith(
        isLoading: false,
        dashboard: dashboard,
        user: dashboard.user,
        availableLimit: dashboard.availableLimit,
        currentLoan: dashboard.currentLoan,
        recentLoans: dashboard.recentLoans,
      );
    } on AppException catch (e) {
      state = state.copyWith(isLoading: false, error: e.message);
    } catch (e) {
      state = state.copyWith(isLoading: false, error: 'Failed to load dashboard');
    }
  }
  
  void clearError() {
    state = state.copyWith(error: null);
  }
}

final homeRepositoryProvider = Provider<HomeRepository>((ref) {
  return HomeRepositoryImpl();
});

final homeProvider = StateNotifierProvider<HomeNotifier, HomeState>((ref) {
  final repository = ref.watch(homeRepositoryProvider);
  return HomeNotifier(repository);
});