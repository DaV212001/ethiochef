import 'package:flutter/material.dart';

class RouteLabelCards extends StatelessWidget {
  String text;
  RouteLabelCards({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: double.infinity,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: Text(text,
                style: TextStyle(fontWeight: FontWeight.bold,color: Colors.black)),
          ),
        ],
      ),
    );;
  }
}
