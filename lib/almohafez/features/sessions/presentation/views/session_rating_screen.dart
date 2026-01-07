import 'package:almohafez/almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/app_default_text_form_field.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/main_button.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/simple_appbar.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/features/sessions/data/models/session_model.dart';
import 'package:almohafez/almohafez/features/sessions/data/models/session_rating_model.dart';
import 'package:almohafez/almohafez/features/sessions/data/services/sessions_service.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:shimmer/shimmer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SessionRatingScreen extends StatefulWidget {
  final String sessionId;

  const SessionRatingScreen({super.key, required this.sessionId});

  @override
  State<SessionRatingScreen> createState() => _SessionRatingScreenState();
}

class _SessionRatingScreenState extends State<SessionRatingScreen> {
  SessionModel? _session;
  bool _isLoading = true;
  bool _isSubmitting = false;
  String? _errorMessage;

  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final List<String> _selectedTags = [];

  @override
  void initState() {
    super.initState();
    _loadSessionDetails();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
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
    } catch (e) {
      setState(() {
        _errorMessage = 'session_details_error'.tr();
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppSimpleAppBar(
        title: 'session_rating_title'.tr(),
        isBack: true,
        backgroundColor: Colors.transparent,
        titleStyle: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.bold,
          color: AppColors.primaryDark,
        ),
      ),
      body: _isLoading
          ? _buildShimmerLoading()
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
          Icon(Icons.error_outline, size: 64.sp, color: AppColors.grey),
          16.height,
          Text(
            _errorMessage!,
            style: TextStyle(fontSize: 16.sp, color: AppColors.textSecondary),
            textAlign: TextAlign.center,
          ),
          16.height,
          AppDefaultButton(
            buttonText: 'sessions_retry'.tr(),
            ontap: _loadSessionDetails,
            width: 150.w,
            height: 40.h,
          ),
        ],
      ).animate().fade().scale(),
    );
  }

  Widget _buildContent() {
    if (_session == null) return const SizedBox();

    return SingleChildScrollView(
      padding: EdgeInsets.only(bottom: 24.h),
      child: Column(
        children: [
          // Header with tutor info
          _buildHeader().animate().fade().slideY(
            begin: -0.2,
            end: 0,
            duration: 400.ms,
          ),

          // Rating section
          _buildRatingSection()
              .animate()
              .fade(delay: 200.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms),

          // Feedback section
          _buildFeedbackSection()
              .animate()
              .fade(delay: 400.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms),

          // Submit button
          _buildSubmitButton()
              .animate()
              .fade(delay: 600.ms)
              .slideY(begin: 0.2, end: 0, duration: 400.ms),

          SizedBox(height: 50.h),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(color: AppColors.backgroundPrimary),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
        child: Column(
          children: [
            // Tutor image
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.primarySuccess.withOpacity(0.2),
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primarySuccess.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: ClipOval(
                child: AppCustomImageView(
                  imagePath: _session!.tutorImageUrl,
                  width: 100.w,
                  height: 100.w,
                  fit: BoxFit.cover,
                ),
              ),
            ),

            16.height,

            // Title
            Text(
              'session_rating_question'.tr(),
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.bold,
                color: AppColors.primaryDark,
              ),
              textAlign: TextAlign.center,
            ),

            8.height,

            // Tutor name and session type
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                style: TextStyle(
                  fontSize: 16.sp,
                  color: AppColors.textSecondary,
                  fontFamily: 'Cairo',
                ),
                children: [
                  TextSpan(text: '${'session_rating_with'.tr()} '),
                  TextSpan(
                    text: _session!.tutorName,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryBlueViolet,
                    ),
                  ),
                ],
              ),
            ),

            4.height,

            Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              decoration: BoxDecoration(
                color: AppColors.primaryTurquoise.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _session!.typeDisplayName,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: AppColors.primaryTurquoise,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(24.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        children: [
          Text(
            'session_rating_rate_session'.tr(),
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: AppColors
                  .primaryDark, // Used Dark instead of Green for better readability
            ),
          ),

          24.height,

          // Star rating
          RatingBar.builder(
            initialRating: _rating,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: false,
            itemCount: 5,
            itemPadding: EdgeInsets.symmetric(horizontal: 4.0.w),
            itemBuilder: (context, _) =>
                Icon(Icons.star_rounded, color: AppColors.primaryGold),
            onRatingUpdate: (rating) {
              setState(() {
                _rating = rating;
              });
            },
          ),

          16.height,

          // Rating description
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 300),
            child: _rating > 0
                ? Text(
                    _getRatingDescription(_rating.toInt()),
                    key: ValueKey<double>(_rating),
                    style: TextStyle(
                      fontSize: 16.sp,
                      color: AppColors.primaryGold,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  )
                : SizedBox(height: 20.h),
          ),
        ],
      ),
    );
  }

  Widget _buildFeedbackSection() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: AppColors.backgroundCard,
        borderRadius: BorderRadius.circular(16.r),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: AppColors.borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.edit_note_rounded,
                color: AppColors.primaryBlueViolet,
                size: 24.sp,
              ),
              8.width,
              Text(
                'session_rating_feedback_title'.tr(),
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryDark,
                ),
              ),
            ],
          ),

          8.height,

          Text(
            'session_rating_feedback_subtitle'.tr(),
            style: TextStyle(fontSize: 12.sp, color: AppColors.textSecondary),
          ),

          16.height,

          AppDefaultTextFormField(
            controller: _feedbackController,
            type: TextInputType.multiline,
            validate: (value) {
              return null; // Optional
            },
            maxLines: 4,
            hint: 'session_rating_feedback_placeholder'.tr(),
            required: false,
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    final canSubmit = _rating > 0 && !_isSubmitting;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      width: double.infinity,
      child: AppDefaultButton(
        buttonText: 'session_rating_submit'.tr(),
        ontap: () {
          if (canSubmit) _submitRating();
        },
        isLoading: _isSubmitting,
        backgroundColor: canSubmit
            ? AppColors.primarySuccess
            : AppColors.disable,
        textColor: Colors.white,
        isAnimate: true,
      ),
    );
  }

  String _getRatingDescription(int rating) {
    switch (rating) {
      case 1:
        return 'session_rating_level_very_poor'.tr();
      case 2:
        return 'session_rating_level_poor'.tr();
      case 3:
        return 'session_rating_level_acceptable'.tr();
      case 4:
        return 'session_rating_level_good'.tr();
      case 5:
        return 'session_rating_level_excellent'.tr();
      default:
        return '';
    }
  }

  Future<void> _submitRating() async {
    if (_rating == 0) {
      Fluttertoast.showToast(
        msg: 'session_rating_select_rating'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryWarning,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final ratingModel = SessionRatingModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        sessionId: widget.sessionId,
        studentId:
            Supabase.instance.client.auth.currentUser?.id ?? 'unknown_student',
        tutorId: _session!.tutorId,
        rating: _rating,
        feedback: _feedbackController.text.trim().isNotEmpty
            ? _feedbackController.text.trim()
            : null,
        tags: _selectedTags.isNotEmpty ? _selectedTags : null,
        createdAt: DateTime.now(),
      );

      await SessionsService.submitSessionRating(ratingModel);

      // Show success message
      Fluttertoast.showToast(
        msg: 'session_rating_success'.tr(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primarySuccess,
        textColor: Colors.white,
        fontSize: 16.0,
      );

      // Navigate back
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      Fluttertoast.showToast(
        msg: '${'session_rating_error'.tr()}: $e',
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: AppColors.primaryError,
        textColor: Colors.white,
        fontSize: 16.0,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  Widget _buildShimmerLoading() {
    return SingleChildScrollView(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 16.h),
      child: Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 16.h),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Column(
                children: [
                  Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                    ),
                  ),
                  16.height,
                  Container(width: 200.w, height: 24.h, color: Colors.white),
                  8.height,
                  Container(width: 150.w, height: 16.h, color: Colors.white),
                  8.height,
                  Container(
                    width: 80.w,
                    height: 24.h,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ],
              ),
            ),
            16.height,
            Container(
              height: 150.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            16.height,
            Container(
              height: 200.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16.r),
              ),
            ),
            16.height,
            Container(
              height: 50.h,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
