import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 90,
        ),
        Text(
          "Welcome Back",
          style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 22,
            letterSpacing: 0.2,
            color: theme.colorScheme.tertiary,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          "Let's get back to cooking a masterpiece",
          style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.tertiary
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Container(
          height: 75,
          child: TextFormField(
            maxLength: 9,
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: InputDecoration(
              prefixIcon: Icon(CupertinoIcons.phone),
              labelText: 'Phone Number',
              prefixText: '+251 ',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        Container(
          width: double.infinity,
          height: 65,
          padding: EdgeInsets.symmetric(vertical: 10),
          child: ElevatedButton(
            onPressed: () {},
            child: Text("SignIn"),
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Don't have an account?",
              style: theme.textTheme.headlineSmall?.copyWith(
                color: theme.colorScheme.tertiary.withOpacity(0.8),
              ),
            ),
            TextButton(
              onPressed: () {
                // Handle sign-up action
              },
              child: Text(
                "Sign up",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
