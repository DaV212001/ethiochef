import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ethio_chef/widgets/screen_head.dart';

import '../../../models/promotion.dart';
import '../../../theme/app_theme.dart';
import '../../../widgets/cached_image.dart';
import '../../../widgets/home/ad_carousel_component.dart';

class AdsCarousel extends StatefulWidget {
  final List<Promotion> promotion;
  const AdsCarousel({super.key, required this.promotion});

  @override
  State<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {
  bool? fetched;
  @override
  void initState() {
    //fetchImages();;
    super.initState;
  }

  // List<PhotosModel> images = [];

  // Future<void> fetchImages() async {
  //   try {
  //     final AdsService service = AdsService();
  //     final data = await service.getApiImage();
  //     setState(() {
  //       fetched = true;
  //       images = data;
  //     });
  //   } catch (error) {
  //     print('Error: $error');
  //   }
  // }
  List imageList = [
    {"id": 1, "image_path": 'assets/images/photo_1.jpg'},
    {"id": 2, "image_path": 'assets/images/photo_2.jpg'},
    {"id": 3, "image_path": 'assets/images/photo_3.jpg'}
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      color: Colors.black,
      child: Column(children: [
        Stack(
          children: [
            InkWell(
              onTap: () {
                print(currentIndex);
              },
              child: CarouselSlider(
                items: [
                  Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/ads_one.jpg"),
                            fit: BoxFit.cover,
                          ),

                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 75,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            boxShadow: [
                              // BoxShadow(
                              //   color: Colors.black,
                              //   offset: Offset(0, 40),
                              //   blurRadius: 20
                              // ),
                            ],),
                          child: SizedBox()
                        ),
                      ),
                    ],
                  ), Stack(
                    fit: StackFit.expand,
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          image: DecorationImage(
                            image: AssetImage("assets/images/ads_two.jpg"),
                            fit: BoxFit.cover,
                          ),

                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: 75,
                          decoration: BoxDecoration(
                            boxShadow: [
                              // BoxShadow(
                              //   color: Colors.black,
                              //   offset: Offset(0, 40),
                              //     blurRadius: 10,
                              // ),
                            ],),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [

                            ],
                          ),
                        ),
                      ),
                    ],
                  ),Stack(
                      fit: StackFit.expand,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/ads_three.jpg"),
                              fit: BoxFit.cover,
                            ),

                          ),
                        ),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            height: 75,
                            decoration: BoxDecoration(
                              boxShadow: [
                                // BoxShadow(
                                //   color: Colors.black,
                                //   offset: Offset(0, 40),
                                //   blurRadius: 10,
                                // ),
                              ],),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [

                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                ],
                carouselController: carouselController,
                options: CarouselOptions(
                  scrollPhysics: const BouncingScrollPhysics(),
                  autoPlay: true,
                  aspectRatio: 2,
                  viewportFraction: 1,
                  onPageChanged: (index, reason) {
                    setState(() {
                      currentIndex = index;
                    });
                  },
                ),
              ),
            ),
            Positioned(
                bottom: 10,
                right: 0,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 17),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: imageList.asMap().entries.map((entry) {
                          return GestureDetector(
                            onTap: () =>
                                carouselController.animateToPage(entry.key),
                            child: Container(
                              width: currentIndex == entry.key ? 17 : 7,
                              height: 7.0,
                              margin: const EdgeInsets.symmetric(
                                horizontal: 3.0,
                              ),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: currentIndex == entry.key
                                      ? theme.colorScheme.primary
                                      : theme.colorScheme.primaryContainer),
                            ),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                ))
          ],
        ),
        ScreenHead(
          hasNotification: true,
          screen: 0,
          searchHint: "search".tr(),
        )
      ]),
    );
  }
}
