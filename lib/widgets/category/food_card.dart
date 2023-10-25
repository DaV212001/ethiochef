import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/recipe_screen.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:ethio_chef/widgets/small_label_button.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class FoodCard extends StatefulWidget {
  static int foodCardType = 1;
  final Food food;

  const FoodCard({super.key, required this.food});

  @override
  State<FoodCard> createState() => _FoodCardState();
}

class _FoodCardState extends State<FoodCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          withNavBar: false,
          screen: RecipeScreen(food: widget.food),
        );
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(color: theme.colorScheme.surface),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                widget.food.name,
                style: theme.textTheme.headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w500),
                textAlign: TextAlign.start,
              ),
            ),
            if (widget.food.description != null)
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  _getTrimmedDescription(),
                  style: theme.textTheme.bodyMedium,
                ),
              ),
            Container(
                width: double.infinity,
                height: 250,
                child: CachedImage(
                  url: widget.food.thumbnail,
                  fit: BoxFit.fill,
                )),
            const SizedBox(
              height: 5,
            ),
            buildRow(widget.food.menuTimes),
            buildRow(widget.food.categories)
          ],
        ),
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

  String _getTrimmedDescription() {
    if (widget.food.description!.length <= 150) {
      return widget.food.description!;
    }
    return widget.food.description!.substring(0, 150) + "... ";
  }
}
