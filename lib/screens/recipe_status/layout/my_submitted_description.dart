import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:pod_player/pod_player.dart';

import '../../../models/submitted_recipe.dart';
import '../../../utils/screen_utils.dart';
import '../../../widgets/cached_image.dart';

class SubmittedDescription extends StatefulWidget {
  final MySubmittedRecipe recipe;
  const SubmittedDescription({super.key, required this.recipe});

  @override
  State<SubmittedDescription> createState() => _SubmittedDescriptionState();
}

class _SubmittedDescriptionState extends State<SubmittedDescription>
    with SingleTickerProviderStateMixin {
  @override
  void initState() {
    setVideo(widget.recipe.video!);
    super.initState();
  }

  VideoPlayerController? videoController = null;
  ChewieController? chewieController = null;
  void setVideo(video) {
    print("CHECKING VIDEO $video");
    if (video == null) {
      return;
    }
    setState(() {
      videoController = VideoPlayerController.networkUrl(Uri.parse(video));
      chewieController = ChewieController(
        videoPlayerController: videoController!,
        autoPlay: true,
        looping: false,
        allowMuting: true,
        showControls: true,
        autoInitialize: true,
        showOptions: false,
      );
    });
  }

  bool showAddRecipeCard = true;
  int selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    Widget buildVideo(ThemeData theme) {
      return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: theme.colorScheme.primary.withOpacity(0.5),
            width: 1,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(5),
          child: Container(
            constraints: BoxConstraints(minHeight: 200.0, maxHeight: 400),
            child: Ink(
              width: double.infinity,
              child: InkWell(child: Chewie(controller: chewieController!)),
            ),
          ),
        ),
      );
    }

    ThemeData theme = Theme.of(context);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Stack(
                children: [
                  SizedBox(
                    width: width,
                    height: height * 0.4,
                    child: CachedImage(
                      url: widget.recipe.image,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Positioned(
                    top: 5,
                    right: 10,
                    left: 10,
                    child: SafeArea(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            child: circularBackground(
                              child: Icon(
                                Icons.arrow_back,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  widget.recipe.title,
                  style: TextStyle(
                    fontSize: isTablet ? 15.sp : 20.sp,
                    fontWeight: FontWeight.w300,
                    color: theme.colorScheme.secondaryContainer,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  "dish_description".tr,
                  style: TextStyle(
                    fontSize: isTablet ? 15.sp : 20.sp,
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.secondaryContainer,
                  ),
                ),
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  widget.recipe.description!,
                  style: TextStyle(
                    fontSize: isTablet ? 15.sp : 20.sp,
                    fontWeight: FontWeight.w300,
                    color: theme.colorScheme.secondaryContainer,
                  ),
                ),
              ),
              Padding(padding: EdgeInsets.all(10), child: buildVideo(theme)),
              Padding(
                padding: const EdgeInsets.all(20),
                child: DefaultTabController(
                  length: 2,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      ButtonsTabBar(
                        onTap: (index) {
                          setState(() {
                            selectedIndex = index;
                          });
                        },
                        backgroundColor: theme.colorScheme.primary,
                        unselectedBackgroundColor: Colors.transparent,
                        unselectedLabelStyle: TextStyle(
                          fontSize: isTablet ? 11.sp : 15.sp,
                          fontWeight: FontWeight.w500,
                          color: theme.colorScheme.primary,
                        ),
                        labelStyle: TextStyle(
                          fontSize: isTablet ? 11.sp : 15.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                        contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        radius: 5,
                        tabs: [
                          Tab(text: "ingredients".tr),
                          Tab(text: "steps".tr),
                        ],
                      ),
                      Container(
                        height: 300,
                        child: selectedIndex == 0
                            ? ListView.builder(
                                shrinkWrap: true,
                                itemCount: 1,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  index++;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: widget.recipe.ingredients!.entries
                                        .map((ingredient) {
                                          return Flex(
                                            direction: Axis.vertical,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                "${index++}. ${ingredient.value}",
                                                softWrap: true,
                                                overflow: TextOverflow.visible,
                                                style: TextStyle(
                                                  fontSize: isTablet
                                                      ? 15.sp
                                                      : 19.sp,
                                                  fontWeight: FontWeight.w600,
                                                  color: theme
                                                      .colorScheme
                                                      .secondaryContainer,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                            ],
                                          );
                                        })
                                        .toList(),
                                  );
                                },
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: 1,
                                physics: BouncingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                itemBuilder: (context, index) {
                                  index++;
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: widget.recipe.steps!.entries.map((
                                      step,
                                    ) {
                                      return Flex(
                                        direction: Axis.vertical,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          const SizedBox(width: 8.0),
                                          Text(
                                            "${index++}. ${step.value}",
                                            softWrap: true,
                                            overflow: TextOverflow.visible,
                                            style: TextStyle(
                                              fontSize: isTablet
                                                  ? 15.sp
                                                  : 19.sp,
                                              fontWeight: FontWeight.w600,
                                              color: theme
                                                  .colorScheme
                                                  .secondaryContainer,
                                            ),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      );
                                    }).toList(),
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget circularBackground({required Widget child}) {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(100)),
        color: Theme.of(context).colorScheme.onPrimary,
      ),
      child: child,
    );
  }
}
