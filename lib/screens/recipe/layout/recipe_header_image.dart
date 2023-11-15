import 'package:ethio_chef/widgets/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class RecipeHeaderImage extends StatefulWidget {
  final String image;
  final bool isFavorite;
  final Function() onFavorite;

  const RecipeHeaderImage(
      {super.key,
      required this.image,
      required this.onFavorite,
      required this.isFavorite});

  @override
  State<RecipeHeaderImage> createState() => _RecipeHeaderImageState();
}

class _RecipeHeaderImageState extends State<RecipeHeaderImage> {
  late bool isFavorite;

  @override
  void initState() {
    isFavorite = widget.isFavorite;
    super.initState();
  }

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
        right: 10,
        left: 10,
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                  onTap: () {
                    Navigator.of(context).pop();
                  },
                  child: circularBackground(
                    child: Icon(
                      Icons.arrow_back,
                      color: theme.colorScheme.background,
                    ),
                  )),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          isFavorite = !isFavorite;
                        });
                        widget.onFavorite();
                      },
                      child: circularBackground(
                        child: Icon(
                          CupertinoIcons.text_bubble,
                          color: theme.colorScheme.secondary,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                width: 5.h,
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isFavorite = !isFavorite;
                  });
                  widget.onFavorite();
                },
                child: circularBackground(
                  child: Icon(
                    isFavorite
                        ? CupertinoIcons.bookmark_solid
                        : CupertinoIcons.bookmark,
                    color: theme.colorScheme.secondary,
                  ),
                ),
              ),
            ],
          ),
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
