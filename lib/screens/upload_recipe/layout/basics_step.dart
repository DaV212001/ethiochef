import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/competition/competitions_screen.dart';
import 'package:ethio_chef/widgets/input_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/image_field.dart';
import 'package:ethio_chef/widgets/upload_recipe/stepper_control_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../generated/assets.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/main_button.dart';

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
          Column(
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
                height: 20,
              ),
            ],
          ),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
                border: Border.all(
                    color: theme.colorScheme.primary,
                    width: 1
                )
            ),
            child: Column(
              children: [
                Text(
                  'do_you_have_skills_title'.tr(),
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.primary),),
                Text(
                  'do_you_have_skills_description'.tr(),
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondaryContainer),),
                SizedBox(
                  height: 10,
                ),
                Text(
                  'buy_your_food'.tr(),
                  style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                      color: theme.colorScheme.secondaryContainer),),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: supportButton(Colors.blue, 'https://t.me/ethiochef_support', Assets.socialTelegram, isTablet),
                )

              ],
            ),
          ),
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
                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) {
                    return Dialog(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.r),
                        ),
                        backgroundColor: Theme
                            .of(context)
                            .cardColor,
                        child: Container(
                          height: isTablet ? 600.h : 450.h,
                          width: isTablet ? 275.w : 400.w,
                          padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                          margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Icon(
                                Icons.error,
                                color: theme.colorScheme.error,
                                size: 50,
                              ),
                              Text(
                                "food_submission_agreement_title".tr(),
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontSize: 20.sp,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              Text(
                                "food_submission_agreement".tr(),
                                style: TextStyle(
                                  color: theme.colorScheme.tertiary,
                                  fontWeight: FontWeight.normal,
                                  fontSize: 15.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  MainButton(
                                      text: 'food_submission_agreement_title'.tr(),
                                      onPress: () async {
                                        setState(() {
                                          hasAgreed = true;
                                        });
                                        Navigator.pop(context);
                                      }),
                                  SizedBox(height: 10.h),
                                  TextButton(
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      child: Text(
                                        "cancel".tr(),
                                        style:
                                        TextStyle(color: theme.colorScheme.primary, fontSize: 14.sp),
                                      ))
                                ],
                              )
                            ],
                          ),
                        )
                    );
                  },
                );
              }else {
                if (!_formKey.currentState!.validate()) {
                  imageStatus();
                  return;
                }
                imageStatus();
                if (currentImage == null) {
                  return;
                }

                widget.updateControllers(
                    widget.nameController,
                    widget.descriptionController,
                    widget.prepTimeController,
                    widget.servingSizeController,
                    currentImage);
                widget.next();
              }
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
