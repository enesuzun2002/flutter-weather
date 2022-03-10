import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/main_page.dart';
import 'package:weather/services/firebase_funcs_provider.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/theme/theme_constants.dart';
import 'package:weather/theme/theme_manager.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeManager>(context, listen: true);
    themeProvider.getUserTheme();
    final reloadWeatherDataProvider =
        Provider.of<ReloadWeatherData>(context, listen: true);
    reloadWeatherDataProvider.weatherUnitSReload();
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
