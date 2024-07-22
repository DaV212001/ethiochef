import 'dart:async';

import 'package:ethio_chef/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import '../screens/from_scheduled_notif.dart';

void backGroundhandler(NotificationResponse payload) {
  onSelectNotification(payload.payload, navigatorKey.currentContext!);
}

void onSelectNotification(String? payload, BuildContext context) async {
  print(payload);
  if (payload!.startsWith('Scheduled Notification')) {
    // Navigate to FromNotif when the scheduled notification is tapped
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      screen: FromNotif(
        timeOfDay: payload.replaceFirst('Scheduled Notification :', ''),
      ),
    );
  }
}

class NotificationScheduled {
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static Future notificationDetails() async {
    return NotificationDetails(
        android: AndroidNotificationDetails('channel id', 'channel name',
            channelDescription: 'channel description',
            importance: Importance.max,
            icon: '@drawable/ic_launcher2'),
        iOS: DarwinNotificationDetails());
  }

  static Future init(
      {required BuildContext context, bool initScheduled = false}) async {
    final android = AndroidInitializationSettings('@drawable/ic_launcher2');
    final iOS = DarwinInitializationSettings();
    final settings = InitializationSettings(android: android, iOS: iOS);
    await _notifications.initialize(settings,
        onDidReceiveNotificationResponse: (payload) async {
      print(payload);
      // Check if the tapped notification is a scheduled one
      if (payload.payload!.startsWith('Scheduled Notification')) {
        // Navigate to FromNotif when the scheduled notification is tapped
        PersistentNavBarNavigator.pushNewScreen(context,
            withNavBar: false,
            screen: FromNotif(
              timeOfDay:
                  payload.payload!.replaceFirst('Scheduled Notification :', ''),
            ));
      }
    }, onDidReceiveBackgroundNotificationResponse: backGroundhandler);
  }

  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
  }) async {
    print('CALLLLLLEDDDDD NOTIF');
    _notifications.show(id, title, body, await notificationDetails(),
        payload: payload);
  }

  static Future showScheduledNotification(
      {int id = 0,
      String? title,
      String? body,
      String? payLoad,
      required DateTime scheduledNotificationDateTime}) async {
    return _notifications.zonedSchedule(
        id,
        title,
        body,
        tz.TZDateTime.from(
          scheduledNotificationDateTime,
          tz.local,
        ),
        await notificationDetails(),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime);
  }

  static tz.TZDateTime _scheduleDaily(Timer time) {
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(tz.local, now.year, now.month, now.day,
        now.hour, now.minute, now.second);
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(Duration(days: 1))
        : scheduleDate;
  }

  static Future<void> scheduleNotifications() async {
    tz.initializeTimeZones();
    tz.setLocalLocation(tz.getLocation(
        'Africa/Addis_Ababa')); // Set the local timezone to Addis Ababa

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
        FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@drawable/ic_launcher2');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Define the notification details
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id', 'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.defaultImportance,
        icon: '@drawable/ic_launcher2');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    final List<TimeOfDay> notificationTimes = [
      TimeOfDay(hour: 7, minute: 0),
      TimeOfDay(hour: 12, minute: 30),
      TimeOfDay(hour: 17, minute: 0),
      TimeOfDay(hour: 19, minute: 30),
    ];

    for (final time in notificationTimes) {
      final tz.TZDateTime scheduledDate = _nextInstanceOf(time);
      print(
          'SHEDDDDDDDDDDDDLLLLLLLLLEDDDDDDDDDDDDDDFIRRRRRRRRRRR: $scheduledDate');
      await flutterLocalNotificationsPlugin.zonedSchedule(
        notificationTimes.indexOf(time), // Notification ID
        'ኢትዮ ሼፍ',
        '${notificationTimes.indexOf(time) == 0 ? 'ለቁርስ ጠቃሚ ምክር' : notificationTimes.indexOf(time) == 1 ? 'ለምሳ ጠቃሚ ምክር' : notificationTimes.indexOf(time) == 2 ? 'ለመክሰስ ጠቃሚ ምክር' : 'ለእራት ጠቃሚ ምክር'}',
        scheduledDate,
        const NotificationDetails(
            android: AndroidNotificationDetails('channel id', 'channel name',
                importance: Importance.defaultImportance)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload:
            'Scheduled Notification :${notificationTimes.indexOf(time) == 0 ? 'breakfast' : notificationTimes.indexOf(time) == 1 ? 'lunch' : notificationTimes.indexOf(time) == 2 ? 'supper' : 'dinner'}', // Unique payload for each notification
        matchDateTimeComponents: DateTimeComponents.time,
      );
    }
  }

  static tz.TZDateTime _nextInstanceOf(TimeOfDay time) {
    final tz.TZDateTime now = tz.TZDateTime.now(tz.local);
    tz.TZDateTime scheduledDate = tz.TZDateTime(tz.local, now.year, now.month,
        now.day, time.hour, time.minute, 0, 0, 0);

    if (scheduledDate.isBefore(now)) {
      scheduledDate = scheduledDate.add(const Duration(days: 1));
    }

    return scheduledDate;
  }

