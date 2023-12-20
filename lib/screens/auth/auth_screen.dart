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
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [LanguageSelectorButton()],
        ),
        body: SingleChildScrollView(
          child: Container(
            width: double.infinity,
            child: widget.isSignIn ? SignIn() : SignUp(),
          ),
        ));
  }
}
