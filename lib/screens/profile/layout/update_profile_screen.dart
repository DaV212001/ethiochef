import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../services/user_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/auth/phone_input_field.dart';
import '../../../widgets/input_field.dart';
import '../../../widgets/main_app_bar.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/profile/profile_widget.dart';

class UpdateProfileScreen extends StatefulWidget {
  // final User user;
  final dynamic imagePath;
  final bool isFile;
  final bool hasEditButton;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final Function() reFresh;
  const UpdateProfileScreen({
    super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.hasEditButton,
    required this.imagePath,
    required this.isFile,
    required this.reFresh,
  });

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  late var profilePicture = null;
  bool isFile = false;
  bool isLoading = false;

  @override
  void initState() {
    // User.profilePicture = null;
    firstNameController.text = widget.firstName ?? '';
    lastNameController.text = widget.lastName ?? '';
    emailController.text = widget.email ?? '';
    if (widget.phone != '') {
      String formattedNumber = widget.phone.substring(2);
      phoneNumberController.text = formattedNumber;
    }
    profilePicture = widget.imagePath;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
      appBar: MainAppBar(title: "edit".tr, hasMainIcons: false),
      body: Form(
        key: formKey,
        child: Padding(
          padding: EdgeInsets.only(
            left: isTablet ? 80.w : 40.w,
            right: isTablet ? 80.w : 40.w,
            top: isTablet ? 50.h : 10.h,
          ),
          child: ListView(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            children: [
              ProfileWidget(
                imagePath: profilePicture,
                hasEditButton: isFile || profilePicture != null,
                isFile: isFile,
                onClicked: showOptions,
                isUpdateScreen: true,
              ),
              SizedBox(height: 15.h),
              // Row(
              //   children: [
              InputField(
                controller: firstNameController,
                icon: CupertinoIcons.person,
                label: 'first_name'.tr,
                hint: "your_first_name".tr,
                type: InputField.NameType,
              ),
              // SizedBox(height: 100,),
              InputField(
                controller: lastNameController,
                icon: CupertinoIcons.person,
                label: 'last_name'.tr,
                hint: "your_last_name".tr,
                type: InputField.NameType,
              ),
              //   ],
              // ),
              SizedBox(height: 20.h),
              InputField(
                controller: emailController,
                icon: CupertinoIcons.mail,
                label: "email".tr,
                hint: "your_email".tr,
                type: InputField.EmailType,
              ),
              PhoneInputField(controller: phoneNumberController),
              SizedBox(height: 20.h),
              MainButton(
                isLoading: isLoading,
                text: "edit".tr,
                onPress: () async {
                  setState(() {
                    isLoading = true;
                  });
                  UserService userService = UserService();
                  print("Updating");
                  print(profilePicture);
                  var response;
                  if (profilePicture is File || profilePicture == null) {
                    response = await userService.updateProfile(
                      firstNameController.text,
                      lastNameController.text,
                      emailController.text,
                      phoneNumberController.text,
                      profilePicture,
                    );
                  }
                  if (profilePicture is String) {
                    response = await userService.updateWithStringProfile(
                      firstNameController.text,
                      lastNameController.text,
                      emailController.text,
                      phoneNumberController.text,
                      profilePicture,
                    );
                  }

                  if (response.statusCode == 200) {
                    SnackBar success = SnackBar(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      content: Text("profile_update_successful".tr),
                    );
                    await ScaffoldMessenger.of(context).showSnackBar(success);
                    widget.reFresh();
                    Navigator.pop(context);
                  } else {
                    SnackBar failed = SnackBar(
                      padding: EdgeInsets.symmetric(vertical: 20),
                      content: Text("profile_update_failed".tr),
                    );
                    await ScaffoldMessenger.of(context).showSnackBar(failed);
                  }
                  setState(() {
                    isLoading = false;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        profilePicture = File(pickedFile.path);
        isFile = true;
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        profilePicture = File(pickedFile.path);
        isFile = true;
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
            child: Text('photo_gallery'.tr),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text('camera'.tr),
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
}
