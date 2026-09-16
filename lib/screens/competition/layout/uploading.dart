import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../../utils/screen_utils.dart';

class Uploading extends StatefulWidget {
  const Uploading({super.key});

  @override
  State<Uploading> createState() => _UploadingState();
}

class _UploadingState extends State<Uploading> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "uploading_title".tr,
          style: TextStyle(color: theme.colorScheme.primary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                child: Text(
                  "uploading_title".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.colorScheme.primary,
                    fontSize: isTablet ? 18.sp : 20.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                child: Text(
                  "uploading_body".tr,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: theme.unselectedWidgetColor,
                    fontSize: isTablet ? 12.sp : 15.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
