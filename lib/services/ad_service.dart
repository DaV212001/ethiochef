import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum BannerPosition { top, middle, bottom }

class AdService extends GetxService with WidgetsBindingObserver {
  static AdService get to => Get.find<AdService>();

  // Set to true to verify whether the ad setup and UI work using Google's official test ad units
  static const bool useTestAds = false;

  // Active Standard Banner Ad Unit ID
  static const String _liveBannerAdUnitId =
      'ca-app-pub-4750411587709054/7572899454';

  static String get topBannerAdUnitId => useTestAds
      ? 'ca-app-pub-3940256099942544/6300978111'
      : _liveBannerAdUnitId;
  static String get middleBannerAdUnitId => useTestAds
      ? 'ca-app-pub-3940256099942544/6300978111'
      : _liveBannerAdUnitId;
  static String get bottomBannerAdUnitId => useTestAds
      ? 'ca-app-pub-3940256099942544/6300978111'
      : _liveBannerAdUnitId;

  // Legacy fallback getter
  static String get bannerAdUnitId => topBannerAdUnitId;

  // Standard Interstitial & App Open Ad Unit IDs
  static String get interstitialAdUnitId => useTestAds
      ? 'ca-app-pub-3940256099942544/1033173712'
      : 'ca-app-pub-4750411587709054/8502837745';
  static String get appOpenAdUnitId => useTestAds
      ? 'ca-app-pub-3940256099942544/9257395921'
      : 'ca-app-pub-4750411587709054/8619221961';

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
          debugPrint('✅ [AdMob] Interstitial ad loaded successfully (unit: $interstitialAdUnitId).');

