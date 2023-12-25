import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/upload_recipe/stepper_control_buttons.dart';
import 'package:ethio_chef/widgets/upload_recipe/video_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../widgets/main_button.dart';

class VideoStep extends StatefulWidget {
  final ValueChanged<File?> updateVideo;
  final File? video;
  final Function next;
  final Function back;
  final VoidCallback uploadCompetition;
  final bool isCompetition;

  const VideoStep({
    super.key,
    required this.updateVideo,
    required this.next,
    required this.back,
    required this.uploadCompetition,
    required this.isCompetition,
    this.video,
  });

  @override
  State<VideoStep> createState() => _VideoStepState();
}

class _VideoStepState extends State<VideoStep> {
  File? currentVideo = null;
  bool videoInvalid = false;
  bool isLoading = false;

  @override
  void initState() {
    currentVideo = widget.video;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 10,
        ),
        VideoField(
          video: currentVideo,
          invalid: videoInvalid,
          onVideoSelected: (File? video) {
            setState(() {
              videoInvalid = false;
              currentVideo = video;
              widget.updateVideo(video);
            });
          },
        ),
        if(videoInvalid)
        invalidVideo(),
        widget.isCompetition?
        MainButton(
          isLoading: isLoading,
          width: 200.w,
          text: 'submit_a_recipe'.tr(),
          onPress: widget.uploadCompetition,
        )
            :
        StepperControlButtons(
          next: () {
            if (currentVideo == null && videoInvalid == false) {
              setState(() {
                videoInvalid = true;
              });
              return;
            }
            widget.next();
          },
          back: () {
            widget.back();
          },
        )
      ],
    );
  }

  Widget invalidVideo() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 15.0, top: 5),
        child: Text("video_is_required".tr(),
            style: Theme.of(context)
                .textTheme
                .labelMedium
                ?.copyWith(color: Theme.of(context).colorScheme.error)),
      ),
    );
  }
}
