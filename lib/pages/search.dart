import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);
  String city = "";

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _cityEditingController = TextEditingController();

  CustomWidgets cw = CustomWidgets();
  WeatherSharedPrefs wsf = WeatherSharedPrefs();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          cw.getData(widget.city);
                          _cityEditingController.clear();
                          wsf.updateCities(
                              cw.weatherListCityNamesToList(MyApp.weatherList));
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
}
