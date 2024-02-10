import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/competition.dart';
import 'package:ethio_chef/screens/competition/layout/competition_header.dart';
import 'package:ethio_chef/screens/competition/layout/competition_header_image.dart';
import 'package:ethio_chef/utils/place_holder_data.dart';
import 'package:ethio_chef/widgets/recipe/share_button.dart';
import 'package:ethio_chef/widgets/youtube_video_player.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

import '../../services/subscription_checker.dart';
import '../../services/user_service.dart';
import '../../utils/screen_utils.dart';
import '../auth/auth_screen.dart';
import '../subscription/all_subscriptions.dart';
import 'layout/contestants_carousel.dart';
import 'layout/upload_video.dart';

class CompetitionScreen extends StatefulWidget {
  final Competition competition;

  const CompetitionScreen({super.key, required this.competition});

  @override
  State<CompetitionScreen> createState() => _CompetitionScreenState();
}

class _CompetitionScreenState extends State<CompetitionScreen> {
  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    final bool isTablet = ScreenUtils.isTablet(context);
    ThemeData theme = Theme.of(context);
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: DefaultTabController(
            length: 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CompetitionHeaderImage(
                  image: widget.competition.image.toString(),
                ),
                CompetitionHeader(
                  competition: widget.competition,
                ),
                SizedBox(
                  height: 10.h,
                ),
                if (widget.competition.video != null)
                  YoutubeVideoPlayer(
                    link: widget.competition.video!,
                  ),
                if(widget.competition.competitor!.isNotEmpty)
                Contestants(contestant: widget.competition.competitor, contest_id: widget.competition.id!)
                // ShareButton(food: PlaceHolderData.food)
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: theme.colorScheme.primary,
          onPressed: () async {
            setState(() {
              isLoading = true;
            });
            await handleSubscriptionStatus(context);
            setState(() {
              isLoading = false;
            });
          },
          child: isLoading == true ? CircularProgressIndicator(
            color: Colors.white,
          ):Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }
  Future<void> handleSubscriptionStatus(BuildContext context) async {
    String? status = SubscriptionStatus().status;

    switch (status) {
      case "Not logged in":
        showSnackBarAndNavigate(context, 'please_subscribe_to_see_ingredients_and_steps'.tr(), AuthScreen(isSignIn: true));
        break;
      case "Another user logged in":
        showSnackBarAndNavigate(context, 'another_account_login'.tr(), AuthScreen(isSignIn: true));
        break;
      case "User is subscribed":
        final userService = UserService();
        var userData = await userService.fetchUserProfile();

        if (userData!.isFromSMS == false) {
          pushNewScreen(context, screen: UploadCompetitionVideo(competitionId: widget.competition.id!), withNavBar: false);
        } else {
          showSubscriptionAlert(context);
        }
        break;
      case "User is not subscribed":
        pushNewScreen(context, withNavBar: false, screen: AllSubscriptions(returnPrice: (int) {}, first_name: "", last_name: "", isSignUp: false, phone: ""));
        break;
    }
    setState(() {
      isLoading = false;
    });
  }

  void showSubscriptionAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.error,
      showCancelBtn: true,
      showConfirmBtn: true,
      text: 'sms_payment_error'.tr(),
      titleAlignment: TextAlign.center,
      textAlignment: TextAlign.center,
      confirmBtnText: 'pay'.tr(),
      onConfirmBtnTap: () {
        pushNewScreen(context, withNavBar: false, screen: AllSubscriptions(returnPrice: (int) {}, first_name: "", last_name: "", isSignUp: false, phone: ""));
      },
      cancelBtnText: 'cancel'.tr(),
      onCancelBtnTap: () {
        Navigator.pop(context);
      },
      confirmBtnColor: Colors.red,
      cancelBtnTextStyle: TextStyle(
        color: Colors.black,
        fontWeight: FontWeight.bold,
      ),
      backgroundColor: Colors.white,
      headerBackgroundColor: Colors.grey,
      confirmBtnTextStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      barrierColor: Colors.red,
      titleColor: Colors.red,
      textColor: Colors.red,
    );
    setState(() {
      isLoading = false;
    });
  }

  void showSnackBarAndNavigate(BuildContext context, String message, Widget route) {
    setState(() {
      isLoading = false;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        padding: EdgeInsets.symmetric(vertical: 20),
        content: Text(message),
      ),
    );
    pushNewScreen(context, withNavBar: false, screen: route);
  }
}
