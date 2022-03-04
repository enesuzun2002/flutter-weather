import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/main.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:weather/widgets/weather_list_view.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  CustomWidgets cw = CustomWidgets();
  WeatherSharedPrefs wsf = WeatherSharedPrefs();
  @override
  Widget build(BuildContext context) {
    MyApp.selectedIndex = 0;
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          if (!MyApp.reload && !MyApp.isRunning) {
            MyApp.isRunning = true;
            Timer(const Duration(minutes: 3), () {
              MyApp.reload = true;
              MyApp.isRunning = false;
            });
          }
          if (MyApp.reload) {
            await refresh();
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                duration: const Duration(seconds: 1),
                content: Text(AppLocalizations.of(context)!.scfReload)));
            MyApp.reload = false;
            // Create a new timer after refreshing so that user don't have to wait 60 secs everytime they try to refresh.
            // Also add a guard so this only works if reload is false.
            if (!MyApp.reload && !MyApp.isRunning) {
              MyApp.isRunning = true;
              Timer(const Duration(minutes: 3), () {
                MyApp.reload = true;
                MyApp.isRunning = false;
              });
            }
          } else {
            if (!MyApp.isShown) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  duration: const Duration(seconds: 1),
                  content: Text(AppLocalizations.of(context)!.reloadWait)));
              MyApp.isShown = true;
              Timer(const Duration(seconds: 30), () {
                MyApp.isShown = false;
              });
            }
            setState(() {});
          }
        },
        child: const WeatherListView(),
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (MyApp.weatherList.isNotEmpty) {
            weatherRemoveAlert(context);
          }
        },
        child: const Icon(Icons.remove_circle_rounded),
      ),
    );
  }

  Future<dynamic> weatherRemoveAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text(AppLocalizations.of(context)!.removeConf),
              content: Text(
                  "${AppLocalizations.of(context)!.removeDesc} ${cw.fixCityName(MyApp.weatherList.last)}"),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.cancelB)),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      MyApp.weatherList.removeLast();
                      wsf.updateCities(
                          cw.weatherListCityNamesToList(MyApp.weatherList));
                      refresh();
                    },
                    child: Text(AppLocalizations.of(context)!.okB))
              ],
            ));
  }

  Future<void> refresh() async {
    final reloadProvider =
        Provider.of<ReloadWeatherData>(context, listen: false);
    await reloadProvider.weatherDataReload();
    setState(() {});
  }
}
