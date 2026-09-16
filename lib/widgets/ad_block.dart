import 'package:ethiochef/controllers/ad_visibility_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBlock extends StatelessWidget {
  final AdVisibilityController adVisibilityController =
      Get.find<AdVisibilityController>();
  AdBlock({super.key, required BannerAd? bannerAd, required this.isbottom})
    : _bannerAd = bannerAd;
  final bool isbottom;
  final BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      double pad = isbottom ? 90.0 : 0.0;
      if (!adVisibilityController.isAdVisible.value || _bannerAd == null) {
        return SizedBox.shrink();
      }
      return Padding(
        padding: EdgeInsets.only(bottom: pad),
        child: Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
        ),
      );
    });
  }
}
