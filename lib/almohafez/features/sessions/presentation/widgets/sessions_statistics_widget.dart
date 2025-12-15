import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/sessions_response_model.dart';

class SessionsStatisticsWidget extends StatelessWidget {
  final SessionsResponseModel sessionsData;

  const SessionsStatisticsWidget({
    Key? key,
    required this.sessionsData,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFF2E7D32),
            const Color(0xFF4CAF50),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Title
          Text(
            'sessions_statistics_title'.tr(),
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Statistics grid
          Row(
            children: [
              Expanded(
                child: _buildStatItem(
                  'sessions_statistics_total'.tr(),
                  sessionsData.totalCount.toString(),
                  Icons.calendar_today,
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: _buildStatItem(
                  'sessions_statistics_upcoming'.tr(),
                  sessionsData.upcomingCount.toString(),
                  Icons.schedule,
                ),
              ),
              
              const SizedBox(width: 12),
              
              Expanded(
                child: _buildStatItem(
                  'sessions_statistics_completed'.tr(),
                  sessionsData.completedCount.toString(),
                  Icons.check_circle,
                ),
              ),
            ],
          ),
          
          // Additional row for cancelled sessions if any
          if (sessionsData.cancelledCount > 0) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatItem(
                    'sessions_statistics_cancelled'.tr(),
                    sessionsData.cancelledCount.toString(),
                    Icons.cancel,
                    isWarning: true,
                  ),
                ),
                const Expanded(child: SizedBox()), // Empty space
                const Expanded(child: SizedBox()), // Empty space
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStatItem(
    String label,
    String value,
    IconData icon, {
    bool isWarning = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.15),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.white.withOpacity(0.3),
          width: 1,
        ),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: isWarning ? Colors.orange[200] : Colors.white,
            size: 24,
          ),
          
          const SizedBox(height: 8),
          
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isWarning ? Colors.orange[200] : Colors.white,
            ),
          ),
          
          const SizedBox(height: 4),
          
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isWarning ? Colors.orange[200] : Colors.white.withOpacity(0.9),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}