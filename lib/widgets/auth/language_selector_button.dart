import 'dart:async';

import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/theme/model_theme.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar_v2/persistent-tab-view.dart';
import 'package:provider/provider.dart';

import '../../main.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/main_screen.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:restart_app/restart_app.dart';

class LanguageSelectorButton extends StatefulWidget {
  const LanguageSelectorButton({Key? key});

  @override
  State<LanguageSelectorButton> createState() => _LanguageSelectorButtonState();
}

class _LanguageSelectorButtonState extends State<LanguageSelectorButton> {
  late Timer timer;
  late bool changed = false;
  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    ModelTheme lang = Provider.of<ModelTheme>(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton2(
        customButton: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            children: [
              SvgIcon(
                image: Assets.iconsLanguage,
                color: Theme.of(context).colorScheme.secondaryContainer,
              )
            ],
          ),
        ),
        items: [
          ...Language.languages.map(
            (item) => DropdownMenuItem<Language>(
              value: item,
              child: Text(
                item.name,
                style: theme.textTheme.headlineMedium
                    ?.copyWith(color: theme.colorScheme.tertiary),
              ),
            ),
          ),
        ],
        onChanged: (value) {

          setState(() {
            Language.selectedLanguage = value!;
            context.setLocale(value.code);
            lang.languageCode = value.code.countryCode??value.code.languageCode;
            print(lang.languageCode);
            print(Language.selectedLanguage.name);
            changed = true;
          });
          RestartWidget.restartApp(context);
          // Navigator.of(context).popUntil((route) => route.settings.name == '/home');
          // Restart.restartApp();
          // Navigator.pushReplacement(context,
          //     MaterialPageRoute(
          //         builder: (BuildContext context)=>MainScreen())
          // );
          // pushNewScreenWithRouteSettings(context,
          //   screen: HomeScreen(),
          //   settings: RouteSettings(name: '/home'),
          //   withNavBar: true
          // );
          // Navigator.of(context).pushAndRemoveUntil(
          //   MaterialPageRoute(builder: (context) => EthioChef()),
          //       (route) => false, // Clears all previous routes
          // );


          // pushNewScreen(context, screen: HomeScreen(), withNavBar: true, );


        },
        dropdownStyleData: DropdownStyleData(
          width: 160,
          padding: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4),
            color: Theme.of(context).colorScheme.surface,
          ),
          offset: const Offset(0, 8),
        ),
        menuItemStyleData: MenuItemStyleData(
          customHeights: List<double>.filled(Language.languages.length, 48),
          padding: const EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }
}
