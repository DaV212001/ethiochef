import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/add_ingredient_button.dart';
import 'package:ethio_chef/widgets/upload_recipe/image_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/ingredinet_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/step_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/cupertino.dart';
import 'dart:io';

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


  final picker = ImagePicker();
  File? picture = null;
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
            children: [
              ImageField(
                imagePath: picture,
                onClicked: showOptions,
              ),
              SizedBox(height: 10,),
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

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        picture = File(pickedFile.path);
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);
    setState(() {
      if (pickedFile != null) {
        picture = File(pickedFile.path);
      }
    });
  }

  //Show options to get image from camera or gallery
  Future showOptions() async {
    showCupertinoModalPopup(
      context: context,
      builder: (context) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            child: Text('Photo Gallery'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('Camera'),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from camera
              getImageFromCamera();
            },
          ),
        ],
      ),
    );
  }

  //Image Picker function to get image from gallery
  Future getVideoFromGallery() async {
    final pickedFile = await picker.pickVideo(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        picture = File(pickedFile.path);
      }
    });
  }
}
