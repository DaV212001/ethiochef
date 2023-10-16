import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/screens/auth/layout/sign_in.dart';
import 'package:ethio_chef/screens/auth/layout/sign_up.dart';
import 'package:ethio_chef/widgets/auth/language_selector_button.dart';
import 'package:flutter/material.dart';

class AuthScreen extends StatefulWidget {
  final bool isSignIn;
  const AuthScreen({super.key, this.isSignIn = true});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [LanguageSelectorButton()],
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: widget.isSignIn ? 0 : 75),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: width,
                      decoration: BoxDecoration(
                          color: theme.colorScheme.surface,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            color: theme.colorScheme.secondaryContainer,
                            width: 1.0,
                          )),
                      margin: EdgeInsets.symmetric(horizontal: 15),
                      padding: EdgeInsets.all(15),
                      child: widget.isSignIn ? SignIn() : SignUp(),
                    ),
                    Positioned(
                        top: -100,
                        left: width / 4,
                        right: width / 4,
                        child: SizedBox(
                            width: 200,
                            height: 200,
                            child: Image.asset(Assets.imagesLogo)))
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
