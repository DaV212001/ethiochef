import 'package:flutter/material.dart';

import '../../../models/food.dart';

import '../../../widgets/cached_image.dart';
import '../../screens/recipe/layout/recipe_header.dart';
import '../../screens/recipe/layout/recipe_tabs.dart';

class SavedRecipeDescription extends StatefulWidget {
  final Food food;
  const SavedRecipeDescription({super.key, required this.food});

  @override
  State<SavedRecipeDescription> createState() => _SavedRecipeDescriptionState();
}

class _SavedRecipeDescriptionState extends State<SavedRecipeDescription> {


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