import 'package:flutter/material.dart';
import 'package:weather/widgets/weather_list_view.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: WeatherListView(),
    );
  }
}
