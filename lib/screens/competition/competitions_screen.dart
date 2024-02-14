import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/screens/subscription/layout/payment.dart';
import 'package:ethio_chef/services/competition_service.dart';
import 'package:ethio_chef/widgets/screen_head.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';
import '../../services/subscription_checker.dart';
import '../../services/user_service.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/error_card.dart';
import '../../widgets/loading.dart';
import '../../widgets/pull_to_refresh.dart';
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

  @override
  void initState() {
    _future = fetchCompetition();
    _loadAd();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return RefreshWidget(
        onRefresh:()async{
          setState(() {
            _future = fetchCompetition();
          });
        },
      child: Scaffold(
        body: FutureBuilder(
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
              return buildCompetitionPage(snapshot.data as List<Competition>);
            }),
      ),
    );
  }
  Widget buildCompetitionPage(List<Competition> competition){
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    if(competition.isEmpty){
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Container(
              height: isTablet ? 600.h : 450.h,
              width: isTablet ? 275.w : 400.w,
              padding: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              margin: EdgeInsets.symmetric(vertical: 5.h, horizontal: 10.w),
              child: Column(
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: theme.colorScheme.primary,
                            width: 1
                        )
                    ),
                    child: Column(
                      children: [
                        Text("no_competition_currently".tr(),
                            style: TextStyle(
                                fontSize: isTablet ? 11.sp : 15.sp,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.secondaryContainer)
                        ),
                        Text("awards_title".tr(),
                            style: TextStyle(
                                fontSize: isTablet ? 13.sp : 17.sp,
                                fontWeight: FontWeight.w800,
                                color: theme.colorScheme.primary)
                        ),
                        Text("awards".tr(),
                            style: TextStyle(
                                fontSize: isTablet ? 11.sp : 15.sp,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.secondaryContainer)
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return Scaffold(
        body: SingleChildScrollView(
          child: SafeArea(
            child: Column(children: [
              ScreenHead(
                hasNotification: true,
                screen: 1,
                searchHint: "search".tr(),
              ),
              if (_bannerAd != null)
                Align(
                  alignment: Alignment.topCenter,
                  child: SafeArea(
                    child: SizedBox(
                      width: _bannerAd!.size.width.toDouble(),
                      height: _bannerAd!.size.height.toDouble(),
                      child: AdWidget(ad: _bannerAd!),
                    ),
                  ),
                ),
              ListView(
                scrollDirection: Axis.vertical,
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                children:[ Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CompetitionHeaderImage(
                      image: competition[0].image.toString(),
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
                    if(competition[0].competitor!.isNotEmpty)
                      Contestants(contestant: competition[0].competitor, contest_id: competition[0].id!)
                    // ShareButton(food: PlaceHolderData.food)
                  ],
                )],
              ),
              if (_bannerAd2 != null)
                Align(
                    alignment: Alignment.topCenter,
                    child: SafeArea(
                        child: SizedBox(
                          width: _bannerAd2!.size.width.toDouble(),
                          height: _bannerAd2!.size.height.toDouble(),
                          child: AdWidget(ad: _bannerAd2!),
                        )
                    )
                )
            ]),
          ),
        ),

        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: FloatingActionButton.extended(
            autofocus: true,
            elevation: 4,
            isExtended: true,
            tooltip: 'upload_video'.tr(),
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
            label: isLoading == true ? CircularProgressIndicator(
              color: Colors.white,
            ):Text('upload_video'.tr(),
              style: TextStyle(
                  fontSize: isTablet ? 13.sp : 15.sp,
                  fontWeight: FontWeight.w800,
                  color: Colors.white),),
            backgroundColor: theme.colorScheme.primary,
          ),
        ),

        // floatingActionButton: FloatingActionButton(
        //   backgroundColor: theme.colorScheme.primary,
        //   onPressed: () async {
        //     setState(() {
        //       isLoading = true;
        //     });
        //     await handleSubscriptionStatus(context, competition[0].id!);
        //     setState(() {
        //       isLoading = false;
        //     });
        //   },
        //   child: isLoading == true ? CircularProgressIndicator(
        //     color: Colors.white,
        //   ):Icon(Icons.add, color: Colors.white),
        // )
    );
  }
  String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  BannerAd? _bannerAd;
  BannerAd? _bannerAd2;
  BannerAd? _bannerAd3;
  void _loadAd() async {
    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd = ad as BannerAd;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();

    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd2 = ad as BannerAd;

          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();

    BannerAd(
      adUnitId: _adbannerUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          setState(() {
            _bannerAd3 = ad as BannerAd;

          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          ad.dispose();
        },
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    ).load();
  }
  bool isLoading = false;

  Widget buildCompetition(BuildContext context, List<Competition> competition) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return ListView.builder(
      itemCount: competition.length,
      itemBuilder: (context, index) {
      return SingleChildScrollView(
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompetitionHeaderImage(
                image: competition[index].image.toString(),
              ),
              CompetitionHeader(
                competition: competition[index],
              ),
              SizedBox(
                height: 10.h,
              ),
              if (competition[index].video != null)
                YoutubeVideoPlayer(
                  link: competition[index].video!,
                ),
              if(competition[index].competitor!.isNotEmpty)
                Contestants(contestant: competition[index].competitor, contest_id: competition[index].id!)
              // ShareButton(food: PlaceHolderData.food)
            ],
          ),
        ),
      );
    },);
  }
  Future<void> handleSubscriptionStatus(BuildContext context, int competition) async {
    String? status = SubscriptionStatus().status;

    switch (status) {
      case "Not logged in":
        showSnackBarAndNavigate(context, 'please_subscribe_to_see_ingredients_and_steps'.tr(), AuthScreen(isSignIn: true));
        break;
      case "Another user logged in":
        showSnackBarAndNavigate(context, 'another_account_login'.tr(), AuthScreen(isSignIn: true));
        break;
      case "User is subscribed":
        print("User is subscribed");
        final userService = UserService();
        var userData = await userService.fetchUserProfile();
        print("userData ${userData!.isFromSMS}");
        print("userData ${userData!.user!.firstName}");
        print("userData ${userData!.user!.lastName}");
        print("userData ${userData!.user!.id}");

        if (userData!.isFromSMS == false) {
          pushNewScreen(context, screen: UploadCompetitionVideo(competitionId: competition!), withNavBar: false);
        } else {
          showSubscriptionAlert(context);
        }
        break;
      case "User is not subscribed":
        pushNewScreen(
          context,
          screen: PaymentCheckout(isNormalSubscription: true),
          withNavBar: false,
          pageTransitionAnimation: PageTransitionAnimation.cupertino,
        );
        break;
    }
    setState(() {
      isLoading = false;
    });
  }

  void showSubscriptionAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      showCancelBtn: false,
      showConfirmBtn: true,
      title: "",
      text: 'sms_payment_error'.tr(),
      titleAlignment: TextAlign.center,
      textAlignment: TextAlign.center,
      confirmBtnText: 'pay'.tr(),
      onConfirmBtnTap: () {
        pushNewScreen(context, withNavBar: false, screen: PaymentCheckout(isNormalSubscription: true));
      },
      cancelBtnText: 'cancel'.tr(),
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      confirmBtnColor: Colors.red,
      cancelBtnTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.white,
      headerBackgroundColor: Colors.grey,
      confirmBtnTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      barrierColor: Colors.red,
      titleColor: Colors.red,
      textColor: Colors.red,
    );
    setState(() {
      isLoading = false;
    });
  }

  void showSnackBarAndNavigate(BuildContext context, String message, Widget route) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        content: Text(message),
      ),
    );
    pushNewScreen(context, withNavBar: false, screen: route);
  }
}
