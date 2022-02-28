import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/widgets/custom_widgets.dart';

class Settings extends StatefulWidget {
  const Settings({Key? key}) : super(key: key);

  @override
  State<Settings> createState() => _SettingsState();
}

class _SettingsState extends State<Settings> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.getAppBar("Ayarlar"),
      body: SafeArea(child: Stack(children: const [])),
    );
  }
}
