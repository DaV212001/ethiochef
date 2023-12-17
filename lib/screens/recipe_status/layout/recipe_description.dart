import 'dart:io';
import 'package:crypto/crypto.dart' as crypto;
import 'package:chewie/chewie.dart';
import 'package:cloudinary_flutter/cloudinary_context.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/recipe_status/layout/recipe_info.dart';
import 'package:ethio_chef/screens/recipe_status/layout/recipe_status_header.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pod_player/pod_player.dart';

import '../../../../../models/recipe.dart';
import '../../../../../services/recipe_service.dart';
import '../../../../../widgets/main_button.dart';
import 'package:cloudinary_url_gen/cloudinary.dart';
import 'package:cloudinary_flutter/image/cld_image.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'ingredient_steps.dart';

class RecipeDescription extends StatefulWidget {
  Recipe myRecipe;
  RecipeDescription({super.key, required this.myRecipe});

  @override
  State<RecipeDescription> createState() => _RecipeDescriptionState();
}

class _RecipeDescriptionState extends State<RecipeDescription> {
  bool isLoading = false;
  VideoPlayerController? videoController = null;
  ChewieController? chewieController = null;
  bool isLoadingVideo = false;
  List<Tab> tabs = [Tab(
    text: 'Video',
  ),Tab(
    text: 'Image',
  )];
  @override
  void initState() {
    setVideo(widget.myRecipe.video);
    CloudinaryContext.cloudinary= Cloudinary.fromCloudName(cloudName: "ttreeadvert");
   super.initState();
  }
  String generateSignature(String apiKey, String apiSecret, String timestamp, String path) {
    final dataToSign = '$apiKey$timestamp$path';
    print("dataToSign    $dataToSign");
    final signatureBytes = crypto.Hmac(crypto.sha256, utf8.encode(apiSecret)).convert(utf8.encode(dataToSign));
    print("signatureBytes    $signatureBytes");
    return base64Encode(signatureBytes.bytes);
  }
  Future<void> uploadVideo() async {
    print("uploading 1");

    var request = http.MultipartRequest(
      'POST',
      Uri.parse('https://api.cloudinary.com/v1_1/ttreeadvert/video/upload'),
    );
    print("uploading 2");

    request.files.add(await http.MultipartFile.fromPath('file', widget.myRecipe.video!.path));
    print("uploading 3");
    print("widget.myRecipe.video!.path ${widget.myRecipe.video!.path}");
    request.fields['upload_preset'] = 'my_uploads';
    print("uploading 4");

    try {
      var response = await request.send();
    print("uploading 5");
      var responseJson = await http.Response.fromStream(response).then((value) {
        print("value.body ${value.body}");
    print("uploading 6");
      });
    print("uploading 7");
    } catch (error) {
      print(error);
    }
  }
  void setVideo(File? video) {
    if (widget.myRecipe.video == null) {
      return;
    }
    setState(() {
      videoController = VideoPlayerController.file(widget.myRecipe.video!);
      chewieController = ChewieController(
        videoPlayerController: videoController!,
        autoPlay: false,
        looping: false,
        allowMuting: true,
        showControls: true,
        autoInitialize: true,
        showOptions: false,
      );
      isLoadingVideo = false;
    });
  }
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  @override
  void dispose() {
    videoController?.dispose();
    chewieController?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
          body: SingleChildScrollView(
            //TODO fix the end of slider effect
              scrollDirection: Axis.vertical,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RecipeStatusHeaderImage(image: widget.myRecipe.image),
                      SizedBox(
                        height: 15.h,
                      ),
                      Center(
                        child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Container(
                                  constraints: BoxConstraints(minHeight: 200.0, maxHeight: 400),
                                  child: isLoadingVideo == true
                                      ? CircularProgressIndicator(backgroundColor:Colors.pink)
                                      : videoController != null
                                      ? Chewie(controller: chewieController!):
                                  CircularProgressIndicator(backgroundColor:Colors.blue,)),
                            ))
                      ),
                      RecipeInfo(recipe: widget.myRecipe),
                      IngredientAndSteps(recipe: widget.myRecipe),
                      Center(
                        child: MainButton(
                          isLoading: isLoading,
                          width: 200.w,
                          text: 'submit_a_recipe'.tr(),
                          onPress: ()async{
                            setState(() {
                              isLoading = true;
                            });
                            print("Submit");
                            SnackBar wait = SnackBar(
                              duration: Duration(seconds: 4),
                                padding: EdgeInsets.symmetric(vertical: 10),
                                content: Text(
                                  "wait_recipe".tr(),
                                ));
                            ScaffoldMessenger.of(context).showSnackBar(wait);
                            RecipeService service = RecipeService();
                            var response = await service.createFood(widget.myRecipe);
                            print("uploading");
                            await uploadVideo();
                            print("uploaded");
                            SnackBar success = SnackBar(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                content: Text(
                                  "submitted_successfully".tr(),
                                ));
                            SnackBar failed = SnackBar(
                                padding: EdgeInsets.symmetric(vertical: 10),
                                content: Text(
                                  "submitted_failed".tr(),
                                ));
                            if(response.statusCode == 200){
                              await ScaffoldMessenger.of(context).showSnackBar(success);
                              Navigator.pop(context);
                            }else{
                              await ScaffoldMessenger.of(context).showSnackBar(failed);
                              Navigator.pop(context);
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                        ),
                      )
                ]),
              ))),
    );
  }


}
