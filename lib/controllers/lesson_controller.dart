import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';

class LessonController extends GetxController {
  var isLoading = true.obs;
  var lesson = {}.obs;
  var error = ''.obs;
  Future<String> downloadPdf(String url) async {
    final response = await http.get(Uri.parse(url));
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/temp.pdf');
    await file.writeAsBytes(response.bodyBytes);
    return file.path;
  }

  Future<void> fetchLesson() async {
    try {
      isLoading(true);
      final id = Get.arguments['id'];
      final response =
          await http.get(Uri.parse('https://api.asteghi.com/api/lesson/$id'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        Logger().d(data);
        lesson.value = data['data'];
      } else {
        error.value = 'Failed to fetch lesson: ${response.statusCode}';
      }
    } catch (e) {
      error.value = 'Error: $e';
    } finally {
      isLoading(false);
    }
  }

  @override
  void onInit() {
    super.onInit();
    fetchLesson();
  }
}
