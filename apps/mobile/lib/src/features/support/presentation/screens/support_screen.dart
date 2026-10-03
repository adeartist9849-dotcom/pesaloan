import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';

class SupportScreen extends ConsumerWidget {
  const SupportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Support')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'We\'re here to help',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'Choose any of the following ways to reach us. We aim to respond within 24 hours.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
            ),
            const SizedBox(height: 32),
            _buildContactCard(
              context,
              icon: Icons.phone_outlined,
              title: 'Call Us',
              subtitle: AppConstants.supportPhone,
              description: 'Mon-Fri, 8am-6pm EAT',
              onTap: () => _launchPhone(AppConstants.supportPhone),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              context,
              icon: Icons.email_outlined,
              title: 'Email Us',
              subtitle: AppConstants.supportEmail,
              description: 'We respond within 24 hours',
              onTap: () => _launchEmail(AppConstants.supportEmail),
            ),
            const SizedBox(height: 12),
            _buildContactCard(
              context,
              icon: Icons.chat_outlined,
              title: 'Live Chat',
              subtitle: 'Chat with our support team',
              description: 'Available in-app, Mon-Fri 8am-6pm',
              onTap: () {
                // TODO: Open in-app chat
              },
            ),
            const SizedBox(height: 32),
            _buildSection(
              context,
              'Common Topics',
              [
                _TopicItem(
                  icon: Icons.account_balance_wallet_outlined,
                  title: 'Loan Disbursement',
                  onTap: () {},
                ),
                _TopicItem(
                  icon: Icons.payment_outlined,
                  title: 'Repayment Issues',
                  onTap: () {},
                ),
                _TopicItem(
                  icon: Icons.lock_outline,
                  title: 'Account & PIN',
                  onTap: () {},
                ),
                _TopicItem(
                  icon: Icons.verified_user_outlined,
                  title: 'KYC Verification',
                  onTap: () {},
                ),
                _TopicItem(
                  icon: Icons.credit_card_outlined,
                  title: 'Credit Limit',
                  onTap: () {},
                ),
                _TopicItem(
                  icon: Icons.description_outlined,
                  title: 'Loan Agreement',
                  onTap: () {},
                ),
              ],
            ),
            const SizedBox(height: 32),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.05),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.primaryGreen.withOpacity(0.2)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Office Hours',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildHoursRow('Monday - Friday', '8:00 AM - 6:00 PM'),
                  _buildHoursRow('Saturday', '9:00 AM - 1:00 PM'),
                  _buildHoursRow('Sunday & Holidays', 'Closed'),
                ],
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required String description,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppTheme.primaryGreen, size: 24),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: const TextStyle(
                color: AppTheme.primaryGreen,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              description,
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ],
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, List<_TopicItem> items) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppTheme.primaryGreen,
          ),
        ),
        const SizedBox(height: 12),
        Card(
          child: Column(
            children: items
                .map((item) => ListTile(
                      leading: Icon(item.icon, color: AppTheme.primaryGreen),
                      title: Text(item.title),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: item.onTap,
                    ))
                .toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildHoursRow(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(fontSize: 14),
          ),
          Text(
            hours,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppTheme.primaryGreen,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _TopicItem {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  _TopicItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });
}
