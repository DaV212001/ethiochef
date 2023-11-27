import 'dart:convert';

import 'package:ethio_chef/models/privacy_policies.dart';
import 'package:ethio_chef/models/terms_and_conditions.dart';

import '../constants/constants.dart';
import '../models/faqs.dart';
import 'package:http/http.dart' as http;


class AppDocServices {
  Future<List<FAQ>> fetchFaqs() async {
    List<FAQ> faqs = [];
    final response = await http.get(
      Uri.parse("${Constants.url}/user/faq"),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("FAQ's Retrieved ${jsonData['data']}");
      var faqsData = jsonData['data'] as List;
      faqs = faqsData
          .map((faqsData) =>
          FAQ.fromJson(faqsData))
          .toList();
      return faqs;
    } else {
      throw Exception(response.statusCode.toString());
    }
  }

  Future<List<PrivacyPolicy>> fetchPrivacyPolicies () async {
    List<PrivacyPolicy> privacyPolicies = [];
    final response = await http.get(
      Uri.parse("${Constants.url}/user/privacy"),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Privacy Policies Retrieved ${jsonData['data']}");
      var privacyPoliciesData = jsonData['data'] as List;
      privacyPolicies = privacyPoliciesData
          .map((privacyPoliciesData) =>
          PrivacyPolicy.fromJson(privacyPoliciesData))
          .toList();
      return privacyPolicies;
    } else {
      throw Exception(response.statusCode.toString());
    }
  }

  Future<List<TermsAndConditions>> fetchTermsAndConditions () async {
    List<TermsAndConditions> termsAndConditions = [];
    final response = await http.get(
      Uri.parse("${Constants.url}/user/terms"),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      print("Terms And Conditions Retrieved ${jsonData['data']}");
      var termsAndConditionsData = jsonData['data'] as List;
      termsAndConditions = termsAndConditionsData
          .map((termsAndConditionsData) =>
          TermsAndConditions.fromJson(termsAndConditionsData))
          .toList();
      return termsAndConditions;
    } else {
      throw Exception(response.statusCode.toString());
    }
  }


}