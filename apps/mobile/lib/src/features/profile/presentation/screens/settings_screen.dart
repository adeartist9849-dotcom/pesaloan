import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';
import 'package:pesaloan/src/features/auth/presentation/providers/auth_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).user;

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionHeader(context, 'Security'),
          _buildSettingsTile(
            icon: Icons.lock_outlined,
            title: 'Change PIN',
            subtitle: 'Update your 4-6 digit PIN',
            onTap: () => context.go(AppConstants.routeChangePin),
          ),
          _buildSettingsTile(
            icon: Icons.fingerprint_outlined,
            title: 'Biometric Login',
            subtitle: 'Use fingerprint or face ID',
            trailing: Switch(
              value: false, // TODO: Get from storage
              onChanged: (value) {},
              activeColor: AppTheme.primaryGreen,
            ),
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.security_outlined,
            title: 'Session Management',
            subtitle: 'View and manage active sessions',
            onTap: () {},
          ),

          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Notifications'),
          _buildSettingsTile(
            icon: Icons.notifications_outlined,
            title: 'Push Notifications',
            subtitle: 'Receive loan updates and reminders',
            trailing: Switch(
              value: true, // TODO: Get from storage
              onChanged: (value) {},
              activeColor: AppTheme.primaryGreen,
            ),
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.sms_outlined,
            title: 'SMS Notifications',
            subtitle: 'Critical alerts via SMS',
            trailing: Switch(
              value: true, // TODO: Get from storage
              onChanged: (value) {},
              activeColor: AppTheme.primaryGreen,
            ),
            onTap: () {},
          ),

          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Preferences'),
          _buildSettingsTile(
            icon: Icons.language_outlined,
            title: 'Language',
            subtitle: 'English',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.dark_mode_outlined,
            title: 'Theme',
            subtitle: 'System Default',
            onTap: () {},
          ),

          const SizedBox(height: 24),
          _buildSectionHeader(context, 'Support & Legal'),
          _buildSettingsTile(
            icon: Icons.help_outline,
            title: 'Help Center',
            subtitle: 'FAQs and guides',
            onTap: () => context.go(AppConstants.routeHelp),
          ),
          _buildSettingsTile(
            icon: Icons.chat_outlined,
            title: 'Contact Support',
            subtitle: 'Call or email us',
            onTap: () => context.go(AppConstants.routeSupport),
          ),
          _buildSettingsTile(
            icon: Icons.article_outlined,
            title: 'Terms of Service',
            subtitle: 'Read our terms and conditions',
            onTap: () => context.go(AppConstants.routeTerms),
          ),
          _buildSettingsTile(
            icon: Icons.privacy_tip_outlined,
            title: 'Privacy Policy',
            subtitle: 'How we protect your data',
            onTap: () => context.go(AppConstants.routePrivacyPolicy),
          ),
          _buildSettingsTile(
            icon: Icons.description_outlined,
            title: 'Loan Agreement',
            subtitle: 'Standard loan terms',
            onTap: () => context.go(AppConstants.routeLoanAgreement),
          ),
          _buildSettingsTile(
            icon: Icons.verified_user_outlined,
            title: 'CRB Disclosure',
            subtitle: 'Credit reference bureau information',
            onTap: () => context.go(AppConstants.routeCrbDisclosure),
          ),
          _buildSettingsTile(
            icon: Icons.account_balance_outlined,
            title: 'Regulatory Information',
            subtitle: 'CBK license and compliance',
            onTap: () => context.go(AppConstants.routeRegulatoryInfo),
          ),
          _buildSettingsTile(
            icon: Icons.report_outlined,
            title: 'Complaints & Disputes',
            subtitle: 'How to file a complaint',
            onTap: () => context.go(AppConstants.routeComplaints),
          ),

          const SizedBox(height: 24),
          _buildSectionHeader(context, 'About'),
          _buildSettingsTile(
            icon: Icons.info_outline,
            title: 'App Version',
            subtitle: '1.0.0',
            onTap: () {},
          ),
          _buildSettingsTile(
            icon: Icons.star_outline,
            title: 'Rate Us',
            subtitle: 'Share your feedback',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8, left: 4),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSettingsTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.primaryGreen.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: AppTheme.primaryGreen, size: 20),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
        subtitle: Text(subtitle),
        trailing: trailing ?? const Icon(Icons.chevron_right),
        onTap: onTap,
      ),
    );
  }
}
