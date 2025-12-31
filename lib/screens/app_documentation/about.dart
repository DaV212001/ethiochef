import 'package:easy_localization/easy_localization.dart' as e;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../controllers/about_controlller.dart';
import '../../utils/error_util.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/main_app_bar.dart';
import '../../widgets/main_button.dart';

class AboutScreen extends StatelessWidget {
  AboutScreen({super.key});

  final AboutUsController aboutUsController = Get.put(AboutUsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        title: e.tr("about"),
        hasMainIcons: false,
      ),
      body: Obx(
        () {
          if (aboutUsController.isLoading.value == ApiCallStatus.loading) {
            return Center(child: CircularProgressIndicator());
          }

          if (aboutUsController.aboutUs.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(e.tr("about") + "" + e.tr("no")),
                  MainButton(
                      text: e.tr('refresh'),
                      onPress: () => aboutUsController.fetchAboutUs())
                ],
              ),
            );
          }
          final bool isTablet = ScreenUtils.isTablet(context);
          ThemeData theme = Theme.of(context);
          return ListView.builder(
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: aboutUsController.aboutUs.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${aboutUsController.aboutUs[index].title}. ",
                      softWrap: true,
                      overflow: TextOverflow.visible,
                      style: TextStyle(
                        fontSize: isTablet ? 15.sp : 19.sp,
                        fontWeight: FontWeight.w600,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    SizedBox(width: 5),
                    SizedBox(
                      width: 350.sp,
                      child: Text(
                        "${aboutUsController.aboutUs[index].description}",
                        softWrap: true,
                        overflow: TextOverflow.visible,
                        style: TextStyle(
                          fontSize: isTablet ? 15.sp : 19.sp,
                          fontWeight: FontWeight.w600,
                          color: theme.colorScheme.secondaryContainer,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
