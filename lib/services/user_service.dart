import 'dart:convert';
import 'package:ethio_chef/services/subscription_checker.dart';
import 'package:ethio_chef/utils/constants.dart';
import 'dart:io';
import 'package:ethio_chef/models/subscriptionplans.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path/path.dart';

import '../models/user.dart';
import '../models/user_profile.dart';
import 'authorization_service.dart';
import 'firsebase_service.dart';

class UserService {
  Future<http.Response> registerUser(User user) async {
    var response = await http.post(Uri.parse("${Constants.url}/user/signup"),
        headers: {"Content-type": "application/json"},
        body: json.encode(user.toJson()));
    return response;
  }
  Future<http.Response> logOut(int index) async {
    final access_token = await AuthService.getAuthorizationToken();
    String userId = index.toString();
    var response = await http.post(
        Uri.parse("${Constants.url}/user/logout"),
        headers: {
          'Authorization': 'JWT $access_token'
        },
        body: {
          "user_id": userId
        });
    return response;
  }
  Future<dynamic> fetchLoggedInUser() async {
    bool status = await AuthService.isUserLoggedIn();
   if(status == true){
     final access_token = await AuthService.getAuthorizationToken();

     Map<String, dynamic> decodedToken = JwtDecoder.decode(access_token!);
     final user = User.fromJson(decodedToken['user']);
     return user;
   }
   return null;
  }

  Future<http.Response> login(String phone) async {
    String phone_number = "0" + phone;
    var body = json.encode({"phone_number": phone_number});
    final response = await http.post(
        Uri.parse("https://apiv2.ethiochef.com/user/login"),
        body: {"phone_number": phone_number});
    if(response.statusCode == 200){
      var access_token = jsonDecode(response.body)['data']['session_token'];
      var refresh_token = jsonDecode(response.body)['data']['refresh_token'];
      await SubscriptionStatus().checkStatus();
      await AuthService.setAuthorizationToken(access_token);
      await FirebaseService().checkTokenRegistration(true);
      await AuthService.setRefreshToken(refresh_token);
    }
    return response;
  }


  Future<http.Response> updateProfile(String firstName, String lastName, String email, String phoneNumber, File? image) async {
    User user = await fetchLoggedInUser();
    final access_token = await AuthService.getAuthorizationToken();
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${Constants.url}/user/profile/update/${user.id}"),
    );
    String phone = "0"+phoneNumber;
    request.headers['Authorization'] = 'JWT $access_token';
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['email'] = email;
    request.fields['phone_number'] = phone;

    if (image != null) {
      var fileStream = http.ByteStream(image.openRead());
      var length = await image.length();

      var multipartFile = http.MultipartFile(
        'profile_picture',
        fileStream,
        length,
        filename: image.path.split('/').last,
      );

      request.files.add(multipartFile);
    }

    var response = await request.send();

    var responseString = await response.stream.bytesToString();

    return http.Response(responseString, response.statusCode);
  }
  Future<http.Response> updateUserSubscription(
      int subscription_id, int user_id) async {
    final Uri url = Uri.parse("${Constants.url}/user/subscription/update/5");

    final access_token = await AuthService.getAuthorizationToken();
    final body = {
      "subscription_id": subscription_id,
      "user_id": user_id,
      "status": "authenticated"
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $access_token'
      },
      body: jsonEncode(body),
    );

    return response;
  }

  Future<List<SubscriptionPlans>> fetchSubscriptionPlans() async {
    List<SubscriptionPlans> subscriptionPlans = [];
    final response = await http.get(
      Uri.parse("${Constants.url}/pay/plans"),
    );
    print("==============fetchSubscriptionPlans response.body====================");
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Subscriptions Retrieved ${jsonData['data']}");
      var subscriptionPlansData = jsonData['data'] as List;
      subscriptionPlans = subscriptionPlansData
          .map((subscriptionPlansData) =>
              SubscriptionPlans.fromJson(subscriptionPlansData))
          .toList();
      return subscriptionPlans;
    } else {
      throw Exception(response.statusCode.toString());
    }
  }

  Future<http.Response> createUserSubscription(
      int subscription_id, int user_id) async {
    final Uri url = Uri.parse("${Constants.url}/user/subscription/create");
    final body = {"subscription_id": subscription_id, "user_id": user_id};
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    return response;
  }

  Future<List<SubscriptionPlans>> fetchUserSubscriptions() async {
    List<SubscriptionPlans> subscriptionPlans = [];
    var access_token = await AuthService.getAuthorizationToken();
    User user = await fetchLoggedInUser();
    final response = await http
        .get(Uri.parse("${Constants.url}/user/subscription/${user.id}"), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'JWT ${access_token}',
    });
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      var subscriptionPlansData = jsonData['data']['subscription'];
      if (subscriptionPlansData is List) {
        subscriptionPlans = subscriptionPlansData
            .map((subscriptionPlansData) =>
            SubscriptionPlans.fromJson(subscriptionPlansData))
            .toList();
      } else if (subscriptionPlansData is Map) {
        subscriptionPlans = [SubscriptionPlans.fromJson(subscriptionPlansData)];
        print(subscriptionPlans.length);
      }
      return subscriptionPlans;
    } else {
      throw Exception(response.statusCode.toString());
    }
  }

  Future<bool> deleteUserSubscription () async {
    var access_token = await AuthService.getAuthorizationToken();
    User user = await fetchLoggedInUser();
    final response = await http
        .get(Uri.parse("${Constants.url}/user/subscription/${user.id}"), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'JWT ${access_token}'
    });
    var jsonData1;
    if (response.statusCode == 200) {
      jsonData1 = json.decode(response.body);}
    final Uri url = Uri.parse("${Constants.url}/user/subscription/delete/${jsonData1['data']["id"]}");

    final response1 = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'JWT ${access_token}',
      },
    );
    final jsonData = json.decode(response1.body);
    return jsonData['message'] == 'User subscription deleted successfully';
  }


  Future<UserProfile?> fetchUserProfile() async {
    var access_token = await AuthService.getAuthorizationToken();
    final userService = UserService();
    final response = await http.get(
      Uri.parse('${Constants.url}/user/profile'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $access_token',
      },
    );
    final jsonData = json.decode(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return UserProfile.fromJson(jsonData['data']);
    }
    if(jsonData['message'] == "User is not subscribed"){
      var loggedInData = await userService.fetchLoggedInUser();
      UserProfile user  = UserProfile();
      user.message = 'User is not subscribed';
      user.user = loggedInData;
      return user;
    }


    return null;
  }
  Future<http.Response> checkUserSubscription() async{
    var access_token = await AuthService.getAuthorizationToken();
    final response = await http.get(
      Uri.parse('${Constants.url}/user/check-subscription'),
      headers: {
        'Authorization': 'JWT $access_token',
      },
    );
    return response;
  }
}
