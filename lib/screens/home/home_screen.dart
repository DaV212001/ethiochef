import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/home/layout/category_tab.dart';
import 'package:ethio_chef/widgets/screen_head.dart';
import 'package:ethio_chef/screens/home/layout/recent_dishes.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              ScreenHead(
                hasNotification: true,
                screen: 0,
                searchHint: "search".tr(),
              ),
              CategoryTab(dishes: PlaceHolderData.dishes),
              SizedBox(
                height: 10,
              ),
              RecentDishes(
                dishes: PlaceHolderData.dishes,
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      ),
    );
  }
}
