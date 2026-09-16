import 'dart:convert';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/web.dart';

import '../services/ad_service.dart';
import '../utils/constants.dart';

class AdVisibilityController extends GetxController {
  var isAdVisible = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdVisibility();
  }

  Future<void> fetchAdVisibility() async {
    try {
      final response = await http.get(
        Uri.parse('${Constants.url}/user/ad_visiblity'),
      );
      Logger().d(response.statusCode);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        Logger().d(data);
        // If data is 0 or "0", ads are off. If 1 or "1", ads are on.
        final rawVal = data['data'];
        if (rawVal == 0 || rawVal == "0" || rawVal.toString() == "0") {
          isAdVisible.value = false;
        } else {
          isAdVisible.value = true;
        }
      }
    } catch (e) {
      print('Error fetching ad visibility: $e');
      // Default to visible if there's an error
      isAdVisible.value = true;
    } finally {
      // Sync with AdService if registered
      if (Get.isRegistered<AdService>()) {
        AdService.to.adsEnabled.value = isAdVisible.value;
      }
    }
  }
}
