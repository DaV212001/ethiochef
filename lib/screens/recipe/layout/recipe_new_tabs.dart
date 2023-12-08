import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:flutter/material.dart';
import 'package:vertical_scrollable_tabview/vertical_scrollable_tabview.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../../models/category.dart';
import '../../../widgets/svg_icon.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    List<String> items = [
      "Ingredients",
      "Steps"
    ];

    List<dynamic> icons = [
      'assets/images/icons/ingredients.svg',
      'assets/images/icons/food_menu.svg',
    ];
    int current = 0;
    PageController pageController = PageController();
    return Column(
      children: [
        /// Tab Bar
        SizedBox(
          width: double.infinity,
          height: 90,
          child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: items.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (ctx, index) {
                return Column(
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          current = index;
                        });
                        pageController.animateToPage(
                          current,
                          duration: const Duration(milliseconds: 200),
                          curve: Curves.ease,
                        );
                      },
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.all(5),
                        width: 100,
                        height: 55,
                        decoration: BoxDecoration(
                          color: current == index
                              ? Colors.white70
                              : Colors.white54,
                          borderRadius: current == index
                              ? BorderRadius.circular(12)
                              : BorderRadius.circular(7),
                          border: current == index
                              ? Border.all(
                              color: Colors.deepPurpleAccent,
                              width: 2.5)
                              : null,
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgIcon(
                                image: icons[current],
                                color: theme.primaryColor,
                              ),
                              Text(
                                items[current],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: current == index,
                      child: Container(
                        width: 5,
                        height: 5,
                        decoration: const BoxDecoration(
                            color: Colors.deepPurpleAccent,
                            shape: BoxShape.circle),
                      ),
                    )
                  ],
                );
              }),
        ),
        Container(
          margin: const EdgeInsets.only(top: 30),
          width: double.infinity,
          height: 150,
          child: PageView.builder(
            scrollDirection: Axis.vertical,
            itemCount: icons.length,
            controller: pageController,
            physics: const BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgIcon(
                    image: icons[current],
                    color: theme.primaryColor,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                      "${items[current]} Tab Content"
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
// class ResizableTabs extends StatelessWidget {
//   final String title;
//   final int count;
//   const ResizableTabs({super.key, required this.title, required this.count});
//
//   @override
//   Widget build(BuildContext context) {
//     return ListView.builder(
//       shrinkWrap: true,
//       scrollDirection: Axis.vertical,
//       physics: BouncingScrollPhysics(),
//       itemCount: count,
//       itemExtent: 255,
//       itemBuilder: (BuildContext context, int index) {
//         return Ink(
//           child: InkWell(
//             onTap: () {
//             },
//             child: Text("$title  $count"),
//           ),
//         );
//       },
//     );;
//   }
// }
