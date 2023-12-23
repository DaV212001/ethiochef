import 'dart:io';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/theme/model_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pod_player/pod_player.dart';
import 'package:provider/provider.dart';

import '../../../../widgets/main_button.dart';

class CompetitionDescription extends StatefulWidget {
  Competition comp;
  CompetitionDescription({super.key, required this.comp});

  @override
  State<CompetitionDescription> createState() => _CompetitionDescriptionState();
}

class _CompetitionDescriptionState extends State<CompetitionDescription> {
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
    setVideo(widget.comp.videoFile);
    super.initState();
  }
  void setVideo(File? video) {
    if (widget.comp.videoFile == null) {
      print("widget.res.video is Null");
      return;
    }
    print("widget.res.video is not null");
    setState(() {
      videoController = VideoPlayerController.file(widget.comp.videoFile!);
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
    ModelTheme lang = Provider.of<ModelTheme>(context);
    final List<Map<String, dynamic>> orderList = [
      {
        "title": "dish_name".tr(),
        "leadingIcon": Icons.category,
        "trailing": lang.languageCode == "en" ? widget.comp.name_en.toString() : lang.languageCode=='am'? widget.comp.name_am.toString(): lang.languageCode =='GB'? widget.comp.name_or.toString():widget.comp.name_tr.toString()
      },
      {
        "title": "dish_description".tr(),
        "leadingIcon": Icons.list_alt,
        "trailing": lang.languageCode == "en" ? widget.comp.description_en.toString() : lang.languageCode=='am'? widget.comp.description_am.toString(): lang.languageCode =='GB'? widget.comp.description_or.toString():widget.comp.description_tr.toString()
      },
      // {
      //   "title": "serving_sizes".tr(),
      //   "leadingIcon": Icons.people_outline,
      //   "trailing": widget.comp.servingSize.toString()
      // },
      // {
      //   "title": "preparation_times".tr(),
      //   "leadingIcon": Icons.timer_outlined,
      //   "trailing": widget.comp.prepTime.toString()
      // },
    ];

    ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(lang.languageCode == "en" ? widget.comp.name_en.toString() : lang.languageCode=='am'? widget.comp.name_am.toString(): lang.languageCode =='GB'? widget.comp.name_or.toString():widget.comp.name_tr.toString(), style: TextStyle(
              color: theme.colorScheme.primary
          ),),
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: GestureDetector(
              onTap: () {
                Navigator.of(context).pop();
              },
              child: Icon(
                Icons.arrow_back,
                color: theme.colorScheme.primary,
              )),
        ),
        body: SingleChildScrollView(
          //TODO fix the end of slider effect
            scrollDirection: Axis.vertical,
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    child: Card(
                      child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: widget.comp.imageFile! !=null?Image.file(
                                widget.comp.imageFile!,
                                fit: BoxFit.fill
                            ):Image.asset(
                              'assets/images/logo.png',
                              fit: BoxFit.fill,
                              height: 100.h,
                              width: 100.w,
                            ),
                          )),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Card(
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
                        )),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10.h, left: 10.w, right: 10.w),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        itemCount: orderList.length,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          final order = orderList[index];
                          return ListTile(
                              title: Text(order["title"],
                                  style: TextStyle(fontSize: 14.sp)),
                              leading: Icon(
                                order["leadingIcon"],
                                size: 13.sp,
                              ),
                              trailing: Text(order["trailing"],
                                  style: TextStyle(fontSize: 12.sp)));
                        }),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: ListTile(
                        title: Text("Ingredient",
                            style:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.normal)),
                        leading: Icon(
                          Icons.dinner_dining,
                          size: 15.sp,
                        ),
                        trailing: Text('',
                            style: TextStyle(fontSize: 12.sp))),
                  ),
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.comp.ingredient!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: ListTile(
                              title: Text(widget.comp.ingredient![index]['ingredient'].toString(),
                                  style:
                                  Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.normal)
                              ),
                              leading: Text("${index+1}. "),
                              trailing: Text(widget.comp.ingredient![index]['quantity'].toString(),
                                  style:
                                  Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 15.sp,
                                      fontWeight: FontWeight.normal)
                              )),
                        );
                      }),
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: ListTile(
                        title: Text("Steps",
                            style:
                            Theme.of(context).textTheme.bodyLarge!.copyWith(
                                fontSize: 13.sp,
                                fontWeight: FontWeight.normal)),
                        leading: Icon(
                          Icons.dinner_dining,
                          size: 15.sp,
                        ),
                        trailing: Text('',
                            style: TextStyle(fontSize: 15.sp))),
                  ),
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.comp.steps!.length,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: EdgeInsets.only(left: 10.w, right: 10.w),
                          child: ListTile(
                              title: Text("${widget.comp.steps![index].toString()}",
                                  style:
                                  Theme.of(context).textTheme.bodyLarge!.copyWith(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.normal)
                              ),
                              leading: Text("${index+1}. "),
                              trailing: null),
                        );
                      }),
                  MainButton(
                    text: 'Submit',
                    onPress: (){

                    },
                  )
                ])));
  }


}
