import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/material.dart';

class ImageHeadFoodCard extends StatelessWidget {
  static int foodCardType = 3;
  final Food food;

  const ImageHeadFoodCard({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        borderRadius: AppTheme.allBorderRadius,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Container(
              width: double.infinity,
              height: 150,
              padding: EdgeInsets.all(5),
              child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                child: CachedImage(
                  url: food.thumbnail,
                  fit: BoxFit.fill,
                ),
              )),
          SizedBox(
            height: 2,
          ),
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              food.name,
              style: TextStyle(
                color: theme.colorScheme.tertiary,
                fontWeight: FontWeight.bold,
                fontSize: 14
              ),
              textAlign: TextAlign.start,
            ),
          ),
        ],
      ),
    );
  }
}
