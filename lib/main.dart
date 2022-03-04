import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/account.dart';
import 'package:weather/pages/home.dart';
import 'package:weather/pages/search.dart';
import 'package:weather/services/firebase_funcs_provider.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/theme/theme_constants.dart';
import 'package:weather/theme/theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:weather/widgets/nav_drawer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => FirebaseFuncsProvider()),
    ChangeNotifierProvider(create: (_) => ThemeManager()),
    ChangeNotifierProvider(create: (_) => ReloadWeatherData()),
  ], child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  static List<dynamic> weatherList = <dynamic>[];
  static bool reload = false;
  static bool isRunning = false;
  static bool isShown = false;
  static bool firstRun = true;
  static bool firstInstall = true;
  static int? selectedIndex;

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() async {
    WeatherSharedPrefs wsf = WeatherSharedPrefs();
    MyApp.firstInstall = await wsf.getFirstInstall();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeManager>(context, listen: true);
    themeProvider.getUserTheme();
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      title: 'Weather',
      home: const MainPage(),
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
      resizeToAvoidBottomInset: false,
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasData) {
              pageIndex = 0;
              return pages[pageIndex];
            } else if (snapshot.hasError) {
              return Center(child: Text(AppLocalizations.of(context)!.spErr));
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

  CustomWidgets cw = CustomWidgets();

  final pages = [
    const Home(),
    Search(),
  ];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: cw.getAppBar(pageIndex == 0
          ? AppLocalizations.of(context)!.weather
          : AppLocalizations.of(context)!.addNewCity),
      drawer: const NavDrawer(),
      body: pages[pageIndex],
      bottomNavigationBar: NavigationBar(
        height: 70.0,
        selectedIndex: pageIndex,
        onDestinationSelected: (index) {
          setState(() {
            pageIndex = index;
          });
        },
        destinations: [
          NavigationDestination(
              icon: const Icon(Icons.home),
              label: AppLocalizations.of(context)!.home),
          NavigationDestination(
              icon: const Icon(Icons.search),
              label: AppLocalizations.of(context)!.search),
        ],
      ),
    );
  }
}
