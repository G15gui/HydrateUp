// // import 'package:flutter/material.dart';
// import 'dart:io';

// import 'package:flutter/foundation.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:flutter_timezone/flutter_timezone.dart';
// import 'package:rxdart/rxdart.dart';
// import 'package:timezone/data/latest_all.dart' as tz;
// import 'package:timezone/timezone.dart' as tz;
// // import 'package:device_info_plus/device_info_plus.dart';
// // import 'package:flutter/cupertino.dart';
// // import 'package:flutter/foundation.dart';
// // import 'package:flutter/material.dart';
// // import 'package:flutter/services.dart';
// // import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// // import 'package:flutter_timezone/flutter_timezone.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:image/image.dart' as image;
// // import 'package:path_provider/path_provider.dart';
// // import 'package:timezone/data/latest_all.dart' as tz;
// // import 'package:timezone/timezone.dart' as tz;

// class NotificationService {
//   static final NotificationsPlugin = FlutterLocalNotificationsPlugin();

//   static final onClickNotification = BehaviorSubject<String>();

//   //on tap
//   static void onTap(NotificationResponse notificationResponse) {
//     onClickNotification.add(notificationResponse.payload!);
//   }

//   static Future<void> configureLocalTimeZone() async {
//     if (kIsWeb || Platform.isLinux) {
//       return;
//     }
//     tz.initializeTimeZones();
//     final String? timeZoneName = await FlutterTimezone.getLocalTimezone();
//     tz.setLocalLocation(tz.getLocation(timeZoneName!));
//   }

//   static Future init() async {
//     await configureLocalTimeZone();

//     final androidInitializationSettings =
//         AndroidInitializationSettings('@mipmap/ic_launcher');

//     final initializationSettingsIOS = DarwinInitializationSettings(
//         requestAlertPermission: true,
//         requestBadgePermission: true,
//         requestSoundPermission: true,
//         onDidReceiveLocalNotification: (id, title, body, payload) async {});

//     final initializationSettingsLinux =
//         LinuxInitializationSettings(defaultActionName: 'Open notification');

//     final initializationSettings = InitializationSettings(
//         android: androidInitializationSettings,
//         iOS: initializationSettingsIOS,
//         linux: initializationSettingsLinux);

//     NotificationsPlugin.initialize(
//       initializationSettings,
//       // onDidReceiveNotificationResponse: onTap,
//       // onDidReceiveBackgroundNotificationResponse: onTap
//     );
//   }

//   static Future send(
//       {int id = 0, String? title, String? body, String? payload}) async {
//     AndroidNotificationDetails androidNotificationDetails =
//         const AndroidNotificationDetails('Alarms', 'Alarms',
//             importance: Importance.max, priority: Priority.high);

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     NotificationsPlugin.show(id, title, body, notificationDetails);
//   }

//   static Future cancelAll() async {
//     NotificationsPlugin.cancelAll();
//   }

//   static Future scheduler(
//       {int id = 0,
//       String? title,
//       String? body,
//       String? payload,
//       Duration duration = const Duration(seconds: 12)}) async {
//     //
//     //
//     //
//     AndroidNotificationDetails androidNotificationDetails =
//         const AndroidNotificationDetails(
//       'awrawr', 'bawrwr',
//       // channelDescription: 'channelDescription',
//       priority: Priority.defaultPriority,
//       importance: Importance.defaultImportance,
//       // fullScreenIntent: true,
//       // ticker: 'ticker'
//     );

//     NotificationDetails notificationDetails =
//         NotificationDetails(android: androidNotificationDetails);

//     print(tz.local);
//     // print(tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)));
//     await NotificationsPlugin.zonedSchedule(id, title, body,
//         tz.TZDateTime.now(tz.local).add(duration), notificationDetails,
//         // androidAllowWhileIdle: true,
//         androidScheduleMode: AndroidScheduleMode.alarmClock,
//         uiLocalNotificationDateInterpretation:
//             UILocalNotificationDateInterpretation.absoluteTime,
//         payload: payload);
//   }
// }
