import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/profile/layout/update_profile_screen.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_picker/image_picker.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../models/user.dart';
import '../../../widgets/profile/profile_widget.dart';

class UserScreenHeader extends StatefulWidget {
  final User user;
  UserScreenHeader({super.key, required this.user});

  @override
  State<UserScreenHeader> createState() => _UserScreenHeaderState();
}

class _UserScreenHeaderState extends State<UserScreenHeader> {
  final double coverHeight = 210.h;
  final double imageHeight = 144.w;
  final picker = ImagePicker();
  // late var profilePicture;
  bool isFile = false;

  @override
  void initState() {
    // User.profilePicture = null;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    String firstName = widget.user.firstName;
    String lastName = widget.user.lastName;
    String formattedName = "${firstName} ${lastName}";
        // "${firstName[0].toUpperCase()}${firstName.substring(1).toLowerCase()} ${lastName[0].toUpperCase()}${lastName.substring(1).toLowerCase()}";

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileWidget(
            isUpdateScreen: false,
            imagePath: User.profilePicture,
            hasEditButton: false,
            isFile: isFile,
            onClicked: showOptions,
          ),
          SizedBox(width: 10.h),
         Expanded(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Text("$formattedName",
                   style: TextStyle(color: theme.colorScheme.tertiary, fontSize: 20.sp)),
               SizedBox(height: 5.h),
               Text(widget.user.email ?? '',
                   style:
                   TextStyle(color: theme.colorScheme.tertiary.withOpacity(0.5), fontSize: 15.sp)),
             ],
           ),
         ),
          SizedBox(width: 5.h),
          ElevatedButton(onPressed: (){
            pushNewScreen(context,
                screen: UpdateProfileScreen(
                  imagePath: User.profilePicture,
                  hasEditButton: false,
                  isFile: isFile,
                  email: widget.user.email ?? '',
                  firstName: widget.user.firstName,
                  lastName: widget.user.lastName,
                  phone: widget.user.phone.toString(),
                ));
          }, child: Text("edit".tr()))
        ],
      ),
    );
  }

  //Image Picker function to get image from gallery
  Future getImageFromGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        User.profilePicture = File(pickedFile.path);
        isFile = true;
      }
    });
  }

  //Image Picker function to get image from camera
  Future getImageFromCamera() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        User.profilePicture = File(pickedFile.path);
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
            child: Text(
              'photo_gallery'.tr(),
              style: TextStyle(fontSize: 20.sp),
            ),
            onPressed: () {
              // close the options modal
              Navigator.of(context).pop();
              // get image from gallery
              getImageFromGallery();
            },
          ),
          CupertinoActionSheetAction(
            child: Text(
              'camera'.tr(),
              style: TextStyle(fontSize: 20.sp),
            ),
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
