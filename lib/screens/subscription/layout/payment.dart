import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/payment_methods.dart';
import 'package:ethio_chef/screens/subscription/layout/payment_step.dart';
import 'package:ethio_chef/screens/subscription/layout/stepper_buttons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'dart:convert';
import '../../../main.dart';
import '../../../models/subscriptionplans.dart';
import '../../../models/user.dart';
import '../../../services/payment_service.dart';
import '../../../services/user_service.dart';
import '../../../widgets/error_card.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/main_app_bar.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/subscription/steps_header.dart';
import '../../auth/layout/payment_screen.dart';
import 'all_subscription_plans_steps.dart';

class PaymentCheckout extends StatefulWidget {
  SubscriptionPlans? selectedSubscriptionPlan;
  Map? userData;
  bool? isInActiveUserSubscription;
  bool? isNormalSubscription;
  PaymentCheckout({super.key,
    this.userData,
    this.selectedSubscriptionPlan,
  this.isInActiveUserSubscription = false,
    this.isNormalSubscription = false
  });

  @override
  State<PaymentCheckout> createState() => _PaymentCheckoutState();
}

class _PaymentCheckoutState extends State<PaymentCheckout> {
  int activeStep = 0;
  Future? _future;
  PaymentMethods? paymentMethod;
  SubscriptionPlans? subscriptionPlan;
  User? user;
  bool awaitResponse = false;
  bool showBackButton = true;

  Future<dynamic> fetchData() async {
    try {
      final paymentService = PaymentService();
      print("fetchPaymentData");
      final paymentData = await paymentService.fetchAllPayments();
      final subscriptionData = UserService();
      print("fetchSubscriptionPlans");
      final allSubscriptionData = await subscriptionData.fetchAllSubscriptionPlans();
      final userService = UserService();
      if(widget.isNormalSubscription==true){
        print("fetchUserSubscriptions");
        final userSubscriptionPlan = await userService.fetchUserSubscriptions();
        return [allSubscriptionData, paymentData, userSubscriptionPlan]; 
      }
      return [allSubscriptionData, paymentData];
    } catch (error) {
      print('Error: $error');
      rethrow;
    }
  }

  @override
  void initState() {
    super.initState();
    _future = fetchData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: MainAppBar(
          title: widget.isNormalSubscription == true ? 'payment'.tr(): 'your_sub'.tr(),
          hasMainIcons: false,
        ),
        body: SafeArea(
            child: FutureBuilder(
              future: _future,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Loading();
                }
                if (snapshot.hasError) {
                  return Center(
                      child: ErrorCard(
                        errorType: snapshot.error.toString(),
                        refresh: () {
                          setState(() {
                            _future = fetchData();
                          });
                        },
                      ));
                }
                if(widget.isNormalSubscription == true){
                  return buildSubscriptionScreen(
                      snapshot.data[0] as List<SubscriptionPlans>,
                      snapshot.data[1] as List<PaymentMethods>,
                      snapshot.data[2] as List<SubscriptionPlans>);
                }
                return buildIsInActiveUserSubscription(
                    snapshot.data[0] as List<SubscriptionPlans>,
                    snapshot.data[1] as List<PaymentMethods>);
              },
            )));
  }


  Widget buildIsInActiveUserSubscription(
      List<SubscriptionPlans> subscriptionPlans,
      List<PaymentMethods> payment) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            StepsHeader(activeStep: activeStep),
            Visibility(
              visible: activeStep == 0,
              child: AllSubscriptionStep(
                subscriptionPlans: subscriptionPlans,
                returnPrice: (subscriptionPrice){
                  setState(() {
                    subscriptionPlan = subscriptionPrice;
                  });
                  if (subscriptionPlan == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('please_select_a_price'.tr())),
                    );
                    return;
                  }else{
                    setState(() {
                      activeStep++;
                    });
                  }
                }, isNormalSubscription: widget.isNormalSubscription!
              )
            ),
            Visibility(
              visible: activeStep == 1,
              child: PaymentStep(
                payments: payment,
                returnSelectedPayment: (paymentSelected) async {
                  setState(() {
                    paymentMethod = paymentSelected;
                  });
                  if (paymentMethod == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('please_select_a_payment_method'.tr())),
                    );
                    return;
                  }else{
                    makePayment();
                  }
                }
              )
            ),
            if(activeStep != 0)
            MainButton(width: double.infinity, onPress: decrementStep!, text: 'back'.tr())
          ],
        ),
      ),
    );
  }

  Widget buildSubscriptionScreen(
      List<SubscriptionPlans> subscriptionPlans,
      List<PaymentMethods> payment,
      List<SubscriptionPlans> userSubscriptionPlan) {

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 15.w),
        child: Column(
          children: [
            StepsHeader(activeStep: activeStep),
            Visibility(
              visible: activeStep == 0,
              child: AllSubscriptionStep(
                isNormalSubscription: widget.isNormalSubscription!,
                subscriptionPlans: subscriptionPlans,
                 userSubscriptionPlans:userSubscriptionPlan,
                returnPrice: (subscription){
                  print(subscription);
                  setState(() {
                    subscriptionPlan = subscription;
                    activeStep++;
                  });
                  print(subscriptionPlan);
                },
              ),
            ),
            Visibility(
              visible: activeStep == 1,
              child: PaymentStep(
                payments: payment,
                returnSelectedPayment: (paymentSelected) async {
                  setState(() {
                    user = userSubscriptionPlan[0].user;
                  });
                  print(paymentSelected.bank_name);
                  setState(() {
                    paymentMethod = paymentSelected;
                  });
                  print(subscriptionPlan!.duration);
                  print(user!.firstName);
                  makePayment();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> incrementStep() async {
    if (activeStep == 1) {
    }
  }

  void decrementStep() {
    if (activeStep == 1) {
      subscriptionPlan = null;
    }
    if (activeStep == 1) {
        paymentMethod = null;
        setState(() {
          awaitResponse = false;
        });
    }
    setState(() {
      activeStep--;
    });
  }
  makePayment() async {
     final service = PaymentService();
     late var response;
     if(widget.isNormalSubscription == true){
       Map unWanted = {};//used to avoid the null values
       response = await service.makePayment(
           unWanted, paymentMethod!.id, user!, subscriptionPlan!.price!, false
       );
     }else{
       print("isInActiveUser Signing up");
       print(subscriptionPlan!.price);
       print(subscriptionPlan!.duration);
       User unWanted = User(
           firstName: "",
           lastName: ""
       );
       response = await service.makePayment(
           widget.userData!, paymentMethod!.id, unWanted, subscriptionPlan!.price!, true
       );
     }
print('response: ${response.body}');
     if(response.statusCode==200) {
       var checkoutUrl = jsonDecode(response.body)['data']['checkout_url'];
       print(jsonDecode(response.body)['data']['checkout_url']);
       print(checkoutUrl);
       await pushNewScreen(context,
           screen: PaymentScreen(
               url: checkoutUrl)
       );
      RestartWidget.restartApp(context);
     }

     setState(() {
       awaitResponse = false;
     });
  }

}