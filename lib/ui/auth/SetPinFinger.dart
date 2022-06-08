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

class SetPinFinger extends StatefulWidget {
  const SetPinFinger({Key? key}) : super(key: key);

  @override
  _SetPinFingerState createState() => _SetPinFingerState();
}

class _SetPinFingerState extends State<SetPinFinger> {
  var screen = "Set Pin Finger";

  final _pinPutController = TextEditingController();

  String _code = "";

  var savedPin;
  var isFPEnable = false;
  final LocalAuthentication _localAuthentication = LocalAuthentication();

  var loading = false;

  TextEditingController otp1Controller = new TextEditingController();
  TextEditingController otp2Controller = new TextEditingController();
  TextEditingController otp3Controller = new TextEditingController();
  TextEditingController otp4Controller = new TextEditingController();

  FocusNode node01 = FocusNode();
  FocusNode node02 = FocusNode();
  FocusNode node03 = FocusNode();
  FocusNode node04 = FocusNode();

  var finalCode = "";

  @override
  void initState() {
    super.initState();
    getUserPin();
  }

  @override
  void dispose() {
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
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
                                    onTap: () async {
                                      var mobile = await getMobile();
                                      openVerifyMobile(context, mobile, 0);
                                      //printMessage(screen, "Forget Pin clicked $mobile");
                                    },
                                    child: Text(
                                      forgotPin,
                                      style: TextStyle(
                                          color: blue, fontSize: font15.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 00.h,
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
        onCodeSubmitted: (code) {

        },
        onCodeChanged: (code) {
          setState(() {
            _code = code!;
            if (finalCode.length == 4) {
              if (savedPin.toString() == finalCode.toString()) {
                Navigator.pop(context);
                savePIN(finalCode.toString());
                saveUserLogin(true);
                openPerspective(context, false);
              } else {
                showToastMessage("PIN not matched.");
              }
            }
          });
        },
      ),
    );
  }

