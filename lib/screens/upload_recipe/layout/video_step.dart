import 'dart:io';
import 'package:ethio_chef/widgets/header.dart';
import 'package:ethio_chef/widgets/upload_recipe/stepper_control_buttons.dart';
import 'package:ethio_chef/widgets/upload_recipe/video_field.dart';
import 'package:flutter/material.dart';

class VideoStep extends StatelessWidget {
  final ValueChanged<File?> updateVideo;
  final Function next;
  final Function back;

  const VideoStep({
    super.key,
    required this.updateVideo,
    required this.next,
    required this.back,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Header(title: "Video"),
        SizedBox(
          height: 10,
        ),
        VideoField(
          onVideoSelected: (File? video) {
            updateVideo(video!);
          },
        ),
        StepperControlButtons(
          next: () {
            //Todo validate form
            next();
          },
          back: () {
            back();
          },
        )
      ],
    );
  }
}
