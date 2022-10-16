import 'package:hive/hive.dart';

class PrefsHelper {
  static const String keyCities = "cities";

  static const String keyTheme = "theme";

  static const String keyFirstInstall = "firstInstall";

  static const String keyApiKey = "apiKey";

  static const String keyUnitS = "unitS";

  static const String prefsBoxName = "prefs";
  static Box prefsBox = Hive.box(prefsBoxName);

  static List<String> cities = [];
  static List weatherDataList = [];
  static String theme = "";
  static String apiKey = "";
  static String unitS = "";
  static bool isRunning = false;
  static bool reload = true;
  static bool isShown = false;

  PrefsHelper() {
    getData();
  }

  void getData() async {
    apiKey = getValue(keyApiKey) ?? "";
    theme = getValue(keyTheme) ?? "system";
    cities = getValue(keyCities) ?? [];
    unitS = getValue(unitS) ?? "metric";
  }

  static void updateValue(String key, dynamic value) {
    prefsBox.put(key, value);
  }

  static dynamic getValue(String key) {
    return prefsBox.get(key);
  }
}
