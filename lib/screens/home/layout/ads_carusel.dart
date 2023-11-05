import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

import '../../../widgets/home/ad_carousel_component.dart';

class AdsCarousel extends StatefulWidget {
  const AdsCarousel({super.key});

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
    {"id": 1, "image_path": 'assets/images/logo.png'},
    {"id": 2, "image_path": 'assets/images/two.png'},
    {"id": 3, "image_path": 'assets/images/three.png'}
  ];

  final CarouselController carouselController = CarouselController();
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(children: [
      Stack(
        children: [
          InkWell(
            onTap: () {
              print(currentIndex);
            },
            child: CarouselSlider(
              items: [
                Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/logo.png"),
                            fit: BoxFit.fill)),
                    child:AdCarouselComponent(
                        label: '',
                        description: ''
                    )
                ),
                Container(
                  decoration: const BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage("assets/images/two.png"),
                          fit: BoxFit.fill)),
                  child: AdCarouselComponent(
                      label: '',
                      description: ''
                  ),

                ),
                Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                            image:
                            AssetImage("assets/images/three.png"),
                            fit: BoxFit.fill)),
                    child:  AdCarouselComponent(
                        label: '',
                        description: ''
                    ))
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
    ]);
  }
}
