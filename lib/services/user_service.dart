import 'dart:convert';
import 'package:ethio_chef/services/subscription_checker.dart';
import 'package:ethio_chef/utils/constants.dart';
import 'dart:io';
import 'package:ethio_chef/models/subscriptionplans.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

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
    String phone_number = "251" + phone;
    print({"phone_number": phone_number});
    final response = await http.post(
        Uri.parse("https://apiv2.ethiochef.com/user/login"),
        body: {"phone_number": phone_number});
    print(response.body);
    print(response.statusCode);

    return response;
  }
  Future<http.Response> updateWithStringProfile(String firstName, String lastName, String email, String phoneNumber, String image) async{
    var requestBody = jsonEncode({
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone_number": phoneNumber,
      "profile_picture": image
    });
    print(requestBody);
    User user = await fetchLoggedInUser();
    final access_token = await AuthService.getAuthorizationToken();
    print(access_token);
    var response = await http.post(
        Uri.parse('${Constants.url}/user/profile/update/${user.id}'),
        headers: {
          'Authorization': 'JWT $access_token',
          'Content-type': 'application/json'
        },
        body: requestBody
    );
    return response;
  }
  Future<http.Response> updateProfile(String firstName, String lastName, String email, String phoneNumber, File? image) async {
    User user = await fetchLoggedInUser();
    print(user.lastName);
    print(user.firstName);
    print(user.id);

    final access_token = await AuthService.getAuthorizationToken();
    print(access_token);
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${Constants.url}/user/profile/update/${user.id}"),
    );
    String phone = "251"+phoneNumber;
    request.headers['Authorization'] = 'JWT $access_token';
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    if(email != ''){
      print(email);
      request.fields['email'] = email;
    }

    request.fields['phone_number'] = phone;

    print(image);
    print("1");
    if (image != null) {
      print(image);
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
    print("2");

    var response = await request.send();
    print("3");
    print(response.stream);
    print(response.request);
    print(response.reasonPhrase);
    print(response.headers);
    var responseString = await response.stream.bytesToString();
    print(responseString);
    print(response.statusCode);

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
  Future<List<SubscriptionPlans>> fetchAllSubscriptionPlans() async {
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
          SubscriptionPlans.fromAllSubscriptionPlansJson(subscriptionPlansData))
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
    // due_date
    List<SubscriptionPlans> subscriptionPlans = [];
    var access_token = await AuthService.getAuthorizationToken();
    User user = await fetchLoggedInUser();
    final response = await http
        .get(Uri.parse("${Constants.url}/user/subscription/${user.id}"), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'JWT ${access_token}',
    });
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      var subscriptionPlansData = jsonData['data'];
      if (subscriptionPlansData is List) {
        subscriptionPlans = subscriptionPlansData
            .map((subscriptionPlansData) =>
            SubscriptionPlans.fromJson(subscriptionPlansData))
            .toList();
      } else if (subscriptionPlansData is Map) {
        print("USER SUBSCRIPTION");
        subscriptionPlans = [SubscriptionPlans.fromJson(subscriptionPlansData)];
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
