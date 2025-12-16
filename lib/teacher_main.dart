import 'package:almohafez/almohafez/core/helper/lifecycle_maneger/shardpref.dart';
import 'package:almohafez/almohafez/core/presentation/view/main_screen.dart';
import 'package:almohafez/almohafez/features/authentication/presentation/views/login_screen.dart';
import 'package:almohafez/almohafez/features/onboarding/presentation/views/welcome_onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:almohafez/almohafez/core/theme/app_theme.dart';
import 'package:almohafez/gen/fonts.gen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  final bool onBoardingShown =
      await PrefsHelper.getBool('onBoardingShow') ?? false;

  await initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      child: MyApp(onBoardingShown: onBoardingShown),
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool onBoardingShown;
  checkAuthAndNavigate(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null && user.id.isNotEmpty) {
      return MainScreen();
    } else {
      return LoginScreen();
    }
  }

  const MyApp({super.key, required this.onBoardingShown});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) => MaterialApp(
        home: onBoardingShown
            ? const WelcomeOnboardingScreen()
            : checkAuthAndNavigate(context),
        locale: context.locale,
        supportedLocales: context.supportedLocales,
        localizationsDelegates: context.localizationDelegates,
        debugShowCheckedModeBanner: false,
        theme: AppTheme.appLightTheme(
          context.locale.languageCode == 'ar'
              ? FontFamily.cairo
              : FontFamily.roboto,
        ),
        // darkTheme: AppTheme.appDarkTheme(
        // context.locale.languageCode == 'ar'
        // ? FontFamily.cairo
        // : FontFamily.roboto,
        // ),
      ),
    );
  }
}
