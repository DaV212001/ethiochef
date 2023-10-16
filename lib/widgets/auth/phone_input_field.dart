import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  const PhoneInputField({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 75,
      child: TextFormField(
        maxLength: 9,
        controller: controller,
        keyboardType: TextInputType.phone,
        decoration: InputDecoration(
          prefixIcon: Icon(CupertinoIcons.phone),
          labelText: 'Phone Number',
          prefixText: '+251 ',
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
