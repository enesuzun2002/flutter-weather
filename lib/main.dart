import 'package:flutter/material.dart';
import 'package:weather/pages/account.dart';
import 'package:weather/pages/home.dart';
import 'package:weather/pages/search.dart';
import 'package:weather/pages/settings.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  static List<dynamic> weatherList = <dynamic>[];
  static bool reload = false;
  static bool isRunning = false;

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
  int pageIndex = 3;

  final pages = [
    const Home(),
    Search(),
    const Settings(),
    const Account(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // drawer: const NavDrawer(),
      body: pages[pageIndex],
      bottomNavigationBar: getBottomNavBar(),
    );
  }

  Container getBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      decoration: BoxDecoration(
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
          IconButton(
              onPressed: () {
                setState(() {
                  pageIndex = 3;
                });
              },
              icon: CustomWidgets.buildNavIcon(
                  Icons.person, pageIndex == 3 ? true : false)),
        ],
      ),
    );
  }
}
