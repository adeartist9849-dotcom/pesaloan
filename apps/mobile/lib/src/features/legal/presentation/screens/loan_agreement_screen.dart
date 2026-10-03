import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';

class LoanAgreementScreen extends ConsumerWidget {
  const LoanAgreementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Loan Agreement')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSection(
              '1. Parties',
              'This Loan Agreement ("Agreement") is entered into between:\n\n'
                  '**Lender:** PesaLoan Limited, a company incorporated under the laws of Kenya, with its registered office in Nairobi, Kenya.\n\n'
                  '**Borrower:** The registered user of the PesaLoan mobile application who accepts a loan offer through the app.\n\n'
                  'The Lender and Borrower are collectively referred to as the "Parties".',
            ),
            _buildSection(
              '2. Definitions',
              '• **Loan Amount:** The principal amount disbursed to the Borrower\n'
                  '• **Interest Rate:** 15% per annum, pro-rated for the loan term\n'
                  '• **Processing Fee:** 5% of the Loan Amount\n'
                  '• **Total Repayment Amount:** Loan Amount + Interest + Processing Fee\n'
                  '• **Loan Term:** The period between disbursement and the due date (7-90 days)\n'
                  '• **Due Date:** The date by which the Total Repayment Amount must be paid\n'
                  '• **Late Payment Penalty:** 1% per day on the outstanding amount\n'
                  '• **Cooling-Off Period:** 24 hours from disbursement',
            ),
            _buildSection(
              '3. Loan Disbursement',
              'Upon acceptance of the loan offer by the Borrower:\n'
                  '• The Loan Amount will be disbursed to the Borrower\'s registered M-Pesa or Airtel Money account\n'
                  '• Disbursement will occur within 24 hours of acceptance\n'
                  '• The Borrower will receive an SMS confirmation with the disbursement details',
            ),
            _buildSection(
              '4. Repayment Terms',
              '• The Borrower agrees to repay the Total Repayment Amount on or before the Due Date\n'
                  '• Repayment shall be made via M-Pesa STK Push or Airtel Money\n'
                  '• The Borrower must ensure sufficient funds in their mobile money account on the Due Date\n'
                  '• Partial repayments are accepted but do not reduce the Due Date\n'
                  '• The Borrower may repay the loan in full at any time before the Due Date without penalty',
            ),
            _buildSection(
              '5. Interest and Fees',
              '• **Interest:** 15% per annum, calculated on a pro-rated basis for the loan term\n'
                  '• **Processing Fee:** 5% of the Loan Amount, deducted at disbursement\n'
                  '• **Late Payment Penalty:** 1% per day on the outstanding amount, calculated from the Due Date until full repayment\n'
                  '• **No hidden fees:** The Total Repayment Amount shown in the loan offer is the exact amount to be repaid',
            ),
            _buildSection(
              '6. Cooling-Off Period',
              'The Borrower has a cooling-off period of 24 hours from the time of loan disbursement. During this period, the Borrower may choose to repay the loan in full (principal only) without incurring any interest or penalties. To exercise this right, the Borrower must contact PesaLoan support immediately.',
            ),
            _buildSection(
              '7. Default',
              'The Borrower will be in default if:\n'
                  '• The Total Repayment Amount is not paid in full by the Due Date\n'
                  '• The Borrower provides false or misleading information\n'
                  '• The Borrower becomes bankrupt or insolvent\n\n'
                  'Consequences of default:\n'
                  '• Late payment penalties will accrue at 1% per day\n'
                  '• The default will be reported to licensed Credit Reference Bureaus\n'
                  '• The Borrower\'s credit score will be negatively affected\n'
                  '• Future loan applications may be declined\n'
                  '• Legal action may be taken to recover the debt',
            ),
            _buildSection(
              '8. Credit Reference Bureau Reporting',
              'The Borrower acknowledges and agrees that:\n'
                  '• PesaLoan will report the loan to licensed Credit Reference Bureaus\n'
                  '• Both positive (timely repayment) and negative (default) information will be reported\n'
                  '• The Borrower has the right to access their credit report from any licensed CRB\n'
                  '• The Borrower may dispute inaccurate information through the CRB dispute resolution process',
            ),
            _buildSection(
              '9. Amendment',
              'PesaLoan reserves the right to amend this Agreement at any time. Material changes will be communicated to the Borrower through the app, SMS, or email at least 14 days before taking effect. Continued use of the app after amendments constitutes acceptance.',
            ),
            _buildSection(
              '10. Governing Law',
              'This Agreement shall be governed by and construed in accordance with the laws of the Republic of Kenya. Any disputes arising from this Agreement shall be subject to the exclusive jurisdiction of the courts of Kenya.',
            ),
            _buildSection(
              '11. Contact Information',
              'For questions about this Agreement:\n'
                  '• Email: legal@PesaLoan.co.ke\n'
                  '• Phone: +254700000000\n'
                  '• Address: PesaLoan Limited, Nairobi, Kenya',
            ),
            const SizedBox(height: 24),
            Text(
              'Last updated: January 2025',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
                  ),
            ),
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
}
