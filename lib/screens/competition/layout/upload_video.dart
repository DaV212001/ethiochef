import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';

import '../../../screens/competition/layout/successfully_uploded.dart';
import '../../../services/competition_service.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/loading.dart';
import '../../../widgets/main_button.dart';
import '../../../widgets/recipe_status/empty_recipe.dart';
import '../../upload_recipe/layout/video_step.dart';

class UploadCompetitionVideo extends StatefulWidget {
  final int competitionId;
  const UploadCompetitionVideo({super.key, required this.competitionId});

  @override
  State<UploadCompetitionVideo> createState() => _UploadCompetitionVideoState();
}

class _UploadCompetitionVideoState extends State<UploadCompetitionVideo> {
  File? video = null;
  bool isLoading = false;
  bool uploading = false;
  bool uploading_failed = false;
  bool uploaded = false;
  bool isSubscribed = false;
  String videoUrl = '';

  bool checkBoxTicked = false;
  @override
  void initState() {
    CloudinaryContext.cloudinary = Cloudinary.fromCloudName(
      cloudName: "ttreeadvert",
    );
    super.initState();
  }

  Future<void> uploadVideo() async {
    print("Uploading 1");
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/dohotrrss/video/upload'),
    );
    //   https://api.cloudinary.com/v1_1/ttreeadvert/video/upload
    //   CloudName: dohotrrss
    //   API key: 688618625183713
    //   API Secret: il2BQtXbW1_s89oLqL-3klI_sqk
    //   API ENV variable:  CLOUDINARY_URL=cloudinary://688618625183713:il2BQtXbW1_s89oLqL-3klI_sqk@dohotrrss

    print("Uploading 2");
    request.headers['Authorization'] = 'Basic YWxhZGRpbjpvcGVuc2VzYW1l';
    print("Uploading 3");

