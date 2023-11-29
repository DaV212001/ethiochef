import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/verification.dart';

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
    await http.post(Uri.parse("https://apiv2.ethiochef.com/pay/chapa"),
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
}