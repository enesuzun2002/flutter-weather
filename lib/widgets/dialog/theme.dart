import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../theme/theme_manager.dart';
import 'package:weather/widgets/helper_widgets.dart';
import 'package:weather/services/weather_prefs_helper.dart';

class ThemeSettingsDialog extends StatelessWidget {
  const ThemeSettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeManager>(context, listen: true);
    // TODO: Get rid of this
    HelperWidgets hw = HelperWidgets();
    return TextButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding:
                    const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                title: Text(AppLocalizations.of(context)!.themeS),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: provider.themeMode == ThemeMode.dark
                            ? hw.activeBox(context, true)
                            : hw.activeBox(context, false),
                        child: SimpleDialogOption(
                          onPressed: () {
                            PrefsHelper.theme = "dark";
                            PrefsHelper.updateValue(
                                PrefsHelper.keyTheme, "dark");
                            provider.toogleTheme(ThemeMode.dark);
                          },
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(AppLocalizations.of(context)!.darkTheme),
                                  const SizedBox(height: 10.0),
                                  const Icon(Icons.dark_mode_outlined)
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: provider.themeMode == ThemeMode.light
                            ? hw.activeBox(context, true)
                            : hw.activeBox(context, false),
                        child: SimpleDialogOption(
                          onPressed: () {
                            PrefsHelper.theme = "light";
                            PrefsHelper.updateValue(
                                PrefsHelper.keyTheme, "light");
                            provider.toogleTheme(ThemeMode.light);
                          },
                          child: Column(
                            children: [
                              Text(AppLocalizations.of(context)!.lightTheme),
                              const SizedBox(height: 10.0),
                              const Icon(Icons.light_mode_outlined),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  SimpleDialogOption(
                    onPressed: () {
                      PrefsHelper.updateValue(PrefsHelper.keyTheme, "system");
                      provider.toogleTheme(ThemeMode.system);
                    },
                    child: Container(
                      decoration: provider.themeMode == ThemeMode.system
                          ? hw.activeBox(context, true)
                          : hw.activeBox(context, false),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const SizedBox(height: 16.0),
                          Text(AppLocalizations.of(context)!.sysTheme),
                          const SizedBox(height: 16.0),
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.themeS,
                    style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(height: 5.0),
                provider.themeMode == ThemeMode.system
                    ? Text(AppLocalizations.of(context)!.sysTheme,
                        style: Theme.of(context).textTheme.bodySmall)
                    : provider.themeMode == ThemeMode.dark
                        ? Text(AppLocalizations.of(context)!.darkTheme,
                            style: Theme.of(context).textTheme.bodySmall)
                        : Text(AppLocalizations.of(context)!.lightTheme,
                            style: Theme.of(context).textTheme.bodySmall)
              ],
            ),
            provider.themeMode == ThemeMode.system
                ? provider.getSystemThemeMode(context)
                    ? const Icon(Icons.dark_mode_outlined)
                    : const Icon(Icons.light_mode_outlined)
                : provider.themeMode == ThemeMode.dark
                    ? const Icon(Icons.dark_mode_outlined)
                    : const Icon(Icons.light_mode_outlined),
          ],
        ));
  }
}
