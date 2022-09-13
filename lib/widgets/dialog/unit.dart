import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather/services/reload_weather_data.dart';

import '../../services/weather_shared_prefs.dart';
import '../../variables.dart';
import '../helper_widgets.dart';

class UnitSettingsDialog extends StatelessWidget {
  const UnitSettingsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    WeatherSharedPrefs wsf = WeatherSharedPrefs();
    HelperWidgets hw = HelperWidgets();
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
}
