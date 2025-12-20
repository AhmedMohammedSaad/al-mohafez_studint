import 'package:almohafez/almohafez_teacher/features/sessions/presentation/widgets/daily_sessions_widget.dart';
import 'package:almohafez/almohafez_teacher/features/sessions/presentation/widgets/session_stats_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import '../../data/models/session_model.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../presentation/cubit/sessions_cubit.dart';
import '../../presentation/cubit/sessions_state.dart';
import 'live_session_screen.dart';
import '../../../students/data/models/student_model.dart';
// Other imports remain

class SessionsScreen extends StatefulWidget {
  const SessionsScreen({super.key});

  @override
  State<SessionsScreen> createState() => _SessionsScreenState();
}

class _SessionsScreenState extends State<SessionsScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    // Load sessions when screen opens
    context.read<SessionsCubit>().loadSessions();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        backgroundColor: AppColors.white,
        elevation: 0,
        title: Text(
          'إدارة الجلسات',
          style: AppTextStyle.textStyle20Bold.copyWith(
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              // Only show stats if sessions are loaded?
              // For now just keeping basic functionality
            },
            icon: Icon(
              Icons.bar_chart,
              color: AppColors.textPrimary,
              size: 24.sp,
            ),
          ),
        ],
      ),
      body: BlocBuilder<SessionsCubit, SessionsState>(
        builder: (context, state) {
          if (state is SessionsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is SessionsError) {
            return Center(child: Text(state.message));
          }

          List<Session> allSessions = [];
          if (state is SessionsLoaded) {
            allSessions = state.sessions;
          }

          return RefreshIndicator(
            onRefresh: () async {
              await context.read<SessionsCubit>().loadSessions();
            },
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16.w),
              physics: const AlwaysScrollableScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (state is SessionsLoaded)
                    SessionStatsWidget(sessions: allSessions),

                  SizedBox(height: 20.h),

                  DailySessionsWidget(
                    selectedDate:
                        selectedDate, // Can keep dummy or remove param if updated Widget, but better to keep for now and ignore it inside widget or pass now
                    sessions: allSessions, // Pass ALL sessions
                    onSessionTap: (session) {
                      _handleSessionTap(session);
                    },
                  ),

                  if (allSessions.isEmpty)
                    Center(
                      child: Padding(
                        padding: EdgeInsets.only(top: 50.h),
                        child: Text(
                          "لا توجد جلسات",
                          style: AppTextStyle.textStyle16Medium.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _handleSessionTap(Session session) {
    if (session.status == SessionStatus.scheduled ||
        session.status == SessionStatus.inProgress) {
      showModalBottomSheet(
        context: context,
        backgroundColor: AppColors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
        ),
        builder: (context) => Container(
          padding: EdgeInsets.all(20.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40.w,
                height: 4.h,
                decoration: BoxDecoration(
                  color: AppColors.textSecondary,
                  borderRadius: BorderRadius.circular(2.r),
                ),
              ),
              SizedBox(height: 20.h),
              Text('خيارات الجلسة', style: AppTextStyle.textStyle18Bold),
              SizedBox(height: 20.h),
              ListTile(
                leading: Icon(
                  Icons.play_circle_fill,
                  color: AppColors.primarySuccess,
                  size: 24.sp,
                ),
                title: Text(
                  'بدء الجلسة',
                  style: AppTextStyle.textStyle16Medium,
                ),
                onTap: () {
                  Navigator.pop(context); // Close bottom sheet
                  _showStartSessionDialog(session);
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.edit,
                  color: AppColors.primaryBlueViolet,
                  size: 24.sp,
                ),
                title: Text(
                  'تعديل الجلسة',
                  style: AppTextStyle.textStyle16Medium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Navigate to edit session screen
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.cancel,
                  color: AppColors.primaryError,
                  size: 24.sp,
                ),
                title: Text(
                  'إلغاء الجلسة',
                  style: AppTextStyle.textStyle16Medium,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // Cancel session logic
                },
              ),
              65.height,
            ],
          ),
        ),
      );
    }
  }

  void _showStartSessionDialog(Session session) {
    final TextEditingController urlController = TextEditingController(
      text: session.meetingUrl,
    );
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("بدء الجلسة", style: AppTextStyle.textStyle18Bold),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "يرجى إدخال رابط الاجتماع للطالب للدخول:",
                style: AppTextStyle.textStyle14Medium,
              ),
              10.height,
              TextFormField(
                controller: urlController,
                decoration: InputDecoration(
                  labelText: "رابط الاجتماع (Zoom, Google Meet, etc.)",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'الرابط مطلوب';
                  }
                  return null;
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              "إلغاء",
              style: AppTextStyle.textStyle14Medium.copyWith(
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primarySuccess,
            ),
            onPressed: () {
              if (formKey.currentState!.validate()) {
                final url = urlController.text;
                // Update session with new URL & Start
                context.read<SessionsCubit>().startSession(session.id, url);
                Navigator.pop(ctx);

                // Construct a dummy student object since we don't have full student details here
                // ideally we fetch student info or pass it.
                // For now creating minimal student object
                final tempStudent = Student(
                  id: session.studentId,
                  firstName: session.studentName.split(' ').first,
                  lastName: session.studentName.split(' ').skip(1).join(' '),
                  email: '',
                  phone: '',
                  level: 'غير محدد',
                  currentPart: 'غير محدد',
                  completedParts: [],
                  joinDate: DateTime.now(),
                  isActive: true,
                  totalSessions: 0,
                  averageRating: 0.0,
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => LiveSessionScreen(
                      session: session.copyWith(
                        meetingUrl: url,
                        status: SessionStatus.inProgress,
                      ),
                      student: tempStudent,
                    ),
                  ),
                );
              }
            },
            child: Text(
              "ابدأ الآن",
              style: AppTextStyle.textStyle14Medium.copyWith(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
