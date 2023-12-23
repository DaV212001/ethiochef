import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:ethio_chef/generated/assets.dart';
import 'package:ethio_chef/models/language.dart';
import 'package:ethio_chef/theme/model_theme.dart';
import 'package:ethio_chef/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LanguageSelectorButton extends StatefulWidget {
  const LanguageSelectorButton({Key? key});

  @override
  State<LanguageSelectorButton> createState() => _LanguageSelectorButtonState();
}

class _LanguageSelectorButtonState extends State<LanguageSelectorButton> {
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
            lang.languageCode = value.code.languageCode;
            print(Language.selectedLanguage.name);
          });
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
