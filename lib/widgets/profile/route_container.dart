import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/profile/route_card.dart';
import 'package:ethio_chef/widgets/profile/route_labels_card.dart';
import 'package:flutter/material.dart';

import '../../theme/app_theme.dart';

class RouteContainer extends StatelessWidget {
  // Widget widget;
  final int indexTwo;
  final String routeName;
  final List<Map<String, dynamic>> routePart;
  RouteContainer({super.key,
  // required this.widget,
    required this.routePart,
    required this.indexTwo,
    required this.routeName
});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0,),
    decoration: BoxDecoration(
    color: theme.colorScheme.onSecondary.withOpacity(0.2),
    borderRadius: AppTheme.allBorderRadius),
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: routePart.length,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return Column(
            children: [
              index ==0? RouteLabelCards(text: routeName):SizedBox.shrink(),
              RouteCard(
                onTap: routePart[index]["onTap"],
                title: routePart[index]["title"],
                icon: routePart[index]["leadingIcon"]
              ),
              index ==indexTwo? SizedBox.shrink(): Divider(
                thickness: 1,
                height: 1,
                color: theme.colorScheme.primary
              )
            ],
          );
        },
      )
      ));
  }
}
