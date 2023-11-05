
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../../theme/model_theme.dart';
import '../../../widgets/auth/language_selector_button.dart';
import '../../../widgets/change_theme.dart';
import '../../../widgets/profile/route_card.dart';
import '../../../widgets/profile/route_labels_card.dart';


class RouteList extends StatefulWidget {
  const RouteList({super.key});

  @override
  State<RouteList> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ModelTheme>(context);
    ThemeData theme = Theme.of(context);
    final List<Map<String, dynamic>> itemList = [
      {
        "title": "change_profile".tr(),
        "leadingIcon": Icons.account_circle_outlined,
        "onTap": () {
          print("change_profile");
          // pushNewScreen(
          //   context,
          //   screen: UpdateProfileScreen(),
          //   withNavBar: false,
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
        },
        "trailing": Icon(Icons.chevron_right_outlined,
            color: theme.colorScheme.primary),
      },
      {
        "title": "change_password".tr(),
        "leadingIcon": Icons.password,
        "onTap": () {
          print("change_password");
          // pushNewScreen(
          //   context,
          //   screen: ChangePassword(),
          //   withNavBar: false,
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
      {
        "title": "change_theme".tr(),
        "leadingIcon": themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
        "onTap": (){

        },
        "trailing": Text("")
      },
      {
        "title": "change_language".tr(),
        "leadingIcon": Icons.language,
        "onTap": (){

        },
        "trailing": Text(""),

      },
      {
        "title": "privacy_policy".tr(),
        "leadingIcon": Icons.privacy_tip_outlined,
        "onTap": () {
          print("privacy_policy");
          // pushNewScreen(
          //   context,
          //   screen: PrivacyPolicyScreen(),
          //   withNavBar: false,
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
      {
        "title": "faq".tr(),
        "leadingIcon": Icons.question_mark,
        "onTap": () {
          print("faq");
          // pushNewScreen(
          //   context,
          //   screen: FAQScreen(),
          //   withNavBar: false,
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
      {
        "title": "terms_and_conditions".tr(),
        "leadingIcon": Icons.error,
        "onTap": () {
          print("terms_and_conditions");
          // pushNewScreen(
          //   context,
          //   screen: TermsAndConditionScreen(),
          //   withNavBar: false,
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
      {
        "title": "about".tr(),
        "leadingIcon": Icons.info_outline_rounded,
        "onTap": () {
          print("about");
          // pushNewScreen(
          //   context,
          //   screen: AboutScreen(),
          //   withNavBar: false,
          //   pageTransitionAnimation: PageTransitionAnimation.cupertino,
          // );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      }
    ];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0),
      child: Container(
        decoration: BoxDecoration(
            color: theme.buttonTheme.colorScheme?.primaryContainer,
            borderRadius: BorderRadius.circular(10)),
        child: ListView.builder(
          shrinkWrap: true,
          physics: BouncingScrollPhysics(),
          itemCount: itemList.length,
          itemBuilder: (context, index) {
            final item = itemList[index];
            final specialIcon = item["special_icon"];
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: index==0?RouteLabelCards(text: tr("profile")):
                    index==2?RouteLabelCards(text: tr("general")):
                    index==4?RouteLabelCards(text: tr("documentation"))
                  :null,
                  ),
                  RouteCard(
                    onTap: item["onTap"],
                    title: item["title"],
                    icon: item["leadingIcon"],
                  ),
                  index != itemList.length - 1
                      ? Divider(
                    thickness: 1,
                    height: 1,
                  )
                      : SizedBox()
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

