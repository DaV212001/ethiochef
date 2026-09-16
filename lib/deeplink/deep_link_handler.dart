import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';

import '../screens/auth/auth_screen.dart';
import '../services/authorization_service.dart';
import 'deep_link_navigator.dart';

class DeepLinkHandler extends StatefulWidget {
  final Widget child;

  const DeepLinkHandler({Key? key, required this.child}) : super(key: key);

  @override
  _DeepLinkHandlerState createState() => _DeepLinkHandlerState();
}

class _DeepLinkHandlerState extends State<DeepLinkHandler> {
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;
  bool _navigated = false;

  @override
  void initState() {
    super.initState();
    _initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  void _initDeepLinks() async {
    _appLinks = AppLinks();

    // Handle links when app is in foreground or background
    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      _checkAndHandleDeepLink(uri);
    });

    // Handle initial link if app was closed
    try {
      final uri = await _appLinks.getInitialLink();
      if (uri != null) {
        _checkAndHandleDeepLink(uri);
      }
    } catch (e) {
      debugPrint('Failed to get initial link: $e');
    }
  }

  void _checkAndHandleDeepLink(Uri uri) {
    if (_navigated) {
      return;
    }

    // try {
    //   if (uri.queryParameters.containsKey('tid')) {
    //     String? _transactionId = uri.queryParameters['tid'];
    //     if (_transactionId != null) {
    //       GetStorage storage = GetStorage();
    //       storage.write('tid', _transactionId);
    //       return;
    //     }
    //   }
    //   if (uri.queryParameters.containsKey('o')) {
    //     String? _transactionId = uri.queryParameters['o'];
    //     if (_transactionId != null) {
    //       GetStorage storage = GetStorage();
    //       storage.write('o', _transactionId);
    //       return;
    //     }
    //   }
    // } on Exception catch (e) {
    //   print(e);
    // }

    // Check if the user is logged in
    AuthService.getAuthorizationToken().then((token) {
      if (token == "none") {
        // User is not logged in, navigate to AuthScreen
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                AuthScreen(isSignIn: true, isfromDeepLink: true),
          ),
        ).then((value) {
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
    if (uri.pathSegments.isEmpty) return;
    final foodId = uri.pathSegments.last;

    if (foodId.isEmpty) {
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
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => DeepLinkNavigation(foodID: foodID),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // If no deep link is detected, return the normal home screen of your app
    return widget.child;
  }
}
