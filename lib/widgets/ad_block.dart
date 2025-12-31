import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdBlock extends StatelessWidget {
  const AdBlock(
      {super.key, required BannerAd? bannerAd, required this.isbottom})
      : _bannerAd = bannerAd;
  final bool isbottom;
  final BannerAd? _bannerAd;

  @override
  Widget build(BuildContext context) {
    // double pad = isbottom ? 90.0 : 0.0;
    // if(_bannerAd == null){
    return SizedBox.shrink();
    // I/flutter (16161): │ 🐛 {
    // I/flutter (16161): │ 🐛   "first_name": "Abel",
    // I/flutter (16161): │ 🐛   "last_name": "Seyoum",
    // I/flutter (16161): │ 🐛   "email": "nadgohbj@gmail.com",
    // I/flutter (16161): │ 🐛   "grade_id": "2",
    // I/flutter (16161): │ 🐛   "phone": "954070484",
    // I/flutter (16161): │ 🐛   "password": "12345678"
    // I/flutter (16161): │ 🐛 }

    // }
    // return Padding(
    //   padding: EdgeInsets.only(bottom: pad),
    //   child: Align(
    //       alignment: Alignment.topCenter,
    //       child: SafeArea(
    //           child: SizedBox(
    //               width: _bannerAd!.size.width.toDouble(),
    //               height: _bannerAd!.size.height.toDouble(),
    //               child: AdWidget(ad: _bannerAd!)
    //           )
    //       )
    //   ),
    // );
  }
}
