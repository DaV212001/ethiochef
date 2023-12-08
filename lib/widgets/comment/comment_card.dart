
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';

import '../../models/comment.dart';
import '../../models/user.dart';
import '../../screens/comment/add_edit_comment.dart';
import '../../services/comment_service.dart';
import '../../utils/screen_utils.dart';

class CommentCard extends StatelessWidget {
  final Comments comment;
  final int? fooId;
  final User user;
  final Function() refresh;

  const CommentCard(
      {super.key,
        required this.comment,
        required this.refresh,
        required this.fooId,
        required this.user});

  @override
  Widget build(BuildContext context) {
    String body;
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: isTablet ? 0.w : 10.w),
      padding: EdgeInsets.only(
          top: isTablet ? 5.w : 10.h,
          right: isTablet ? 5.w : 10.w,
          left: isTablet ? 5.w : 10.w),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.all(Radius.circular(5.r)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        // mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "${comment.user.firstName} ${comment.user.lastName}",
            style: TextStyle(
                fontSize: isTablet ? 8.sp : 13.sp,
                fontWeight: FontWeight.w300),
          ),
          const Divider(),
          Text(
            comment.comment,
            style: TextStyle(
                fontSize: isTablet ? 11.sp : 16.sp,
                fontWeight: FontWeight.w500),
          ),
          Visibility(
            visible: comment.user.id == user.id,
            child: Column(
              children: [
                const Divider(),
                buildButtons(context)
              ],
            ),
            replacement: SizedBox.shrink(),
          ),

        ],
      ),
    );
  }

  Widget buildButtons(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        InkWell(
          onTap: (){
            pushNewScreen(
                context,
                screen: AddEditComment(
                    isEditing: true,
                    foodId: fooId!,
                    comments: comment,
                    refresh: (){
                      refresh();
                    }
                )
            );
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Text(
              "edit".tr(),
              style: TextStyle(
                color: theme.primaryColor,
                fontWeight: FontWeight.normal,
                fontSize: isTablet ? 11.sp : 15.sp,
              ),
            ),
          ),
        ),
        InkWell(
          onTap: (){
            removeComment(context);
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
            child: Text(
              "remove".tr(),
              style: TextStyle(
                  color: theme.colorScheme.error,
                  fontWeight: FontWeight.normal,
                  fontSize: isTablet ? 11.sp : 15.sp),
            ),
          ),
        )
      ],
    );
  }
  void removeComment(BuildContext context) async{


    CommentService service = CommentService();
    try {
      var response =
      await service.deleteComment(comment.id);
      if (response.statusCode == 200) {
        refresh();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('deleted_comment_successful'.tr())),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('deleted_comment_failed'.tr())),
        );
        throw Exception();
      }
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('deleted_comment_failed'.tr())),
      );
    }

  }
}