// Future<void> _showMessagingNotification() async {
  //   // use a platform channel to resolve an Android drawable resource to a URI.
  //   // This is NOT part of the notifications plugin. Calls made over this
  //   /// channel is handled by the app
  //   final String? imageUri = await platform.invokeMethod('drawableToUri', 'food');
  //
  //   /// First two person objects will use icons that part of the Android app's
  //   /// drawable resources
  //   const Person me = Person(
  //     name: 'Me',
  //     key: '1',
  //     uri: 'tel:1234567890',
  //     icon: DrawableResourceAndroidIcon('me'),
  //   );
  //   const Person coworker = Person(
  //     name: 'Coworker',
  //     key: '2',
  //     uri: 'tel:9876543210',
  //     icon: FlutterBitmapAssetAndroidIcon('icons/coworker.png'),
  //   );
  //   // download the icon that would be use for the lunch bot person
  //
  //   // this person object will use an icon that was downloaded
  //   final Person lunchBot = Person(
  //     name: 'Lunch bot',
  //     key: 'bot',
  //     bot: true,
  //     icon: BitmapFilePathAndroidIcon(largeIconPath),
  //   );
  //   final Person chef = Person(
  //       name: 'Master Chef',
  //       key: '3',
  //       uri: 'tel:111222333444',
  //       icon: ByteArrayAndroidIcon.fromBase64String(
  //           await _base64encodedImage('https://placekitten.com/48/48')));
  //
  //   final List<Message> messages = <Message>[
  //     Message('Hi', DateTime.now(), null),
  //     Message("What's up?", DateTime.now().add(const Duration(minutes: 5)), coworker),
  //     Message('Lunch?', DateTime.now().add(const Duration(minutes: 10)), null,
  //         dataMimeType: 'image/png', dataUri: imageUri),
  //     Message('What kind of food would you prefer?',
  //         DateTime.now().add(const Duration(minutes: 10)), lunchBot),
  //     Message('You do not have time eat! Keep working!',
  //         DateTime.now().add(const Duration(minutes: 11)), chef),
  //   ];
  //   final MessagingStyleInformation messagingStyle = MessagingStyleInformation(me,
  //       groupConversation: true,
  //       conversationTitle: 'Team lunch',
  //       htmlFormatContent: true,
  //       htmlFormatTitle: true,
  //       messages: messages);
  //   final AndroidNotificationDetails androidNotificationDetails = AndroidNotificationDetails(
  //       'message channel id', 'message channel name',
  //       channelDescription: 'message channel description',
  //       category: AndroidNotificationCategory.message,
  //       styleInformation: messagingStyle);
  //   final NotificationDetails notificationDetails =
  //   NotificationDetails(android: androidNotificationDetails);
  //   await _notifications.show(
  //       2, 'message title', 'message body', notificationDetails);
  //
  //   // wait 10 seconds and add another message to simulate another response
  //   await Future<void>.delayed(const Duration(seconds: 10), () async {
  //     messages.add(Message("I'm so sorry!!! But I really like thai food ...",
  //         DateTime.now().add(const Duration(minutes: 11)), null));
  //     await _notifications.show(
  //         3, 'message title', 'message body', notificationDetails);
  //   });
  // }
}
