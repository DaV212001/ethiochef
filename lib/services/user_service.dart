import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/subscriptionplans.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import '../utils/constants.dart';
import 'authorization_service.dart';

class UserService {
  Future<http.Response> registerUser(User user) async {
    var response = await http.post(
      Uri.parse("${Constants.url}/user/signup"),
      headers: {"Content-type": "application/json"},
      body: json.encode(user.toJson()),
    );
    return response;
  }

  // Future<http.Response> registerNew({
  //   required String firstName,
  //   required String lastName,
  //   required String phoneNumber,
  //   required String package,
  //   required String email,
  //   required String password,
  //   String? promoCode,
  // }) async {
  //   var body = {
  //     "first_name": firstName,
  //     "last_name": lastName,
  //     "phone_number": "251" + phoneNumber,
  //     "package": package,
  //     "email": email,
  //     "password": password,
  //     "promo_code": promoCode ?? "",
  //   };
  //   var response = await http.post(
  //     Uri.parse("${Constants.url}/register"),
  //     headers: {"Content-type": "application/json"},
  //     body: json.encode(body),
  //   );
  //   return response;
  // }

  Future<http.Response> logOut(int index) async {
    final access_token = await AuthService.getAuthorizationToken();
    String userId = index.toString();
    var response = await http.post(
      Uri.parse("${Constants.url}/user/logout"),
      headers: {'Authorization': 'JWT $access_token'},
      body: {"user_id": userId},
    );
    return response;
  }

  Future<dynamic> fetchLoggedInUser() async {
    bool status = await AuthService.isUserLoggedIn();
    if (status == true) {
      final access_token = await AuthService.getUserData();

      Map<String, dynamic> decodedToken = jsonDecode(access_token!);
      final user = User.fromJson(decodedToken);
      return user;
    }
    return null;
  }

  Future<http.Response> login(String phone, {String? password}) async {
    String phone_number = "251" + phone;
    print({"phone_number": phone_number});
    final response = await http.post(
      Uri.parse("${Constants.url}/login"),
      body: {"phone_number": phone_number, "password": password},
    );
    print(response.body);
    print(response.statusCode);

    return response;
  }

  Future<http.Response> updateWithStringProfile(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    String image,
  ) async {
    var requestBody = jsonEncode({
      "first_name": firstName,
      "last_name": lastName,
      "email": email,
      "phone_number": phoneNumber,
      "profile_picture": image,
    });
    print(requestBody);
    User user = await fetchLoggedInUser();
    final access_token = await AuthService.getAuthorizationToken();
    print(access_token);
    var response = await http.post(
      Uri.parse('${Constants.url}/user/profile/update/${user.id}'),
      headers: {
        'Authorization': 'JWT $access_token',
        'Content-type': 'application/json',
      },
      body: requestBody,
    );
    return response;
  }

  Future<http.Response> updateProfile(
    String firstName,
    String lastName,
    String email,
    String phoneNumber,
    File? image,
  ) async {
    User user = await fetchLoggedInUser();
    final access_token = await AuthService.getAuthorizationToken();
    String phone = "251" + phoneNumber;

    // 1. PUT request for profile data
    final putUrl = Uri.parse("${Constants.url}/user/profile/${user.id}");
    final putBody = jsonEncode({
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": phone,
      "email": email.isEmpty ? 'guest@email.com' : email,
      "id": user.id,
    });

    var response = await http.put(
      putUrl,
      headers: {
        'Authorization': 'JWT $access_token',
        'Content-Type': 'application/json',
      },
      body: putBody,
    );
    Logger().d(response.body);
    AuthService.setUserData(jsonEncode(jsonDecode(response.body)['data']));

    // 2. If image is not null, send Multipart POST request to update_profile
    if (image != null) {
      var request = http.MultipartRequest(
        'POST',
        Uri.parse("${Constants.url}/update_profile"),
      );
      request.headers['Authorization'] = 'JWT $access_token';
      request.fields['user_id'] = user.id.toString();

      var fileStream = http.ByteStream(image.openRead());
      var length = await image.length();

      var multipartFile = http.MultipartFile(
        'image',
        fileStream,
        length,
        filename: image.path.split('/').last,
      );

      request.files.add(multipartFile);
      var streamedResponse = await request.send();
      var responseString = await streamedResponse.stream.bytesToString();
      return http.Response(responseString, streamedResponse.statusCode);
    }

    return response;
  }

