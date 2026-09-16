import 'package:carousel_slider/carousel_slider.dart' as c;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/promotion.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/cached_image.dart';

class SecondAdsCarousel extends StatefulWidget {
  final List<Promotion> promotion;
  const SecondAdsCarousel({super.key, required this.promotion});

  @override
  State<SecondAdsCarousel> createState() => _SecondAdsCarouselState();
}

class _SecondAdsCarouselState extends State<SecondAdsCarousel> {
  final c.CarouselSliderController carouselController =
      c.CarouselSliderController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.promotion.isEmpty) return const SizedBox.shrink();

    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);

    return Container(
      margin: EdgeInsets.symmetric(vertical: 10.h),
      child: Column(
        children: [
          c.CarouselSlider(
            items: widget.promotion.map((promotion) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: CachedImage(
                        url: promotion.image,
                        fit: BoxFit.cover,
                      ),
                    ),
                  );
                },
              );
            }).toList(),
            carouselController: carouselController,
            options: c.CarouselOptions(
              scrollPhysics: const BouncingScrollPhysics(),
              autoPlay: true,
              aspectRatio: 2.5,
              viewportFraction: 0.9,
              onPageChanged: (index, reason) {
                setState(() {
                  currentIndex = index;
                });
              },
            ),
          ),
          SizedBox(height: 10.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.promotion.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => carouselController.animateToPage(entry.key),
                child: Container(
                  width: currentIndex == entry.key ? 18 : 7,
                  height: 7.0,
                  margin: const EdgeInsets.symmetric(horizontal: 3.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: currentIndex == entry.key
                        ? theme.colorScheme.primary
                        : theme.colorScheme.primary.withOpacity(0.3),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
