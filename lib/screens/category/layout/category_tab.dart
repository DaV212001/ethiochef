import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../controllers/category_food_controller.dart';
import '../../../models/category.dart';
import '../../../screens/category/layout/vertical_food_list.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/ad_block.dart';
import '../../../widgets/screen_head.dart';

class CategoryCustomTab extends StatefulWidget {
  final List<Category> category;
  const CategoryCustomTab({super.key, required this.category});

  @override
  State<CategoryCustomTab> createState() => _CategoryCustomTabState();
}

class _CategoryCustomTabState extends State<CategoryCustomTab> {
  final CategoryFoodController controller = Get.put(CategoryFoodController());
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    if (widget.category.isNotEmpty) {
      controller.changeCategory(widget.category[selectedIndex].id);
    }
    _loadAd();
  }

  final String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  BannerAd? _bannerAd;
  BannerAd? _bannerAd2;
  BannerAd? _bannerAd3;

  void _loadAd() async {
    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();

    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd2 = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();

    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd3 = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    final ThemeData theme = Theme.of(context);
    List<Tab> tabs = widget.category
        .map((e) => Tab(text: e.name!.toString()))
        .toList();

    return SafeArea(
      child: DefaultTabController(
        length: widget.category.length,
        child: Column(
          mainAxisSize: MainAxisSize.max,
          children: [
            _bannerAd != null
                ? AdBlock(bannerAd: _bannerAd, isbottom: false)
                : const SizedBox.shrink(),

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
                  controller.refreshData();
                },
                child: VerticalFoodList(
                  key: PageStorageKey(
                    'category_${widget.category[selectedIndex].id}',
                  ),
                  bannerAd2: _bannerAd2,
                  bannerAd3: _bannerAd3,
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
    super.dispose();
  }
}
