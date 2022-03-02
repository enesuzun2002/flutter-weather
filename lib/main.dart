import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/about.dart';
import 'package:weather/pages/account.dart';
import 'package:weather/pages/home.dart';
import 'package:weather/pages/profile.dart';
import 'package:weather/pages/search.dart';
import 'package:weather/pages/settings.dart';
import 'package:weather/services/firebase_funcs_provider.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:weather/widgets/nav_drawer.dart';

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
  static bool isShown = false;
  static int selectedDestination = 0;
  static bool firstRun = true;

  static final StreamController<int> controller =
      StreamController<int>.broadcast();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) {
        return FirebaseFuncsProvider();
      },
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Weather',
        home: MainPage(),
      ),
    );
  }
}

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  static final StreamController<int> controller =
      StreamController<int>.broadcast();

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final Stream<int> stream = MainPage.controller.stream;

  int pageIndex = 1;

  @override
  void initState() {
    stream.listen((event) {
      pageIndex = event;
      setState(() {});
    });
    super.initState();
  }

  final pages = [
    const MyHomePage(),
    const Account(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              pageIndex = 0;
              return pages[pageIndex];
            } else if (snapshot.hasError) {
              return Center(child: Text("Something went wrong!"));
            } else {
              pageIndex = 1;
              return pages[pageIndex];
            }
          }),
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

  final Stream<int> stream = MyApp.controller.stream;

  final pages = [
    const Home(),
    Search(),
    const Settings(),
    const Profile(),
    const About(),
  ];

  @override
  void initState() {
    stream.listen((pageIndexS) {
      setState(() {
        pageIndex = pageIndexS;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (pageIndex == 2) {
      return Scaffold(
        body: pages[pageIndex],
      );
    } else {
      return Scaffold(
        body: pages[pageIndex],
        bottomNavigationBar: getBottomNavBar(),
      );
    }
  }

  Container getBottomNavBar() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      width: double.infinity,
      decoration:
          BoxDecoration(color: const Color.fromARGB(255, 215, 232, 250)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
              enableFeedback: false,
              onPressed: () {
                setState(() {
                  MyApp.controller.add(0);
                  pageIndex = 0;
                });
              },
              icon: CustomWidgets.buildNavIcon(
                  Icons.home_filled, pageIndex == 0 ? true : false)),
          IconButton(
              onPressed: () {
                setState(() {
                  MyApp.controller.add(1);
                  pageIndex = 1;
                });
              },
              icon: CustomWidgets.buildNavIcon(
                  Icons.search, pageIndex == 1 ? true : false)),
          IconButton(
              onPressed: () {
                setState(() {
                  MyApp.controller.add(3);
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
