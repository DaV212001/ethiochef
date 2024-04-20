import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quickalert/quickalert.dart';
import 'package:ethio_chef/models/subscriptionplans.dart' as h;
import 'package:ethio_chef/services/user_service.dart' as u;

import '../../../widgets/subscription/subscription_card.dart';


class UserSubscription extends StatefulWidget {

  List<h.SubscriptionPlans> userSubscriptionPlans = [];
  String duration_user;
  UserSubscription({super.key,
    required this.userSubscriptionPlans,
    required this.duration_user
  });

  @override
  State<UserSubscription> createState() => _UserSubscriptionState();
}

class _UserSubscriptionState extends State<UserSubscription> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
            'your_sub'.tr(),
            style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.secondaryContainer)
        ),
        SizedBox(
          height: 20.h,
        ),
        SizedBox(
          width: 300.w,
          child: ListView.builder(
              shrinkWrap: true,
              itemCount: widget.userSubscriptionPlans.length,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                widget.duration_user =
                widget.userSubscriptionPlans.isNotEmpty ?
                widget.userSubscriptionPlans[index].duration
                    .toString() + " Months left" : "0";
                return SubscriptionCard(
                  buttonName: 'delete'.tr(),
                  plan: widget.userSubscriptionPlans[index].plan!,
                  price: widget.userSubscriptionPlans[index].price
                      .toString(),
                  duration: widget.duration_user,
                  onTap: () async {

                    await QuickAlert.show(
                      context: context,
                      type: QuickAlertType.error,
                      showCancelBtn: true,
                      showConfirmBtn: true,
                      title: "warning".tr(),
                      text: 'delete_subscription_warning'.tr(),
                      titleAlignment: TextAlign.center,
                      textAlignment: TextAlign.center,
                      confirmBtnText: 'delete'.tr(),
                      onConfirmBtnTap: (){
                        deleteSubscription(index);
                      },
                      cancelBtnText: 'cancel'.tr(),
                      onCancelBtnTap: (){
                        Navigator.pop(context);
                      },
                      confirmBtnColor: Colors.red,
                      cancelBtnTextStyle: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold
                      ),
                      backgroundColor: Colors.white,
                      headerBackgroundColor: Colors.grey,
                      confirmBtnTextStyle: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                      barrierColor: Colors.red,
                      titleColor: Colors.red,
                      textColor: Colors.red,
                    );

                  },
                );
              }
          ),
        ),
        SizedBox(height: 5,),



      ],
    );
  }
  void deleteSubscription(int index) async {
    print('Delete');
    u.UserService service = u.UserService();
    bool deleted = await service.deleteUserSubscription();
    if (deleted) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                'Deleted successfully',
              )
          )
      );
      setState(() {
        widget.userSubscriptionPlans.removeAt(index);
      });
    }
  }
}
