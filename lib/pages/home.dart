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
  @override
  void initState() {
    ReloadWeatherData.weatherDataReloadSharedPrefs();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomWidgets.getAppBar("Hava Durumu"),
      body: RefreshIndicator(
        onRefresh: () async {
          if (!MyApp.reload && !MyApp.isRunning) {
            MyApp.isRunning = true;
            Timer(const Duration(minutes: 3), () {
              print("You can reload now!");
              MyApp.reload = true;
              MyApp.isRunning = false;
            });
          }
          if (MyApp.reload) {
            await refresh();
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Weather data successfully reloaded!")));
            MyApp.reload = false;
            // Create a new timer after refreshing so that user don't have to wait 60 secs everytime they try to refresh.
            // Also add a guard so this only works if reload is false.
            if (!MyApp.reload && !MyApp.isRunning) {
              MyApp.isRunning = true;
              Timer(const Duration(minutes: 3), () {
                print("You can reload again!");
                MyApp.reload = true;
                MyApp.isRunning = false;
              });
            }
          } else {
            print(
                "Refresh called at ${DateTime.now().hour}:${DateTime.now().minute}:${DateTime.now().second} but it failed...");
            ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text(
                    "You have to wait atleast 3 minutes before reloading!")));
            setState(() {});
          }
        },
        child: Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListView.builder(
            itemCount: MyApp.weatherList.isEmpty ? 1 : MyApp.weatherList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  child: MyApp.weatherList.isEmpty
                      ? const GetWeather()
                      : CustomWidgets.getWeatherCard(
                          MyApp.weatherList.elementAt(index)),
                ),
              );
            },
          ),
        ),
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (MyApp.weatherList.isNotEmpty) {
            MyApp.weatherList.removeLast();
            WeatherSharedPrefs.updateCities(
                CustomWidgets.weatherListCityNamesToList(MyApp.weatherList));
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
