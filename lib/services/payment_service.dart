import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart' as getx;
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/payment_methods.dart';
import '../models/user.dart';
import '../models/verification.dart';
import '../services/authorization_service.dart';
import '../services/user_service.dart';
import '../utils/constants.dart';

class PaymentService {
  Future<http.Response> unsubscribeTelebirr() async {
    User user = await UserService().fetchLoggedInUser();
    String? token = await AuthService.getAuthorizationToken();

    var mandateData = await getMandateData();
    print('CHECKING MANDATE DATA: $mandateData');

    if (mandateData == null) {
      throw Exception('Error getting mandate');
    }

    Map<String, dynamic> cancelMandateBody = {
      "phone_number": user.phone,
      "mandateID": mandateData['mandateId'],
    };

    print(cancelMandateBody);

    var response = await http.post(
      Uri.parse("${Constants.url}/telebirr/cancelMandate"),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'JWT $token',
      },
      body: jsonEncode(cancelMandateBody),
    );
    print('CANCEL MANDATE RESPONSE: ${response.body}'); // print(response.body);

    return response;
  }

  Future<dynamic> getMandateData() async {
    User user = await UserService().fetchLoggedInUser();
    String? token = await AuthService.getAuthorizationToken();
    Map<String, dynamic> getMandateBody = {
      "phoneNumber": user.phone,
      "type": "ACTIVE",
    };

    print(getMandateBody);
    var response;
    try {
      var request =
          http.Request(
              'GET',
              Uri.parse("${Constants.url}/telebirr/getMandate"),
            )
            ..headers['Content-Type'] = 'application/json'
            ..headers['Authorization'] = 'JWT $token'
            ..body = jsonEncode(getMandateBody);

      response = await request.send();
    } catch (e) {
      print('ERROre: $e');
    }
    print(response.statusCode);
    if (response.statusCode != 200) {
      return 'empty';
    }
    var responseBody = await response.stream.bytesToString();
    print('Response: $responseBody');
    print('MANDATE ID ${jsonDecode(responseBody)['mandateId']}');
    return jsonDecode(responseBody);
  }

  Future<Verification> getChapaCheckoutLink(
    int amount,
    String email,
    String first_name,
    String last_name,
    String phone_number,
  ) async {
    print({
      "amount": amount, //
      "email": email,
      "first_name": first_name,
      "last_name": last_name,
      "phone_number": phone_number, //
    });
    Verification verification = Verification();
    print(
      jsonEncode({
        "amount": amount,
        "email": email,
        "first_name": first_name,
        "last_name": last_name,
        "phone_number": phone_number,
      }),
    );
    final response = await http.post(
      Uri.parse("${Constants.url}/pay/chapa"),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "amount": amount,
        "email": email,
        "first_name": first_name,
        "last_name": last_name,
        "phone_number": phone_number,
      }),
    );
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['data']['data']['checkout_url']);
      verification.checkoutUrl = jsonDecode(
        response.body,
      )['data']['data']['checkout_url'];
      verification.txref = jsonDecode(response.body)['tx_ref'];
      return verification;
    } else {
      throw Exception(
        'statuscode: ${response.statusCode.toString()}, message: ${response.body}',
      );
    }
  }

  Future<bool> verifyChapaPayment(String txref) async {
    final Uri url = Uri.parse(
      "https://api.chapa.co/v1/transaction/verify/$txref}",
    );

    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        'Authorization': 'Bearer CHASECK_TEST-HITNNsdxmGdc2eSFw3rI6Z8UD6XxhxWk',
      },
    );
    print(response.body);
    final jsonData = json.decode(response.body);
    print(jsonData);
    return jsonData['message'] == 'Payment not paid yet';
  }

  Future<List<PaymentMethods>> fetchAllPayments() async {
    print("fetchAllPayments");
    final response = await http.get(
      Uri.parse('${Constants.url}/pay/payment-methods'),
    );

    print("response.statusCode = ${response.statusCode}");
    print("response.statusCode = ${response.body}");
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      Logger().d(jsonData);
      final List<dynamic> paymentData = jsonData['data'];
      print("paymentData $paymentData");
      return paymentData
          .map((comment) => PaymentMethods.fromJson(comment))
          .toList();
    } else {
      throw Exception('Failed to fetch payment methods');
    }
  }

  Future<http.Response> telebirrPay({
    required String phoneNumber,
    required String firstName,
    required String lastName,
    required int paymentAmount,
    required String fcmToken,
    int paymentId = 0,
  }) async {
    var body = {
      "package_id": paymentId,
      "amount": paymentAmount,
      "phone_number": phoneNumber,
      "first_name": firstName,
      "last_name": lastName,
      "fcm_token": fcmToken,
    };

    var requestBody = jsonEncode(body);
    print("requestBody $requestBody");
    var response = await http.post(
      Uri.parse("${Constants.url}/pay"),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    Logger().d(response.body);
    print(response.body);
    // if (response.statusCode == 200) {
    //   print('INITIATING COUNT DOWN');
    //   Future.delayed(Duration(seconds: 15), () async {
    //     print('PAYMENT STARTED');
    //     await initPayment(phoneNumber, paymentAmount);
    //     print('PAYMENT DONE');
    //   });
    // }
    if (response.statusCode != 200) {
      getx.Get.snackbar('error'.tr, 'pay_again'.tr);
    }
    return response;
  }

  // Future<http.Response> trackConversion(String tid){
  //   var body = {
  //     "status": "1",
  //     "tid": tid,
  //     "event": "register"
  //   };
  //   var headers = {
  //     "Accept": "text/html, application/xhtml+xml, application/xml;q=0.9, image/webp",
  //     "content-type": "application/x-www-form-urlencoded"
  // };
  //   var requestBody = jsonEncode(body);
  //   print("requestBody $requestBody");
  //   var response = http.post(Uri.parse("https://api.offer18.com/api/m/conversion?mid=459&api-key=459AEGUKDYTJSPWMFQ&secret-key=E58C514D0006B69E95DD2C69EF66FF37"),
  //       headers: headers,
  //       body: requestBody);
  //   print(response.body);
  //   return response;
  // }

  Future<http.Response> initPayment(
    String phoneNumber,
    int paymentAmount,
  ) async {
    var body = {"amount": paymentAmount, "phone_number": phoneNumber};

    var requestBody = jsonEncode(body);
    print("requestBody $requestBody");

    // Show loading overlay
    var response = await http.post(
      Uri.parse("${Constants.url}/telebirr/initPayment"),
      headers: {'Content-Type': 'application/json'},
      body: requestBody,
    );
    print(response.body);
    if (response.statusCode != 200) {
      getx.Get.snackbar('error'.tr, 'pay_again'.tr);
    }

    return response;
  }

  Future<http.Response> makePayment(
    Map userData,
    int paymentId,
    User user,
    int paymentAmount,
    bool isSignUp,
  ) async {
    var body = {};
    String? fcmToken = await FirebaseMessaging.instance.getToken();
    print("FCMTOKENNNNNNNNNNNNNNNNN: $fcmToken");
    var response;
    if (isSignUp) {
      body = {
        "id": paymentId,
        "amount": paymentAmount,
        "phone_number": userData['phone'],
        "first_name": userData['first_name'],
        "last_name": userData['last_name'],
        "package_id": paymentId,
      };
      // if (paymentId == 6) {
      if (fcmToken == null) {
        print('FCM TOKEN IS NULL');
      }
      response = await telebirrPay(
        phoneNumber: userData['phone'],
        firstName: userData['first_name'],
        lastName: userData['last_name'],
        paymentId: paymentId,
        paymentAmount: paymentAmount,
        fcmToken: fcmToken!,
      );
      return response;
      // }
    } else {
      body = {
        "id": paymentId,
        "amount": paymentAmount,
        "phone_number": user.phone.toString(),
        "first_name": user.firstName,
        "last_name": user.lastName,
      };
      if (paymentId == 6) {
        if (fcmToken == null) {
          print('FCM TOKEN IS NULL');
        }
        response = await telebirrPay(
          phoneNumber: user.phone.toString(),
          firstName: user.firstName,
          lastName: user.lastName,
          // paymentId: paymentId,
          paymentAmount: paymentAmount,
          fcmToken: fcmToken!,
        );
      }
    }
    if (paymentId != 6) {
      var body = {"user_id": user.id, "package_id": paymentId};
      var requestBody = jsonEncode(body);
      print("requestBody $requestBody");
      response = await http.post(
        Uri.parse("${Constants.url}/pay"),
        headers: {"Content-type": "application/json"},
        body: requestBody,
      );
      Logger().d(response.body);
      print(response.body);
      print(response.statusCode);
    }
    Map<String, String> args = {
      "o": "21213899", // 0000000 (Offer ID)
      "tid": "{REFERRER_TID}", // x-xxxx-xxxxxx-xxxxxx (Click ID)
      "event": "registeration", // install
      "adv_sub1": "",
      "adv_sub2": "",
      "adv_sub3": "",
      "adv_sub4": "",
      "adv_sub5": "",
      "coupon": "",
      "sale": "",
      "payout": "",
    };
    print(args);
    // await Offer18Plugin.trackConversion(args);
    return response;
  }

  Future<http.Response> payForPackage(int userId, int packageId) async {
    var body = {"user_id": userId, "package_id": packageId};
    var requestBody = jsonEncode(body);
    print("requestBody $requestBody");
    var response = await http.post(
      Uri.parse("${Constants.url}/pay"),
      headers: {"Content-type": "application/json"},
      body: requestBody,
    );
    return response;
  }
}
