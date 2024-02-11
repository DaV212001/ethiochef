import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/language.dart';
import '../../theme/app_theme.dart';
import '../../utils/screen_utils.dart';
import '../main_button.dart';

class SubscriptionCard extends StatefulWidget {
  final String plan;
  final String price;
  final String duration;
  final String buttonName;
  final Function() onTap;
  const SubscriptionCard({super.key,
  required this.plan,
    required this.price,
    required this.duration,
    required this.buttonName,
    required this.onTap
  });

  @override
  State<SubscriptionCard> createState() => _SubscriptionCardState();
}

class _SubscriptionCardState extends State<SubscriptionCard> {
  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        borderRadius: AppTheme.allBorderRadius,
        color: Color(0xFFF8FAFC),
        border: Border.all(
      color: theme.colorScheme.primary,
        width: 0.3
      )
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Text(
            widget.plan!,
            style: TextStyle(
                fontSize: isTablet ? 18.sp : 23.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.primary),
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            '${Language.getLocaleCode() == 'en'? 'Birr': "ብር"} ${widget.price}',
            style: TextStyle(
                fontSize: isTablet ? 11.sp : 15.sp,
                fontWeight: FontWeight.w600,
                color: theme.colorScheme.surface),
          ),
          // if(widget.duration != '0')Text('${Language.getLocaleCode() == 'en'? 'Good until': "እስከ"}: ${widget.duration}',
        if(widget.duration != '0')Text('${widget.duration}',
              style: TextStyle(
                  fontSize: isTablet ? 11.sp : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.surface)),
          SizedBox(
            height: 20.h,
          ),
          MainButton(
              width: 200.w,
              text: widget.buttonName,
              onPress: widget.onTap
          )
        ],
      ),
    );
  }
}
