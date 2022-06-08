import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/ui/home/detailscreen.dart';

import 'package:moneypro_new/utils/Functions.dart';
import 'package:showcaseview/showcaseview.dart';

import '../../utils/Constants.dart';

class DummyClass extends StatefulWidget {
  final String response;

  const DummyClass({Key? key, required this.response}) : super(key: key);

  @override
  _DummyClassState createState() => _DummyClassState();
}

class _DummyClassState extends State<DummyClass> {
  var screen = "Dummy";

  var loading = false;

  var isManagerShow = false;
  var kycStatus = "1";
  var role = "3";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => Scaffold(
              body: SafeArea(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Card(
                        elevation: 4.0,
                        color: Color(0xFF090943),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Container(
                          height: 200,
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/contact_less.png",
                                    height: 20,
                                    width: 18,
                                  ),
                                  Image.asset(
                                    "assets/mastercard.png",
                                    height: 50,
                                    width: 50,
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(top: 16.0),
                                child: Text(
                                  '61065550398',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 21,
                                      fontFamily: 'CourrierPrime'),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Sanwal Singh',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'IFSC Code',
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 9, fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'ICIC0000012',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Card(
                        elevation: 4.0,
                        color: Color(0xFF090943),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        child: Container(
                          height: 200,
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: <Widget>[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Image.asset(
                                    "assets/contact_less.png",
                                    height: 20,
                                    width: 18,
                                  ),
                                  Image.asset(
                                    "assets/appM_logo.png",
                                    height: 48,
                                    width: 48,
                                  ),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'A/c No.',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        '61065550398',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        'Avbl Balc.',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        '$rupeeSymbol 45,098',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: <Widget>[
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        'Name',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        'Sanwal Singh',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: <Widget>[
                                      Text(
                                        'IFSC Code',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700),
                                      ),
                                      Text(
                                        'ICIC0000012',
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }
}
