import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:weather/widgets/nav_drawer.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);
  String city = "";

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _cityEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: CustomWidgets.getAppBar(AppLocalizations.of(context)!.addNewCity),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  decoration: InputDecoration(
                      hintText: AppLocalizations.of(context)!.cityName,
                      icon: const Icon(Icons.search)),
                  autocorrect: false,
                  autofocus: true,
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
              ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      CustomWidgets.getData(widget.city);
                      _cityEditingController.clear();
                      WeatherSharedPrefs.updateCities(
                          CustomWidgets.weatherListCityNamesToList(
                              MyApp.weatherList));
                    }
                  },
                  child: Text(AppLocalizations.of(context)!.addCity)),
            ],
          ),
        ),
      ),
    );
  }
}
