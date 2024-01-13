import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
        color: theme.colorScheme.tertiaryContainer
      ),
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Text(
            widget.plan!,
            style: Theme
                .of(context)
                .textTheme
                .headlineMedium,
          ),
          SizedBox(
            height: 20.h,
          ),
          Text(
            'Price: ${widget.price
                .toString()}',
            style: Theme
                .of(context)
                .textTheme
                .bodyMedium,
          ),
          if(widget.duration != '0')Text('Duration: ${widget.duration}'),
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