  Future<http.Response> updateUserSubscription(
    int subscription_id,
    int user_id,
  ) async {
    final Uri url = Uri.parse("${Constants.url}/user/subscription/update/5");

    final access_token = await AuthService.getAuthorizationToken();
    final body = {
      "subscription_id": subscription_id,
      "user_id": user_id,
      "status": "authenticated",
    };

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $access_token',
      },
      body: jsonEncode(body),
    );

    return response;
  }

  Future<List<SubscriptionPlans>> fetchSubscriptionPlans() async {
    List<SubscriptionPlans> subscriptionPlans = [];
    final response = await http.get(Uri.parse("${Constants.url}/pay/plans"));
    print(
      "==============fetchSubscriptionPlans response.body====================",
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Subscriptions Retrieved ${jsonData['data']}");
      var subscriptionPlansData = jsonData['data'] as List;
      subscriptionPlans = subscriptionPlansData
          .map(
            (subscriptionPlansData) =>
                SubscriptionPlans.fromJson(subscriptionPlansData),
          )
          .toList();
      return subscriptionPlans;
    } else {
      throw Exception(response.statusCode.toString());
    }
  }

  Future<List<SubscriptionPlans>> fetchAllSubscriptionPlans() async {
    List<SubscriptionPlans> subscriptionPlans = [];
    final response = await http.get(Uri.parse("${Constants.url}/pay/plans"));
    print(
      "==============fetchSubscriptionPlans response.body====================",
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Subscriptions Retrieved ${jsonData['data']}");
      var subscriptionPlansData = jsonData['data'] as List;
      subscriptionPlans = subscriptionPlansData
          .map(
            (subscriptionPlansData) =>
                SubscriptionPlans.fromAllSubscriptionPlansJson(
                  subscriptionPlansData,
                ),
          )
          .toList();
      return subscriptionPlans;
    } else {
      throw Exception(response.statusCode.toString());
    }
  }

  Future<http.Response> createUserSubscription(
    int subscription_id,
    int user_id,
  ) async {
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
    final response = await http.get(
      Uri.parse("${Constants.url}/user/subscription/${user.id}"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT ${access_token}',
      },
    );
    print(response.statusCode);
    print(response.body);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      var subscriptionPlansData = jsonData['data'];
      if (subscriptionPlansData is List) {
        subscriptionPlans = subscriptionPlansData
            .map(
              (subscriptionPlansData) =>
                  SubscriptionPlans.fromJson(subscriptionPlansData),
            )
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

  Future<bool> deleteUserSubscription() async {
    var access_token = await AuthService.getAuthorizationToken();
    User user = await fetchLoggedInUser();
    final response = await http.delete(
      Uri.parse("${Constants.url}/user/subscription/${user.id}"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT ${access_token}',
      },
    );
    var jsonData;
    if (response.statusCode == 200) {
      jsonData = json.decode(response.body);
    }
    // final Uri url = Uri.parse(
    //   "${Constants.url}/user/subscription/delete/${jsonData1['data']["id"]}",
    // );

    // final response1 = await http.delete(
    //   url,
    //   headers: {
    //     "Content-Type": "application/json",
    //     'Authorization': 'JWT ${access_token}',
    //   },
    // );
    // final jsonData = json.decode(response1.body);
    return response.statusCode == 200 || response.statusCode == 204;
  }

  UserProfile testUser = UserProfile(
    user: User(firstName: 'm', lastName: 'n'),
    status: 'Active',
    subscription: SubscriptionPlans(plan: '1', duration: 1, id: 15),
  );

  Future<UserProfile?> fetchUserProfile() async {
    // return testUser;

    String? userData = await AuthService.getUserData();
    var userDataDecoded = jsonDecode(userData ?? '');
    // final userService = UserService();
    // final response = await http.get(
    //   Uri.parse('${Constants.url}/user/profile'),
    //   headers: {
    //     'Content-Type': 'application/json',
    //     'Authorization': 'JWT $access_token',
    //   },
    // );
    //
    // final jsonData = json.decode(response.body);
    //
    // if (response.statusCode == 200) {
    //   final jsonData = json.decode(response.body);
    return UserProfile(user: User.fromJson(userDataDecoded));
    // }
    // if (jsonData['message'] == "User is not subscribed") {
    //   var loggedInData = await userService.fetchLoggedInUser();
    //   UserProfile user = UserProfile();
    //   user.message = 'User is not subscribed';
    //   user.user = loggedInData;
    //   return user;
    // }

    return null;
  }

  Future<http.Response> checkUserSubscription() async {
    String? userData = await AuthService.getUserData();
    var userDataDecoded = jsonDecode(userData ?? "");
    final response = await http.get(
      Uri.parse('${Constants.url}/user/subscription/${userDataDecoded['id']}'),
      // headers: {'Authorization': 'JWT $access_token'},
    );
    return response;
  }

  Future<http.Response> registerNew({
    required String firstName,
    required String lastName,
    required String phoneNumber,
    required String package,
    String? email,
    String? password,
    String? promoCode,
  }) async {
    var body = {
      "first_name": firstName,
      "last_name": lastName,
      "phone_number": "251" + phoneNumber,
      "package": package,
      "email": email,
      "password": password,
      "promo_code": promoCode,
    };
    var response = await http.post(
      Uri.parse("${Constants.url}/register"),
      headers: {"Content-type": "application/json"},
      body: json.encode(body),
    );
    return response;
  }
}
