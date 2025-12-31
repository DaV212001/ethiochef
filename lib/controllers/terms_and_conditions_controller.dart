import 'package:get/get.dart';

import '../models/terms_and_conditions.dart';
import '../services/app_doc_services.dart';

class TermsAndConditionsController extends GetxController {
  var termsAndConditions = <TermsAndConditions>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchTermsAndConditions();
    super.onInit();
  }

  Future<void> fetchTermsAndConditions() async {
    termsAndConditions.value = await AppDocServices().fetchTermsAndConditions();
    isLoading.value = false;
  }
}
