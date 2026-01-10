import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactUsScreen extends StatelessWidget {
  const ContactUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      appBar: AppBar(
        title: Text(
          'contact_us_title'.tr(),
          style: TextStyle(
            fontSize: 22.sp,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF0A1D64),
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF0A1D64)),
      ),
      body: Padding(
        padding: EdgeInsets.all(24.w),
        child: Column(
          children: [
            // Header Image or Icon
            Icon(
              Icons.support_agent,
              size: 80.sp,
              color: const Color(0xFF0A1D64),
            ),
            SizedBox(height: 16.h),
            Text(
              'contact_us_message'.tr(),
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16.sp, color: const Color(0xFF6B7280)),
            ),
            SizedBox(height: 32.h),

            // Contact Options
            _buildContactOption(
              icon: Icons.email,
              title: 'support_email_label'.tr(),
              subtitle: 'support_email_value'.tr(),
              color: Colors.blueAccent,
              onTap: () => _launchEmail('ahmedmohamedsaad9534@gmail.com'),
            ),
            SizedBox(height: 16.h),
            _buildContactOption(
              icon: Icons.phone,
              title: 'support_phone_label'.tr(),
              subtitle: 'support_phone_value'.tr(),
              color: Colors.green,
              onTap: () => _launchPhone('+201080941234'),
            ),
            SizedBox(height: 16.h),
            _buildContactOption(
              icon: Icons.chat,
              title: 'whatsapp_label'.tr(),
              subtitle: 'contact_via_whatsapp'.tr(),
              color: const Color(0xFF25D366),
              onTap: () => _launchWhatsApp('+201080941234'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16.r),
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16.r),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 24.sp),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF0A1D64),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: const Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16.sp, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri url = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri url = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchWhatsApp(String phone) async {
    final Uri url = Uri.parse("https://wa.me/$phone");
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
