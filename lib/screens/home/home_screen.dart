import 'package:ethiochef/controllers/ad_visibility_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../controllers/home_controller.dart';
import '../../generated/assets.dart';
import '../../services/scheduled_notification_service.dart';
import '../../utils/constants.dart';
import '../../utils/screen_utils.dart';
import '../../utils/update_manager.dart';
import '../../widgets/ad_block.dart';
import '../../widgets/error_card.dart';
import '../../widgets/loading.dart';
import '../competition/competitions_screen.dart';
import '../recipe_status/my_submitted_recipe.dart';
import 'layout/ads_carousel.dart';
import 'layout/category_carousel.dart';
import 'layout/meal_tab.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  final HomeController controller = Get.put(HomeController());

  @override
  void initState() {
    loadAd();
    _initServices();
    super.initState();
  }

  void _initServices() {
    UpdateManager um = UpdateManager();
    um.showUpdateDialog(context);
    NotificationScheduled.init(context: context);
    listenNotification();
  }

  static const String _adbannerUnitId = kDebugMode
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-4750411587709054/9425791625';
  static const String _adbannerUnitId2 = kDebugMode
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-4750411587709054/1691458173';
  static BannerAd? _bannerAd1;
  static BannerAd? _bannerAd2;

  void loadAd() async {
    print("Loading Ads");
    await BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd1 = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
    await BannerAd(
      adUnitId: _adbannerUnitId2,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd2 = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Loading();
        }
        if (controller.hasError.value) {
          return Center(
            child: ErrorCard(
              errorType: controller.errorMessage.value,
              refresh: () => controller.fetchHomeData(refresh: true),
            ),
          );
        }
        return buildHomePage();
      }),
    );
  }

  Widget buildHomePage() {
    final bool isTablet = ScreenUtils.isTablet(context);
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () => controller.fetchHomeData(refresh: true),
        child: CustomScrollView(
          slivers: [
            Obx(
              () =>
                  Get.find<AdVisibilityController>().isAdVisible.value &&
                      _bannerAd2 != null
                  ? SliverAppBar(
                      pinned: true,
                      floating: false,
                      flexibleSpace: FlexibleSpaceBar(
                        background: AdBlock(
                          bannerAd: _bannerAd2,
                          isbottom: false,
                        ),
                      ),
                    )
                  : const SliverToBoxAdapter(),
            ),

            SliverList(
              delegate: SliverChildListDelegate([
                AdsCarousel(promotion: controller.promotions),

                SizedBox(height: 5.h),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Column(
                    children: [
                      SizedBox(height: 15.h),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 8),
                        child: supportButton(
                          Colors.blue,
                          Constants.supportLink,
                          Assets.socialTelegram,
                          isTablet,
                          text: 'rec_food'.tr,
                        ),
                      ),
                      HomeCategoryTab(
                        breakfast: controller.breakfast,
                        lunch: controller.lunch,
                        superMeal: controller.superMeal,
                        dinner: controller.dinner,
                      ),
                      if (_bannerAd1 != null)
                        AdBlock(bannerAd: _bannerAd1, isbottom: false),
                      CategoryCarousel(
                        category: controller.categories,
                        secondLevelPromotions: controller.secondLevelPromotions,
                      ),
                      SizedBox(height: 15.h),
                      SizedBox(height: 15.h),
                    ],
                  ),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void listenNotification() =>
      NotificationScheduled.onNotifications.stream.listen((event) {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: SubmittedRecipe(),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      });
}
