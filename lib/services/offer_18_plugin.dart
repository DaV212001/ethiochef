import 'package:android_play_install_referrer/android_play_install_referrer.dart';
import 'package:flutter/services.dart';

class Offer18Plugin {
  static const MethodChannel _channel = MethodChannel('offer18_plugin');

  static Future<void> initSDK(
      String domain, String accountId, String tidKey) async {
    await _channel.invokeMethod('initSDK', {
      'domain': domain,
      'accountId': accountId,
      'tidKey': tidKey,
    });
  }

  static Future<void> trackConversion(Map<String, String> args) async {
    if (args['tid'] == "{REFERRER_TID}") {
      ReferrerDetails referrerDetails =
          await AndroidPlayInstallReferrer.installReferrer;
      print('INSTALL REFERRER URL FETCHED: ${referrerDetails.installReferrer}');
      if (referrerDetails.installReferrer != null) {
        args['tid'] = referrerDetails.installReferrer!.split('=')[1];
      }
      print(args);
    }
    var response = await _channel.invokeMethod('trackConversion', {
      'args': args,
    });
    print(response);
  }

  static Future<void> getReferrerInstallUrl() async {
    var response = await _channel.invokeMethod('getReferrerInstallUrl');
    print('Referrer Url: $response');
  }
}

class Offer18EventArguments {
  static Map<String, String> REGISTRATION = {
    "o": "21213899",
    "tid": "{REFERRER_TID}",
    "event": "registration",
    "m": "459",
    "adv_sub1": "",
    "adv_sub2": "",
    "adv_sub3": "",
    "adv_sub4": "",
    "adv_sub5": "",
    "coupon": "",
    "sale": "",
    "payout": ""
  };
  static Map<String, String> INSTALL = {
    "o": "21213899",
    "tid": "{REFERRER_TID}",
    "event": "install",
    "m": "459",
    "adv_sub1": "",
    "adv_sub2": "",
    "adv_sub3": "",
    "adv_sub4": "",
    "adv_sub5": "",
    "coupon": "",
    "sale": "",
    "payout": ""
  };
}
