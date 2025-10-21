import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/session_model.dart';
import '../../data/services/sessions_service.dart';
import '../../../../core/services/navigation_service/global_navigation_service.dart';
import '../../../../core/routing/app_route.dart';

class SessionDetailsScreen extends StatefulWidget {
  final String sessionId;

  const SessionDetailsScreen({Key? key, required this.sessionId})
    : super(key: key);

  @override
  State<SessionDetailsScreen> createState() => _SessionDetailsScreenState();
}

class _SessionDetailsScreenState extends State<SessionDetailsScreen> {
  SessionModel? _session;
  bool _isLoading = true;
  String? _errorMessage;
  int? _countdownSeconds;

  @override
  void initState() {
    super.initState();
    _loadSessionDetails();
  }

  Future<void> _loadSessionDetails() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final session = await SessionsService.getSessionById(widget.sessionId);
      setState(() {
        _session = session;
        _isLoading = false;
      });

      // Start countdown if needed
      if (SessionsService.shouldShowCountdown(session!)) {
        _startCountdownTimer();
      }
    } catch (e) {
      setState(() {
        _errorMessage = 'session_details_error'.tr();
        _isLoading = false;
      });
    }
  }

  void _startCountdownTimer() {
    _updateCountdown();
    Future.delayed(const Duration(seconds: 1), () {
      if (mounted &&
          _session != null &&
          SessionsService.shouldShowCountdown(_session!)) {
        _startCountdownTimer();
      }
    });
  }

  void _updateCountdown() {
    if (_session != null) {
      setState(() {
        _countdownSeconds = SessionsService.getCountdownSeconds(_session!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'session_details_title'.tr(),
          style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
          ? _buildErrorWidget()
          : _buildContent(),
    );
  }

  Widget _buildErrorWidget() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.grey[400]),
          const SizedBox(height: 16),
          Text(
            _errorMessage!,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: _loadSessionDetails,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2E7D32),
              foregroundColor: Colors.white,
            ),
            child: Text('sessions_retry'.tr()),
          ),
        ],
      ),
    );
  }

  Widget _buildContent() {
    if (_session == null) return const SizedBox();

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header with tutor info
          _buildHeader(),

          // Session details
          _buildSessionDetails(),

          // Notes section
          if (_session!.notes != null && _session!.notes!.isNotEmpty)
            _buildNotesSection(),

          // Rating section (for completed sessions)
          if (_session!.isCompleted) _buildRatingSection(),

          // Action buttons
          _buildActionButtons(),

          const SizedBox(height: 100), // Space for floating button
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF2E7D32), Color(0xFF4CAF50)],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            // Tutor image
            CircleAvatar(
              radius: 50,
              backgroundColor: Colors.white.withOpacity(0.2),
              backgroundImage: _session!.tutorImageUrl.isNotEmpty
                  ? AssetImage(_session!.tutorImageUrl)
                  : null,
              child: _session!.tutorImageUrl.isEmpty
                  ? Icon(
                      Icons.person,
                      size: 50,
                      color: Colors.white.withOpacity(0.7),
                    )
                  : null,
            ),

            const SizedBox(height: 16),

            // Tutor name
            Text(
              _session!.tutorName,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),

            const SizedBox(height: 8),

            // Session type
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _session!.typeDisplayName,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            // Status indicator
            const SizedBox(height: 12),
            _buildStatusChip(),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip() {
    Color backgroundColor;
    Color textColor;
    IconData icon;
    String text;

    switch (_session!.status) {
      case SessionStatus.upcoming:
        if (SessionsService.canJoinSession(_session!)) {
          backgroundColor = Colors.green;
          textColor = Colors.white;
          icon = Icons.play_circle_filled;
          text = 'session_status_ready_to_join'.tr();
        } else {
          backgroundColor = Colors.blue;
          textColor = Colors.white;
          icon = Icons.schedule;
          text = 'session_status_upcoming'.tr();
        }
        break;
      case SessionStatus.ongoing:
        backgroundColor = Colors.orange;
        textColor = Colors.white;
        icon = Icons.live_tv;
        text = 'session_status_ongoing'.tr();
        break;
      case SessionStatus.completed:
        backgroundColor = Colors.grey;
        textColor = Colors.white;
        icon = Icons.check_circle;
        text = 'session_status_completed'.tr();
        break;
      case SessionStatus.cancelled:
        backgroundColor = Colors.red;
        textColor = Colors.white;
        icon = Icons.cancel;
        text = 'session_status_cancelled'.tr();
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor, size: 18),
          const SizedBox(width: 8),
          Text(
            text,
            style: TextStyle(color: textColor, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionDetails() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'session_details_section_title'.tr(),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2E7D32),
            ),
          ),

          const SizedBox(height: 16),

          // Date and time
          _buildDetailRow(
            Icons.schedule,
            'session_details_date_time'.tr(),
            _formatDateTime(_session!.scheduledDateTime),
          ),

          const SizedBox(height: 12),

          // Duration
          _buildDetailRow(
            Icons.timer,
            'session_details_duration'.tr(),
            '${_session!.durationMinutes} ${'sessions_minutes'.tr()}',
          ),

          const SizedBox(height: 12),

          // Mode
          _buildDetailRow(
            _session!.mode == SessionMode.online
                ? Icons.videocam
                : Icons.location_on,
            'session_details_type'.tr(),
            _session!.modeDisplayName,
          ),

          const SizedBox(height: 12),

          // Session ID
          _buildDetailRow(Icons.tag, 'session_details_id'.tr(), _session!.id),

          // Countdown (if applicable)
          if (_countdownSeconds != null && _countdownSeconds! > 0) ...[
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.withOpacity(0.3)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.timer, color: Colors.orange[700], size: 20),
                  const SizedBox(width: 8),
                  Text(
                    '${'sessions_starts_in'.tr()}: ${_formatCountdown(_countdownSeconds!)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 20, color: const Color(0xFF2E7D32)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNotesSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.note, color: const Color(0xFF2E7D32), size: 20),
              const SizedBox(width: 8),
              Text(
                'session_details_notes'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              _session!.notes!,
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[700],
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.star, color: Colors.amber, size: 20),
              const SizedBox(width: 8),
              Text(
                'session_details_rating'.tr(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF2E7D32),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          if (_session!.rating != null) ...[
            Row(
              children: [
                ...List.generate(5, (index) {
                  return Icon(
                    index < _session!.rating!.round()
                        ? Icons.star
                        : Icons.star_border,
                    color: Colors.amber,
                    size: 24,
                  );
                }),
                const SizedBox(width: 12),
                Text(
                  _session!.rating!.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.amber,
                  ),
                ),
              ],
            ),

            if (_session!.feedback != null &&
                _session!.feedback!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _session!.feedback!,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ] else ...[
            Text(
              'session_details_no_rating'.tr(),
              style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Container(
      margin: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Main action button
          SizedBox(width: double.infinity, child: _buildMainActionButton()),

          // Secondary actions
          if (_session!.status == SessionStatus.upcoming) ...[
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _addNote,
                    icon: const Icon(Icons.note_add),
                    label: Text('session_details_add_note'.tr()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF2E7D32),
                      side: const BorderSide(color: Color(0xFF2E7D32)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _cancelSession,
                    icon: const Icon(Icons.cancel),
                    label: Text('session_details_cancel'.tr()),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red,
                      side: const BorderSide(color: Colors.red),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildMainActionButton() {
    String buttonText = '';
    Color buttonColor = Colors.grey;
    VoidCallback? onPressed;
    IconData icon = Icons.info;

    switch (_session!.status) {
      case SessionStatus.upcoming:
        if (SessionsService.canJoinSession(_session!)) {
          buttonText = 'session_details_join'.tr();
          buttonColor = Colors.green;
          onPressed = _joinSession;
          icon = Icons.videocam;
        } else {
          buttonText = 'session_details_not_started'.tr();
          buttonColor = Colors.grey;
          onPressed = null;
          icon = Icons.schedule;
        }
        break;
      case SessionStatus.ongoing:
        buttonText = 'session_details_ongoing'.tr();
        buttonColor = Colors.orange;
        onPressed = _joinSession;
        icon = Icons.live_tv;
        break;
      case SessionStatus.completed:
        if (_session!.rating == null) {
          buttonText = 'session_details_rate'.tr();
          buttonColor = const Color(0xFF2E7D32);
          onPressed = _navigateToRating;
          icon = Icons.star;
        } else {
          buttonText = 'session_details_ended'.tr();
          buttonColor = Colors.grey;
          onPressed = null;
          icon = Icons.check_circle;
        }
        break;
      case SessionStatus.cancelled:
        buttonText = 'session_details_cancelled'.tr();
        buttonColor = Colors.red;
        onPressed = null;
        icon = Icons.cancel;
        break;
    }

    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        buttonText,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: buttonColor,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.grey[300],
        disabledForegroundColor: Colors.grey[600],
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
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
    } else if (sessionDate == today.subtract(const Duration(days: 1))) {
      dateStr = 'sessions_yesterday'.tr();
    } else {
      dateStr = DateFormat('EEEE، dd MMMM yyyy', 'ar').format(dateTime);
    }

    final timeStr = DateFormat('hh:mm a', 'ar').format(dateTime);
    return '$dateStr ${'sessions_at'.tr()} $timeStr';
  }

  String _formatCountdown(int seconds) {
    final minutes = seconds ~/ 60;
    final remainingSeconds = seconds % 60;

    if (minutes > 0) {
      return '${minutes.toString().padLeft(2, '0')}:${remainingSeconds.toString().padLeft(2, '0')} ${'sessions_minutes'.tr()}';
    } else {
      return '$remainingSeconds ${'sessions_seconds'.tr()}';
    }
  }

  void _joinSession() async {
    try {
      await SessionsService.joinSession(_session!.id);
      
      // Navigate to meeting screen
      NavigationService.push(
        '${AppRouter.kMeetingScreen}?sessionId=${_session!.id}',
      );
      
      _loadSessionDetails(); // Refresh data
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${'session_join_error'.tr()}: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _navigateToRating() {
    NavigationService.goTo(
      '${AppRouter.kSessionRatingScreen}?sessionId=${widget.sessionId}',
    );
  }

  void _addNote() {
    // TODO: Implement add note functionality
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('session_add_note_coming_soon'.tr())),
    );
  }

  void _cancelSession() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('session_cancel_title'.tr()),
        content: Text('session_cancel_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text('common_no'.tr()),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('session_cancel_yes'.tr()),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await SessionsService.cancelSession(
          _session?.id ?? '',
          _session?.status.name ?? '',
        );
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('session_cancelled_success'.tr()),
            backgroundColor: Colors.orange,
          ),
        );
        _loadSessionDetails(); // Refresh data
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${'session_cancel_error'.tr()}: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }
}
