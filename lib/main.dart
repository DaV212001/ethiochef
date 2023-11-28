import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/screens/auth/auth_screen.dart';
import 'package:ethio_chef/screens/main_screen.dart';
import 'package:ethio_chef/screens/splash_screen.dart';
import 'package:ethio_chef/services/authorization_service.dart';
import 'package:ethio_chef/theme/app_theme.dart';
import 'package:ethio_chef/theme/model_theme.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  await EasyLocalization.ensureInitialized();

  runApp(
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
        child: const EthioChef()),
  );
}

class EthioChef extends StatefulWidget {
  const EthioChef({super.key});

  @override
  State<EthioChef> createState() => _EthioChefState();
}

class _EthioChefState extends State<EthioChef> {
  bool isLoggedIn = false;
  void getUserStatus() async {
    bool status = await AuthService.isUserLoggedIn();
    print("Logged in status = $status");
    setState(() {
      isLoggedIn = status;
    });
  }
  @override
  void initState() {
    super.initState();
    _checkFirstTimeUser();
  }
  bool isFirstTimeUser = true;
  Future<void> _checkFirstTimeUser() async {
    print("Checking First TimeUser");
    final prefs = await SharedPreferences.getInstance();
    final hasLaunchedBefore = prefs.getBool('hasLaunchedEthioChefBefore') ?? false;
    if (hasLaunchedBefore) {
      setState(() {
        isFirstTimeUser = false;
      });
    } else {
      await prefs.setBool('hasLaunchedEthioChefBefore', true);
    }
  }
  Future<Widget> screenToStart() async {

    bool status = await AuthService.isUserLoggedIn();
    print("Logged in status = $status");
    setState(() {
      isLoggedIn = status;
    });
    return isLoggedIn ? MainScreen() : AuthScreen(isSignIn: true);
  }
  @override
  Widget build(BuildContext context) {
    Language.selectedLanguage = Language.getSelectedLanguage(context);

    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
          builder: (context, ModelTheme themeNotifier, child) {
        // themeNotifier.isDark = false; // using to check dark theme
            Widget homeScreen;
            print("First Time User status $isFirstTimeUser")
            if (isFirstTimeUser) {
              print("To SplashScreen $isFirstTimeUser");
              homeScreen = SplashScreen();
            } else {
              print("To SignupScreen $isFirstTimeUser");
              getUserStatus();
              homeScreen = isLoggedIn ? MainScreen() : AuthScreen(isSignIn: true);
            }
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
                '/': (context) => homeScreen,
                '/main': (context) => homeScreen
              }),
        );
      }),
    );
  }
}
