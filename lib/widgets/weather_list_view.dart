import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/widgets/custom_widgets.dart';

class WeatherListView extends StatelessWidget {
  const WeatherListView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (MyApp.firstRun) {
      return FutureBuilder(
        future: ReloadWeatherData.weatherDataReloadSharedPrefs(),
        builder: (context, snapshot) {
          MyApp.firstRun = false;
          if (snapshot.connectionState == ConnectionState.done) {
            if (MyApp.weatherList.isEmpty) {
              return Center(
                child: Text("Try adding a city so i can show a card!"),
              );
            } else {
              return Padding(
                padding: const EdgeInsets.only(top: 16.0),
                child: ListView.separated(
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16.0),
                  itemCount: MyApp.weatherList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: CustomWidgets.getWeatherCard(
                          MyApp.weatherList.elementAt(index)),
                    );
                  },
                ),
              );
            }
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      );
    } else {
      if (MyApp.weatherList.isEmpty) {
        return Center(
          child: Text("Try adding a city so i can show a card!"),
        );
      } else {
        return Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox(height: 16.0),
            itemCount: MyApp.weatherList.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: CustomWidgets.getWeatherCard(
                    MyApp.weatherList.elementAt(index)),
              );
            },
          ),
        );
      }
    }
  }
}
