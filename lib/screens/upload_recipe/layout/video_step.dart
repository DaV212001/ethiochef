import 'dart:io';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/upload_recipe/stepper_control_buttons.dart';
import 'package:ethio_chef/widgets/upload_recipe/video_field.dart';
import 'package:flutter/material.dart';

class VideoStep extends StatefulWidget {
  final ValueChanged<File?> updateVideo;
  final File? video;
  final Function next;
  final Function back;

  const VideoStep({
    super.key,
    required this.updateVideo,
    required this.next,
    required this.back,
    this.video,
  });

  @override
  State<VideoStep> createState() => _VideoStepState();
}

class _VideoStepState extends State<VideoStep> {
  File? currentVideo = null;
  @override
  void initState() {
    currentVideo = widget.video;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(title: "Video"),
        SizedBox(
          height: 10,
        ),
        VideoField(
          video: currentVideo,
          onVideoSelected: (File? video) {
            widget.updateVideo(video);
          },
        ),
        StepperControlButtons(
          next: () {
            //Todo validate form
            widget.next();
          },
          back: () {
            widget.back();
          },
        )
      ],
    );
  }
}
