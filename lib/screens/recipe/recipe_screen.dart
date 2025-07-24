import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header.dart';
import 'package:ethio_chef/screens/recipe/layout/recipe_header_image.dart';
import 'package:ethio_chef/services/user_service.dart';
import 'package:ethio_chef/widgets/ad_block.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../models/comment.dart';
import '../../models/user.dart';
import '../../services/comment_service.dart';
import '../../services/food_service.dart';
import '../../widgets/error_card.dart';
import '../../widgets/loading.dart';
import '../../widgets/pull_to_refresh.dart';
import '../../widgets/recipe/share_button.dart';
import '../comment/food_comments.dart';
import 'layout/recipe_related.dart';
import 'layout/recipe_tabs.dart';

class RecipeScreen extends StatefulWidget {
  final Food food;
  const RecipeScreen({super.key, required this.food});

  @override
  State<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends State<RecipeScreen> {
  Future? _future;

  @override
  void initState() {
    _future = fetchData();
    loadAd();
    super.initState();
  }

  Future<dynamic> fetchData() async {
    // try {
    print('fetchData');
    final foodService = FoodService();
    var foodData = await foodService.fetchFoodById(widget.food.id!);
    print('fetchDataBYID');
    final commentService = CommentService();
    var commentData = await commentService.fetchComments(widget.food.id!);
    final userService = UserService();
    var userData = await userService.fetchLoggedInUser();
    return [foodData, commentData, userData];
    // } on Exception catch (error, s) {
    //   Logger().t(error, stackTrace: s);
    //   print('ERROR CAUGHT: $error');
    // }
  }

  static String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  static BannerAd? _bannerAd1;
  static BannerAd? _bannerAd2;
  static BannerAd? _bannerAd3;

  void loadAd() async {
    print("Loading Ads");
    await BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd1 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
    await BannerAd(
      adUnitId: 'ca-app-pub-4750411587709054/1691458173',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd2 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
    await BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd3 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return RefreshWidget(
        child: Scaffold(
            body: FutureBuilder(
                future: _future,
                builder: (context, AsyncSnapshot<dynamic> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Loading();
                  }
                  if (snapshot.hasError) {
                    print(snapshot.error);
                    print(snapshot.stackTrace);
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
                  return buildRecipeScreen(
                      snapshot.data[0] as Food,
                      snapshot.data[1] as List<Comments>,
                      snapshot.data[2] as User);
                })),
        onRefresh: () async {
          setState(() {
            _future = fetchData();
          });
        });
  }

  Widget buildRecipeScreen(Food food, List<Comments> comment, User user) {
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_bannerAd1 != null)
            AdBlock(
              bannerAd: _bannerAd1,
              isbottom: false,
            ),
          SafeArea(
            child: RecipeHeaderImage(
              food: food,
              likes: food.likes!,
              user: User(firstName: 'Guest', lastName: 'User'),
              image: food.thumbnail,
              onLike: () {},
              refresh: () {
                setState(() {
                  _future = fetchData();
                });
              },
              foodId: food.id!,
            ),
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                RecipeHeader(
                  food: food,
                ),
                SizedBox(height: 10),
                RecipeScreenTab(
                  food: food,
                ),
                if (_bannerAd2 != null)
                  AdBlock(
                    bannerAd: _bannerAd2,
                    isbottom: false,
                  ),
                CommentScreen(
                  foodId: food.id!,
                  comments: comment,
                  refresh: () {
                    print("Should call this guy");
                    setState(() {
                      _future = fetchData();
                    });
                  },
                  user: user,
                ),
                if (!food.related_recipe!.isEmpty)
                  RecipeRelated(food: food.related_recipe),
                if (_bannerAd3 != null)
                  AdBlock(
                    bannerAd: _bannerAd3,
                    isbottom: true,
                  )
              ],
            ),
          ),
          ShareButton(food: food),
        ],
      )),
    );
  }
}
