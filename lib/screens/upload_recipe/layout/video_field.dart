import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:ethio_chef/widgets/upload_recipe/loading_video.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:pod_player/pod_player.dart';

class VideoField extends StatefulWidget {
  final Function(File?) onVideoSelected;
  const VideoField({Key? key, required this.onVideoSelected}) : super(key: key);

  @override
  State<VideoField> createState() => _VideoFieldState();
}

class _VideoFieldState extends State<VideoField> {
  final picker = ImagePicker();
  VideoPlayerController? videoController = null;
  ChewieController? chewieController = null;
  bool isLoadingVideo = false;

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Column(
      children: [
        Center(
          child: Stack(
            children: [
              buildVideo(theme),
              if (videoController != null)
                Positioned(
                  top: 4,
                  right: 4,
                  child: Ink(
                    child: InkWell(
                        onTap: clearVideo,
                        child: buildClearIcon(theme.colorScheme.primary)),
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
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
              constraints:
                  BoxConstraints(minHeight: 60.0,),
              child: Ink(
                width: double.infinity,
                child: InkWell(
                  child: isLoadingVideo
                      ? LoadingVideo()
                      : videoController != null
                          ? AspectRatio(
                              aspectRatio: videoController!.value.aspectRatio,
                              child: Chewie(controller: chewieController!))
                          : button(theme),
                ),
              )),
        ));
  }

  Widget button(ThemeData theme) {
    return TextButton(
      onPressed: getVideoFromGallery,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.video_camera_back_outlined,
            size: 30,
            color: theme.unselectedWidgetColor.withOpacity(0.85),
          ),
          SizedBox(width: 10),
          Text("Tap here to add a video.",
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.unselectedWidgetColor.withOpacity(0.85),
              ))
        ],
      ),
    );
  }

  Widget buildClearIcon(Color color) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(5),
      child: Container(
        padding: EdgeInsets.all(8),
        color: color,
        child: Icon(
          Icons.cleaning_services_outlined,
          color: Colors.white,
          size: 20,
        ),
      ),
    );
  }

  //Image Picker function to get image from gallery
  Future getVideoFromGallery() async {
    setState(() {
      isLoadingVideo = true;
    });
    var maxFileSizeInBytes = 100 * 1048576; // 100mb
    final pickedFile = await picker.pickVideo(
        source: ImageSource.gallery, maxDuration: Duration(minutes: 10));
    if (pickedFile == null) {
      setState(() {
        isLoadingVideo = false;
      });
      return;
    }
    var videoPath = await pickedFile.readAsBytes();
    var fileSize = videoPath.length; // Get the file size in bytes
    if (fileSize >= maxFileSizeInBytes) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Video file size should not exceed 100MB.")),
      );
      setState(() {
        isLoadingVideo = false;
      });
      return;
    }
    File video = File(pickedFile.path);
    setState(() {
      videoController = VideoPlayerController.file(video);
      chewieController = ChewieController(
        videoPlayerController: videoController!,
        autoPlay: false,
        looping: false,
        aspectRatio: videoController?.value.aspectRatio,
        allowMuting: true,
        showControls: true,
        autoInitialize: true,
        showOptions: false,
      );
      isLoadingVideo = false;
      widget.onVideoSelected(video);
    });
  }

  void clearVideo() {
    setState(() {
      videoController?.dispose();
      chewieController?.dispose();
      videoController = null;
      chewieController = null;
      ;
    });
  }

  @override
  void dispose() {
    videoController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }
}
