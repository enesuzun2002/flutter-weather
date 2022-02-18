import 'package:flutter/material.dart';
import 'package:weather/search.dart';
import 'package:weather/services/weather_api_client.dart';
import 'package:weather/weather/weather_data.dart';
import 'package:weather/widgets/custom_widgets.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);

  WeatherData weatherData = WeatherData();
  WeatherApiClient client = WeatherApiClient();

  Future<void> getData(String city) async {
    weatherData = await client.getWeatherData(city);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FutureBuilder(
              future: getData(Search.city),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CustomWidgets.getHeader(),
                      Padding(
                          padding: const EdgeInsets.only(top: 24.0),
                          child: CustomWidgets.getWeatherCard(weatherData)),
                    ],
                  );
                }
                return CustomWidgets.getLoadingAnim();
              },
            ),
          ),
        ],
      ),
    );
  }
}
