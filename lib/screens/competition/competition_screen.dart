import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/screens/competition/layout/competition_header.dart';
import 'package:ethio_chef/screens/competition/layout/competition_header_image.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/recipe/share_button.dart';
import 'package:ethio_chef/widgets/youtube_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CompetitionScreen extends StatefulWidget {
  final Competition competition;

  const CompetitionScreen({super.key, required this.competition});

  @override
  State<CompetitionScreen> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: DefaultTabController(
          length: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CompetitionHeaderImage(
                image: widget.competition.image,
              ),
              CompetitionHeader(
                competition: widget.competition,
              ),
              SizedBox(
                height: 10.h,
              ),
              if (widget.competition.video != null)
                YoutubeVideoPlayer(
                  link: PlaceHolderData.videoLink,
                ),
              ShareButton(food: PlaceHolderData.food)
            ],
          ),
        ),
      ),
    );
  }
}
