import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

enum BannerPosition { top, middle, bottom }

class AdService extends GetxService with WidgetsBindingObserver {
  static AdService get to => Get.find<AdService>();

  // Set to true to verify whether the ad setup and UI work using Google's official test ad units
  static const bool useTestAds = false;

  // Remote Ad Units API endpoint
  static const String adUnitsApiUrl =
      'https://api.ethiochef.com/api/user/ad_units';

  // Fallback Standard Ad Unit IDs
  static const String fallbackBannerAdUnitId =
      'ca-app-pub-4750411587709054/7572899454';
  static const String fallbackInterstitialAdUnitId =
      'ca-app-pub-4750411587709054/8502837745';
  static const String fallbackAppOpenAdUnitId =
      'ca-app-pub-4750411587709054/8619221961';

  // Dynamic live ad units (initialized with fallbacks, updated from API or cache)
  static String _liveBannerAdUnitId = fallbackBannerAdUnitId;
  static String _liveInterstitialAdUnitId = fallbackInterstitialAdUnitId;
  static String _liveAppOpenAdUnitId = fallbackAppOpenAdUnitId;

  // Storage keys for persistent caching
  static const String _prefKeyBanner = 'cached_ad_unit_banner';
  static const String _prefKeyInterstitial = 'cached_ad_unit_interstitial';
  static const String _prefKeyAppOpen = 'cached_ad_unit_app_open';

  /// Loads cached ad units from SharedPreferences into static fields.
  static Future<void> loadCachedAdUnits() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedBanner = prefs.getString(_prefKeyBanner)?.trim();
      final cachedInterstitial = prefs.getString(_prefKeyInterstitial)?.trim();
      final cachedAppOpen = prefs.getString(_prefKeyAppOpen)?.trim();

