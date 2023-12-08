import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/notification.dart';
import '../utils/constants.dart';
import 'authorization_service.dart';

class NotificationService {
  Future<List<NotificationData>> fetchNotifications() async {
    try {
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(
          Uri.parse(
          '${Constants.url}/user/notifications/'),
          headers: {
        'Authorization': 'JWT $access_token'
      });
      print("fetch notifications ${response.body}");
      if (response.statusCode == 200) {
        final Map<String, dynamic> jsonData = json.decode(response.body);
        final List<dynamic> products = jsonData["data"];
        final List<NotificationData> notifications =
        products.map((notification) {
          return NotificationData.fromJson(notification);
        }).toList();
        return notifications;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }


  void markAllNotificationAsRead() async {
    try {
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.post(
          Uri.parse(
              '${Constants.url}/user/notifications/read'),
          headers: {
        'Authorization': 'JWT $access_token'
      });
      print(access_token);
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }

  void markNotificationAsRead(int id) async {
    print("id $id");
    try {
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.post(
          Uri.parse(
              '${Constants.url}/user/notifications/read/$id'),
          headers: {
        'Authorization': 'JWT $access_token'
      });
      print("response.body== ${response.body}==response.body");
      print("response.statusCode ${response.statusCode}");
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<int> getNumberOfUnreadNotification() async {
    return 5;
  }
}
