import 'package:flutter/material.dart';

class AdCarouselComponent extends StatefulWidget {
  final String label;
  final String description;
  // final Icon? icon;
  AdCarouselComponent({super.key,
    required this.label,
    required this.description,
    // this.icon
  });

  @override
  State<AdCarouselComponent> createState() => _AdCarouselComponentState();
}

class _AdCarouselComponentState extends State<AdCarouselComponent> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Padding(
            padding: EdgeInsets.only(left: 17, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  widget.label,
                  style: TextStyle(
                      fontSize: 25,
                      color: theme.colorScheme.tertiary,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  widget.description,
                  style: const TextStyle(
                      fontSize: 10,
                      color: Colors.black,
                      fontWeight: FontWeight.bold),
                ),
                // const SizedBox(height: 5),
                // // Container(
                // //     decoration: BoxDecoration(
                // //       borderRadius: BorderRadius.circular(2),
                // //       border: Border(
                // //           right: BorderSide(
                // //               color: theme.colorScheme.primary,
                // //               width: 2),
                // //           left: BorderSide(
                // //               color: theme.colorScheme.primary,
                // //               width: 2),
                // //           bottom: BorderSide(
                // //               color: theme.colorScheme.primary,
                // //               width: 2),
                // //           top: BorderSide(
                // //               color: theme.colorScheme.primary,
                // //               width: 2)),
                // //     ),
                // //     child: widget.icon)
              ],
            ))
      ],
    );
  }
}
