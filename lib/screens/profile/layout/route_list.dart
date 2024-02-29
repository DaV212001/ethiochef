
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/subscription/layout/payment.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../../theme/model_theme.dart';
import '../../../utils/update_manager.dart';
import '../../../widgets/profile/route_container.dart';
import '../../../widgets/profile/saved_recipe.dart';
import '../../../widgets/update_card.dart';
import '../../app_documentation/about.dart';
import '../../app_documentation/faq_screen.dart';
import '../../app_documentation/privacy_policies_screen.dart';
import '../../app_documentation/terms_and_conditions_screen.dart';
import '../../recipe_status/my_submitted_recipe.dart';

import 'package:url_launcher/url_launcher.dart';

class RouteList extends StatefulWidget {
  final Function()? onRefresh;
  final BannerAd? banner;
  const RouteList({super.key, this.onRefresh,
    this.banner
  });

  @override
  State<RouteList> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  static final int statusNoUpdate = 0;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ModelTheme>(context);
    ThemeData theme = Theme.of(context);
    final List<Map<String, dynamic>> general = [
      {
        "title": "subscription_plans".tr(),
        "leadingIcon": Icons.subscriptions_outlined,
        "onTap": () async {
          pushNewScreen(
            context,
            screen: PaymentCheckout(isNormalSubscription: true),
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
        "title": "submitted_recipes".tr(),
        "leadingIcon": Icons.dinner_dining,
        "onTap": () {
          pushNewScreen(
            context,
            screen: SubmittedRecipe(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
      {
        "title": 'saved_recipes'.tr(),
        "leadingIcon": CupertinoIcons.bookmark_fill,
        "onTap": () {
          pushNewScreen(
            context,
            screen: SavedRecipe(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
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
          pushNewScreen(
            context,
            screen: AboutScreen(),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        "trailing":
        Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
      {
        "title": "new_version".tr(),
        "leadingIcon": Icons.settings_applications,
        "onTap": () {
          checkIfUpdateIsAvailable();
          print("new_version");

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
            if(widget.banner != null)
            Align(
              alignment: Alignment.topCenter,
              child: SafeArea(
                child: SizedBox(
                  width: widget.banner!.size.width.toDouble(),
                  height: widget.banner!.size.height.toDouble(),
                  child: AdWidget(ad: widget.banner!),
                ),
              ),
            ),
            RouteContainer(
              routePart: other,
              indexTwo: 4,
              routeName: tr("other"),
            )
          ],
        ),
      ),
    );
  }
  Future<void> checkIfUpdateIsAvailable()async{
    UpdateManager update = UpdateManager();
    int status = await update.checkForUpdate();
    String url = update.updateUrl();
    if(status == statusNoUpdate){
      noUpDateRequired(context);
    }else{
      updateIsAvailable(url);
    }
  }
  Future<void> _launchUrl() async {
    String url = "https://play.google.com/store/apps/details?id=com.peacetechnology.ethiochef";
    if (!await launchUrl(Uri.parse(url))) {
      throw Exception('Could not launch $url');
    }
  }
  void noUpDateRequired(BuildContext context) {
    ThemeData theme = Theme.of(context);
    QuickAlert.show(
      context: context,
      type: QuickAlertType.success,
      showCancelBtn: false,
      showConfirmBtn: false,
      title: "",
      text: 'no_update_available'.tr(),
      titleAlignment: TextAlign.center,
      textAlignment: TextAlign.center,
      confirmBtnColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.secondary,
      headerBackgroundColor: theme.colorScheme.primary,
      barrierColor: Colors.transparent,
      titleColor: theme.colorScheme.primary,
      textColor: theme.colorScheme.primary
    );
  }
  updateIsAvailable(String url){
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return WillPopScope(
          onWillPop: () async {
            return true;
          },
          child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20.r),
              ),
              backgroundColor: Theme
                  .of(context)
                  .cardColor,
              child: UpdateCard(
                  isRequired: false,
                  uri: Uri.parse(url)
              )
          ),
        );
      },
    );
  }
}

