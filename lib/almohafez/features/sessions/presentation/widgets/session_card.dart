import 'package:flutter/material.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/presentation/view/widgets/app_custom_image_view.dart';
import '../../data/models/session_model.dart';
import '../../data/services/sessions_service.dart';

class SessionCard extends StatefulWidget {
  final SessionModel session;
  final VoidCallback onTap;
  final VoidCallback onJoinSession;
  final VoidCallback onRateSession;

  const SessionCard({
    Key? key,
    required this.session,
    required this.onTap,
    required this.onJoinSession,
    required this.onRateSession,
  }) : super(key: key);

  @override
  State<SessionCard> createState() => _SessionCardState();
}

class _SessionCardState extends State<SessionCard> {
  Timer? _timer;
  int _countdownSeconds = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    _updateState();

    final now = DateTime.now();
    final sessionStart = widget.session.scheduledDateTime;
    final difference = sessionStart.difference(now);

    // If session is more than 10 minutes away, check every minute
    if (difference.inMinutes > 10) {
      _timer = Timer.periodic(const Duration(minutes: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }

        // If we get within 10 minutes, switch to second-based timer
        final newDiff = widget.session.scheduledDateTime.difference(
          DateTime.now(),
        );
        if (newDiff.inMinutes <= 10) {
          timer.cancel();
          _startTimer(); // Restart with appropriate frequency
        } else {
          _updateState();
        }
      });
    } else {
      // If within 10 minutes or ongoing, update every second
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        if (!mounted) {
          timer.cancel();
          return;
        }
        _updateState();

        // Stop if session ended (logic can be refined, but keeping it simple for now)
        // We continue updating to show "Ended" state if needed
      });
    }
  }

  void _updateState() {
    if (mounted) {
      setState(() {
        _countdownSeconds = SessionsService.getCountdownSeconds(widget.session);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with tutor info and status indicator
              Row(
                children: [
                  // Tutor image
                  AppCustomImageView(
                    imagePath: widget.session.tutorImageUrl,
                    height: 50,
                    width: 50,
                    radius: BorderRadius.circular(25),
                    fit: BoxFit.cover,
                    placeHolder: 'assets/images/shaegh.jpg', // Fallback
                  ),
                  const SizedBox(width: 12),

                  // Tutor name and session type
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.session.tutorName,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          widget.session.typeDisplayName,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Status indicator
                  _buildStatusIndicator(),
                ],
              ),

              const SizedBox(height: 16),

              // Session details
              Row(
                children: [
                  // Date and time
                  Expanded(
                    child: _buildDetailItem(
                      Icons.schedule,
                      _formatDateTime(widget.session.scheduledDateTime),
                    ),
                  ),

                  // Duration
                  _buildDetailItem(
                    Icons.timer,
                    '${widget.session.durationMinutes} ${'sessions_minutes'.tr()}',
                  ),
                ],
              ),

              const SizedBox(height: 12),

              // Mode and additional info
              Row(
                children: [
                  // Session mode
                  Expanded(
                    child: _buildDetailItem(
                      widget.session.mode == SessionMode.online
                          ? Icons.videocam
                          : Icons.location_on,
                      widget.session.modeDisplayName,
                    ),
                  ),

                  // Rating (for completed sessions)
                  if (widget.session.isCompleted &&
                      widget.session.rating != null)
                    _buildRatingDisplay(),
                ],
              ),

              // Notes (if available)
              if (widget.session.notes != null &&
                  widget.session.notes!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      widget.session.notes!,
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                    ),
                  ),
                ),

              const SizedBox(height: 16),

              // Action button with countdown
              _buildActionButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusIndicator() {
    Color color;
    IconData icon;

    switch (widget.session.status) {
      case SessionStatus.upcoming:
        if (SessionsService.canJoinSession(widget.session)) {
          color = Colors.green;
          icon = Icons.play_circle_filled;
        } else {
          color = Colors.blue;
          icon = Icons.schedule;
        }
        break;
      case SessionStatus.ongoing:
        color = Colors.orange;
        icon = Icons.live_tv;
        break;
      case SessionStatus.completed:
        color = Colors.grey;
        icon = Icons.check_circle;
        break;
      case SessionStatus.cancelled:
        color = Colors.red;
        icon = Icons.cancel;
        break;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, color: color, size: 20),
    );
  }

  Widget _buildDetailItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildRatingDisplay() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star, size: 16, color: Colors.amber),
        const SizedBox(width: 4),
        Text(
          widget.session.rating!.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton() {
    final buttonState = SessionsService.getSessionButtonState(widget.session);

    String buttonText = buttonState['text'];
    String colorName = buttonState['color'];
    bool isEnabled = buttonState['enabled'];
    String action = buttonState['action'];

    Color buttonColor;
    switch (colorName) {
      case 'green':
        buttonColor = Colors.green;
        break;
      case 'orange':
        buttonColor = Colors.orange;
        break;
      case 'grey':
      default:
        buttonColor = Colors.grey;
        break;
    }

    VoidCallback? onPressed;
    if (isEnabled) {
      switch (action) {
        case 'join':
          onPressed = widget.onJoinSession;
          break;
        case 'rate':
          onPressed = widget.onRateSession;
          break;
        case 'none':
        default:
          onPressed = null;
          break;
      }
    }

    return Column(
      children: [
        // Countdown display (if applicable)
        if (SessionsService.shouldShowCountdown(widget.session) &&
            _countdownSeconds > 0)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.timer, size: 16, color: Colors.orange[700]),
                  const SizedBox(width: 6),
                  Text(
                    '${'sessions_starts_in'.tr()}: ${_formatCountdown(_countdownSeconds)}',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ),

        // Action button
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: isEnabled ? onPressed : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              foregroundColor: Colors.white,
              disabledBackgroundColor: Colors.grey[300],
              disabledForegroundColor: Colors.grey[600],
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: Text(
              buttonText,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final sessionDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    String dateStr;
    if (sessionDate == today) {
      dateStr = 'sessions_today'.tr();
    } else if (sessionDate == today.add(const Duration(days: 1))) {
      dateStr = 'sessions_tomorrow'.tr();
    } else {
      // Format date manually for Arabic
      final day = dateTime.day.toString().padLeft(2, '0');
      final month = dateTime.month.toString().padLeft(2, '0');
      final year = dateTime.year.toString();
      dateStr = '$day/$month/$year';
    }

    // Format time manually for Arabic
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final timeStr = '$hour:$minute';

    return '$dateStr ${'sessions_at'.tr()} $timeStr';
  }

  String _formatCountdown(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes > 0) {
      return '${minutes.toString().padLeft(2, '0')} ${'sessions_minutes_short'.tr()}';
    } else {
      return '${remainingSeconds.toString().padLeft(2, '0')} ${'sessions_seconds_short'.tr()}';
    }
  }
}
