import 'dart:convert';

import 'package:ethio_chef/services/user_service.dart';

import 'authorization_service.dart';

class SubscriptionStatus {
  static final SubscriptionStatus _singleton = SubscriptionStatus._internal();

  factory SubscriptionStatus() {
    return _singleton;
  }

  SubscriptionStatus._internal();

  String? status;

  Future<void> checkStatus() async {
    var token = await AuthService.getAuthorizationToken();
    if(token=="none"){
      status = "Not logged in";
    } else {
      UserService service = UserService();
      var response = await service.checkUserSubscription();
      final jsonData = json.decode(response.body);
      if(jsonData['message'] == "Invalid Token, Redirect to login"){
        status = "Another user logged in";
      } else {
        if(response.statusCode == 200) {
          if(jsonData['message'] == "User is subscribed"){
            status = "User is subscribed";
          } else {
            status = "User is not subscribed";
          }
        } else {
          status = "User is not subscribed";
        }
      }
    }
  }

  void updateStatus(String newStatus) {
    status = newStatus;
  }
}
