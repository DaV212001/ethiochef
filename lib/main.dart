// import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
// import 'package:get/get.dart';
import 'package:ethiochef/config/storage_config.dart';
import 'package:ethiochef/controllers/ad_visibility_controller.dart';
import 'package:ethiochef/translations/app_translations.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest_all.dart' as tz;

import '../deeplink/deep_link_handler.dart';
import '../models/language.dart';
import '../screens/auth/auth_screen.dart';
import '../screens/main_screen.dart';
import '../services/firsebase_service.dart';
import '../services/scheduled_notification_service.dart';
import '../theme/app_theme.dart';
import '../theme/model_theme.dart';
import 'services/ad_service.dart';
import 'controllers/theme_mode_controller.dart';
import 'firebase_options.dart';

Future<void> requestAlarmPermission() async {
  if (kIsWeb || defaultTargetPlatform != TargetPlatform.android) {
    return;
  }
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
    '=============================================================================TESSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSSTTTTTTTTTTTTTTTTTTTTTTTTT================================================876897============================',
  );
  await NotificationScheduled.scheduleNotifications();
  print(
    '=============================================================================COMPLETTTTTTTTTTTTTTTTTTTTTTTTETTTTTTTTTTTTTTTTTTTTTTTTTTTTETTTTTTTTTTTTTTTTTTTTTTTT================================================876897============================',
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey();
void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(statusBarColor: AppTheme.primaryColor),
  );
  WidgetsFlutterBinding.ensureInitialized();
  // Offer18Plugin.initSDK('na.o18.click', '459', 'ethiochef-tid');
  // Offer18Plugin.getReferrerInstallUrl();
  print(
    "==========================MobileAds.instance.initialize()====================================",
  );
  MobileAds.instance.initialize();
  await AdService.loadCachedAdUnits();
  print(
    "=========================MobileAds.instance.initialize()=====================================",
  );
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  // await AndroidAlarmManager.initialize();
  // await EasyLocalization.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin
      >()
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
  await GetStorage.init(); //
  await ConfigPreference.init();
  // VisitorService.trackVisit();
  runApp(
    Phoenix(
      child:
          //DevicePreview(
          //     enabled: !kReleaseMode,
          //     builder: (context) =>
          // EasyLocalization(
          //   supportedLocales: const [
          //     // needed to use these locales because om,ti  where not supported
          //     Locale('en', 'AU'),
          //     Locale('am'),
          //     Locale('en', 'GB'),
          //     Locale('en'),
          //   ],
          //   path: 'assets/locale',
          //   startLocale: Locale('en'),
          //   fallbackLocale: const Locale('en'),
          //   child:
          RestartWidget(
            child: EthioChef(),
            // ),
          ),
      // ),
    ),
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
    return KeyedSubtree(key: key, child: widget.child);
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
    Get.put(AdService());
    Get.put(AdVisibilityController());
    Get.put(ThemeModeController(context));
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
              debugShowCheckedModeBanner: false,
              navigatorKey: navigatorKey,
              // navigatorObservers: [AdRouteObserver()],
              // localizationsDelegates: [
              //   GlobalMaterialLocalizations.delegate,
              //   GlobalCupertinoLocalizations.delegate,
              //   GlobalWidgetsLocalizations.delegate,
              //   ...context.localizationDelegates,
              // ],
              // supportedLocales: context.supportedLocales,
              locale: ThemeModeController.getLocale(),
              themeMode: themeNotifier.isDark
                  ? ThemeMode.dark
                  : ThemeMode.light,
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              translations: AppTranslations(),
              initialRoute: '/',
              routes: {
                '/': (context) => DeepLinkHandler(child: MainScreen()),
                '/main': (context) => MainScreen(),
              },
            ),
          );
        },
      ),
    );
  }
}
