import 'package:ethio_chef/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:ethio_chef/models/subscriptionplans.dart' as h;
import 'package:ethio_chef/services/user_service.dart' as u;
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../widgets/main_button.dart';





class AllSubscriptions extends StatefulWidget {
  final Function(int) returnPrice;
  const AllSubscriptions({super.key, required this.returnPrice});

  @override
  State<AllSubscriptions> createState() => _AllSubscriptionsState();
}

class _AllSubscriptionsState extends State<AllSubscriptions> {
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

    var response = await service.fetchSubscriptionPlans();
    setState(() {
      subscriptionPlans = response;
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
                  return Column(
                    children: [
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
                                          print("amount ${subscriptionPlans[index].price}");
                                          widget.returnPrice(subscriptionPlans[index].price!);
                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ],
                                  )
                              ),
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
