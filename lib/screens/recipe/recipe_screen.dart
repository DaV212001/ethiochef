import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header_image.dart';
import 'package:flutter/material.dart';

class RecipeScreen extends StatelessWidget {
  final Food food;

  const RecipeScreen({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RecipeHeaderImage(
              image: food.thumbnail,
              isFavorite: food.isSaved,
              onFavorite: () {},
            ),
            RecipeHeader(food: food,),
          ],
        ),
      ),
    );
  }


}
