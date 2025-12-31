import 'package:get/get.dart';

import '../models/privacy_policies.dart';
import '../services/app_doc_services.dart';

class PrivacyPolicyController extends GetxController {
  var privacyPolicies = <PrivacyPolicy>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchPrivacyPolicies();
    super.onInit();
  }

  Future<void> fetchPrivacyPolicies() async {
    privacyPolicies.value = await AppDocServices().fetchPrivacyPolicies();
    isLoading.value = false;
  }
}
