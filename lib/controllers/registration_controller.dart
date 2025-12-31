import 'dart:convert';

import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class RegisterController extends GetxController {
  var isLoading = false.obs;
  var grades = [].obs;
  var selectedGradeId = RxnInt();
  var error = ''.obs;

  // Text controllers
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    fetchGrades();
  }

  Future<void> fetchGrades() async {
    try {
      isLoading(true);
      final response =
          await http.get(Uri.parse('https://api.asteghi.com/api/grade'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        grades.value = data['data'];
      } else {
        error.value = 'Failed to fetch grades';
      }
    } catch (e) {
      error.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }

  Future<void> register() async {
    if (selectedGradeId.value == null) {
      Get.snackbar('Error', 'Please select a grade');
      return;
    }

    try {
      isLoading(true);
      var payload = {
        "first_name": firstNameController.text,
        "last_name": lastNameController.text,
        "email": emailController.text,
        "grade_id": selectedGradeId.value.toString(),
        "phone": '251' + phoneController.text,
        "password": passwordController.text,
      };
      Logger().d(payload);
      final response = await http.post(
        Uri.parse('https://api.asteghi.com/api/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);
      Logger().d(data);
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.snackbar('Success', data['message'] ?? 'Registered successfully');
        Get.to(() => AuthScreen(
              isSignIn: true,
            ));
      } else {
        Get.snackbar('Error', data['message'] ?? 'Registration failed');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
