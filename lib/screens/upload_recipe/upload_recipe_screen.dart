import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../screens/upload_recipe/layout/basics_step.dart';
import '../../../screens/upload_recipe/layout/ingredients_step.dart';
import '../../../screens/upload_recipe/layout/steps_header.dart';
import '../../../screens/upload_recipe/layout/steps_step.dart';
import '../../../screens/upload_recipe/layout/video_step.dart';
import '../../../services/scheduled_notification_service.dart';
import '../../../widgets/ad_block.dart';
import '../../models/recipe.dart';
import '../../services/recipe_service.dart';
import '../../services/subscription_checker.dart';
import '../../widgets/loading.dart';
import '../auth/auth_screen.dart';
import '../subscription/layout/payment.dart';
import 'layout/successfully_added.dart';

class UploadRecipeScreen extends StatefulWidget {
  UploadRecipeScreen({Key? key});

  @override
  State<UploadRecipeScreen> createState() => _UploadRecipeScreenState();
}

class _UploadRecipeScreenState extends State<UploadRecipeScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController prepTimeController = TextEditingController();
  TextEditingController servingSizeController = TextEditingController();
  List<TextEditingController> itemControllers = [TextEditingController()];
  List<TextEditingController> quantityControllers = [TextEditingController()];
  List<TextEditingController> stepControllers = [TextEditingController()];
  List<Map<String, String>> ingredients = [];
  Map<String, dynamic> ingredientToCreate = {};
  Map<String, dynamic> stepToCreate = {};
  List<String> step = [];
  int activeStep = 0;
  File? image;
  File? video;
  bool agreed = false;
  bool isLoading = false;
  bool isSubscribed = false;
  String videoUrl = "";
  String videoPath = "";
  int statusCode = 0;

  @override
  void initState() {
    loadAd();
    super.initState();
  }

  static String get _adbannerUnitId => AdService.topBannerAdUnitId;
  static BannerAd? _bannerAd1;

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
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        foregroundColor: theme.colorScheme.primary,
        elevation: 0,
        title: Text(
          "extra_skills".tr,
          style: TextStyle(
            fontSize: 19.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.primary,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Column(
            children: steps(),
          ),
        ),
      ),
    );
  }

  List<Widget> steps() {
    final ThemeData theme = Theme.of(context);
    return [
      if (_bannerAd1 != null)
        AdBlock(
          bannerAd: _bannerAd1,
          isbottom: false,
        ),
      StepsHeader(activeStep: activeStep),
      Visibility(
        visible: activeStep == 0,
        child: BasicsStep(
          nameController: nameController,
          descriptionController: descriptionController,
          prepTimeController: prepTimeController,
          servingSizeController: servingSizeController,
          image: image,
          updateControllers: (nameController, descriptionController,
              prepTimeController, servingSizeController, image) {
            this.nameController = nameController;
            this.descriptionController = descriptionController;
            this.prepTimeController = prepTimeController;
            this.servingSizeController = servingSizeController;
            this.image = image;
          },
          next: incrementStep,
          hasUserAgreed: (agreed) {
            setState(() {
              agreed = true;
            });
          },
        ),
      ),
      Visibility(
        visible: activeStep == 1,
        child: IngredientsStep(
          itemControllers: itemControllers,
          quantityControllers: quantityControllers,
          updateControllers: (quantityControllers, itemControllers) {
            this.quantityControllers = quantityControllers;
            this.itemControllers = itemControllers;
          },
          next: incrementStep,
          back: decrementStep,
        ),
      ),
      Visibility(
        visible: activeStep == 2,
        child: StepsStep(
          stepControllers: stepControllers,
          updateControllers: (stepControllers) {
            stepControllers.forEach((element) {
              print(element.text);
            });
            this.stepControllers = stepControllers;
          },
          next: incrementStep,
          back: decrementStep,
        ),
      ),
      Visibility(
        visible: activeStep == 3,
        child: Center(
          child: Container(
            child: isLoading == true
                ? Column(
                    children: [
                      Text(
                        "uploading_title".tr,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          fontSize: 15.sp,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Loading(),
                    ],
                  )
                : VideoStep(
                    isCompetition: false,
                    video: video,
                    updateVideo: (video) {
                      setState(() {
                        this.video = video;
                      });
                    },
                    next: (video) async {
                      setState(() {
                        videoPath = video!.path;
                      });
                      setState(() {
                        isLoading = true;
                      });
                      print(
                          "=======================================================================================================");
                      print(video!.path);
                      print(videoPath);
                      print(
                          "=======================================================================================================");
                      print("Checking user $isSubscribed");
                      await uploadVideo();
                    },
                    back: decrementStep,
                  ),
          ),
        ),
      )
    ];
  }

  Future<void> incrementStep() async {
    if (activeStep != 0) {
      print("increment 3");
      setState(() {
        activeStep++;
      });
    }
    if (activeStep == 0) {
      print("increment 1");
      await checkSubscription();
    }
    if (activeStep == 0 && isSubscribed) {
      print("increment 2");
      setState(() {
        activeStep++;
      });
    }
  }

  void decrementStep() {
    setState(() {
      activeStep--;
    });
  }

  Future<void> createFood(String url) async {
    try {
      print(
          "=======================================================================================");
      print(videoPath);
      print(
          "=======================================================================================");
      print("Create ingredient map");
      // Create ingredient map
      for (int i = 0; i < itemControllers.length; i++) {
        ingredients.add({
          '${i + 1}': quantityControllers[i].text,
        });
      }
      for (int i = 0; i < stepControllers.length; i++) {
        String stepString = stepControllers[i].text;
        step.add(stepString);
      }

      int stepNumber = 1;
      for (String instruction in step) {
        stepToCreate["$stepNumber"] = instruction;
        stepNumber++;
      }
      // Create step instructions
      print("Create step instructions");
      print(
          "=======================================================================================");
      print(step);
      print(
          "=======================================================================================");
      // Combine ingredients map
      print("Create ingredients map");
      ingredients.forEach((map) {
        ingredientToCreate.addAll(map);
      });

      // Create new recipe object
      print("1");
      Recipe newRecipe = Recipe(
          name: nameController.text,
          description: descriptionController.text,
          prepTime: prepTimeController.text,
          servingSize: servingSizeController.text,
          steps: step,
          image: image,
          video: video,
          ingredient: ingredients,
          ingredientToCreate: ingredientToCreate,
          stepToCreate: stepToCreate,
          videoUrl: url);
      print("2");
      RecipeService service = RecipeService();
      var response = await service.createFood(newRecipe);

      if (response.statusCode == 200) {
        await NotificationScheduled.showNotification(
          id: 1,
          payload: 'food.uploaded',
          body: "submitted_successfully".tr,
          title: "successful".tr,
        );
        reset();
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: SuccessfullyAdded(),
          withNavBar: true,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
      } else {
        showRetryDialog();
      }
    } catch (error) {
      print('Error creating recipe: $error');
      showRetryDialog();
    }
  }

  void showRetryDialog() {
    reset();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('failed_to_send_recipe'.tr),
          content: Text('please_try_again'.tr),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('ok'.tr),
            ),
          ],
        );
      },
    );
  }

  void reset() {
    setState(() {
      isLoading = false;
      nameController.text = '';
      descriptionController.text = '';
      prepTimeController.text = '';
      servingSizeController.text = '';
      itemControllers = [TextEditingController()];
      stepControllers = [TextEditingController()];
      quantityControllers = [TextEditingController()];
      image = null;
      video = null;
      ingredients = [];
      step = [];
      ingredientToCreate = {};
      stepToCreate = {};
      activeStep = 0;
    });
  }

  Future<void> checkSubscription() async {
    String? status = SubscriptionStatus().status;
    switch (status) {
      case null:
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: false,
          screen: AuthScreen(isSignIn: true),
        );
        break;
      case "Not logged in":
        SnackBar logIn = SnackBar(
            padding: EdgeInsets.symmetric(vertical: 20),
            content:
                Text('please_subscribe_to_see_ingredients_and_steps'.tr));
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: false,
          screen: AuthScreen(isSignIn: true),
        );
        break;
      case "Another user logged in":
        PersistentNavBarNavigator.pushNewScreen(
          context,
          withNavBar: false,
          screen: AuthScreen(isSignIn: true),
        );
        break;
      case "User is subscribed":
        setState(() {
          isSubscribed = true;
        });
        break;
      case "User is not subscribed":
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: PaymentCheckout(isSMS: true, isNormalSubscription: true),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
        break;
    }
  }

  Future<void> uploadVideo() async {
    print("Uploading 1");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/dohotrrss/video/upload'),
    );

    print("Uploading 2");
    request.headers['Authorization'] = 'Basic YWxhZGRpbjpvcGVuc2VzYW1l';
    print("Uploading 3");

    request.files.add(await http.MultipartFile.fromPath('file', videoPath));
    print("Uploading 4");
    request.fields['upload_preset'] = 'ethiochef';
    print("Uploading 5");
    try {
      print("Uploading 6");
      var response = await request.send();
      var responseJson =
          await http.Response.fromStream(response).then((value) async {
        var jsonRes = jsonDecode(value.body);
        print("Uploading 7");
        print("jsonRes $jsonRes");
        print(response.stream);
        print(response.headers);
        print(response.statusCode);
        print(response.reasonPhrase);
        setState(() {
          videoUrl = jsonRes['url'];
        });
        print("jsonRes $jsonRes");
        print("videoUrl $videoUrl");

        if (response.statusCode == 200) {
          await createFood(jsonRes['url']);
        } else {
          showRetryDialog();
        }
      });
    } catch (error) {
      print(error);
    }
  }
}
