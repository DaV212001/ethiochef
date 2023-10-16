import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PhoneInputField extends StatelessWidget {
  final TextEditingController controller;
  final double height;

  const PhoneInputField(
      {super.key, required this.controller, this.height = 75});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
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
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Phone number is required';
          } else if (value.length != 9 ||
              !RegExp(r'^[0-9]+$').hasMatch(value)) {
            return 'Invalid phone number';
          }
          return null;
        },
      ),
    );
  }
}
