import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';

class VideoField extends StatelessWidget {
  final VideoPlayerController? video;
  final ChewieController? cVideo;
  final VoidCallback onClicked;

  const VideoField(
      {Key? key, required this.video, required this.onClicked, this.cVideo})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              buildVideo(theme),
              if (video != null)
                Positioned(
                  bottom: 4,
                  right: 4,
                  child: Ink(
                    child: InkWell(
                        onTap: onClicked,
                        child: buildEditIcon(theme.colorScheme.primary)),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildVideo(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.primary.withOpacity(0.5),
          width: 1,
        ),
      ),
      child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Container(
            constraints: BoxConstraints(minHeight: 200.0, maxHeight: double.infinity),
            child: Ink(
              width: double.infinity,
              child: InkWell(
                child: video != null
                    ? AspectRatio(
                        aspectRatio: video!.value.aspectRatio,
                        child: Chewie(controller: cVideo!))
                    : IconButton(
                        onPressed: onClicked,
                        icon: Icon(
                          Icons.video_camera_back_outlined,
                          size: 50,
                        ),
                      ),
              ),
            ),
          )),
    );
  }

  Widget buildEditIcon(Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: EdgeInsets.all(8),
        color: color,
        child: Icon(
          Icons.edit,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }
}
