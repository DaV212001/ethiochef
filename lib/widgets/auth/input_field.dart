import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final IconData? icon;
  final double height;

  const InputField(
      {super.key,
      required this.controller,
      required this.label,
      this.hint,
      this.icon,
      this.height = 75});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.text,
        decoration: InputDecoration(
          prefixIcon: icon != null ? Icon(icon): null,
          labelText: label,
          hintText: hint,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
