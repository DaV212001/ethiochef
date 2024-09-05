import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';

class PhoneInputField extends StatefulWidget {
  final TextEditingController controller;
  final double height;
  final bool? validate;
  final GlobalKey<FormState>? formKey;

  const PhoneInputField(
      {super.key,
      required this.controller,
      this.height = 85,
      this.validate,
      this.formKey});

  @override
  State<PhoneInputField> createState() => _PhoneInputFieldState();
}

class _PhoneInputFieldState extends State<PhoneInputField> {
  @override
  Widget build(BuildContext context) {
    return FormField<String>(
      // key: widget.formKey,
      builder: (validationState) {
        return IntlPhoneField(
          // key: widget.formKey,
          controller: widget.controller,
          decoration: InputDecoration(
            prefixIcon: Icon(CupertinoIcons.phone),
            labelText: "phone_number".tr(),
            errorText:
                validationState.hasError ? validationState.errorText : null,
            // border: OutlineInputBorder(),
          ),
          initialCountryCode: 'ET',
          // onSubmitted: (value) {
          //   validationState.didChange(value);
          // },
          onChanged: (phone) {
            validationState.didChange(phone.number);
          },
          pickerDialogStyle: PickerDialogStyle(
              searchFieldInputDecoration: InputDecoration(
            labelText: "search_country".tr(),
          )),
          invalidNumberMessage: "invalid_phone_number".tr(),
          // disableLengthCheck: true,
          // autovalidateMode: AutovalidateMode.always,
        );
      },
      // autovalidateMode: AutovalidateMode.always,
      validator: (value) {
        print('Validation cc: ${value == null}');
        if (value == null || value.isEmpty) {
          print('Validation cc: ${(value == null || value.isEmpty)}');
          return "phone_number_required".tr();
        }
        return null;
      },
    );
  }
}
// InternationalPhoneNumberInput(
//   controller: widget.controller,
//   onInputChanged: (value) {
//     print('CHECKING PHONE INPUT: ${value.dial_code + value.dial_code + value.code}');
//     },
//
//   initCountry: CountryCodeModel(
//       name: "Ethiopia", dial_code: "+251", code: "ET"),
//   phoneConfig: PhoneConfig(
//     hintText: "phone_number".tr(),
//     labelText: "phone_number".tr(),
//     borderWidth: 0
//   ),
//   validator: (value) {
//     if (value.number.isEmpty) {
//       return "phone_number_required".tr();
//     }
//     return null;
//   },
// )
// TextFormField(
//   maxLength: 9,
//   controller: controller,
//   keyboardType: TextInputType.phone,
//   decoration: InputDecoration(
//     prefixIcon: Icon(CupertinoIcons.phone),
//     labelText: "phone_number".tr(),
//     prefixText: '+251'
//     // border: OutlineInputBorder(),
//   ),
//   validator: (value) {
//     if (value == null || value.isEmpty) {
//       return "phone_number_required".tr();
//     } else if (value.length != 9 ||
//         !RegExp(r'^[0-9]+$').hasMatch(value)) {
//       return "invalid_phone_number".tr();
//     }
//     return null;
//   },
// ),
