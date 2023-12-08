import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: Card(
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
                text: widget.buttonName,
                onPress: widget.onTap
              )
            ],
          )
      ),
    );
  }
}
