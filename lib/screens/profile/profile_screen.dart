import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/screens/subscription/layout/payment.dart';
import 'package:ethio_chef/services/footer_service.dart';
import 'package:ethio_chef/widgets/ad_block.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/footer_data.dart';
import '../../models/user.dart';
import '../../models/user_profile.dart';
import '../../services/authorization_service.dart';
import '../../services/user_service.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/error_card.dart';
import '../../widgets/loading.dart';
import '../../widgets/main_button.dart';
import '../../widgets/profile/user_screen_footer.dart';
import '../../widgets/pull_to_refresh.dart';
import 'layout/route_list.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

import 'layout/user_screen_header.dart';
class ProfileScreen extends StatefulWidget {
  final Function()? onRefresh;
  const ProfileScreen({Key? key, this.onRefresh}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoggedIn = false;
  late User user = User(lastName: '', firstName: '');
  Future? _future;
  bool isLoading = false;

  @override
  void initState() {
    _future = fetchData();
    loadAd();
    super.initState();
  }

  static String _adbannerUnitId = 'ca-app-pub-4750411587709054/9425791625';
  static BannerAd? _bannerAd1;
  static BannerAd? _bannerAd2;
  static BannerAd? _bannerAd3;
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
      adUnitId: 'ca-app-pub-4750411587709054/1691458173',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd2 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();

    await BannerAd(
      adUnitId: 'ca-app-pub-4750411587709054/2820228086',
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          _bannerAd3 = ad as BannerAd;
        },
        onAdFailedToLoad: (ad, err) {
          print("Error loading ad: $err");
          ad.dispose();
        },
      ),
    ).load();
  }
  Future<dynamic> fetchData() async {
    var access_token = await AuthService.getAuthorizationToken();
    if(access_token == 'none'){
      pushNewScreen(context, screen: AuthScreen(), withNavBar: false);
    }
    try {
      final userService = UserService();
      var userData = await userService.fetchUserProfile();
      if(userData?.message == "User is not subscribed" ){
        setState(() {
          isLoading = false;
          print("userData ${userData?.message}");
          user = userData?.user ?? User(lastName: '', firstName: '');
        });
      }
      print("userData1 $userData");
      FooterService foot = FooterService();
      var footerData = await foot.getFooterData();
      setState(() {

      });
      return [userData, footerData];
    } catch (error) {

      rethrow;
    }
  }
  int amount = 0;
  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return RefreshWidget(
      child: SafeArea(
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
                              _future = fetchData();
                            });
                          }
                        ));
                  }

                  if(snapshot.data == null){
                    return Center(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: theme.colorScheme.error,
                              size: 100,
                            ),
                            Text("another_account_login".tr(),
                                style: TextStyle(
                                    fontSize: isTablet ? 11.sp : 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.error)

                            ),
                            MainButton(
                              isLoading: isLoading,
                              text: "log_out".tr(),
                              onPress: () async {
                                setState(() {
                                  isLoading = true;
                                });
                                await AuthService.logout();
                                SharedPreferences shared = await SharedPreferences.getInstance();
                                await shared.remove('savedRecipes');
                                await shared.remove('ethioChef_authorization_token');
                                Phoenix.rebirth(context);
                                setState(() {
                                  isLoading = false;
                                });
                              }
                            )
                          ]
                        ),
                      ),
                    );
                  }
                  if(snapshot.data[0] == null){
                    return Center(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error,
                              color: theme.colorScheme.error,
                              size: 100,
                            ),
                            Text("another_account_login".tr(),
                                style: TextStyle(
                                    fontSize: isTablet ? 11.sp : 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: theme.colorScheme.error)

                            ),
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: MainButton(
                                  isLoading: isLoading,
                                  text: "log_out".tr(),
                                  onPress: () async {
                                    setState(() {
                                      isLoading = true;
                                    });
                                    await AuthService.logout();
                                    SharedPreferences shared = await SharedPreferences.getInstance();
                                    await shared.remove('savedRecipes');
                                    await shared.remove('ethioChef_authorization_token');
                                    Phoenix.rebirth(context);
                                    setState(() {
                                      isLoading = false;
                                    });
                                  }
                              ),
                            )
                          ]
                      ),
                    );
                  }
                  return buildUserScreen(snapshot.data[0] as UserProfile, snapshot.data[1] as FooterData);
                })
        ),
      ),
        onRefresh:()async{
          setState(() {
            _future = fetchData();
          });
        }
    );
  }
  @override
  Widget buildUserScreen(UserProfile user, FooterData data) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return RefreshWidget(
      onRefresh:()async{
        setState(() {
          _future = fetchData();
        });
      },
      child: Column(
        children: [

          if (_bannerAd1 != null)
            AdBlock(bannerAd: _bannerAd1, isbottom: false,),

          Expanded(
            child: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              children: [
                UserScreenHeader(
                    user: user, reFresh: (){
                  setState(() {
                    print("and should call this");
                    _future = fetchData();
                  });
                }),
                if(user.message=="User is not subscribed")
                  GestureDetector(
                    onTap: (){
                      pushNewScreen(
                        context,
                        screen: PaymentCheckout(
                          isNormalSubscription: true
                        ),
                        withNavBar: false,
                        pageTransitionAnimation: PageTransitionAnimation.cupertino,
                      );
                    },
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 10),
                      width: double.infinity,
                      color: Colors.red,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 5),
                        child: Text('please_subscribe_now'.tr(),
                          style: TextStyle(
                              fontSize: isTablet ? 11.sp : 15.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.secondary),),
                      ),
                    ),
                  )
                ,
                RouteList(
                  banner: _bannerAd3,
                  onRefresh: (){
                    setState(() {
                      _future = fetchData();
                    });
                  },
                ),
                if (_bannerAd2 != null)
                  AdBlock(bannerAd: _bannerAd2, isbottom: true,),
                SizedBox(height: 5.h,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: MainButton(
                      isLoading: isLoading,
                      text: "log_out".tr(),
                      onPress: () async {
                        setState(() {
                          isLoading = true;
                        });
                        UserService service = UserService();
                        await service.logOut(user.user!.id!);
                        await AuthService.logout();
                        SharedPreferences shared = await SharedPreferences.getInstance();
                        await shared.remove('savedRecipes');
                        await shared.remove('ethioChef_authorization_token');
                        await shared.clear();
                        Phoenix.rebirth(context);
                        setState(() {
                          isLoading = false;
                        });
                      }
                  ),
                ),
                SizedBox(height: 5.h,),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: UserScreenFooter(footerData:data),
                ),
                SizedBox(
                  height: 45,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
