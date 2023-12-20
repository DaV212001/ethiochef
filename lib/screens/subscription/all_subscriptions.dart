import 'package:ethio_chef/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ethio_chef/models/subscriptionplans.dart' as h;
import 'package:ethio_chef/services/user_service.dart' as u;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../models/user.dart';
import '../../models/verification.dart';
import '../../services/payment_service.dart';
import '../../services/user_service.dart';
import '../../widgets/main_button.dart';
import '../../widgets/subscription/subscription_card.dart';
import '../auth/layout/payment_screen.dart';





class AllSubscriptions extends StatefulWidget {
  final String first_name;
  final String last_name;
  final String phone;
  final bool isSignUp;
  final bool? isStepper;
  final Function(int) returnPrice;
  const AllSubscriptions({super.key,
    required this.returnPrice,
    required this.isSignUp,
    required this.first_name,
    required this.last_name,
    required this.phone,
    this.isStepper = false});

  @override
  State<AllSubscriptions> createState() => _AllSubscriptionsState();
}

class _AllSubscriptionsState extends State<AllSubscriptions> {
  List<h.SubscriptionPlans> subscriptionPlans = [];
  List<h.SubscriptionPlans> userSubscriptionPlans = [];
  late String duration_user;

  int user_id = 2;
  String first_name = "";
  String last_name = "";
  String phone = "";
  late String duration;
  int currentYear = DateTime.now().year;
  int currentMonth = DateTime.now().month;
  Future<void>? _subscriptionPlansFuture;

  @override
  void initState() {
    super.initState();
    _subscriptionPlansFuture = getSubscriptionPlans();
    if(widget.isSignUp == false){
      getUserData();
    }else{
      print("isSignUp ${widget.isSignUp}");
      setState(() {
        first_name = widget.first_name;
        last_name = widget.last_name;
        phone = widget.phone;
      });
      print(first_name);
      print(last_name);
      print(phone);
    }
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

Future<void> getUserData() async {
  UserService service = u.UserService();
  User user = await service.fetchLoggedInUser();
  setState(() {
    user_id = user.id!;
    first_name = user.firstName;
    last_name = user.lastName;
    phone = user.phone!;
  });
}



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: widget.isStepper==false ? MainAppBar(
        title: userSubscriptionPlans.isEmpty ? 'Subscribe to a plan' :'Subscribe to a new plan',
        hasMainIcons: false,
      ): null,
      body: SafeArea(
          child: FutureBuilder(
              future: _subscriptionPlansFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return SingleChildScrollView(
                    scrollDirection: Axis.vertical,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      children: [
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
                              duration_user =
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
                                duration: duration_user,
                                onTap: (){
                                  deleteSubscription(index);
                                },
                              );
                            }
                        ),
                        ListView.builder(
                            shrinkWrap: true,
                            itemCount: subscriptionPlans.length,
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            itemBuilder: (context, index) {
                              duration =
                              subscriptionPlans[index].duration != null ?
                              subscriptionPlans[index].plan == 'Yearly' ?
                              '${currentYear -
                                  subscriptionPlans[index].duration!.year} years'
                                  :
                              '${currentMonth -
                                  subscriptionPlans[index].duration!.month} months'
                                  :
                              '0';
                              return SubscriptionCard(
                                buttonName: 'Subscribe',
                                plan: subscriptionPlans[index].plan!,
                                price: subscriptionPlans[index].price.toString(),
                                duration: duration,
                                onTap: () async {
                                  print("Subscribe");
                                  print(first_name);
                                  print(last_name);
                                  print(phone);
                                  Verification verification =
                                  await PaymentService().getChapaCheckoutLink(subscriptionPlans[index].price!, '', first_name, last_name+"_"+phone, phone);
                                  print("verification.checkoutUrl ${verification.checkoutUrl}");
                                  print("PaymentService");
                                  await pushNewScreen(context,
                                      screen: PaymentScreen(url: verification.checkoutUrl!)
                                  );

                                  // bool notpaid = await PaymentService().verifyChapaPayment(verification.txref!);
                                  // print(notpaid);
                                  print("amount ${subscriptionPlans[index].price}");
                                  widget.returnPrice(subscriptionPlans[index].price!);
                                  Navigator.of(context).pop();
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
