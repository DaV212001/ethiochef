import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("ethio_chef".tr()),
            Row(
              children: [
                TextButton(
                    child: const Text("አማርኛ"),
                    onPressed: () {
                      setState(() {
                        context.setLocale(const Locale('am'));
                      });
                    }),
                TextButton(
                    child: const Text("English"),
                    onPressed: () {
                      setState(() {
                        context.setLocale(const Locale('en'));
                      });
                    }),
                TextButton(
                    child: const Text("Afaan Oromoo"),
                    onPressed: () {
                      setState(() {
                        context.setLocale(const Locale('en', 'GB'));
                      });
                    }),
                TextButton(
                    child: const Text("ትግርኛ"),
                    onPressed: () {
                      setState(() {
                        context.setLocale(const Locale('en', 'AU'));
                      });
                    }),
                TextButton(
                    child: const Text("Somali"),
                    onPressed: () {
                      setState(() {
                        context.setLocale(const Locale('en', 'CA'));
                      });
                    }),
              ],
            )
          ],
        ),
      ),
    );
  }
}
