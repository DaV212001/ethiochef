import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/competition.dart';
import '../../../utils/screen_utils.dart';
import '../../upload_recipe/layout/video_step.dart';

class SaveCompetitionVideo extends StatefulWidget {
  const SaveCompetitionVideo({super.key});

  @override
  State<SaveCompetitionVideo> createState() => _SaveCompetitionVideoState();
}

class _SaveCompetitionVideoState extends State<SaveCompetitionVideo> {
  File? video = null;
  bool isLoading = false;
  bool uploading = false;
  String videoUrl = '';

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "upload_competition".tr,
          style: TextStyle(color: theme.colorScheme.primary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(
              context,
            ).popUntil((route) => route.settings.name == '/competition');
          },
          child: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            VideoStep(
              isCompetition: false,
              video: video,
              updateVideo: (video) {
                print("===========video $video");
                setState(() {
                  this.video = video;
                });
              },
              next: (video) {
                Competition newRecipe = Competition(videoFile: video);

                Competition.addCompetition(newRecipe);
              },
              back: () {},
            ),
          ],
        ),
      ),
    );
  }
}
