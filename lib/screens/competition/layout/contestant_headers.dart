import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

import '../../../models/contestants.dart';
import 'package:chewie/chewie.dart';
class ContestantHeaderImage extends StatefulWidget {
  final String image;
  final String video;
  Contestant contestant;
  ContestantHeaderImage(
      {super.key,
        required this.image,
        required this.video,
        required this.contestant
      });

  @override
  State<ContestantHeaderImage> createState() => _ContestantHeaderImageState();
}

class _ContestantHeaderImageState extends State<ContestantHeaderImage> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  @override
  void initState() {
    print(widget.contestant.video);
    super.initState();
    _videoPlayerController = VideoPlayerController.network(widget.contestant.video.toString());
    _videoPlayerController.initialize().then((_) {
      print("=============================================================================================================================");
      print(widget.contestant.video);
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: true,
      );
      setState(() {});
    });
    _videoPlayerController.addListener(() {
      if (_videoPlayerController.value.hasError) {
        print(widget.contestant.video);
        print('=============================================================================================================================Error: ${_videoPlayerController.value.errorDescription}');
      }
    });
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
    );


  }


  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    ThemeData theme = Theme.of(context);
    return SizedBox(
        width: width,
        height: height * 0.3,
        child: _chewieController != null ? Chewie(controller: _chewieController)
            : Center(child: CircularProgressIndicator()),
    );

  }
  @override
  void dispose() {
    _videoPlayerController.dispose();
    super.dispose();
  }
}

