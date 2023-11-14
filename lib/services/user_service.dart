import 'dart:convert';

import 'package:ethio_chef/constants/constants.dart';
import 'package:http/http.dart' as http;

import '../models/user.dart';
import 'authorization_service.dart';

class UserService {
  // {
  // "first_name": "Mohammed",
  // "last_name": "Ibrahim",
  // "phone_number":"0946410664"
  // }
  // "first_name":"Abebe","last_name":"Lema","email":null,"phone_number":"0911223344",
  Future<http.Response> registerUser(User user) async {
    print(user);
    print(user.firstName);
    print(user.lastName);
    print(user.phone);
    print(json.encode(user.toJson()));

    var response = await http.post(Uri.parse("${Constants.url}/user/signup"),
        headers: {"Content-type": "application/json"},
        body: json.encode(user.toJson()));
    print("Response Body  == ${response.body} == Response Body");
    return response;
  }

  Future<User> fetchLoggedInUser() async {
    final access_token = await AuthService.getAuthorizationToken();
    final response = await http.get(
      Uri.parse("${Constants.url}/account"),
      headers: {
        "Content-type": "application/json",
        'Authorization': 'Bearer $access_token',
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("User Date Retrieved ${jsonData['data']}");
      final user = User.fromJson(jsonData['data']);
      return user;
    } else {
      throw Exception(response.statusCode.toString());
    }
  }

  Future<http.Response> login(String phone) async {
    print("Logging in");
    print(phone);
    String phone_number = "0"+phone;
    print("phone_number $phone_number");
    var body = json.encode({
      "phone_number": phone_number
    });
    print(body);
    final response = await http.post(
        Uri.parse("https://apiv2.ethiochef.com/user/login"),
      body: {
        "phone_number": phone_number
      }
    );
    print(response);
    print(response.body);
    print(response.statusCode);
    // var access_token = jsonDecode(response.body)['token'];
    // await AuthService.setAuthorizationToken(access_token);
    // print("Login token = ${access_token}");
    return response;
  }



  Future<http.Response> updateUserAccount(
      String first_name, String last_name) async {
    final Uri url =
        Uri.parse("${Constants.url}/change_password");

    final access_token = await AuthService.getAuthorizationToken();

    final body = {
      "first_name": first_name,
      "last_name": last_name,
      "profile_picture": null
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $access_token'
      },
      body: jsonEncode(body),
    );

    return response;
  }


}
