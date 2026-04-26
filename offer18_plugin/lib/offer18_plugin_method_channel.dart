import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'offer18_plugin_platform_interface.dart';

/// An implementation of [Offer18PluginPlatform] that uses method channels.
class MethodChannelOffer18Plugin extends Offer18PluginPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('offer18_plugin');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
