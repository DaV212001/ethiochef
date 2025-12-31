import 'dart:convert';
import 'dart:io';

import 'package:ethio_chef/services/user_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

import '../models/user.dart';

class AstegniController extends GetxController {
  final isLoading = false.obs;
  final grades = [].obs;
  final cities = [].obs;
  final selectedGradeId = RxnInt();
  final selectedCityId = RxnInt();
  final selectedGender = ''.obs;
  final imageFile = Rx<File?>(null);
  final error = ''.obs;

  // Text controllers
  final fullNameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final experienceController = TextEditingController();
  final descriptionController = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  AstegniController();

  @override
  void onInit() {
    super.onInit();
    fetchGrades();
    fetchCities();
  }

  Future<void> fetchGrades() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.asteghi.com/api/grade'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        grades.value = data['data'];
      }
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> fetchCities() async {
    try {
      final response =
          await http.get(Uri.parse('https://api.asteghi.com/api/city'));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        cities.value = data['data'];
      }
    } catch (e) {
      error.value = e.toString();
    }
  }

  Future<void> pickImage() async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      imageFile.value = File(picked.path);
    }
  }

  Future<void> submitForm() async {
    if (selectedGradeId.value == null) {
      Get.snackbar('Error', 'Please select a grade');
      return;
    }

    if (selectedCityId.value == null) {
      Get.snackbar('Error', 'Please select a city');
      return;
    }

    if (selectedGender.value.isEmpty) {
      Get.snackbar('Error', 'Please select your gender');
      return;
    }

    if (imageFile.value == null) {
      Get.snackbar('Error', 'Please upload a profile picture');
      return;
    }

    try {
      isLoading(true);
      var request = http.MultipartRequest(
        'POST',
        Uri.parse('https://api.asteghi.com/api/astegni'),
      );
      UserService userService = UserService();
      User user = await userService.fetchLoggedInUser();

      request.fields['full_name'] = fullNameController.text;
      request.fields['adress'] = addressController.text;
      request.fields['phone'] = phoneController.text;
      request.fields['user_id'] = user.id.toString();
      request.fields['grade_id'] = selectedGradeId.value.toString();
      request.fields['city_id'] = selectedCityId.value.toString();
      request.fields['gender'] = selectedGender.value;
      request.fields['years_of_experience'] = experienceController.text;
      request.fields['description'] = descriptionController.text;

      if (imageFile.value != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'profile_picture',
          imageFile.value!.path,
        ));
      }

      final response = await request.send();
      final resBody = await response.stream.bytesToString();
      Logger().d(resBody);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(resBody);
        Logger().d(data);
        Get.snackbar(
            'Success', data['message'] ?? 'Form submitted successfully');
      } else {
        Get.snackbar('Error', 'Submission failed: ${response.statusCode}');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }
}
