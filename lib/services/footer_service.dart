import 'dart:convert';

import 'package:http/http.dart' as http;

import '../models/footer_data.dart';
import '../utils/constants.dart';
import '../utils/error_util.dart';

class FooterService{
  Future<FooterData> getFooterData() async {
    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(
        Uri.parse("${Constants.url}/user/footer"),
        headers: {
          "Content-type": "application/json",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        final FooterData footerData = FooterData.fromJson(jsonData["data"][0]);
        return footerData;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }
}