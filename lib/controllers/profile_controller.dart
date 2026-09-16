import 'package:get/get.dart';

import '../models/footer_data.dart';
import '../models/user.dart';
import '../models/user_profile.dart';
import '../services/authorization_service.dart';
import '../services/footer_service.dart';
import '../services/user_service.dart';

class ProfileController extends GetxController {
  var userProfile = Rxn<UserProfile>();
  var footerData = Rxn<FooterData>();

  var isProfileLoading = false.obs;
  var isFooterLoading = false.obs;

  var profileError = "".obs;
  var footerError = "".obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    fetchUserProfile();
    fetchFooterData();
  }

  Future<void> fetchUserProfile() async {
    isProfileLoading.value = true;
    profileError.value = "";
    try {
      var access_token = await AuthService.getAuthorizationToken();
      if (access_token == 'none') {
        userProfile.value = UserProfile(
          user: User(firstName: 'Guest', lastName: 'User'),
          message: "Guest Mode",
        );
      } else {
        final userService = UserService();
        var userData = await userService.fetchUserProfile();
        userProfile.value = userData;
      }
    } catch (e) {
      profileError.value = e.toString();
    } finally {
      isProfileLoading.value = false;
    }
  }

  Future<void> fetchFooterData() async {
    isFooterLoading.value = true;
    footerError.value = "";
    try {
      FooterService foot = FooterService();
      var data = await foot.getFooterData();
      footerData.value = data;
    } catch (e) {
      footerError.value = e.toString();
    } finally {
      isFooterLoading.value = false;
    }
  }
}
