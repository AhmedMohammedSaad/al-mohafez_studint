import 'package:almohafez/core/routing/app_route.dart';
import 'package:almohafez/core/theme/app_theme.dart';
import 'package:almohafez/gen/fonts.gen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) => MaterialApp.router(
        routerConfig: AppRouter.router,
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
