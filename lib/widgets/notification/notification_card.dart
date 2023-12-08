
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';

import '../../models/notification.dart';
import '../../utils/screen_utils.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
class NotificationCard extends StatefulWidget {
  final bool isRead;
  final Function() delete;
  final Function() reFresh;
  final NotificationData data;

  const NotificationCard({super.key,
    required this.data,
    required this.delete,
    required this.reFresh,
    required this.isRead
  });

  @override
  State<NotificationCard> createState() => _NotificationCardState();
}

class _NotificationCardState extends State<NotificationCard> {

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Slidable(
      key: const ValueKey(0),

      startActionPane: ActionPane(
        motion: const ScrollMotion(),
        dismissible: DismissiblePane(onDismissed: () {}),

        children: widget.isRead == false? [

          SlidableAction(
            onPressed: (context) {
              print("Delete pressed");
              widget.delete();
              widget.reFresh();
            },
            backgroundColor: theme.colorScheme.primaryContainer,
            foregroundColor: Colors.white,
            icon: Icons.check_circle,
            label: 'mark_as_read'.tr(),
          )
        ]:[],
      ),

      child: Container(
        decoration: BoxDecoration(
            color: widget.data.isRead
                ? theme.scaffoldBackgroundColor
                : theme.colorScheme.inverseSurface),
        child: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 10.h,
            horizontal: 15.w,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 15.w,
                    height: isTablet ? 8.h : 13.h,
                  ),Text(
                    '${widget.data.date}',
                    style: TextStyle(fontSize: isTablet ? 10.sp : 12.sp),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                    width: 8.w,
                    height: isTablet ? 8.h : 13.h,
                    decoration: widget.data.isRead
                        ? null
                        : BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.blue,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.title,
                          style: TextStyle(
                              fontSize: isTablet ? 13.sp : 15.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        Text(
                          widget.data.body,
                          style: TextStyle(fontSize: isTablet ? 10.sp : 12.sp),
                        )
                      ],
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      )
    );

  }
}
