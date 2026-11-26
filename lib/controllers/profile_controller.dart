import 'package:ethiochef/config/storage_config.dart';
import 'package:ethiochef/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  /// Request Account Deletion (Apple App Store Guideline 5.1.1(v) & Google Play User Data)
  Future<void> requestAccountDeletion(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (ctx) {
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
        final titleColor = isDark ? Colors.white : const Color(0xFF141115);
        final bodyColor = isDark ? Colors.white70 : const Color(0xFF333333);

        return AlertDialog(
          backgroundColor: bgColor,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              const Icon(
                Icons.warning_amber_rounded,
                color: Colors.redAccent,
                size: 24,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'delete_account'.tr,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: titleColor,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            'delete_account_confirm_message'.tr,
            style: TextStyle(height: 1.4, color: bodyColor),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(
                'cancel'.tr,
                style: TextStyle(color: bodyColor),
              ),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.redAccent,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              onPressed: () => Navigator.of(ctx).pop(true),
              child: Text('delete_account'.tr),
            ),
          ],
        );
      },
    );

    if (confirmed == true) {
      try {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('delete_account_pending', true);
      } catch (_) {}

      final currentUserId = userProfile.value?.user?.id;
      if (currentUserId != null) {
        try {
          await UserService().logOut(currentUserId);
        } catch (_) {}
      }

      try {
        await AuthService.logout();
        final shared = await SharedPreferences.getInstance();
        await shared.remove('savedRecipes');
        await shared.remove('ethioChef_authorization_token');
        await ConfigPreference.logOut();
      } catch (_) {}

      if (Get.isRegistered<HomeController>()) {
        Get.find<HomeController>().fetchHomeData(refresh: true);
      }
      await fetchData();

      Get.snackbar(
        'delete_account_request_title'.tr,
        'delete_account_request_body'.tr,
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
        margin: const EdgeInsets.all(16),
      );
    }
  }
}
