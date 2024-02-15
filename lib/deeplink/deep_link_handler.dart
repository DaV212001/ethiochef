import 'package:ethio_chef/services/food_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

import '../models/food.dart';
import 'deep_link_navigator.dart';

class DeepLinkHandler extends StatefulWidget {
  final Widget child;

  const DeepLinkHandler({Key? key, required this.child}) : super(key: key);

  @override
  _DeepLinkHandlerState createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> with WidgetsBindingObserver {
  Uri? _initialUri;
  Uri? _latestUri;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    getInitialUriFromPlugin().then((uri) {
      if (uri != null) {
        setState(() {
          _initialUri = uri;
        });
      }
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  Future<Uri?> getInitialUriFromPlugin() async {
    try {
      final uri = await getInitialUri();
      return uri;
    } on PlatformException catch (err) {
      print('Failed to get initial uri: $err');
      return null;
    }
  }

  @override
  Future<bool> didPushRouteInformation(RouteInformation routeInformation) async {
    print('DEVVVVV NOTIFYINGGGGG THATTTTT    didPushRouteInformation called');
    print('ANDDDDD THAT I HAVE RLLLL: ${routeInformation.location!}');
    final uri = Uri.parse(routeInformation.location!);
    setState(() {
      _latestUri = uri;
    });

    // Return true if the deep link matches the expected scheme and host
    if (_latestUri != null && _latestUri?.scheme == 'https' && _latestUri?.host == 'ethiochef.com') {
      return true;
    }

    // Return false if the deep link does not match the expected scheme and host
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState)  {
        print('CHECKING TO SEEE IF WE CAN USE THE INITIAL URLLLLLL: $_initialUri');
        // Check if the deep link matches the expected scheme and host
        if (!_navigated && ((_initialUri != null && _initialUri?.scheme == 'https' && _initialUri?.host == 'ethiochef.com') ||
            (_latestUri != null && _latestUri?.scheme == 'https' && _latestUri?.host == 'ethiochef.com'))) {
          print('CHECKING FOR ORIGINALLL URL CORRECTNESS!!!!!: $_latestUri');
          // Extract the video file name from the deep link
          final foodId = _latestUri?.pathSegments.last??_initialUri?.pathSegments.last;
          print('CHECKING FOR URL CORRECTNESS!!!!!:  $foodId');
          // get the food item from the url
          int foodID = int.parse(foodId!);

          // Navigate to VideoPlayerWidget with the video URL
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Navigator.push(context, MaterialPageRoute(builder: (context) => DeepLinkNavigation(foodID: foodID)));
          });
          _navigated = true;
        }
        // If no deep link is detected, return the normal home screen of your app
        return widget.child;
      },
    );
  }
}
