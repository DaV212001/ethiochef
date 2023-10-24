import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        splashIconSize: 250,
        splash: Image.asset(
          Assets.imagesLogo,
          fit: BoxFit.fill,
        ),
        animationDuration: const Duration(microseconds: 2500),
        nextScreen: const AuthScreen(),
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.bottomToTop);
  }
}
