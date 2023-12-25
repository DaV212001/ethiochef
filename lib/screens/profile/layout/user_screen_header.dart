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
import '../../../models/user_profile.dart';
import '../../../services/user_service.dart';
import '../../../theme/app_theme.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/profile/profile_widget.dart';

class UserScreenHeader extends StatefulWidget {
  final UserProfile user;
  final Function() reFresh;
  UserScreenHeader({super.key, required this.user, required this.reFresh});

  @override
  State<UserScreenHeader> createState() => _UserScreenHeaderState();
}

class _UserScreenHeaderState extends State<UserScreenHeader> {
  final double coverHeight = 210.h;
  final double imageHeight = 144.w;
  final picker = ImagePicker();
  late var profilePicture;
  bool isFile = false;

  @override
  void initState() {
    if(widget.user.user?.profile_picture !=null) {
      print("pic my ${widget.user.user?.profile_picture}");
      profilePicture = widget.user.user?.profile_picture;
    }else{
      profilePicture = null;
    }
    print("pic my this ${profilePicture}");
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    String? firstName = widget.user.user?.firstName;
    String? lastName = widget.user.user?.lastName;
    String formattedName = "${firstName} ${lastName}";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          ProfileWidget(
            isUpdateScreen: false,
            imagePath: widget.user.user?.profile_picture,
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
               if(widget.user.user?.email != '')
               SizedBox(height: 5.h),
               if(widget.user.user?.email != '')
               Text(widget.user.user?.email ?? '',
                   style:
                   TextStyle(color: theme.colorScheme.tertiary.withOpacity(0.5), fontSize: 15.sp)),
             ],
           ),
         ),
          SizedBox(width: 5.h),
          ElevatedButton(onPressed: (){
            String? str = widget.user.user?.phone.toString();
            String? phone = str?.substring(1);
            print(phone);
            pushNewScreen(context,
                screen: UpdateProfileScreen(
                  imagePath: profilePicture,
                  hasEditButton: false,
                  isFile: isFile,
                  email: widget.user.user?.email ?? '',
                  firstName: widget.user.user!.firstName,
                  lastName: widget.user.user!.lastName,
                  phone: phone.toString(),
                  reFresh: (){
                    print("call this");
                    widget.reFresh();
                  }
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
        profilePicture = File(pickedFile.path);
        isFile = true;
        updatePicture();
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
        updatePicture();
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
            child: Text('photo_gallery'.tr(),
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
  Future updatePicture() async {
    var response;
    final bool isTablet = ScreenUtils.isTablet(context);
    SnackBar success = SnackBar(
        content: Text(
          "Profile picture updated successfully",//todo localization
          style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
        ));
    SnackBar failed = SnackBar(
        content: Text(
          "Profile picture updated failed",
          style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
        ));
    try {
      UserService service = UserService();
      response = await service.updateProfile(
          widget.user.user!.firstName,
          widget.user.user!.lastName,
          widget.user.user!.email.toString(),
          widget.user.user!.phone.toString(),
          profilePicture);
      print("==========response1 ==== ${response.statusCode}");
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(success);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(failed);
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(failed);
    }
    return response;
  }
}
