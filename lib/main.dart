import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:weather/pages/main_page.dart';
import 'package:weather/services/prefs_helper.dart';
import 'package:weather/theme/theme_constants.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox(PrefsHelper.prefsBoxName).then((value) => PrefsHelper());

  String theme = PrefsHelper.theme;
  if (theme == "dark") {
    themeMode = ThemeMode.dark;
  } else if (theme == "light") {
    themeMode = ThemeMode.light;
  } else {
    themeMode = ThemeMode.system;
  }

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      debugShowCheckedModeBanner: false,
      title: 'Weather',
      home: const MainPage(),
    );
  }
}
