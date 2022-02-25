import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:weather/home.dart';
import 'package:weather/search.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/settings.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:weather/widgets/nav_drawer.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static List<dynamic> weatherList = <dynamic>[];

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int pageIndex = 0;

  final pages = [
    const Home(),
    Search(),
    const Settings(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: CustomWidgets.getHeader(),
        ),
        drawer: NavDrawer(),
        bottomNavigationBar: getBottomNavBar(),
        body: pages[pageIndex]);
  }

  Container getBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
          /* boxShadow: [
                BoxShadow(
                    offset: Offset(0, -2),
                    color: Colors.black.withOpacity(0.25),
                    blurRadius: 10.0)
              ], */
          borderRadius: BorderRadius.circular(16.0),
          color: const Color.fromARGB(255, 215, 232, 250)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  pageIndex = 0;
                });
              },
              icon: CustomWidgets.buildNavIcon(
                  Icons.home_filled, pageIndex == 0 ? true : false)),
          IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 1;
                });
              },
              icon: CustomWidgets.buildNavIcon(
                  Icons.search, pageIndex == 1 ? true : false)),
          IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 2;
                });
              },
              icon: CustomWidgets.buildNavIcon(
                  Icons.settings, pageIndex == 2 ? true : false)),
        ],
      ),
    );
  }
}
