import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../services/ad_service.dart';
import 'ad_block.dart';

/// A self-contained Banner Ad widget that manages its own lifecycle.
/// Suitable for recurring in-feed, in-list, or in-grid banner ads.
class InlineBannerAd extends StatefulWidget {
  final BannerPosition position;
  final bool isBottom;

  const InlineBannerAd({
    super.key,
    this.position = BannerPosition.middle,
    this.isBottom = false,
  });

  @override
  State<InlineBannerAd> createState() => _InlineBannerAdState();
}

class _InlineBannerAdState extends State<InlineBannerAd> {
  BannerAd? _bannerAd;
  bool _isLoaded = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    AdService.refreshNotifier.addListener(_onRefreshRequested);
    _loadAd();
  }

  void _onRefreshRequested() {
    if (!mounted) return;
    // Only reload if the banner is not already loaded and is not currently in flight
    if (!_isLoaded && _bannerAd == null && !_isLoading) {
      _loadAd();
    }
  }

  void _loadAd() {
    if (!AdService.to.adsEnabled.value) return;
    _isLoading = true;

    AdService.loadBannerSequentially(
      position: widget.position,
      isMounted: () => mounted,
      onLoaded: (ad) {
        _isLoading = false;
        if (mounted) {
          setState(() {
            _bannerAd = ad;
            _isLoaded = true;
          });
        } else {
          ad.dispose();
        }
      },
      onFailed: (error) {
        _isLoading = false;
        if (mounted) {
          setState(() {
            _isLoaded = false;
          });
        }
      },
    );
  }

  @override
  void dispose() {
    AdService.refreshNotifier.removeListener(_onRefreshRequested);
    _bannerAd?.dispose();
    _bannerAd = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) return const SizedBox.shrink();
    if (!AdService.to.adsEnabled.value) return const SizedBox.shrink();

    return AdBlock(bannerAd: _bannerAd, isbottom: widget.isBottom);
  }
}
