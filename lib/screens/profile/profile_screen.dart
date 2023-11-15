import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:profile/profile.dart';
import 'package:avatar_glow/avatar_glow.dart';

import '../../widgets/change_theme.dart';
import '../../widgets/main_button.dart';
import 'layout/route_list.dart';
import 'layout/user_screen_header.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: ListView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            children: [
              UserScreenHeader(),
              RouteList(),
              SizedBox(height: 5.h,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MainButton(
                    isLoading: false,
                    text: "Log out".tr(),
                    onPress: () async {

                    }),
              ),
              SizedBox(height: 5.h,),
              Align(
                alignment: Alignment.bottomCenter,
                child: Text("@2023 Copyright EthioChef"),
              ),
              SizedBox(
                height: 45,
              ),
            ],
          ),

      ),
    );
  }
}
