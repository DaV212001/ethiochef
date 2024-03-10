import 'dart:convert';

import 'package:ethio_chef/services/scheduled_notification_service.dart';
import 'package:ethio_chef/services/user_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';
import '../utils/constants.dart';
import 'authorization_service.dart';

class FirebaseService {
  final _firebaseMessaging = FirebaseMessaging.instance;
  final _androidChannel = const AndroidNotificationChannel(
      'high_importance_channel', 'High Importance Notifications',
      description: "This channel is used for important notifications",
      importance: Importance.high);
  final _localNotifications = FlutterLocalNotificationsPlugin();

  void handleMessage(RemoteMessage? message) async {
    print("here 1");
    if (message!.notification == null) return;
    if(message.notification?.title == 'breakfast'){
      await NotificationScheduled.showNotification(
          title: 'ኢትዮ ሼፍ',
          body: 'ለቁርስ ጠቃሚ ምክር',
          payload: 'Scheduled Notification :${message.notification?.title}'
      );
    }
    else if(message.notification?.title == 'lunch'){
      await NotificationScheduled.showNotification(
          title: 'ኢትዮ ሼፍ',
          body: 'ለምሳ ጠቃሚ ምክር',
          payload: 'Scheduled Notification :${message.notification?.title}'
      );
    }
    else if(message.notification?.title == 'supper'){
      await NotificationScheduled.showNotification(
          title: 'ኢትዮ ሼፍ',
          body: 'ለመክሰስ ጠቃሚ ምክር',
          payload: 'Scheduled Notification :${message.notification?.title}'
      );
    }
    else if(message.notification?.title == 'dinner'){
      await NotificationScheduled.showNotification(
          title: 'ኢትዮ ሼፍ',
          body: 'ለእራት ጠቃሚ ምክር',
          payload: 'Scheduled Notification :${message.notification?.title}'
      );
    } else{
      await _localNotifications.show(
          message.notification.hashCode,
          message.notification?.title,
          message.notification?.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id, _androidChannel.name,
                channelDescription: _androidChannel.description,
                priority: Priority.max,
                icon: '@drawable/ic_launcher2'
            ),
          ),
          payload: jsonEncode(message.toMap()));
    }
  }

  Future initPushNotifications() async {
    print("here 2");
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
        alert: true, badge: true, sound: true);
    await FirebaseMessaging.instance.requestPermission(
      announcement: true,
      carPlay: true,
      criticalAlert: true,
    );
    print("here 3");
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);
    print("here 4");
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
    print("here 5");
    FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
    print("here 6");
    FirebaseMessaging.onMessage.listen((message) async {
      print("here 7");
      final notification = message.notification;
      print("here 8");
      if (notification == null) return;
      if(message.notification?.title == 'breakfast'){
        await NotificationScheduled.showNotification(
          title: 'ኢትዮ ሼፍ',
          body: 'ለቁርስ ጠቃሚ ምክር',
          payload: 'Scheduled Notification :${message.notification?.title}'
        );
      }
      else if(message.notification?.title == 'lunch'){
        await NotificationScheduled.showNotification(
            title: 'ኢትዮ ሼፍ',
            body: 'ለምሳ ጠቃሚ ምክር',
            payload: 'Scheduled Notification :${message.notification?.title}'
        );
      }
      else if(message.notification?.title == 'supper'){
        await NotificationScheduled.showNotification(
            title: 'ኢትዮ ሼፍ',
            body: 'ለመክሰስ ጠቃሚ ምክር',
            payload: 'Scheduled Notification :${message.notification?.title}'
        );
      }
      else if(message.notification?.title == 'dinner'){
        await NotificationScheduled.showNotification(
            title: 'ኢትዮ ሼፍ',
            body: 'ለእራት ጠቃሚ ምክር',
            payload: 'Scheduled Notification :${message.notification?.title}'
        );
      } else{
      await _localNotifications.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
                _androidChannel.id, _androidChannel.name,
                channelDescription: _androidChannel.description,
                priority: Priority.max,
                icon: '@drawable/ic_launcher2'
                ),
          ),
          payload: jsonEncode(message.toMap()));
      }
      print("here 9");
    });
  }

  Future<void> initNotification() async {
    await _firebaseMessaging.requestPermission();
    final fCMToken = await _firebaseMessaging.getToken();
    print('Token: $fCMToken');
    initPushNotifications();
  }

  Future initLocalNotifications() async {
    const iOS = DarwinInitializationSettings();
    const android = AndroidInitializationSettings('ic_launcher2');
    const setting = InitializationSettings(
      android: android,
      iOS: iOS,
    );
    await _localNotifications.initialize(setting,
        onDidReceiveNotificationResponse: (payload) {
          print(payload);
          final message = RemoteMessage.fromMap(jsonDecode(payload as String));
          handleMessage(message);
        });
  }

  Future<void> checkTokenRegistration() async {
    bool login = true;
    final access_token = await AuthService.getAuthorizationToken();
    if(access_token == "none"){
      login = false;
    }
    print("hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    final prefs = await SharedPreferences.getInstance();
    final tokenRegistered = prefs.getBool('firebase_token_registered') ?? false;
    print("==============================================================================================");
    print("tokenRegistered = $tokenRegistered");
    print("login = $login");
    print("==============================================================================================");
    if(tokenRegistered == false && login == false){
      print("not logged in");
      final fCMToken = await _firebaseMessaging.getToken();
      await prefs.setBool('firebase_token_registered', true);
      print(fCMToken);
      final body = jsonEncode({"token": fCMToken});
      print(body);
      var response =
      await http.post(Uri.parse("${Constants.url}/user/push/register"),
          headers: {
            'Content-type': 'application/json'
          },
          body: body);
      print("==================================http.post============================================================");
      print(response.body);
      print(response.statusCode);
      print("==================================http.post============================================================");
      if (response.statusCode == 200) {
        print('firebase_token_registered');
        await prefs.setBool('firebase_token_registered', true);
      }
    }else if(tokenRegistered == false && login == true){
      final userService = UserService();
      var userData = await userService.fetchUserProfile();
      print(userData);
      print(userData?.userId);
      final access_token = await AuthService.getAuthorizationToken();
      if(access_token == "none"){

        return;
      }
      print("access_token $access_token");
      final fCMToken = await _firebaseMessaging.getToken();
      print(fCMToken);
      final body = jsonEncode({"token": fCMToken,"user_id": userData?.userId});
      print(body);
      var response =
      await http.post(Uri.parse("${Constants.url}/user/push/register"),
          headers: {
            'Content-type': 'application/json'
          },
          body: body);
      print("=======================================");
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('firebase_token_registered');
        await prefs.setBool('firebase_token_registered', true);
      }
    }
    // if (tokenRegistered && !login) {
    //
    //   print("heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrr");
    // } else {
    //
    //   final userService = UserService();
    //   var userData = await userService.fetchUserProfile();
    //   print(userData);
    //   print(userData?.userId);
    //   final access_token = await AuthService.getAuthorizationToken();
    //   if(access_token == "none"){
    //
    //     return;
    //   }
    //   print("access_token $access_token");
    //   final fCMToken = await _firebaseMessaging.getToken();
    //   print(fCMToken);
    //   final body = jsonEncode({"token": fCMToken});
    //   print(body);
    //   var response =
    //   await http.post(Uri.parse("${Constants.url}/user/push/register"),
    //       body: {"token": fCMToken, "user_id": userData?.userId});
    //   print("=======================================");
    //   print(response.body);
    //   print(response.statusCode);
    //   if (response.statusCode == 200) {
    //     print('firebase_token_registered');
    //     await prefs.setBool('firebase_token_registered', true);
    //   }
    // }
  }
}
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
  if(message.notification?.title == 'breakfast'){
    await NotificationScheduled.showNotification(
        title: 'ኢትዮ ሼፍ',
        body: 'ለቁርስ ጠቃሚ ምክር',
        payload: 'Scheduled Notification :${message.notification?.title}'
    );
  }
  else if(message.notification?.title == 'lunch'){
    await NotificationScheduled.showNotification(
        title: 'ኢትዮ ሼፍ',
        body: 'ለምሳ ጠቃሚ ምክር',
        payload: 'Scheduled Notification :${message.notification?.title}'
    );
  }
  else if(message.notification?.title == 'supper'){
    await NotificationScheduled.showNotification(
        title: 'ኢትዮ ሼፍ',
        body: 'ለመክሰስ ጠቃሚ ምክር',
        payload: 'Scheduled Notification :${message.notification?.title}'
    );
  }
  else if(message.notification?.title == 'dinner'){
    await NotificationScheduled.showNotification(
        title: 'ኢትዮ ሼፍ',
        body: 'ለእራት ጠቃሚ ምክር',
        payload: 'Scheduled Notification :${message.notification?.title}'
    );
  }
}
