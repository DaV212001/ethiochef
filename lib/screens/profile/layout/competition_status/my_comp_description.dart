// import 'dart:async';
// import 'dart:io';
//
// import 'package:buttons_tabbar/buttons_tabbar.dart';
// import 'package:chewie/chewie.dart';
// import 'package:easy_localization/easy_localization.dart';
// import 'package:ethio_chef/models/competition.dart';
// import 'package:ethio_chef/theme/model_theme.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:pod_player/pod_player.dart';
// import 'package:provider/provider.dart';
//
// import '../../../../widgets/main_button.dart';
//
// class CompetitionDescription extends StatefulWidget {
//   Competition comp;
//   CompetitionDescription({super.key, required this.comp});
//
//   @override
//   State<CompetitionDescription> createState() => _CompetitionDescriptionState();
// }
//
// class _CompetitionDescriptionState extends State<CompetitionDescription> {
//   bool isLoading = true;
//
//   late Timer timer;
//   void getRecipes() async {
//     timer = Timer.periodic(const Duration(milliseconds: 1000), (timer) async {
//       if (!mounted) {
//         timer.cancel();
//         // Stop the timer if the widget is not mounted
//         return;
//       }
//       Competition.savedCompetitions =
//       await Competition.loadCompetitionsFromSharedPrefs();
//       setState(() {
//         isLoading = false;
//       });
//       if(Competition.savedCompetitions.length == 0){
//         setState(() {
//           isLoading = true;
//         });
//       }
//     });
//
//   }
//   VideoPlayerController? videoController = null;
//   ChewieController? chewieController = null;
//   bool isLoadingVideo = false;
//   List<Tab> tabs = [Tab(
//     text: 'Video',
//   ),Tab(
//     text: 'Image',
//   )];
//   @override
//   void initState() {
//     setVideo(widget.comp.videoFile);
//     super.initState();
//   }
//   void setVideo(File? video) {
//     if (widget.comp.videoFile == null) {
//       print("widget.res.video is Null");
//       return;
//     }
//     print("widget.res.video is not null");
//     setState(() {
//       videoController = VideoPlayerController.file(widget.comp.videoFile!);
//       chewieController = ChewieController(
//         videoPlayerController: videoController!,
//         autoPlay: false,
//         looping: false,
//         allowMuting: true,
//         showControls: true,
//         autoInitialize: true,
//         showOptions: false,
//       );
//       isLoadingVideo = false;
//     });
//   }
//   final PageController _pageController = PageController(initialPage: 0);
//   int _currentPage = 0;
//   @override
//   void dispose() {
//     videoController?.dispose();
//     chewieController?.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     ModelTheme lang = Provider.of<ModelTheme>(context);
//
//     ThemeData theme = Theme.of(context);
//     return Scaffold(
//         appBar: AppBar(
//           title: Text(widget.comp.name.toString(),
//             style: TextStyle(
//               color: theme.colorScheme.primary
//           ),),
//           backgroundColor: Colors.transparent,
//           elevation: 0,
//           leading: GestureDetector(
//               onTap: () {
//                 Navigator.of(context).pop();
//               },
//               child: Icon(
//                 Icons.arrow_back,
//                 color: theme.colorScheme.primary,
//               )),
//         ),
//         body: SingleChildScrollView(
//           //TODO fix the end of slider effect
//             scrollDirection: Axis.vertical,
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//
//                   Card(
//                     child: Container(
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(5),
//                         ),
//                         child: ClipRRect(
//                           borderRadius: BorderRadius.circular(5),
//                           child: Container(
//                               constraints: BoxConstraints(minHeight: 200.0, maxHeight: 400),
//                               child: isLoadingVideo == true
//                                   ? CircularProgressIndicator(backgroundColor:Colors.pink)
//                                   : videoController != null
//                                   ? Chewie(controller: chewieController!):
//                               CircularProgressIndicator(backgroundColor:Colors.blue,)),
//                         )),
//                   ),
//                   MainButton(
//                     text: 'Delete',
//                     onPress: () async {
//                       Competition.deleteCompetition(comp);
//                       Competition.savedCompetitions = await Competition.loadCompetitionsFromSharedPrefs();
//                     },
//                   ),
//                 ])));
//   }
//
//
// }
