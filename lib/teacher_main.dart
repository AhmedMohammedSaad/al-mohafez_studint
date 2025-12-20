import 'package:almohafez/almohafez/core/presentation/view_model/cubit/app_cubit.dart';
import 'package:almohafez/almohafez_teacher/core/presentation/view/main_screen.dart';
import 'package:almohafez/almohafez_teacher/features/onboarding/presentation/views/welcome_onboarding_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:nb_utils/nb_utils.dart';
import 'almohafez_teacher/features/profile/presentation/cubit/teacher_profile_cubit.dart';
import 'almohafez_teacher/features/profile/data/repos/teacher_profile_repo.dart';
import 'package:almohafez/almohafez/core/theme/app_theme.dart';
import 'package:almohafez/gen/fonts.gen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'almohafez_teacher/features/students/presentation/cubit/teacher_students_cubit.dart';
import 'almohafez_teacher/features/students/data/repositories/teacher_students_repo.dart';
import 'almohafez_teacher/features/students/presentation/cubit/student_details_cubit.dart';
import 'almohafez_teacher/features/students/data/repositories/student_details_repo.dart';
import 'almohafez_teacher/features/sessions/presentation/cubit/sessions_cubit.dart';
import 'almohafez_teacher/features/sessions/data/repositories/sessions_repo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();

  await Supabase.initialize(
    url: 'https://tghyxcxvvnvkcaflsohk.supabase.co',
    anonKey: 'sb_secret_3nsmTWIOuaNwrpGwA3HG1w_JlyPDnUj',
  );

  // Initialize nb_utils for SharedPreferences
  await initialize();

  runApp(
    EasyLocalization(
      supportedLocales: const [Locale('ar'), Locale('en')],
      path: 'assets/translations',
      fallbackLocale: const Locale('ar'),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => AppCubit()),
          BlocProvider(
            create: (context) =>
                TeacherProfileCubit(TeacherProfileRepo())..loadProfile(),
          ),
          BlocProvider(
            create: (_) => TeacherStudentsCubit(TeacherStudentsRepo()),
          ),
          BlocProvider(
            create: (_) => StudentDetailsCubit(StudentDetailsRepo()),
          ),
          BlocProvider(
            create: (_) =>
                SessionsCubit(SessionsRepo(Supabase.instance.client))
                  ..loadSessions(),
          ),
        ],
        child: MyApp(),
      ),
    ),
  );
}

class MyApp extends StatelessWidget {
  checkAuthAndNavigate(BuildContext context) {
    final user = Supabase.instance.client.auth.currentUser;

    if (user != null && user.id.isNotEmpty) {
      return MainScreen();
    } else {
      return WelcomeOnboardingScreen();
    }
  }

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      builder: (_, __) => MaterialApp(
        home: checkAuthAndNavigate(context),
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
