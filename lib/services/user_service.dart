import 'dart:convert';
import 'package:ethio_chef/utils/constants.dart';
import 'dart:io';
import 'package:ethio_chef/models/subscriptionplans.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:path/path.dart';

import '../models/user.dart';
import '../models/user_profile.dart';
import 'authorization_service.dart';

class UserService {
  Future<http.Response> registerUser(User user) async {
    var response = await http.post(Uri.parse("${Constants.url}/user/signup"),
        headers: {"Content-type": "application/json"},
        body: json.encode(user.toJson()));
    print("Response Body  == ${response.body} == Response Body");
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
    print("Response Body  == ${response.body} == Response Body");
    return response;
  }
  Future<dynamic> fetchLoggedInUser() async {
    bool status = await AuthService.isUserLoggedIn();
    print("Logged in status = $status");
   if(status == true){
     final access_token = await AuthService.getAuthorizationToken();

     Map<String, dynamic> decodedToken = JwtDecoder.decode(access_token!);
     print("User Data Retrieved ${decodedToken['user']}");
     final user = User.fromJson(decodedToken['user']);
     print("user ==================== $user =======================");
     return user;
   }
    print("Returning null");
   return null;
  }

  Future<http.Response> login(String phone) async {
    print("Logging in");
    print(phone);
    String phone_number = "0" + phone;
    print("phone_number $phone_number");
    var body = json.encode({"phone_number": phone_number});
    print(body);
    final response = await http.post(
        Uri.parse("https://apiv2.ethiochef.com/user/login"),
        body: {"phone_number": phone_number});
    print(response);
    print(response.body);
    print(response.statusCode);
    if(response.statusCode == 200){
      var access_token = jsonDecode(response.body)['data']['session_token'];
      var refresh_token = jsonDecode(response.body)['data']['refresh_token'];
      print("Login token = ${access_token}");
      await AuthService.setAuthorizationToken(access_token);
      await AuthService.setRefreshToken(refresh_token);
      print("Login token = ${access_token}");
      print('Refresh token = ${refresh_token}');
    }
    return response;
  }




  // Future<http.Response> updateUserAccount(
  //     String firstName, String lastName, String email, String phoneNumber) async {
  //     User user = await fetchLoggedInUser();
  //     final access_token = await AuthService.getAuthorizationToken();
  //     print('ID ${user.id}');
  //     print('Phone: ${user.phone}');
  //
  //   final body = {
  //     'first_name': firstName,
  //     'last_name': lastName,
  //     'email': email,
  //     'phone_number': "0"+phoneNumber,
  //     'profile_picture': ""
  //   };
  //   print(body);
  //
  //   final response = await http.post(
  //     Uri.parse('${Constants.url}/user/profile/update/${user.id}'),
  //     headers: {
  //       'Content-Type': 'application/json',
  //       'Authorization': 'JWT $access_token'
  //     },
  //     body: jsonEncode(body)
  //   );
  //   print(response.body);
  //   return response;
  // }
  Future<http.Response> updateProfile(String firstName, String lastName, String email, String phoneNumber, File? image) async {
    User user = await fetchLoggedInUser();
    final access_token = await AuthService.getAuthorizationToken();
    print('ID ${user.id}');
    print('Phone: ${user.phone}');
    var request = http.MultipartRequest(
      'POST',
      Uri.parse("${Constants.url}/user/profile/update/${user.id}"),
    );
    print("Updating 1");
    String phone = "0"+phoneNumber;
    request.headers['Authorization'] = 'JWT $access_token';
    print("phoneNumber $phone");
    request.fields['first_name'] = firstName;
    request.fields['last_name'] = lastName;
    request.fields['email'] = email;
    request.fields['phone_number'] = phone;
    print("Updating 2");

    if (image != null) {
      print("Updating 3");
      var fileStream = http.ByteStream(image.openRead());
      var length = await image.length();

      var multipartFile = http.MultipartFile(
        'profile_picture',
        fileStream,
        length,
        filename: image.path.split('/').last,
      );
      print("Updating 4");

      request.files.add(multipartFile);
      print("Updating 5");
    }

    print("Updating 6");
    var response = await request.send();

    print("Updating 7");
    var responseString = await response.stream.bytesToString();

    print("Response Body  == ${response.statusCode} == Response Body");
    print("Response Body  == $responseString == Response Body");

    return http.Response(responseString, response.statusCode);
  }
  // Future<http.StreamedResponse> updateUserProfile(String firstName, String lastName, String email, String phoneNumber, File profilePicture) async {
  //   User user = await fetchLoggedInUser();
  //   final access_token = await AuthService.getAuthorizationToken();
  //   print('ID ${user.id}');
  //   print('Phone: ${user.phone}');
  //   var url = '${Constants.url}/user/profile/update/${user.id}';
  //
  //   print("Updating 1");
  //   // Create a multipart request
  //   var request = http.MultipartRequest('POST', Uri.parse(url));
  //
  //   // Add other fields
  //   request.fields['first_name'] = firstName;
  //   request.fields['last_name'] = lastName;
  //   request.fields['email'] = email;
  //   request.fields['phone_number'] = phoneNumber;
  //
  //   // Add file
  //   print("Updating 2");
  //   request.files.add(
  //     await http.MultipartFile.fromPath(
  //       'profile_picture', // key for the file field
  //       profilePicture.path,
  //       filename: basename(profilePicture.path), // optional
  //     ),
  //   );
  //   print("Updating 3");
  //
  //   // Add headers
  //   request.headers.addAll({
  //     'Authorization': 'JWT $access_token'
  //   });
  //
  //   print("Updating 4");
  //   // Send the request
  //   var response = await request.send();
  //   print("Updating 5");
  //
  //   if (response.statusCode == 200) {
  //     print('Profile updated successfully');
  //   } else {
  //     print('Failed to update profile');
  //   }
  //
  //   return response;
  // }


