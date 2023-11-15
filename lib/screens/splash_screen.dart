import 'dart:async';
import 'package:flutter/material.dart';

import 'auth/auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  var imageUrls = [
    "assets/images/splash_screen_one.jpg",
    "assets/images/splash_screen_two.jpg",
    "assets/images/splash_screen_three.jpg",
  ];
  int currentIndex = 0;

  late Timer timer;

  @override
  void initState() {
    super.initState();
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) {
      setState(() {
        if (currentIndex < imageUrls.length - 1) {
          currentIndex++;
        } else {
          timer.cancel();
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => const AuthScreen(),
            ),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: AnimatedSwitcher(
        duration: const Duration(seconds: 1),
        child: FadeTransition(
          key: ValueKey<int>(currentIndex),
          opacity: const AlwaysStoppedAnimation<double>(1.0),
          child: Image.asset(
            imageUrls[currentIndex],
            key: ValueKey<int>(currentIndex),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
