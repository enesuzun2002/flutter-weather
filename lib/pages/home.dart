import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:weather/widgets/nav_drawer.dart';
import 'package:weather/widgets/weather_list_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavDrawer(),
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
                duration: Duration(seconds: 1),
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
            if (!MyApp.isShown) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  duration: Duration(seconds: 1),
                  content: Text(
                      "You have to wait atleast 3 minutes before reloading!")));
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
            MyApp.weatherList.removeLast();
            WeatherSharedPrefs.updateCities(
                CustomWidgets.weatherListCityNamesToList(MyApp.weatherList));
            refresh();
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
