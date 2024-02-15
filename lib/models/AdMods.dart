import 'package:flutter/cupertino.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdMod {
  static String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  static BannerAd? _bannerAd1;
  static BannerAd? _bannerAd2;
  static BannerAd? _bannerAd3;

  static void loadAd() async {
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
      adUnitId: _adbannerUnitId,
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
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd3 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        }
      )
    ).load();
  }
  static bool adNullChecker(int ad_num){
    switch(ad_num){
      case 1:
        if(_bannerAd1 != null){
          return true;
        }else{
          return false;
        }
      case 2:
        if(_bannerAd2 != null){
          return true;
        }else{
          return false;
        }
      case 3:
        if(_bannerAd3 != null){
          return true;
        }else{
          return false;
        }
    }
    return false;
  }
  static Widget displayAd1() {
    if (_bannerAd1 != null) {
      return Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: SizedBox(
            width: _bannerAd1!.size.width.toDouble(),
            height: _bannerAd1!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd1!)
          )
        )
      );
    } else {
      return SizedBox.shrink();
    }
  }
  static Widget displayAd2() {
    if (_bannerAd2 != null) {
      return Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: SizedBox(
            width: _bannerAd2!.size.width.toDouble(),
            height: _bannerAd2!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd2!)
          )
        )
      );
    } else {
      return SizedBox.shrink();
    }
  }
  static Widget displayAd3() {
    if (_bannerAd3 != null) {
      return Align(
        alignment: Alignment.topCenter,
        child: SafeArea(
          child: SizedBox(
            width: _bannerAd3!.size.width.toDouble(),
            height: _bannerAd3!.size.height.toDouble(),
            child: AdWidget(ad: _bannerAd3!)
          )
        )
      );
    } else {
      return SizedBox.shrink();
    }
  }
}