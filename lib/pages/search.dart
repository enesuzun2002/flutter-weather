import 'package:flutter/material.dart';
import 'package:weather/main.dart';
import 'package:weather/services/weather_shared_prefs.dart';
import 'package:weather/widgets/custom_widgets.dart';
import 'package:weather/widgets/get_weather.dart';
import 'package:weather/widgets/nav_drawer.dart';

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
    final Stream<int> stream = MyApp.controller.stream;
    return Scaffold(
      drawer: const NavDrawer(),
      appBar: CustomWidgets.getAppBar("Şehir Ekle"),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.disabled,
                  decoration: const InputDecoration(
                      hintText: "Type in city name...",
                      icon: Icon(Icons.search)),
                  autocorrect: false,
                  autofocus: true,
                  enableSuggestions: false,
                  controller: _cityEditingController,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Please enter city name';
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
                      GetWeather.getData(widget.city);
                      _cityEditingController.clear();
                      WeatherSharedPrefs.updateCities(
                          CustomWidgets.weatherListCityNamesToList(
                              MyApp.weatherList));
                    } else {
                      print('Error');
                    }
                  },
                  child: const Text("Ekle")),
            ],
          ),
        ),
      ),
    );
  }
}
