import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/basics_step.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/ingredients_step.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/steps_header.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/steps_step.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/video_step.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:quickalert/quickalert.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../models/recipe.dart';
import '../../services/recipe_service.dart';
import '../../services/subscription_checker.dart';
import '../../services/user_service.dart';
import '../../widgets/loading.dart';
import '../auth/auth_screen.dart';
import '../subscription/all_subscriptions.dart';
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
  BannerAd? _bannerAd;
  String videoUrl = "";
  String videoPath = "";
  int statusCode = 0;

  @override
  void initState() {
    _loadAd();
    super.initState();
  }

  String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';

  void _loadAd() async {
    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        onAdOpened: (Ad ad) {},
        onAdClosed: (Ad ad) {},
        onAdImpression: (Ad ad) {},
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
          "submit_a_recipe".tr(),
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
      if (_bannerAd != null)
        Align(
          alignment: Alignment.topCenter,
          child: SafeArea(
            child: SizedBox(
              width: _bannerAd!.size.width.toDouble(),
              height: _bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: _bannerAd!),
            ),
          ),
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
          hasUserAgreed: (agreed){
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
            child: isLoading == true ? Column(
              children: [
                Text(
                  "uploading_title".tr(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    fontSize: 15.sp,
                  ),
                ),
                SizedBox(height: 20,),
                Text(
                  "uploading_body".tr(),
                  style: TextStyle(
                    color: theme.colorScheme.secondary,
                    fontWeight: FontWeight.normal,
                    fontSize: 17.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20,),
                Loading(),
              ],
            ):VideoStep(
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
                print("=======================================================================================================");
                print(video!.path);
                print(videoPath);
                print("=======================================================================================================");
                print("Checking user $isSubscribed");
                await createFood();
              },
              back: decrementStep,
            ),
          ),
        ),
      )
    ];
  }

  Future<void> incrementStep() async {
    if(activeStep == 0){
      await checkSubscription();
    }
    if(activeStep == 0 && isSubscribed){
      setState(() {
        activeStep++;
      });
    }
    if(activeStep != 0){
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

  Future<void> createFood() async {
    try {
      print("=======================================================================================");
      print(videoPath);
      print("=======================================================================================");
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
      print("=======================================================================================");
      print(step);
      print("=======================================================================================");
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
          stepToCreate: stepToCreate
      );
      print("2");
      RecipeService service = RecipeService();
      var response = await service.createFood(newRecipe);

      if (response.statusCode == 200) {
        await uploadVideo();
        reset();
        pushNewScreen(
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
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('failed_to_send_recipe'.tr()),
          content: Text('please_try_again'.tr()),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void reset() {
    setState(() {
      isLoading = true;
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
    switch(status){
      case null:

        pushNewScreen(
          context,
          withNavBar: false,
          screen: AuthScreen(isSignIn: true),
        );
        break;
      case "Not logged in":
        SnackBar logIn =SnackBar(
            padding: EdgeInsets.symmetric(vertical: 20),
            content: Text(
                'please_subscribe_to_see_ingredients_and_steps'.tr()
            ));
        pushNewScreen(
          context,
          withNavBar: false,
          screen: AuthScreen(isSignIn: true),
        );
        break;
      case "Another user logged in":
        pushNewScreen(
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
        pushNewScreen(
          context,
          withNavBar: false,
          screen: AllSubscriptions(returnPrice: (int ) {  },
              first_name: "",
              last_name: "",
              isSignUp: false,
              phone: ""),
        );
        break;
    }
  }

  Future<void> uploadVideo() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/ttreeadvert/video/upload'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', videoPath));
    request.fields['upload_preset'] = 'my_uploads';

    try {
      var response = await request.send();
      var responseJson = await http.Response.fromStream(response).then((value) {
        var jsonRes = jsonDecode(value.body);
        setState(() {
          videoUrl = jsonRes['url'];
        });
      });
    } catch (error) {
      print(error);
    }
  }
}