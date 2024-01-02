import 'dart:convert';

import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/competition/layout/successfully_uploded.dart';
import 'package:ethio_chef/screens/competition/layout/uploading.dart';
import 'package:ethio_chef/widgets/main_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'dart:io';

import '../../../services/competition_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/error_card.dart';
import '../../../widgets/info_card.dart';
import '../../../widgets/main_button.dart';
import '../../upload_recipe/layout/video_step.dart';
import 'package:http/http.dart' as http;

class UploadCompetitionVideo extends StatefulWidget {
  const UploadCompetitionVideo({super.key});

  @override
  State<UploadCompetitionVideo> createState() => _UploadCompetitionVideoState();
}

class _UploadCompetitionVideoState extends State<UploadCompetitionVideo> {
  File? video = null;
  bool isLoading = false;
  bool uploading = false;
  String videoUrl = '';
  @override
  void initState() {
    CloudinaryContext.cloudinary= Cloudinary.fromCloudName(cloudName: "ttreeadvert");
    super.initState();
  }
  Future<void> uploadVideo() async {
    print("upload 1");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/ttreeadvert/video/upload'),
    );
    print("upload 2");

    request.files.add(await http.MultipartFile.fromPath('file', video!.path));
    print("upload 3");
    request.fields['upload_preset'] = 'my_uploads';
    print("upload 4");

    try {
      print("sending");
      var response = await request.send();
      print("upload 5");
      var responseJson = await http.Response.fromStream(response).then((value) {
        var jsonRes = jsonDecode(value.body);
        print("Json Response ${jsonRes}");
        print("Json Url ${jsonRes['url']}");
        setState(() {
          videoUrl = jsonRes['url'];
        });
        print("videoUrl ${videoUrl}");

      });

    } catch (error) {
      print("upload error");
      print(error);
    }
  }
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("upload_competition".tr(),style: TextStyle(
            color: theme.colorScheme.primary
        )),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
            onTap: () {
               Navigator.of(context).popUntil((route) => route.settings.name == '/competition');
            },
            child: Icon(
              Icons.arrow_back,
              color: theme.colorScheme.primary,
            )),
      ),
      body:  Container(
        child: Column(
          children: [
            VideoStep(
              isCompetition: true,
              video: video,
              updateVideo: (video) async {

                setState(() {
                  uploading = true;
                });
                print("Pressed");
                this.video = video;
                print("My Video = ${video}");
                print("My Video = ${video?.path}");
                await uploadVideo();
                CompetitionService service = CompetitionService();
                var response = await service.sendCompetitionVideo(videoUrl);
                setState(() {
                  uploading = false;
                  video = null;
                });
                if(response.statusCode == 200){
                  print("=================================================== POP");
                  pushNewScreen(
                    context,
                    screen: SuccessfullyUploaded(),
                    withNavBar: false,
                    pageTransitionAnimation: PageTransitionAnimation.cupertino,
                  );
                }
              },
              next: (video){}, back: (){
            },
            )
          ],
        )
      )
    );
  }
}
