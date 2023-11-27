import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/privacy_policies.dart';
import '../../services/app_doc_services.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/main_app_bar.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  List<PrivacyPolicy> privacyPolicies = [];


  @override
  void initState() {
    super.initState();
    fetchPrivacyPolicies();
  }

  Future<void> fetchPrivacyPolicies() async {
    privacyPolicies = await AppDocServices().fetchPrivacyPolicies();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
        appBar: MainAppBar(
        title: "Privacy Policy".tr(),
    hasMainIcons: false,
    ),
    body: Padding(
      padding: const EdgeInsets.only(top: 10, left: 12,right: 12),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: privacyPolicies.length,
          itemBuilder: (context, index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  privacyPolicies[index].title,
                  style: TextStyle(
                      fontSize: isTablet ? 8.sp : 13.sp,
                      fontWeight: FontWeight.w300),
                ),
                const Divider(),
                Text(
                  privacyPolicies[index].body,
                  style: TextStyle(
                      fontSize: isTablet ? 11.sp : 16.sp,
                      fontWeight: FontWeight.w500),
                ),

              ],
            );
          }),
    )
    );
  }
}
