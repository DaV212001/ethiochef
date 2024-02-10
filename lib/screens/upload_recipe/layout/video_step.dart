import 'dart:io';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/upload_recipe/stepper_control_buttons.dart';
import 'package:ethio_chef/widgets/upload_recipe/video_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../utils/screen_utils.dart';
import '../../../widgets/main_button.dart';

class VideoStep extends StatefulWidget {
  final ValueChanged<File?> updateVideo;
  final File? video;
  final ValueChanged<File?> next;
  final Function back;
  final bool isCompetition;

  const VideoStep({
    super.key,
    required this.updateVideo,
    required this.next,
    required this.back,
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
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
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
            });
          },
        ),
        if(videoInvalid)
        invalidVideo(),
        widget.isCompetition?
        isLoading == true?Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  child: Text(
                    "uploading_title".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontSize: isTablet ? 18.sp : 20.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.h, horizontal: 8.w),
                  child: Text(
                    "uploading_body".tr(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: theme.unselectedWidgetColor,
                        fontSize:isTablet ? 12.sp :  15.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            )
        ):
        MainButton(
          isLoading: isLoading,
          width: 200.w,
          text: 'submit_a_competition'.tr(),
          onPress: () {
            if (currentVideo == null && videoInvalid == false) {

              setState(() {
                videoInvalid = true;
              });
              return;
            }
            setState(() {
              isLoading = true;
            });
            widget.updateVideo(currentVideo);
          } ,
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
            widget.next(currentVideo);
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
