import 'package:flutter/material.dart';

import '../models/food.dart';
import '../screens/recipe/recipe_screen.dart';
import '../widgets/error_card.dart';
import '../widgets/loading.dart';

class DeepLinkNavigation extends StatefulWidget {
  final int foodID;
  const DeepLinkNavigation({super.key, required this.foodID});

  @override
  State<DeepLinkNavigation> createState() => _DeepLinkNavigationState();
}

class _DeepLinkNavigationState extends State<DeepLinkNavigation> {
  Food? food;

  Future? _future;

  @override
  void initState() {
    _future = fetchData();
    super.initState();
  }

  Future<void> fetchData() async {
    // try {
    //   print('fetchData');
    //   final foodService = FoodService();
    //   food = await foodService.fetchFoodById(widget.foodID);
    // } catch (error) {
    //   rethrow;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Loading();
            } else if (snapshot.hasError) {
              return Center(
                child: ErrorCard(
                    errorType: snapshot.error.toString(),
                    refresh: () {
                      setState(() {
                        _future = fetchData();
                      });
                    }),
              );
            }
            if (food == null) {
              return ErrorCard(
                errorType: 'Cant fetch food',
                refresh: () {
                  setState(() {
                    _future = fetchData();
                  });
                },
              );
            }
            return RecipeScreen(chapter: food!);
          }),
    );
  }
}
