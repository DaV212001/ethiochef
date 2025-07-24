import 'package:easy_localization/easy_localization.dart' as e;
import 'package:ethio_chef/screens/subscription/layout/payment.dart';
import 'package:ethio_chef/utils/constants.dart';
import 'package:ethio_chef/widgets/ad_block.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:logger/logger.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../main.dart';
import '../../../services/authorization_service.dart';
import '../../../services/payment_service.dart';
import '../../../services/user_service.dart';
import '../../../theme/app_theme.dart';
import '../../../theme/model_theme.dart';
import '../../../utils/update_manager.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/profile/route_container.dart';
import '../../../widgets/profile/saved_recipe.dart';
import '../../../widgets/update_card.dart';
import '../../app_documentation/about.dart';
import '../../app_documentation/faq_screen.dart';
import '../../app_documentation/privacy_policies_screen.dart';
import '../../app_documentation/terms_and_conditions_screen.dart';
import '../../auth/auth_screen.dart';
import '../../recipe_status/my_submitted_recipe.dart';

class RouteList extends StatefulWidget {
  final Function()? onRefresh;
  final BannerAd? banner;
  final bool telebirr;
  const RouteList(
      {super.key, this.onRefresh, this.banner, required this.telebirr});

  @override
  State<RouteList> createState() => _RouteListState();
}

