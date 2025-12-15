import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';

class EmptySessionsWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onActionPressed;
  final String? actionText;

  const EmptySessionsWidget({
    Key? key,
    required this.title,
    required this.subtitle,
    required this.icon,
    this.onActionPressed,
    this.actionText,
  }) : super(key: key);

  // Factory constructors for common scenarios
  factory EmptySessionsWidget.noUpcomingSessions({
    VoidCallback? onBookNew,
  }) {
    return EmptySessionsWidget(
      title: 'empty_sessions_upcoming_title'.tr(),
      subtitle: 'empty_sessions_upcoming_subtitle'.tr(),
      icon: Icons.schedule,
      onActionPressed: onBookNew,
      actionText: 'empty_sessions_upcoming_action'.tr(),
    );
  }

  factory EmptySessionsWidget.noCompletedSessions() {
    return EmptySessionsWidget(
      title: 'empty_sessions_completed_title'.tr(),
      subtitle: 'empty_sessions_completed_subtitle'.tr(),
      icon: Icons.history,
    );
  }

  factory EmptySessionsWidget.noSessions({
    VoidCallback? onBookNew,
  }) {
    return EmptySessionsWidget(
      title: 'empty_sessions_general_title'.tr(),
      subtitle: 'empty_sessions_general_subtitle'.tr(),
      icon: Icons.book,
      onActionPressed: onBookNew,
      actionText: 'empty_sessions_general_action'.tr(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: Colors.grey[400],
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2E7D32),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 12),
            
            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                height: 1.5,
              ),
              textAlign: TextAlign.center,
            ),
            
            // Action button (if provided)
            if (onActionPressed != null && actionText != null) ...[
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: onActionPressed,
                icon: const Icon(Icons.add),
                label: Text(actionText!),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2E7D32),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}