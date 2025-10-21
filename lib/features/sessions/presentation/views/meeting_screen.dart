import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'dart:async';
import '../../../../core/services/navigation_service/global_navigation_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../sessions/data/models/session_model.dart';
import '../../../sessions/data/services/sessions_service.dart';

class MeetingScreen extends StatefulWidget {
  final String sessionId;
  
  const MeetingScreen({
    Key? key,
    required this.sessionId,
  }) : super(key: key);

  @override
  State<MeetingScreen> createState() => _MeetingScreenState();
}

class _MeetingScreenState extends State<MeetingScreen> {
  SessionModel? _session;
  bool _isLoading = true;
  bool _isMicMuted = false;
  bool _isCameraOff = false;
  bool _isScreenSharing = false;
  bool _showControls = true;
  bool _isRecording = false;
  Timer? _hideControlsTimer;
  Timer? _sessionTimer;
  Duration _sessionDuration = Duration.zero;
  
  @override
  void initState() {
    super.initState();
    _loadSessionDetails();
    _startSessionTimer();
    _startHideControlsTimer();
    // Keep orientation in portrait mode
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }

  @override
  void dispose() {
    _sessionTimer?.cancel();
    _hideControlsTimer?.cancel();
    
    // Restore all orientations when leaving
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    
    super.dispose();
  }

