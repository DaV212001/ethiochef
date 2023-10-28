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
  final _formKey = GlobalKey<FormState>();
  bool imageInvalid = false;

  @override
  void initState() {
    currentImage = widget.image;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ImageField(
            invalid: imageInvalid,
            image: currentImage,
            onImageSelected: (File? image) {
              currentImage = image;
            },
          ),
          if (imageInvalid) invalidImage(),
          SizedBox(
            height: 10,
          ),
          InputField(
              controller: widget.nameController,
              label: "Dish Name",
              hint: "Enter dish name"),
          SizedBox(
            height: 10,
          ),
          InputField(
            controller: widget.descriptionController,
            label: "Dish Description",
            hint: "Enter dish description",
            maxLines: 3,
            minLines: 3,
            height: 100,
          ),
          SizedBox(
            height: 10,
          ),
          InputField(
            icon: Icons.timer_outlined,
            controller: widget.prepTimeController,
            label: "Preparation time",
            hint: "Enter dish preparation in minutes",
            inputType: TextInputType.number,
          ),
          SizedBox(
            height: 10,
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
              if (!_formKey.currentState!.validate()) {
                imageStatus();
                return;
              }
              imageStatus();
              if(currentImage == null){
                return;
              }

              widget.updateControllers(
                  widget.nameController,
                  widget.descriptionController,
                  widget.prepTimeController,
                  widget.servingSizeController,
                  currentImage);
              widget.next();
            },
          )
        ],
      ),
    );
  }

  void imageStatus(){
    if (currentImage == null && imageInvalid == false) {
      setState(() {
        imageInvalid = true;
      });
      return;
    }
    if (currentImage != null && imageInvalid == true) {
      setState(() {
        imageInvalid = false;
      });
    }
  }

  Widget invalidImage() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 5),
        child: Text("Image is required",
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}
