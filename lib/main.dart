import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:weather/services/weather_api_client.dart';
import 'package:weather/weather/weather_data.dart';
import 'package:loading_animations/loading_animations.dart';

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

  Future<void> getData() async {
    weatherData = await client.getWeatherData("Gaziantep");
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: FutureBuilder(
        future: getData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return Column(
              children: <Widget>[
                Text(weatherData.name!),
                Text("${weatherData.main!.tempMax}"),
                Icon(
                  CupertinoIcons.cloud_sun,
                  size: 100.0,
                ),
              ],
            );
          }
          return Center(
            child: Container(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    LoadingBouncingGrid.circle(
                      size: 60,
                      backgroundColor: Colors.amber,
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 16.0),
                      child: const Text(
                        'Fetching Weather Data',
                        style: TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ]),
            ),
          );
        },
      )),
    );
  }
}
