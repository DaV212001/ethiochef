import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/notification.dart';
import '../../utils/screen_utils.dart';

class NotificationCard extends StatefulWidget {
  final bool isRead;
  final Function() delete;
  final Function() reFresh;
  final NotificationData data;

  const NotificationCard({
    super.key,
    required this.data,
    required this.delete,
    required this.reFresh,
    required this.isRead,
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
      key: ValueKey(widget.data.id),
      startActionPane: widget.isRead == false
          ? ActionPane(
              motion: const ScrollMotion(),
              dragDismissible: false,
              children: [
                SlidableAction(
                  onPressed: (context) {
                    print("Delete pressed");
                    widget.delete();
                    widget.reFresh();
                  },
                  backgroundColor: theme.colorScheme.primaryContainer,
                  foregroundColor: theme.colorScheme.primary,
                  icon: Icons.check_circle,
                  label: 'mark_as_read'.tr,
                ),
              ],
            )
          : null,
      child: Container(
        decoration: widget.data.isRead == false
            ? BoxDecoration(color: theme.colorScheme.inverseSurface)
            : null,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 15.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(width: 15.w, height: isTablet ? 8.h : 13.h),
                  Text(
                    DateFormat.yMMMd().format(widget.data.date),
                    style: TextStyle(
                      fontSize: isTablet ? 10.sp : 12.sp,
                      fontWeight: FontWeight.w400,
                      color: theme.colorScheme.secondaryContainer,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  if (widget.data.isRead == false)
                    Container(
                      width: 8.w,
                      height: isTablet ? 8.h : 13.h,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue,
                      ),
                    ),
                  if (widget.data.isRead == false) SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.data.title,
                          style: TextStyle(
                            fontSize: isTablet ? 11.sp : 15.sp,
                            fontWeight: FontWeight.w600,
                            color: theme.colorScheme.primary,
                          ),
                        ),
                        SizedBox(height: 5.h),
                        Text(
                          widget.data.body,
                          style: TextStyle(
                            fontSize: isTablet ? 10.sp : 13.sp,
                            fontWeight: FontWeight.w400,
                            color: theme.colorScheme.secondaryContainer,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
