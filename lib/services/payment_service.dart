import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/payment_methods.dart';
import '../models/user.dart';
import '../models/verification.dart';
import '../utils/constants.dart';

class PaymentService {
  Future<Verification> getChapaCheckoutLink(int amount, String email,
      String first_name, String last_name, String phone_number) async {
    print({
      "amount": amount,//
      "email": email,
      "first_name": first_name,
      "last_name": last_name,
      "phone_number": phone_number//
    });
    Verification verification = Verification();
    print(jsonEncode({
      "amount": amount,
      "email": email,
      "first_name": first_name,
      "last_name": last_name,
      "phone_number": phone_number
    }));
    final response =
    await http.post(
        Uri.parse("https://apiv2.ethiochef.com/pay/chapa"),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "amount": amount,
          "email": email,
          "first_name": first_name,
          "last_name": last_name,
          "phone_number": phone_number
        }));
    print(response.statusCode);
    print(response.body);
    if (response.statusCode == 200) {
      print(jsonDecode(response.body)['data']['data']['checkout_url']);
      verification.checkoutUrl = jsonDecode(response.body)['data']['data']['checkout_url'];
      verification.txref = jsonDecode(response.body)['tx_ref'];
      return verification;
    } else {
      throw Exception(
          'statuscode: ${response.statusCode.toString()}, message: ${response.body}');
    }
  }

  Future<bool> verifyChapaPayment (String txref) async {
    final Uri url = Uri.parse("https://api.chapa.co/v1/transaction/verify/$txref}");

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
  Future<List<PaymentMethods>> fetchAllPayments() async{
    print("fetchAllPayments");
    final response = await http.get(
      Uri.parse('${Constants.url}/pay/payment-methods'),
    );
    print("response.statusCode = ${response.statusCode}");
    print("response.statusCode = ${response.body}");
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> paymentData = jsonData['data'];
      print("paymentData $paymentData");
      return paymentData.map((comment) => PaymentMethods.fromJson(comment)).toList();
    } else {
      throw Exception('Failed to fetch payment methods');
    }
  }
  Future<http.Response> makePayment(Map userData, int paymentId, User user, int paymentAmount, bool isSignUp) async {
    var body = {};
    if(isSignUp){
      body = {
        "id": paymentId,
        "amount": paymentAmount,
        "phone_number": userData['phone'],
        "first_name": userData['first_name'],
        "last_name": userData['last_name']
      };
    }else{
      body = {
        "id": paymentId,
        "amount": paymentAmount,
        "phone_number": "251"+user.phone.toString(),
        "first_name": user.firstName,
        "last_name": user.lastName
      };
    }
    var requestBody = jsonEncode(body);
    print("requestBody $requestBody");
    var response = await http.post(Uri.parse("${Constants.url}/pay"),
        headers: {"Content-type": "application/json"},
        body: requestBody);
    print(response.body);
    print(response.statusCode);

    return response;
  }
}