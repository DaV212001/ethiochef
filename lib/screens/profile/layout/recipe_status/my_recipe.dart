import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/recipe.dart';
import 'package:ethio_chef/screens/profile/layout/recipe_status/recipe_description.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../../widgets/profile/recipe_card.dart';
import '../../../upload_recipe/upload_recipe_screen.dart';

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
      body:  Recipe.savedRecipes.length == 0?Center(
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
                screen: RecipeDescription(res: resp),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            child: RecipeCard(
              recipe: resp,
              name: resp.name.toString(),
              imageUrl: resp.image,
            ),
          );
        },),
      floatingActionButton: FloatingActionButton(
        backgroundColor:  theme.colorScheme.primary,
          onPressed: () {
            pushNewScreen(context,
                screen: UploadRecipeScreen(type: "recipe"), withNavBar: false);
          },
        child: Icon(
          Icons.add,
          color:Colors.white
        ),
      ),
    );
  }
}
/*
* Column(
          children: [
            GestureDetector(

            ),
            Text(resp.name.toString()),
            Text(resp.description.toString()),
            Text(resp.prepTime.toString()),
            Text(resp.servingSize.toString()),
            ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                itemCount: resp.steps?.length,
                itemBuilder: (context, index){
                  return Column(
                    children: [
                      Text(resp.steps![index].toString()),
                    ],
                  );
                }
            ),
            ListView.builder(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
              shrinkWrap: true,
                itemCount: resp.ingredient?.length,
                itemBuilder: (context, index){
                var ing = resp.ingredient![index];
                return Column(
                  children: [
                    Text(ing['ingredient'].toString()),
                    Text(ing['quantity'].toString()),
                  ],
                );
                }
            ),

            Text("==============================="),
            SizedBox(height: 50,)
          ],
        )
* */