import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CompetitionHeaderImage extends StatefulWidget {
  final String image;

  const CompetitionHeaderImage(
      {super.key,
      required this.image});

  @override
  State<CompetitionHeaderImage> createState() => _CompetitionHeaderImageState();
}

class _CompetitionHeaderImageState extends State<CompetitionHeaderImage> {
 

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return Stack(children: [
      SizedBox(
        width: width,
        height: height * 0.4,
        child: CachedImage(url: widget.image, fit: BoxFit.cover),
      ),
      Positioned(
        top: 5,
        left: 10,
        child: SafeArea(
          child: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: circularBackground(
                child: Icon(
                  Icons.arrow_back,
                  color: theme.colorScheme.background,
                ),
              )),
        ),
      )
    ]);
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
