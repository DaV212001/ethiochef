import 'package:flutter/material.dart';

class RouteLabelCards extends StatelessWidget {
  String text;
  RouteLabelCards({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Color(0xFFD2691E), Color(0xFFFEC20A)]),
          // borderRadius: BorderRadius.all(Radius.circular(10))
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(text,
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.grey[100])),
          ),
        ],
      ),
    );;
  }
}
