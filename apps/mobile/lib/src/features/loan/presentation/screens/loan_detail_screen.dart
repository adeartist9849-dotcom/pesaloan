import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/loan/presentation/providers/loan_provider.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_detail_model.dart';

class LoanDetailScreen extends ConsumerStatefulWidget {
  final String loanId;
  
  const LoanDetailScreen({super.key, required this.loanId});
  
  @override
  ConsumerState<LoanDetailScreen> createState() => _LoanDetailScreenState();
}

class _LoanDetailScreenState extends ConsumerState<LoanDetailScreen> {
  LoanDetailModel? _loan;
  bool _isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadLoanDetail();
  }
  
  Future<void> _loadLoanDetail() async {
    try {
      final loan = await ref.read(loanProvider.notifier).getLoanDetail(widget.loanId);
      if (mounted) {
        setState(() {
          _loan = loan;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _isLoading = false);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('AppException: ', '')),
            backgroundColor: AppTheme.errorRed,
          ),
        );
        context.go(AppConstants.routeHome);
      }
    }
  }
  
  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    if (_loan == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Loan Details')),
        body: const Center(child: Text('Loan not found')),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: Text('Loan #${_loan!.id.substring(0, 8).toUpperCase()}'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildStatusCard(),
            const SizedBox(height: 24),
            _buildDetailCard(
              title: 'Loan Summary',
              children: [
                _buildDetailRow('Principal', '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_loan!.principal)}'),
                _buildDetailRow('Interest', '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_loan!.interest)}'),
                _buildDetailRow('Fees', '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_loan!.fees)}'),
                const Divider(height: 24),
                _buildDetailRow('Total Payable', '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_loan!.totalPayable)}', isTotal: true),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailCard(
              title: 'Schedule',
              children: [
                _buildDetailRow('Term', '${_loan!.termDays} days'),
                _buildDetailRow('Disbursed', _loan!.disbursedAt != null ? DateFormat('dd MMM yyyy HH:mm').format(_loan!.disbursedAt!) : 'Pending', icon: Icons.arrow_downward_outlined),
                _buildDetailRow('Due Date', DateFormat('dd MMM yyyy').format(_loan!.dueDate), icon: Icons.calendar_today_outlined),
                if (_loan!.paidAt != null)
                  _buildDetailRow('Paid On', DateFormat('dd MMM yyyy HH:mm').format(_loan!.paidAt!), icon: Icons.check_circle_outlined),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailCard(
              title: 'Transactions',
              children: _loan!.transactions.map((txn) => _buildTransactionTile(txn)).toList(),
            ),
            const SizedBox(height: 24),
            _buildDetailCard(
              title: 'Repayments',
              children: _loan!.repayments.map((repayment) => _buildRepaymentTile(repayment)).toList(),
            ),
            const SizedBox(height: 32),
            if (_loan!.status == 'ACTIVE' || _loan!.status == 'OVERDUE')
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go('${AppConstants.routeRepayment}?loanId=${_loan!.id}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: _loan!.status == 'OVERDUE' ? AppTheme.errorRed : AppTheme.primaryGreen,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _loan!.status == 'OVERDUE' ? 'Pay Now (Overdue)' : 'Make Payment',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildStatusCard() {
    Color statusColor;
    IconData statusIcon;
    
    switch (_loan!.status) {
      case 'ACTIVE':
        statusColor = AppTheme.primaryGreen;
        statusIcon = Icons.credit_card;
        break;
      case 'OVERDUE':
        statusColor = AppTheme.errorRed;
        statusIcon = Icons.warning;
        break;
      case 'PAID':
        statusColor = AppTheme.successGreen;
        statusIcon = Icons.check_circle;
        break;
      case 'PENDING':
        statusColor = AppTheme.warningAmber;
        statusIcon = Icons.hourglass_empty;
        break;
      default:
        statusColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
        statusIcon = Icons.help;
    }
    
    final daysUntilDue = _loan!.dueDate.difference(DateTime.now()).inDays;
    final isOverdue = daysUntilDue < 0 && _loan!.status == 'ACTIVE';
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            statusColor.withOpacity(0.1),
            statusColor.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(statusIcon, color: statusColor, size: 32),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _loan!.status,
                      style: TextStyle(
                        color: statusColor,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      'Outstanding: ${AppConstants.currencySymbol}${NumberFormat('#,###').format(_loan!.outstandingBalance)}',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _buildInfoColumn(
                  'Due Date',
                  DateFormat('dd MMM yyyy').format(_loan!.dueDate),
                  isOverdue ? AppTheme.errorRed : null,
                ),
              ),
              Container(width: 1, height: 40, color: Theme.of(context).colorScheme.outline),
              Expanded(
                child: _buildInfoColumn(
                  isOverdue ? 'Days Overdue' : 'Days Remaining',
                  '${isOverdue ? daysUntilDue.abs() : daysUntilDue}',
                  isOverdue ? AppTheme.errorRed : null,
                ),
              ),
              Container(width: 1, height: 40, color: Theme.of(context).colorScheme.outline),
              Expanded(
                child: _buildInfoColumn(
                  'Agreement',
                  'v${_loan!.agreementVersion}',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoColumn(String label, String value, [Color? valueColor]) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
  
  Widget _buildDetailCard({
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Theme.of(context).colorScheme.outline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildDetailRow(String label, String value, {bool isTotal = false, IconData? icon}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
            const SizedBox(width: 12),
          ],
          Expanded(
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: isTotal ? AppTheme.primaryGreen : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildTransactionTile(TransactionModel txn) {
    Color typeColor;
    IconData typeIcon;
    
    switch (txn.type) {
      case 'DISBURSEMENT':
        typeColor = AppTheme.primaryGreen;
        typeIcon = Icons.arrow_downward;
        break;
      case 'REPAYMENT':
        typeColor = AppTheme.successGreen;
        typeIcon = Icons.arrow_upward;
        break;
      case 'FEE':
      case 'PENALTY':
        typeColor = AppTheme.errorRed;
        typeIcon = Icons.remove_circle;
        break;
      default:
        typeColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
        typeIcon = Icons.help;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: typeColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(typeIcon, color: typeColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  txn.type,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: typeColor,
                  ),
                ),
                Text(
                  txn.description,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${txn.type == 'REPAYMENT' || txn.type == 'DISBURSEMENT' ? '+' : '-'}${AppConstants.currencySymbol}${NumberFormat('#,###').format(txn.amount)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: typeColor,
                ),
              ),
              Text(
                DateFormat('dd MMM HH:mm').format(txn.createdAt),
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildRepaymentTile(RepaymentModel repayment) {
    Color statusColor;
    IconData statusIcon;
    
    switch (repayment.status) {
      case 'COMPLETED':
        statusColor = AppTheme.successGreen;
        statusIcon = Icons.check_circle;
        break;
      case 'PROCESSING':
        statusColor = AppTheme.warningAmber;
        statusIcon = Icons.hourglass_empty;
        break;
      case 'FAILED':
        statusColor = AppTheme.errorRed;
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
        statusIcon = Icons.help;
    }
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(statusIcon, color: statusColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Repayment',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Ref: ${repayment.transactionReference}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${AppConstants.currencySymbol}${NumberFormat('#,###').format(repayment.amount)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: statusColor,
                ),
              ),
              Text(
                repayment.paidAt != null
                    ? DateFormat('dd MMM HH:mm').format(repayment.paidAt!)
                    : 'Pending',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}