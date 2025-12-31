import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

import '../models/about_us.dart';
import '../models/faq_ethio_clone.dart';
import '../models/footer_data.dart';
import '../models/privacy_policies.dart';
import '../models/terms_and_conditions.dart';
import '../utils/constants.dart';
import '../utils/error_util.dart';

class AppDocServices {
  Future<List<FAQ>> fetchFaqs() async {
    try {
      await ErrorUtil.checkConnection();
      List<FAQ> faqs = [];
      final response = await http.get(
        Uri.parse("https://api.asteghi.com/api/faq"),
      );
      Logger().d(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        var faqsData = jsonData['data'] as List;
        faqs = faqsData.map((faqsData) => FAQ.fromJson(faqsData)).toList();
        return faqs;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<PrivacyPolicy>> fetchPrivacyPolicies() async {
    try {
      await ErrorUtil.checkConnection();
      List<PrivacyPolicy> privacyPolicies = [];
      final response = await http.get(
        Uri.parse("https://api.asteghi.com/api/privacy"),
      );
      Logger().d(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        var privacyPoliciesData = jsonData['data'] as List;
        privacyPolicies = privacyPoliciesData
            .map((privacyPoliciesData) =>
                PrivacyPolicy.fromJson(privacyPoliciesData))
            .toList();
        return privacyPolicies;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<TermsAndConditions>> fetchTermsAndConditions() async {
    try {
      await ErrorUtil.checkConnection();
      List<TermsAndConditions> termsAndConditions = [];
      final response = await http.get(
        Uri.parse("https://api.asteghi.com/api/term"),
      );
      Logger().d(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        var termsAndConditionsData = jsonData['data'] as List;
        termsAndConditions = termsAndConditionsData
            .map((termsAndConditionsData) =>
                TermsAndConditions.fromJson(termsAndConditionsData))
            .toList();
        return termsAndConditions;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<List<AboutUs>> fetchAboutUs() async {
    // try {
    await ErrorUtil.checkConnection();
    List<AboutUs> aboutUs = [];
    final response = await http.get(
      Uri.parse("https://api.asteghi.com/api/about-us"),
    );
    Logger().d(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      var aboutUsData = jsonData['data'] as List;
      aboutUs = aboutUsData
          .map((aboutUsData) => AboutUs.fromJson(aboutUsData))
          .toList();
      return aboutUs;
    } else {
      throw Exception(response.statusCode.toString());
    }
    // } catch (error) {
    //   rethrow;
    // }
  }

  Future<FooterData> getFooterData() async {
    try {
      await ErrorUtil.checkConnection();
      final response = await http.get(
        Uri.parse("${Constants.url}/footer"),
        headers: {
          "Content-type": "application/json",
        },
      );
      print(response.body);
      if (response.statusCode == 200) {
        dynamic jsonData = json.decode(response.body);
        final FooterData footerData = FooterData.fromJson(jsonData["data"]);
        return footerData;
      } else {
        throw Exception(response.statusCode.toString());
      }
    } catch (error) {
      rethrow;
    }
  }
}