  Future<http.Response> updateUserSubscription(
      int subscription_id, int user_id) async {
    final Uri url = Uri.parse("${Constants.url}/user/subscription/update/5");

    final access_token = await AuthService.getAuthorizationToken();
    print(access_token);
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
    print(subscription_id);
    print(user_id);
    final body = {"subscription_id": subscription_id, "user_id": user_id};
    print(jsonEncode(body));
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(body),
    );
    print(response.body);
    return response;
  }

  Future<List<SubscriptionPlans>> fetchUserSubscriptions() async {
    List<SubscriptionPlans> subscriptionPlans = [];
    var access_token = await AuthService.getAuthorizationToken();
    User user = await fetchLoggedInUser();
    print(user.id);
    final response = await http
        .get(Uri.parse("${Constants.url}/user/subscription/${user.id}"), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'JWT ${access_token}',
    });
    print(response.body);
    print(response.statusCode);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Subscriptions Retrieved ${jsonData['data']['subscription']}");
      var subscriptionPlansData = jsonData['data']['subscription'];
      print('Breakpoint 1');
      if (subscriptionPlansData is List) {
        subscriptionPlans = subscriptionPlansData
            .map((subscriptionPlansData) =>
            SubscriptionPlans.fromJson(subscriptionPlansData))
            .toList();
      } else if (subscriptionPlansData is Map) {
        print('map');
        subscriptionPlans = [SubscriptionPlans.fromJson(subscriptionPlansData)];
        print('map2');
        print(subscriptionPlans.length);
      }
      print('Breakpoint 2');
      print('CHECKING POPULATION ${subscriptionPlans.length}');
      return subscriptionPlans;
    } else {
      throw Exception(response.statusCode.toString());
    }
  }

  Future<bool> deleteUserSubscription () async {
    var access_token = await AuthService.getAuthorizationToken();
    User user = await fetchLoggedInUser();
    print(user.id);
    final response = await http
        .get(Uri.parse("${Constants.url}/user/subscription/${user.id}"), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'JWT ${access_token}'
    });
    print(response.statusCode);
    var jsonData1;
    if (response.statusCode == 200) {
      jsonData1 = json.decode(response.body);}
    print(jsonData1['data']["id"]);
    final Uri url = Uri.parse("${Constants.url}/user/subscription/delete/${jsonData1['data']["id"]}");

    final response1 = await http.delete(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'JWT ${access_token}',
      },
    );
    print(response1.body);
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
    print("user jsonData $jsonData");
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


}
