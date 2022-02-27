import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:weather/widgets/get_weather.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool reload = false;

  @override
  void initState() {
    ReloadWeatherData.weatherDataReloadSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0, left: 16.0, right: 16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            Timer(const Duration(seconds: 60), () {
              print("You can reload now!");
              reload = true;
            });
            if (reload) {
              await refresh();
              reload = false;
            } else {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "You have to wait atleast 60 seconds before reloading!")));
            }
          },
          child: ListView.builder(
            itemCount: MyApp.weatherList.isEmpty ? 1 : MyApp.weatherList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: MyApp.weatherList.isEmpty
                    ? const GetWeather()
                    : CustomWidgets.getWeatherCard(
                        MyApp.weatherList.elementAt(index)),
              );
            },
          ),
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (MyApp.weatherList.isNotEmpty) {
            MyApp.weatherList.removeLast();
            WeatherSharedPrefs.updateCities(
                CustomWidgets.weatherListCityNamesToList(MyApp.weatherList));
            Timer(const Duration(seconds: 60), () => reload = true);
            await refresh();
          }
        },
        child: const Icon(Icons.remove_circle_rounded),
      ),
    );
  }

  Future<void> refresh() async {
    await ReloadWeatherData.weatherDataReload();
    setState(() {});
  }
}
