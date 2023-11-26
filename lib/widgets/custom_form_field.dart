import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../theme/app_theme.dart';
import '../utils/screen_utils.dart';

class CustomFormField extends StatelessWidget {
  final TextEditingController controller;
  final String name;
  final bool required;
  final int maxLines;
  final int minLines;
  final String? hint;

  const CustomFormField({
    required this.controller,
    required this.name,
    this.required = true,
    this.maxLines = 1,
    this.minLines = 1,
    this.hint,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    return TextFormField(
      maxLines: maxLines,
      minLines: minLines,
      keyboardType: TextInputType.name,
      controller: controller,
      textAlignVertical: TextAlignVertical.top,
      style: isTablet ? AppTheme.inputFieldStyleTablet : null,
      decoration: InputDecoration(
        hintText: hint,
        labelText: name,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.r),
        ),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide:
            BorderSide(width: 1, color: Theme
                .of(context)
                .colorScheme
                .primary)
        ),
        errorStyle: isTablet ? AppTheme.inputFieldErrorStyleTablet : null,
      ),
      validator: (value) {
        if (value!.isEmpty && required) {
          return "is_required".tr(args: [name]);
        }
        return null;
      },
    );
  }
}
