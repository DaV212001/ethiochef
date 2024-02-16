import 'dart:async';
import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:timezone/timezone.dart' as tz;
class NotificationScheduled{
  static final _notifications = FlutterLocalNotificationsPlugin();
  static final onNotifications = BehaviorSubject<String?>();
  static Future notificationDetails() async{
    return NotificationDetails(
      android: AndroidNotificationDetails(
        'channel id',
        'channel name',
        channelDescription: 'channel description',
        importance: Importance.max,
          icon: '@drawable/ic_launcher2'
      ),
      iOS: DarwinNotificationDetails()
    );
  }
  static Future init({bool initScheduled = false}) async{
    final android = AndroidInitializationSettings('@drawable/ic_launcher2');
    final iOS = DarwinInitializationSettings();
    final settings = InitializationSettings(
      android: android,
      iOS: iOS
    );
    await _notifications.initialize(
      settings,
        onDidReceiveNotificationResponse:(payload)async{
          print(payload);
          final message = RemoteMessage.fromMap(jsonDecode(payload as String));

        }
    );
  }
  static Future showNotification({
    int id = 0,
    String? title,
    String? body,
    String? payload,
})async=>
      _notifications.show(
          id,
          title,
          body,
          await notificationDetails(),
          payload: payload);

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
  static tz.TZDateTime _scheduleDaily(Timer time){
    final now = tz.TZDateTime.now(tz.local);
    final scheduleDate = tz.TZDateTime(
      tz.local,
      now.year,
      now.month,
      now.day,
      now.hour,
      now.minute,
      now.second
    );
    return scheduleDate.isBefore(now)
        ? scheduleDate.add(Duration(days: 1))
        : scheduleDate;
  }
  static Future<void> scheduleNotifications() async {
  tz.setLocalLocation(tz.getLocation('Africa/Addis_Ababa')); // Set the local timezone to Addis Ababa

    final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    const AndroidInitializationSettings initializationSettingsAndroid = AndroidInitializationSettings('@drawable/ic_launcher2');
    final InitializationSettings initializationSettings = InitializationSettings(android: initializationSettingsAndroid);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);

    // Define the notification details
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'channel_id',
        'channel_name',
        channelDescription: 'channel_description',
        importance: Importance.defaultImportance,
        icon: '@drawable/ic_launcher2'
    );
    const NotificationDetails platformChannelSpecifics = NotificationDetails(android: androidPlatformChannelSpecifics);

    final List<DateTime> notificationTimes = [
      DateTime.now().add(Duration(seconds: 2)), // 2:00 AM
      DateTime.now().add(Duration(seconds: 3)), // 7:00 AM
      DateTime.now().add(Duration(seconds: 5)), // 11:00 AM
      DateTime.now().add(Duration(seconds: 8)), // 2:00 PM
    ];
    for (final time in notificationTimes) {
      tz.TZDateTime scheduledDate = tz.TZDateTime.from(
        time,
        tz.local,
      );

      // Add 4 seconds to the scheduled time
      scheduledDate = scheduledDate.add(Duration(seconds: 4));

      await flutterLocalNotificationsPlugin.zonedSchedule(
        0, // Notification ID
        'Scheduled Notification',
        'This notification is scheduled to run at specific times',
        scheduledDate,
        const NotificationDetails(
            android: AndroidNotificationDetails(
                'your channel id', 'your channel name',
                importance: Importance.defaultImportance)),
        androidAllowWhileIdle: true,
        uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
        payload: 'Scheduled Notification',
        matchDateTimeComponents: DateTimeComponents.time
      );
    }
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