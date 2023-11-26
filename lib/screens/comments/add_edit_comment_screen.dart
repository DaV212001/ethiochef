//
// import 'package:easy_localization/easy_localization.dart';
// import 'package:ethio_chef/widgets/main_button.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// import '../../utils/screen_utils.dart';
// import '../../widgets/custom_form_field.dart';
//
// class AddEditCommentScreen extends StatefulWidget {
//
//   const AddEditCommentScreen({super.key});
//
//   @override
//   State<AddEditCommentScreen> createState() => _AddEditCommentScreenState();
// }
//
// class _AddEditCommentScreenState extends State<AddEditCommentScreen> {
//   final commentController = TextEditingController();
//   final formKey = GlobalKey<FormState>();
//   bool isLoading = false;
//
//   @override
//   void initState() {
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//
//     ThemeData theme = Theme.of(context);
//     final bool isTablet = ScreenUtils.isTablet(context);
//     return Scaffold(
//         body: SingleChildScrollView(
//           child: SafeArea(
//             child: Padding(
//               padding: EdgeInsets.only(
//                   left: isTablet ? 80.w : 40.w,
//                   right: isTablet ? 80.w : 40.w,
//                   top: isTablet ? 50.h : 10.h),
//               child: Form(
//                 key: formKey,
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     CustomFormField(
//                       maxLines: 10,
//                       minLines: 3,
//                       controller: commentController,
//                       name: "body".tr(),
//                     ),
//                     MainButton(
//                       isLoading: isLoading,
//                         text: "_address".tr(),
//                         onPress: (){
//                           if (formKey.currentState!.validate()){
//
//                           }
//                         })
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         )
//     );
//   }
//
//   Widget gap(BuildContext context) {
//     return SizedBox(
//       height: 20.h,
//     );
//   }
//
//
//   // final bool isTablet = ScreenUtils.isTablet(context);
//   // SnackBar success = SnackBar(
//   //     content: Text(
//   //       'comment_create_successful'.tr(),
//   //       style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
//   //     ));
//   // SnackBar failed = SnackBar(
//   //     content: Text(
//   //       'comment_create_failed'.tr(),
//   //       style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
//   //     ));
// }
