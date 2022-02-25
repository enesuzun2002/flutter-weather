import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/weather/weather_data.dart';

class CustomWidgets {
  static Color getColor(WeatherData weatherData) {
    switch (weatherData.weather[0].main) {
      case "Clouds":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Thunderstorm":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Drizzle":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Rain":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Snow":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Atmosphere":
        return const Color.fromARGB(255, 153, 65, 6);
      case "Clear":
        return const Color.fromARGB(255, 0, 151, 161);
      default:
        return const Color.fromARGB(255, 153, 65, 6);
    }
  }

  static Icon buildNavIcon(IconData iconData, bool active) {
    return Icon(iconData,
        size: 20.0, color: Color(active ? 0xFF0001FC : 0xFF0A1034));
  }

  static Text getHeader() {
    return Text(
      " Hava Durumu",
      style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
    );
  }

  static Container getWeatherCard(WeatherData weatherData) {
    return Container(
      height: 150.0,
      width: double.infinity,
      decoration: BoxDecoration(
          color: CustomWidgets.getColor(weatherData),
          borderRadius: BorderRadius.circular(16.0)),
      child: Padding(
        padding: const EdgeInsets.all(28.0),
        child: getWeatherCardInfo(weatherData),
      ),
    );
  }

  static Container getProgressIndicatorCard() {
    return Container(
      height: 150.0,
      width: double.infinity,
      decoration: BoxDecoration(
          color: const Color.fromARGB(255, 153, 65, 6),
          borderRadius: BorderRadius.circular(16.0)),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  static String fixCityName(WeatherData weatherData) {
    String name = "";
    if (weatherData.name.toString().contains("Province")) {
      name = weatherData.name.toString().split(" ").first;
    } else {
      name = weatherData.name.toString();
    }
    return name;
  }

  static Row getWeatherCardInfo(WeatherData weatherData) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Text(
              " ${fixCityName(weatherData)}, ${weatherData.sys.country!}",
              style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                "${weatherData.main!.temp} C",
                style: const TextStyle(
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
          ],
        ),
        Image.network(
            "http://openweathermap.org/img/wn/${weatherData.weather[0].icon!}@2x.png"),
      ],
    );
  }
}
