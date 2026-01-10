import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_animate/flutter_animate.dart';

class WelcomeBarWidget extends StatelessWidget {
  const WelcomeBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Builder(
            builder: (context) {
              final user = Supabase.instance.client.auth.currentUser;
              final name =
                  user?.userMetadata?['first_name'] ?? 'profile_user_name'.tr();
              return Text(
                'welcome_greeting'.tr(namedArgs: {'username': name}),
                style: TextStyle(
                  fontSize: 22.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF0A1D64),
                ),
              ).animate().custom(
                duration: 2000.ms,
                builder: (context, value, child) {
                  // We need the full text text to substring it
                  String fullText = 'welcome_greeting'.tr(
                    namedArgs: {'username': name},
                  );

                  // Use characters to handle emojis and unicode correctly
                  // invalid UTF-16 error happens when splitting surrogate pairs
                  final textChars = fullText.characters;
                  int count = (value * textChars.length).toInt();
                  String visibleText = textChars.take(count).toString();

                  return Text(
                    visibleText,
                    style: TextStyle(
                      fontSize: 22.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A1D64),
                    ),
                  );
                },
              );
            },
          ),
          SizedBox(height: 4.h),
          Text(
            'welcome_message'.tr(),
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.normal,
              color: const Color(0xFF5B6C9F),
            ),
          ),
        ],
      ),
    );
  }
}
