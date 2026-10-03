import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/loan/presentation/providers/loan_provider.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_history_model.dart';

class LoanHistoryScreen extends ConsumerStatefulWidget {
  const LoanHistoryScreen({super.key});
  
  @override
  ConsumerState<LoanHistoryScreen> createState() => _LoanHistoryScreenState();
}

class _LoanHistoryScreenState extends ConsumerState<LoanHistoryScreen> {
  final _scrollController = ScrollController();
  bool _isLoadingMore = false;
  int _page = 1;
  final int _limit = 20;
  List<LoanHistoryModel> _loans = [];
  bool _hasMore = true;
  
  @override
  void initState() {
    super.initState();
    _loadLoans();
    _scrollController.addListener(_onScroll);
  }
  
  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }
  
  void _onScroll() {
    if (_scrollController.position.pixels >= _scrollController.position.maxScrollExtent - 200) {
      _loadMore();
    }
  }
  
  Future<void> _loadLoans({bool refresh = false}) async {
    if (refresh) {
      _page = 1;
      _loans = [];
      _hasMore = true;
    }
    
    if (!_hasMore || _isLoadingMore) return;
    
    setState(() => _isLoadingMore = true);
    
    try {
      final newLoans = await ref.read(loanProvider.notifier).getLoanHistory(
        page: _page,
        limit: _limit,
      );
      
      if (mounted) {
        setState(() {
          _loans.addAll(newLoans);
          _page++;
          _hasMore = newLoans.length == _limit;
          _isLoadingMore = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoadingMore = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('AppException: ', '')),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    }
  }
  
  Future<void> _loadMore() async {
    await _loadLoans();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan History')),
      body: _loans.isEmpty && !_isLoadingMore
          ? _buildEmptyState()
          : RefreshIndicator(
              onRefresh: () => _loadLoans(refresh: true),
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: _loans.length + (_hasMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index == _loans.length) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),
                    );
                  }
                  
                  final loan = _loans[index];
                  return _LoanHistoryTile(
                    loan: loan,
                    onTap: () => context.go('${AppConstants.routeLoanDetail}/${loan.id}'),
                  );
                },
              ),
            ),
    );
  }
  
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No Loan History',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your loan applications and repayments will appear here',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () => context.go(AppConstants.routeLoanApply),
              child: const Text('Apply for Your First Loan'),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoanHistoryTile extends StatelessWidget {
  final LoanHistoryModel loan;
  final VoidCallback onTap;
  
  const _LoanHistoryTile({
    required this.loan,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    Color statusColor;
    IconData statusIcon;
    
    switch (loan.status) {
      case 'PAID':
        statusColor = AppTheme.successGreen;
        statusIcon = Icons.check_circle;
        break;
      case 'ACTIVE':
        statusColor = AppTheme.primaryGreen;
        statusIcon = Icons.credit_card;
        break;
      case 'OVERDUE':
        statusColor = AppTheme.errorRed;
        statusIcon = Icons.warning;
        break;
      case 'PENDING':
        statusColor = AppTheme.warningAmber;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'DECLINED':
        statusColor = AppTheme.errorRed;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
        statusIcon = Icons.help;
    }
    
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Theme.of(context).colorScheme.outline),
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(statusIcon, color: statusColor, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Loan #${loan.id.substring(0, 8).toUpperCase()}',
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: statusColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          loan.status,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: statusColor,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${AppConstants.currencySymbol}${NumberFormat('#,###').format(loan.amount)}',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Due: ${DateFormat('dd MMM yyyy').format(loan.dueDate)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (loan.disbursedAt != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    loan.status == 'PAID'
                        ? 'Paid ${DateFormat('dd MMM').format(loan.paidAt!)}'
                        : 'Disbursed ${DateFormat('dd MMM').format(loan.disbursedAt!)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.chevron_right,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}