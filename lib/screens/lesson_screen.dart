import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

import '../controllers/lesson_controller.dart';

class LessonScreen extends StatelessWidget {
  const LessonScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(LessonController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Lesson Detail'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.error.isNotEmpty) {
          return Center(child: Text(controller.error.value));
        }

        final lesson = controller.lesson;
        final type = lesson['type'];
        final attachment = lesson['attachment'] ?? '';
        final title = lesson['title'] ?? '';
        final description = lesson['description'] ?? '';

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Text(title,
            //     style: const TextStyle(
            //         fontSize: 20, fontWeight: FontWeight.bold)),
            // const SizedBox(height: 8),
            // Text(description),
            // const SizedBox(height: 16),
            Expanded(
              child: type == 1
                  ? SfPdfViewer.network(lesson['attachment'])
                  : type == 2
                      ? YoutubePlayer(
                          controller: YoutubePlayerController(
                            initialVideoId:
                                YoutubePlayer.convertUrlToId(attachment) ?? '',
                            flags: const YoutubePlayerFlags(
                              autoPlay: false,
                              mute: false,
                            ),
                          ),
                          showVideoProgressIndicator: true,
                        )
                      : const Center(
                          child: Text(
                            'Unsupported lesson type',
                          ),
                        ),
            ),
          ],
        );
      }),
    );
  }
}
