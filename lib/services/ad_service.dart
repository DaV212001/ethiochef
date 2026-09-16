import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdService extends GetxService with WidgetsBindingObserver {
  static AdService get to => Get.find<AdService>();

  // Ad Unit IDs
  static const String bannerAdUnitId = 'ca-app-pub-4750411587709054/6014720876';
  static const String interstitialAdUnitId = 'ca-app-pub-4750411587709054/9602612094';
  static const String appOpenAdUnitId = 'ca-app-pub-4750411587709054/4693548698';

  /// PROGRAMMATIC DEVELOPER TOGGLE:
  /// True by default. The developer can toggle this at runtime or code level:
  /// e.g. `AdService.to.adsEnabled.value = false;` to turn off all ads.
  final RxBool adsEnabled = true.obs;

  // Interstitial Ad
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  DateTime? _lastInterstitialShownAt;

  // App Open Ad
  AppOpenAd? _appOpenAd;
  bool _isAppOpenLoading = false;
  bool _isShowingAppOpenAd = false;
  DateTime? _appOpenLoadTime;

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    if (adsEnabled.value) {
      loadInterstitialAd();
      loadAppOpenAd();
    }

    // React to toggle changes
    ever(adsEnabled, (bool enabled) {
      if (enabled) {
        loadInterstitialAd();
        loadAppOpenAd();
      } else {
        _interstitialAd?.dispose();
        _interstitialAd = null;
        _appOpenAd?.dispose();
        _appOpenAd = null;
      }
    });
  }

  @override
  void onClose() {
    WidgetsBinding.instance.removeObserver(this);
    _interstitialAd?.dispose();
    _appOpenAd?.dispose();
    super.onClose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      showAppOpenAdIfAvailable();
    }
  }

  // ==================== INTERSTITIAL AD ====================

  void loadInterstitialAd() {
    if (!adsEnabled.value || _isInterstitialLoading || _interstitialAd != null) {
      return;
    }
    _isInterstitialLoading = true;

    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialLoading = false;
          debugPrint('AdService: Interstitial ad loaded.');

          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialLoading = false;
          debugPrint('AdService: Interstitial ad failed to load: $error');
        },
      ),
    );
  }

  /// Show interstitial ad on navigation / screen changes.
  /// Includes a 15-second debounce safeguard so users aren't overwhelmed.
  void showInterstitialAd({bool force = false}) {
    if (!adsEnabled.value) return;

    if (!force && _lastInterstitialShownAt != null) {
      final difference = DateTime.now().difference(_lastInterstitialShownAt!);
      if (difference.inSeconds < 15) {
        debugPrint('AdService: Skipping interstitial due to cooldown.');
        return;
      }
    }

    if (_interstitialAd == null) {
      debugPrint('AdService: Interstitial ad not ready yet.');
      loadInterstitialAd();
      return;
    }

    _lastInterstitialShownAt = DateTime.now();
    _interstitialAd!.show();
  }

  // ==================== APP OPEN AD ====================

  void loadAppOpenAd() {
    if (!adsEnabled.value || _isAppOpenLoading || _appOpenAd != null) {
      return;
    }
    _isAppOpenLoading = true;

    AppOpenAd.load(
      adUnitId: appOpenAdUnitId,
      orientation: AppOpenAd.orientationPortrait,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _appOpenLoadTime = DateTime.now();
          _isAppOpenLoading = false;
          debugPrint('AdService: App Open ad loaded.');
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          _isAppOpenLoading = false;
          debugPrint('AdService: App Open ad failed to load: $error');
        },
      ),
    );
  }

  void showAppOpenAdIfAvailable() {
    if (!adsEnabled.value || _isShowingAppOpenAd) return;

    if (_appOpenAd == null) {
      debugPrint('AdService: App Open ad not ready yet.');
      loadAppOpenAd();
      return;
    }

    // Expire after 4 hours
    if (_appOpenLoadTime != null &&
        DateTime.now().difference(_appOpenLoadTime!).inHours >= 4) {
      _appOpenAd?.dispose();
      _appOpenAd = null;
      loadAppOpenAd();
      return;
    }

    _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        _isShowingAppOpenAd = true;
      },
      onAdDismissedFullScreenContent: (ad) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        _isShowingAppOpenAd = false;
        ad.dispose();
        _appOpenAd = null;
        loadAppOpenAd();
      },
    );

    _appOpenAd!.show();
  }

  // ==================== BANNER AD HELPER ====================

  /// Creates and loads a BannerAd widget listener
  static BannerAd createBannerAd({
    Function(BannerAd)? onLoaded,
    Function(BannerAd)? onAdLoaded,
    Function(LoadAdError)? onFailed,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          onLoaded?.call(ad as BannerAd);
          onAdLoaded?.call(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          onFailed?.call(error);
        },
      ),
    );
  }
}

/// Route observer to show interstitial ad when navigating to any screen.
class AdRouteObserver extends NavigatorObserver {
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    super.didPush(route, previousRoute);
    if (previousRoute != null && route is PageRoute) {
      _triggerAd();
    }
  }


  void _triggerAd() {
    try {
      if (Get.isRegistered<AdService>()) {
        AdService.to.showInterstitialAd();
      }
    } catch (e) {
      debugPrint('AdRouteObserver error: $e');
    }
  }
}
