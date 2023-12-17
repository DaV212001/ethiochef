import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/basics_step.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/ingredients_step.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/steps_header.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/steps_step.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/video_step.dart';
import 'package:flutter/material.dart';

import '../../models/competition.dart';
import '../../models/recipe.dart';

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

  @override
  void initState() {
    super.initState();
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
          style: theme.textTheme.headlineLarge
              ?.copyWith(color: theme.colorScheme.primary),
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
    return [
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
        child: VideoStep(
          video: video,
          updateVideo: (video) {
           this.video = video;
          },
          next: (){
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

             print("STEPS ${stepToCreate}");
             for (var map in ingredients) {
               ingredientToCreate.addAll(map);
             }
             print("INGREDIENTS ${ingredientToCreate}");
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

             print("Add RECIPE");
             Recipe.addRecipe(newRecipe);
             setState(() {
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
      )
    ];
  }

  void incrementStep() {
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
