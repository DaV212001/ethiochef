import 'package:get/get.dart';

import '../models/faq_ethio_clone.dart';
import '../services/app_doc_services.dart';

class FaqController extends GetxController {
  var faqs = <FAQ>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    fetchFaqs();
    super.onInit();
  }

  Future<void> fetchFaqs() async {
    faqs.value = await AppDocServices().fetchFaqs();
    isLoading.value = false;
  }
}
