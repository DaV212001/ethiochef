import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'offer18_plugin_method_channel.dart';

abstract class Offer18PluginPlatform extends PlatformInterface {
  /// Constructs a Offer18PluginPlatform.
  Offer18PluginPlatform() : super(token: _token);

  static final Object _token = Object();

  static Offer18PluginPlatform _instance = MethodChannelOffer18Plugin();

  /// The default instance of [Offer18PluginPlatform] to use.
  ///
  /// Defaults to [MethodChannelOffer18Plugin].
  static Offer18PluginPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [Offer18PluginPlatform] when
  /// they register themselves.
  static set instance(Offer18PluginPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
