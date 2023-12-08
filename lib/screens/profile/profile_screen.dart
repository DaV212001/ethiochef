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
  String first_name = '';
  String last_name = '';
  String phone = '';
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
    print("Fetch data");
    _future = fetchData();
    super.initState();
  }
  Future<dynamic> fetchData() async {
    print("Fetching data");
    try {
      print('fetch user');
      final userService = UserService();
      var userData = await userService.fetchUserProfile();
      print("userData $userData");
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
            if(snapshot.data == "User is not subscribed"){
              print("snapshot data ${snapshot.data}");
              return Center(
                  child: InfoCard(
                      onPress: ()async{
                        await  getUserData();
                        await pushNewScreen(context,
                            screen: AllSubscriptions(
                              first_name: first_name,
                              last_name: last_name,
                              phone: phone,
                              isSignUp: true,
                              returnPrice: (price){
                                setState(() {
                                  amount = price;
                                });
                              },)
                        );
                      },
                      infoTitle: "User is not subscribed".tr(),
                      infoBody: "subscribe".tr(),
                      closeText: "",
                      buttonText: "subscribe".tr(),
                      infoImage: "",
                      closeBtn: false
                  ));
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
            return buildUserScreen(snapshot.data[0] as UserProfile);
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
                      UserService service = UserService();
                      service.logOut(user.id!);
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
  Future<void> getUserData() async {
    UserService service = UserService();
    User user = await service.fetchLoggedInUser();
    setState(() {
      first_name = user.firstName;
      last_name = user.lastName;
      phone = user.phone!;
    });
  }
}
