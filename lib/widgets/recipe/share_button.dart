import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/screen_utils.dart';

class ShareButton extends StatelessWidget {
  final Food food;
  const ShareButton({super.key, required this.food});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(10),
      child: TextButton(
        onPressed: () {
          String text = "share_recipe".tr();
          Share.shareUri(Uri.parse('https://appdeeplink.ethiochef.com/${food.id}'));
        },
        style: TextButton.styleFrom(
          padding: const EdgeInsets.all(10),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
            // You can adjust the radius
            side: BorderSide(
              color: theme.colorScheme.primary,
              width: 1.0,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.share,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: 10),
            Text(
              "share_recipe".tr(),
              style: TextStyle(
                  fontSize: isTablet ? 15.sp : 20.sp,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.secondaryContainer),
            )
          ],
        ),
      ),
    );
  }
}
