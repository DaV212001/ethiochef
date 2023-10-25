import 'package:ethio_chef/models/category.dart';
import 'package:ethio_chef/screens/category/category_screen.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

class CategoryCard extends StatelessWidget {
  final Category category;
  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          withNavBar: false,
          screen: CategoryScreen(
              category: category,
          ),
        );
      },
      child: Card(
        child: Stack(
          fit: StackFit.expand,
          children: [
            ClipRRect(
              borderRadius: AppTheme.allBorderRadius,
              child: Container(

                  child: CachedImage(url: category.image, fit: BoxFit.fill)),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
                decoration: BoxDecoration(
                    borderRadius: AppTheme.allBorderRadius,
                    color: theme.colorScheme.tertiary.withOpacity(0.35)),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Padding(
                    padding: EdgeInsets.all(5),
                    child: Text(
                      category.name,
                      style: theme.textTheme.headlineSmall?.copyWith(
                          color: theme.colorScheme.onTertiary,
                          fontWeight: FontWeight.w500),
                      textAlign: TextAlign.start,
                      softWrap: true,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