    request.files.add(await http.MultipartFile.fromPath('file', video!.path));
    print("Uploading 4");
    request.fields['upload_preset'] = 'ethiochef';
    print("Uploading 5");
    // CloudName: dohotrrss
    // API key: 688618625183713
    // API Secret: il2BQtXbW1_s89oLqL-3klI_sqk
    // API ENV variable:  CLOUDINARY_URL=cloudinary://688618625183713:il2BQtXbW1_s89oLqL-3klI_sqk@dohotrrss
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
      print("Upload error: $error");
      showTryAgainDialog();
    }
  }

  void showTryAgainDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Failed to upload video'),
          content: Text(
            'There was an error uploading the video. Please try again.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  bool alreadyUploaded = false;
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "submit_a_competition".tr,
          style: TextStyle(color: theme.colorScheme.primary),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          child: Icon(Icons.arrow_back, color: theme.colorScheme.primary),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: theme.colorScheme.primary,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        "awards_title".tr,
                        style: TextStyle(
                          fontSize: isTablet ? 13.sp : 17.sp,
                          fontWeight: FontWeight.w800,
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      AwardsList(theme: theme),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 18.0),
                  child: CheckboxListTile(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    value: checkBoxTicked,
                    onChanged: (value) {
                      setState(() {
                        checkBoxTicked = value!;
                      });
                    },
                    title: Text(
                      "agree_with_copyright".tr,
                      style: TextStyle(color: Colors.black),
                    ),
                    controlAffinity:
                        ListTileControlAffinity.leading, // add this line
                  ),
                ),
                if (checkBoxTicked)
                  Container(
                    child: uploading_failed == true
                        ? Column(
                            children: [
                              Icon(
                                color: theme.colorScheme.error,
                                size: 300,
                                Icons.error,
                              ),
                              Text(
                                "video_upload_failed".tr,
                                style: TextStyle(
                                  fontSize: isTablet ? 13.sp : 17.sp,
                                  fontWeight: FontWeight.w800,
                                  color: theme.colorScheme.primary,
                                ),
                              ),
                              if (alreadyUploaded)
                                MainButton(
                                  onPress: () async {
                                    setState(() {
                                      uploading = true;
                                      uploading_failed = false;
                                    });
                                    print("Resend Pressed");
                                    print("My Video = ${video}");
                                    print("My Video = ${video?.path}");
                                    await uploadVideo();
                                    CompetitionService service =
                                        CompetitionService();
                                    var response = await service
                                        .sendCompetitionVideo(
                                          videoUrl,
                                          widget.competitionId,
                                        );
                                    if (response.statusCode == 200) {
                                      print(
                                        "=================================================== POP",
                                      );
                                      setState(() {
                                        uploading_failed = false;
                                        uploading = false;
                                      });
                                      PersistentNavBarNavigator.pushNewScreen(
                                        context,
                                        screen: SuccessfullyUploaded(),
                                        withNavBar: false,
                                        pageTransitionAnimation:
                                            PageTransitionAnimation.cupertino,
                                      );
                                    } else if (jsonDecode(
                                          response.body,
                                        )["message"] ==
                                        "User has already applied to this contest") {
                                      setState(() {
                                        alreadyUploaded == true;
                                        uploading_failed = true;
                                        uploading = false;
                                      });
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return Center(
                                            child: Container(
                                              width:
                                                  MediaQuery.of(
                                                    context,
                                                  ).size.width *
                                                  0.8,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: Text(
                                                      'no_more_than_one_video'
                                                          .tr,
                                                      textAlign:
                                                          TextAlign.center,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                        color: Colors.black,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                          8.0,
                                                        ),
                                                    child: MainButton(
                                                      text: 'ok'.tr,
                                                      onPress: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      );
                                    } else {
                                      setState(() {
                                        uploading_failed = true;
                                        uploading = false;
                                      });
                                    }
                                  },
                                  width: 200.w,
                                  text: "resend".tr,
                                ),
                            ],
                          )
                        : Visibility(
                            child: Column(
                              children: [
                                uploaded == true
                                    ? Text(
                                        "successful".tr,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          color: theme.colorScheme.primary,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 15.sp,
                                        ),
                                      )
                                    : Text(
                                        "video_is_uploading".tr,
                                        style: TextStyle(
                                          fontSize: isTablet ? 13.sp : 17.sp,
                                          fontWeight: FontWeight.w800,
                                          color: theme.colorScheme.primary,
                                        ),
                                      ),
                                if (uploading && uploaded == false) Loading(),
                              ],
                            ),
                            visible: uploading,
                            replacement: VideoStep(
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
                                CompetitionService service =
                                    CompetitionService();
                                var response = await service
                                    .sendCompetitionVideo(
                                      videoUrl,
                                      widget.competitionId,
                                    );
                                setState(() {
                                  video = null;
                                });
                                if (response.statusCode == 200) {
                                  setState(() {
                                    uploaded = true;
                                  });
                                  print(
                                    "=================================================== POP",
                                  );
                                  await PersistentNavBarNavigator.pushNewScreen(
                                    context,
                                    screen: SuccessfullyUploaded(),
                                    withNavBar: false,
                                    pageTransitionAnimation:
                                        PageTransitionAnimation.cupertino,
                                  );
                                } else if (jsonDecode(
                                      response.body,
                                    )["message"] ==
                                    "User has already applied to this contest") {
                                  setState(() {
                                    alreadyUploaded == true;
                                    uploading_failed = true;
                                    uploading = false;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (context) {
                                      return Center(
                                        child: Container(
                                          width:
                                              MediaQuery.of(
                                                context,
                                              ).size.width *
                                              0.8,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                              20,
                                            ),
                                          ),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Text(
                                                  'no_more_than_one_video'.tr,
                                                  textAlign: TextAlign.center,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Colors.black,
                                                  ),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: MainButton(
                                                  text: 'ok'.tr,
                                                  onPress: () {
                                                    Navigator.pop(context);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                } else {
                                  setState(() {
                                    uploading_failed = true;
                                    uploading = false;
                                  });
                                }
                              },
                              next: (video) {},
                              back: () {},
                            ),
                          ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
