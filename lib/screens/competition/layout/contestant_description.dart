import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/screens/competition/layout/competition_header_image.dart';
import 'package:ethio_chef/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../models/contestants.dart';
import '../../../services/competition_service.dart';
import '../../../widgets/cached_image.dart';
import 'competition_header.dart';
import 'contestant_headers.dart';

class ContestantDescription extends StatefulWidget {
  Competition competition;
  Contestant contestant;
  ContestantDescription({super.key, required this.competition, required this.contestant});

  @override
  State<ContestantDescription> createState() => _ContestantDescriptionState();
}

class _ContestantDescriptionState extends State<ContestantDescription> {
  bool Loading = false;
  @override
  Widget build(BuildContext context) {
    String? firstName = widget.contestant.firstName;
    String formattedName = "${firstName}";
    ThemeData theme = Theme.of(context);
    return Scaffold(
      appBar: MainAppBar(
        hasSearchField: false,
        hasBackButton: true,
        hasMainIcons: false,
        isSearchScreen: false,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SafeArea(
                        child: ContestantHeaderImage(
                            video: widget.competition.videoFromContestant!,
                            image: widget.competition.image!,
                            contestant: widget.contestant
                        )
                    ),
                    Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CompetitionHeader(
                                  competition: widget.competition
                              ),
                              Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 50,
                                        height: 50,
                                        child: Image.asset("assets/images/logo.png",width: 50.sp, height: 50.sp)
                                    ),
                                    SizedBox(width: 10.h),
                                    Expanded(
                                        child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text("$formattedName",
                                                  style: TextStyle(
                                                      fontSize: 20.sp,
                                                      fontWeight: FontWeight.w800,
                                                      color: theme.colorScheme.secondaryContainer)),
                                            ]
                                        )
                                    ),
                                    SizedBox(width: 5.h),
                                    GestureDetector(
                                      onTap: ()async {
                                        setState(() {
                                          Loading = true;
                                        });
                                        print("voting");

                                        CompetitionService cmp = CompetitionService();
                                        print("voting 2");

                                        try {
                                          print("voting 3");
                                          print(widget.contestant.id!);
                                          print(widget.competition.id!);
                                          var response = await cmp.voteContestant(widget.contestant.id!, widget.competition.id!);

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
                                    )
                                  ]
                              )
                            ]
                        )
                    )
                  ]
              )
          )
      )
    );
  }
}
