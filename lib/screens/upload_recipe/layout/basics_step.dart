import 'dart:io';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/image_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/stepper_control_buttons.dart';
import 'package:flutter/material.dart';

class BasicsStep extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController prepTimeController;
  final TextEditingController servingSizeController;
  final File? image;
  final Function(TextEditingController, TextEditingController,
      TextEditingController, TextEditingController, File?) updateControllers;
  final Function next;

  const BasicsStep(
      {super.key,
      required this.updateControllers,
      required this.next,
      required this.nameController,
      required this.descriptionController,
      required this.prepTimeController,
      required this.servingSizeController,
      this.image});

  @override
  State<BasicsStep> createState() => _BasicsStepState();
}

class _BasicsStepState extends State<BasicsStep> {
  late File? currentImage;

  @override
  void initState() {
    currentImage = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageField(
          image: currentImage,
          onImageSelected: (File? image) {
            currentImage = image;
          },
        ),
        SizedBox(
          height: 10,
        ),
        InputField(
            controller: widget.nameController,
            label: "Dish Name",
            hint: "Enter dish name"),
        InputField(
          controller: widget.descriptionController,
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
          controller: widget.prepTimeController,
          label: "Preparation time",
          hint: "Enter dish preparation in minutes",
          inputType: TextInputType.number,
        ),
        InputField(
          icon: Icons.people_outline,
          controller: widget.servingSizeController,
          label: "Serving size",
          hint: "Enter dish serving size",
          inputType: TextInputType.number,
        ),
        StepperControlButtons(
          isFirst: true,
          next: () {
            widget.updateControllers(
                widget.nameController,
                widget.descriptionController,
                widget.prepTimeController,
                widget.servingSizeController,
                currentImage
            );
            //Todo validate form
            widget.next();
          },
        )
      ],
    );
  }
}
