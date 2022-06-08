import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:local_auth/local_auth.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:pinput/pin_put/pin_put.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ConfirmAuth extends StatefulWidget {
  final Map itemResponse;

  const ConfirmAuth({Key? key, required this.itemResponse}) : super(key: key);

  @override
  _ConfirmAuthState createState() => _ConfirmAuthState();
}

class _ConfirmAuthState extends State<ConfirmAuth> {
  var screen = "Set Pin Finger";

  final _pinPutController = TextEditingController();

  String _code = "";

  var savedPin;
  var isFPEnable = false;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  var loading = false;

  @override
  void initState() {
    super.initState();
    getUserPin();
  }

  getFinger() async {
    var scVal = await getfingerprint();
    setState(() {
      isFPEnable = scVal;

      printMessage(screen, "IS Finger Enable : $isFPEnable");

      if (scVal) {
        openNativeFP();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      body: (loading)
          ? Center(
              child: circularProgressLoading(40.0),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 80.h,
                  ),
                  Center(
                      child: Image.asset(
                    'assets/appM_logo.png',
                    height: 40.h,
                  )),
                  Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "Enter your 4-digit pin",
                            style: TextStyle(
                                color: black,
                                fontSize: font18.sp,
                                fontWeight: FontWeight.w700),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          _buildInputBox(),
                          SizedBox(
                            height: 20.h,
                          ),
                          InkWell(
                            onTap: () {
                              //openVerifyForgotPIN(context);
                              printMessage(screen, "Forget Pin clicked");
                            },
                            child: Text(
                              forgotPin,
                              style: TextStyle(color: blue, fontSize: font15.sp),
                            ),
                          ),
                          SizedBox(
                            height: 00,
                          ),
                        ],
                      )),
                  _buildKeyPad(),
                ],
              ),
            ),
    )));
  }

  _buildInputBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 90, vertical: 00),
      child: PinFieldAutoFill(
        controller: _pinPutController,
        decoration: UnderlineDecoration(
          textStyle: TextStyle(fontSize: 20.sp, color: Colors.black),
          colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
        ),
        currentCode: _code,
        codeLength: 4,
        onCodeSubmitted: (code) {},
        onCodeChanged: (code) {
          setState(() {
            _code = code!;
            if (code.length == 4) {
              if (savedPin.toString() == code.toString()) {
                Navigator.pop(context);
                openConfirmPayment(context, widget.itemResponse);
              } else {
                showToastMessage("PIN not matched.");
              }
            }
          });
        },
      ),
    );
  }

  _buildKeyPad() {
    return Column(
      children: [
        SizedBox(height: 0),
        GridView.count(
          crossAxisCount: 3,
          shrinkWrap: true,
          crossAxisSpacing: 40,
          mainAxisSpacing: 15,
          padding: const EdgeInsets.all(50),
          physics: NeverScrollableScrollPhysics(),
          children: [
            ...[1, 2, 3, 4, 5, 6, 7, 8, 9, 0].map((e) {
              return RoundedButton(
                title: '$e',
                onTap: () {
                  _pinPutController.text = '${_pinPutController.text}$e';
                },
              );
            }),
            InkWell(
              onTap: () {
                if (isFPEnable) {
                  openNativeFP();
                } else {
                  showToastMessage(
                      "Fingerprint is disable. Enable it from Menu options");
                }
              },
              child: Container(
                width: 60.0.w,
                height: 60.0.h,
                child: Center(
                  child: Image.asset(
                    'assets/fingerprint.png',
                    height: 24.h,
                    width: 24.w,
                    color: lightBlue,
                  ),
                ),
                decoration: new BoxDecoration(
                    color: white,
                    shape: BoxShape.circle,
                    border: Border.all(color: gray)),
              ),
            ),
            InkWell(
              onTap: () {
                if (_pinPutController.text.isNotEmpty) {
                  _pinPutController.text = _pinPutController.text
                      .substring(0, _pinPutController.text.length - 1);
                }
              },
              child: Container(
                width: 60.0.w,
                height: 60.0.h,
                child: Center(
                  child: Image.asset(
                    'assets/back.png',
                    height: 24.h,
                    width: 24.w,
                    color: lightBlue,
                  ),
                ),
                decoration: new BoxDecoration(
                    color: white,
                    shape: BoxShape.circle,
                    border: Border.all(color: gray)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  openNativeFP() async {
    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "pin": "$savedPin",
      };

      printMessage(screen, "Passing pin : $savedPin");

      String result = await platform.invokeMethod("fingerprint", arr);
      printMessage(screen, "F Response : $result");
      if (result == "true") {
        Navigator.pop(context);
        openConfirmPayment(context, widget.itemResponse);
      } else {
        showToastMessage(somethingWrong);
      }
    }
  }

  Future getUserPin() async {
    setState(() {
      loading = true;
    });

    var headers = {
      "Content-Type": "application/json",
    };

    var token = await getToken();

    final body = {
      "token": "$token",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(getPin),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");

      setState(() {
        loading = false;
        var status = data['status'];
        if (status.toString() == "1") {
          savedPin = data['pin'].toString();
        }
        getFinger();
      });
    } else {
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }
  }
}
