
import 'package:avatar_glow/avatar_glow.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class UserHeader extends StatefulWidget {
  const UserHeader({super.key});

  @override
  State<UserHeader> createState() => _UserHeaderState();
}

class _UserHeaderState extends State<UserHeader> {

  final double coverHeight = 150;
  final double profileHeight = 124;


  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        buildBody(),
        buildContent()
      ],
    );
  }
  Widget buildBody(){
    final bottom = profileHeight / 2;
    final top = coverHeight - profileHeight / 2;
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Container(
            margin: EdgeInsets.only(bottom: bottom),
            child: buildCoverImage()
        ),
        Positioned(
          top: top,
          child: buildProfileImage(),
        )
      ],
    );
  }
  Widget buildCoverImage(){
    ThemeData theme = Theme.of(context);
    return Container(
      height: coverHeight,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFFD2691E), Color(0xFFFEC20A)]),
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(50),
            bottomRight: Radius.circular(50),
          )),
    );
  }
  Widget buildProfileImage()=>AvatarGlow(
      glowColor: Color(0xFFFEC20A),
      endRadius: profileHeight/2,
      duration: Duration(milliseconds: 2000),
      repeat: true,
      showTwoGlows: true,
      repeatPauseDuration: Duration(milliseconds: 100),
      child: Material(     // Replace this child with your own
        elevation: 8.0,
        shape: CircleBorder(),
        child: CircleAvatar(
          backgroundColor: Colors.grey[100],
          child: Image.asset(
              'assets/images/logo.png',
              height: 80
          ),
          radius: profileHeight/2,
        ),
      )
  );
  Widget buildContent() {
    ThemeData theme = Theme.of(context);
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 10,),
          Text(
            "hello_user".tr(args: ["Dagim"]),
            style: theme.textTheme.headlineLarge,
          ),
          SizedBox(height: 10,),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(tr("subscription_date")),
              Text(":"),
              Text(" 2 months ",style: theme.textTheme.headlineLarge,)
            ],
          ),
          SizedBox(height: 10,),
        ]
    );
  }
}
