import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/services/user_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';

import '../../../models/user.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/auth/phone_input_field.dart';
import '../../../widgets/input_field.dart';
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
  const UpdateProfileScreen({super.key,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    required this.hasEditButton,
    required this.imagePath,
    required this.isFile,
  });

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  File? updatedProfilePicture;

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneNumberController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  // late var profilePicture;
  bool isFile = false;
  bool awaitResponse = false;

  @override
  void initState() {
    // User.profilePicture = null;
    firstNameController.text = widget.firstName;
    lastNameController.text = widget.lastName;
    emailController.text = widget.email;
    phoneNumberController.text = widget.phone;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.primary,
              )),
        ),
        body: Form(
          key: formKey,
          child: Padding(
            padding: EdgeInsets.only(
                left: isTablet ? 80.w : 40.w,
                right: isTablet ? 80.w : 40.w,
                top: isTablet ? 50.h : 10.h
            ),
            child: ListView(
              scrollDirection: Axis.vertical,
              children: [
                ProfileWidget(
                    isUpdateScreen: true,
                  imagePath: widget.imagePath,
                  hasEditButton: widget.isFile || widget.imagePath != null,
                  isFile: widget.isFile,
                  onClicked: showOptions
                ),
                SizedBox(height: 15.h),
                // Row(
                //   children: [
                    InputField(
                      controller: firstNameController,
                      icon: CupertinoIcons.person,
                      label: 'first_name'.tr(),
                      hint: "your_first_name".tr(),
                      type: InputField.NameType,
                    ),
                    // SizedBox(height: 100,),
                    InputField(
                      controller: lastNameController,
                      icon: CupertinoIcons.person,
                      label: 'last_name'.tr(),
                      hint: "your_last_name".tr(),
                      type: InputField.NameType,
                    ),
                //   ],
                // ),
                SizedBox(height: 20.h),
                InputField(
                  controller: emailController,
                  icon: CupertinoIcons.mail,
                  label: "email".tr(),
                  hint: "your_email".tr(),
                  type: InputField.EmailType,
                ),
                PhoneInputField(controller: phoneNumberController),
                SizedBox(height: 20.h),
                MainButton(text: "update".tr(), onPress: () async{
                  UserService userService = UserService();
                  String trial = await userService.updateUserProfile(
                    firstNameController.text,
                    lastNameController.text,
                    emailController.text,
                    phoneNumberController.text,
                    updatedProfilePicture!
                  );
ScaffoldMessenger.of(context).showSnackBar(
  SnackBar(
    content: Text(
      trial
    )
  )
);
                }),
              ],
            ),
          ),
        ));
  }


  // Future<http.Response> updateUserAccount(
  //     String first_name, String last_name) async {
  //   //TODO: MOVE TO USER SERVICE
  //   // Set the API endpoint
  //   final Uri url = Uri.https("");
  //   // Get the access token from shared preferences
  //   final SharedPreferences shared = await SharedPreferences.getInstance();
  //   var access_token = shared.getString('access_token');
  //
  //   // Create the request body
  //   final body = {
  //     'first_name': first_name,
  //     'last_name': last_name,
  //     'profile_picture': "profile_picture"
  //   };
  //
  //   // Add the access token to the request headers
  //   final headers = {
  //     'Content-Type': 'application/json',
  //     'Authorization': 'Bearer $access_token'
  //   };
  //
  //   // Make the POST request
  //   final response = await http.post(
  //     url,
  //     headers: headers,
  //     body: jsonEncode(body),
  //   );
  //
  //   return response;
  // }

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        updatedProfilePicture = File(pickedFile.path);
        isFile = true;
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        updatedProfilePicture = File(pickedFile.path);
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
            child: Text('Photo Gallery',),
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
}
