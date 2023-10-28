import 'dart:io';

import 'package:easy_stepper/easy_stepper.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/basics_step.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/ingredients_step.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/steps_step.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/video_step.dart';
import 'package:flutter/material.dart';

class UploadRecipeScreen extends StatefulWidget {
  const UploadRecipeScreen({super.key});

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
          "Upload a recipe",
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

  Widget buildStepper() {
    final steps = List.generate(4, (index) {
      int stepNumber = index + 1;
      return EasyStep(
        customStep: CircleAvatar(
          radius: 8,
          backgroundColor: Colors.white,
          child: CircleAvatar(
            radius: 7,
            backgroundColor: activeStep >= index ? Colors.orange : Colors.white,
          ),
        ),
        title: stepNumber == 1
            ? 'Basic Info'
            : stepNumber == 2
                ? 'Ingredients'
                : stepNumber == 3
                    ? 'Steps'
                    : 'Video',
        topTitle: true,
      );
    });
    return EasyStepper(
      activeStep: activeStep,
      activeStepTextColor: Colors.black87,
      finishedStepTextColor: Colors.black87,
      internalPadding: 0,
      showLoadingAnimation: false,
      stepRadius: 8,
      showStepBorder: false,
      lineStyle: LineStyle(
        lineLength: 70,
        lineSpace: 0,
        lineType: LineType.normal,
        defaultLineColor: Colors.white,
        finishedLineColor: Colors.orange,
      ),
      steps: steps,
      onStepReached: (index) => setState(() => activeStep = index),
    );
  }
}
