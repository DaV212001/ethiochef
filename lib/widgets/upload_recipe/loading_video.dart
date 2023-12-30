import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class LoadingVideo extends StatefulWidget {
  @override
  _LoadingVideoState createState() => _LoadingVideoState();
}

class _LoadingVideoState extends State<LoadingVideo> {
  bool showSecondRow = false;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration(seconds: 7), () {
    //   setState(() {
    //     if (mounted) {
    //       // Check if the widget is still mounted
    //       setState(() {
    //         showSecondRow = true;
    //       });
    //     }
    //   });
    // });
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return SizedBox(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                ),
              ),
              SizedBox(width: 10),
              Text(
                "video_is_loading".tr(),
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.unselectedWidgetColor.withOpacity(0.85),
                ),
              ),
            ],
          ),
          if (showSecondRow)
            SizedBox(
              height: 10
            ),
          if (showSecondRow) // Show the second row if showSecondRow is true
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "video_is_loading_body".tr(),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.unselectedWidgetColor.withOpacity(0.85),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }
}
