import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:weather/theme/theme_constants.dart';
import 'package:weather/widgets/helper_widgets.dart';
import 'package:weather/services/prefs_helper.dart';

class ThemeSettingsDialog extends StatefulWidget {
  const ThemeSettingsDialog({Key? key}) : super(key: key);

  @override
  State<ThemeSettingsDialog> createState() => _ThemeSettingsDialogState();
}

class _ThemeSettingsDialogState extends State<ThemeSettingsDialog> {
  @override
  Widget build(BuildContext context) {
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
                        decoration: themeMode == ThemeMode.dark
                            ? hw.activeBox(context, true)
                            : hw.activeBox(context, false),
                        child: SimpleDialogOption(
                          onPressed: () {
                            PrefsHelper.theme = "dark";
                            PrefsHelper.updateValue(
                                PrefsHelper.keyTheme, "dark");
                            Get.changeThemeMode(ThemeMode.dark);
                            themeMode = ThemeMode.dark;
                            setState(() {});
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
                        decoration: themeMode == ThemeMode.light
                            ? hw.activeBox(context, true)
                            : hw.activeBox(context, false),
                        child: SimpleDialogOption(
                          onPressed: () {
                            PrefsHelper.theme = "light";
                            PrefsHelper.updateValue(
                                PrefsHelper.keyTheme, "light");
                            Get.changeThemeMode(ThemeMode.light);
                            themeMode = ThemeMode.light;
                            setState(() {});
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
                      PrefsHelper.theme = "system";
                      PrefsHelper.updateValue(PrefsHelper.keyTheme, "system");
                      Get.changeThemeMode(ThemeMode.system);
                      themeMode = ThemeMode.system;
                      setState(() {});
                    },
                    child: Container(
                      decoration: themeMode == ThemeMode.system
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
                themeMode == ThemeMode.system
                    ? Text(AppLocalizations.of(context)!.sysTheme,
                        style: Theme.of(context).textTheme.bodySmall)
                    : themeMode == ThemeMode.dark
                        ? Text(AppLocalizations.of(context)!.darkTheme,
                            style: Theme.of(context).textTheme.bodySmall)
                        : Text(AppLocalizations.of(context)!.lightTheme,
                            style: Theme.of(context).textTheme.bodySmall)
              ],
            ),
            Get.isDarkMode
                ? const Icon(Icons.dark_mode_outlined)
                : const Icon(Icons.light_mode_outlined)
          ],
        ));
  }
}
