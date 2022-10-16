import 'package:get/get.dart';
import 'package:weather/services/prefs_helper.dart';

class ReloadWeatherDataController extends GetxController {
  String apiKey = "";

  void weatherDataReload() {
    for (var element in PrefsHelper.cities) {
      if (PrefsHelper.apiKey != "") {
        PrefsHelper.getWeatherData(
            element, PrefsHelper.apiKey, PrefsHelper.unitS);
      }
    }
    update();
  }
}
