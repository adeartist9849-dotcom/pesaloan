import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pesaloan/src/shared/theme/app_theme.dart';

class NotificationsScreen extends ConsumerWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO: Replace with actual notifications from provider
    final notifications = _getMockNotifications();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
        actions: [
          if (notifications.isNotEmpty)
            TextButton(
              onPressed: () {
                // TODO: Mark all as read
              },
              child: const Text('Mark all read'),
            ),
        ],
      ),
      body: notifications.isEmpty
          ? _buildEmptyState(context)
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                final notification = notifications[index];
                return _NotificationTile(notification: notification);
              },
            ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_off_outlined,
              size: 80,
              color: Theme.of(context).colorScheme.onSurface.withOpacity(0.3),
            ),
            const SizedBox(height: 24),
            Text(
              'No Notifications',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              'You have no notifications at the moment. Loan updates and reminders will appear here.',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurface.withOpacity(0.7),
                  ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  List<_NotificationItem> _getMockNotifications() {
    return [
      _NotificationItem(
        id: '1',
        title: 'Loan Approved',
        message: 'Your loan of KES 10,000 has been approved and disbursed to your M-Pesa.',
        type: _NotificationType.success,
        timestamp: DateTime.now().subtract(const Duration(hours: 2)),
        isRead: false,
      ),
      _NotificationItem(
        id: '2',
        title: 'Payment Reminder',
        message: 'Your loan repayment of KES 10,625 is due in 3 days.',
        type: _NotificationType.warning,
        timestamp: DateTime.now().subtract(const Duration(days: 1)),
        isRead: false,
      ),
      _NotificationItem(
        id: '3',
        title: 'KYC Verified',
        message: 'Your identity has been verified. You can now apply for loans.',
        type: _NotificationType.info,
        timestamp: DateTime.now().subtract(const Duration(days: 3)),
        isRead: true,
      ),
    ];
  }
}

class _NotificationTile extends StatelessWidget {
  final _NotificationItem notification;

  const _NotificationTile({required this.notification});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: _getTypeColor(notification.type).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            _getTypeIcon(notification.type),
            color: _getTypeColor(notification.type),
            size: 24,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                notification.title,
                style: TextStyle(
                  fontWeight: notification.isRead ? FontWeight.w500 : FontWeight.w700,
                ),
              ),
            ),
            if (!notification.isRead)
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppTheme.primaryGreen,
                  shape: BoxShape.circle,
                ),
              ),
          ],
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(notification.message),
            const SizedBox(height: 8),
            Text(
              _formatTimestamp(notification.timestamp),
              style: TextStyle(
                fontSize: 12,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.5),
              ),
            ),
          ],
        ),
        onTap: () {
          // TODO: Navigate to relevant screen based on notification type
        },
      ),
    );
  }

  Color _getTypeColor(_NotificationType type) {
    switch (type) {
      case _NotificationType.success:
        return AppTheme.successGreen;
      case _NotificationType.warning:
        return AppTheme.warningAmber;
      case _NotificationType.error:
        return AppTheme.errorRed;
      case _NotificationType.info:
        return AppTheme.infoBlue;
    }
  }

  IconData _getTypeIcon(_NotificationType type) {
    switch (type) {
      case _NotificationType.success:
        return Icons.check_circle_outline;
      case _NotificationType.warning:
        return Icons.warning_amber_outlined;
      case _NotificationType.error:
        return Icons.error_outline;
      case _NotificationType.info:
        return Icons.info_outline;
    }
  }

  String _formatTimestamp(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} min ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hr ago';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return DateFormat('dd MMM yyyy').format(timestamp);
    }
  }
}

enum _NotificationType { success, warning, error, info }

class _NotificationItem {
  final String id;
  final String title;
  final String message;
  final _NotificationType type;
  final DateTime timestamp;
  final bool isRead;

  _NotificationItem({
    required this.id,
    required this.title,
    required this.message,
    required this.type,
    required this.timestamp,
    required this.isRead,
  });
}
