import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);
  String city = "";
  String apiKey = "";
  String unitS = "";

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _cityEditingController = TextEditingController();

  CustomWidgets cw = CustomWidgets();
  WeatherSharedPrefs wsf = WeatherSharedPrefs();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    var weatherCod;
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  decoration: InputDecoration(
                    label: Text(AppLocalizations.of(context)!.cityName),
                  ),
                  autocorrect: false,
                  enableSuggestions: false,
                  controller: _cityEditingController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return AppLocalizations.of(context)!.cityNameErr;
                    }
                    return null;
                  },
                  onChanged: (value) => widget.city = value,
                ),
              ),
              const SizedBox(
                height: 16.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 35.0),
                child: SizedBox(
                  height: 45.0,
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () async {
                        widget.apiKey = await wsf.getApiKey();
                        widget.unitS = await wsf.getUnitS();
                        if (_formKey.currentState!.validate()) {
                          if (widget.apiKey == "") {
                            apiKeyAlert(context);
                            return;
                          }
                          weatherCod = await cw.getData(
                              widget.city, widget.apiKey, widget.unitS);
                          if (weatherCod == 401) {
                            invalidApiKeyAlert(context);
                          } else if (weatherCod == "404") {
                            invalidLocationAlert(context);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(
                                  AppLocalizations.of(context)!.locationScss),
                            ));
                            _cityEditingController.clear();
                            wsf.updateCities(cw
                                .weatherListCityNamesToList(MyApp.weatherList));
                          }
                        }
                      },
                      child: Text(AppLocalizations.of(context)!.addCity)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> invalidApiKeyAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text(AppLocalizations.of(context)!.apiKeyInvalidD),
              content: Text(AppLocalizations.of(context)!.apiKeyInvalidS),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.okB))
              ],
            ));
  }

  Future<dynamic> invalidLocationAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text(AppLocalizations.of(context)!.locationInvalidD),
              content: Text(AppLocalizations.of(context)!.locationInvalidS),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.okB))
              ],
            ));
  }

  Future<dynamic> apiKeyAlert(BuildContext context) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0)),
              title: Text(AppLocalizations.of(context)!.apiKeyAlertT),
              content: Text(AppLocalizations.of(context)!.apiKeyAlertD),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(AppLocalizations.of(context)!.okB))
              ],
            ));
  }
}
