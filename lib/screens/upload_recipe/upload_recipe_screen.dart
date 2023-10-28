import 'dart:io';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/add_ingredient_button.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/image_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/ingredient_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/step_field.dart';
import 'package:ethio_chef/screens/upload_recipe/layout/video_field.dart';
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
  bool hasOneIngredient = true;
  bool hasOneStep = true;

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
            children: [
              ImageField(
                onImageSelected: (File? image) {},
              ),
              SizedBox(
                height: 10,
              ),
              InputField(
                  controller: nameController,
                  label: "Dish Name",
                  hint: "Enter dish name"),
              InputField(
                controller: descriptionController,
                label: "Dish Description",
                hint: "Enter dish description",
                maxLines: 10,
                minLines: 10,
                height: 150,
              ),
              SizedBox(
                height: 13,
              ),
              InputField(
                icon: Icons.timer_outlined,
                controller: prepTimeController,
                label: "Preparation time",
                hint: "Enter dish preparation in minutes",
                inputType: TextInputType.number,
              ),
              InputField(
                icon: Icons.people_outline,
                controller: servingSizeController,
                label: "Serving size",
                hint: "Enter dish serving size",
                inputType: TextInputType.number,
              ),
              Header(title: "Ingredients"),
              SizedBox(
                height: 10,
              ),
              for (int i = 0; i < quantityControllers.length; i++)
                IngredientField(
                  quantityController: quantityControllers[i],
                  itemController: itemControllers[i],
                  isOnlyIngredient: hasOneIngredient,
                  isLastIngredient: i == quantityControllers.length - 1,
                  onMinus: () {
                    removeIngredient(i);
                  },
                ),
              AddButton(text: "Add ingredient", onPress: addIngredient),
              Header(title: "Steps"),
              SizedBox(
                height: 10,
              ),
              for (int i = 0; i < stepControllers.length; i++)
                StepField(
                  index: i,
                  stepController: stepControllers[i],
                  isLastStep: i == stepControllers.length - 1,
                  isOnlyStep: hasOneStep,
                  onMinus: () {
                    removeStep(i);
                  },
                ),
              AddButton(text: "Add step", onPress: addStep),
              Header(title: "Video"),
              SizedBox(
                height: 10,
              ),
              VideoField(
                onVideoSelected: (File? video) {},
              ),
              SizedBox(
                height: 100,
              )
            ],
          ),
        ),
      ),
    );
  }

  void addIngredient() {
    quantityControllers.add(TextEditingController());
    itemControllers.add(TextEditingController());
    setState(() {
      hasOneIngredient = quantityControllers.length == 1;
    });
  }

  void removeIngredient(int i) {
    setState(() {
      quantityControllers.removeAt(i);
      itemControllers.removeAt(i);
      hasOneIngredient = quantityControllers.length == 1;
    });
  }

  void addStep() {
    stepControllers.add(TextEditingController());
    setState(() {
      hasOneStep = stepControllers.length == 1;
    });
  }

  void removeStep(int i) {
    setState(() {
      stepControllers.removeAt(i);
      hasOneStep = stepControllers.length == 1;
    });
  }
}
