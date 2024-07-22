import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../models/competition.dart';
import '../../../models/contestants.dart';
import '../../../services/competition_service.dart';
import '../../../utils/screen_utils.dart';
import '../../auth/auth_screen.dart';
import 'contestant_description.dart';

class Contestants extends StatefulWidget {
  final int contest_id;
  final Competition competition;
  final List<Contestant>? contestant;
  final Function() refresh;
  Contestants(
      {super.key,
      required this.contestant,
      required this.contest_id,
      required this.competition,
      required this.refresh});

  @override
  State<Contestants> createState() => _ContestantsState();
}

class _ContestantsState extends State<Contestants> {
  bool Loading = false;
  bool isVoted = false;
  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    double height = 180;
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
                  return Container(
                    color: theme.cardColor,
                    child: GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(context,
                            screen: ContestantDescription(
                                competition: widget.competition,
                                contestant: widget.contestant![index]));
                      },
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ClipOval(
                              child: Container(
                                  width: 50,
                                  height: 50,
                                  child: widget.contestant![index].image! != ""
                                      ? Image.network(
                                          widget.contestant![index].image!,
                                          fit: BoxFit.fill,
                                        )
                                      : Image.asset("assets/images/logo.png",
                                          width: 50.sp, height: 50.sp)),
                            ),
                            Text(
                              "${widget.contestant![index].firstName.toString()}",
                              style: TextStyle(
                                  fontSize: isTablet ? 12.sp : 17.sp,
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.secondaryContainer),
                            ),
                            SizedBox(height: 5.h),
                            Text(
                              'votes'.tr(args: [
                                widget.contestant![index].votes.toString()
                              ]),
                              style: TextStyle(
                                  fontSize: isTablet ? 10.sp : 14.sp,
                                  fontWeight: FontWeight.w500,
                                  color: theme.colorScheme.secondaryContainer),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            MainButton(
                                width: double.infinity,
                                isLoading: Loading,
                                text: "please_vote".tr(),
                                onPress: () async {
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
                                    var response = await cmp.voteContestant(
                                        widget.contestant![index].id!,
                                        widget.contest_id!);

                                    if (response?.statusCode == 200) {
                                      setState(() {
                                        Loading = false;
                                      });
                                      widget.refresh();
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(SnackBar(
                                              content:
                                                  Text('Competition liked!')));
                                    }
                                  } catch (e) {
                                    setState(() {
                                      Loading = false;
                                    });
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(e.toString() ==
                                                'You have already voted for this contestant'
                                            ? "already_voted".tr()
                                            : e.toString()),
                                      ),
                                    );
                                  }

                                  setState(() {
                                    Loading = false;
                                  });
                                })
                          ]),
                    ),
                  );
                }),
          ),
        )
      ],
    );
  }

  void loginFunction() {
    PersistentNavBarNavigator.pushNewScreen(
      context,
      withNavBar: false,
      screen: AuthScreen(isSignIn: true),
    );
  }
}
