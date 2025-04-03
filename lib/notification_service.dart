// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:timezone/timezone.dart' as tz;
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:permission_handler/permission_handler.dart';

// class NotificationService {
//   static final FlutterLocalNotificationsPlugin _notificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> init() async {
//     print("Initializing notifications...");
//     tz.initializeTimeZones(); // Initialize time zones

//     const AndroidInitializationSettings androidSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final InitializationSettings settings =
//         InitializationSettings(android: androidSettings);

//     await _notificationsPlugin.initialize(settings);
//     await createNotificationChannel(); // Create the notification channel
//     print("Notifications initialized successfully");
//   }

//   static Future<void> createNotificationChannel() async {
//     const AndroidNotificationChannel channel = AndroidNotificationChannel(
//       'minute_channel', // Same as in your NotificationDetails
//       'Minute Notifications',
//       description: 'Repeating notifications every minute',
//       importance: Importance.high,
//     );

//     await _notificationsPlugin
//         .resolvePlatformSpecificImplementation<
//             AndroidFlutterLocalNotificationsPlugin>()
//         ?.createNotificationChannel(channel);
//   }

//   static Future<void> showRepeatingNotification() async {
//     print("Scheduling notification...");

//     // Check and request SCHEDULE_EXACT_ALARM permission
//     if (await Permission.scheduleExactAlarm.request().isGranted) {
//       try {
//         // Schedule the first notification
//         await _notificationsPlugin.zonedSchedule(
//           0,
//           "Vitapsyche Reminder",
//           "It's Time For Sound Relaxation Let's Get Started 😊 !",
//           _nextInstanceOfTime(), // Schedule the first notification
//           const NotificationDetails(
//             android: AndroidNotificationDetails(
//               'minute_channel',
//               'Minute Notifications',
//               channelDescription: 'Repeating notifications every minute',
//               importance: Importance.high,
//               priority: Priority.high,
//             ),
//           ),
//           androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
//           uiLocalNotificationDateInterpretation:
//               UILocalNotificationDateInterpretation.absoluteTime,
//           matchDateTimeComponents: DateTimeComponents.time,
//           payload: 'minute_reminder',
//         );
//         print("Notification scheduled successfully");

//         // Use a periodic task to reschedule the notification
//         _schedulePeriodicNotifications();
//       } catch (e) {
//         print("Error scheduling notification: $e");
//       }
//     } else {
//       print("SCHEDULE_EXACT_ALARM permission not granted");
//     }
//   }

//   static tz.TZDateTime _nextInstanceOfTime() {
//     final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
//     return now.add(const Duration(minutes: 1)); // Schedule after 5 minutes
//   }

//   static void _schedulePeriodicNotifications() {
//     print("Scheduling periodic notifications...");

//     // Use a periodic task to schedule notifications every 5 minutes
//     Future.delayed(const Duration(minutes: 1), () async {
//       await showRepeatingNotification(); // Reschedule the notification
//       _schedulePeriodicNotifications(); // Continue scheduling
//     });
//   }
// }
