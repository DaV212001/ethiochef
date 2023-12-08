import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../models/user_profile.dart';
import '../../models/verification.dart';
import '../../services/authorization_service.dart';
import '../../services/payment_service.dart';
import '../../services/user_service.dart';
import '../../widgets/info_card.dart';
import '../../widgets/main_button.dart';
import '../../widgets/profile/route_card.dart';
import '../auth/auth_screen.dart';
import '../auth/layout/payment_screen.dart';
import '../main_screen.dart';
import '../subscription/all_subscriptions.dart';
import 'layout/route_list.dart';
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

  void getUserStatus() async {
    bool status = await AuthService.isUserLoggedIn();
    print("Logged in status = $status");
    setState(() {
      isLoggedIn = status;
    });
  }

  Future? _future;
  bool isLoading = false;

  @override
  void initState() {
    getUserStatus();
    _future = fetchData();
    super.initState();
  }
  Future<UserProfile?> fetchData() async {
    try {
      print('fetch user');
      final userService = UserService();
      var userData = await userService.fetchUserProfile();
      print("userData2 $userData");
      if(userData?.message == "User is not subscribed" ){

        setState(() {
          isLoading = false;
          print("userData ${userData?.message}");
          user = userData?.user??User(lastName: '', firstName: '');
          print("========================================================================================");
          print(user.firstName);
          print(user.lastName);
          print(user.phone);
          print("========================================================================================");
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
    return Scaffold(
      body: FutureBuilder(
          future: _future,
          builder: (context, AsyncSnapshot<dynamic> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                  child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                  child: InfoCard(
                      onPress: (){
                        setState(() {
                          _future = fetchData();
                        });
                      },
                      infoTitle: "Error",
                      infoBody: "Getting User data",
                      closeText: "",
                      buttonText: "Reload",
                      infoImage: "",
                      closeBtn: false
                  ));
            }
            if(snapshot.data.message == "User is not subscribed"){
              print("snapshot data ${snapshot.data.message}");
              return Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('please_subscribe_to_get_full_access_of_the_app'.tr()),
                    MainButton(
                        width: 200,
                        text: 'subscribe'.tr(),
                        onPress: ()async{
                          await showDialog(
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
                                  child: InfoCard(
                                    onPress: () async {
                                      await pushNewScreen(context,
                                          screen: AllSubscriptions(returnPrice: (price){
                                            setState(() {
                                              amount = price;
                                            });
                                          },)
                                      );
                                      print("amount $amount");
                                      Verification verification =
                                      await PaymentService().getChapaCheckoutLink(amount, '', user.firstName, user.lastName, user.phone.toString());

                                      print("PaymentService");
                                      pushNewScreen(context,
                                          screen: PaymentScreen(url: verification.checkoutUrl!)
                                      );

                                      bool notpaid = await PaymentService().verifyChapaPayment(verification.txref!);
                                      print(notpaid);
                                    },
                                    buttonText: "Pay Subscription",
                                    closeText: "Pay Later",
                                    infoBody: "Pay your monthly, yearly or weekly subscription",
                                    infoTitle: "Subscriptions payment",
                                    infoImage: "assets/images/chapa.png",
                                    closeBtn: true,
                                  ),
                                ),
                              );
                            },
                          );
                        })
                  ],
                ),
              );
            }
            if(snapshot.data == null){
              print("snapshot data ${snapshot.data}");
              return Center(
                  child: InfoCard(
                      onPress: ()async{
                        await pushNewScreen(context, screen: AuthScreen(isSignIn: true));
                        setState(() {
                          _future = fetchData();
                        });
                      },
                      infoTitle: "welcome_back_title".tr(),
                      infoBody: "lets_get_back_to_cooking_masterpiece".tr(),
                      closeText: "",
                      buttonText: "sign_in_button".tr(),
                      infoImage: "",
                      closeBtn: false
                  ));
            }
            return buildUserScreen(snapshot.data as UserProfile);
          })
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
              UserScreenHeader(user: user, reFresh: (){
                setState(() {
                  _future = fetchData();
                });
              }),
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