class _RouteListState extends State<RouteList> {
  bool canceling = false;
  static final int statusNoUpdate = 0;
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ModelTheme>(context);
    ThemeData theme = Theme.of(context);
    String deleteString =
        widget.telebirr ? e.tr("cancel_subscription") : e.tr("del_sub");
    final List<Map<String, dynamic>> general = [
      {
        "title": e.tr("subscription_plans"),
        "leadingIcon": Icons.subscriptions_outlined,
        "onTap": () async {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: PaymentCheckout(isSMS: false, isNormalSubscription: true),
            withNavBar: false,
            pageTransitionAnimation: PageTransitionAnimation.cupertino,
          );
        },
        "trailing": Icon(Icons.chevron_right_outlined,
            color: theme.colorScheme.primary),
      },
      {
        "title": e.tr("change_theme"),
        "leadingIcon":
            themeProvider.isDark ? Icons.light_mode : Icons.dark_mode,
        "onTap": () {},
        "trailing": Text("")
      },
      {
        "title": e.tr("change_language"),
        "leadingIcon": Icons.language,
        "onTap": () {},
        "trailing": Text(""),
      }
    ];
    final List<Map<String, dynamic>> status = [
      {
        "title": e.tr("submitted_recipes"),
        "leadingIcon": Icons.dinner_dining,
        "onTap": () {
          PersistentNavBarNavigator.pushNewScreen(
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
        "title": e.tr("saved_recipes"),
        "leadingIcon": CupertinoIcons.bookmark_fill,
        "onTap": () {
          PersistentNavBarNavigator.pushNewScreen(
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
        "title": e.tr("privacy_policy"),
        "leadingIcon": Icons.privacy_tip_outlined,
        "onTap": () {
          print("privacy_policy");
          PersistentNavBarNavigator.pushNewScreen(
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
        "title": e.tr("faq"),
        "leadingIcon": Icons.question_mark,
        "onTap": () {
          print("faq");
          PersistentNavBarNavigator.pushNewScreen(
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
        "title": e.tr("terms_and_conditions"),
        "leadingIcon": Icons.error,
        "onTap": () {
          print("terms_and_conditions");
          PersistentNavBarNavigator.pushNewScreen(
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
        "title": e.tr("about"),
        "leadingIcon": Icons.info_outline_rounded,
        "onTap": () {
          print("about");
          PersistentNavBarNavigator.pushNewScreen(
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
        "title": e.tr("new_version"),
        "leadingIcon": Icons.settings_applications,
        "onTap": () {
          checkIfUpdateIsAvailable();
          print("new_version");
        },
        "trailing":
            Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
      {
        "title": e.tr("share_app"),
        "leadingIcon": Icons.share_rounded,
        "onTap": () {
          Share.shareUri(Uri.parse(Constants.shareLink));
        },
        "trailing":
            Icon(Icons.chevron_right_outlined, color: theme.colorScheme.primary)
      },
      {
        "title": deleteString,
        "leadingIcon": Icons.delete,
        "onTap": () async {
          if (widget.telebirr) {
            Get.showOverlay(
              asyncFunction: () async {
                await deleteTelebirrSub(context);
              },
              loadingWidget: const Center(child: CircularProgressIndicator()),
            );
          } else {
            buildShowDialogForDeleteAccount(context);
          }

          // await QuickAlert.show(
          //   context: context,
          //   type: QuickAlertType.error,
          //   showCancelBtn: true,
          //   showConfirmBtn: true,
          //   title: "warning".tr(),
          //   text: 'delete_subscription_warning'.tr(),
          //   titleAlignment: TextAlign.center,
          //   textAlignment: TextAlign.center,
          //   confirmBtnText: 'delete'.tr(),
          //   onConfirmBtnTap: ()  {
          //     deleteSub();
          //   },
          //   cancelBtnText: 'cancel'.tr(),
          //   onCancelBtnTap: (){
          //     Navigator.pop(context);
          //   },
          //   confirmBtnColor: Colors.red,
          //   cancelBtnTextStyle: TextStyle(
          //       color: Colors.black,
          //       fontWeight: FontWeight.bold
          //   ),
          //   backgroundColor: Colors.white,
          //   headerBackgroundColor: Colors.grey,
          //   confirmBtnTextStyle: const TextStyle(
          //     color: Colors.white,
          //     fontWeight: FontWeight.bold,
          //   ),
          //   barrierColor: Colors.red,
          //   titleColor: Colors.red,
          //   textColor: Colors.red,
          // );
        }
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
              routeName: e.tr("general"),
            ),
            RouteContainer(
              routePart: status,
              indexTwo: 1,
              routeName: e.tr("status"),
            ),
            if (widget.banner != null)
              AdBlock(
                bannerAd: widget.banner,
                isbottom: false,
              ),
            RouteContainer(
              routePart: other,
              indexTwo: 4,
              routeName: e.tr("other"),
            )
          ],
        ),
      ),
    );
  }

  Future<void> deleteTelebirrSub(BuildContext context) async {
    var response = await PaymentService().unsubscribeTelebirr();
    if (response.statusCode == 200) {
      print('CALLEDDDDDDDDDDDDD!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!');
      await AuthService.logout();
      SharedPreferences shared = await SharedPreferences.getInstance();
      await shared.remove('savedRecipes');
      await shared.remove('ethioChef_authorization_token');
    }
    showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(color: Colors.red),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(e.tr('sub_canceled')),
                                MainButton(
                                  text: e.tr('ok'),
                                  onPress: () {
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                AuthScreen(isSignIn: true)));
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> buildShowDialogForDeleteAccount(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) {
          return Scaffold(
            body: Container(
              decoration: BoxDecoration(color: Colors.red),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Center(
                          child: Padding(
                            padding: EdgeInsets.all(8),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(e.tr("warning")),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child:
                                      Text(e.tr("delete_subscription_warning")),
                                ),
                                SizedBox(
                                  height: 30,
                                ),
                                Row(
                                  mainAxisSize: MainAxisSize.max,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    ElevatedButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        style: ButtonStyle(
                                            backgroundColor:
                                                MaterialStatePropertyAll<Color>(
                                                    Colors.white)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            e.tr("cancel"),
                                            style:
                                                TextStyle(color: Colors.black),
                                          ),
                                        )),
                                    DeleteButton()
                                  ],
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<void> checkIfUpdateIsAvailable() async {
    UpdateManager update = UpdateManager();
    int status = await update.checkForUpdate();
    String url = update.updateUrl();
    if (status == statusNoUpdate) {
      noUpDateRequired(context);
    } else {
      updateIsAvailable(url);
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
        text: e.tr('no_update_available'),
        titleAlignment: TextAlign.center,
        textAlignment: TextAlign.center,
        confirmBtnColor: theme.colorScheme.primary,
        backgroundColor: theme.colorScheme.secondary,
        headerBackgroundColor: theme.colorScheme.primary,
        barrierColor: Colors.transparent,
        titleColor: theme.colorScheme.primary,
        textColor: theme.colorScheme.primary);
  }

  updateIsAvailable(String url) {
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
              backgroundColor: Theme.of(context).cardColor,
              child: UpdateCard(isRequired: false, uri: Uri.parse(url))),
        );
      },
    );
  }
}

class DeleteButton extends StatefulWidget {
  const DeleteButton({
    super.key,
  });

  @override
  State<DeleteButton> createState() => _DeleteButtonState();
}

class _DeleteButtonState extends State<DeleteButton> {
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () async {
          setState(() {
            deleting = true;
          });
          UserService service = UserService();
          try {
            bool deleted = await service.deleteUserSubscription();
            if (deleted) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                e.tr('del_succ'),
              )));
              RestartWidget.restartApp(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(
                e.tr('del_fail'),
              )));
            }
          } catch (err, s) {
            Logger().t(err, stackTrace: s);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
              e.tr('del_fail'),
            )));
          } finally {
            setState(() {
              deleting = false;
            });
          }
        },
        style: ButtonStyle(
            backgroundColor: MaterialStatePropertyAll<Color>(Colors.red)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: deleting
              ? CircularProgressIndicator(
                  color: Colors.white,
                )
              : Text(
                  e.tr('delete'),
                  style: TextStyle(color: Colors.white),
                ),
        ));
  }
}

Future<void> _launchUrl(String url, bool isTablet) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    SnackBar(
        content: Text(
      e.tr('open_link_failed'),
      style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
    ));
  }
}
