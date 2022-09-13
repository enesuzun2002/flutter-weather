import 'package:flutter/material.dart';
import 'package:weather/services/prefs_helper.dart';
import 'package:weather/widgets/dialog/alert.dart';
import 'package:weather/widgets/helper_widgets.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  SearchState createState() => SearchState();
}

class SearchState extends State<Search> {
  final TextEditingController _cityEditingController = TextEditingController();

  HelperWidgets hw = HelperWidgets();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    var weatherCod;
    String city = "";
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Form(
                key: formKey,
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
                  onChanged: (value) => city = value,
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
                        if (formKey.currentState!.validate()) {
                          if (PrefsHelper.apiKey == "") {
                            showDialog(
                                context: context,
                                builder: (context) => MyAlertDialog(
                                    title: AppLocalizations.of(context)!
                                        .apiKeyAlertT,
                                    content: AppLocalizations.of(context)!
                                        .apiKeyAlertD));
                            return;
                          }
                          weatherCod = await PrefsHelper.getWeatherData(
                              city, PrefsHelper.apiKey, PrefsHelper.unitS);
                          if (weatherCod == 401) {
                            showDialog(
                                context: context,
                                builder: (context) => MyAlertDialog(
                                    title: AppLocalizations.of(context)!
                                        .apiKeyInvalidD,
                                    content: AppLocalizations.of(context)!
                                        .apiKeyInvalidS));
                          } else if (weatherCod == "404") {
                            showDialog(
                                context: context,
                                builder: (context) => MyAlertDialog(
                                    title: AppLocalizations.of(context)!
                                        .locationInvalidD,
                                    content: AppLocalizations.of(context)!
                                        .locationInvalidS));
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              duration: const Duration(seconds: 1),
                              content: Text(
                                  AppLocalizations.of(context)!.locationScss),
                            ));
                            _cityEditingController.clear();
                            PrefsHelper.updateValue(
                                PrefsHelper.keyCities,
                                hw.weatherListCityNamesToList(
                                    PrefsHelper.weatherDataList));
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
}
