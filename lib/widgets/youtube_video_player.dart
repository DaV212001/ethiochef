import 'package:flutter/material.dart';
import 'package:pod_player/pod_player.dart';
import 'package:url_launcher/url_launcher.dart';

import '../generated/assets.dart';
import '../utils/constants.dart';
import 'cached_image.dart';

class YoutubeVideoPlayer extends StatefulWidget {
  final String link;
  final String? thumbnailUrl;

  const YoutubeVideoPlayer({
    super.key,
    required this.link,
    this.thumbnailUrl,
  });

  @override
  State<YoutubeVideoPlayer> createState() => _YoutubeVideoPlayerState();
}

class _YoutubeVideoPlayerState extends State<YoutubeVideoPlayer> {
  PodPlayerController? _controller;
  bool _isLoading = true;
  bool _hasError = false;
  String? _playableUrl;
  bool _isYouTube = false;

  static final RegExp _ytRegex = RegExp(
    r'(?:https?:\/\/)?(?:www\.|m\.)?(?:youtu\.be\/|youtube\.com\/(?:embed\/|v\/|watch\?v=|shorts\/|watch\?.+&v=))([\w-]{11})',
    caseSensitive: false,
  );

  static final RegExp _vimeoRegex = RegExp(
    r'(?:https?:\/\/)?(?:www\.)?vimeo\.com\/(?:channels\/(?:\w+\/)?|groups\/([^\/]*)\/videos\/|album\/(\d+)\/video\/|video\/|)(\d+)',
    caseSensitive: false,
  );

  @override
  void initState() {
    super.initState();
    _initPlayer();
  }

  String _cleanUrl(String raw) {
    String url = raw.trim();
    if (!url.startsWith('http://') && !url.startsWith('https://')) {
      if (url.startsWith('/')) {
        return '${Constants.ImageAPI}$url';
      } else {
        return '${Constants.ImageAPI}/$url';
      }
    }
    return url;
  }

  Future<void> _initPlayer() async {
    final rawLink = widget.link.trim();
    if (rawLink.isEmpty) {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
        });
      }
      return;
    }

    try {
      PlayVideoFrom playFrom;
      final ytMatch = _ytRegex.firstMatch(rawLink);

      if (ytMatch != null && ytMatch.groupCount >= 1) {
        _isYouTube = true;
        final videoId = ytMatch.group(1);
        _playableUrl = 'https://www.youtube.com/watch?v=$videoId';
        playFrom = PlayVideoFrom.youtube(_playableUrl!);
      } else if (RegExp(r'^[\w-]{11}$').hasMatch(rawLink)) {
        _isYouTube = true;
        _playableUrl = 'https://www.youtube.com/watch?v=$rawLink';
        playFrom = PlayVideoFrom.youtube(_playableUrl!);
      } else if (_vimeoRegex.hasMatch(rawLink)) {
        final match = _vimeoRegex.firstMatch(rawLink);
        final vimeoId = match?.group(3) ?? rawLink;
        _playableUrl = 'https://vimeo.com/$vimeoId';
        playFrom = PlayVideoFrom.vimeo(vimeoId);
      } else {
        // Direct media URL (MP4, MOV, HLS, or server upload)
        final fullUrl = _cleanUrl(rawLink);
        _playableUrl = fullUrl;
        playFrom = PlayVideoFrom.network(fullUrl);
      }

      final controller = PodPlayerController(
        playVideoFrom: playFrom,
        podPlayerConfig: const PodPlayerConfig(
          autoPlay: false,
          isLooping: false,
          videoQualityPriority: [720, 360],
        ),
      );

      await controller.initialise();

      if (mounted) {
        setState(() {
          _controller = controller;
          _isLoading = false;
        });
      } else {
        controller.dispose();
      }
    } catch (e) {
      debugPrint('⚠️ [VideoPlayer] PodPlayer failed to initialize ($rawLink): $e');
      if (mounted) {
        setState(() {
          _isLoading = false;
          _hasError = true;
          _playableUrl ??= _cleanUrl(rawLink);
        });
      }
    }
  }

  Future<void> _launchExternalVideo() async {
    final urlStr = _playableUrl ?? _cleanUrl(widget.link);
    try {
      final uri = Uri.parse(urlStr);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      }
    } catch (e) {
      debugPrint('❌ [VideoPlayer] Could not launch video URL ($urlStr): $e');
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (_isLoading) {
      return Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.thumbnailUrl != null && widget.thumbnailUrl!.isNotEmpty)
              Positioned.fill(
                child: CachedImage(url: widget.thumbnailUrl!, fit: BoxFit.cover),
              ),
            Container(color: const Color.fromRGBO(0, 0, 0, 0.35)),
            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      );
    }

    if (_hasError || _controller == null) {
      return Container(
        color: Colors.black,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.thumbnailUrl != null && widget.thumbnailUrl!.isNotEmpty)
              Positioned.fill(
                child: CachedImage(url: widget.thumbnailUrl!, fit: BoxFit.cover),
              ),
            Container(color: const Color.fromRGBO(0, 0, 0, 0.4)),
            InkWell(
              onTap: _launchExternalVideo,
              borderRadius: BorderRadius.circular(50),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(0, 0, 0, 0.7),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white54, width: 1.5),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      _isYouTube ? Icons.play_arrow : Icons.videocam,
                      color: Colors.redAccent,
                      size: 28,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _isYouTube ? "Watch on YouTube" : "Play Video",
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return PodVideoPlayer(
      podProgressBarConfig: PodProgressBarConfig(
        playingBarColor: theme.colorScheme.primary,
        circleHandlerColor: theme.colorScheme.primary,
        bufferedBarColor: theme.colorScheme.primary.withAlpha(128),
      ),
      controller: _controller!,
      backgroundColor: theme.colorScheme.tertiary,
      videoThumbnail: widget.thumbnailUrl != null && widget.thumbnailUrl!.isNotEmpty
          ? null
          : const DecorationImage(
              image: AssetImage(Assets.imagesLogo),
            ),
    );
  }
}
