import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/screens/SplashScreen.dart';
import 'package:fast_cached_network_image/fast_cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
          Locale('en','GB'),
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
  Widget build(BuildContext context) {
    Language.selectedLanguage = Language.getSelectedLanguage(context);
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          ...context.localizationDelegates,
        ],
        supportedLocales: context.supportedLocales,
        locale: context.locale,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashScreen(),
          // '/main': (context) => const MainLayoutScreen()
        });
  }
}
