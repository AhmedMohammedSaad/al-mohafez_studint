import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../data/models/progress_model.dart';

class TeacherNotesWidget extends StatefulWidget {
  final List<TeacherNote> notes;

  const TeacherNotesWidget({super.key, required this.notes});

  @override
  State<TeacherNotesWidget> createState() => _TeacherNotesWidgetState();
}

class _TeacherNotesWidgetState extends State<TeacherNotesWidget>
    with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  late List<Animation<double>> _fadeAnimations;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
  }

  void _initializeAnimations() {
    _animationControllers = [];
    _fadeAnimations = [];

    for (int i = 0; i < widget.notes.length; i++) {
      final controller = AnimationController(
        duration: const Duration(milliseconds: 300),
        vsync: this,
      );

      final animation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(parent: controller, curve: Curves.easeInOut));

      _animationControllers.add(controller);
      _fadeAnimations.add(animation);
    }

    // Start animations with delay
    _startSequentialAnimations();
  }

  void _startSequentialAnimations() {
    for (int i = 0; i < _animationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: i * 150), () {
        if (mounted) {
          _animationControllers[i].forward();
        }
      });
    }
  }

  @override
  void dispose() {
    for (final controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'progress_teacher_notes'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF2E3A59),
            ),
          ),
          SizedBox(height: 16.h),
          if (widget.notes.isNotEmpty)
            SizedBox(
              height: 120.h,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: widget.notes.length,
                separatorBuilder: (context, index) => SizedBox(width: 12.w),
                itemBuilder: (context, index) {
                  return AnimatedBuilder(
                    animation: _fadeAnimations[index],
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimations[index].value,
                        child: Transform.translate(
                          offset: Offset(
                            0,
                            20 * (1 - _fadeAnimations[index].value),
                          ),
                          child: _NoteCard(note: widget.notes[index]),
                        ),
                      );
                    },
                  );
                },
              ),
            )
          else
            SizedBox(
              height: 120.h,
              child: Center(
                child: Text(
                  'progress_no_teacher_notes'.tr(),
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: const Color(0xFF8C8C8C),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _NoteCard extends StatelessWidget {
  final TeacherNote note;

  const _NoteCard({required this.note});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.w,
      padding: EdgeInsets.all(12.w),
      decoration: BoxDecoration(
        color: const Color(0xFFE9F8FF),
        borderRadius: BorderRadius.circular(12.r),
        border: Border.all(color: const Color(0xFFB3E5FC), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              note.note,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w500,
                color: const Color(0xFF404040),
                height: 1.4,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (note.timestamp != null) ...[
            SizedBox(height: 8.h),
            Text(
              _formatTimestamp(note.timestamp!),
              style: TextStyle(
                fontSize: 10.sp,
                fontWeight: FontWeight.w400,
                color: const Color(0xFF8C8C8C),
              ),
            ),
          ],
        ],
      ),
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      final date = DateTime.parse(timestamp);
      final now = DateTime.now();
      final difference = now.difference(date);

      if (difference.inDays == 0) {
        return 'progress_time_today'.tr();
      } else if (difference.inDays == 1) {
        return 'progress_time_yesterday'.tr();
      } else if (difference.inDays < 7) {
        return 'progress_time_days_ago'.tr(
          args: [difference.inDays.toString()],
        );
      } else {
        return 'progress_time_weeks_ago'.tr(
          args: [(difference.inDays / 7).floor().toString()],
        );
      }
    } catch (e) {
      return timestamp;
    }
  }
}
