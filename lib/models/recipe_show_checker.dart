import 'dart:convert';

import '../services/authorization_service.dart';
import '../services/user_service.dart';

class Check{
  static Future<String> checkToShow() async{
    var token = await AuthService.getAuthorizationToken();
    if(token=="none"){
      return "Not logged in";
    }else{
      UserService service = UserService();
      var response = await service.checkUserSubscription();
      final jsonData = json.decode(response.body);
      if(jsonData['message'] == "Invalid Token, Redirect to login"){
        return "Another user logged in";
      }else{
      if(response.statusCode == 200) {
        if(jsonData['message'] == "User is subscribed"){
          return "User is subscribed";
        }
        else{
          return "User is not subscribed";
        }
      } else{
        return "User is not subscribed";
      }
      }
    }
  }
}