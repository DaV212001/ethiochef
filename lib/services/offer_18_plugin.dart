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
