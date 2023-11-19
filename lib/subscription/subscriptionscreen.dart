import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:ethio_chef/models/subscriptionplans.dart' as h;
import 'package:ethio_chef/services/user_service.dart' as u;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../models/user.dart';
import '../theme/app_theme.dart';
import '../utils/screen_utils.dart';
import '../widgets/main_button.dart';

import 'package:url_launcher/url_launcher.dart';



Future<void> _launchUrl(String url, bool isTablet) async {
  final Uri _url = Uri.parse(url);
  if (!await launchUrl(_url)) {
    SnackBar(
        content: Text(
          'open_link_failed'.tr(),
          style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
        ));
  }
}


class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({super.key});

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
List<h.SubscriptionPlans> subscriptionPlans = [];
List<h.SubscriptionPlans> userSubscriptionPlans = [];

int user_id = 2;
late String duration;
late String durationu;
int currentYear = DateTime.now().year;
int currentMonth = DateTime.now().month;
Future<void>? _subscriptionPlansFuture;


@override
void initState() {
  super.initState();
  _subscriptionPlansFuture = getSubscriptionPlans();
}

  Future<void> getSubscriptionPlans() async {
    u.UserService service = u.UserService();
    User user = await service.fetchLoggedInUser();
  setState(() {
    user_id = user.id!;
  });

    var response = await service.fetchSubscriptionPlans();
    setState(() {
      subscriptionPlans = response;
    });

    var response1 = await service.fetchUserSubscriptions();
    setState(() {
      userSubscriptionPlans = response1;
    });

  }




@override
Widget build(BuildContext context) {
  return Scaffold(
    body: SafeArea(
        child: FutureBuilder(
            future: _subscriptionPlansFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Text(
                    userSubscriptionPlans.isEmpty ? 'Subscribe to a plan' :'Subscribe to a new plan',
                    style: Theme
                        .of(context)
                        .textTheme
                        .headlineLarge,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                      itemCount: subscriptionPlans.length,
                      itemBuilder: (context, index) {
                        duration =
                        subscriptionPlans[index].duration != null ?
                        //subscription duration is not null
                        subscriptionPlans[index].plan == 'Yearly' ?
                        //subscription duration is not null and subscription is yearly
                        '${currentYear -
                            subscriptionPlans[index].duration!.year} years'
                            :
                        //subscription duration is not null and subscription is monthly
                        '${currentMonth -
                            subscriptionPlans[index].duration!.month} months'
                            :
                        //subscription duration is null
                        '0';

                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Card(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    subscriptionPlans[index].plan!,
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    'Price: ${subscriptionPlans[index].price
                                        .toString()}',
                                    style: Theme
                                        .of(context)
                                        .textTheme
                                        .bodyMedium,
                                  ),
                                  if(duration != '0')Text('Duration: ${duration}'),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  MainButton(
                                    text: 'Subscribe',
                                    onPress: () async {
                                      print('Subscribe');
                                      var response = userSubscriptionPlans.isEmpty?
                                      await u
                                          .UserService()
                                          .createUserSubscription(
                                          subscriptionPlans[index].id!, user_id)
                                      :
                                      await u.UserService().updateUserSubscription(subscriptionPlans[index].id!, user_id)
                                      ;
                                      print('Sub: ${subscriptionPlans[index].id}, user: $user_id');
                                      print(response.statusCode);
                                      if (response.statusCode == 200) {
                                        setState(() {
                                          userSubscriptionPlans.isEmpty?userSubscriptionPlans.add(
                                              subscriptionPlans[index]): userSubscriptionPlans.forEach((element) {element = subscriptionPlans[index];});
                                        });
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                  userSubscriptionPlans.isEmpty? "Subscribed successfully": "Updated successfully",
                                                )
                                            )
                                        );
                                      }
                                      else {
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                  'Error: ${jsonDecode(
                                                      response.body)['message']}',
                                                )
                                            )
                                        );
                                      }
                                    },
                                  )
                                ],
                              )
                          ),
                        );
                      }
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  if(userSubscriptionPlans.isNotEmpty)Text(
                    'Your subscription',
                      style: Theme
                          .of(context)
                          .textTheme
                          .headlineLarge,
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                      itemCount: userSubscriptionPlans.length,
                      itemBuilder: (context, index) {
                        durationu =
                        userSubscriptionPlans.isNotEmpty?
                        userSubscriptionPlans[index].duration != null ?
                        //subscription duration is not null
                        userSubscriptionPlans[index].plan == 'Yearly' ?
                        //subscription duration is not null and subscription is yearly
                        '${currentYear -
                            userSubscriptionPlans[index].duration!.year} years'
                            :
                        //subscription duration is not null and subscription is monthly
                        '${currentMonth -
                            userSubscriptionPlans[index].duration!.month} months'
                            :
                        //subscription duration is null
                        '0'
                            : '0';
                        return Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20.w),
                          child: Card(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    userSubscriptionPlans[index].plan!,
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Text(
                                    'Price: ${userSubscriptionPlans[index].price}'
                                  ),
                                  
                                  if(durationu != '0')Text('Duration: ${durationu}'),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  MainButton(
                                    text: 'Delete',
                                    onPress: () async{
                                      print('Delete');
                                      u.UserService service = u.UserService();
                                      bool deleted = await service.deleteUserSubscription();
                                      if(deleted){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                                content: Text(
                                                  'Deleted successfully',
                                                )
                                            )
                                        );
                                        setState(() {
                                          userSubscriptionPlans.removeAt(index);
                                        });

                                      }
                                    }
                                  )
                                ]
                              )
                          )
                        );
                      }
                  )
                ],
              );
            }
            else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          }
        )
      ),
    );
  }
}
