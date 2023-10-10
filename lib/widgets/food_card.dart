import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:ethio_chef/widgets/small_label_button.dart';
import 'package:flutter/material.dart';

class FoodCard extends StatelessWidget {
  static int foodCardType = 1;
  final Food food;

  const FoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              height: 150,
              child: ClipRRect(
                borderRadius: AppTheme.topBorderRadius,
                child: CachedImage(
                  url: food.thumbnail,
                  fit: BoxFit.fill,
                ),
              )),
          const SizedBox(
            height: 5,
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                food.name,
                style: theme.textTheme.headlineMedium,
                textAlign: TextAlign.start,
              ),
            ),
          ),
          buildRow(food.menuTimes),
          buildRow(food.categories),
          SizedBox(height: 5,)
        ],
      ),
    );
  }

  Widget buildRow(List<Category> row) {
    List<SmallLabelButton> labels =
    row.map((e) => SmallLabelButton(text: e.name, onTap: () {})).toList();
    return Expanded(
      child: Container(
        alignment: Alignment.centerLeft,
        child: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          children: List.generate(
            labels.length,
                (index) => Row(
              children: [
                if (index < labels.length) SizedBox(width: 5.0),
                labels[index],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
