import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';
import 'dart:io';

import '../../models/competition.dart';
import '../../theme/model_theme.dart';
import '../../utils/screen_utils.dart';
import '../main_button.dart';
class MyCompCard extends StatelessWidget {
  Competition comp;
  MyCompCard({super.key,
    required this.comp
  });

  @override
  Widget build(BuildContext context) {
    ModelTheme lang = Provider.of<ModelTheme>(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isTablet ? 10.w : 30.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Card(
            elevation: 3,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                        child: Text(
                          lang.languageCode == 'en' ? comp.name_en! : lang.languageCode == 'am' ? comp.name_am!: lang.languageCode == 'GB' ? comp.name_or! : comp.name_tr!,
                          style: TextStyle(
                              fontSize: isTablet ? 12.sp : 14.sp,
                              fontWeight: FontWeight.bold),
                        )),
                    Center(
                      child: Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5.r)),
                          child: SizedBox(
                            height: isTablet ? 80.h : 100.h,
                            width: isTablet ? 85.w : 110.w,
                            child: Image.file(
                              comp.imageFile!,
                              fit: BoxFit.fill,
                            ),
                          )),
                    )
                  ]),
            ),
          ),

          MainButton(
            text: 'Delete',
            onPress: () async {
              Competition.deleteCompetition(comp);
              Competition.savedCompetitions = await Competition.loadCompetitionsFromSharedPrefs();
            },
          ),
        ],
      ),
    );
  }

}
