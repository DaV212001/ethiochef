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

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (!AdService.to.adsEnabled.value) return;

    _bannerAd = AdService.createBannerAd(
      position: widget.position,
      onAdLoaded: (ad) {
        if (mounted) {
          setState(() {
            _isLoaded = true;
          });
        }
      },
      onFailed: (error) {
        if (mounted) {
          setState(() {
            _isLoaded = false;
          });
        }
      },
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null) return const SizedBox.shrink();
    if (!AdService.to.adsEnabled.value) return const SizedBox.shrink();

    return AdBlock(bannerAd: _bannerAd, isbottom: widget.isBottom);
  }
}
