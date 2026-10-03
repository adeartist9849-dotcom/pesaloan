import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:pesaloan/src/features/auth/domain/models/registration_fee_model.dart';

class RegistrationFeeScreen extends ConsumerStatefulWidget {
  final String phoneNumber;
  
  const RegistrationFeeScreen({
    super.key,
    required this.phoneNumber,
  });
  
  @override
  ConsumerState<RegistrationFeeScreen> createState() => _RegistrationFeeScreenState();
}

class _RegistrationFeeScreenState extends ConsumerState<RegistrationFeeScreen> {
  bool _isLoading = false;
  String? _checkoutRequestId;
  int _countdown = 0;
  
  @override
  void initState() {
    super.initState();
    _loadFeeAndInitiatePayment();
  }
  
  Future<void> _loadFeeAndInitiatePayment() async {
    setState(() => _isLoading = true);
    
    try {
      // Load fee info
      await ref.read(authStateProvider.notifier).loadRegistrationFee();
      
      // Initiate payment
      final checkoutRequestId = await ref.read(authStateProvider.notifier)
          .initiateRegistrationFeePayment(phoneNumber: widget.phoneNumber);
      
      _checkoutRequestId = checkoutRequestId;
      _startCountdown();
      
      // Start polling for payment status
      _pollPaymentStatus();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to initiate payment: ${e.toString().replaceFirst('AppException: ', '')}'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  void _startCountdown() {
    _countdown = 120; // 2 minutes
    Future.doWhile(() async {
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        setState(() => _countdown--);
        return _countdown > 0;
      }
      return false;
    });
  }
  
  Future<void> _pollPaymentStatus() async {
    while (mounted && _countdown > 0) {
      await Future.delayed(const Duration(seconds: 5));
      if (!mounted) break;
      
      try {
        await ref.read(authStateProvider.notifier)
            .checkRegistrationFeeStatus(phoneNumber: widget.phoneNumber);
        
        final status = ref.read(authStateProvider).registrationFeeStatus;
        if (status != null && status.paid) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Registration fee paid successfully!')),
            );
            context.go(AppConstants.routeLogin);
          }
          return;
        }
      } catch (_) {
        // Ignore polling errors
      }
    }
  }
  
  Future<void> _retryPayment() async {
    setState(() => _isLoading = true);
    
    try {
      final checkoutRequestId = await ref.read(authStateProvider.notifier)
          .initiateRegistrationFeePayment(phoneNumber: widget.phoneNumber);
      
      _checkoutRequestId = checkoutRequestId;
      _startCountdown();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to retry payment: ${e.toString().replaceFirst('AppException: ', '')}'),
            backgroundColor: AppTheme.errorRed,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  
  String _formatAmount(int amountInCents) {
    return '${AppConstants.currencySymbol}${(amountInCents / 100).toStringAsFixed(2)}';
  }

  Widget _buildDestinationInfo(RegistrationFeeModel fee) {
    IconData icon;
    String label;
    
    switch (fee.destinationType) {
      case PaymentDestinationType.mpesaTill:
        icon = Icons.store;
        label = 'M-Pesa Till';
        break;
      case PaymentDestinationType.mpesaPaybill:
        icon = Icons.account_balance;
        label = 'M-Pesa Paybill';
        break;
      case PaymentDestinationType.bankAccount:
        icon = Icons.account_balance;
        label = 'Bank Account';
        break;
      case PaymentDestinationType.mobileMoney:
        icon = Icons.phone_android;
        label = 'Mobile Money';
        break;
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Theme.of(context).colorScheme.outline.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppTheme.primaryGreen),
              const SizedBox(width: 8),
              Text(
                'Payment Destination: $label',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppTheme.primaryGreen,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: Text(
                  'Account: ${fee.destinationAccount}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontFamily: 'monospace',
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (fee.destinationName != null) ...[
            const SizedBox(height: 4),
            Text(
              fee.destinationName!,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
          if (fee.destinationBranch != null) ...[
            const SizedBox(height: 4),
            Text(
              'Branch: ${fee.destinationBranch}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
          if (fee.destinationReference != null) ...[
            const SizedBox(height: 4),
            Text(
              'Reference: ${fee.destinationReference}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
              ),
            ),
          ],
        ],
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authStateProvider);
    final fee = authState.registrationFee;
    final feeStatus = authState.registrationFeeStatus;
    
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 40),
              Icon(
                Icons.payment_outlined,
                size: 80,
                color: AppTheme.primaryGreen,
              ),
              const SizedBox(height: 24),
              Text(
                'Registration Fee Required',
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                'A one-time registration fee is required to activate your account',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              if (fee != null) ...[
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppTheme.primaryGreen.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.3)),
                  ),
                  child: Column(
                    children: [
                      Text(
                        'Registration Fee',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: AppTheme.primaryGreen,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _formatAmount(fee.amount),
                        style: Theme.of(context).textTheme.displayMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppTheme.primaryGreen,
                        ),
                      ),
                      if (fee.description != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          fee.description!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 16),
                      _buildDestinationInfo(fee),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
              
              if (_isLoading) ...[
                const Center(
                  child: CircularProgressIndicator(),
                ),
                const SizedBox(height: 24),
              ] else if (_checkoutRequestId != null) ...[
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'STK Push Sent',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We\'ve sent a payment request to your M-Pesa. Please enter your M-Pesa PIN to complete the payment.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (_countdown > 0)
                        Text(
                          'Request expires in ${(_countdown ~/ 60).toString().padLeft(2, '0')}:${(_countdown % 60).toString().padLeft(2, '0')}',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  onPressed: _countdown > 0 ? null : _retryPayment,
                  icon: const Icon(Icons.refresh),
                  label: Text(_countdown > 0 ? 'Wait for response...' : 'Retry Payment'),
                ),
              ],
              
              if (feeStatus != null && feeStatus.paid) ...[
                const Icon(
                  Icons.check_circle_outline,
                  size: 80,
                  color: Colors.green,
                ),
                const SizedBox(height: 16),
                Text(
                  'Payment Successful!',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: Colors.green,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Your registration fee has been received. You can now sign in to your account.',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () => context.go(AppConstants.routeLogin),
                  child: const Text('Go to Login'),
                ),
              ],
              
              const Spacer(),
              Text(
                'This is a one-time fee. By proceeding, you agree to our Terms of Service.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}