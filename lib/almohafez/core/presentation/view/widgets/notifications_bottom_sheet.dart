import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:almohafez/almohafez/core/presentation/view/widgets/app_custom_image_view.dart';
import 'package:almohafez/almohafez/core/theme/app_colors.dart';
import 'package:almohafez/almohafez/core/theme/app_text_style.dart';
import 'package:almohafez/almohafez/core/utils/app_strings.dart';
import 'package:almohafez/generated/assets.dart';

class NotificationsBottomSheet extends StatelessWidget {
  const NotificationsBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.6,
      ),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(AppStrings.notifications, style: AppTextStyle.h2),
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.primaryColor2.withValues(alpha: 0.1),
                  ),
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    color: AppColors.primaryColor2,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          // Notifications list
          Flexible(
            child: ListView.separated(
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              itemCount: 7, // Number of notifications
              separatorBuilder: (context, index) =>
                  const Divider(indent: 16, endIndent: 16, height: 1),
              itemBuilder: (context, index) => _buildNotificationItem(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 50.w,
            height: 50.h,
            padding: const EdgeInsets.all(8),
            child: const AppCustomImageView(imagePath: AssetData.money),
          ),
          12.width,
          // Notification content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Redemption', style: AppTextStyle.h5),
                4.height,
                Text(
                  '3,643 tasks was moved to a new workflow',
                  style: AppTextStyle.b1,
                ),
                8.height,
                Text(
                  'Yesterday at 11:30PM',
                  style: AppTextStyle.b5.copyWith(color: AppColors.gray2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
