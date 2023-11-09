import 'package:ethio_chef/theme/app_theme.dart';
import 'package:flutter/material.dart';

class IngredientCard extends StatelessWidget {
  final String ingredient;
  const IngredientCard({super.key, required this.ingredient});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        // color: theme.colorScheme.primaryContainer.withOpacity(0.05),
        borderRadius: AppTheme.allBorderRadius,
        border: Border.all(
          color: theme.colorScheme.primary
        ),
      ),
      child: Center(
        child: Text(
          textAlign: TextAlign.center,
          ingredient,
          style: theme.textTheme.bodyMedium,
        ),
      ),
    );
  }
}
