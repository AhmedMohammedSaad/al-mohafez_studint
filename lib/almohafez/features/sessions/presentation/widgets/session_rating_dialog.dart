import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';

class SessionRatingDialog extends StatefulWidget {
  final String tutorName;
  final String tutorImageUrl;
  final Function(double rating, String? comment, List<String> tags) onSubmit;

  const SessionRatingDialog({
    super.key,
    required this.tutorName,
    required this.tutorImageUrl,
    required this.onSubmit,
  });

  @override
  State<SessionRatingDialog> createState() => _SessionRatingDialogState();
}

class _SessionRatingDialogState extends State<SessionRatingDialog> {
  double _rating = 0;
  final TextEditingController _commentController = TextEditingController();
  final List<String> _selectedTags = [];

  final List<String> _positiveTags = [
    'session_rating_tag_excellent',
    'session_rating_tag_helpful',
    'session_rating_tag_clear',
    'session_rating_tag_patient',
    'session_rating_tag_skilled',
    'session_rating_tag_inspiring',
  ];

  final List<String> _negativeTags = [
    'session_rating_tag_connection_issues',
    'session_rating_tag_late',
    'session_rating_tag_unclear',
    'session_rating_tag_rushed',
  ];

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  List<String> get _currentTags => _rating >= 4 ? _positiveTags : _negativeTags;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.r)),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: Container(
        padding: EdgeInsets.all(20.w),
        decoration: BoxDecoration(
          color: AppColors.backgroundCard,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Header
              Text(
                'session_rating_title'.tr(),
                style: AppTextStyle.h5.copyWith(
                  color: AppColors.primaryBlueViolet,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.h),

              // Tutor Info
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24.r,
                    backgroundImage: NetworkImage(widget.tutorImageUrl),
                    onBackgroundImageError: (_, __) {},
                    child: widget.tutorImageUrl.isEmpty
                        ? Icon(Icons.person, color: Colors.white)
                        : null,
                  ),
                  SizedBox(width: 12.w),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'session_rating_with'.tr(),
                        style: AppTextStyle.regular12.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      Text(
                        widget.tutorName,
                        style: AppTextStyle.medium16.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24.h),

              // Rating Bar
              Text(
                'session_rating_question'.tr(),
                style: AppTextStyle.medium14,
              ),
              SizedBox(height: 12.h),
              RatingBar.builder(
                initialRating: 0,
                minRating: 1,
                direction: Axis.horizontal,
                allowHalfRating: true,
                itemCount: 5,
                itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                itemBuilder: (context, _) =>
                    Icon(Icons.star_rounded, color: AppColors.primaryGold),
                onRatingUpdate: (rating) {
                  setState(() {
                    _rating = rating;
                    _selectedTags.clear(); // Reset tags on rating change
                  });
                },
              ),
              SizedBox(height: 8.h),
              Text(
                _getRatingLabel(_rating),
                style: AppTextStyle.medium14.copyWith(
                  color: AppColors.primaryGold,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 24.h),

              // Tags
              if (_rating > 0) ...[
                Text(
                  'session_rating_what_liked'.tr(),
                  style: AppTextStyle.medium14,
                ),
                SizedBox(height: 12.h),
                Wrap(
                  spacing: 8.w,
                  runSpacing: 8.h,
                  alignment: WrapAlignment.center,
                  children: _currentTags.map((tagKey) {
                    final isSelected = _selectedTags.contains(tagKey);
                    return FilterChip(
                      label: Text(tagKey.tr()),
                      selected: isSelected,
                      onSelected: (selected) {
                        setState(() {
                          if (selected) {
                            _selectedTags.add(tagKey);
                          } else {
                            _selectedTags.remove(tagKey);
                          }
                        });
                      },
                      backgroundColor: AppColors.backgroundSection,
                      selectedColor: AppColors.primaryBlueViolet.withOpacity(
                        0.1,
                      ),
                      checkmarkColor: AppColors.primaryBlueViolet,
                      labelStyle: AppTextStyle.regular12.copyWith(
                        color: isSelected
                            ? AppColors.primaryBlueViolet
                            : AppColors.textSecondary,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                        side: BorderSide(
                          color: isSelected
                              ? AppColors.primaryBlueViolet
                              : Colors.transparent,
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 24.h),
              ],

              // Comment Field
              TextField(
                controller: _commentController,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: 'session_rating_comment_hint'.tr(),
                  hintStyle: AppTextStyle.regular14.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  filled: true,
                  fillColor: AppColors.backgroundSection,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding: EdgeInsets.all(16.w),
                ),
              ),
              SizedBox(height: 24.h),

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _rating > 0
                      ? () {
                          widget.onSubmit(
                            _rating,
                            _commentController.text,
                            _selectedTags,
                          );
                          Navigator.of(context).pop();
                        }
                      : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlueViolet,
                    disabledBackgroundColor: AppColors.textSecondary
                        .withOpacity(0.3),
                    padding: EdgeInsets.symmetric(vertical: 16.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.r),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    'session_rating_submit'.tr(),
                    style: AppTextStyle.buttonLarge.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 12.h),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(
                  'meeting_cancel'.tr(),
                  style: AppTextStyle.medium14.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _getRatingLabel(double rating) {
    if (rating == 0) return 'session_rating_please_rate'.tr();
    if (rating >= 5) return 'session_rating_excellent'.tr();
    if (rating >= 4) return 'session_rating_good'.tr();
    if (rating >= 3) return 'session_rating_fair'.tr();
    if (rating >= 2) return 'session_rating_poor'.tr();
    return 'session_rating_very_poor'.tr();
  }
}
