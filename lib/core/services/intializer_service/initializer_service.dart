// import 'package:bloc/bloc.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:nb_utils/nb_utils.dart';
// import 'package:logger/logger.dart';

// import '../../../blocobserve.dart';
// import '../../data/local_data/caching_helper.dart';
// import '../../utils/app_consts.dart';
// import '../notification_service/local_notification_service.dart';
// import '../service_locator/service_locator.dart';

// var logger = Logger(
//   printer: PrettyPrinter(),
// );

// class AppInitializer {
//   AppInitializer();

//   static bool initialized = false;

//   Future<void> init() async {
//     try {
//       if (initialized) return;

//       /// intialize nb utils
//       await initialize();

//       AppConst.isDark = AppCacheHelper.getCachedBool(key: AppCacheHelper.isDark);
//       AppConst.accessToken = await AppCacheHelper.getSecureString(key: AppCacheHelper.accessTokenKey);
//       AppConst.accessToken = await AppCacheHelper.getSecureString(key: AppCacheHelper.refreshTokenKey);
//       AppConst.onBoarding = AppCacheHelper.getCachedBool(key: AppCacheHelper.onBoardingKey);

//       /// intialize bloc observer
//       Bloc.observer = MyBlocObserver();

//       /// intialize flutter
//       defaultInkWellSplashColor = Colors.transparent;
//       defaultInkWellHighlightColor = Colors.transparent;
//       defaultInkWellHoverColor = Colors.transparent;

//       /// intialize flutter screen util
//       await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

//       /// intialize easy localization
//       await EasyLocalization.ensureInitialized();

//       /// intialize service locator
//       ServiceLocator.init();

//       /// intialize firebase
//       await initializeLocalNotification();
//       // await initializeFirebase();

//       /// intialize local notification
//       await initializeLocalNotification();

//       initialized = true;
//     } catch (e) {
//       logger.e(e.toString());
//     }
//   }

//   Future<void> initializeUser() async {
//     try {} catch (e) {
//       logger.e(e.toString());
//     }
//   }

//   Future<void> initializeLocalNotification() async {
//     try {
//       await LocalNotificationsService.initialize();
//     } catch (e) {
//       logger.e(e.toString());
//     }
//   }

//   // Future<void> initializeFirebase() async {
//   //   try {
//   //     await Firebase.initializeApp(
//   //       // options: DefaultFirebaseOptions.currentPlatform,
//   //     );
//   //     final firebaseNotificationsService = FirebaseNotificationsService();
//   //     await firebaseNotificationsService.initFCM();
//   //   } catch (e) {
//   //     logger.e(e.toString());
//   //   }
//   // }
// }
