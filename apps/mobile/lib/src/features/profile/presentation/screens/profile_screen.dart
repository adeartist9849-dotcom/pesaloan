import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:pesaloan/src/features/profile/presentation/providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});
  
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);
    final user = ref.watch(authStateProvider).user;
    
    return Scaffold(
      appBar: AppBar(title: const Text('Profile')),
      body: profileState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildProfileHeader(context, user),
                  const SizedBox(height: 24),
                  _buildKycStatusCard(context, profileState.kycStatus),
                  const SizedBox(height: 24),
                  _buildInfoSection(context, user),
                  const SizedBox(height: 24),
                  _buildActionButtons(context, ref),
                ],
              ),
            ),
    );
  }
  
  Widget _buildProfileHeader(BuildContext context, user) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: AppTheme.primaryGreen.withOpacity(0.1),
          child: Text(
            user?.fullName.isNotEmpty == true ? user.fullName[0].toUpperCase() : 'U',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryGreen,
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user?.fullName ?? 'User',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                user?.phoneNumber ?? '',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
  
  Widget _buildKycStatusCard(BuildContext context, String kycStatus) {
    Color statusColor;
    String statusText;
    IconData statusIcon;
    
    switch (kycStatus) {
      case 'VERIFIED':
        statusColor = AppTheme.successGreen;
        statusText = 'Verified';
        statusIcon = Icons.verified;
        break;
      case 'PENDING_REVIEW':
        statusColor = AppTheme.warningAmber;
        statusText = 'Under Review';
        statusIcon = Icons.hourglass_empty;
        break;
      case 'REJECTED':
        statusColor = AppTheme.errorRed;
        statusText = 'Rejected';
        statusIcon = Icons.cancel;
        break;
      default:
        statusColor = Theme.of(context).colorScheme.onSurface.withOpacity(0.5);
        statusText = 'Not Started';
        statusIcon = Icons.help;
    }
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: statusColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: statusColor.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
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
                Text(
                  'KYC Status',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
                ),
                Text(
                  statusText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: statusColor,
                  ),
                ),
              ],
            ),
          ),
          if (kycStatus != 'VERIFIED')
            TextButton(
              onPressed: () => context.go(AppConstants.routeKyc),
              child: const Text('Complete KYC'),
            ),
        ],
      ),
    );
  }
  
  Widget _buildInfoSection(BuildContext context, user) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Account Information',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 16),
        _InfoTile(
          icon: Icons.phone_outlined,
          label: 'Phone Number',
          value: user?.phoneNumber ?? '',
        ),
        _InfoTile(
          icon: Icons.email_outlined,
          label: 'Email',
          value: user?.email ?? 'Not provided',
        ),
        _InfoTile(
          icon: Icons.calendar_today_outlined,
          label: 'Date of Birth',
          value: user?.dateOfBirth != null
              ? DateFormat('dd MMM yyyy').format(DateTime.parse(user!.dateOfBirth))
              : 'Not provided',
        ),
        _InfoTile(
          icon: Icons.badge_outlined,
          label: 'National ID',
          value: user?.nationalId != null
              ? '****${user!.nationalId.substring(user.nationalId.length - 4)}'
              : 'Not provided',
        ),
        _InfoTile(
          icon: Icons.account_balance_wallet_outlined,
          label: 'Loan Limit',
          value: '${AppConstants.currencySymbol}${NumberFormat('#,###').format(user?.loanLimit ?? 0)}',
          valueColor: AppTheme.primaryGreen,
        ),
        _InfoTile(
          icon: Icons.calendar_month_outlined,
          label: 'Member Since',
          value: user?.createdAt != null
              ? DateFormat('MMM yyyy').format(DateTime.parse(user!.createdAt))
              : 'Unknown',
        ),
      ],
    );
  }
  
  Widget _buildActionButtons(BuildContext context, WidgetRef ref) {
    return Column(
      children: [
        OutlinedButton.icon(
          onPressed: () => context.go(AppConstants.routeSettings),
          icon: const Icon(Icons.settings_outlined),
          label: const Text('Settings'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () => context.go(AppConstants.routeChangePin),
          icon: const Icon(Icons.lock_outlined),
          label: const Text('Change PIN'),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size(double.infinity, 52),
          ),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: () async {
            final confirmed = await showDialog<bool>(
              context: context,
              builder: (context) => AlertDialog(
                title: const Text('Logout'),
                content: const Text('Are you sure you want to logout?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Logout'),
                  ),
                ],
              ),
            );
            
            if (confirmed == true && context.mounted) {
              await ref.read(authStateProvider.notifier).logout();
              if (context.mounted) {
                context.go(AppConstants.routeLogin);
              }
            }
          },
          icon: const Icon(Icons.logout_outlined, color: AppTheme.errorRed),
          label: Text('Logout', style: TextStyle(color: AppTheme.errorRed)),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            minimumSize: const Size(double.infinity, 52),
            side: BorderSide(color: AppTheme.errorRed),
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color? valueColor;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: AppTheme.primaryGreen.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                      ),
                ),
                Text(
                  value,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: valueColor,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}