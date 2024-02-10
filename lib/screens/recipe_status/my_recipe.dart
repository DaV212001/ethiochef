import 'dart:async';

import 'package:easy_localization/easy_localization.dart';

import 'package:ethio_chef/screens/recipe_status/layout/recipe_description.dart';import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../widgets/profile/recipe_card.dart';
import '../../models/recipe.dart';
import '../upload_recipe/upload_recipe_screen.dart';
import 'my_submitted_recipe.dart';

class MyRecipes extends StatefulWidget {
  const MyRecipes({super.key});

  @override
  State<MyRecipes> createState() => _MyRecipesState();
}

class _MyRecipesState extends State<MyRecipes> {
  bool isLoading = true;

  late Timer timer;
  void getRecipes() async {
    timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
      if (!mounted) {
        timer.cancel();
        // Stop the timer if the widget is not mounted
        return;
      }
      Recipe.savedRecipes = await Recipe.loadRecipesFromSharedPrefs();
      setState(() {
        isLoading = false;
      });
      if(Recipe.savedRecipes.length == 0){
        setState(() {
          isLoading = true;
        });
      }
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
        title: Text("my_recipes".tr(),style: TextStyle(
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
            Align(
              alignment: Alignment.topRight,
              child: TextButton(
                child: Text(
                    'submitted_recipes'.tr()
                ),
                onPressed: (){

                  pushNewScreen(
                    context,
                    screen: SubmittedRecipe(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                },
              ),
            ),
            Recipe.savedRecipes.length == 0?Center(
              child: Column(
                children: [
                  Text("submit_a_recipe".tr())
                ],
              ),
            ):isLoading ==true?
            Center(
                child: CircularProgressIndicator()
            ):
            ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: Recipe.savedRecipes.length,
              itemBuilder: (BuildContext context, int index) {
                var resp = Recipe.savedRecipes[index];
                return GestureDetector(
                  onTap: (){
                    print("tap");
                    pushNewScreen(
                      context,
                      screen: RecipeDescription(myRecipe: resp),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  child:
                  RecipeCard(
                    recipe: resp,
                    name: resp.name.toString(),
                    imageUrl: resp.image,
                  ),
                );
              },)
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor:  theme.colorScheme.primary,
          onPressed: () {
            pushNewScreen(context,
                screen: UploadRecipeScreen(), withNavBar: false);
          },
        child: Icon(
          Icons.add,
          color:Colors.white
        ),
      ),
    );
  }
}