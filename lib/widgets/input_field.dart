import 'package:flutter/material.dart';

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

  const InputField({super.key,
    required this.controller,
    this.label,
    this.hint,
    this.icon,
    this.height = 75,
    this.width,
    this.type = 0,
    this.maxLines = 1,
    this.minLines = 1,
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
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        maxLines: maxLines,
        minLines: minLines,
        textAlignVertical: TextAlignVertical.top,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon) : null,
          labelText: label,
          hintText: hint,
          alignLabelWithHint: true,
          border: OutlineInputBorder(),
        ),
        validator: validator,
      ),
    );
  }

  String? validateNoType(String? value) {
    // No validation for NoType
    return null;
  }

  String? validateNameType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Name is required';
    }
    return null;
  }

  String? validateEmailType(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    } else
    if (!RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$').hasMatch(value)) {
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
