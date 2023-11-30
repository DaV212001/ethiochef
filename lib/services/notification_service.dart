import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/notification.dart';
import '../utils/constants.dart';
import 'authorization_service.dart';

class NotificationService {
  Future<List<NotificationData>> fetchNotifications() async {
    try {
      final Uri url = Uri.parse(
          '${Constants.url}/user/notifications/');
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access_token'
      });
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
      final Uri url = Uri.parse(
          '${Constants.url}/read_all_product_notifications');
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.post(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access_token'
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

  void markNotificationAsRead(String id) async {
    try {
      final Uri url = Uri.parse(
          '${Constants.url}/user/notifications/$id');
      final access_token = await AuthService.getAuthorizationToken();
      final response = await http.post(url, headers: {
        'Authorization': 'Bearer $access_token'
      });
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
