import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: cw.getAppBar(AppLocalizations.of(context)!.settings),
      body: SafeArea(child: Stack(children: const [])),
    );
  }
}
