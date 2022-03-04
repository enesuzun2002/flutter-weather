import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/theme/theme_manager.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:weather/widgets/nav_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  CustomWidgets cw = CustomWidgets();
  WeatherSharedPrefs wsf = WeatherSharedPrefs();

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeManager>(context, listen: true);
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: cw.getAppBar(AppLocalizations.of(context)!.settings),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: TextButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return SimpleDialog(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.0)),
                        title: Text(AppLocalizations.of(context)!.themeS),
                        children: [
                          SimpleDialogOption(
                            onPressed: () {
                              wsf.updateTheme('system');
                              provider.toogleTheme(ThemeMode.system);
                              Navigator.pop(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 5.0),
                                Text(AppLocalizations.of(context)!.sysTheme),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              wsf.updateTheme('dark');
                              provider.toogleTheme(ThemeMode.dark);
                              Navigator.pop(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocalizations.of(context)!
                                        .darkTheme),
                                    const Icon(Icons.dark_mode_outlined)
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                              ],
                            ),
                          ),
                          SimpleDialogOption(
                            onPressed: () {
                              wsf.updateTheme('light');
                              provider.toogleTheme(ThemeMode.light);
                              Navigator.pop(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(AppLocalizations.of(context)!
                                        .lightTheme),
                                    const Icon(Icons.light_mode_outlined),
                                  ],
                                ),
                                const SizedBox(height: 16.0),
                              ],
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
                        provider.themeMode == ThemeMode.system
                            ? Text(AppLocalizations.of(context)!.sysTheme,
                                style: Theme.of(context).textTheme.bodySmall)
                            : provider.themeMode == ThemeMode.dark
                                ? Text(AppLocalizations.of(context)!.darkTheme,
                                    style:
                                        Theme.of(context).textTheme.bodySmall)
                                : Text(AppLocalizations.of(context)!.lightTheme,
                                    style:
                                        Theme.of(context).textTheme.bodySmall)
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
                )),
          ),
        ],
      ),
    );
  }
}
