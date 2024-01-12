import 'dart:convert';

import 'package:device_preview/device_preview.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/deeplink/deep_link_handler.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/screens/main_screen.dart';
import 'package:ethio_chef/services/authorization_service.dart';
import 'package:ethio_chef/services/firsebase_service.dart';
import 'package:ethio_chef/services/user_service.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/theme/model_theme.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


final navigatorKey = GlobalKey<NavigatorState>();
void main() async {
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: AppTheme.primaryColor
  ));
  WidgetsFlutterBinding.ensureInitialized();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  await EasyLocalization.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await FirebaseService().initNotification();

  runApp(
    Phoenix(
         child:
         //DevicePreview(
        //     enabled: !kReleaseMode,
        //     builder: (context) =>
                EasyLocalization(
                supportedLocales: const [
                  // needed to use these locales because om,ti  where not supported
                  Locale('en', 'AU'),
                  Locale('am'),
                  Locale('en', 'GB'),
                  Locale('en'),
                ],
                path: 'assets/locale',
                fallbackLocale: const Locale('en'),
                child: RestartWidget(child: EthioChef()))
  // ),
      )
  );
}
class RestartWidget extends StatefulWidget {
  RestartWidget({required this.child});

  final Widget child;

  static void restartApp(BuildContext context) {
    context.findAncestorStateOfType<_RestartWidgetState>()?.restartApp();
  }

  @override
  _RestartWidgetState createState() => _RestartWidgetState();
}

class _RestartWidgetState extends State<RestartWidget> {
  Key key = UniqueKey();

  void restartApp() {
    setState(() {
      key = UniqueKey();
    });
  }

  @override
  Widget build(BuildContext context) {
    return KeyedSubtree(
      key: key,
      child: widget.child,
    );
  }
}
class EthioChef extends StatefulWidget {
  const EthioChef({super.key});

  @override
  State<EthioChef> createState() => _EthioChefState();
}


class _EthioChefState extends State<EthioChef> {
  bool isFirstTimeUser = true;
  bool isLoggedIn = true;

  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }
  Future<void> _checkFirstTimeUser() async {
    print("check login status");
    await FirebaseService().checkTokenRegistration(false);
  }

  @override
  Widget build(BuildContext context) {
    Language.selectedLanguage = Language.getSelectedLanguage(context);
    print("main 1");
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ModelTheme())
      ],
      child: Consumer<ModelTheme>(
          builder: (context, ModelTheme themeNotifier, child) {
            print("main 2");
        // themeNotifier.isDark = false; // using to check dark theme
            Widget homeScreen;
            // print("First Time User status $isFirstTimeUser");
            if(isLoggedIn == false){
              print("Logged in status = $isLoggedIn");
              print("To Auth Screen");
              homeScreen = AuthScreen();
            }else {
              print("Logged in status = $isLoggedIn");
              print("To Main Screen");
              homeScreen = MainScreen();
            }
            print("main 3");
        return ScreenUtilInit(
          designSize: const Size(412, 892),//Never change this value
          child: MaterialApp(
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                ...context.localizationDelegates,
              ],
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              themeMode: themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              initialRoute: '/',
              routes: {
                '/': (context) => DeepLinkHandler(child: MainScreen()),
                '/main': (context) => MainScreen()
              }),
        );
      }),
    );
  }
}
