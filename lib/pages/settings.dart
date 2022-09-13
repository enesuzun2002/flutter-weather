import 'package:flutter/material.dart';
import 'package:weather/widgets/dialog/api.dart';
import 'package:weather/widgets/dialog/theme.dart';
import 'package:weather/widgets/dialog/unit.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: const [
          Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: ThemeSettingsDialog(),
          ),
          SizedBox(height: 16.0),
          ApiKeySettingsDialog(),
          SizedBox(height: 16.0),
          UnitSettingsDialog(),
        ],
      ),
    );
  }
}
