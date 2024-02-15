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
import '../../subscription/layout/payment.dart';

class Contestants extends StatefulWidget {
  final int contest_id;
  final List<Contestant>? contestant;

  const Contestants({super.key, required this.contestant, required this.contest_id});

  @override
  State<Contestants> createState() => _ContestantsState();
}

class _ContestantsState extends State<Contestants> {
  bool Loading = false;

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    double height = 220;
    double width = 165;
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 10, right: 10, top: 10),
            child: Text(
              "vote_for_contestants".tr(),
              style: TextStyle(
                  fontSize: isTablet ? 13.sp : 17.sp,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.secondaryContainer),
            )),
        Padding(
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
                  return Card(
                    color: theme.cardColor,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedImage(
                          url: widget.contestant![index].image!,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 5.h),
                        Text("${widget.contestant![index].firstName.toString()} ${widget.contestant![index].lastName.toString()}",

                          style: TextStyle(
                              fontSize: isTablet ? 11.sp : 15.sp,
                              fontWeight: FontWeight.w800,
                              color: theme.colorScheme.secondaryContainer),
                        ),
                        SizedBox(height: 5.h),
                        Text("${widget.contestant![index].phone.toString()}",

                          style: TextStyle(
                              fontSize: isTablet ? 10.sp : 14.sp,
                              fontWeight: FontWeight.w400,
                              color: theme.colorScheme.secondaryContainer),),
                        SizedBox(height: 5.h),
                        Text('votes'.tr(args: [widget.contestant![index].votes.toString()]),
                          style: TextStyle(
                              fontSize: isTablet ? 10.sp : 14.sp,
                              fontWeight: FontWeight.w500,
                              color: theme.colorScheme.secondaryContainer),),
                        Align(
                          child: GestureDetector(
                            onTap: ()async {
                              setState(() {
                                Loading = true;
                              });
                              print("voting");

                              CompetitionService cmp = CompetitionService();
                              print("voting 2");

                              try {
                                print("voting 3");
                                print(widget.contestant![index].id!);
                                print(widget.contest_id!);
                                var response = await cmp.voteContestant(widget.contestant![index].id!, widget.contest_id!);

                                if(response?.statusCode == 200){
                                  setState(() {
                                    Loading = false;
                                  });
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Competition liked!')));
                                }
                              } catch(e){
                                setState(() {
                                  Loading = false;
                                });
                                ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
                              }

                              setState(() {
                                Loading = false;
                              });
                            },
                            child: Container(
                              width: 30,
                              height: 30,
                              child: !Loading?Center(
                                child: Icon(
                                  Icons.favorite_border,
                                  color: theme.colorScheme.primary,
                                ),
                              ): CircularProgressIndicator(),
                            ),
                          ),alignment: Alignment.bottomLeft,
                        )


                      ]
                    ),
                  );
                }
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
