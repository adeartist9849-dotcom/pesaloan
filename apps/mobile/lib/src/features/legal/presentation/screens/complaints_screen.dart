import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:pesaloan/src/core/constants/app_constants.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';

class ComplaintsScreen extends ConsumerWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Complaints & Disputes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              'How to File a Complaint',
              'We are committed to providing excellent service. If you have a complaint about any aspect of our service, please follow the steps below:',
            ),
            _buildSection(
              'Step 1: Contact Our Support Team',
              'Reach out to our customer support team through any of the following channels:\n\n'
                  '• **Email:** support@PesaLoan.co.ke\n'
                  '• **Phone:** +254700000000\n'
                  '• **In-app:** Use the support chat feature\n\n'
                  'Our support team will acknowledge your complaint within 24 hours and aim to resolve it within 14 days.',
            ),
            _buildSection(
              'Step 2: Escalate to Complaints Officer',
              'If your complaint is not resolved to your satisfaction by the support team, you may escalate it to our Complaints Officer:\n\n'
                  '• **Email:** complaints@PesaLoan.co.ke\n'
                  '• **Phone:** +254700000000\n\n'
                  'Please include your complaint reference number (provided by the support team) when escalating.',
            ),
            _buildSection(
              'Step 3: External Dispute Resolution',
              'If your complaint remains unresolved after 30 days, you may escalate it to the Central Bank of Kenya:\n\n'
                  '• **Email:** cbk@centralbank.go.ke\n'
                  '• **Website:** www.centralbank.go.ke\n'
                  '• **Phone:** +254 20 286 0000\n\n'
                  'The CBK will investigate your complaint and facilitate resolution.',
            ),
            _buildSection(
              'Common Complaints & Resolutions',
              '**Loan Disbursement Issues:**\n'
                  'If your loan has not been disbursed within 24 hours of acceptance, contact support with your loan reference number.\n\n'
                  '**Repayment Issues:**\n'
                  'If you made a repayment but it has not been reflected, provide your M-Pesa transaction ID to support.\n\n'
                  '**Incorrect Charges:**\n'
                  'If you believe you have been charged incorrectly, provide details of the transaction and we will investigate.\n\n'
                  '**Account Access Issues:**\n'
                  'If you cannot access your account, contact support with your registered phone number for assistance.\n\n'
                  '**Data Privacy Concerns:**\n'
                  'If you have concerns about how your data is handled, contact our Data Protection Officer at dpo@PesaLoan.co.ke.',
            ),
            _buildSection(
              'What to Include in Your Complaint',
              'To help us resolve your complaint quickly, please include:\n\n'
                  '• Your full name and registered phone number\n'
                  '• Your complaint reference number (if escalating)\n'
                  '• A clear description of the issue\n'
                  '• Relevant dates and transaction details\n'
                  '• Any supporting documents or screenshots\n'
                  '• Your preferred resolution',
            ),
            _buildSection(
              'Our Commitment',
              'PesaLoan is committed to:\n\n'
                  '• Acknowledging complaints within 24 hours\n'
                  '• Providing a resolution within 14 days\n'
                  '• Keeping you informed of progress\n'
                  '• Treating all complaints fairly and confidentially\n'
                  '• Using feedback to improve our services',
            ),
            const SizedBox(height: 24),
            _buildContactCard(context),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
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
          const SizedBox(height: 8),
          Text(
            content,
            style: const TextStyle(
              fontSize: 14,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactCard(BuildContext context) {
    return Container(
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
            'Quick Contact',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppTheme.primaryGreen,
            ),
          ),
          const SizedBox(height: 12),
          _buildContactRow(
            context,
            Icons.email_outlined,
            'Email',
            AppConstants.supportEmail,
            () => _launchEmail(AppConstants.supportEmail),
          ),
          const SizedBox(height: 8),
          _buildContactRow(
            context,
            Icons.phone_outlined,
            'Phone',
            AppConstants.supportPhone,
            () => _launchPhone(AppConstants.supportPhone),
          ),
        ],
      ),
    );
  }

  Widget _buildContactRow(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppTheme.primaryGreen),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
                  ),
                ),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.primaryGreen,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20),
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
