import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/weather_api_client.dart';
import 'package:weather/weather/weather_data.dart';
import 'package:weather/widgets/custom_widgets.dart';

class GetWeather extends StatelessWidget {
  const GetWeather({Key? key}) : super(key: key);

  static Future<WeatherData?> getData(String city) async {
    WeatherData weatherData = WeatherData();
    WeatherApiClient client = WeatherApiClient();
    weatherData = await client.getWeatherData(city);
    if (weatherData.cod == "404") {
      return MyApp.weatherList.last;
    } else {
      for (var element in MyApp.weatherList) {
        if (element.name == weatherData.name) {
          MyApp.weatherList.remove(element);
          MyApp.weatherList.add(weatherData);
          return weatherData;
        }
      }
      MyApp.weatherList.add(weatherData);
      return weatherData;
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getData("Gaziantep"),
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasData) {
          return Padding(
              padding: const EdgeInsets.only(top: 24.0),
              child: CustomWidgets.getWeatherCard(snapshot.data!));
        }
        return CustomWidgets.getProgressIndicatorCard();
      },
    );
  }
}
