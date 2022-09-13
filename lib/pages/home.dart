import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/widgets/weather_list_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WeatherListView(),
    );
  }

  void refresh() {
    final reloadProvider =
        Provider.of<ReloadWeatherData>(context, listen: false);
    reloadProvider.weatherDataReload();
    setState(() {});
  }
}
