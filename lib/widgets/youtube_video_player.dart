import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final String link;

  const YoutubeVideoPlayer({Key? key, required this.link}) : super(key: key);

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  late YoutubePlayerController _controller;
  bool _isPlayerReady = false;

  @override
  void initState() {
    final videoId = YoutubePlayer.convertUrlToId(widget.link);
    _controller = YoutubePlayerController(
      initialVideoId: videoId ?? '',
      flags: const YoutubePlayerFlags(
        autoPlay: true,
        mute: false,
        loop: false,
        enableCaption: true,
        forceHD: true,
      ),
    )..addListener(_playerListener);
    _controller.load(videoId ?? '');
    super.initState();
  }

  void _playerListener() {
    if (_isPlayerReady || !_controller.value.isReady) return;
    setState(() {
      _isPlayerReady = true;
    });
  }

  @override
  void dispose() {
    _controller.removeListener(_playerListener);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return YoutubePlayer(
      controller: _controller,
      showVideoProgressIndicator: true,
      progressIndicatorColor: theme.colorScheme.primary,
      progressColors: ProgressBarColors(
        playedColor: theme.colorScheme.primary,
        handleColor: theme.colorScheme.primary,
        bufferedColor: theme.colorScheme.primary.withOpacity(0.3),
      ),
      // topActions: <Widget>[
      //   const SizedBox(width: 8.0),
      //   Expanded(
      //     child: Text(
      //       _controller.metadata.title,
      //       style: TextStyle(
      //         color: theme.colorScheme.onPrimary,
      //         fontWeight: FontWeight.w500,
      //       ),
      //       overflow: TextOverflow.ellipsis,
      //       maxLines: 1,
      //     ),
      //   ),
      // ],
    );
  }
}
