// import 'package:flutter_local_notifications/flutter_local_notifications.dart';

// class LocalNotificationsService {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

//   static Future<void> initialize() async {
//     const AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings('@mipmap/ic_launcher');
//     const DarwinInitializationSettings initializationSettingsDarwin = DarwinInitializationSettings();
//     const InitializationSettings initializationSettings =
//         InitializationSettings(android: initializationSettingsAndroid, iOS: initializationSettingsDarwin);

//     await flutterLocalNotificationsPlugin.initialize(initializationSettings);
//   }

//   static Future<void> showNotification(String title, String content) async {
//     const AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
//       'DrYou',
//       'DrYou',
//       channelDescription: 'Dr You Notification Channel',
//       importance: Importance.max,
//       priority: Priority.high,
//       ticker: 'ticker',
//     );

//     const DarwinNotificationDetails iosNotificationDetails = DarwinNotificationDetails(
//       threadIdentifier: 'DrYou',
//     );

//     const NotificationDetails notificationDetails = NotificationDetails(
//       android: androidNotificationDetails,
//       iOS: iosNotificationDetails,
//     );

//     await flutterLocalNotificationsPlugin.show(
//       0,
//       title,
//       content,
//       notificationDetails,
//     );
//   }
// }

