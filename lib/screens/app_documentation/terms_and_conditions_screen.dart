import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/terms_and_conditions.dart';
import '../../services/app_doc_services.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/info_card.dart';

class TermsAndConditionsScreen extends StatefulWidget {
  const TermsAndConditionsScreen({super.key});

  @override
  State<TermsAndConditionsScreen> createState() =>
      _TermsAndConditionsScreenState();
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
    ThemeData theme = Theme.of(context);
    if (isLoading) {
      return Scaffold(
        // appBar: MainAppBar(
        //   title: "terms_and_conditions".tr(),
        //   hasMainIcons: false,
        // ),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (termsAndConditions.length == 0) {
      return Scaffold(
          // appBar: MainAppBar(
          //   title: "terms_and_conditions".tr(),
          //   hasMainIcons: false,
          // ),
          body: Center(
              child: InfoCard(
                  onPress: () {
                    setState(() {
                      fetchTermsAndConditions();
                    });
                  },
                  infoTitle: "terms_and_conditions".tr(),
                  infoBody: "no".tr(args: ["terms_and_conditions".tr()]),
                  closeText: "",
                  buttonText: "refresh".tr(),
                  infoImage: "",
                  closeBtn: false)));
    }
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
        // appBar: MainAppBar(
        //   title: "terms_and_conditions".tr(),
        //   hasMainIcons: false,
        // ),
        body: Padding(
            padding: const EdgeInsets.only(top: 10, left: 12, right: 12),
            child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: termsAndConditions.length,
                itemBuilder: (context, index) {
                  return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${termsAndConditions[index].title}. ",
                          softWrap: true,
                          overflow: TextOverflow.visible,
                          style: TextStyle(
                              fontSize: isTablet ? 15.sp : 19.sp,
                              fontWeight: FontWeight.w600,
                              color: theme.colorScheme.primary),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        SizedBox(
                            width: 360.sp,
                            child: Text("${termsAndConditions[index].body}",
                                softWrap: true,
                                overflow: TextOverflow.visible,
                                style: TextStyle(
                                    fontSize: isTablet ? 15.sp : 19.sp,
                                    fontWeight: FontWeight.w600,
                                    color:
                                        theme.colorScheme.secondaryContainer)))
                      ]);
                })));
  }
}
