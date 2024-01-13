// import 'dart:async';
//
// import 'package:chewie/chewie.dart';
// import 'package:ethio_chef/models/competition.dart';
// import 'package:flutter/material.dart';
// import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
// import 'package:pod_player/pod_player.dart';
//
// import '../../../../widgets/main_button.dart';
// import '../../../../widgets/profile/my_competition_card.dart';
// import '../../../competition/layout/upload_video.dart';
// import '../../../upload_recipe/upload_recipe_screen.dart';
// import 'my_comp_description.dart';
//
//
// class MyCompetition extends StatefulWidget {
//   const MyCompetition({super.key});
//
//   @override
//   State<MyCompetition> createState() => _MyCompetitionState();
// }
//
// class _MyCompetitionState extends State<MyCompetition> {
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
//   @override
//   void initState() {
//     super.initState();
//   }
//   @override
//   void dispose() {
//     videoController?.dispose();
//     chewieController?.dispose();
//     super.dispose();
//   }
//   @override
//   Widget build(BuildContext context) {
//     final ThemeData theme = Theme.of(context);
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("My Competition(s)",style: TextStyle(
//             color: theme.colorScheme.primary
//         )),
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//         leading: GestureDetector(
//             onTap: () {
//               Navigator.of(context).pop();
//             },
//             child: Icon(
//               Icons.arrow_back,
//               color: theme.colorScheme.primary,
//             )),
//       ),
//       body: Competition.savedCompetitions.length==0?Center(
//         child: Column(
//           children: [
//             Text("Add competition")
//           ],
//         ),
//       ):isLoading ==true?
//       Center(
//         child: CircularProgressIndicator(),
//       )
//           :
//       ListView.builder(
//         scrollDirection: Axis.vertical,
//         shrinkWrap: true,
//         physics: NeverScrollableScrollPhysics(),
//         itemCount: Competition.savedCompetitions.length,
//         itemBuilder: (BuildContext context, int index) {
//           var comp = Competition.savedCompetitions[index];
//           return Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//
//                 Card(
//                   child: Container(
//                       decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(5),
//                         child: Container(
//                             constraints: BoxConstraints(minHeight: 200.0, maxHeight: 400),
//                             child: isLoadingVideo == true
//                                 ? CircularProgressIndicator(backgroundColor:Colors.pink)
//                                 : videoController != null
//                                 ? Chewie(controller: chewieController!):
//                             CircularProgressIndicator(backgroundColor:Colors.blue,)),
//                       )),
//                 ),
//                 MainButton(
//                   text: 'Delete',
//                   onPress: () async {
//                     Competition.deleteCompetition(comp);
//                     Competition.savedCompetitions = await Competition.loadCompetitionsFromSharedPrefs();
//                   },
//                 ),
//               ]);
//         },),
//         floatingActionButton: FloatingActionButton(
//           backgroundColor:  theme.colorScheme.primary,
//           onPressed: () {
//             pushNewScreen(context,
//                 screen: UploadCompetitionVideo(), withNavBar: false);
//           },
//           child: Icon(
//               Icons.add,
//               color:Colors.white
//           ),
//         )
//     );
//   }
// }
// /*
// * Column(
//           children: [
//             GestureDetector(
//
//             ),
//             Text(resp.name.toString()),
//             Text(resp.description.toString()),
//             Text(resp.prepTime.toString()),
//             Text(resp.servingSize.toString()),
//             ListView.builder(
//                 scrollDirection: Axis.vertical,
//                 physics: BouncingScrollPhysics(),
//                 shrinkWrap: true,
//                 itemCount: resp.steps?.length,
//                 itemBuilder: (context, index){
//                   return Column(
//                     children: [
//                       Text(resp.steps![index].toString()),
//                     ],
//                   );
//                 }
//             ),
//             ListView.builder(
//                 scrollDirection: Axis.vertical,
//                 physics: BouncingScrollPhysics(),
//               shrinkWrap: true,
//                 itemCount: resp.ingredient?.length,
//                 itemBuilder: (context, index){
//                 var ing = resp.ingredient![index];
//                 return Column(
//                   children: [
//                     Text(ing['ingredient'].toString()),
//                     Text(ing['quantity'].toString()),
//                   ],
//                 );
//                 }
//             ),
//
//             Text("==============================="),
//             SizedBox(height: 50,)
//           ],
//         )
// * */