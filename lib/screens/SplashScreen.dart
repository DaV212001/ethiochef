import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/utils/theme/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ModelTheme>(
        builder: (context, ModelTheme themeNotifier, child) {
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
              ),
              IconButton(
                  onPressed: () {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                  },
                  icon: const Icon(Icons.dark_mode))
            ],
          ),
        ),
      );
    });
  }
}
