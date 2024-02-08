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
import '../../models/competition.dart';
import '../../models/recipe.dart';
import '../../services/recipe_service.dart';
import 'layout/successfully_added.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UploadRecipeScreen extends StatefulWidget {
  String type;
  UploadRecipeScreen({super.key, required this.type});

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
  File? image = null;
  File? video = null;
  bool agreed = false;
  bool isLoading = false;
BannerAd? _bannerAd;
  @override
  void initState() {
    _loadAd();
    super.initState();
  }
  String videoUrl = "";
  String videoPath = "";
  int statusCode = 0;
  Future<void> uploadVideo() async {
    print("video ========== ${video}");
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
        print("Json Response ${jsonRes}");
        print("Json Url ${jsonRes['url']}");
        setState(() {
          videoUrl = jsonRes['url'];
        });
        print("videoUrl ${videoUrl}");
      });
    } catch (error) {
      print(error);
    }
  }
  String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  void _loadAd() async {
    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
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
              color: theme.colorScheme.primary),
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
            print(agreed);
            setState(() {
              agreed = true;
            });
            print(agreed);
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
                Text(
                  "uploading_body".tr(),
                  style: TextStyle(
                    color: theme.colorScheme.tertiary,
                    fontWeight: FontWeight.normal,
                    fontSize: 17.sp,
                  ),
                  textAlign: TextAlign.center,
                ),
                CircularProgressIndicator(),
              ],
            ):VideoStep(
              isCompetition: false,
              video: video,
              updateVideo: (video) {
                print("===========video $video");
                setState(() {
                  this.video = video;
                });
              },
              next: (video) async {
                setState(() {
                  isLoading = true;
                });
               if(widget.type == "recipe"){
                 Map<String, String> ingredientMap = {
                   'ingredient': 'ingredient',
                 };
                 print("ingredientMap = $ingredientMap");
                 for (int i = 0; i < itemControllers.length; i++) {
                   String ingredient = itemControllers[i].text;
                   String quantity = quantityControllers[i].text;

                   ingredientMap = {
                     '${i+1}': quantity,
                   };
                   ingredients.add(ingredientMap);

                 }
                 for(int i=0;i<stepControllers.length;i++){
                   String stepString = stepControllers[i].text;
                   step.add(stepString);
                 }

                 int stepNumber = 1;
                 for (String instruction in step) {
                   stepToCreate["$stepNumber"] = instruction;
                   stepNumber++;
                 }

                 for (var map in ingredients) {
                   ingredientToCreate.addAll(map);
                 }
                 print("video ${video}");
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

                 print("video ========== ${video}");
                 videoPath = video!.path;
                 print("videoPath ========== ${videoPath}");
                 print("Add RECIPE");
                 RecipeService service = RecipeService();
                 var response = await service.createFood(newRecipe);
                 print("video ========== ${video}");
                 if(response.statusCode == 200) {
                   statusCode = 200;
                   print(response.statusCode);
                   await uploadVideo();
                   print("Video uploaded");
                   pushNewScreen(
                     context,
                     screen: SuccessfullyAdded(),
                     withNavBar: true,
                     pageTransitionAnimation: PageTransitionAnimation.cupertino,
                   );
                 }
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


               }else{
                 Map<String, String> ingredientMap = {
                   'ingredient': 'ingredient',
                   'quantity': 'quantity',
                 };
                 for (int i = 0; i < itemControllers.length; i++) {
                   String ingredient = itemControllers[i].text;
                   String quantity = quantityControllers[i].text;

                   ingredientMap = {
                     'ingredient': quantity,
                     'quantity': ingredient,
                   };
                   ingredients.add(ingredientMap);

                 }
                 for(int i=0;i<stepControllers.length;i++){
                   String stepString = stepControllers[i].text;
                   step.add(stepString);
                 }
                 Competition newRecipe = Competition(
                     name: nameController.text,
                     description: descriptionController.text,
                     prepTime: prepTimeController.text,
                     servingSize: servingSizeController.text,
                     steps: step,
                     imageFile: image,
                     videoFile: video,
                     ingredient: ingredients
                 );


                 Competition.addCompetition(newRecipe);
                 setState(() {
                   activeStep = 0;
                 });
               }
              },
              back: decrementStep,
            ),
          ),
        ),
      )
    ];
  }

  Future<void> incrementStep() async {

      setState(() {
        activeStep++;
      });

  }

  void decrementStep() {
    setState(() {
      activeStep--;
    });
  }

}
