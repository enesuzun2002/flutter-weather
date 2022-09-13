import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:weather/pages/main_page.dart';
import 'package:weather/services/reload_weather_data.dart';
import 'package:weather/services/prefs_helper.dart';
import 'package:weather/theme/theme_constants.dart';
import 'package:weather/theme/theme_manager.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(PrefsHelper.prefsBoxName).then((value) => PrefsHelper());

  runApp(MultiProvider(providers: [
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
    return MaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeProvider.themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      home: const MainPage(),
    );
  }
}
