import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../theme/app_theme.dart';
import '../../utils/screen_utils.dart';
import '../cached_image.dart';

class RectangularPaymentCard extends StatefulWidget {
  final String image_url;
  final String payment_name;
  final VoidCallback press;

  RectangularPaymentCard(
      {super.key,
        required this.image_url,
        required this.payment_name,
        required this.press});

  @override
  State<RectangularPaymentCard> createState() => _RectangularPaymentCardState();
}

class _RectangularPaymentCardState extends State<RectangularPaymentCard> {
  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
          onTap: widget.press,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: 90,
                  width: 200,
                  decoration: BoxDecoration(
                    color: theme.cardColor,
                    borderRadius: AppTheme.allBorderRadius
                  ),
                  child: ClipRRect(
                    borderRadius: AppTheme.allBorderRadius,
                    child: CachedImage(
                      url: widget.image_url,
                      fit: BoxFit.contain
                    ),
                  ),
                ),
                Text(widget.payment_name,
                    style: TextStyle(
                    fontSize: isTablet ? 11.sp : 15.sp,
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.primary),)
              ])),
    );
  }
}
