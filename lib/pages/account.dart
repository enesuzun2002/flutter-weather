import 'dart:async';

import 'package:flutter/material.dart';
import 'package:weather/pages/account/login.dart';
import 'package:weather/pages/account/register.dart';

class Account extends StatefulWidget {
  const Account({Key? key}) : super(key: key);

  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  static int pageIndex = 0;

  final Stream<int> stream = Login.controller.stream;

  static final pages = [
    const Login(),
    const Register(),
  ];

  @override
  void initState() {
    stream.listen((pageIndexS) {
      setState(() {
        pageIndex = pageIndexS;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[pageIndex],
    );
  }
}
