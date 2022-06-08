import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Constants.dart';

class NoInternet extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: 200,
            width: 200,
            margin: EdgeInsets.fromLTRB(0, 0, 0, 25),
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/no-internet.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          Text(
            "No Internet Connection",
            style: TextStyle(
              fontSize: font20,
              color: black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "You are not connected to the internet. Make sure your Wi-Fi is ON and Aeroplane Mode is OFF & try again.",
              style: TextStyle(
                fontSize: font16,
                color: black
              ),
              textAlign: TextAlign.center,
            ),
          )
        ],
      ),
    );
  }
}