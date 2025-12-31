import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';

class CachedImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const CachedImage({super.key, required this.url, required this.fit});

  @override
  Widget build(BuildContext context) {
    return FastCachedImage(
      url: url,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 250),
      errorBuilder: (context, exception, stacktrace) {
        // Retry with a prepended URL if the original one fails
        final retryUrl = 'https://www.ethiochef.com$url';

        return FastCachedImage(
          url: retryUrl,
          fit: fit,
          fadeInDuration: const Duration(milliseconds: 250),
          errorBuilder: (context, exception, stacktrace) {
            // Fallback if the retried URL also fails
            return Center(
              child: Image.asset('assets/images/logo.jpg'),
            );
          },
        );
      },
      loadingBuilder: (context, progress) {
        return Container(
          color: Colors.transparent,
        );
      },
    );
  }
}
