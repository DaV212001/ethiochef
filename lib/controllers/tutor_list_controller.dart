import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;

import '../models/tutor.dart';

class TutorListController extends GetxController {
  var isLoading = true.obs;
  var tutors = <Tutor>[].obs;

  @override
  void onInit() {
    fetchTutors();
    super.onInit();
  }

  Future<void> fetchTutors() async {
    try {
      isLoading(true);
      final response =
          await http.get(Uri.parse('https://api.asteghi.com/api/astegni'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List list = data['data'];
        tutors.value = list.map((e) => Tutor.fromJson(e)).toList();
      } else {
        Get.snackbar('Error', 'Failed to load tutors (${response.statusCode})');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong: $e');
    } finally {
      isLoading(false);
    }
  }
}
