import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../../../models/food.dart';
import '../../../screens/recipe/layout/recipe_header.dart';
import '../../../screens/recipe/layout/recipe_header_image.dart';
import '../../../services/user_service.dart';
import '../../../widgets/ad_block.dart';
import '../../models/comment.dart';
import '../../models/user.dart';
import '../../services/ad_service.dart';
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
    print('fetchData');
    final foodService = FoodService();
    final Food foodData = await foodService.fetchFoodById(widget.food.id!);
    print('fetchDataBYID');

    List<Comments> commentData = [];
    try {
      final commentService = CommentService();
      commentData = await commentService.fetchComments(widget.food.id!);
    } catch (e) {
      print("Error fetching comments: $e");
    }

    final userService = UserService();
    User? userData;
    try {
      userData = await userService.fetchLoggedInUser();
    } catch (e) {
      print("User not logged in or fetch error: $e");
    }

    return [foodData, commentData, userData];
  }

  BannerAd? _bannerAdTop;
  BannerAd? _bannerAdMiddle;
  BannerAd? _bannerAdBottom;

  @override
  void dispose() {
    _bannerAdTop?.dispose();
    _bannerAdMiddle?.dispose();
    _bannerAdBottom?.dispose();
    super.dispose();
  }

  void loadAd() {
    if (!AdService.to.adsEnabled.value) return;
    print("Loading Recipe Banner Ads (Top, Middle, Bottom)");

    if (_bannerAdTop == null) {
      AdService.loadBannerSequentially(
        position: BannerPosition.top,
        isMounted: () => mounted,
        onLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAdTop = ad;
            });
          } else {
            ad.dispose();
          }
        },
        onFailed: (err) {
          if (mounted) {
            setState(() {
              _bannerAdTop = null;
            });
          }
        },
      );
    }

    if (_bannerAdMiddle == null) {
      AdService.loadBannerSequentially(
        position: BannerPosition.middle,
        isMounted: () => mounted,
        onLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAdMiddle = ad;
            });
          } else {
            ad.dispose();
          }
        },
        onFailed: (err) {
          if (mounted) {
            setState(() {
              _bannerAdMiddle = null;
            });
          }
        },
      );
    }

    if (_bannerAdBottom == null) {
      AdService.loadBannerSequentially(
        position: BannerPosition.bottom,
        isMounted: () => mounted,
        onLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAdBottom = ad;
            });
          } else {
            ad.dispose();
          }
        },
        onFailed: (err) {
          if (mounted) {
            setState(() {
              _bannerAdBottom = null;
            });
          }
        },
      );
    }
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
              return SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: theme.colorScheme.secondaryContainer),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Center(child: Loading()),
                  ],
                ),
              );
            }
            if (snapshot.hasError || !snapshot.hasData || snapshot.data == null) {
              print('RecipeScreen error: ${snapshot.error}');
              final String err = snapshot.hasError ? snapshot.error.toString() : "no_internet";
              return SafeArea(
                child: Stack(
                  children: [
                    Positioned(
                      top: 10,
                      left: 10,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back, color: theme.colorScheme.secondaryContainer),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    Center(
                      child: ErrorCard(
                        errorType: err,
                        refresh: () {
                          setState(() {
                            _future = fetchData();
                          });
                        },
                      ),
                    ),
                  ],
                ),
              );
            }
            return buildRecipeScreen(
              snapshot.data[0] as Food,
              snapshot.data[1] as List<Comments>,
              snapshot.data[2] as User?,
            );
          },
        ),
      ),
      onRefresh: () async {
        loadAd();
        setState(() {
          _future = fetchData();
        });
      },
    );
  }

  Widget buildRecipeScreen(Food food, List<Comments> comment, User? user) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (_bannerAdTop != null && AdService.to.adsEnabled.value)
              AdBlock(bannerAd: _bannerAdTop, isbottom: false),
            SafeArea(
              child: RecipeHeaderImage(
                food: food,
                likes: food.likes ?? [],
                user: user,
                image: food.thumbnail,
                onLike: () {},
                refresh: () {
                  setState(() {
                    _future = fetchData();
                  });
                },
                foodId: food.id ?? widget.food.id ?? 0,
              ),
            ),
            if (_bannerAdMiddle != null && AdService.to.adsEnabled.value)
              AdBlock(bannerAd: _bannerAdMiddle, isbottom: false),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RecipeHeader(food: food),
                  SizedBox(height: 10),
                  RecipeScreenTab(food: food),
                  CommentScreen(
                    foodId: food.id ?? widget.food.id ?? 0,
                    comments: comment,
                    refresh: () {
                      print("Should call this guy");
                      setState(() {
                        _future = fetchData();
                      });
                    },
                    user: user,
                  ),
                  if (food.related_recipe != null && food.related_recipe!.isNotEmpty)
                    RecipeRelated(food: food.related_recipe),
                  if (_bannerAdBottom != null && AdService.to.adsEnabled.value)
                    AdBlock(bannerAd: _bannerAdBottom, isbottom: true),
                ],
              ),
            ),
            ShareButton(food: food),
          ],
        ),
      ),
    );
  }
}
