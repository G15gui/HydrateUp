//import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';

import 'dart:convert';

import 'package:cron/cron.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import 'goalsData.dart';

Cron cron = Cron();

class SetAlarms {
  static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'channel_alarms',
    'Alarms',
    importance: Importance.max,
    priority: Priority.high,
    ticker: 'ticker',
  );

  static setupLocalNotification() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings("@mipmap/ic_launcher");

    var initializationSettingsIOS = DarwinInitializationSettings();

    var initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
        macOS: null,
        linux: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    //SetAlarms.All();
  }

  static Future notify(
    int? id,
    String? title,
    String? content,
  ) async {
    final notificationDetails = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: null,
      macOS: null,
    );

    // Show the notification
    await flutterLocalNotificationsPlugin.show(
      id ?? 0,
      title ?? '', // Use title parameter here
      content ?? '', // Use content parameter here
      notificationDetails,
      payload: '',
    );
  }

  // static Future futureNotify(
  //   String? title,
  //   String? content,
  //   DateTime? time, // Change the type to String for the time parameter
  // ) async {
  //   // Print the provided time for debugging
  //   print('Provided time: $time');

  //   // Parse the time string into a DateTime object
  //   //DateTime parsedTime = DateFormat.jm().parse(time!);
  //   DateTime parsedTime = time!;
  //   // Initialize the timezone database
  //   tzdata.initializeTimeZones();

  //   // Get the device's timezone
  //   var deviceTimeZone = tz.local;

  //   // Convert the provided time to the device's timezone
  //   var scheduledTime = tz.TZDateTime.from(parsedTime, deviceTimeZone);

  //   // Initialize the notification details
  //   final notificationDetails = NotificationDetails(
  //     android: androidPlatformChannelSpecifics,
  //     iOS: null,
  //     macOS: null,
  //   );

  //   // Schedule the notification
  //   await flutterLocalNotificationsPlugin.zonedSchedule(
  //     0,
  //     title!,
  //     content!,
  //     scheduledTime,
  //     notificationDetails,
  //     //androidAllowWhileIdle: true,
  //     uiLocalNotificationDateInterpretation:
  //         UILocalNotificationDateInterpretation.absoluteTime,
  //     matchDateTimeComponents: DateTimeComponents.time,
  //     payload: 'Custom_Sound',
  //   );

  //   //     // Schedule the notification
  //   // await flutterLocalNotificationsPlugin.periodicallyShow(
  //   //   0,
  //   //   title!,
  //   //   content!,
  //   //   //scheduledTime,
  //   //   RepeatInterval.daily,
  //   //   notificationDetails,
  //   //   androidScheduleMode: AndroidScheduleMode.exact,
  //   //   //androidAllowWhileIdle: true,
  //   //   //uiLocalNotificationDateInterpretation:
  //   //       //UILocalNotificationDateInterpretation.absoluteTime,
  //   //   //matchDateTimeComponents: DateTimeComponents.time,
  //   //   payload: 'Custom_Sound',
  //   // );
  // }
  static void All() async {
    //Map<String, dynamic> map = new Map.identity();

    // print((jsonEncode(map)));
    //int cont = 0;
    //print('-2-2');

    // cron.schedule(Schedule.parse('26 9 * * *'), () async {
    //   //print('-3-2');
    //   SetAlarms.notify(1, 'a.name', '22.22');
    // });
    cron.close();
    cron = Cron();

    for (var g in AllGoals.values) {
      for (var a in g.alarms) {
        //cont++;
        if (a.enable) {
          a.name = g.name;
          //map.putIfAbsent(cont.toString(), (() => a.toJson()));
          cron.schedule(Schedule.parse('${a.min} ${a.hours} * * *'), () async {
            SetAlarms.notify(a.id, a.name, ''); //'${a.hours}:${a.min}'
          });
        }
      }
    }
    //final SharedPreferences prefs = await SharedPreferences.getInstance();
    //await prefs.setString("nal", (jsonEncode(map)));
  }

  static void bs() async {
    var NotifyAlarmsList = List.empty(growable: true);
    var now = DateTime.now();

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.reload();
    final String? nalJson = prefs.getString('nal');

    if (nalJson != null) {
      Map<String, dynamic> jsonToNAL = jsonDecode(nalJson);

      for (var a in jsonToNAL.values) {
        NotifyAlarmsList.add(alarmData.fromJson(a));
      }
    }
    for (var n in NotifyAlarmsList) {
      {
        //print("Background service n.name : ${n.name}");

        var hour = n.hours;
        var min = n.min;
        //print("${hour}:${min} - ${now.hour}:${now.minute}");
        //print(((now.hour == hour) && (now.minute == min)));
        if ((now.hour == hour) && (now.minute == min)) {
          SetAlarms.notify(n.id, n.name, ' ');
        }
      }
    }
  }

  static void cancelBSP() async {
    var activeNotifications =
        await flutterLocalNotificationsPlugin.getActiveNotifications();
    bool isBSP = false;
    for (var n in activeNotifications) {
      if (n.id == 112233) {
        isBSP = true;
        break;
      }
    }
    if (isBSP) {
      flutterLocalNotificationsPlugin.cancel(112233);
    }
    // for (var g in AllGoals.values) {
    //   for (var a in g.alarms) {
    //     await AndroidAlarmManager.cancel(a.id);
    //   }
    // }
  }

  static void cancelAll() async {
    // for (var g in AllGoals.values) {
    //   for (var a in g.alarms) {
    //     await AndroidAlarmManager.cancel(a.id);
    //   }
    // }
  }

  // static void schedule(int id, int hour, int min, String title, String body,
  //     {String? payload}) {
  //   //
  //   var now = DateTime.now();
  //   var scheduleTime = DateTime(now.year, now.month, now.day, hour, min, 0, 0);
  //   var difference = scheduleTime.difference(now);
  //   //var difference = Duration(seconds: 2);

  //   if (difference.isNegative) {
  //     difference += Duration(days: 1);
  //     scheduleTime.add(Duration(days: 1));
  //   }
  //   print("schedule: ${hour}:${min} , ${difference}");
  //   //

  //   // AndroidAlarmManager.cancel(id);
  //   // return;

  //   AndroidAlarmManager.periodic(Duration(hours: 24), id, send,
  //       startAt: scheduleTime,
  //       allowWhileIdle: true,
  //       params: {
  //         'id': id,
  //         'title': title,
  //         'body': body,
  //         'payload': payload,
  //       });
  // }

  // static send(int id, Map<String, dynamic> map) {
  //   var title = map['title'];
  //   var body = map['body'];
  //   var payload = map['payload'];
  //   NotificationService.send(
  //       id: id, title: title, body: body, payload: payload);
  //   //AndroidAlarmManager.cancel(id);
  // }
}
