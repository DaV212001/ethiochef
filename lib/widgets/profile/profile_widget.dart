import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/user.dart';
import '../../utils/screen_utils.dart';
import '../cached_image.dart';

class ProfileWidget extends StatelessWidget {
  final dynamic imagePath;
  final VoidCallback onClicked;
  final bool isFile;
  final bool hasEditButton;
  final bool isUpdateScreen;
  const ProfileWidget(
      {Key? key,
        required this.imagePath,
        required this.onClicked,
        required this.isFile,
        required this.hasEditButton,
        required this.isUpdateScreen})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20.0),
      child: Column(
        children: [
          Center(
            child: Stack(
              children: [
                buildImage(theme.cardColor, context),
                if (hasEditButton && imagePath != null)
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Ink(
                      color: Colors.white,
                      child: InkWell(
                          onTap: onClicked,
                          child: buildEditIcon(theme.primaryColor)),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(Color color, BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    return ClipOval(
      child: Material(
        color: color,
        child: Ink(
          width: isUpdateScreen?128.w :68.w,
          height: isUpdateScreen? isTablet ? 145.h : 128.h:isTablet ? 75.h : 68.h,
          child: InkWell(
              child: isFile
                  ? Image.file(
                imagePath,
                fit: BoxFit.fill,
              )
                  : imagePath != null
                  ? CachedImage(
                url: imagePath!,
                fit: BoxFit.fill,
              )
                  : IconButton(
                  onPressed: onClicked,
                  icon: Icon(
                    CupertinoIcons.camera,
                    size: 50.sp,
                  ))),
        ),
      ),
    );
  }

  Widget buildEditIcon(Color color) => buildCircle(
    color: Colors.white30,
    all: 3.r,
    child: buildCircle(
      color: color,
      all: 8.r,
      child: Icon(
        Icons.edit,
        color: Colors.black,
        size: 20.sp,
      ),
    ),
  );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
      ClipOval(
        child: Container(
          padding: EdgeInsets.all(all),
          color: color,
          child: child,
        ),
      );
}
