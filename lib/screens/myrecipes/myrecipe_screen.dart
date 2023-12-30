import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../models/food.dart';
import '../../models/language.dart';
import '../../utils/screen_utils.dart';
import 'dart:io';

import '../../widgets/cached_image.dart';
import '../../widgets/main_button.dart';
import '../recipe/layout/recipe_header.dart';
import '../recipe/layout/recipe_tabs.dart';
import '../recipe/recipe_screen.dart';

class RecipeMine extends StatefulWidget {
  const RecipeMine({super.key});

  @override
  State<RecipeMine> createState() => _RecipeMineState();
}

class _RecipeMineState extends State<RecipeMine> {
  bool isLoading = true;

  late Timer timer;
  void getRecipes() async {
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (!mounted) {
        timer.cancel();
        // Stop the timer if the widget is not mounted
        return;
      }
      Food.savedRecipes = await Food.loadRecipesFromSharedPrefs();
      setState(() {
        isLoading = false;
      });
      // if(Food.savedRecipes.length == 0){
      //   setState(() {
      //     isLoading = true;
      //   });
      // }
    });


  }

  @override
  void initState() {
    getRecipes();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("saved_recipes".tr(),style: TextStyle(
            color: theme.colorScheme.primary
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: theme.colorScheme.primary,
            )),
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            isLoading ==true?
            Center(
                child: CircularProgressIndicator()
            ):
            Food.savedRecipes.length == 0?
              Center(
                child: Text('No Saved Recipes', style: TextStyle(
                    color: Colors.black
                )),
              ): ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: Food.savedRecipes.length,
              itemBuilder: (BuildContext context, int index) {
                var resp = Food.savedRecipes[index];
                return GestureDetector(
                  onTap: (){
                    print("tap");
                    pushNewScreen(
                      context,
                      screen: MyRecipeScreen(food: resp),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  child: MyRecipeCard(
                    recipe: resp,
                    name: resp.name[Language.getLocaleCode()].toString(),
                    imageUrl: File(resp.thumbnail),
                  ),
                );
              },)
          ],
        ),
      ),
    );
  }
}





class MyRecipeScreen extends StatefulWidget {
  final Food food;
  const MyRecipeScreen({super.key, required this.food});

  @override
  State<MyRecipeScreen> createState() => _MyRecipeScreenState();
}

class _MyRecipeScreenState extends State<MyRecipeScreen> {


  Widget circularBackground({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: Theme.of(context).colorScheme.onPrimary),
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: width,
                      height: height * 0.4,
                      child: CachedImage(url: widget.food.thumbnail, fit: BoxFit.fill),
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
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
                                ),
                              ),
                            ]
                        ),
                      ),
                    ),
                  ],
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      RecipeHeader(
                        food: widget.food,
                      ),
                      SizedBox(height: 10),
                      RecipeScreenTab(
                        food: widget.food,
                      ),

              ],
            )
        ),]
      )
      )
      ),
    );
  }
}






class MyRecipeCard extends StatelessWidget {
  Food recipe;
  String name;
  File? imageUrl;
  MyRecipeCard({super.key,
    required this.recipe,
    required this.name,
    required this.imageUrl
  });

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    print('CHECKING IMAGE: ${recipe.thumbnail}');
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 10.w : 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 5.h),
          //   child: Text(
          //     DateFormat('yyyy-MM-dd HH:mm').format(widget.order.date!),
          //     style: TextStyle(fontSize: 12.sp),
          //   ),
          // ),
          Card(
            elevation: 3,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                          name!,
                          style: TextStyle(
                              fontSize: isTablet ? 12.sp : 14.sp,
                              fontWeight: FontWeight.bold),
                        )),
                    Center(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r)),
                          child: SizedBox(
                            height: isTablet ? 80.h : 100.h,
                            width: isTablet ? 85.w : 110.w,
                            child: Image.network(
                              recipe.thumbnail,
                              fit: BoxFit.fill,
                            ),
                          )),
                    )
                  ]),
            ),
          ),

          MainButton(
            text: 'Delete',
            onPress: () async {
              Food.deleteRecipe(recipe);
              Food.savedRecipes = await Food.loadRecipesFromSharedPrefs();
            },
          ),
        ],
      ),
    );
  }

}

