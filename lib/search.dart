import 'package:flutter/material.dart';

class Search extends StatelessWidget {
  Search({Key? key}) : super(key: key);
  static String city = "Gaziantep";
  TextEditingController textEditingController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: TextField(
          decoration: InputDecoration(
            icon: Icon(Icons.search),
          ),
          controller: textEditingController,
          onSubmitted: (value) {
            city = textEditingController.text;
          },
        ),
      ),
    );
  }
}
