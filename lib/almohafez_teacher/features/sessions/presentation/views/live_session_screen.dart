import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import '../../data/models/session_model.dart';
import '../../../students/data/models/student_model.dart';
import '../widgets/session_timer_widget.dart';
import '../widgets/session_notes_widget.dart';
import '../widgets/session_controls_widget.dart';

class LiveSessionScreen extends StatefulWidget {
  final Session session;
  final Student student;

  const LiveSessionScreen({
    super.key,
    required this.session,
    required this.student,
  });

  @override
  State<LiveSessionScreen> createState() => _LiveSessionScreenState();
}

class _LiveSessionScreenState extends State<LiveSessionScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _topicsController = TextEditingController();
  bool _isSessionActive = false;
  Duration _sessionDuration = Duration.zero;
  DateTime? _sessionStartTime;

  @override
  void initState() {
    super.initState();
    _notesController.text = widget.session.notes ?? '';
  }

  @override
  void dispose() {
    _notesController.dispose();
    _topicsController.dispose();
    super.dispose();
  }

  void _startSession() {
    setState(() {
      _isSessionActive = true;
      _sessionStartTime = DateTime.now();
    });
  }

  void _pauseSession() {
    setState(() {
      _isSessionActive = false;
    });
  }

  void _endSession() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('إنهاء الجلسة', style: AppTextStyle.textStyle18Bold),
        content: Text(
          'هل أنت متأكد من إنهاء الجلسة؟',
          style: AppTextStyle.textStyle14Medium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: AppTextStyle.textStyle14Medium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryError,
            ),
            child: Text(
              'إنهاء',
              style: AppTextStyle.textStyle14Medium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _saveNotes() {
    // حفظ الملاحظات
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تم حفظ الملاحظات بنجاح',
          style: AppTextStyle.textStyle14Medium.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primarySuccess,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: AppColors.primaryBlueViolet,
        elevation: 0,
        title: Text(
          'الجلسة المباشرة',
          style: AppTextStyle.textStyle24Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
        ),
        actions: [
          IconButton(
            onPressed: _saveNotes,
            icon: const Icon(Icons.save_rounded, color: Colors.white),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 30.r,
                          backgroundColor: AppColors.primaryBlueViolet
                              .withOpacity(0.1),
                          child: Text(
                            widget.student.firstName.substring(0, 1),
                            style: AppTextStyle.textStyle18Bold.copyWith(
                              color: AppColors.primaryBlueViolet,
                            ),
                          ),
                        ),
                        SizedBox(width: 16.w),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.student.firstName,
                                style: AppTextStyle.textStyle18Bold.copyWith(
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                widget.session.topic ?? '',
                                style: AppTextStyle.textStyle14Medium.copyWith(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              SizedBox(height: 4.h),
                              Text(
                                'المدة المخططة: ${widget.session.duration} دقيقة',
                                style: AppTextStyle.textStyle12Medium.copyWith(
                                  color: AppColors.primaryBlueViolet,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // مؤقت الجلسة
              SessionTimerWidget(
                isActive: _isSessionActive,
                duration: _sessionDuration,
                onDurationChanged: (duration) {
                  setState(() {
                    _sessionDuration = duration;
                  });
                },
              ),

              SizedBox(height: 20.h),

              // أدوات التحكم في الجلسة
              SessionControlsWidget(
                isSessionActive: _isSessionActive,
                onStart: _startSession,
                onPause: _pauseSession,
                onEnd: _endSession,
              ),
              SizedBox(height: 20.h),
              // الموضوعات المغطاة
              Container(
                padding: EdgeInsets.all(16.w),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.r),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الموضوعات المغطاة',
                      style: AppTextStyle.textStyle16Bold.copyWith(
                        color: AppColors.textPrimary,
                      ),
                    ),
                    SizedBox(height: 12.h),
                    TextFormField(
                      controller: _topicsController,
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'اكتب الموضوعات التي تم تغطيتها في الجلسة...',
                        hintStyle: AppTextStyle.textStyle14Medium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: AppColors.borderColor),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(
                            color: AppColors.primaryBlueViolet,
                            width: 2,
                          ),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.r),
                          borderSide: BorderSide(color: AppColors.borderColor),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20.h),

              // ملاحظات الجلسة
              SessionNotesWidget(
                notesController: _notesController,
                onSave: _saveNotes,
              ),

              SizedBox(height: 20.h),
            ],
          ),
        ),
      ),
    );
  }
}
