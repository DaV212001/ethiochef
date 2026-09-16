import 'package:ethiochef/config/storage_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../controllers/profile_controller.dart';
import '../../../screens/auth/auth_screen.dart';
import '../../../screens/subscription/layout/payment.dart';
import '../../../widgets/ad_block.dart';
import '../../controllers/home_controller.dart';
import '../../models/user.dart';
import '../../models/user_profile.dart';
import '../../services/ad_service.dart';
import '../../services/authorization_service.dart';
import '../../services/user_service.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/error_card.dart';
import '../../widgets/loading.dart';
import '../../widgets/main_button.dart';
import '../../widgets/profile/user_screen_footer.dart';
import 'layout/route_list.dart';
import 'layout/user_screen_header.dart';

class ProfileScreen extends StatefulWidget {
  final Function()? onRefresh;
  const ProfileScreen({Key? key, this.onRefresh}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileController controller = Get.put(ProfileController());
  bool isLoggedIn = false;
  late User user = User(lastName: '', firstName: '');
  bool isLoading = false;

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  @override
  void dispose() {
    _bannerAd1?.dispose();
    _bannerAd2?.dispose();
    _bannerAd3?.dispose();
    super.dispose();
  }

  static String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  static BannerAd? _bannerAd1;
  static BannerAd? _bannerAd2;
  static BannerAd? _bannerAd3;
  void loadAd() async {
    if (Get.isRegistered<AdService>() && !AdService.to.adsEnabled.value) return;
    print("Loading Ads");
    await BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd1 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
    await BannerAd(
      adUnitId: 'ca-app-pub-4750411587709054/1691458173',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd2 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();

    await BannerAd(
      adUnitId: 'ca-app-pub-4750411587709054/2820228086',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd3 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
  }

  bool telebirr = false;

  int amount = 0;
  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: Obx(() {
          if (controller.isProfileLoading.value &&
              controller.userProfile.value == null) {
            return Loading();
          }

          if (controller.profileError.isNotEmpty &&
              controller.userProfile.value == null) {
            return Center(
              child: ErrorCard(
                errorType: controller.profileError.value,
                refresh: () => controller.fetchUserProfile(),
              ),
            );
          }

          if (controller.userProfile.value == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.error,
                      color: theme.colorScheme.error,
                      size: 100,
                    ),
                    Text(
                      "another_account_login".tr,
                      style: TextStyle(
                        fontSize: isTablet ? 11.sp : 15.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.error,
                      ),
                    ),
                    MainButton(
                      isLoading: isLoading,
                      text: "log_out".tr,
                      onPress: () async {
                        setState(() {
                          isLoading = true;
                        });
                        await AuthService.logout();
                        SharedPreferences shared =
                            await SharedPreferences.getInstance();
                        await shared.remove('savedRecipes');
                        await shared.remove('ethioChef_authorization_token');
                        ConfigPreference.logOut();
                        // if (Get.isRegistered<HomeController>()) {
                        //   Get.find<HomeController>().fetchHomeData(
                        //     refresh: true,
                        //   );
                        // }
                        // if (Get.isRegistered<CategoryFoodController>()) {
                        //   Get.find<CategoryFoodController>().refreshData();
                        // }
                        // Phoenix.rebirth(context);
                        setState(() {
                          isLoading = false;
                        });
                      },
                    ),
                  ],
                ),
              ),
            );
          }

          return buildUserScreen(controller.userProfile.value!);
        }),
      ),
    );
  }

  Widget buildUserScreen(UserProfile user) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    bool isGuest = user.message == "Guest Mode";

    return RefreshIndicator(
      onRefresh: () async {
        controller.fetchData();
      },
      child: SingleChildScrollView(
        child: Column(
          children: [
            UserScreenHeader(
              guest: user.message == 'Guest Mode',
              user: user,
              reFresh: () {
                controller.fetchUserProfile();
              },
            ),
            if (isGuest)
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MainButton(
                  isLoading: isLoading,
                  text: "sign_in_button".tr,
                  onPress: () async {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: AuthScreen(),
                      withNavBar: false,
                    );
                  },
                ),
              ),
            if (user.message == "User is not subscribed" && !isGuest)
              GestureDetector(
                onTap: () {
                  PersistentNavBarNavigator.pushNewScreen(
                    context,
                    screen: PaymentCheckout(
                      isSMS: true,
                      isNormalSubscription: true,
                    ),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  color: Colors.red,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                      vertical: 5,
                    ),
                    child: Text(
                      'please_subscribe_now'.tr,
                      style: TextStyle(
                        fontSize: isTablet ? 11.sp : 15.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondary,
                      ),
                    ),
                  ),
                ),
              ),
            RouteList(
              banner: _bannerAd3,
              telebirr: telebirr,
              guest: user.message == 'Guest Mode',
              onRefresh: () {
                controller.fetchData();
              },
            ),
            if (_bannerAd2 != null)
              AdBlock(bannerAd: _bannerAd2, isbottom: true),
            SizedBox(height: 5.h),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              child: MainButton(
                isLoading: isLoading,
                text: isGuest ? "sign_in_button".tr : "log_out".tr,
                onPress: () async {
                  if (isGuest) {
                    PersistentNavBarNavigator.pushNewScreen(
                      context,
                      screen: AuthScreen(),
                      withNavBar: false,
                    );
                    return;
                  }
                  setState(() {
                    isLoading = true;
                  });
                  UserService service = UserService();
                  if (user.user?.id != null) {
                    await service.logOut(user.user!.id!);
                  }
                  await AuthService.logout();
                  SharedPreferences shared =
                      await SharedPreferences.getInstance();
                  await shared.remove('savedRecipes');
                  await shared.remove('ethioChef_authorization_token');
                  ConfigPreference.logOut();
                  if (Get.isRegistered<HomeController>()) {
                    Get.find<HomeController>().fetchHomeData(refresh: true);
                  }
                  controller.fetchData();
                  Phoenix.rebirth(context);
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ),
            SizedBox(height: 5.h),
            Obx(() {
              if (controller.isFooterLoading.value) {
                return const Center(
                  child: SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(),
                  ),
                );
              }
              if (controller.footerData.value != null) {
                return Align(
                  alignment: Alignment.bottomCenter,
                  child: UserScreenFooter(
                    footerData: controller.footerData.value!,
                  ),
                );
              }
              return const SizedBox.shrink();
            }),
            SizedBox(height: 45),
          ],
        ),
      ),
    );
  }
}
