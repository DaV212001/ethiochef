
import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/submitted_recipe.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/cached_image.dart';
import '../../../widgets/youtube_video_player.dart';
import '../../recipe/layout/recipe_header.dart';
import '../../recipe/layout/recipe_tabs.dart';

class SubmittedDescription extends StatefulWidget {
  final MySubmittedRecipe recipe;
  const SubmittedDescription({super.key, required this.recipe});

  @override
  State<SubmittedDescription> createState() => _SubmittedDescriptionState();
}

class _SubmittedDescriptionState extends State<SubmittedDescription> with SingleTickerProviderStateMixin{


  @override
  void initState() {
    super.initState();
  }


  bool showAddRecipeCard = true;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context){
    ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
      body: SafeArea(

        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Stack(children: [
                  SizedBox(
                    width: width,
                    height: height * 0.4,
                    child: CachedImage(url: widget.recipe.image, fit: BoxFit.fill),
                  ),
                  Positioned(
                    top: 5,
                    right: 10,
                    left: 10,
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: circularBackground(
                                child: Icon(
                                  Icons.arrow_back,
                                  color: theme.colorScheme.onSecondary,
                                ),
                              )),
                        ],
                      ),
                    ),
                  )
                ]),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    widget.recipe.title,
                    style: TextStyle(
                        fontSize: isTablet ? 15.sp : 20.sp,
                        fontWeight: FontWeight.w300,
                        color: theme.colorScheme.secondaryContainer),
                  ),
                ),Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "dish_description".tr(),
                    style: TextStyle(
                        fontSize: isTablet ? 15.sp : 20.sp,
                        fontWeight: FontWeight.w800,
                        color: theme.colorScheme.secondaryContainer),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    widget.recipe.description!,
                    style: TextStyle(
                        fontSize: isTablet ? 15.sp : 20.sp,
                        fontWeight: FontWeight.w300,
                        color: theme.colorScheme.onTertiary),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: DefaultTabController(
                    length: 2,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        ButtonsTabBar(
                          onTap: (index) {
                            setState(() {
                              selectedIndex = index;
                            });
                          },
                          unselectedBorderColor: Colors.transparent,
                          backgroundColor: theme.colorScheme.primary,
                          unselectedBackgroundColor: Colors.transparent,
                          unselectedLabelStyle:  TextStyle(
                              fontSize: isTablet ? 11.sp : 15.sp,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.onTertiary),
                          labelStyle:  TextStyle(
                              fontSize: isTablet ? 11.sp : 15.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.secondary),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                          radius: 2,
                          tabs: [
                            Tab(
                                text: "ingredients".tr()
                            ),
                            Tab(
                                text: "steps".tr()
                            )
                          ],
                        ),
                        Container(
                            height: 300,
                            child: selectedIndex == 0 ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: 1,
                              physics: BouncingScrollPhysics(),
                              scrollDirection: Axis.vertical,
                              itemBuilder: (context, index) {
                                index++;
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: widget.recipe.ingredients!.entries.map((ingredient) {
                                    return Flex(
                                      direction: Axis.vertical,
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${index++}. ${ingredient.value}",
                                          softWrap: true,
                                          overflow: TextOverflow.visible,
                                          style: TextStyle(
                                              fontSize: isTablet ? 15.sp : 19.sp,
                                              fontWeight: FontWeight.w600,
                                              color: theme.colorScheme.secondaryContainer),
                                        ),
                                        SizedBox(height: 10)
                                      ],
                                    );
                                  }).toList(),
                                );
                              },): ListView.builder(
                                shrinkWrap: true,
                                itemCount: 1,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  index++;
                                  return Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      children: widget.recipe.steps!.entries.map((step) {
                                        return Flex(
                                            direction: Axis.vertical,
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.start,
                                            children: [
                                              const SizedBox(width: 8.0),
                                              Text(
                                                "${index++}. ${step.value}",
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                                style: TextStyle(
                                                    fontSize: isTablet ? 15.sp : 19.sp,
                                                    fontWeight: FontWeight.w600,
                                                    color: theme.colorScheme.secondaryContainer),
                                              ),
                                              SizedBox(height: 10)
                                            ]
                                        );
                                      }).toList()
                                  );
                                })
                        )
                      ],
                    ),
                  ),
                )

              ],
            )
        ),
      ),
    );
  }
  Widget circularBackground({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: Theme.of(context).colorScheme.onPrimary),
      child: child,
    );
  }
}
