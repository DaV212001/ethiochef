import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/notification_icon.dart';
import 'package:ethio_chef/widgets/search_input_field.dart';
import 'package:flutter/material.dart';

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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: isHomeScreen
                ? MainAxisAlignment.spaceBetween
                : MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (isHomeScreen)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "hello_user".tr(args: ["Dagim"]),
                      style: theme.textTheme.headlineLarge,
                    ),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    // Text(
                    //   "lets_make_dinner".tr(),
                    //   style: theme.textTheme.headlineSmall
                    //       ?.copyWith(color: theme.colorScheme.shadow),
                    // )
                  ],
                ),
              NotificationIcon(
                hasNotification: hasNotification,
              ),
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SearchInputField(
            enabled: true,
            hint: searchHint,
          ),
        ],
      ),
    );
  }
}
