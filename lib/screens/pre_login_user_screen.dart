import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

class PreLoginUserScreen extends StatefulWidget {
  const PreLoginUserScreen({super.key});

  @override
  State<PreLoginUserScreen> createState() => _PreLoginUserScreenState();
}

class _PreLoginUserScreenState extends State<PreLoginUserScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.perm_identity_outlined,
            size: 100.sp,
          ),
          SizedBox(height: 10.h),
          Text(
            "welcome_back_body".tr(),
            style: TextStyle(fontSize: 15.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 15.h),
          MainButton(
            width: 200.w,
            onPress: () {
              PersistentNavBarNavigator.pushNewScreen(
                context,
                screen: const AuthScreen(isSignIn: true),
                withNavBar: false,
                pageTransitionAnimation: PageTransitionAnimation.cupertino,
              );
            },
            text: 'sign_in_button'.tr(),
          )
        ],
      ),
    ));
  }
}
