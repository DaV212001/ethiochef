import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class ForgotPasswordController extends GetxController {
  var isLoading = false.obs;
  var step = 1.obs; // 1=email, 2=otp, 3=new password
  var email = ''.obs;
  var otp = ''.obs;
  var newPassword = ''.obs;

  Future<void> sendOtp() async {
    if (email.value.isEmpty) {
      Get.snackbar('Error', 'Please enter your email');
      return;
    }

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('https://api.asteghi.com/api/send-otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email.value}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'OTP sent successfully');
        step.value = 2;
      } else {
        Get.snackbar('Error', 'Failed to send OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> verifyOtp() async {
    if (otp.value.isEmpty) {
      Get.snackbar('Error', 'Please enter the OTP');
      return;
    }

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('https://api.asteghi.com/api/otp-verify'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'otp': otp.value, 'email': email.value}),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'OTP verified');
        step.value = 3;
      } else {
        Get.snackbar('Error', 'Invalid or expired OTP');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }

  Future<void> changePassword() async {
    if (newPassword.value.isEmpty) {
      Get.snackbar('Error', 'Please enter a new password');
      return;
    }

    try {
      isLoading(true);
      final response = await http.post(
        Uri.parse('https://api.asteghi.com/api/change-password-by-email'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email.value,
          'password': newPassword.value,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password changed successfully');
        Get.back(); // Navigate back to login
      } else {
        Get.snackbar('Error', 'Failed to change password');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }
}
