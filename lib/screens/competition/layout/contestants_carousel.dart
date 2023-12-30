import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/food.dart';
import 'package:ethio_chef/widgets/horizontal_food_carousel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../../models/contestants.dart';
import '../../../models/recipe_show_checker.dart';
import '../../../services/competition_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/cached_image.dart';
import '../../../widgets/meal_card.dart';
import '../../auth/auth_screen.dart';
import '../../subscription/all_subscriptions.dart';

class Contestants extends StatefulWidget {
  final List<Contestant>? contestant;

  const Contestants({super.key, required this.contestant});

  @override
  State<Contestants> createState() => _ContestantsState();
}

class _ContestantsState extends State<Contestants> {
  bool Loading = false;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    double height = 260;
    double width = 165;
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              "related_contestants".tr(),
              style: theme.textTheme.headlineMedium?.copyWith(
                  color: theme.colorScheme.tertiary,
                  fontWeight: FontWeight.w500),
            )),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              height: height,
              child: ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                  itemExtent: width,
                  itemCount: widget.contestant!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipOval(
                            child: CachedImage(
                              url: widget.contestant![index].image!,
                              fit: BoxFit.cover,
                            )
                        ),
                        SizedBox(height: 5.h),
                        Text("${widget.contestant![index].firstName.toString()} ${widget.contestant![index].lastName.toString()}",

                          style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.tertiary,
                              fontWeight: FontWeight.w500)
                        ),
                        SizedBox(height: 5.h),
                        Text("${widget.contestant![index].phone.toString()}",
                          style: theme.textTheme.headlineMedium?.copyWith(
                              color: theme.colorScheme.tertiary,
                              fontWeight: FontWeight.w300),),
                        SizedBox(height: 5.h),
                        Text(widget.contestant![index].votes.toString(),
                            style: theme.textTheme.headlineMedium?.copyWith(
                                color: theme.colorScheme.tertiary,
                                fontWeight: FontWeight.w300)),
                        Padding(
                          padding: EdgeInsets.all(8),
                          child: GestureDetector(
                            onTap: ()async {
                              SnackBar checking =SnackBar(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  showCloseIcon: true,
                                  content: Text(
                                      'Checking Subscription Please wait'.tr()
                                  ));
                              ScaffoldMessenger.of(context).showSnackBar(checking);
                              String status = await Check.checkToShow();
                              switch(status){
                                case "Not logged in":
                                  print("Not logged in");
                                  SnackBar logIn =SnackBar(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      content: Text(
                                          'Please subscribe to see ingredients and steps'.tr()
                                      ));
                                  loginFunction();
                                  ScaffoldMessenger.of(context).showSnackBar(logIn);
                                  break;
                                case "Another user logged in":
                                  print("Another user logged in");
                                  SnackBar logIn =SnackBar(
                                      padding: EdgeInsets.symmetric(vertical: 20),
                                      content: Text(
                                          'another_account_login'.tr()
                                      ));
                                  ScaffoldMessenger.of(context).showSnackBar(logIn);
                                  loginFunction();
                                  break;
                                case "User is subscribed":
                                  print("User is subscribed");


                                  CompetitionService cmp = CompetitionService();
                                  setState(() {
                                    Loading = true;
                                  });

                                  // try {
                                  //   var response = await cmp.likeCompetition(
                                  //       widget.competition.id!);
                                  //
                                  //   if(response?.statusCode == 200){
                                  //     setState(() {
                                  //       Loading = false;
                                  //     });
                                  //     likes++;
                                  //     ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Competition liked!')));
                                  //   }
                                  // } catch(e){
                                  //   setState(() {
                                  //     Loading = false;
                                  //   });
                                  //   ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                  // }



                                  break;
                                case "User is not subscribed":
                                  print("User is not subscribed");
                                  pushNewScreen(
                                    context,
                                    withNavBar: false,
                                    screen: AllSubscriptions(returnPrice: (int ) {  },
                                      first_name: "",
                                      last_name: "",
                                      isSignUp:
                                      false,phone: "",),
                                  );
                                  break;
                              }

                              setState(() {
                                Loading = false;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                              child: !Loading?Center(
                                child: Icon(
                                  Icons.thumb_up_sharp,
                                  color: Colors.white,
                                ),
                              ): CircularProgressIndicator(),
                            ),
                          ),
                        ),
                      ]
                    );
                  }
              ),
            ),
          ),
        )
      ],
    );
  }
  void loginFunction(){
    pushNewScreen(
      context,
      withNavBar: false,
      screen: AuthScreen(isSignIn: true),
    );
  }
}
