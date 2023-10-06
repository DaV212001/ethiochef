import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/screens/splash_screen.dart';
import 'package:ethio_chef/screens/main_screen.dart';
import 'package:ethio_chef/utils/theme/app_theme.dart';
import 'package:ethio_chef/utils/theme/model_theme.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await FastCachedImageConfig.init(clearCacheAfter: const Duration(days: 15));
  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
        supportedLocales: const [
          // needed to use these locales because om,ti and, sm where not supported
          Locale('en', 'AU'),
          Locale('en', 'CA'),
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
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Language.selectedLanguage = Language.getSelectedLanguage(context);

    return ChangeNotifierProvider(
      create: (_) => ModelTheme(),
      child: Consumer<ModelTheme>(
          builder: (context, ModelTheme themeNotifier, child) {
        themeNotifier.isDark = false; // using to check dark theme
        return MaterialApp(
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
              '/': (context) => const SplashScreen(),
              '/main': (context) => const MainScreen()
            });
      }),
    );
  }
}
