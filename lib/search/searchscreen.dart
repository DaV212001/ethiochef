import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ethio_chef/widgets/screen_head.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../models/language.dart';
import '../screens/competition/layout/vertical_competition_list.dart';
import '../screens/home/layout/recent_dishes.dart';
import '../utils/place_holder_data.dart';

class SearchScreen extends StatefulWidget {
  final bool homescreen;
  final bool categoryscreen;
  final bool competitionscreen;
  final bool nutritionscreen;

  const SearchScreen({
    super.key,
    required this.homescreen,
    required this.categoryscreen,
    required this.competitionscreen,
    required this.nutritionscreen});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  Widget build(BuildContext context) {
    int throwoffscreennumber = 9;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 8.0),
              child: ScreenHead(
                  hasNotification: false,
                  screen: throwoffscreennumber,
                  searchHint: "search".tr()
              ),
            ),
            // Expanded(
            //   child: ListView.builder(
            //     itemCount: widget.homescreen?4:5,
            //     itemBuilder: (context, index) {
            //       if(widget.homescreen==true){
            //         return ListTile(
            //           leading: CircleAvatar(backgroundImage: NetworkImage(PlaceHolderData.dishes[index].thumbnail)),
            //           title: Text(PlaceHolderData.dishes[index].name[Language.getLocaleCode()].toString()),
            //           subtitle: Text(PlaceHolderData.dishes[index].description!),
            //           onTap: () {},
            //         );
            //       }
            //       // if(widget.categoryscreen==true){
            //       //   return ListTile(
            //       //     leading: CircleAvatar(backgroundImage: NetworkImage(PlaceHolderData.categories[index].image)),
            //       //     title: Text(PlaceHolderData.categories[index].name),
            //       //     onTap: () {},
            //       //   );
            //       // }
            //       if(widget.competitionscreen==true){
            //         return ListTile(
            //           leading: CircleAvatar(backgroundImage: NetworkImage(PlaceHolderData.foodCompetitionList[index].image!)),
            //           title: Text(PlaceHolderData.foodCompetitionList[index].name!),
            //           subtitle: Text(PlaceHolderData.foodCompetitionList[index].description!),
            //           onTap: () {},
            //         );
            //       }
            //
            //       return null;
            //     }
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
