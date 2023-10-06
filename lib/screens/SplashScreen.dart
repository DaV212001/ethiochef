import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:ethio_chef/screens/main_screen.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
        splashIconSize: 250,
        splash: Image.asset(
          'assets/images/logo.png',
          fit: BoxFit.fill,
        ),
        animationDuration: const Duration(microseconds: 2500),
        nextScreen: const MainScreen(),
        splashTransition: SplashTransition.scaleTransition,
        pageTransitionType: PageTransitionType.bottomToTop);
  }
}
