import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/loan/presentation/providers/loan_provider.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_application_model.dart';
import 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';

class LoanApplicationScreen extends ConsumerStatefulWidget {
  const LoanApplicationScreen({super.key});
  
  @override
  ConsumerState<LoanApplicationScreen> createState() => _LoanApplicationScreenState();
}

class _LoanApplicationScreenState extends ConsumerState<LoanApplicationScreen> {
  final _form = FormGroup({
    'amount': FormControl<double>(validators: [
      Validators.required,
      Validators.min(AppConstants.minLoanAmount.toDouble()),
      Validators.max(AppConstants.maxLoanAmount.toDouble()),
    ]),
    'termDays': FormControl<int>(validators: [
      Validators.required,
      Validators.min(AppConstants.minLoanTermDays),
      Validators.max(AppConstants.maxLoanTermDays),
    ]),
  });
  
  bool _isLoading = false;
  double _selectedAmount = AppConstants.minLoanAmount.toDouble();
  int _selectedTerm = AppConstants.minLoanTermDays;
  
  @override
  void initState() {
    super.initState();
    _form.control('amount').value = _selectedAmount;
    _form.control('termDays').value = _selectedTerm;
  }
  
  @override
  void dispose() {
    _form.dispose();
    super.dispose();
  }
  
  void _onAmountChanged(double value) {
    setState(() {
      _selectedAmount = value;
      _form.control('amount').value = value;
    });
  }
  
  void _onTermChanged(int value) {
    setState(() {
      _selectedTerm = value;
      _form.control('termDays').value = value;
    });
  }
  
  Future<void> _submit() async {
    if (!_form.valid) {
      _form.markAllAsTouched();
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await ref.read(loanProvider.notifier).applyForLoan(
        amount: _selectedAmount.toInt(),
        termDays: _selectedTerm,
      );
      
      if (mounted) {
        context.go('${AppConstants.routeLoanOffer}?loanId=latest');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('AppException: ', '')),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  @override
  Widget build(BuildContext context) {
    final loanState = ref.watch(loanProvider);
    final user = ref.watch(authStateProvider).user;
    final availableLimit = user?.loanLimit ?? 0;
    
    final interest = _calculateInterest(_selectedAmount, _selectedTerm);
    final fees = _calculateFees(_selectedAmount);
    final totalRepayment = _selectedAmount + interest + fees;
    final dueDate = DateTime.now().add(Duration(days: _selectedTerm));
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Apply for Loan'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildLimitCard(availableLimit),
            const SizedBox(height: 24),
            _buildAmountSelector(),
            const SizedBox(height: 24),
            _buildTermSelector(),
            const SizedBox(height: 24),
            _buildCostBreakdown(
              amount: _selectedAmount,
              termDays: _selectedTerm,
              interest: interest,
              fees: fees,
              totalRepayment: totalRepayment,
              dueDate: dueDate,
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed: _isLoading || _selectedAmount > availableLimit ? null : _submit,
              child: _isLoading
                  ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Continue to Review'),
            ),
            if (_selectedAmount > availableLimit) ...[
              const SizedBox(height: 12),
              Text(
                'Amount exceeds your available limit of ${AppConstants.currencySymbol}${NumberFormat('#,###').format(availableLimit)}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: AppTheme.errorRed,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
  
  Widget _buildLimitCard(int limit) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.account_balance_wallet_outlined, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Your Loan Limit',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  '${AppConstants.currencySymbol}${NumberFormat('#,###').format(limit)}',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildAmountSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Loan Amount',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_selectedAmount.toInt())}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppTheme.primaryGreen,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.primaryGreen,
            inactiveTrackColor: AppTheme.primaryGreen.withOpacity(0.2),
            thumbColor: AppTheme.primaryGreen,
            overlayColor: AppTheme.primaryGreen.withOpacity(0.2),
            valueIndicatorColor: AppTheme.primaryGreen,
            valueIndicatorTextStyle: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
            trackHeight: 4,
          ),
          child: Slider(
            value: _selectedAmount,
            min: AppConstants.minLoanAmount.toDouble(),
            max: AppConstants.maxLoanAmount.toDouble(),
            divisions: ((AppConstants.maxLoanAmount - AppConstants.minLoanAmount) / 500).round(),
            label: '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_selectedAmount.toInt())}',
            onChanged: _onAmountChanged,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${AppConstants.currencySymbol}${NumberFormat('#,###').format(AppConstants.minLoanAmount)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
            Text(
              '${AppConstants.currencySymbol}${NumberFormat('#,###').format(AppConstants.maxLoanAmount)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ],
    );
  }
  
  Widget _buildTermSelector() {
    final terms = [7, 14, 21, 30, 45, 60, 90];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repayment Period',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: terms.map((term) {
            final isSelected = _selectedTerm == term;
            return FilterChip(
              label: Text('${term} days'),
              selected: isSelected,
              onSelected: (_) => _onTermChanged(term),
              selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryGreen,
              labelStyle: TextStyle(
                color: isSelected ? AppTheme.primaryGreen : Theme.of(context).colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              ),
              side: BorderSide(
                color: isSelected ? AppTheme.primaryGreen : Theme.of(context).colorScheme.outline,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildCostBreakdown({
    required double amount,
    required int termDays,
    required double interest,
    required double fees,
    required double totalRepayment,
    required DateTime dueDate,
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
            'Total Cost Breakdown',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 16),
          _buildCostRow('Amount Requested', '${AppConstants.currencySymbol}${NumberFormat('#,###').format(amount.toInt())}'),
          _buildCostRow('Interest (${_getInterestRate()}%)', '${AppConstants.currencySymbol}${NumberFormat('#,###').format(interest.toInt())}'),
          _buildCostRow('Processing Fee (${_getFeeRate()}%)', '${AppConstants.currencySymbol}${NumberFormat('#,###').format(fees.toInt())}'),
          const Divider(height: 24),
          _buildCostRow(
            'Total Repayment',
            '${AppConstants.currencySymbol}${NumberFormat('#,###').format(totalRepayment.toInt())}',
            isTotal: true,
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Icon(Icons.calendar_today_outlined, size: 18, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
              const SizedBox(width: 8),
              Text(
                'Due Date: ${DateFormat('dd MMM yyyy').format(dueDate)}',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildCostRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w600 : FontWeight.w400,
              color: isTotal ? Theme.of(context).colorScheme.onSurface : Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
            ),
          ),
          Text(
            value,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? AppTheme.primaryGreen : Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
  
  double _calculateInterest(double amount, int termDays) {
    const annualRate = 0.15; // 15% per annum
    return amount * annualRate * (termDays / 365);
  }
  
  double _calculateFees(double amount) {
    const feeRate = 0.05; // 5% processing fee
    return amount * feeRate;
  }
  
  double _getInterestRate() => 15.0;
  double _getFeeRate() => 5.0;
}