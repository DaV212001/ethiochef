import 'package:flutter_test/flutter_test.dart';
import 'package:offer18_plugin/offer18_plugin.dart';
import 'package:offer18_plugin/offer18_plugin_platform_interface.dart';
import 'package:offer18_plugin/offer18_plugin_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockOffer18PluginPlatform
    with MockPlatformInterfaceMixin
    implements Offer18PluginPlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final Offer18PluginPlatform initialPlatform = Offer18PluginPlatform.instance;

  test('$MethodChannelOffer18Plugin is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelOffer18Plugin>());
  });

  test('getPlatformVersion', () async {
    Offer18Plugin offer18Plugin = Offer18Plugin();
    MockOffer18PluginPlatform fakePlatform = MockOffer18PluginPlatform();
    Offer18PluginPlatform.instance = fakePlatform;

    expect(await offer18Plugin.getPlatformVersion(), '42');
  });
}
