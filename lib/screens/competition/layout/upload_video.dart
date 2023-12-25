import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'dart:io';

import '../../../services/competition_service.dart';
import '../../upload_recipe/layout/video_step.dart';
import 'package:http/http.dart' as http;

class UploadCompetitionVideo extends StatefulWidget {
  const UploadCompetitionVideo({super.key});

  @override
  State<UploadCompetitionVideo> createState() => _UploadCompetitionVideoState();
}

class _UploadCompetitionVideoState extends State<UploadCompetitionVideo> {
  File? video = null;
  @override
  void initState() {
    CloudinaryContext.cloudinary= Cloudinary.fromCloudName(cloudName: "ttreeadvert");
    super.initState();
  }
  Future<void> uploadVideo() async {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/ttreeadvert/video/upload'),
    );

    request.files.add(await http.MultipartFile.fromPath('file', video!.path));
    request.fields['upload_preset'] = 'my_uploads';

    try {
      var response = await request.send();
      var responseJson = await http.Response.fromStream(response).then((value) {
        print("value $value");
      });
      print("response $response");
      print("responseJson $responseJson");
    } catch (error) {
      print(error);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MainAppBar(
        hasBackButton: true,
        hasMainIcons: false,
        hasSearchField: false,
        isSearchScreen: false,
        title: 'upload_competition'.tr(),
      ),
      body:  Column(
        children: [
          VideoStep(
            uploadCompetition: () async{
              await uploadVideo();
              CompetitionService service = CompetitionService();
              // service.sendCompetitionVideo(response);
            },
            isCompetition: true,

              video: video,
              updateVideo: (video) {
                this.video = video;
              },
              next: (){}, back: (){
          },
          )
        ],
      )
    );
  }
}
