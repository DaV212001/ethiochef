import 'dart:async';

import 'package:abushakir/abushakir.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../models/language.dart';
import '../../models/subscriptionplans.dart';
import '../../services/user_service.dart';
import '../../utils/screen_utils.dart';
import '../main_button.dart';

class SubscriptionDropDown extends StatefulWidget {
  SubscriptionPlans? selectedSubscriptionPlan;
  final Function(SubscriptionPlans) onChange;
  SubscriptionDropDown({
    Key? key,
    required this.onChange,
    this.selectedSubscriptionPlan,
  });

  @override
  State<SubscriptionDropDown> createState() => _SubscriptionDropDownState();
}

class _SubscriptionDropDownState extends State<SubscriptionDropDown> {
  Future? future;
  @override
  void initState() {
    // TODO: implement initState
    future = fetchSubscriptionPlans();
    super.initState();
  }

  Future<dynamic> fetchSubscriptionPlans() async {
    final subscriptionData = UserService();
    print("fetchSubscriptionPlans");
    final allSubscriptionData = await subscriptionData
        .fetchAllSubscriptionPlans();
    print(allSubscriptionData);
    widget.onChange(allSubscriptionData[0]);
    return allSubscriptionData;
  }

  late Timer timer;
  late bool changed = false;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        if (snapshot.hasError) {
          return Center(
            child: MainButton(
              width: 200.w,
              text: "refresh".tr,
              onPress: () {
                setState(() {
                  future = fetchSubscriptionPlans();
                });
              },
            ),
          );
        }
        return buildDropDownMenu(snapshot.data as List<SubscriptionPlans>);
      },
    );
  }

  bool hasSelected = false;
  @override
  Widget buildDropDownMenu(List<SubscriptionPlans> subscriptionPlans) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: buildShowableCard(widget.selectedSubscriptionPlan!),
        ),
        items: [
          ...subscriptionPlans.map(
            (item) => DropdownMenuItem<SubscriptionPlans>(
              value: item,
              child: buildCard(item),
            ),
          ),
        ],
        onChanged: (value) {
          print(hasSelected);
          print(value!.price);
          print(value!.duration);
          setState(() {
            hasSelected = true;
            widget.selectedSubscriptionPlan = value;
          });
          print(widget.selectedSubscriptionPlan!.price);
          print(widget.selectedSubscriptionPlan!.duration);
          print(hasSelected);
          widget.onChange(value);
        },
        dropdownStyleData: DropdownStyleData(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            border: Border.all(
              color: Theme.of(context).colorScheme.primary,
              width: 0.5,
            ),
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).colorScheme.secondary,
          ),
          offset: const Offset(0, 8),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: List<double>.filled(subscriptionPlans.length, 48),
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }

  Widget buildCard(SubscriptionPlans item) {
    ThemeData theme = Theme.of(context);
    DateTime now = DateTime.now();
    Duration duration = Duration(days: item.duration! * 30);
    DateTime expirationDate = now.add(duration);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${Language.getLocaleCode() == 'en' ? 'Birr' : "ብር"} ${item.price.toString()}',
          style: TextStyle(
            color: theme.colorScheme.secondaryContainer,
            fontWeight: FontWeight.w400,
          ),
        ),
        Expanded(
          child: Text(
            '${Language.getLocaleCode() == 'en' ? 'Good until' : "እስከ"} ${Language.getLocaleCode() == 'en' ? DateFormat('MMMM dd, yyyy').format(expirationDate) : '${EtDatetime.fromMillisecondsSinceEpoch(expirationDate.millisecondsSinceEpoch).monthGeez} ${EtDatetime.fromMillisecondsSinceEpoch(expirationDate.millisecondsSinceEpoch).day}, ${EtDatetime.fromMillisecondsSinceEpoch(expirationDate.millisecondsSinceEpoch).year}'}',
            style: TextStyle(
              fontSize: 12,
              color: theme.colorScheme.secondaryContainer,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildShowableCard(SubscriptionPlans item) {
    ThemeData theme = Theme.of(context);
    DateTime now = DateTime.now();
    Duration duration = Duration(days: item.duration! * 30);
    DateTime expirationDate = now.add(duration);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 16.0),
          child: Icon(Icons.payment_rounded),
        ),
        Text(
          '${Language.getLocaleCode() == 'en' ? 'Birr' : "ብር"} ${item.price.toString()}',
          style: TextStyle(
            color: theme.colorScheme.secondaryContainer,
            fontWeight: FontWeight.w400,
          ),
        ),
        SizedBox(width: 10),
        Expanded(
          child: Text(
            '${Language.getLocaleCode() == 'en' ? 'Good until' : "እስከ"} ${Language.getLocaleCode() == 'en' ? DateFormat('MMMM dd, yyyy').format(expirationDate) : '${EtDatetime.fromMillisecondsSinceEpoch(expirationDate.millisecondsSinceEpoch).monthGeez} ${EtDatetime.fromMillisecondsSinceEpoch(expirationDate.millisecondsSinceEpoch).day}, ${EtDatetime.fromMillisecondsSinceEpoch(expirationDate.millisecondsSinceEpoch).year}'}',
            style: TextStyle(
              color: theme.colorScheme.secondaryContainer,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
      ],
    );
  }
}
