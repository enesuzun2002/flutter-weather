import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/theme/theme_manager.dart';
import 'package:weather/variables.dart';
import 'package:weather/widgets/helper_widgets.dart';

class DialogWidgets {
  HelperWidgets hw = HelperWidgets();
  WeatherSharedPrefs wsf = WeatherSharedPrefs();
  // Alert Dialogs
  Future<dynamic> invalidApiKeyAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text(AppLocalizations.of(context)!.apiKeyInvalidD),
              content: Text(AppLocalizations.of(context)!.apiKeyInvalidS),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.okB))
              ],
            ));
  }

  Future<dynamic> invalidLocationAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text(AppLocalizations.of(context)!.locationInvalidD),
              content: Text(AppLocalizations.of(context)!.locationInvalidS),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.okB))
              ],
            ));
  }

  Future<dynamic> apiKeyAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text(AppLocalizations.of(context)!.apiKeyAlertT),
              content: Text(AppLocalizations.of(context)!.apiKeyAlertD),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.okB))
              ],
            ));
  }

  Future<dynamic> firstInstallAlert(BuildContext context, String title) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text(title),
              content: Text(AppLocalizations.of(context)!.firstLaunchAlert),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.okB))
              ],
            ));
  }

  // Settings Dialogs
  Padding apiKeyDialog(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    final TextEditingController apiKeyEditingController =
        TextEditingController();
    String apiKey = "";
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            onPressed: () async {
              apiKeyEditingController.text = await wsf.getApiKey();
              showDialog(
                context: context,
                builder: (context) {
                  return SimpleDialog(
                    contentPadding:
                        const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0)),
                    title: Text(AppLocalizations.of(context)!.apiKeySH),
                    children: [
                      Form(
                          key: formKey,
                          child: Column(
                            children: [
                              Text(
                                AppLocalizations.of(context)!.apiKeyHelp,
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                              const SizedBox(height: 8.0),
                              TextFormField(
                                autovalidateMode: AutovalidateMode.disabled,
                                decoration: InputDecoration(
                                  border: const UnderlineInputBorder(),
                                  filled: false,
                                  label: Text(
                                      AppLocalizations.of(context)!.apiKeyHint),
                                ),
                                autocorrect: false,
                                enableSuggestions: false,
                                controller: apiKeyEditingController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return AppLocalizations.of(context)!
                                        .apiKeyEmpty;
                                  } else if (value.length != 32) {
                                    return AppLocalizations.of(context)!
                                        .apiKeyInvalid;
                                  }
                                  return null;
                                },
                                onChanged: (value) => apiKey = value,
                              ),
                            ],
                          )),
                      TextButton(
                        onPressed: () {
                          if (formKey.currentState!.validate()) {
                            wsf.updateApiKey(apiKey);
                            Navigator.pop(context);
                          }
                        },
                        child: Text(AppLocalizations.of(context)!.okB),
                      )
                    ],
                  );
                },
              );
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(AppLocalizations.of(context)!.apiKeySH,
                        style: Theme.of(context).textTheme.subtitle1),
                    const SizedBox(height: 5.0),
                    Text(AppLocalizations.of(context)!.apiKeySD,
                        style: Theme.of(context).textTheme.bodySmall),
                  ],
                ),
                const Icon(Icons.api_outlined),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Padding unitSettingDialog(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: TextButton(
        onPressed: () async {
          showDialog(
            context: context,
            builder: (context) {
              return SimpleDialog(
                contentPadding:
                    const EdgeInsets.fromLTRB(16.0, 20.0, 16.0, 16.0),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)),
                title: Text(AppLocalizations.of(context)!.unitSH),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        decoration: Variables.unitS == "metric"
                            ? hw.activeBox(context, true)
                            : hw.activeBox(context, false),
                        child: SimpleDialogOption(
                          onPressed: () {
                            wsf.updateUnitS("metric");
                            Variables.unitS = "metric";
                          },
                          child: Row(
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  const SizedBox(height: 16.0),
                                  Text(AppLocalizations.of(context)!.metricB),
                                  const SizedBox(height: 16.0),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        decoration: Variables.unitS == "imperial"
                            ? hw.activeBox(context, true)
                            : hw.activeBox(context, false),
                        child: SimpleDialogOption(
                          onPressed: () {
                            wsf.updateUnitS("imperial");
                            Variables.unitS = "imperial";
                          },
                          child: Column(
                            children: [
                              const SizedBox(height: 16.0),
                              Text(AppLocalizations.of(context)!.imperialB),
                              const SizedBox(height: 16.0),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(AppLocalizations.of(context)!.unitSH,
                    style: Theme.of(context).textTheme.subtitle1),
                const SizedBox(height: 5.0),
                Variables.unitS == "metric"
                    ? Text(AppLocalizations.of(context)!.metricD,
                        style: Theme.of(context).textTheme.bodySmall)
                    : Text(AppLocalizations.of(context)!.imperialD,
                        style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            Container()
          ],
        ),
      ),
    );
  }

  TextButton themeSettingsDialog(BuildContext context) {
    final provider = Provider.of<ThemeManager>(context, listen: true);
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
                            wsf.updateTheme('dark');
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
                            wsf.updateTheme('light');
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
                      wsf.updateTheme('system');
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
