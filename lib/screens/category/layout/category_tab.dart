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

  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdMiddle;
  BannerAd? _bannerAdBottom;

  void _loadAd() {
    print("Loading Category Banner Ads with ID: ${AdService.bannerAdUnitId}");
    AdService.createBannerAd(
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _bannerAdTop = ad;
          });
        }
      },
      onFailed: (err) {
        if (mounted) {
          setState(() {
            _bannerAdTop = null;
          });
        }
      },
    )..load();

    AdService.createBannerAd(
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _bannerAdMiddle = ad;
          });
        }
      },
      onFailed: (err) {
        if (mounted) {
          setState(() {
            _bannerAdMiddle = null;
          });
        }
      },
    )..load();

    AdService.createBannerAd(
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _bannerAdBottom = ad;
          });
        }
      },
      onFailed: (err) {
        if (mounted) {
          setState(() {
            _bannerAdBottom = null;
          });
        }
      },
    )..load();
  }

  @override
  Widget build(BuildContext context) {
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
