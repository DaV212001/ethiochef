import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_ingredients.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_steps.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';

class RecipeBody extends StatefulWidget {
  final List<String> ingredients;
  final List<String> steps;

  const RecipeBody({super.key, required this.ingredients, required this.steps});

  @override
  State<RecipeBody> createState() => _RecipeBodyState();
}

class _RecipeBodyState extends State<RecipeBody> with TickerProviderStateMixin {
  late TabController _tabController;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _tabController = DefaultTabController.of(context);
    _tabController.addListener(() {
      setState(() {
        selectedIndex = _tabController.index;
      });
    });
    bool tabIsSteps  = selectedIndex == 1;
    double ingredientsHeight = widget.ingredients.length * 50;
    double stepsHeight = widget.steps.length * 70;
    ThemeData theme = Theme.of(context);
    var tabs = [
      Tab(
        text: "Ingredients",
        icon: SvgIcon(
          image: Assets.iconsIngredients,
          color: tabIsSteps ? theme.unselectedWidgetColor
              : theme.colorScheme.primary,
        ),
      ),
      Tab(
        text: "Steps",
        icon: SvgIcon(
          image: Assets.iconsCooking,
          color: tabIsSteps
              ? theme.colorScheme.primary
              : theme.unselectedWidgetColor,
        ),
      ),
    ];
    return Column(
      children: <Widget>[
        ButtonsTabBar(
          controller: _tabController,
          backgroundColor: Colors.transparent,
          unselectedBackgroundColor: Colors.transparent,
          unselectedLabelStyle: theme.textTheme.labelMedium
              ?.copyWith(color: theme.colorScheme.tertiary),
          labelStyle: theme.textTheme.bodyMedium
              ?.copyWith(color: theme.colorScheme.primary),
          contentPadding: EdgeInsets.symmetric(horizontal: 10),
          radius: 5,
          tabs: tabs,
          physics: NeverScrollableScrollPhysics(),
        ),
        Expanded(
          flex: 0,
          child: Container(
            constraints: BoxConstraints(
              maxHeight: !tabIsSteps ? ingredientsHeight : stepsHeight,
            ),
            child: TabBarView(
              controller: _tabController,
              children: <Widget>[
                RecipeIngredients(ingredients: widget.ingredients),
                RecipeSteps(steps: widget.steps,),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
