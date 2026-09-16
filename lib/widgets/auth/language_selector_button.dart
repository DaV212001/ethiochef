import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:ethiochef/controllers/home_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../../controllers/category_controller.dart';
import '../../controllers/category_food_controller.dart';
import '../../controllers/theme_mode_controller.dart';
import '../../models/language.dart';
import '../../theme/model_theme.dart';
import '../../utils/screen_utils.dart';

class LanguageSelectorButton extends StatefulWidget {
  final Function() onChange;
  const LanguageSelectorButton({Key? key, required this.onChange});

  @override
  State<LanguageSelectorButton> createState() => _LanguageSelectorButtonState();
}

class _LanguageSelectorButtonState extends State<LanguageSelectorButton> {
  late Timer timer;
  late bool changed = false;
  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    ModelTheme lang = Provider.of<ModelTheme>(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              Text(
                Language.selectedLanguage.name,
                style: TextStyle(
                  fontSize: isTablet ? 11.sp : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.secondaryContainer,
                ),
              ),
            ],
          ),
        ),
        items: [
          ...Language.languages.map(
            (item) => DropdownMenuItem<Language>(
              value: item,
              child: Text(
                item.name,
                style: TextStyle(
                  fontSize: isTablet ? 11.sp : 15.sp,
                  fontWeight: FontWeight.w600,
                  color: theme.colorScheme.primary,
                ),
              ),
            ),
          ),
        ],
        onChanged: (value) {
          if (value == null) return;
          setState(() {
            Language.selectedLanguage = value;
            // lang.languageCode =
            //     value.code.countryCode ?? value.code.languageCode;
            // print(lang.languageCode);
            print(Language.selectedLanguage.name);
            Get.updateLocale(value.code);
            ThemeModeController.saveLanguage(value.code);
            changed = true;
          });
          widget.onChange();
          // RestartWidget.restartApp(context);
          if (Get.isRegistered<HomeController>()) {
            Get.find<HomeController>().fetchHomeData();
          }
          if (Get.isRegistered<CategoryController>()) {
            Get.find<CategoryController>().fetchCategories();
          }
          if (Get.isRegistered<CategoryFoodController>()) {
            Get.find<CategoryFoodController>().refreshData();
          }
        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).colorScheme.secondary,
          ),
          offset: const Offset(0, 8),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: List<double>.filled(Language.languages.length, 48),
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}
