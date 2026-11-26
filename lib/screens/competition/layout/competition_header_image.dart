import '../../../widgets/cached_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../widgets/youtube_video_player.dart';
import '../../../models/food.dart';

class CompetitionHeaderImage extends StatefulWidget {
  final String image;
  final String video;
  const CompetitionHeaderImage(
      {super.key,
      required this.image,
      required this.video
      });

  @override
  State<CompetitionHeaderImage> createState() => _CompetitionHeaderImageState();
}

class _CompetitionHeaderImageState extends State<CompetitionHeaderImage> {
 

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    final hasValidVideo = widget.video.isNotEmpty &&
        Food.parseVideoUrl(widget.video) != null;
    return Stack(children: [
      if (hasValidVideo)
        SizedBox(
          width: width,
          height: height * 0.3,
          child: YoutubeVideoPlayer(
            link: widget.video.toString(),
          ),
        )
      else
        SizedBox(
          width: width,
          height: height * 0.4,
          child: CachedImage(url: widget.image, fit: BoxFit.fill),
        )
    ]);
  }

  Widget circularBackground({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: Theme.of(context).colorScheme.onPrimary),
      child: child,
    );
  }
}
