import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:ethio_chef/widgets/small_label_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImageFoodCard extends StatefulWidget {
  static int foodCardType = 2;
  final Food food;

  const ImageFoodCard({super.key, required this.food});

  @override
  State<ImageFoodCard> createState() => _ImageFoodCardState();
}

class _ImageFoodCardState extends State<ImageFoodCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Card(
      child: Stack(
        fit: StackFit.expand,
        children: [
          ClipRRect(
            borderRadius: AppTheme.allBorderRadius,
            child: CachedImage(url: widget.food.thumbnail, fit: BoxFit.fill),
          ),
          Positioned(
            bottom: 5,
            left: 10,
            right: 10,
            child: Container(
              height: 75,
              padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              decoration: BoxDecoration(
                  borderRadius: AppTheme.allBorderRadius,
                  color: theme.colorScheme.tertiary.withOpacity(0.9)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          widget.food.name,
                          style: theme.textTheme.headlineSmall?.copyWith(
                              color: theme.colorScheme.onTertiary,
                              fontWeight: FontWeight.w500),
                          textAlign: TextAlign.start,
                        ),
                        GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.food.isSaved = !widget.food.isSaved ;
                              });
                            },
                            child: Icon(
                              widget.food.isSaved
                                  ? CupertinoIcons.bookmark_solid
                                  : CupertinoIcons.bookmark,
                              color: theme.colorScheme.primary,
                            ))
                      ],
                    ),
                  ),
                  buildRow(widget.food.menuTimes)
                ],
              ),
            ),
          ),
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
                labels[index],
                if (index < labels.length - 1) SizedBox(width: 5.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
