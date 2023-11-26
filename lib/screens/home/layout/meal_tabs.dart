import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/screen_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../models/food.dart';
import '../../../services/meal_service.dart';
import '../../../widgets/category/food_card.dart';
import '../../../widgets/info_card.dart';


class MealTab extends StatefulWidget {
  List<Food> breakfast;
  List<Food> lunch;
  List<Food> superMeal;
  List<Food> dinner;
  MealTab({super.key,
    required this.breakfast,
    required this.lunch,
    required this.superMeal,
    required this.dinner
  });

  @override
  State<MealTab> createState() => _MealTabState();
}

class _MealTabState extends State<MealTab> {

  Future? _future;


  Future<dynamic> fetchSubCatData() async {
    try {
      print('subCategoryService');



    } catch (error) {
      rethrow;
    }
  }
  @override
  void initState() {
    // _future = fetchSubCatData();
    print("=============================================================================");
    print("=============================================================================");
    print("=============================================================================");
    print("=============================================================================");
    print(widget.breakfast[0].name);
    print(widget.lunch[0].name);
    print(widget.superMeal[0].name);
    print(widget.dinner[0].name);
    print("=============================================================================");
    print("=============================================================================");
    print("=============================================================================");
    print("=============================================================================");
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
          physics: NeverScrollableScrollPhysics(),
          child: DefaultTabController(
            length: 4,
            child: Column(children: [
              ButtonsTabBar(
                backgroundColor: theme.colorScheme.primary,
                unselectedBackgroundColor: Colors.transparent,
                unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: theme.colorScheme.tertiary
                ),
                labelStyle: theme.textTheme.bodyMedium
                    ?.copyWith(color: theme.colorScheme.onTertiary),
                contentPadding: EdgeInsets.symmetric(horizontal: 10),
                radius: 1,
                tabs: [
                  Tab(text: "Breakfast"),
                  Tab(text: "Lunch"),
                  Tab(text: "Super"),
                  Tab(text: "Dinner")
                ],
                onTap: (index){
                  print(index);
                },
              ),
              SizedBox(
                  height: 130.h,
                  child: TabBarView(children:[
                    for(int i=0;i<4;i++)
                      ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        itemCount: i==0? widget.breakfast.length:
                        i==1? widget.lunch.length:
                        i==2? widget.superMeal.length:
                        widget.dinner.length,
                        itemBuilder: (context, index) {
                          return Container(
                              child: i == 0?
                              InkWell(
                                onTap: (){
                                  print(widget.breakfast[index].name);
                                  // pushNewScreen(
                                  //   context,
                                  //   withNavBar: false,
                                  //   screen: HomeFoodList(subCategory: subCategory[index]),
                                  // );
                                },
                                child: Card(
                                  child: Container(
                                    height: 75,
                                    padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                    decoration: BoxDecoration(
                                        color: theme.colorScheme.onSecondaryContainer.withOpacity(0.7)),
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        SizedBox(height: 5),
                                        Text(
                                          widget.breakfast[index].name??"",
                                          style: theme.textTheme.headlineSmall?.copyWith(
                                              color: theme.colorScheme.onTertiary,
                                              fontWeight: FontWeight.w500),
                                          textAlign: TextAlign.start,
                                        ),
                                        SizedBox(
                                          height: 5.h,
                                        ),
                                        // CategoryLabelCarousel(categories: widget.food.menuTimes)
                                      ],
                                    ),
                                  ),
                                ),
                              ):i == 1?
                              Card(
                                child: Container(
                                  height: 75,
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: theme.colorScheme.onSecondaryContainer.withOpacity(0.7)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        widget.lunch[index].name??"",
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                            color: theme.colorScheme.onTertiary,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      // CategoryLabelCarousel(categories: widget.food.menuTimes)
                                    ],
                                  ),
                                ),
                              ):i == 2?
                              Card(
                                child: Container(
                                  height: 75,
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: theme.colorScheme.onSecondaryContainer.withOpacity(0.7)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        widget.superMeal[index].name??"",
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                            color: theme.colorScheme.onTertiary,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      // CategoryLabelCarousel(categories: widget.food.menuTimes)
                                    ],
                                  ),
                                ),
                              ):
                              Card(
                                child: Container(
                                  height: 75,
                                  padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                                  decoration: BoxDecoration(
                                      color: theme.colorScheme.primary.withOpacity(0.7)),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      SizedBox(height: 5),
                                      Text(
                                        widget.dinner[index].name??"",
                                        style: theme.textTheme.headlineSmall?.copyWith(
                                            color: theme.colorScheme.onTertiary,
                                            fontWeight: FontWeight.w500),
                                        textAlign: TextAlign.start,
                                      ),
                                      SizedBox(
                                        height: 5.h,
                                      ),
                                      // CategoryLabelCarousel(categories: widget.food.menuTimes)
                                    ],
                                  ),
                                ),
                              )
                          );
                        },)
                  ]
                  )),
            ]),
          )),
    );
  }


