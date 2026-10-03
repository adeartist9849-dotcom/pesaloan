import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/loan/presentation/providers/loan_provider.dart';
import 'package:pesaloan/src/features/loan/domain/models/loan_offer_model.dart';

class LoanOfferScreen extends ConsumerStatefulWidget {
  final String loanId;
  
  const LoanOfferScreen({super.key, required this.loanId});
  
  @override
  ConsumerState<LoanOfferScreen> createState() => _LoanOfferScreenState();
}

class _LoanOfferScreenState extends ConsumerState<LoanOfferScreen> {
  bool _isLoading = false;
  bool _showAgreement = false;
  bool _agreementAccepted = false;
  LoanOfferModel? _offer;
  
  @override
  void initState() {
    super.initState();
    _loadOffer();
  }
  
  Future<void> _loadOffer() async {
    try {
      final offer = await ref.read(loanProvider.notifier).getLoanOffer(widget.loanId);
      if (mounted) {
        setState(() => _offer = offer);
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
  
  Future<void> _acceptLoan() async {
    if (_offer == null) return;

    if (!_agreementAccepted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please accept the Loan Agreement to proceed'),
          backgroundColor: AppTheme.warningAmber,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    
    try {
      await ref.read(loanProvider.notifier).acceptLoan(
        loanId: _offer!.id,
        agreementVersion: _offer!.agreementVersion,
      );
      
      if (mounted) {
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
  Widget build(BuildContext context) {
    if (_offer == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Loan Offer'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppTheme.primaryGreen,
                    AppTheme.primaryGreenDark,
                  ],
                ),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                children: [
                  const Icon(Icons.celebration_outlined, color: Colors.white, size: 48),
                  const SizedBox(height: 16),
                  Text(
                    'Congratulations!',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You\'re eligible for a loan of',
                    style: TextStyle(color: Colors.white.withOpacity(0.9), fontSize: 16),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_offer!.amount)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 40,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            _buildDetailCard(
              title: 'Loan Details',
              children: [
                _buildDetailRow('Loan Amount', '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_offer!.amount)}'),
                _buildDetailRow('Repayment Period', '${_offer!.termDays} days'),
                _buildDetailRow('Interest', '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_offer!.interest)}'),
                _buildDetailRow('Processing Fee', '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_offer!.fees)}'),
                const Divider(height: 24),
                _buildDetailRow(
                  'Total Repayment',
                  '${AppConstants.currencySymbol}${NumberFormat('#,###').format(_offer!.totalPayable)}',
                  isTotal: true,
                ),
                const SizedBox(height: 16),
                _buildDetailRow('Due Date', DateFormat('dd MMM yyyy').format(_offer!.dueDate), icon: Icons.calendar_today_outlined),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailCard(
              title: 'Important Information',
              icon: Icons.info_outline,
              iconColor: AppTheme.infoBlue,
              children: [
                _buildInfoItem('This loan carries a fixed interest rate for the entire term.'),
                _buildInfoItem('Late payments attract a penalty fee of 1% per day on the outstanding amount.'),
                _buildInfoItem('Early repayment is allowed with no prepayment penalty.'),
                _buildInfoItem('Default may affect your credit score and future loan eligibility.'),
              ],
            ),
            const SizedBox(height: 24),
            _buildDetailCard(
              title: 'Loan Agreement',
              icon: Icons.description_outlined,
              iconColor: AppTheme.accentOrange,
              children: [
                _buildInfoItem('By accepting, you agree to the terms and conditions in the loan agreement.'),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => setState(() => _showAgreement = true),
                  icon: const Icon(Icons.article_outlined),
                  label: const Text('View Full Agreement'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            _buildAgreementAcceptance(),
            const SizedBox(height: 32),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _isLoading ? null : () => context.go(AppConstants.routeHome),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isLoading || !_agreementAccepted ? null : _acceptLoan,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                            ),
                          )
                        : const Text('Accept Loan'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _buildAgreementAcceptance() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Loan Agreement Acceptance',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'By accepting this loan, you agree to the Loan Agreement terms including the interest rate, fees, repayment schedule, and CRB reporting.',
            style: TextStyle(fontSize: 13, height: 1.5),
          ),
          const SizedBox(height: 8),
          InkWell(
            onTap: () => context.push(AppConstants.routeLoanAgreement),
            child: const Text(
              'View Full Loan Agreement',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppTheme.primaryGreen,
                decoration: TextDecoration.underline,
              ),
            ),
          ),
          const SizedBox(height: 12),
          CheckboxListTile(
            value: _agreementAccepted,
            onChanged: (value) {
              setState(() => _agreementAccepted = value ?? false);
            },
            title: const Text(
              'I have read and agree to the Loan Agreement',
              style: TextStyle(fontSize: 13),
            ),
            controlAffinity: ListTileControlAffinity.leading,
            contentPadding: EdgeInsets.zero,
            dense: true,
            activeColor: AppTheme.primaryGreen,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required String title,
    required List<Widget> children,
    IconData? icon,
    Color? iconColor,
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
          Row(
            children: [
              if (icon != null) ...[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: (iconColor ?? AppTheme.primaryGreen).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(icon, color: iconColor ?? AppTheme.primaryGreen, size: 20),
                ),
                const SizedBox(width: 12),
              ],
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
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
  
  Widget _buildInfoItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.circle, size: 8, color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5)),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}