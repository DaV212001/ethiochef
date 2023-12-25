import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/screens/competition/competition_screen.dart';
import 'package:ethio_chef/services/competition_service.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/theme/model_theme.dart';
import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../models/recipe_show_checker.dart';
import '../../screens/auth/auth_screen.dart';
import '../../screens/subscription/all_subscriptions.dart';

class CompetitionsCard extends StatefulWidget {
  final Competition competition;

  const CompetitionsCard({Key? key, required this.competition}) : super(key: key);

  @override
  _CompetitionsCardState createState() => _CompetitionsCardState();
}

class _CompetitionsCardState extends State<CompetitionsCard> {

  bool Loading = false;
  int likes = 0;


  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ModelTheme lang = Provider.of<ModelTheme>(context);
    return GestureDetector(
      onTap: () {
        pushNewScreen(
          context,
          withNavBar: false,
          screen: CompetitionScreen(competition: widget.competition),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: AppTheme.allBorderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
                width: double.infinity,
                height: 160.h,
                child: ClipRRect(
                  borderRadius: AppTheme.topBorderRadius,
                  child: CachedImage(
                    url: widget.competition.image.toString(),
                    fit: BoxFit.fill,
                  ),
                )),
            SizedBox(
              height:9.h,
            ),
            Container(
              margin: EdgeInsets.symmetric(
                horizontal: 10.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        lang.languageCode == 'en'? widget.competition.name_en!.toString() : lang.languageCode == 'am'? widget.competition.name_am!.toString(): lang.languageCode == 'GB'? widget.competition.name_or!.toString() : widget.competition.name_tr!.toString(),
                        style: theme.textTheme.headlineMedium,
                        textAlign: TextAlign.start,
                      ),
                      Text(
                        "votes".tr(args: [widget.competition.votes.toString()]),
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: theme.unselectedWidgetColor),
                        textAlign: TextAlign.start,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 9.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "days_left".tr(args: [widget.competition.daysLeft.toString()]),
                        style: theme.textTheme.labelMedium
                            ?.copyWith(color: theme.unselectedWidgetColor),
                        textAlign: TextAlign.start,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
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
                                    try {
                                      var response = await cmp.likeCompetition(
                                          widget.competition.id!);

                                      if(response?.statusCode == 200){
                                        setState(() {
                                          Loading = false;
                                        });
                                        likes++;
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Competition liked!')));
                                      }
                                    } catch(e){
                                      setState(() {
                                        Loading = false;
                                      });
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                                    }



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
                          Text('${likes}  likes', style: theme.textTheme.bodySmall)
                        ],
                      )

                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
