import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputField extends StatelessWidget {
  static final NoType = 0;
  static final NameType = 1;
  static final EmailType = 2;
  static final PromoCodeType = 3;

  final TextEditingController controller;
  final String? label;
  final String? hint;
  final IconData? icon;
  final double height;
  final double? width;
  final int type;
  final int maxLines;
  final int minLines;
  final TextInputType inputType;
  final bool isObscure;
  void Function(String)? onChanged;
  final FocusNode? focus;

  // Observable to manage the obscured state
  final RxBool _isObscured = true.obs;

  InputField({
    super.key,
    required this.controller,
    this.focus,
    this.label,
    this.hint,
    this.icon,
    this.height = 76,
    this.width,
    this.type = 0,
    this.maxLines = 1,
    this.minLines = 1,
    this.isObscure = false, // Indicates whether the field is obscurable
    this.onChanged,
    this.inputType = TextInputType.text,
  });

  @override
  Widget build(BuildContext context) {
    String? Function(String?)? validator;

    switch (type) {
      case 0:
        validator = validateNoType;
        break;
      case 1:
        validator = validateNameType;
        break;
      case 2:
        validator = validateEmailType;
        break;
      case 3:
        validator = validatePromoCodeType;
        break;
      default:
        validator = null;
    }

    return Container(
      height: height,
      width: width,
      child: Obx(() {
        bool isObscured = _isObscured.value;
        return TextFormField(
          controller: controller,
          focusNode: focus,
          keyboardType: inputType,
          obscureText:
              isObscure ? _isObscured.value : false, // Toggle obscuring
          maxLines: isObscure ? 1 : maxLines,
          minLines: isObscure ? 1 : minLines,
          textAlignVertical: TextAlignVertical.center,
          decoration: InputDecoration(
            prefixIcon: icon != null
                ? Icon(
                    icon,
                    size: 20,
                  )
                : null,
            suffixIcon: isObscure
                ? IconButton(
                    icon: Icon(
                      _isObscured.value
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      _isObscured.toggle();
                    },
                  )
                : null,
            labelText: label,
            hintText: hint,
          ),
          validator: validator,
          onChanged: onChanged,
        );
      }),
    );
  }

  String? validateNoType(String? value) {
    if (value == null || value.isEmpty) {
      return 'enter_dish_name'.tr;
    }
    return null;
  }

  String? validateNameType(String? value) {
    if (value == null || value.isEmpty) {
      return "name_is_required".tr;
    }
    return null;
  }

  String? validateEmailType(String? value) {
    if (value == null || value.isEmpty) {
      return "email_is_required".tr;
    } else if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$')
        .hasMatch(value)) {
      return 'Invalid email format';
    }
    return null;
  }

  String? validatePromoCodeType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Promo code is required';
    } else if (value.length != 6) {
      return 'Promo code must be 6 characters';
    }
    return null;
  }
}
