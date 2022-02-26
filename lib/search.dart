import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:weather/widgets/get_weather.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);
  static String city = "";

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              TextField(
                decoration: const InputDecoration(
                  hintText: "Şehir Adı...",
                  icon: Icon(Icons.search),
                ),
                controller: textEditingController,
                onSubmitted: (value) {
                  setState(() {
                    if (value != "") {
                      GetWeather.getData(value);
                      textEditingController.clear();
                      WeatherSharedPrefs.updateCities(
                          CustomWidgets.weatherListCityNamesToList(
                              MyApp.weatherList));
                    }
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
