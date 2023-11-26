import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class RecipeSteps extends StatelessWidget {
  final Map<String, dynamic> steps;

  const RecipeSteps({Key? key, required this.steps}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Column(
        children: steps!.entries.map((ingredient) {
          return Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(ingredient.key),
                  const SizedBox(height: 8.0),
                  Text(ingredient.value),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}