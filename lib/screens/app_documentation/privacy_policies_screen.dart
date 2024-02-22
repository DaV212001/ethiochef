import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/privacy_policies.dart';
import '../../services/app_doc_services.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/info_card.dart';
import '../../widgets/main_app_bar.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  List<PrivacyPolicy> privacyPolicies = [];
  bool isLoading = true;


  @override
  void initState() {
    super.initState();
    fetchPrivacyPolicies();
  }

  Future<void> fetchPrivacyPolicies() async {
    privacyPolicies = await AppDocServices().fetchPrivacyPolicies();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    if(isLoading) {
      return Scaffold(
        appBar: MainAppBar(
          title: "privacy_policy".tr(),
          hasMainIcons: false,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if(privacyPolicies.length == 0) {
      return Scaffold(
        appBar: MainAppBar(
          title: "privacy_policy".tr(),
          hasMainIcons: false,
        ),
        body: Center(
            child: InfoCard(
                onPress: () {
                  fetchPrivacyPolicies();
                },
                infoTitle: "privacy_policy",
                infoBody: "no".tr(args: ["privacy_policy".tr()]),
                closeText: "",
                buttonText: "refresh".tr(),
                infoImage: "",
                closeBtn: false)),
      );
    }
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
        appBar: MainAppBar(
        title: "privacy_policy".tr(),
    hasMainIcons: false,
    ),
    body: Padding(
      padding: const EdgeInsets.only(top: 10, left: 12,right: 12),
      child: ListView.builder(
          physics: BouncingScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: privacyPolicies.length,
          itemBuilder: (context, index) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${privacyPolicies[index].title}. ",
                  softWrap: true,
                  overflow: TextOverflow.visible,
                  style: TextStyle(
                      fontSize: isTablet ? 15.sp : 19.sp,
                      fontWeight: FontWeight.w600,
                      color: theme.colorScheme.primary),
                ),
                SizedBox(width: 5,)
                ,SizedBox(
                  width: 350.sp,
                  child: Text(
                    "${privacyPolicies[index].body}",
                    softWrap: true,
                    overflow: TextOverflow.visible,
                    style: TextStyle(
                        fontSize: isTablet ? 15.sp : 19.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.secondaryContainer),
                  ),
                )
              ],);
          }),
    )
    );
  }
}