  _buildInputBox1() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 50.h,
          height: 50.h,
          child: TextFormField(
            focusNode: node01,
            obscureText: true,
            textAlign: TextAlign.center,
            style: TextStyle(color: black, fontSize: inputFont.sp),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: otp1Controller,
            decoration: new InputDecoration(
              isDense: true,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid, width: 0)),
              counterText: "",
            ),
            maxLength: 1,
            onChanged: (val) {
              if (val.length == 1) {
                FocusScope.of(context).requestFocus(node02);
              }
            },
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Container(
          width: 50.h,
          height: 50.h,
          child: TextFormField(
            focusNode: node02,
            obscureText: true,
            textAlign: TextAlign.center,
            style: TextStyle(color: black, fontSize: inputFont.sp),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: otp2Controller,
            decoration: new InputDecoration(
              isDense: true,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid, width: 0)),
              counterText: "",
            ),
            maxLength: 1,
            onChanged: (val) {
              if (val.length == 1) {
                FocusScope.of(context).requestFocus(node03);
              } else if (val.length == 0) {
                FocusScope.of(context).requestFocus(node01);
              }
            },
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Container(
          width: 50.h,
          height: 50.h,
          child: TextFormField(
            focusNode: node03,
            obscureText: true,
            textAlign: TextAlign.center,
            style: TextStyle(color: black, fontSize: inputFont.sp),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: otp3Controller,
            decoration: new InputDecoration(
              isDense: true,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid, width: 0)),
              counterText: "",
            ),
            maxLength: 1,
            onChanged: (val) {
              if (val.length == 1) {
                FocusScope.of(context).requestFocus(node04);
              } else if (val.length == 0) {
                FocusScope.of(context).requestFocus(node02);
              }
            },
          ),
        ),
        SizedBox(
          width: 15.w,
        ),
        Container(
          width: 50.h,
          height: 50.h,
          child: TextFormField(
            focusNode: node04,
            obscureText: true,
            textAlign: TextAlign.center,
            style: TextStyle(color: black, fontSize: inputFont.sp),
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.next,
            controller: otp4Controller,
            decoration: new InputDecoration(
              isDense: true,
              border: UnderlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid, width: 0)),
              counterText: "",
            ),
            maxLength: 1,
            onChanged: (val) {
              printMessage(screen, "val : $val");
              if (val.length == 1) {
                closeKeyBoard(context);
                var _code1 = otp1Controller.text.toString();
                var _code2 = otp2Controller.text.toString();
                var _code3 = otp3Controller.text.toString();
                var _code4 = otp4Controller.text.toString();

                var _code = "$_code1$_code2$_code3$_code4";

                printMessage(screen, "Code : $_code");

                if (_code.length == 4) {
                  if (savedPin.toString() == _code.toString()) {
                    Navigator.pop(context);
                    savePIN(_code.toString());
                    saveUserLogin(true);
                    openPerspective(context, false);
                  } else {
                    showToastMessage("PIN not matched.");
                  }
                }
              } else if (val.length == 0) {
                FocusScope.of(context).requestFocus(node03);
              }
            },
          ),
        ),
      ],
    );
  }

  _buildKeyPad() {
    return Column(
      children: [
        SizedBox(height: 0.h),
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

                  //_pinPutController.text = '${_pinPutController.text}$e';
                  _pinPutController.text = '${_pinPutController.text}*';

                  setState(() {
                    finalCode = "$finalCode$e".trim();
                    printMessage(screen, "Final code enterd $finalCode");
                  });

                  if (finalCode.length == 4) {
                    if (savedPin.toString() == finalCode.toString()) {
                      Navigator.pop(context);
                      savePIN(finalCode.toString());
                      saveUserLogin(true);
                      openPerspective(context, false);
                    } else {
                      showToastMessage("PIN not matched.");
                    }
                  }

                  /*var one = otp1Controller.text.toString();
                  var two = otp2Controller.text.toString();
                  var three = otp3Controller.text.toString();
                  var four = otp4Controller.text.toString();

                  if (one.length == 0) {
                    setState(() {
                      otp1Controller = new TextEditingController(text: "$e");
                      FocusScope.of(context).requestFocus(node02);
                    });
                  }
                  else if (two.length == 0) {
                    setState(() {
                      otp2Controller = new TextEditingController(text: "$e");
                      FocusScope.of(context).requestFocus(node03);
                    });
                  }
                  else if (three.length == 0) {
                    setState(() {
                      otp3Controller = new TextEditingController(text: "$e");
                      FocusScope.of(context).requestFocus(node04);
                    });
                  }
                  else if (four.length == 0) {
                    setState(() {
                      otp4Controller = new TextEditingController(text: "$e");
                      closeKeyBoard(context);
                      var _code1 = otp1Controller.text.toString();
                      var _code2 = otp2Controller.text.toString();
                      var _code3 = otp3Controller.text.toString();
                      var _code4 = otp4Controller.text.toString();

                      var _code = "$_code1$_code2$_code3$_code4";

                      printMessage(screen, "Code : $_code");

                      if (_code.length == 4) {
                        if (savedPin.toString() == _code.toString()) {
                          Navigator.pop(context);
                          savePIN(_code.toString());
                          saveUserLogin(true);
                          openPerspective(context, false);
                        } else {
                          showToastMessage("PIN not matched.");
                        }
                      }
                    });
                  }*/
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

                setState(() {
                  if(finalCode.isNotEmpty){
                    finalCode = finalCode.substring(0,finalCode.length-1);
                  }
                });

                /*var one = otp1Controller.text.toString();
                var two = otp2Controller.text.toString();
                var three = otp3Controller.text.toString();
                var four = otp4Controller.text.toString();

                if (four.length == 1) {
                  setState(() {
                    otp4Controller = new TextEditingController(text: "");
                    FocusScope.of(context).requestFocus(node03);
                  });
                } else if (three.length == 0) {
                  setState(() {
                    otp3Controller = new TextEditingController(text: "");
                    FocusScope.of(context).requestFocus(node02);
                  });
                } else if (two.length == 0) {
                  setState(() {
                    otp2Controller = new TextEditingController(text: "");
                    FocusScope.of(context).requestFocus(node01);
                  });
                } else if (one.length == 0) {
                  setState(() {
                    otp1Controller = new TextEditingController(text: "");
                    FocusScope.of(context).requestFocus(node01);
                  });
                }*/
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
        saveUserLogin(true);
        openPerspective(context, false);
      } else {
        showToastMessage(somethingWrong);
      }
    }
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
        } else {
          openSetPin(context);
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
