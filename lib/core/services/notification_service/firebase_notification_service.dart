// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import '../intializer_service/initializer_service.dart';
// import 'local_notification_service.dart';
//
// class FirebaseNotificationsService {
//   FirebaseMessaging? _firebaseMessaging;
//
//   bool initialized = false;
//
//   String userToken = '';
//
//   // Initialize Firebase Messaging
//   Future<FirebaseMessaging> _init() async {
//     try {
//       logger.i('Initializing firebase notifications...');
//       final FirebaseMessaging fcm = FirebaseMessaging.instance;
//
//       // Request permissions
//       await fcm.requestPermission(
//         sound: true,
//         alert: true,
//         badge: true,
//         criticalAlert: true,
//       );
//
//       // Subscribe to topic
//       fcm.subscribeToTopic('dr_you');
//       _firebaseMessaging = fcm;
//
//       return fcm;
//     } catch (e) {
//       logger.e(e.toString());
//       rethrow;
//     }
//   }
//
//   // Setup FCM token and update ViewModel
//   Future<String?> setupToken() async {
//     try {
//       if (_firebaseMessaging == null) {
//         await _init();
//       }
//       String token = await _firebaseMessaging!.getToken() ?? '';
//       userToken = token;
//       // Assuming you have a ViewModel for managing state, you can update it
//       // For example: yourViewModel.updateFcmToken(token);
//       return token;
//     } catch (e) {
//       logger.e(e.toString());
//       rethrow;
//     }
//   }
//
//   // Initialize FCM listeners for foreground, background, and app launch events
//   Future<void> initFCM() async {
//     try {
//       if (initialized) return;
//
//       await setupToken();
//
//       // Foreground message listener
//       FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//         logger.i('A new onMessage event was published!');
//         if (message.notification != null) {
//           logger.i('--->  ${message.toMap()}');
//         }
//         // Show notification
//         await LocalNotificationsService.showNotification(
//           message.notification?.title ?? '',
//           message.notification?.body ?? '',
//         );
//       });
//
//       // App opened from background notification
//       FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
//         logger.i('A new onMessageOpenedApp event was published!');
//         await LocalNotificationsService.showNotification(
//           message.notification?.title ?? '',
//           message.notification?.body ?? '',
//         );
//       });
//
//       // Handle background messages
//       FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
//
//       initialized = true;
//     } catch (e) {
//       logger.e(e.toString());
//     }
//   }
//
//   // Handle background message
//   @pragma('vm:entry-point')
//   static Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//     await Firebase.initializeApp(
//         // options: DefaultFirebaseOptions.currentPlatform,
//         );
//
//     logger.i("Handling a background message: ${message.messageId}");
//   }
// }
