import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../generated/assets.dart';
import '../../models/footer_data.dart';
import '../../theme/app_theme.dart';
import '../../utils/screen_utils.dart';
import '../svg_icon.dart';

class UserScreenFooter extends StatelessWidget {
  final FooterData footerData;

  const UserScreenFooter({super.key, required this.footerData});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    print(footerData.toString());
    Color color = Theme.of(context).colorScheme.primary;
    bool isTablet = ScreenUtils.isTablet(context);
    return Column(
      children: [
        Text(footerData.copyWriteText,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 17.sp,
                fontWeight: FontWeight.w800,
                color: theme.colorScheme.secondaryContainer)),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(footerData.faceBookLink != "")
            socialMediaButton(color, footerData.faceBookLink,
                Assets.socialFacebook, isTablet),
            if(footerData.youtubeLink != "")
            socialMediaButton(color, footerData.youtubeLink,
                Assets.socialYoutube, isTablet),
            if(footerData.instagramLink != "")
            socialMediaButton(color, footerData.instagramLink,
                Assets.socialInstagram, isTablet),
            if(footerData.linkedInLink != "")
            socialMediaButton(color, footerData.linkedInLink,
                Assets.socialLinkedin, isTablet),
            if(footerData.twitterLink != "")
            socialMediaButton(color, footerData.twitterLink,
                Assets.socialTwitter, isTablet),
            if(footerData.telegramLink != "")
            socialMediaButton(color, footerData.telegramLink,
                Assets.socialTelegram, isTablet),
            if(footerData.tiktokLink != "")
            socialMediaButton(color, footerData.tiktokLink,
                Assets.socialTiktok, isTablet),
          ],
        )
      ],
    );
  }

  Widget socialMediaButton(
      Color color, String? link, String image, bool isTablet) {
    if (link == null) return SizedBox.shrink();
    return Ink(
      child: InkWell(
        onTap: () {
          _launchUrl(link, isTablet);
        },
        child: SvgIcon(
          color: color,
          image: image,
          size: 50.sp,
        ),
      ),
    );
  }

  Future<void> _launchUrl(String url, bool isTablet) async {
    final Uri _url = Uri.parse(url);
    if (!await launchUrl(_url)) {
      SnackBar(
          content: Text(
        'open_link_failed'.tr(),
        style: isTablet ? AppTheme.snackBarStyleTablet : AppTheme.snackBarStyle,
      ));
    }
  }
}
