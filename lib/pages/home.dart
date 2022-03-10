import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/variables.dart';
import 'package:weather/widgets/weather_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  WeatherSharedPrefs wsf = WeatherSharedPrefs();
  @override
  Widget build(BuildContext context) {
    Variables.selectedIndex = 0;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (!Variables.reload && !Variables.isRunning) {
            Variables.isRunning = true;
            Timer(const Duration(minutes: 3), () {
              Variables.reload = true;
              Variables.isRunning = false;
            });
          }
          if (Variables.reload) {
            await refresh();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                content: Text(AppLocalizations.of(context)!.scfReload)));
            Variables.reload = false;
            // Create a new timer after refreshing so that user don't have to wait 60 secs everytime they try to refresh.
            // Also add a guard so this only works if reload is false.
            if (!Variables.reload && !Variables.isRunning) {
              Variables.isRunning = true;
              Timer(const Duration(minutes: 3), () {
                Variables.reload = true;
                Variables.isRunning = false;
              });
            }
          } else {
            if (!Variables.isShown) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(AppLocalizations.of(context)!.reloadWait)));
              Variables.isShown = true;
              Timer(const Duration(seconds: 30), () {
                Variables.isShown = false;
              });
            }
            setState(() {});
          }
        },
        child: const WeatherListView(),
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
      ),
    );
  }

  Future<void> refresh() async {
    final reloadProvider =
        Provider.of<ReloadWeatherData>(context, listen: false);
    await reloadProvider.weatherDataReload();
    setState(() {});
  }
}
