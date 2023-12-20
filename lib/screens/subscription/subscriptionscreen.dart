import 'dart:convert';

import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ethio_chef/models/subscriptionplans.dart' as h;
import 'package:ethio_chef/services/user_service.dart' as u;
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


import 'package:url_launcher/url_launcher.dart';

import '../../models/user.dart';
import '../../widgets/main_button.dart';
import '../../widgets/subscription/subscription_card.dart';



class SubscriptionScreen extends StatefulWidget {
  final Function()? onRefresh;
  const SubscriptionScreen({super.key, required this.onRefresh});

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
    appBar: MainAppBar(
      title: userSubscriptionPlans.isEmpty ? 'Subscribe to a plan' :'Subscribe to a new plan',
      hasMainIcons: false,
    ),
    body: SafeArea(
        child: FutureBuilder(
            future: _subscriptionPlansFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return SingleChildScrollView(
                child: Column(
                  children: [
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: subscriptionPlans.length,
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
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
                          return SubscriptionCard(
                            buttonName: 'Subscribe',
                            plan: subscriptionPlans[index].plan!,
                            price: subscriptionPlans[index].price.toString(),
                            duration: duration,
                            onTap: () async {
                              subscribeUser(index);
                            },
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
                        scrollDirection: Axis.vertical,
                        physics: BouncingScrollPhysics(),
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
                          return SubscriptionCard(
                            buttonName: 'Delete',
                            plan: userSubscriptionPlans[index].plan!,
                            price: userSubscriptionPlans[index].price.toString(),
                            duration: durationu,
                            onTap: (){
                              deleteSubscription(index);
                            },
                          );
                        }
                    )
                  ],
                ),
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
  void subscribeUser(int index)async{
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
      widget.onRefresh!();
      Navigator.of(context).pop();
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
  }
  void deleteSubscription(int index) async {
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
}
