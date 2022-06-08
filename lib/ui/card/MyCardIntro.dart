import 'dart:async';

import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class MyCardIntro extends StatefulWidget {
  const MyCardIntro({Key? key}) : super(key: key);

  @override
  _MyCardIntroState createState() => _MyCardIntroState();
}

class _MyCardIntroState extends State<MyCardIntro> {
  var screen = "My Card Intro";

  var name = "";

  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 2), () {
      Navigator.pop(context);
      opneMyCardIntroSecond(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: white,
      body: Stack(children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: FittedBox(
              fit: BoxFit.fill, child: Image.asset("assets/mycard_bg_1.png")),
        ),
      ]),
    ));
  }
}
