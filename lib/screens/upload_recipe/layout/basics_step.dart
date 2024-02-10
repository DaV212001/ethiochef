import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/image_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/stepper_control_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../../utils/screen_utils.dart';

class BasicsStep extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController descriptionController;
  final TextEditingController prepTimeController;
  final TextEditingController servingSizeController;
  final File? image;
  final Function(TextEditingController, TextEditingController,
      TextEditingController, TextEditingController, File?) updateControllers;
  final Function(bool) hasUserAgreed;
  final Function next;

  const BasicsStep(
      {super.key,
      required this.updateControllers,
      required this.next,
      required this.nameController,
      required this.descriptionController,
      required this.prepTimeController,
      required this.servingSizeController,
        required this.hasUserAgreed,
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
  bool hasAgreed = false;
  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
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
              label: "dish_name".tr(),
              hint: "enter_dish_name".tr()),
          SizedBox(
            height: 10,
          ),
          InputField(
            controller: widget.descriptionController,
            label: "dish_description".tr(),
            hint: "enter_dish_description".tr(),
            maxLines: 3,
            minLines: 3,
            height: 100,
          ),
          SizedBox(
            height: 10,
          ),
          // InputField(
          //   icon: Icons.timer_outlined,
          //   controller: widget.prepTimeController,
          //   label: "preparation_times".tr(),
          //   hint: "enter_dish_preparation_in_minutes".tr(),
          //   inputType: TextInputType.number,
          // ),
          SizedBox(
            height: 10,
          ),
          // InputField(
          //   icon: Icons.people_outline,
          //   controller: widget.servingSizeController,
          //   label: "serving_sizes".tr(),
          //   hint: "enter_dish_serving_size".tr(),
          //   inputType: TextInputType.number,
          // ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Checkbox(
                activeColor: theme.colorScheme.primary,
                checkColor: theme.colorScheme.tertiary,
                  value: hasAgreed,
                  onChanged: (val){
                    print(hasAgreed);
                    setState(() {
                      hasAgreed = !hasAgreed;
                    });
                    print(hasAgreed);
                    widget.hasUserAgreed(hasAgreed);
                    print("Not called");
                  },
              ),
              SizedBox(
                width: 300,
                child: Container(
                  width: 300,
                  child: Text(
                      'food_submission_agreement'.tr(),
                    style: TextStyle(
                        fontSize: isTablet ? 11.sp : 15.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondaryContainer)
                  ),
                ),
              )
            ],
          ),
          StepperControlButtons(
            isFirst: true,
            next: () async {
              if(hasAgreed == false){
               return await QuickAlert.show(
                  context: context,
                  barrierDismissible: true,
                  type: QuickAlertType.warning,
                  showCancelBtn: false,
                  showConfirmBtn: true,
                  title: "food_submission_agreement_title".tr(),
                  text: 'food_submission_agreement'.tr(),
                  titleAlignment: TextAlign.center,
                  textAlignment: TextAlign.center,
                  confirmBtnText: 'food_submission_agreement_title'.tr(),
                  onConfirmBtnTap: (){
                    setState(() {
                      hasAgreed = true;
                    });                 // Navigator.pop(context);
                  },
                  confirmBtnColor: Colors.red,
                  cancelBtnTextStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold
                  ),
                  backgroundColor: Colors.white,
                  headerBackgroundColor: Colors.grey,
                  confirmBtnTextStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  barrierColor: Colors.red,
                  titleColor: Colors.red,
                  textColor: Colors.red,
                );
                return;
              }
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
        child: Text("image_is_required".tr(),
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}
