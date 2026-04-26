
import 'offer18_plugin_platform_interface.dart';

class Offer18Plugin {
  Future<String?> getPlatformVersion() {
    return Offer18PluginPlatform.instance.getPlatformVersion();
  }
}
