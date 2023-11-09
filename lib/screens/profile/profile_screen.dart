import 'package:flutter/material.dart';
import 'package:profile/profile.dart';
import 'package:avatar_glow/avatar_glow.dart';

import '../../widgets/change_theme.dart';
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
            children: [
              UserHeader(),
              RouteList(),
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
