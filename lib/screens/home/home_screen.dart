import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../controllers/home_controller.dart';
import '../../generated/assets.dart';
import '../../services/ad_service.dart';
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
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  final HomeController controller = Get.put(HomeController());

  @override
  bool get wantKeepAlive => true;

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

  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdMiddle;
  BannerAd? _bannerAdBottom;

  @override
  void dispose() {
    _bannerAdTop?.dispose();
    _bannerAdMiddle?.dispose();
    _bannerAdBottom?.dispose();
    super.dispose();
  }

  void loadAd() {
    if (!AdService.to.adsEnabled.value) return;
    print("Loading Home Banner Ads (Top, Middle, Bottom)");

    if (_bannerAdTop == null) {
      AdService.loadBannerSequentially(
        position: BannerPosition.top,
        isMounted: () => mounted,
        onLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAdTop = ad;
            });
          } else {
            ad.dispose();
          }
        },
        onFailed: (err) {
          debugPrint('⚠️ [AdMob] Home top banner failed: ${err.message}');
        },
      );
    }

    if (_bannerAdMiddle == null) {
      AdService.loadBannerSequentially(
        position: BannerPosition.middle,
        isMounted: () => mounted,
        onLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAdMiddle = ad;
            });
          } else {
            ad.dispose();
          }
        },
        onFailed: (err) {
          debugPrint('⚠️ [AdMob] Home middle banner failed: ${err.message}');
        },
      );
    }

    if (_bannerAdBottom == null) {
      AdService.loadBannerSequentially(
        position: BannerPosition.bottom,
        isMounted: () => mounted,
        onLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAdBottom = ad;
            });
          } else {
            ad.dispose();
          }
        },
        onFailed: (err) {
          debugPrint('⚠️ [AdMob] Home bottom banner failed: ${err.message}');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Obx(() {
        if (controller.isLoading.value) {
          return Loading();
        }
        if (controller.hasError.value) {
          return Center(
            child: ErrorCard(
              errorType: controller.errorMessage.value,
              refresh: () {
                AdService.clearCooldownsAndRequestRefresh();
                loadAd();
                controller.fetchHomeData(refresh: true);
              },
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
        onRefresh: () async {
          AdService.clearCooldownsAndRequestRefresh();
          loadAd();
          await controller.fetchHomeData(refresh: true);
        },
        child: CustomScrollView(
          slivers: [
            if (_bannerAdTop != null)
              SliverToBoxAdapter(
                child: AdBlock(
                  bannerAd: _bannerAdTop,
                  isbottom: false,
                ),
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
                      if (_bannerAdMiddle != null)
                        AdBlock(bannerAd: _bannerAdMiddle, isbottom: false),
                      CategoryCarousel(
                        category: controller.categories,
                        secondLevelPromotions: controller.secondLevelPromotions,
                      ),
                      if (_bannerAdBottom != null)
                        AdBlock(bannerAd: _bannerAdBottom, isbottom: true),
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