      if (cachedBanner != null && cachedBanner.isNotEmpty) {
        _liveBannerAdUnitId = cachedBanner;
      }
      if (cachedInterstitial != null && cachedInterstitial.isNotEmpty) {
        _liveInterstitialAdUnitId = cachedInterstitial;
      }
      if (cachedAppOpen != null && cachedAppOpen.isNotEmpty) {
        _liveAppOpenAdUnitId = cachedAppOpen;
      }
      debugPrint('📦 [AdMob] Cached ad units loaded: banner=$_liveBannerAdUnitId, interstitial=$_liveInterstitialAdUnitId, appOpen=$_liveAppOpenAdUnitId');
    } catch (e) {
      debugPrint('⚠️ [AdMob] Error loading cached ad units: $e');
    }
  }

  /// Fetches latest ad unit IDs from the backend API, updates cache and in-memory IDs.
  static Future<void> fetchRemoteAdUnits() async {
    try {
      debugPrint('🌐 [AdMob] Fetching remote ad units from $adUnitsApiUrl...');
      final response = await http
          .get(Uri.parse(adUnitsApiUrl))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        final dynamic body = jsonDecode(response.body);
        final dynamic data = body is Map<String, dynamic> ? body['data'] : null;
        if (data is Map<String, dynamic>) {
          final banner = data['banner']?.toString().trim();
          final interstitial = data['interstitial']?.toString().trim();
          final appOpen = data['app_open']?.toString().trim();

          final prefs = await SharedPreferences.getInstance();

          if (banner != null && banner.isNotEmpty) {
            _liveBannerAdUnitId = banner;
            await prefs.setString(_prefKeyBanner, banner);
          }
          if (interstitial != null && interstitial.isNotEmpty) {
            _liveInterstitialAdUnitId = interstitial;
            await prefs.setString(_prefKeyInterstitial, interstitial);
          }
          if (appOpen != null && appOpen.isNotEmpty) {
            _liveAppOpenAdUnitId = appOpen;
            await prefs.setString(_prefKeyAppOpen, appOpen);
          }

          debugPrint(
            '✅ [AdMob] Remote ad units updated: '
            'banner=$_liveBannerAdUnitId, interstitial=$_liveInterstitialAdUnitId, appOpen=$_liveAppOpenAdUnitId',
          );

          // If interstitial or app-open ads are not yet loaded, trigger load
          if (Get.isRegistered<AdService>()) {
            final service = AdService.to;
            if (service.adsEnabled.value) {
              if (service._interstitialAd == null && !service._isInterstitialLoading) {
                service.loadInterstitialAd();
              }
              if (service._appOpenAd == null && !service._isAppOpenLoading) {
                service.loadAppOpenAd();
              }
            }
          }
        }
      } else {
        debugPrint('⚠️ [AdMob] Failed to fetch remote ad units: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('⚠️ [AdMob] Error fetching remote ad units: $e');
    }
  }

  static String get topBannerAdUnitId => useTestAds
      ? 'ca-app-pub-3940256099942544/6300978111'
      : _liveBannerAdUnitId;
  static String get middleBannerAdUnitId => topBannerAdUnitId;
  static String get bottomBannerAdUnitId => topBannerAdUnitId;
  static String get bannerAdUnitId => topBannerAdUnitId;

  static String get interstitialAdUnitId => useTestAds
      ? 'ca-app-pub-3940256099942544/1033173712'
      : _liveInterstitialAdUnitId;
  static String get appOpenAdUnitId => useTestAds
      ? 'ca-app-pub-3940256099942544/9257395921'
      : _liveAppOpenAdUnitId;

  /// PROGRAMMATIC DEVELOPER TOGGLE:
  /// True by default. The developer can toggle this at runtime or code level:
  /// e.g. `AdService.to.adsEnabled.value = false;` to turn off all ads.
  final RxBool adsEnabled = true.obs;

  // Interstitial Ad
  InterstitialAd? _interstitialAd;
  bool _isInterstitialLoading = false;
  bool _isShowingInterstitialAd = false;
  DateTime? _lastInterstitialShownAt;

  // App Open Ad
  AppOpenAd? _appOpenAd;
  bool _isAppOpenLoading = false;
  bool _isShowingAppOpenAd = false;
  DateTime? _appOpenLoadTime;
  bool _hasShownColdStartAppOpen = false;
  final DateTime _appStartTime = DateTime.now();

  @override
  void onInit() {
    super.onInit();
    WidgetsBinding.instance.addObserver(this);
    _initAdUnitsAndLoad();

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

  Future<void> _initAdUnitsAndLoad() async {
    await loadCachedAdUnits();
    if (adsEnabled.value) {
      loadInterstitialAd();
      loadAppOpenAd(isColdStart: true);
    }
    await fetchRemoteAdUnits();
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
    // Interstitial ads removed
    return;
  }

  /// Show interstitial ad on navigation / screen changes.
  /// Includes a 15-second debounce safeguard so users aren't overwhelmed.
  void showInterstitialAd({bool force = false}) {
    // Interstitial ads removed
    return;
  }

  // ==================== APP OPEN AD ====================

  void loadAppOpenAd({bool isColdStart = false}) {
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

          // Show right when the app opens on cold start
          if (!_hasShownColdStartAppOpen &&
              DateTime.now().difference(_appStartTime).inSeconds < 15 &&
              !_isShowingInterstitialAd) {
            _hasShownColdStartAppOpen = true;
            debugPrint('🚀 [AdMob] Displaying App Open ad right on cold start.');
            showAppOpenAdIfAvailable();
          }
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
    if (!adsEnabled.value || _isShowingAppOpenAd || _isShowingInterstitialAd) return;

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

  /// Clears active failure cooldowns, refreshes ad units from API, and triggers a reload event for all listening banner widgets.
  static void clearCooldownsAndRequestRefresh() {
    debugPrint('🔄 [AdMob] Pull-to-refresh: clearing ad unit cooldowns, fetching latest ad units, and triggering banner retry.');
    _adUnitCooldowns.clear();
    fetchRemoteAdUnits();
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
