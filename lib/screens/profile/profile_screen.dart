import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../models/user_profile.dart';
import '../../services/authorization_service.dart';
import '../../services/user_service.dart';
import '../../widgets/error_card.dart';
import '../../widgets/loading.dart';
import '../../widgets/main_button.dart';
import '../../widgets/profile/route_card.dart';
import '../subscription/all_subscriptions.dart';
import 'layout/route_list.dart';
import 'layout/user_screen_header.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
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
    super.initState();
  }



  Future<UserProfile?> fetchData() async {
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
      return userData;
    } catch (error) {

      rethrow;
    }
  }
  int amount = 0;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                        },
                      ));
                }
                //TODO: check this code esti
                if(snapshot.data == null){
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("another_account_login".tr()),
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
                  );
                }
                return buildUserScreen(snapshot.data as UserProfile);
              })
      ),
    );
  }
  @override
  Widget buildUserScreen(UserProfile user) {
    return SafeArea(
      child: Scaffold(
        body: ListView(
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: RouteCard(
                  onTap: (){
                    pushNewScreen(
                      context,
                      screen: AllSubscriptions(
                        returnPrice: (n){

                        }, isSignUp: false, first_name: '', last_name: '', phone: '',
                      ),
                      withNavBar: false,
                      pageTransitionAnimation: PageTransitionAnimation.cupertino,
                    );
                  },
                  title: 'please_subscribe_now'.tr(),
                  icon: Icons.money,
                ),
              )
              ,
            RouteList(
              onRefresh: (){
                setState(() {
                  _future = fetchData();
                });
              },
            ),
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
                    Phoenix.rebirth(context);
                    // Navigator.of(context).popUntil((route) => route.settings.name == '/main');
                    //
                    // Navigator.of(context).popUntil((route) {
                    //   return route.settings.name == '/main';
                    // });
                    setState(() {
                      isLoading = false;
                    });
                  }
              ),
            ),
            SizedBox(height: 5.h,),
            Align(
              alignment: Alignment.bottomCenter,
              child: Text("@2023 Copyright EthioChef"),
            ),
            SizedBox(
              height: 45,
            ),
          ],
        ),

      ),
    );
  }
}
