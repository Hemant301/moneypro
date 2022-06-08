import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class UpdatePin extends StatefulWidget {
  const UpdatePin({Key? key}) : super(key: key);

  @override
  _UpdatePinState createState() => _UpdatePinState();
}

class _UpdatePinState extends State<UpdatePin> {
  var screen = "Update Pin";

  final _pinPutController = TextEditingController();

  String _code = "";

  var savedPin;

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails() async {
    var pin = await getPIN();

    setState(() {
      savedPin = pin;
    });

    printMessage(screen, "Saved Pin : $savedPin");
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              backgroundColor: white,
              body: SingleChildScrollView(
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
                              height: 30.h,
                            ),
                            Text(
                              "$set4digit",
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
                              height: 40.h,
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
        keyboardType: TextInputType.visiblePassword,
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
            InkWell(
              onTap: () {
                var pin = _pinPutController.text.toString();

                printMessage(screen, "New Pin : $pin");

                if (savedPin == pin) {
                  showToastMessage("You cannot use old PIN as New PIN.");
                } else {
                  if (pin.length == 4) {
                    setPinToDB(pin);
                  } else {
                    if (pin.length > 4) {
                      pin = pin.substring(0, 4);
                      setPinToDB(pin);
                    }
                  }
                }
              },
              child: Container(
                width: 60.0.w,
                height: 60.0.h,
                child: Center(
                  child: Image.asset(
                    'assets/tick.png',
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

  Future setPinToDB(pin) async {
    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {"token": "$token", "pin": "$pin"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(setPinAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      var statusCode = response.statusCode;

      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (BuildContext context) {
                return setPinAlert(pin: pin);
              });
        } else {
          showToastMessage(data['message']);
        }
      } else {
        showToastMessage(status500);
      }
    });
  }
}
