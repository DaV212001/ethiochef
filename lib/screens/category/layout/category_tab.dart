import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../controllers/category_food_controller.dart';
import '../../../models/category.dart';
import '../../../screens/category/layout/vertical_food_list.dart';
import '../../../services/ad_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/ad_block.dart';
import '../../../widgets/screen_head.dart';

class CategoryCustomTab extends StatefulWidget {
  final List<Category> category;
  const CategoryCustomTab({super.key, required this.category});

  @override
  State<CategoryCustomTab> createState() => _CategoryCustomTabState();
}

class _CategoryCustomTabState extends State<CategoryCustomTab>
    with AutomaticKeepAliveClientMixin {
  final CategoryFoodController controller = Get.put(CategoryFoodController());
  int selectedIndex = 0;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    if (widget.category.isNotEmpty) {
      controller.changeCategory(widget.category[selectedIndex].id);
    }
    _loadAd();
  }

  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdMiddle;
  BannerAd? _bannerAdBottom;

  void _loadAd() {
    if (!AdService.to.adsEnabled.value) return;
    print("Loading Category Banner Ads (Top, Middle, Bottom)");

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
          debugPrint('⚠️ [AdMob] Category top banner failed: ${err.message}');
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
          debugPrint('⚠️ [AdMob] Category middle banner failed: ${err.message}');
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
          debugPrint('⚠️ [AdMob] Category bottom banner failed: ${err.message}');
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    final ThemeData theme = Theme.of(context);
    List<Tab> tabs = widget.category
        .map((e) => Tab(text: e.name.toString()))
        .toList();

    return SafeArea(
      child: DefaultTabController(
        length: widget.category.length,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            if (_bannerAdTop != null)
              AdBlock(bannerAd: _bannerAdTop, isbottom: false),

            ScreenHead(
              hasNotification: true,
              screen: 1,
              searchHint: "search".tr,
            ),
            ButtonsTabBar(
              onTap: (index) {
                setState(() {
                  selectedIndex = index;
                });
                controller.changeCategory(widget.category[index].id);
              },
              backgroundColor: theme.colorScheme.primary,
              unselectedBackgroundColor: Colors.transparent,
              unselectedLabelStyle: TextStyle(
                fontSize: isTablet ? 11.sp : 15.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.primary,
              ),
              labelStyle: TextStyle(
                fontSize: isTablet ? 11.sp : 15.sp,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
              contentPadding: EdgeInsets.symmetric(horizontal: 10),
              radius: 5,
              tabs: tabs,
            ),

            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  AdService.clearCooldownsAndRequestRefresh();
                  _loadAd();
                  controller.refreshData();
                },
                child: VerticalFoodList(
                  key: PageStorageKey(
                    'category_${widget.category[selectedIndex].id}',
                  ),
                  bannerAd2: _bannerAdMiddle,
                  bannerAd3: _bannerAdBottom,
                  pagingController: controller.pagingController,
                  isSearchList: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _bannerAdTop?.dispose();
    _bannerAdMiddle?.dispose();
    _bannerAdBottom?.dispose();
    super.dispose();
  }
}
