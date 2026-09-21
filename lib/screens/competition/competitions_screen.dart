import 'package:blur/blur.dart';
import 'package:get/get.dart';
import '../../../models/competition.dart';
import '../../../screens/subscription/layout/payment.dart';
import '../../../services/competition_service.dart';
import '../../../utils/constants.dart';
import '../../../widgets/ad_block.dart';
import '../../../widgets/recipe_status/empty_recipe.dart';
import '../../../widgets/screen_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/assets.dart';
import '../../services/subscription_checker.dart';
import '../../services/user_service.dart';
import '../../theme/app_theme.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/competiton/no_competition.dart';
import '../../widgets/error_card.dart';
import '../../widgets/loading.dart';
import '../../widgets/main_button.dart';
import '../../widgets/pull_to_refresh.dart';
import '../../widgets/svg_icon.dart';
import '../../widgets/youtube_video_player.dart';
import '../auth/auth_screen.dart';
import 'layout/competition_header.dart';
import 'layout/competition_header_image.dart';
import 'layout/contestants_carousel.dart';
import 'layout/upload_video.dart';

class CompetitionsScreen extends StatefulWidget {
  const CompetitionsScreen({super.key});

  @override
  State<CompetitionsScreen> createState() => _CompetitionsScreenState();
}

class _CompetitionsScreenState extends State<CompetitionsScreen> {
  Future? _future;
  bool isFromSms = true;
  bool isLoading = true;
  Future<dynamic> fetchCompetition() async {
    try {
      final service = CompetitionService();
      final data = await service.fetchCompetitions();
      return data;
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  Future checkSmsUser() async {
    final userService = UserService();
    var userData = await userService.fetchUserProfile();
    print(userData);
    print(userData!.isFromSMS);
    print(userData!.user!.firstName);
    if (userData!.isFromSMS == false) {
      setState(() {
        isLoading = false;
        isFromSms = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      // showSubscriptionAlert();
    }
  }

  @override
  void initState() {
    checkSmsUser();
    _future = fetchCompetition();
    loadAd();
    super.initState();
  }

  static String get _adbannerUnitId => AdService.topBannerAdUnitId;
  static BannerAd? _bannerAd1;
  static BannerAd? _bannerAd2;

  void loadAd() async {
    print("Loading Ads");
    await BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd1 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
    await BannerAd(
      adUnitId: AdService.middleBannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd1 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return RefreshWidget(
      onRefresh: () async {
        setState(() {
          _future = fetchCompetition();
        });
      },
      child: Stack(
        children: [
          Blur(
            blurColor: theme.colorScheme.primary,
            blur: isLoading == false && isFromSms == true ? 2.5 : 0,
            overlay: isFromSms == true
                ? SizedBox.shrink()
                : Scaffold(
                    body: Stack(children: [
                    FutureBuilder(
                        future: _future,
                        builder: (context, AsyncSnapshot<dynamic> snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return Loading();
                          }
                          if (snapshot.hasError) {
                            return Center(
                                child: ErrorCard(
                              errorType: snapshot.error.toString(),
                              refresh: () {
                                setState(() {
                                  _future = fetchCompetition();
                                });
                              },
                            ));
                          }
                          return buildCompetitionPage(
                              snapshot.data as List<Competition>);
                        })
                  ])),
            child: Scaffold(
                body: Stack(children: [
              FutureBuilder(
                  future: _future,
                  builder: (context, AsyncSnapshot<dynamic> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Loading();
                    }
                    if (snapshot.hasError) {
                      return Center(
                          child: ErrorCard(
                        errorType: snapshot.error.toString(),
                        refresh: () {
                          setState(() {
                            _future = fetchCompetition();
                          });
                        },
                      ));
                    }
                    return buildCompetitionPage(
                        snapshot.data as List<Competition>);
                  }),
            ])),
          ),
          if (isFromSms == true && isLoading == false)
            Align(
                alignment: Alignment.center,
                child: Dialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.r),
                    ),
                    backgroundColor: Theme.of(context).cardColor,
                    child: Container(
                      height: isTablet ? 600.h : 450.h,
                      width: isTablet ? 275.w : 400.w,
                      padding:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      margin:
                          EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Icon(
                            Icons.error,
                            color: theme.colorScheme.error,
                            size: 50,
                          ),
                          Text(
                            "sms_payment_error".tr,
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              fontSize: 20.sp,
                              color: theme.colorScheme.primary,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              MainButton(
                                  text: 'yes'.tr,
                                  onPress: () async {
                                    PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        withNavBar: false,
                                        screen: PaymentCheckout(
                                            isSMS: true,
                                            isNormalSubscription: true));
                                  }),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: supportButton(
                                    Colors.blue,
                                    Constants.supportLink,
                                    Assets.socialTelegram,
                                    isTablet),
                              )
                            ],
                          )
                        ],
                      ),
                    )))
        ],
      ),
    );
  }

  Widget buildCompetitionPage(List<Competition> competition) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);

    if (competition.isEmpty) {
      return NoCompetitionCurrently();
    }
    return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
              child: Column(children: [
            ScreenHead(
              hasNotification: true,
              screen: 1,
              searchHint: "search".tr,
            ),
            if (_bannerAd1 != null)
              AdBlock(
                bannerAd: _bannerAd1,
                isbottom: false,
              ),
            ListView(
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompetitionHeaderImage(
                      image: competition[0].image.toString(),
                      video: competition[0].videoFromContestant.toString(),
                    ),
                    CompetitionHeader(
                      competition: competition[0],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    if (competition[0].video != null)
                      YoutubeVideoPlayer(
                        link: competition[0].video!,
                      ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: supportButton(Colors.blue, Constants.supportLink,
                          Assets.socialTelegram, isTablet),
                    ),
                    AwardsList(theme: theme),
                    if (competition[0].competitor!.isNotEmpty)
                      Contestants(
                          refresh: () {
                            setState(() {
                              _future = fetchCompetition();
                            });
                          },
                          competition: competition[0],
                          contestant: competition[0].competitor,
                          contest_id: competition[0].id!)
                  ],
                )
              ],
            ),
            if (_bannerAd2 != null)
              AdBlock(
                bannerAd: _bannerAd2,
                isbottom: false,
              )
          ])),
        ),
        floatingActionButton: Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: FloatingActionButton.extended(
              autofocus: true,
              elevation: 4,
              isExtended: true,
              tooltip: 'upload_video'.tr,
              onPressed: () async {
                setState(() {
                  isLoading = true;
                });
                await handleSubscriptionStatus(context, competition[0].id!);
                setState(() {
                  isLoading = false;
                });
              },
              icon: const Icon(Icons.play_arrow, color: Colors.white),
              label: isLoading == true
                  ? CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : Text(
                      'upload_video'.tr,
                      style: TextStyle(
                          fontSize: isTablet ? 13.sp : 15.sp,
                          fontWeight: FontWeight.w800,
                          color: Colors.white),
                    ),
              backgroundColor: theme.colorScheme.primary,
            )));
  }

  Future<void> handleSubscriptionStatus(
      BuildContext context, int competition) async {
    String? status = SubscriptionStatus().status;

    switch (status) {
      case "Not logged in":
        showSnackBarAndNavigate(
            context,
            'please_subscribe_to_see_ingredients_and_steps'.tr,
            AuthScreen(isSignIn: true));
        break;
      case "Another user logged in":
        showSnackBarAndNavigate(
            context, 'another_account_login'.tr, AuthScreen(isSignIn: true));
        break;
      case "User is subscribed":
        print("User is subscribed");
        final userService = UserService();
        var userData = await userService.fetchUserProfile();

        if (userData!.isFromSMS == false || userData.subscriptionId != 15) {
          PersistentNavBarNavigator.pushNewScreen(context,
              screen: UploadCompetitionVideo(competitionId: competition!),
              withNavBar: false);
        } else {
          showSubscriptionAlert();
        }
        break;
      case "User is not subscribed":
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: PaymentCheckout(
            isSMS: true,
            isNormalSubscription: true,
          ),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
        break;
    }
    setState(() {
      isLoading = false;
    });
  }

  void showSubscriptionAlert() {
    final bool isTablet = ScreenUtils.isTablet(context);
    final ThemeData theme = Theme.of(context);
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.r),
            ),
            backgroundColor: Theme.of(context).cardColor,
            child: Container(
              height: isTablet ? 600.h : 450.h,
              width: isTablet ? 275.w : 400.w,
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Icon(
                    Icons.error,
                    color: theme.colorScheme.error,
                    size: 50,
                  ),
                  Text(
                    "sms_payment_error".tr,
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MainButton(
                          text: 'pay'.tr,
                          onPress: () async {
                            PersistentNavBarNavigator.pushNewScreen(context,
                                withNavBar: false,
                                screen: PaymentCheckout(
                                    isSMS: true, isNormalSubscription: true));
                          }),
                    ],
                  )
                ],
              ),
            ));
      },
    );
  }

  void showSnackBarAndNavigate(
      BuildContext context, String message, Widget route) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        content: Text(message),
      ),
    );
    PersistentNavBarNavigator.pushNewScreen(context,
        withNavBar: false, screen: route);
  }
}

Widget supportButton(Color color, String? link, String image, bool isTablet,
    {String? text}) {
  if (link == null) return SizedBox.shrink();
  return Ink(
    child: InkWell(
      onTap: () {
        _launchUrl(link, isTablet);
      },
      child: Row(
        children: [
          SvgIcon(
            color: color,
            image: image,
            size: 50.sp,
          ),
          SizedBox(
              width: 250,
              child: Text(
                text ?? "get_support".tr,
                softWrap: true,
                maxLines: 2,
              ))
        ],
      ),
    ),
  );
}

Future<void> _launchUrl(String url, bool isTablet) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    SnackBar(
        content: Text(
      'open_link_failed'.tr,
      style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
    ));
  }
}
