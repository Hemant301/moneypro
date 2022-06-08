import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';



class PancardLanding extends StatefulWidget {
  const PancardLanding({Key? key})
      : super(key: key);

  @override
  _PancardLandingState createState() => _PancardLandingState();
}

class _PancardLandingState extends State<PancardLanding> {
  var screen = "PAN landing";

  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

  @override
  void initState() {
    super.initState();

    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();
    var rl = await getRole();
    double mX = 0.0;
    double wX = 0.0;

    final inheritedWidget = StateContainer.of(context);

    if (mpBalc == null || mpBalc == 0) {
      mpBalc = 0;
      inheritedWidget.updateMPBalc(value: mpBalc);
    } else {
      inheritedWidget.updateMPBalc(value: mpBalc);
    }

    if (qrBalc == null || qrBalc == 0) {
      qrBalc = 0;
      inheritedWidget.updateQRBalc(value: qrBalc);
    } else {
      inheritedWidget.updateQRBalc(value: qrBalc);
    }

    if (walBalc == null || walBalc == 0) {
      walBalc = 0;
      inheritedWidget.updateWelBalc(value: walBalc);
    } else {
      inheritedWidget.updateWelBalc(value: walBalc);
    }

    if (walBalc != null || walBalc != 0) {
      wX = double.parse(walBalc);
    }

    if (mpBalc != null || mpBalc != 0) {
      mX = double.parse(mpBalc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(context, "", 24.0),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      "assets/pancard_banner.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
            top: 20,
          ),
          child: Text(
            "Key points",
            style: TextStyle(
                color: black, fontSize: font16.sp, fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
            top: 20,
          ),
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: lightBlue, // border color
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        'assets/upgrade_shop.png',
                        height: 30.h,
                        color: white,
                      ),
                    ),
                  )),
              SizedBox(width: 5.w,),
              Expanded(
                child: Text(
                  "$pan1",
                  style: TextStyle(color: black, fontSize: font16.sp),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
            top: 0,
          ),
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: lightBlue, // border color
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        'assets/instant_shop.png',
                        height: 30.h,
                        color: white,
                      ),
                    ),
                  )),
              SizedBox(width: 5.w,),
              Expanded(
                child: Text(
                  "$pan3",
                  style: TextStyle(color: black, fontSize: font16.sp),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
            top: 0,
          ),
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: lightBlue, // border color
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        'assets/paperless.png',
                        height: 30.h,
                        color: white,
                      ),
                    ),
                  )),
              SizedBox(width: 5.w,),
              Expanded(
                child: Text(
                  "$pan4",
                  style: TextStyle(color: black, fontSize: font16.sp),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 20.0,
            right: 20,
            top: 0,
          ),
          child: Row(
            children: [
              Container(
                  decoration: BoxDecoration(
                    color: lightBlue, // border color
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(6.0),
                      child: Image.asset(
                        'assets/charges.png',
                        height: 30.h,
                        color: white,
                      ),
                    ),
                  )),
              SizedBox(width: 5.w,),
              Expanded(
                child: Text(
                  "$pan5",
                  style: TextStyle(color: black, fontSize: font16.sp),
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 5.h,
        ),
      ])),
      bottomNavigationBar: _buildBotton(),
    )));
  }

  _buildBotton() {
    return Wrap(
      children: [
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Powered by", style: TextStyle(
                color: black,
                fontSize: font16.sp, fontWeight: FontWeight.bold
              ),),
              SizedBox(width: 5.w,),
              Image.asset('assets/uit_logo.jpeg', height: 26.h,)
            ],
          ),
        ),
        InkWell(
          onTap: () {
            setState(() {
              generatePANToken();
            });
          },
          child: Container(
            height: 45.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Center(
              child: Text(
                "Generate Link".toUpperCase(),
                style: TextStyle(fontSize: font16.sp, color: white),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Future generatePANToken() async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(jwtTokenAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      Navigator.pop(context);
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          var token = data['token'].toString();
          generateURL(token);
        } else {
          showToastMessage(somethingWrong);
        }
      }
    });
  }
  Future generateURL(token) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var email = await getEmail();
    var userToken = await getToken();
    var merchantcid = await getMerchantID();


    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    printMessage(screen, "headers : $headers");

    final body = {
      "email": email,
      "user_token": "$userToken",
      "merchantcid": "$merchantcid",
      "token":"$token",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(generatePANAPI),
        body: jsonEncode(body), headers: headers);


    setState(() {
      Navigator.pop(context);
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Response Transaction : $data");
        if (data['status'].toString() == "1") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return PANkycDialog(
                  text: "$email",
                );
              });
        } else {
          showToastMessage(somethingWrong);
        }
      }
    });
  }
}
