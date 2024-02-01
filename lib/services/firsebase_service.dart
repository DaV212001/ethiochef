import 'dart:convert';

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

  void handleMessage(RemoteMessage? message) {
    print("here 1");
    if (message == null) { print('message NULL'); return;}
    navigatorKey.currentState?.pushNamed("/main");
    navigatorKey.currentState?.pushNamed("/notification", arguments: message);
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

  Future<void> checkTokenRegistration(bool login) async {
    print("hereeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee");
    final prefs = await SharedPreferences.getInstance();
    final tokenRegistered = prefs.getBool('firebase_token_registered') ?? false;
    if (tokenRegistered && !login) {
      print("heeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeerrrrrrrrrrrrrrrrrrrrrr");
    } else {
      final access_token = await AuthService.getAuthorizationToken();
      if(access_token == "none"){
        print("not logged in");
        return;
      }
      print("access_token $access_token");
      final fCMToken = await _firebaseMessaging.getToken();
      print(fCMToken);
      final body = jsonEncode({"token": fCMToken});
      print(body);
      var response =
      await http.post(Uri.parse("${Constants.url}/user/push/register"),
          headers: {
            'Authorization': 'JWT $access_token',
          },
          body: {"token": fCMToken});
      print("=======================================");
      print(response.body);
      print(response.statusCode);
      if (response.statusCode == 200) {
        print('firebase_token_registered');
        await prefs.setBool('firebase_token_registered', true);
      }
    }
  }
}
Future<void> handleBackgroundMessage(RemoteMessage message) async {
  print("Title: ${message.notification?.title}");
  print("Body: ${message.notification?.body}");
  print("Payload: ${message.data}");
}
