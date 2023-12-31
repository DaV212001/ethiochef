import 'dart:async';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/profile/saved_recipe_desc.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../models/food.dart';
import '../../../models/language.dart';
import 'dart:io';

import '../../../widgets/profile/my_recipe_card.dart';

class SavedRecipe extends StatefulWidget {
  const SavedRecipe({super.key});

  @override
  State<SavedRecipe> createState() => _SavedRecipeState();
}

class _SavedRecipeState extends State<SavedRecipe> {
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
                child: Text('no_saved_recipes', style: TextStyle(
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
                      screen: SavedRecipeDescription(food: resp),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  child: SavedRecipeCard(
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











