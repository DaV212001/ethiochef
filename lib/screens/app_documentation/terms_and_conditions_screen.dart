import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/terms_and_conditions.dart';
import '../../services/app_doc_services.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/info_card.dart';
import '../../widgets/main_app_bar.dart';


class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() => _TermsAndConditionsScreenState();
}

class _TermsAndConditionsScreenState extends State<TermsAndConditionsScreen> {
  List<TermsAndConditions> termsAndConditions = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchTermsAndConditions();
  }

  Future<void> fetchTermsAndConditions() async {
    termsAndConditions = await AppDocServices().fetchTermsAndConditions();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if(isLoading) {
      return Scaffold(
        appBar: MainAppBar(
          title: "terms_and_conditions".tr(),
          hasMainIcons: false,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if(termsAndConditions.length == 0) {
      return Scaffold(
        appBar: MainAppBar(
          title: "terms_and_conditions".tr(),
          hasMainIcons: false,
        ),
        body: Center(
            child: InfoCard(
                onPress: () {
                  setState(() {
                    fetchTermsAndConditions();
                  });
                },
                infoTitle: "no_terms_and_conditions".tr(),
                infoBody: "",
                closeText: "",
                buttonText: "refresh".tr(),
                infoImage: "",
                closeBtn: false))
      );
    }
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
        appBar: MainAppBar(
          title: "terms_and_conditions".tr(),
          hasMainIcons: false,
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 10, left: 12,right: 12),
          child: ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: termsAndConditions.length,
              itemBuilder: (context, index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text(
                      termsAndConditions[index].title,
                      style: TextStyle(
                          fontSize: isTablet ? 8.sp : 13.sp,
                          fontWeight: FontWeight.w300),
                    ),
                    const Divider(),
                    Text(
                      termsAndConditions[index].body,
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