          _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('❌ [AdMob] Interstitial ad failed to show: ${error.message} (code: ${error.code})');
              ad.dispose();
              _interstitialAd = null;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isInterstitialLoading = false;
          debugPrint('❌ [AdMob] Interstitial ad failed to load:');
          debugPrint('   - Code: ${error.code} (${_getErrorExplanation(error.code)})');
          debugPrint('   - Message: ${error.message}');
          debugPrint('   - AdUnit: $interstitialAdUnitId');
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
          debugPrint('✅ [AdMob] App Open ad loaded successfully (unit: $appOpenAdUnitId).');
        },
        onAdFailedToLoad: (error) {
          _appOpenAd = null;
          _isAppOpenLoading = false;
          debugPrint('❌ [AdMob] App Open ad failed to load:');
          debugPrint('   - Code: ${error.code} (${_getErrorExplanation(error.code)})');
          debugPrint('   - Message: ${error.message}');
          debugPrint('   - AdUnit: $appOpenAdUnitId');
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

  /// Creates and loads a BannerAd widget listener with position-based unit ID and detailed logging
  static BannerAd createBannerAd({
    BannerPosition position = BannerPosition.top,
    String? customAdUnitId,
    Function(BannerAd)? onLoaded,
    Function(BannerAd)? onAdLoaded,
    Function(LoadAdError)? onFailed,
  }) {
    final adUnit = customAdUnitId ??
        (position == BannerPosition.top
            ? topBannerAdUnitId
            : position == BannerPosition.middle
                ? middleBannerAdUnitId
                : bottomBannerAdUnitId);
    return BannerAd(
      adUnitId: adUnit,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          debugPrint('✅ [AdMob] ${position.name.toUpperCase()} BannerAd LOADED successfully (unit: $adUnit)');
          onLoaded?.call(ad as BannerAd);
          onAdLoaded?.call(ad as BannerAd);
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ [AdMob] ${position.name.toUpperCase()} BannerAd FAILED to load:');
          debugPrint('   - Code: ${error.code} (${_getErrorExplanation(error.code)})');
          debugPrint('   - Message: ${error.message}');
          debugPrint('   - Domain: ${error.domain}');
          debugPrint('   - AdUnit: $adUnit');
          ad.dispose();
          onFailed?.call(error);
        },
      ),
    );
  }

  // ==================== SEQUENTIAL BANNER QUEUE & RATE LIMIT PROTECTION ====================

  static final Map<String, DateTime> _adUnitCooldowns = {};
  static final List<_QueuedBannerRequest> _bannerQueue = [];
  static bool _isProcessingBannerQueue = false;

  /// Global notifier incremented on pull-to-refresh across screens.
  /// Listening banner widgets whose ads failed or were skipped will attempt a reload.
  static final ValueNotifier<int> refreshNotifier = ValueNotifier<int>(0);

  static bool isAdUnitInCooldown(String adUnitId) {
    final cooldownUntil = _adUnitCooldowns[adUnitId];
    if (cooldownUntil == null) return false;
    if (DateTime.now().isBefore(cooldownUntil)) {
      return true;
    }
    _adUnitCooldowns.remove(adUnitId);
    return false;
  }

  static void setAdUnitCooldown(String adUnitId, {int seconds = 15}) {
    _adUnitCooldowns[adUnitId] = DateTime.now().add(Duration(seconds: seconds));
  }

  /// Clears active failure cooldowns and triggers a reload event for all listening banner widgets.
  static void clearCooldownsAndRequestRefresh() {
    debugPrint('🔄 [AdMob] Pull-to-refresh: clearing ad unit cooldowns and triggering banner retry.');
    _adUnitCooldowns.clear();
    refreshNotifier.value++;
  }


  /// Queues a banner ad load sequentially with backoff protection.
  /// Prevents AdMob "Too many recently failed requests" rate limits when multiple
  /// inline banners mount simultaneously.
  static void loadBannerSequentially({
    required BannerPosition position,
    String? customAdUnitId,
    required bool Function() isMounted,
    required Function(BannerAd) onLoaded,
    required Function(LoadAdError) onFailed,
  }) {
    final adUnit = customAdUnitId ??
        (position == BannerPosition.top
            ? topBannerAdUnitId
            : position == BannerPosition.middle
                ? middleBannerAdUnitId
                : bottomBannerAdUnitId);

    _bannerQueue.add(_QueuedBannerRequest(
      adUnitId: adUnit,
      position: position,
      isMounted: isMounted,
      onLoaded: onLoaded,
      onFailed: onFailed,
    ));

    _processBannerQueue();
  }

  static Future<void> _processBannerQueue() async {
    if (_isProcessingBannerQueue) return;
    _isProcessingBannerQueue = true;

    while (_bannerQueue.isNotEmpty) {
      final request = _bannerQueue.removeAt(0);

      if (!request.isMounted()) {
        continue;
      }

      if (isAdUnitInCooldown(request.adUnitId)) {
        final remainingSeconds = _adUnitCooldowns[request.adUnitId]!
            .difference(DateTime.now())
            .inSeconds;
        debugPrint(
          '⏳ [AdMob] Skipping ${request.position.name.toUpperCase()} BannerAd request for ${request.adUnitId}: cooldown active (${remainingSeconds}s remaining to prevent AdMob rate limiting).',
        );
        request.onFailed(
          LoadAdError(
            1,
            'com.google.android.gms.ads',
            'Ad unit is in cooldown to prevent rate limiting',
            null,
          ),
        );
        continue;
      }

      final completer = Completer<void>();

      BannerAd(
        adUnitId: request.adUnitId,
        size: AdSize.banner,
        request: const AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            debugPrint('✅ [AdMob] ${request.position.name.toUpperCase()} BannerAd LOADED successfully (unit: ${request.adUnitId})');
            _adUnitCooldowns.remove(request.adUnitId);
            if (request.isMounted()) {
              request.onLoaded(ad as BannerAd);
            } else {
              ad.dispose();
            }
            if (!completer.isCompleted) completer.complete();
          },
          onAdFailedToLoad: (ad, error) {
            debugPrint('❌ [AdMob] ${request.position.name.toUpperCase()} BannerAd FAILED to load:');
            debugPrint('   - Code: ${error.code} (${_getErrorExplanation(error.code)})');
            debugPrint('   - Message: ${error.message}');
            debugPrint('   - AdUnit: ${request.adUnitId}');
            ad.dispose();

            // Set a 15-second cooldown on failure to avoid Google SDK rate limits
            setAdUnitCooldown(request.adUnitId, seconds: 15);

            if (request.isMounted()) {
              request.onFailed(error);
            }
            if (!completer.isCompleted) completer.complete();
          },
        ),
      ).load();

      await completer.future;

      // Small pacing delay between sequential requests
      await Future.delayed(const Duration(milliseconds: 1200));
    }

    _isProcessingBannerQueue = false;
  }

  static String _getErrorExplanation(int code) {
    switch (code) {
      case 0:
        return "INTERNAL_ERROR (Something happened internally; e.g. invalid response from ad server or Google Play services issue)";
      case 1:
        return "INVALID_REQUEST (The ad request was invalid; e.g. wrong ad unit ID, wrong App ID in AndroidManifest, or package name mismatch)";
      case 2:
        return "NETWORK_ERROR (Ad request failed due to network connectivity)";
      case 3:
        return "NO_FILL (Request reached AdMob successfully, but Google had no ad inventory to return. Common for new ad units, unverified accounts, policy limits, or test devices without test mode)";
      default:
        return "UNKNOWN_ERROR";
    }
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

class _QueuedBannerRequest {
  final String adUnitId;
  final BannerPosition position;
  final bool Function() isMounted;
  final Function(BannerAd) onLoaded;
  final Function(LoadAdError) onFailed;

  _QueuedBannerRequest({
    required this.adUnitId,
    required this.position,
    required this.isMounted,
    required this.onLoaded,
    required this.onFailed,
  });
}