  Future<void> _loadSessionDetails() async {
    try {
      final session = await SessionsService.getSessionById(widget.sessionId);
      setState(() {
        _session = session;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _startSessionTimer() {
    _sessionTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (mounted) {
        setState(() {
          _sessionDuration = Duration(seconds: _sessionDuration.inSeconds + 1);
        });
      }
    });
  }

  void _startHideControlsTimer() {
    _hideControlsTimer?.cancel();
    _hideControlsTimer = Timer(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _showControls = false;
        });
      }
    });
  }

  void _toggleControls() {
    setState(() {
      _showControls = !_showControls;
    });
    if (_showControls) {
      _startHideControlsTimer();
    }
  }

  void _toggleMic() {
    setState(() {
      _isMicMuted = !_isMicMuted;
    });
    _startHideControlsTimer();
  }

  void _toggleCamera() {
    setState(() {
      _isCameraOff = !_isCameraOff;
    });
    _startHideControlsTimer();
  }

  void _toggleScreenShare() {
    setState(() {
      _isScreenSharing = !_isScreenSharing;
    });
    _startHideControlsTimer();
  }

  void _toggleRecording() {
    setState(() {
      _isRecording = !_isRecording;
    });
    _startHideControlsTimer();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isRecording ? 'meeting_recording_started'.tr() : 'meeting_recording_stopped'.tr()),
        backgroundColor: _isRecording ? Colors.red : Colors.green,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _endMeeting() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('meeting_end_title'.tr()),
        content: Text('meeting_end_confirmation'.tr()),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('common_cancel'.tr()),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              NavigationService.goBack();
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: Text('meeting_end_button'.tr()),
          ),
        ],
      ),
    );
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: CircularProgressIndicator(color: Colors.white),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: _toggleControls,
        child: Column(
          children: [
            // Top bar with session info
            if (_showControls) _buildTopBar(),
            
            // Main video area
            Expanded(
              child: Stack(
                children: [
                  _buildMainVideoArea(),
                  
                  // Side panel for participant (tutor)
                  _buildSidePanel(),
                  
                  // Recording indicator
                  if (_isRecording) _buildRecordingIndicator(),
                ],
              ),
            ),
            
            // Bottom controls
            if (_showControls) _buildBottomControls(),
          ],
        ),
      ),
    );
  }

  Widget _buildMainVideoArea() {
    return Container(
      width: double.infinity,
      height: double.infinity,
      margin: EdgeInsets.all(8.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFF1a1a1a),
            Color(0xFF2d2d2d),
          ],
        ),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isCameraOff) ...[
              Container(
                width: 120.w,
                height: 120.w,
                decoration: BoxDecoration(
                  color: AppColors.primaryBlueViolet,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.person,
                  size: 60.sp,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16.h),
              Text(
                'meeting_camera_off'.tr(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ] else ...[
              // Simulated video feed
              Container(
                width: double.infinity,
                height: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[800],
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Stack(
                  children: [
                    // Video placeholder
                    Center(
                      child: Icon(
                        Icons.videocam,
                        size: 80.sp,
                        color: Colors.white54,
                      ),
                    ),
                    // User name overlay
                    Positioned(
                      bottom: 16.h,
                      left: 16.w,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 12.w,
                          vertical: 6.h,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        child: Text(
                          'meeting_you'.tr(),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14.sp,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Positioned(
      top: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          top: MediaQuery.of(context).padding.top + 8.h,
          left: 16.w,
          right: 16.w,
          bottom: 16.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          children: [
            // Session info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _session?.typeDisplayName ?? 'meeting_session'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4.h),
                  Text(
                    '${'meeting_with'.tr()} ${_session?.tutorName ?? 'meeting_teacher'.tr()}',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 14.sp,
                    ),
                  ),
                ],
              ),
            ),
            
            // Session duration
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: 12.w,
                vertical: 6.h,
              ),
              decoration: BoxDecoration(
                color: Colors.black54,
                borderRadius: BorderRadius.circular(20.r),
              ),
              child: Text(
                _formatDuration(_sessionDuration),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomControls() {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: EdgeInsets.only(
          left: 16.w,
          right: 16.w,
          bottom: MediaQuery.of(context).padding.bottom + 16.h,
          top: 16.h,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Colors.black.withOpacity(0.7),
              Colors.transparent,
            ],
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            // Mic toggle
            _buildControlButton(
              icon: _isMicMuted ? Icons.mic_off : Icons.mic,
              isActive: !_isMicMuted,
              onTap: _toggleMic,
            ),
            
            // Camera toggle
            _buildControlButton(
              icon: _isCameraOff ? Icons.videocam_off : Icons.videocam,
              isActive: !_isCameraOff,
              onTap: _toggleCamera,
            ),
            
            // Screen share
            _buildControlButton(
              icon: Icons.screen_share,
              isActive: _isScreenSharing,
              onTap: _toggleScreenShare,
            ),
            
            // Recording
            _buildControlButton(
              icon: Icons.fiber_manual_record,
              isActive: _isRecording,
              onTap: _toggleRecording,
              activeColor: Colors.red,
            ),
            
            // End call
            _buildControlButton(
              icon: Icons.call_end,
              isActive: false,
              onTap: _endMeeting,
              backgroundColor: Colors.red,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSidePanel() {
    return Positioned(
      top: 100.h,
      right: 16.w,
      child: Container(
        width: 120.w,
        height: 160.h,
        decoration: BoxDecoration(
          color: Colors.grey[800],
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(
            color: Colors.white24,
            width: 1,
          ),
        ),
        child: Stack(
          children: [
            // Tutor video placeholder
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 30.r,
                    backgroundColor: AppColors.primaryBlueViolet,
                    child: Icon(
                      Icons.person,
                      size: 30.sp,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    _session?.tutorName ?? 'meeting_teacher'.tr(),
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 10.sp,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            
            // Mic status indicator
            Positioned(
              bottom: 8.h,
              right: 8.w,
              child: Container(
                padding: EdgeInsets.all(4.w),
                decoration: const BoxDecoration(
                  color: Colors.black54,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.mic,
                  size: 12.sp,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecordingIndicator() {
    return Positioned(
      top: MediaQuery.of(context).padding.top + 60.h,
      left: 16.w,
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: 12.w,
          vertical: 6.h,
        ),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(20.r),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 8.w,
              height: 8.w,
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: 6.w),
            Text(
              'meeting_recording_in_progress'.tr(),
              style: TextStyle(
                color: Colors.white,
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    Color? activeColor,
    Color? backgroundColor,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 56.w,
        height: 56.w,
        decoration: BoxDecoration(
          color: backgroundColor ?? 
                 (isActive 
                   ? (activeColor ?? AppColors.primaryBlueViolet)
                   : Colors.white24),
          shape: BoxShape.circle,
        ),
        child: Icon(
          icon,
          color: Colors.white,
          size: 24.sp,
        ),
      ),
    );
  }
}