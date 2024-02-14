import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../utils/screen_utils.dart';

class MainButton extends StatelessWidget {
  final double height;
  final double width;
  final String text;
  final Function() onPress;
  final bool isLoading;

  const MainButton(
      {super.key,
        this.isLoading = false,
      this.height = 65,
      this.width = double.infinity,
      required this.text,
      required this.onPress});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Container(
      width: width,
      height: height,
      padding: EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        onPressed: isLoading ? null : onPress,
        child: Visibility(
          visible: isLoading,
          child: CircularProgressIndicator(),
          replacement: Text(
            text,
              style: TextStyle(
                  fontSize: 15.sp,
                  fontWeight: FontWeight.w800,
                  color: theme.colorScheme.secondary)
          )
        ),
        style: ButtonStyle(
          backgroundColor: MaterialStatePropertyAll(theme.colorScheme.primary),
          shape: MaterialStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }
}
