import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:reactive_forms/reactive_forms.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/loan/presentation/providers/loan_provider.dart';
import 'package:pesaloan/src/features/loan/domain/models/repayment_model.dart';

class RepaymentScreen extends ConsumerStatefulWidget {
  final String loanId;
  
  const RepaymentScreen({super.key, required this.loanId});
  
  @override
  ConsumerState<RepaymentScreen> createState() => _RepaymentScreenState();
}

class _RepaymentScreenState extends ConsumerState<RepaymentScreen> {
  final _form = FormGroup({
    'amount': FormControl<double>(validators: [
      Validators.required,
      Validators.min(1),
    ]),
  });
  
  bool _isLoading = false;
  RepaymentDetailModel? _detail;
  
  @override
  void initState() {
    super.initState();
    _loadDetail();
  }
  
  Future<void> _loadDetail() async {
    try {
      final detail = await ref.read(loanProvider.notifier).getRepaymentDetail(widget.loanId);
      if (mounted) {
        setState(() {
          _detail = detail;
          _form.control('amount').value = detail.outstandingBalance.toDouble();
        });
      }
    } catch (e) {
      if (mounted) {
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
  
  Future<void> _submit() async {
    if (!_form.valid || _detail == null) return;
    
    final amount = _form.control('amount').value!.toInt();
    if (amount > _detail!.outstandingBalance) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Amount cannot exceed outstanding balance of ${AppConstants.currencySymbol}${NumberFormat('#,###').format(_detail!.outstandingBalance)}'),
          backgroundColor: AppTheme.errorRed,
        ),
      );
      return;
    }
    
    setState(() => _isLoading = true);
    
    try {
      await ref.read(loanProvider.notifier).initiateRepayment(
        loanId: widget.loanId,
        amount: amount,
      );
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Repayment initiated. Complete payment on M-Pesa.'),
            backgroundColor: AppTheme.primaryGreen,
          ),
        );
        context.go(AppConstants.routeHome);
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
  void dispose() {
    _form.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Make Repayment')),
      body: _detail == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildOutstandingCard(),
                  const SizedBox(height: 24),
                  _buildAmountInput(),
                  const SizedBox(height: 24),
                  _buildPaymentMethods(),
                  const SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(vertical: 16)),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Continue to M-Pesa'),
                  ),
                ],
              ),
            ),
    );
  }
  
  Widget _buildOutstandingCard() {
    final isOverdue = _detail!.status == 'OVERDUE';
    
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: isOverdue
              ? [AppTheme.errorRed.withOpacity(0.1), AppTheme.errorRed.withOpacity(0.05)]
              : [AppTheme.primaryGreen.withOpacity(0.1), AppTheme.primaryGreen.withOpacity(0.05)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: isOverdue ? AppTheme.errorRed.withOpacity(0.3) : AppTheme.primaryGreen.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: isOverdue ? AppTheme.errorRed.withOpacity(0.2) : AppTheme.primaryGreen.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isOverdue ? Icons.warning_outlined : Icons.credit_card_outlined,
                  color: isOverdue ? AppTheme.errorRed : AppTheme.primaryGreen,
                  size: 28,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Outstanding Balance',
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_detail!.outstandingBalance)}',
                      style: Theme.of(context).textTheme.displaySmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: isOverdue ? AppTheme.errorRed : AppTheme.primaryGreen,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildInfoItem(
                  'Due Date',
                  DateFormat('dd MMM yyyy').format(_detail!.dueDate),
                  isOverdue ? AppTheme.errorRed : null,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  isOverdue ? 'Days Overdue' : 'Days Left',
                  '${isOverdue ? _detail!.dueDate.difference(DateTime.now()).inDays.abs() : _detail!.dueDate.difference(DateTime.now()).inDays}',
                  isOverdue ? AppTheme.errorRed : null,
                ),
              ),
              Expanded(
                child: _buildInfoItem(
                  'Status',
                  _detail!.status,
                  isOverdue ? AppTheme.errorRed : AppTheme.warningAmber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  
  Widget _buildInfoItem(String label, String value, Color? valueColor) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: valueColor,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
          ),
        ),
      ],
    );
  }
  
  Widget _buildAmountInput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Repayment Amount',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        ReactiveForm(
          formGroup: _form,
          child: ReactiveTextField<double>(
            formControlName: 'amount',
            decoration: InputDecoration(
              labelText: 'Amount',
              hintText: 'Enter amount',
              prefixIcon: const Icon(Icons.attach_money_outlined),
              prefixText: '${AppConstants.currencySymbol} ',
            ),
            keyboardType: TextInputType.number,
            validationMessages: {
              ValidationMessage.required: (_) => 'Amount is required',
              ValidationMessage.min: (_) => 'Amount must be at least 1',
            },
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [1000, 2000, 5000, _detail!.outstandingBalance].map((amount) {
            return FilterChip(
              label: Text('${AppConstants.currencySymbol}${NumberFormat('#,###').format(amount)}'),
              selected: _form.control('amount').value == amount,
              onSelected: (_) => setState(() => _form.control('amount').value = amount.toDouble()),
              selectedColor: AppTheme.primaryGreen.withOpacity(0.2),
              checkmarkColor: AppTheme.primaryGreen,
              labelStyle: TextStyle(
                color: _form.control('amount').value == amount ? AppTheme.primaryGreen : Theme.of(context).colorScheme.onSurface,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
  
  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _PaymentMethodCard(
          icon: Icons.phone_android_outlined,
          title: 'M-Pesa STK Push',
          subtitle: 'Enter your M-Pesa PIN on your phone',
          isSelected: true,
          onTap: () {},
        ),
        const SizedBox(height: 12),
        _PaymentMethodCard(
          icon: Icons.account_balance_outlined,
          title: 'Airtel Money',
          subtitle: 'Pay via Airtel Money',
          isSelected: false,
          onTap: () {},
        ),
      ],
    );
  }
}

class _PaymentMethodCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool isSelected;
  final VoidCallback onTap;
  
  const _PaymentMethodCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.isSelected,
    required this.onTap,
  });
  
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.primaryGreen : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected ? AppTheme.primaryGreen.withOpacity(0.1) : Theme.of(context).colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: isSelected ? AppTheme.primaryGreen : Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppTheme.primaryGreen : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle, color: AppTheme.primaryGreen, size: 24),
          ],
        ),
      ),
    );
  }
}