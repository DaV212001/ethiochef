import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:uni_links/uni_links.dart';

import '../screens/auth/auth_screen.dart';
import '../services/authorization_service.dart';
import '../widgets/loading.dart';
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
        _checkAndHandleDeepLink(uri);
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

  void _checkAndHandleDeepLink(Uri uri) {
    if (_navigated) {
      return;
    }

    // Check if the user is logged in
    AuthService.getAuthorizationToken().then((token) {
      if (token == "none") {
        // User is not logged in, navigate to AuthScreen
        Navigator.push(context, MaterialPageRoute(builder: (context) => AuthScreen(isSignIn: true, isfromDeepLink: true,)))
            .then((value) {
          // Check login status again after returning from AuthScreen
          AuthService.getAuthorizationToken().then((newToken) {
            if (newToken != "none") {
              _navigateToDeepLink(uri);
            }
          });
        });
      } else {
        // User is logged in, navigate to DeepLinkNavigation
        _navigateToDeepLink(uri);
      }
    });
  }

  void _navigateToDeepLink(Uri uri) {
    // Extract the last segment of the deep link URL into an int variable
    final foodId = uri.pathSegments.last;

    if (foodId == null || foodId == '') {
      setState(() {
        _navigated = true;
      });
      return;
    }

    int foodID = int.tryParse(foodId) ?? 0;

    if (foodID > 0) {
      // Navigate to DeepLinkNavigation with the extracted food ID
      setState(() {
        _navigated = true;
      });
      Navigator.push(context, MaterialPageRoute(builder: (context) => DeepLinkNavigation(foodID: foodID)));
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no deep link is detected, return the normal home screen of your app
    return widget.child;
  }
}
