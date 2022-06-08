import 'dart:async';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Countdown.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'package:network_info_plus/network_info_plus.dart';
import 'dart:convert';
import 'package:dart_ipify/dart_ipify.dart';

//import 'package:telephony/telephony.dart';

import '../../main.dart';

class VerifyMobile extends StatefulWidget {
  final String mobile;
  final int action;

  const VerifyMobile({Key? key, required this.mobile, required this.action})
      : super(key: key);

  @override
  _VerifyMobileState createState() => _VerifyMobileState();
}

class _VerifyMobileState extends State<VerifyMobile>
    with TickerProviderStateMixin {
  var screen = "Mobile Verify";

  late AnimationController _controller;

  final info = NetworkInfo();

  var deviceId;

  int levelClock = 20;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  TextEditingController otp0Controller = new TextEditingController();
  TextEditingController otp1Controller = new TextEditingController();
  TextEditingController otp2Controller = new TextEditingController();
  TextEditingController otp3Controller = new TextEditingController();
  TextEditingController otp4Controller = new TextEditingController();
  TextEditingController otp5Controller = new TextEditingController();

  FocusNode node00 = FocusNode();
  FocusNode node01 = FocusNode();
  FocusNode node02 = FocusNode();
  FocusNode node03 = FocusNode();
  FocusNode node04 = FocusNode();
  FocusNode node05 = FocusNode();

  var loading = false;

  /*String _message = "";
  final telephony = Telephony.instance;*/

  @override
  void initState() {
    super.initState();
    _firebaseMessaging.getToken().then((token) {
      deviceId = token;
      printMessage(screen, "Device Id : $deviceId");
    });
    // initPlatformState();
    setState(() {
      this.startTimer();
    });

    sendOTP("${widget.mobile}");
  }

  /*Future<void> initPlatformState() async {

    final bool? result = await telephony.requestPhoneAndSmsPermissions;

    if (result != null && result) {
      telephony.listenIncomingSms(
          onNewMessage: onMessage, onBackgroundMessage: onBackgroundMessage);
    }

    if (!mounted) return;
  }

  Future onMessage(SmsMessage message) async {
    setState(() {
      _message = message.body ?? "Error reading message body.";

      if(_message.contains("Moneypro")){
        var m = _message.replaceAll("OTP to verify you mobile no is", "");
        m = m.replaceAll("from Moneypro", "").trim();

        otp0Controller = new TextEditingController(text: "${m[0]}");
        otp1Controller = new TextEditingController(text: "${m[1]}");
        otp2Controller = new TextEditingController(text: "${m[2]}");
        otp3Controller = new TextEditingController(text: "${m[3]}");
        otp4Controller = new TextEditingController(text: "${m[4]}");
        otp5Controller = new TextEditingController(text: "${m[5]}");

      }
    });
  }

  onSendStatus(SendStatus status) {
    setState(() {
      _message = status == SendStatus.SENT ? "sent" : "delivered";
    });
  }*/

  startTimer() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
                levelClock) // gameData.levelClock is a user entered number elsewhere in the applciation
        );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    otp0Controller.dispose();
    otp1Controller.dispose();
    otp2Controller.dispose();
    otp3Controller.dispose();
    otp4Controller.dispose();
    otp5Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              backgroundColor: white,
              leading: IconButton(
                icon: backArrow(),
                onPressed: () {
                  closeCurrentPage(context);
                },
              ),
            ),
            body: (loading)
                ? Center(
                    child: circularProgressLoading(40.0),
                  )
                : SingleChildScrollView(
                    child: Column(children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Center(
                        child: Image.asset(
                      'assets/otp_get.png',
                      height: 250.h,
                    )),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      enterOtp,
                      style: TextStyle(
                          color: black,
                          fontSize: font15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 40.0, right: 40, top: 10),
                      child: Column(
                        children: [
                          Text(
                            weHaveSent,
                            style: TextStyle(color: black, fontSize: font15.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text("+91- ${widget.mobile}",
                              style: TextStyle(
                                  color: lightBlue,
                                  fontSize: font26.sp,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(
                            "(Sit back & relax, we will auto fetch the OTP)",
                            style:
                                TextStyle(fontSize: font11.sp, color: lightBlack),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.h,
                    ),
                    Card(
                        elevation: 15,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                        margin: EdgeInsets.only(top: 00, left: 15, right: 15),
                        child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Container(
                                    height: 50.h,
                                    width: MediaQuery.of(context).size.width,
                                    child: Row(
                                      children: [
                                        SizedBox(
                                          width: 40.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                            focusNode: node00,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: black,
                                                fontSize: inputFont.sp),
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: otp0Controller,
                                            decoration: new InputDecoration(
                                              isDense: true,
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.solid,
                                                      width: 0)),
                                              counterText: "",
                                            ),
                                            maxLength: 1,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(node01);
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                            focusNode: node01,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: black,
                                                fontSize: inputFont.sp),
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: otp1Controller,
                                            decoration: new InputDecoration(
                                              isDense: true,
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.solid,
                                                      width: 0)),
                                              counterText: "",
                                            ),
                                            maxLength: 1,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(node02);
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                            focusNode: node02,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: black,
                                                fontSize: inputFont.sp),
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: otp2Controller,
                                            decoration: new InputDecoration(
                                              isDense: true,
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.solid,
                                                      width: 0)),
                                              counterText: "",
                                            ),
                                            maxLength: 1,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(node03);
                                              } else if (val.length == 0) {
                                                FocusScope.of(context)
                                                    .requestFocus(node01);
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                            focusNode: node03,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: black,
                                                fontSize: inputFont.sp),
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: otp3Controller,
                                            decoration: new InputDecoration(
                                              isDense: true,
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.solid,
                                                      width: 0)),
                                              counterText: "",
                                            ),
                                            maxLength: 1,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(node04);
                                              } else if (val.length == 0) {
                                                FocusScope.of(context)
                                                    .requestFocus(node02);
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                            focusNode: node04,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: black,
                                                fontSize: inputFont.sp),
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.next,
                                            controller: otp4Controller,
                                            decoration: new InputDecoration(
                                              isDense: true,
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.solid,
                                                      width: 0)),
                                              counterText: "",
                                            ),
                                            maxLength: 1,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                FocusScope.of(context)
                                                    .requestFocus(node05);
                                              } else if (val.length == 0) {
                                                FocusScope.of(context)
                                                    .requestFocus(node03);
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: TextFormField(
                                            focusNode: node05,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: black,
                                                fontSize: inputFont.sp),
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.done,
                                            controller: otp5Controller,
                                            decoration: new InputDecoration(
                                              isDense: true,
                                              border: UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                      style: BorderStyle.solid,
                                                      width: 0)),
                                              counterText: "",
                                            ),
                                            maxLength: 1,
                                            onChanged: (val) {
                                              if (val.length == 1) {
                                                closeKeyBoard(context);
                                              } else if (val.length == 0) {
                                                FocusScope.of(context)
                                                    .requestFocus(node04);
                                              }
                                            },
                                          ),
                                        ),
                                        SizedBox(
                                          width: 40.w,
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 40.h,
                                    margin: EdgeInsets.only(
                                        left: 40,
                                        right: 40,
                                        top: 20,
                                        bottom: 20),
                                    decoration: BoxDecoration(
                                        color: lightBlue,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        border: Border.all(color: lightBlue)),
                                    child: InkWell(
                                      onTap: () {
                                        var _code0 =
                                            otp0Controller.text.toString();
                                        var _code1 =
                                            otp1Controller.text.toString();
                                        var _code2 =
                                            otp2Controller.text.toString();
                                        var _code3 =
                                            otp3Controller.text.toString();
                                        var _code4 =
                                            otp4Controller.text.toString();
                                        var _code5 =
                                            otp5Controller.text.toString();

                                        var _code =
                                            "$_code0$_code1$_code2$_code3$_code4$_code5";

                                        if (_code.toString() == "" ||
                                            _code.length != 6) {
                                          showToastMessage("Enter 6-digit OTP");
                                        } else {
                                          closeKeyBoard(context);
                                          submitOTPTask(_code.toString());
                                        }
                                      },
                                      child: Center(
                                        child: Text(
                                          "$continue_",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: font14.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ]))),
                    SizedBox(
                      height: 40.h,
                    ),
                    InkWell(
                      onTap: () {
                        if (_controller.status.toString() ==
                            "AnimationStatus.completed") {
                          reSendOTP(widget.mobile);
                        } else {
                          printMessage(screen, "Still hope");
                        }
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "$resendCode",
                            style:
                                TextStyle(color: lightBlue, fontSize: font12.sp),
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Countdown(
                                animation: StepTween(
                                  begin: levelClock,
                                  // THIS IS A USER ENTERED NUMBER
                                  end: 0,
                                ).animate(_controller),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                      SizedBox(
                        height: 20.h,
                      ),
                  ])))));
  }

  Future reSendOTP(mobile) async {
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
    };

    final body = {
      "mobile": mobile,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(tokenAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Register data : $data");

      setState(() {
        Navigator.pop(context);
        var status = data['status'];
        if (status.toString() == "1") {
          saveToken("${data['token'].toString()}");

          int recOTP = data['otp'];
          recOTP = recOTP - 6;
        }
        showToastMessage(data['message']);
      });
    }else{
      Navigator.pop(context);
      showToastMessage(status500);
    }


  }

  Future sendOTP(mobile) async {
    setState(() {
      loading = true;
    });

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "mobile": mobile,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(tokenAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Register data : $data");

      setState(() {
        loading = false;
        var status = data['status'];
        if (status.toString() == "1") {
          saveToken("${data['token'].toString()}");
        } else {
          openSignUpScreen(context);
        }
        showToastMessage(data['message']);
      });
    }else{
      loading = false;
      showToastMessage(status500);
    }


  }

  Future submitOTPTask(otp) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var ipAddress = "";

    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;

    var token = await getToken();

    try {
      var ipWIFI = await info.getWifiIP();
      printMessage(screen, "ipWIFI : $ipWIFI");

      if (ipWIFI.toString() != "null" && ipWIFI.toString() != "") {
        ipAddress = ipWIFI!;
      } else {
        var ipMobile = await Ipify.ipv4();
        ipAddress = ipMobile;
      }
    } catch (e) {
      printMessage(screen, "Error : ${e.toString()}");
    }

    var imei = androidInfo.androidId;

    printMessage(screen, "ipAddress : $ipAddress");

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "otp": "$otp",
      "token": "$token",
      "device_id": "$deviceId",
      "app_name": "MoneyPro",
      "ip": "$ipAddress",
      "imei": "$imei",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(loginAPI),
        body: jsonEncode(body), headers: headers);


    int statusCode = response.statusCode;

    if(statusCode==200){

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");

      setState(() {
        Navigator.pop(context);
        var status = data['status'];

        if (status.toString() == "1") {
          saveToken("${data['user']['token'].toString()}");
          var mobile = data['user']['mobile'];
          var fname = data['user']['first_name'];
          var lname = data['user']['last_name'];

          saveFirstName(fname);
          saveLastName(lname);
          saveMobile(mobile);
          saveRole("${data['user']['role'].toString()}");
          closeCurrentPage(context);

          if (widget.action == 0) {
            openSetPin(context);
          } else {
            openSetPinFinger(context);
          }
        } else {
          showToastMessage(data['message'].toString());
        }
      });

    }else{
      Navigator.pop(context);
      showToastMessage(status500);
    }


  }
}
