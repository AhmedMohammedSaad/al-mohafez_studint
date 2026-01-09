import 'package:almohafez/almohafez/features/authentication/presentation/views/login_screen.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import '../widgets/app_logo_widget.dart';
import '../widgets/central_illustration_widget.dart';
import '../widgets/main_content_widget.dart';
import '../widgets/language_toggle_widget.dart';
import '../widgets/cta_button_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class WelcomeOnboardingScreen extends StatefulWidget {
  const WelcomeOnboardingScreen({super.key});

  @override
  State<WelcomeOnboardingScreen> createState() =>
      _WelcomeOnboardingScreenState();
}

class _WelcomeOnboardingScreenState extends State<WelcomeOnboardingScreen> {
  bool isArabic = true;
  final player = AudioPlayer();
  bool onBoardingShow = false;
  @override
  void initState() {
    playAudio();
    super.initState();
  }

  void playAudio() async {
    await player.play(AssetSource('audio.mp3'));
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // تحديد اللغة الحالية بعد تهيئة السياق
    isArabic = context.locale.languageCode == 'ar';
  }

  void _toggleLanguage() {
    setState(() {
      isArabic = !isArabic;
      if (isArabic) {
        context.setLocale(const Locale('ar'));
      } else {
        context.setLocale(const Locale('en'));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFE8E2F7), // بنفسجي فاتح
              Color(0xFFB8E6E6), // تركواز هادئ
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                // شعار التطبيق
                AppLogoWidget(
                  key: ValueKey('app_logo_${context.locale.languageCode}'),
                ),

                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // العنصر المركزي
                      const CentralIllustrationWidget(),

                      SizedBox(height: 40.h),

                      // النص الرئيسي
                      MainContentWidget(
                        key: ValueKey(
                          'main_content_${context.locale.languageCode}',
                        ),
                      ),

                      SizedBox(height: 30.h),

                      // مفتاح تبديل اللغة
                      LanguageToggleWidget(
                        isArabic: isArabic,
                        onToggle: _toggleLanguage,
                      ),

                      SizedBox(height: 40.h),

                      // زر الدعوة للعمل
                      CTAButtonWidget(
                        key: ValueKey(
                          'cta_button_${context.locale.languageCode}',
                        ),
                        onPressed: () => _onStartJourney(context),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _onStartJourney(BuildContext context) async {
    // حفظ أن المستخدم شاهد الـ onboarding
    await setValue('onBoardingShow', true);
    print('✅ [Onboarding] Saved onBoardingShow = true');

    // التأكد من الحفظ
    final saved = getBoolAsync('onBoardingShow');
    print('🔍 [Onboarding] Verification: onBoardingShow = $saved');

    // الانتقال إلى شاشة تسجيل الدخول
    if (mounted) {
      // onBoardingShow = true;
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
      // PrefsHelper.saveBool('onBoardingShow', onBoardingShow);
    }
  }
}
