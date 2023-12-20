import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecipeStatusHeaderImage extends StatelessWidget {
  final File? image;
  const RecipeStatusHeaderImage(
      {super.key,
        required this.image
      });
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return Stack(children: [
      SizedBox(
        width: width,
        height: height * 0.4,
        child: ClipRRect(
          child: image! !=null?Image.file(
              image!,
              fit: BoxFit.fill
          ):Image.asset(
            'assets/images/logo.png',
            fit: BoxFit.fill,
            height: 100.h,
            width: 100.w,
          ),
        ),
      ),
      Positioned(
        top: 5,
        right: 10,
        left: 10,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: circularBackground(
                    child: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.onSecondary,
                    ), context: context,
                  ))
            ],
          ),
        ),
      )
    ]);
  }

  Widget circularBackground({required Widget child, required BuildContext context}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: Theme.of(context).colorScheme.onPrimary),
      child: child,
    );
  }
}