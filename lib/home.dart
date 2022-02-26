import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:weather/widgets/get_weather.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);
  static bool reload = false;

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
      body: Padding(
        padding: const EdgeInsets.only(top: 18.0, left: 16.0, right: 16.0),
        child: RefreshIndicator(
          onRefresh: () async {
            await refresh();
          },
          child: ListView.builder(
            itemCount: MyApp.weatherList.isEmpty ? 1 : MyApp.weatherList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: MyApp.weatherList.isEmpty
                    ? GetWeather()
                    : CustomWidgets.getWeatherCard(
                        MyApp.weatherList.elementAt(index)),
              );
            },
          ),
          triggerMode: RefreshIndicatorTriggerMode.anywhere,
        ),
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
        child: Icon(Icons.remove_circle_rounded),
      ),
    );
  }

  Future<void> refresh() async {
    await ReloadWeatherData.weatherDataReload();
    setState(() {});
  }
}
