import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AuthHeaderImage extends StatefulWidget {
  final String image;

  const AuthHeaderImage(
      {super.key,
        required this.image});

  @override
  State<AuthHeaderImage> createState() => _AuthHeaderImageState();
}

class _AuthHeaderImageState extends State<AuthHeaderImage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return Image.asset(widget.image);
  }

  Widget circularBackground({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: Theme.of(context).colorScheme.tertiary.withOpacity(0.7)),
      child: child,
    );
  }
}
