import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/add_ingredient_button.dart';
import 'package:ethio_chef/widgets/upload_recipe/recipe_ingredinet_field.dart';
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
  TextEditingController itemController = TextEditingController();
  TextEditingController quantityController = TextEditingController();

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
              SizedBox(height: 10,),
              RecipeIngredientField(
                quantityController: quantityController,
                itemController: itemController,
              ),
              AddIngredientButton(onPress: (){})
            ],
          ),
        ),
      ),
    );
  }
}