// Widget buildCategoryScreen(List<SubCategory> subCategory, List<Food> food){
//   ThemeData theme = Theme.of(context);
//   List<Tab> tabs = subCategory
//       .map((e) =>
//       Tab(
//           text: e.name
//       ))
//       .toList();
//   return SafeArea(
//     child: SingleChildScrollView(
//         physics: NeverScrollableScrollPhysics(),
//         child: DefaultTabController(
//           length: tabs.length,
//           child: Column(children: [
//             ScreenHead(
//               hasNotification: true,
//               screen: 1,
//               searchHint: "search_for_category".tr(),
//             ),
//             ButtonsTabBar(
//               backgroundColor: theme.colorScheme.primary,
//               unselectedBackgroundColor: Colors.transparent,
//               unselectedLabelStyle: theme.textTheme.labelMedium?.copyWith(
//                   color: theme.colorScheme.tertiary
//               ),
//               labelStyle: theme.textTheme.bodyMedium
//                   ?.copyWith(color: theme.colorScheme.onTertiary),
//               contentPadding: EdgeInsets.symmetric(horizontal: 10),
//               radius: 1,
//               tabs: tabs,
//               onTap: (index){
//                 print(index);
//                 print(PlaceHolderData.foodCompetitionList[index].name);
//                 print(PlaceHolderData.foodCompetitionList[index].daysLeft);
//               },
//             ),
//             SizedBox(
//                 height: 930.h,
//                 child: TabBarView(children:[
//                   for(int i=0;i<tabs.length;i++)
//                     ListView.builder(
//                       shrinkWrap: true,
//                       itemCount: food.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           child: PlaceHolderData.foodCompetitionList[i].daysLeft == food[index].subcategoriesId?
//                           Column(
//                             children: [
//                               Text(food[index].name),
//                               Text(food[index].id.toString()),
//                               Text(food[index].subcategoriesId.toString()),
//                             ],
//                           ):SizedBox.shrink(),
//                         );
//                       },)
//                 ]
//                 )),
//           ]),
//         )),
//   );
// }GestureDetector(
//                             onTap: () {
//                               // pushNewScreenWithRouteSettings(
//                               //     context,
//                               //     withNavBar: false,
//                               //     settings: RouteSettings(name: "/recipe"),
//                               //     screen: RecipeScreen(food: widget.food)
//                               // );
//                             },
//                             child: Card(
//                               child: Stack(
//                                 fit: StackFit.expand,
//                                 children: [
//                                   // ClipRRect(
//                                   //   borderRadius: AppTheme.allBorderRadius,
//                                   //   child: CachedImage(url: temporary.image!, fit: BoxFit.fill),
//                                   // ),
//                                   // Image.network(widget.breakfast[index].image!, fit: BoxFit.fill),
//                                   Positioned(
//                                     bottom: 0,
//                                     left: 0,
//                                     right: 0,
//                                     child: Container(
//                                       height: 75,
//                                       padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
//                                       decoration: BoxDecoration(
//                                           color: theme.colorScheme.onSecondaryContainer.withOpacity(0.7)),
//                                       child: Column(
//                                         crossAxisAlignment: CrossAxisAlignment.start,
//                                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                                         children: [
//                                           SizedBox(height: 5),
//                                           Text(
//                                             widget.breakfast[index].name??"",
//                                             style: theme.textTheme.headlineSmall?.copyWith(
//                                                 color: theme.colorScheme.onTertiary,
//                                                 fontWeight: FontWeight.w500),
//                                             textAlign: TextAlign.start,
//                                           ),
//                                           SizedBox(
//                                             height: 5.h,
//                                           ),
//                                           // CategoryLabelCarousel(categories: widget.food.menuTimes)
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 ],
//                               ),
//                             ),
//                           )

}
