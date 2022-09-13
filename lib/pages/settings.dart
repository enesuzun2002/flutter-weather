import 'package:flutter/material.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/dialog_widgets.dart';
import 'package:weather/widgets/helper_widgets.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  HelperWidgets hw = HelperWidgets();
  WeatherSharedPrefs wsf = WeatherSharedPrefs();
  DialogWidgets dw = DialogWidgets();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: dw.themeSettingsDialog(context),
          ),
          const SizedBox(height: 16.0),
          dw.apiKeyDialog(context),
          const SizedBox(height: 16.0),
          dw.unitSettingDialog(context),
        ],
      ),
    );
  }
}
