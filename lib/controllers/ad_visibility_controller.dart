import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';

class AdVisibilityController extends GetxController {
  var isAdVisible = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdVisibility();
  }

  Future<void> fetchAdVisibility() async {
    try {
      final response = await http.get(
        Uri.parse('https://api.ethiochef.com/api/user/ad_visiblity'),
      );
      Logger().d(response.statusCode);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Logger().d(data);
        // If data is "0", ads are off. If "1", ads are on.
        if (data['data'] == "0") {
          isAdVisible.value = false;
        } else {
          isAdVisible.value = true;
        }
      }
    } catch (e) {
      print('Error fetching ad visibility: $e');
      // Default to visible if there's an error
      isAdVisible.value = false;
    }
  }
}
