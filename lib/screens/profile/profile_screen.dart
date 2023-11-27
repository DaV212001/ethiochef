import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/user.dart';
import '../../services/authorization_service.dart';
import '../../services/user_service.dart';
import '../../widgets/info_card.dart';
import '../../widgets/main_button.dart';
import '../auth/auth_screen.dart';
import '../main_screen.dart';
import 'layout/route_list.dart';
import 'layout/user_screen_header.dart';
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  Future? _future;
  bool isLoading = false;
  @override
  void initState() {
    _future = fetchData();
    super.initState();
  }

  Future<dynamic> fetchData() async {
    try {
      print('fetch user');
      final userService = UserService();
      var userData = await userService.fetchLoggedInUser();
      return userData;
    } catch (error) {
      rethrow;
    }
  }
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
            return buildUserScreen(
                snapshot.data as User);
          }),
    );
  }
  @override
  Widget buildUserScreen(User user) {
    return SafeArea(
      child: Scaffold(
          body: ListView(
            scrollDirection: Axis.vertical,
            physics: BouncingScrollPhysics(),
            children: [
              UserScreenHeader(user: user),
              RouteList(),
              SizedBox(height: 5.h,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: MainButton(
                    isLoading: isLoading,
                    text: "Log out".tr(),
                    onPress: () async {
                      // setState(() {
                      //   isLoading = true;
                      // });
                      // print("Logging out");
                      // SharedPreferences shared = await SharedPreferences.getInstance();
                      // await shared.clear();
                      // await AuthService.logout();
                      // setState(() {
                      //   isLoading = false;
                      // });
                      // Navigator.pushReplacement(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) => MainScreen()
                      //   ),
                      // );
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
