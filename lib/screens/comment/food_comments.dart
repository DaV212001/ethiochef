import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/screens/comment/add_edit_comment.dart';
import 'package:ethio_chef/widgets/comment/comment_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/comment.dart';
import '../../models/user.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/main_app_bar.dart';

class CommentScreen extends StatelessWidget {
  final List<Comments> comments;
  final Function() refresh;
  final User user;
  const CommentScreen({super.key,
    required this.comments,
    required this.refresh,
    required this.user
  });

  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    final double desiredItemWidth = isTablet ? 165.w : 200.w;
    final double desiredItemHeight = isTablet ? 230.h : 260.h;
    final double childAspectRatio = desiredItemHeight / desiredItemWidth;
    return Padding(
      padding: const EdgeInsets.only(top: 10, left: 12,right: 12),
      child: ListView.builder(
          physics: NeverScrollableScrollPhysics(),
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: comments.length,
          itemBuilder: (context, index) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: CommentCard(
                  comment: comments[index],
                  user: user,
                  refresh: (){
                    print("Called this guy");
                refresh();
              }),
            );
          }),
    );
  }
}
