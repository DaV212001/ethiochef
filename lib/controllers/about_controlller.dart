import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../models/about_us.dart';
import '../services/app_doc_services.dart';
import '../utils/error_util.dart';

class AboutUsController extends GetxController {
  var aboutUs = <AboutUs>[].obs;
  var isLoading = ApiCallStatus.holding.obs;

  @override
  void onInit() {
    fetchAboutUs();
    super.onInit();
  }

  Future<void> fetchAboutUs() async {
    isLoading.value = ApiCallStatus.loading;
    try {
      aboutUs.value = await AppDocServices().fetchAboutUs();
      isLoading.value = ApiCallStatus.success;
    } catch (e, s) {
      Logger().t(e, stackTrace: s);
      isLoading.value = ApiCallStatus.error;
    }
  }
}
