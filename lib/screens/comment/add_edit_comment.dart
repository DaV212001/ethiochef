import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/widgets/main_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../models/comment.dart';
import '../../services/comment_service.dart';
import '../../utils/screen_utils.dart';
import '../../widgets/custom_form_field.dart';
import '../../widgets/main_app_bar.dart';

class AddEditComment extends StatefulWidget {
  final int foodId;
  final Comments? comments;
  final bool isEditing;
  final Function() refresh;
  const AddEditComment({super.key,
    this.comments,
    required this.isEditing,
    required this.foodId,
    required this.refresh});

  @override
  State<AddEditComment> createState() => _AddEditCommentState();
}

class _AddEditCommentState extends State<AddEditComment> {
  final formKey = GlobalKey<FormState>();
  bool isLoading = false;

  TextEditingController commentController = TextEditingController();
  @override
  void initState() {
    if(widget.comments != null){
      setState(() {
        commentController.text = widget.comments!.comment;
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    ThemeData theme = Theme.of(context);
    final bool isTablet = ScreenUtils.isTablet(context);
    return Scaffold(
        appBar: MainAppBar(
          title: "comment".tr(),
          hasMainIcons: false,
        ),
        body: SingleChildScrollView(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.only(
                  left: isTablet ? 80.w : 40.w,
                  right: isTablet ? 80.w : 40.w,
                  top: isTablet ? 50.h : 10.h),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    CustomFormField(
                      name: "comment".tr(),
                      controller: commentController,
                      hint: 'comment'.tr(),
                      maxLines: 10,
                      minLines: 3,
                      required: true,
                    ),
                    MainButton(
                      text: widget.isEditing ? 'edit_comment'.tr() : 'add_comment'.tr(),
                      onPress: () {
                        if (widget.isEditing) {
                          editComment();
                        } else {
                          addComment();
                        }
                      },
                      isLoading: isLoading,
                    ),

                  ],
                ),
              ),
            ),
          ),
        )
    );
  }
  void editComment() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      print("commentController.text ${commentController.text}");
      CommentService service = CommentService();
      try {
        var response =
        await    service.updateComment( widget.comments!.id!,
            widget.foodId, commentController.text);
        if (response.statusCode == 200) {
          widget.refresh();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('update_comment_successful'.tr())),
          );
          Navigator.of(context).pop();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('update_comment_failed'.tr())),
          );
          throw Exception();
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('update_comment_failed'.tr())),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<bool> addComment() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      print("widget.foodId ${widget.foodId}");
      print("commentController.text ${commentController.text}");
      CommentService service = CommentService();
      try {
        bool response =
        await service.createComment(widget.foodId, commentController.text);
        if (response == true) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('add_comment_successful'.tr())),
          );
          widget.refresh();
          Navigator.of(context).pop();
          return true;
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('add_comment_failed'.tr())),
          );
          throw Exception();
        }
      } catch (e) {
        print(e);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('add_comment_failed'.tr())),
        );
      }
      setState(() {
        isLoading = false;
      });
    }
    return false;
  }
}
