import '../../theme/app_theme.dart';
import '../../widgets/cached_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/contestants.dart';

class VoteCard extends StatefulWidget {
  final Contestant competitor;
  const VoteCard({super.key, required this.competitor});

  @override
  State<VoteCard> createState() => _VoteCardState();
}

class _VoteCardState extends State<VoteCard> {
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: AppTheme.allBorderRadius,
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Container(
                  width: 100.w,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100.r),
                    child: CachedImage(
                      url: widget.competitor.image!,
                      fit: BoxFit.fill,
                    ),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Text(
                widget.competitor.firstName!,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.start,
              ),
            ],
          ),
        ],
      ),
    );
  }
  // Widget buildcard(){
  //   ThemeData theme = Theme.of(context);
  //   return Card(
  //     elevation: 12,
  //     shape: RoundedRectangleBorder(
  //       borderRadius: BorderRadius.circular(20.0),
  //     ),
  //     color: theme.cardColor,
  //     child: Column(
  //       children: [
  //         ClipRRect(
  //           borderRadius: const BorderRadius.only(
  //             topRight: Radius.circular(20),
  //             topLeft: Radius.circular(20),
  //           ),
  //           child: CachedImage(
  //             url: widget.competition.image.toString(),
  //             fit: BoxFit.fill,
  //           ),
  //         ),
  //         const ListTile(
  //           title: Text(
  //             'Melbourne Cricket Stadium',
  //             style: TextStyle(
  //               color: Colors.white,
  //             ),
  //           ),
  //           subtitle: Text(
  //             'Australia',
  //             style: TextStyle(
  //               color: Colors.grey,
  //             ),
  //           ),
  //         ),
  //         Padding(
  //             padding:
  //             EdgeInsets.symmetric(horizontal: 20, vertical: 10),
  //             child: Row(
  //               children: [
  //                 Expanded(
  //                   child: TextButton(
  //                     style: TextButton.styleFrom(
  //                         backgroundColor: Colors.white),
  //                     onPressed: () {},
  //                     child: const Text(
  //                       "Edit",
  //                       style: TextStyle(
  //                         color: Colors.black,
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.w300,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //                 SizedBox(
  //                   width: 20,
  //                 ),
  //                 Expanded(
  //                   child: TextButton(
  //                     style: TextButton.styleFrom(
  //                         backgroundColor: Colors.red),
  //                     onPressed: () {},
  //                     child: const Text(
  //                       "Delete",
  //                       style: TextStyle(
  //                         color: Colors.white,
  //                         fontSize: 20,
  //                         fontWeight: FontWeight.w300,
  //                       ),
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ))
  //       ],
  //     ),
  //   );
  // }

}
