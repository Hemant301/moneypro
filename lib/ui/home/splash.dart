import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_analytics/observer.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:moneypro_new/utils/SharedPrefs.dart';

class Splash extends StatefulWidget {
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;

  const Splash({Key? key, required this.analytics, required this.observer})
      : super(key: key);

  @override
  _SplashState createState() => _SplashState();
}

class _SplashState extends State<Splash> with SingleTickerProviderStateMixin {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  var screen = "Splash Second Screen";

  late AnimationController animationController;
  late Animation<double> animation;

  var _visible = true;

  AppUpdateInfo? _updateInfo;

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    _firebaseMessaging.getToken().then((token) {
      var deviceId = token;
      printMessage(screen, "Device Id : $deviceId");
    });

    animationController = new AnimationController(
        vsync: this, duration: new Duration(seconds: 1));
    animation =
        new CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => this.setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    trackScreens(screen);
    getAppVersion(context);
    printIps();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
            child: Scaffold(
              body: Stack(
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: FittedBox(
                        fit: BoxFit.fill, child: Image.asset("assets/splash.png")),
                  ),
                  Center(
                    child: Image.asset(
                      'assets/app_splash_logo.png',
                      width: animation.value * 250,
                      height: animation.value * 250,
                    ),
                  ),
                  Positioned(
                      bottom: 10,
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 25.0, right: 25),
                              child: Divider(
                                color: dividerSplash,
                              ),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    child: Image.asset(
                                      'assets/pci.png',
                                      height: 24,
                                    )),
                                Expanded(
                                    child: Image.asset(
                                      'assets/upi.png',
                                      height: 20,
                                    )),
                                Expanded(
                                    child: Image.asset(
                                      'assets/iso.png',
                                      height: 30,
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ))
                ],
              ),
            ),
    );
  }

  Future getAppVersion(context) async {
    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "version": "$appVersion",
    };

    final response = await http.post(Uri.parse(appUpdateAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    printMessage(screen, "Status Code : $statusCode");

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Update Response : $data");

      var statusCode = response.statusCode;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          checkUserLoginStatus();
        } else if (data['status'].toString() == "2") {
          var major = data['major'];
          checkForUpdate(major);
        }
      }
    }
  }

  //appUpdate

  Future printIps() async {
    try {
      DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
      AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
      printMessage(screen, "ID-> :${androidInfo.id}");
    } catch (e) {
      printMessage(screen, "Error : ${e.toString()}");
    }
  }

  Future<void> checkForUpdate(major) async {
    InAppUpdate.checkForUpdate().then((info) {
      setState(() {
        _updateInfo = info;

        printMessage(screen, "Info is : ${_updateInfo}");

        printMessage(screen, "Info updateAvailable : ${UpdateAvailability.updateAvailable}");
        printMessage(screen, "Info updateAvailability : ${_updateInfo?.updateAvailability}");

        if(_updateInfo?.updateAvailability ==
            UpdateAvailability.updateAvailable){
          InAppUpdate.performImmediateUpdate()
              .catchError((e) => printMessage(screen,"${e.toString()}"));
        }else{
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return UpdatePopup(major: major);
              });
        }
      });
    }).catchError((e) {
      printMessage(screen,"${e.toString()}");
    });
  }

  checkUserLoginStatus() async {
    final checked = await getUserLogin();
    var mobile = await getMobile();

    printMessage(screen, "Checked : $checked\nMobile : $mobile");

    if (checked) {
      if(mobile.toString()=="7742526633"){
        Navigator.pop(context);
        openPerspective(context,false);
        return;
      }

      Timer(Duration(seconds: 5), () {
        Navigator.pop(context);
        openSetPinFinger(context);
      });
    } else {
      Timer(Duration(seconds: 2), () {
        Navigator.pop(context);
        openSignIn(context);
      });
    }
  }
}
