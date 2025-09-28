// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'package:app_links/app_links.dart';
import 'package:appmetrica_plugin/appmetrica_plugin.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/deeplink/deep_link_handler.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/screens/main_screen.dart';
import 'package:ethio_chef/services/firsebase_service.dart';
import 'package:ethio_chef/services/scheduled_notification_service.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/theme/model_theme.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:play_install_referrer/play_install_referrer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import 'firebase_options.dart';

Future<void> requestAlarmPermission() async {
  var status = await Permission.scheduleExactAlarm.status;
  print('STATTUUSSSS: $status');
  if (!status.isGranted) {
    await Permission.scheduleExactAlarm.request();
  }
}

// Schedule periodic notifications
Future<void> _setupPeriodicNotifications() async {
  // bool scheduled = await AndroidAlarmManager.periodic(
  //   const Duration(seconds: 1),
  //     52, // ID for the alarm
  //     await tester,
  //     exact: true,
  //     wakeup: true,
  //     rescheduleOnReboot: true,
  //     startAt: DateTime.now()
  // );
  // if(scheduled){
  //   print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Scheduled notifications');}
  // else{
  //   print('>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>Failed to schedule notifications');
  // }
}

Future<void> tester() async {
  print(
      '=============================================================================TESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSTTTTTTTTTTTTTTTTTTTTTTTTT================================================876897============================');
  await NotificationScheduled.scheduleNotifications();
  print(
      '=============================================================================COMPLETTTTTTTTTTTTTTTTTTTTTTTTETTTTTTTTTTTTTTTTTTTTTTTTTTTTETTTTTTTTTTTTTTTTTTTTTTTT================================================876897============================');
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      SystemUiOverlayStyle(statusBarColor: AppTheme.primaryColor));
  WidgetsFlutterBinding.ensureInitialized();

  ReferrerDetails referrerDetails = await PlayInstallReferrer.installReferrer;
  print('INSTALL REFERRER URL FETCHED: ${referrerDetails.installReferrer}');
  AppMetrica.activate(
      AppMetricaConfig("38bec3c7-b6e6-45f1-aba3-274f1d8d4110", logs: true));
  AppMetrica.reportReferralUrl(referrerDetails.installReferrer ??
      'Unknown Referrer: Google Play Services is not installed/enabled in user\'s device');
  print(
      "==========================MobileAds.instance.initialize()====================================");
  await MobileAds.instance.initialize();
  print(
      "=========================MobileAds.instance.initialize()=====================================");
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  // await AndroidAlarmManager.initialize();
  await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final appLinks = AppLinks(); // AppLinks is singleton
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(
        AndroidNotificationChannel(
          'channel id',
          'channel name',
          importance: Importance.max,
        ),
      );
  if (navigatorKey.currentContext != null) {
    print('CONTEXT NOT NULL');
  } else {
    print('CONTEXT NULL');
  }

  tz.initializeTimeZones();

  await requestAlarmPermission();
  await _setupPeriodicNotifications();

  runApp(Phoenix(
      child:
          //DevicePreview(
          //     enabled: !kReleaseMode,
          //     builder: (context) =>
          EasyLocalization(
              supportedLocales: const [
        // needed to use these locales because om,ti  where not supported
        Locale('en', 'AU'), //tigrigna
        Locale('am'), //amharic
        Locale('en', 'GB'), //oromiffa
        Locale('es'), //somali
        Locale('en'), //english
      ],
              path: 'assets/locale',
              startLocale: Locale('en'),
              fallbackLocale: const Locale('en'),
              child: RestartWidget(child: EthioChef()))
      // ),
      ));
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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool? isF = prefs.getBool('isF') ?? true;
    if (isF) {
      print('FIRST TIME USER');
      // await Offer18Plugin.trackConversion(Offer18EventArguments.INSTALL);
      // await AppMetrica.reportEvent('Install');
      prefs.setBool('isF', false);
    }

    print("check login status");
    if (navigatorKey.currentContext != null) {
      print('CONTEXT NOT NULL');
    } else {
      print('CONTEXT NULL');
    }
    await FirebaseService().checkTokenRegistration();
  }

  @override
  Widget build(BuildContext context) {
    Language.selectedLanguage = Language.getSelectedLanguage(context);
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ModelTheme())],
      child: Consumer<ModelTheme>(
          builder: (context, ModelTheme themeNotifier, child) {
        // themeNotifier.isDark = false; // using to check dark theme
        Widget homeScreen;
        // print("First Time User status $isFirstTimeUser");
        if (isLoggedIn == false) {
          print("To Auth Screen");
          homeScreen = AuthScreen();
        } else {
          print("To Main Screen");
          homeScreen = MainScreen();
        }
        return ScreenUtilInit(
          designSize: const Size(412, 892), //Never change this value
          child: GetMaterialApp(
              navigatorKey: navigatorKey,
              localizationsDelegates: [
                GlobalMaterialLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                ...context.localizationDelegates,
              ],
              supportedLocales: context.supportedLocales,
              locale: context.locale,
              themeMode:
                  themeNotifier.isDark ? ThemeMode.dark : ThemeMode.light,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              initialRoute: '/',
              routes: {
                '/': (context) => DeepLinkHandler(child: MainScreen()),
                '/main': (context) => MainScreen(),
              }),
        );
      }),
    );
  }
}
