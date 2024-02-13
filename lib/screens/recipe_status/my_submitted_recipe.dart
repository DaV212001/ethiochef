
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/utils/screen_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import '../../models/submitted_recipe.dart';
import '../../services/recipe_service.dart';
import '../../widgets/error_card.dart';
import '../../widgets/loading.dart';
import '../../widgets/recipe_status/empty_recipe.dart';
import '../../widgets/recipe_status/submitted.dart';
import '../../widgets/recipe_status/submitted_recipe_card.dart';
import 'layout/my_submitted_description.dart';

class SubmittedRecipe extends StatefulWidget {
  const SubmittedRecipe({super.key});

  @override
  State<SubmittedRecipe> createState() => _SubmittedRecipeState();
}

class _SubmittedRecipeState extends State<SubmittedRecipe> with SingleTickerProviderStateMixin{

  Future? _future;

  @override
  void initState() {
    _future = fetchData();
    super.initState();
  }


  Future<dynamic> fetchData() async {
    try {
      RecipeService service = RecipeService();
      var data = await service.fetchDishes();
      return data;
    } catch (error) {
      rethrow;
    }
  }

  bool showAddRecipeCard = true;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("submitted_recipes".tr(),style: TextStyle(
            color: theme.colorScheme.primary
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
              Navigator.of(context).pop();
            },
            child: Icon(
              Icons.arrow_back,
              color: theme.colorScheme.primary,
            )),
      ),
      body: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            }
            if (snapshot.hasError) {
              return Center(
                  child: ErrorCard(
                    errorType: snapshot.error.toString(),
                    refresh: () {
                      setState(() {
                        _future = fetchData();
                      });
                    },
                  ));
            }
            return buildRecipeScreen(snapshot.data as List<MySubmittedRecipe>);
          }),
    );
  }

  Widget buildRecipeScreen(List<MySubmittedRecipe> recipe){
    bool isTablet = ScreenUtils.isTablet(context);
    final double desiredItemWidth = isTablet ? 130.w : 150.w;
    final double desiredItemHeight = isTablet ? 220.h : 200.h;
    final double screenWidth = ScreenUtils.width(context);
    final int crossAxisCount = (screenWidth / desiredItemWidth).floor();
    final double childAspectRatio = desiredItemWidth / desiredItemHeight;
    if(recipe.isEmpty){
      return EmptyRecipe();
    }
    return GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(

        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        mainAxisSpacing: isTablet ? 5 : 0,
      ),
      itemCount: recipe.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        var resp = recipe[index];
        return SubmittedRecipeCard(
            recipe: recipe[index],
            name: recipe[index].title,
            isApproved: recipe[index].approved
        );
      },
    );
  }
}
