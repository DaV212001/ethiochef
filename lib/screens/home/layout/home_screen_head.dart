import 'package:ethio_chef/widgets/search_input_field.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreenHead extends StatelessWidget {
  final bool hasNotification;

  const HomeScreenHead({super.key, required this.hasNotification});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Hello, Dagim",
                    style: theme.textTheme.headlineLarge,
                  ),
                  SizedBox(height: 10,),
                  Text(
                    "Let's make dinner",
                    style: theme.textTheme.headlineSmall
                        ?.copyWith(color: theme.colorScheme.shadow),
                  )
                ],
              ),
              Stack(
                  children: [
                    Icon(
                      CupertinoIcons.bell,
                      color: theme.colorScheme.tertiary,
                      size: 35,
                    ),
                    Visibility(
                      visible: hasNotification != 0,
                      child: Positioned(
                        top: 0,
                        right: 3,
                        child: GestureDetector(
                          onTap: () {},
                          child: GlowingOverscrollIndicator(
                            axisDirection: AxisDirection.up,
                            color: theme.colorScheme.primary,
                            child: CircleAvatar(
                              radius: 5,
                              backgroundColor: theme.colorScheme.primary,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ]),],
          ),
          SizedBox(height: 10,),
          SearchInputField(enabled: true,),
        ],
      ),
    );
  }
}
