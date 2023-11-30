import 'dart:io';

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:chewie/chewie.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pod_player/pod_player.dart';

import '../../../../generated/assets.dart';
import '../../../../models/recipe.dart';
import '../../../../widgets/main_button.dart';

class RecipeDescription extends StatefulWidget {
  Recipe res;
  RecipeDescription({super.key, required this.res});

  @override
  State<RecipeDescription> createState() => _RecipeDescriptionState();
}

class _RecipeDescriptionState extends State<RecipeDescription> {
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
    setVideo(widget.res.video);
    super.initState();
  }
  void setVideo(File? video) {
    if (widget.res.video == null) {
      print("widget.res.video is Null");
      return;
    }
    print("widget.res.video is not null");
    setState(() {
      videoController = VideoPlayerController.file(widget.res.video!);
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
    final List<Map<String, dynamic>> orderList = [
      {
        "title": "dish_name".tr(),
        "leadingIcon": Icons.category,
        "trailing": widget.res.name
      },
      {
        "title": "dish_description".tr(),
        "leadingIcon": Icons.list_alt,
        "trailing": widget.res.description.toString()
      },
      {
        "title": "serving_sizes".tr(),
        "leadingIcon": Icons.people_outline,
        "trailing": widget.res.servingSize.toString()
      },
      {
        "title": "preparation_times".tr(),
        "leadingIcon": Icons.timer_outlined,
        "trailing": widget.res.prepTime.toString()
      },
    ];

    ThemeData theme = Theme.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.res.name.toString(), style: TextStyle(
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
                            child: widget.res.image! !=null?Image.file(
                              widget.res.image!,
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
                  Container(
                    padding: const EdgeInsets.all(8),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: widget.res.ingredient!.length,
                        itemBuilder: (context, index) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.res.ingredient![index]['ingredient'].toString(),
                                    style:
                                    Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.normal)
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(widget.res.ingredient![index]['quantity'].toString(),
                                    style:
                                    Theme.of(context).textTheme.bodyLarge!.copyWith(
                                        fontSize: 15.sp,
                                        fontWeight: FontWeight.normal)
                                ),
                              )
                            ],
                          );
                        }),
                  ),
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
                  Padding(
                    padding: EdgeInsets.only(left: 10.w, right: 10.w),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: ListView.builder(
                          physics: BouncingScrollPhysics(),
                          shrinkWrap: true,
                          itemCount: widget.res.steps!.length,
                          itemBuilder: (context, index) {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(top:10.h,left: 10.w, right: 10.w),
                                  child: Text("${index+1}. ${widget.res.steps![index].toString()}",
                                      style:
                                      Theme.of(context).textTheme.bodyLarge!.copyWith(
                                          fontSize: 16.sp,
                                          fontWeight: FontWeight.normal)
                                  ),
                                ),

                              ],
                            );
                          }),
                    ),
                  ),
                  MainButton(
                    text: 'Submit',
                    onPress: (){

                    },
                  )
            ])));
  }


}
