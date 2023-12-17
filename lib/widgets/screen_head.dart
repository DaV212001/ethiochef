import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/notification_icon.dart';
import 'package:ethio_chef/widgets/search_input_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ScreenHead extends StatelessWidget {
  final int screen;
  final String searchHint;
  final bool hasNotification;

  const ScreenHead(
      {super.key,
        required this.hasNotification,
        required this.screen,
        required this.searchHint});

  @override
  Widget build(BuildContext context) {
    bool isHomeScreen = screen == 0;
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Color(0xFFF8FAFC),
          borderRadius:  BorderRadius.only(
            topLeft:  Radius.circular(isHomeScreen==true ? 20:0),
            topRight: Radius.circular(isHomeScreen==true ? 20:0),
          )),
      child: Row(
        mainAxisAlignment: isHomeScreen
            ? MainAxisAlignment.spaceBetween
            : MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SearchInputField(
            enabled: true,
            hint: searchHint, screen: screen,
          ),
          SizedBox(
            width: 15.w,
          ),
          NotificationIcon(
            hasNotification: hasNotification,
          ),
        ],
      ),
    );
  }
}