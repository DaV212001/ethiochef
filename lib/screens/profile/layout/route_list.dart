
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/profile/layout/recipe_status/my_recipe.dart';
import 'package:ethio_chef/services/user_service.dart';
import 'package:ethio_chef/subscription/subscriptionscreen.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import '../../../models/faqs.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/model_theme.dart';
import '../../../widgets/auth/language_selector_button.dart';
import '../../../widgets/change_theme.dart';
import '../../../widgets/profile/route_card.dart';
import '../../../widgets/profile/route_container.dart';
import '../../../widgets/profile/route_labels_card.dart';
import '../../app_documentation/faq_screen.dart';
import '../../app_documentation/privacy_policies_screen.dart';
import '../../app_documentation/terms_and_conditions_screen.dart';
import 'competition_status/my_competition.dart';


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
    var response;
    bool isLoading = false;
    final List<Map<String, dynamic>> general = [
      {
        "title": "subscription_plans".tr(),
        "leadingIcon": Icons.subscriptions_outlined,
        "onTap": () async {
          pushNewScreen(
            context,
            screen: SubscriptionScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        "trailing": Icon(Icons.chevron_right_outlined,
            color: theme.colorScheme.primary),
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

      }
    ];
    final List<Map<String, dynamic>> status = [
      {
        "title": "saved_recipes".tr(),
        "leadingIcon": Icons.dinner_dining,
        "onTap": () {
          pushNewScreen(
            context,
            screen: MyRecipes(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
      {
        "title": "competition_status".tr(),
        "leadingIcon": Icons.incomplete_circle,
        "onTap": () {
          print("change_password");
          pushNewScreen(
            context,
            screen: MyCompetition(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      }
    ];
    final List<Map<String, dynamic>> other = [
      {
        "title": "privacy_policy".tr(),
        "leadingIcon": Icons.privacy_tip_outlined,
        "onTap": () {
          print("privacy_policy");
          pushNewScreen(
            context,
            screen: PrivacyPolicyScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
      {
        "title": "faq".tr(),
        "leadingIcon": Icons.question_mark,
        "onTap": () {
          print("faq");
          pushNewScreen(
            context,
            screen: FaqScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
      {
        "title": "terms_and_conditions".tr(),
        "leadingIcon": Icons.error,
        "onTap": () {
          print("terms_and_conditions");
          pushNewScreen(
            context,
            screen: TermsAndConditionsScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
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
        child: ListView(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: BouncingScrollPhysics(),
          children: [
            RouteContainer(
              routePart: general,
              indexTwo: 2,
              routeName: tr("general"),
            ),
            RouteContainer(
              routePart: status,
              indexTwo: 1,
              routeName: tr("status"),
            ),
            RouteContainer(
              routePart: other,
              indexTwo: 3,
              routeName: tr("other"),
            )
          ],
        ),
      ),
    );
  }
}

