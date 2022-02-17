import 'package:flutter/material.dart';
import 'package:weather/services/weather_api_client.dart';
import 'package:weather/weather/weather_data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      home: MyHomePage(title: 'Weather'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  WeatherData weatherData = WeatherData();
  WeatherApiClient client = WeatherApiClient();
  @override
  void initState() {
    super.initState();
    client.getWeatherData("Gaziantep").then((value) {
      setState(() {
        weatherData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(weatherData.name!),
            Text("${weatherData.main!.tempMax}"),
          ],
        ),
      ),
    );
  }
}
