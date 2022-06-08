import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Countdown.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MerchantInvestorMobile extends StatefulWidget {
  final String token;
  final String mobile;
  const MerchantInvestorMobile({Key? key,
    required this.token,
    required this.mobile}) : super(key: key);

  @override
  _MerchantInvestorMobileState createState() => _MerchantInvestorMobileState();
}

class _MerchantInvestorMobileState extends State<MerchantInvestorMobile>  with TickerProviderStateMixin {
  var loading = false;
  var screen = "Investor Mobile";
  String _code = "";
  var mobileNumber = "";

  late AnimationController _controller;
  int levelClock = 20;

  var reciveOtp;
  var resendLoader = false;

  TextEditingController otpController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    setState(() {
      this.startTimer();
    });

    sendOTP(1);

    getUserDetail();
  }

  getUserDetail() async {
    var mobile = widget.mobile.toString();
    var m = await generateXFormat(mobile.toString());
    setState(() {
      mobileNumber = m;
    });
  }

  startTimer() {
    _controller = AnimationController(
        vsync: this,
        duration: Duration(
            seconds:
            levelClock)
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        printMessage(screen, "Mobile back pressed");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return exitProcess();
            });
        return false;
      },
      child: SafeArea(
          child: Scaffold(
              backgroundColor: white,
              resizeToAvoidBottomInset:false,
              appBar: AppBar(
                elevation: 0,
                centerTitle: false,
                backgroundColor: white,
                brightness: Brightness.light,
                leading: InkWell(
                  onTap: () {
                    closeKeyBoard(context);
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return exitProcess();
                        });
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/back_arrow_bg.png',
                          height: 60,
                        ),
                        Positioned(
                          top: 16,
                          left: 12,
                          child: Image.asset(
                            'assets/back_arrow.png',
                            height: 16,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                titleSpacing: 0,
                title: appLogo(),
                actions: [
                  Image.asset(
                    'assets/lendbox_head.png',
                    width: 60,
                  ),
                  SizedBox(
                    width: 10,
                  )
                ],
              ),
              body: (loading)
                  ? Center(child: circularProgressLoading(40.0))
                  : SingleChildScrollView(
                    child: Column(children: [
                appSelectedBanner(context, "invest_banner.png", 150.0),
                Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(top: 20),
                      decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.0)),
                        color: white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 10,
                            blurRadius: 10,
                            offset:
                            Offset(0, 1), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 20,
                            ),
                            Center(
                              child: Container(
                                color: gray,
                                width: 50,
                                height: 5,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 20),
                              child: Text(
                                "Enter the OTP sent to your mobile number +91-$mobileNumber  to complete the process.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: black,
                                    fontSize: font14,
                                    height: 1.5),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            _buildInputBox(),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: Countdown(
                                  animation: StepTween(
                                    begin: levelClock,
                                    // THIS IS A USER ENTERED NUMBER
                                    end: 0,
                                  ).animate(_controller),
                                ),
                              ),
                            ),
                            Center(
                              child: InkWell(
                                onTap: () {
                                  if (_controller.status.toString() ==
                                      "AnimationStatus.completed") {
                                    sendOTP(2);
                                  } else {
                                    printMessage(screen, "Still hope");
                                  }
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15, top: 10),
                                  child: Text(
                                    "Didn't receive the OTP? Send Again",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font13,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            (resendLoader)
                                ? Center(
                              child: circularProgressLoading(20.0),
                            )
                                : Container(),
                            Padding(
                              padding:
                              const EdgeInsets.only(left: 25.0, top: 20),
                              child: Text(
                                "Terms and conditions:",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font14,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, top: 10, right: 25),
                              child: Text(
                                "$note17",
                                style:
                                TextStyle(color: black, fontSize: font13),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, top: 10, right: 25),
                              child: Text(
                                "$note18",
                                style:
                                TextStyle(color: black, fontSize: font13),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, top: 5, right: 25),
                              child: Text(
                                "$note19",
                                style:
                                TextStyle(color: black, fontSize: font13),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, top: 5, right: 25),
                              child: Text(
                                "$note20",
                                style:
                                TextStyle(color: black, fontSize: font13),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, top: 5, right: 25),
                              child: Text(
                                "$note21",
                                style:
                                TextStyle(color: black, fontSize: font13),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, top: 5, right: 25, bottom: 20),
                              child: Text(
                                "$note22",
                                style:
                                TextStyle(color: black, fontSize: font13),
                              ),
                            ),

                          ]))
              ]),
                  ),
          bottomNavigationBar: Wrap(
            children: [
              Container(
                width: MediaQuery.of(context).size.width,
                child: Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/check_mark.png",
                          height: 16,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          iAgree,
                          style: TextStyle(
                              fontSize: font12, color: black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    InkWell(
                      onTap: () {
                        var otp = otpController.text.toString();

                        if (otp.length != 6) {
                          showToastMessage("Enter 6-digit OTP");
                          return;
                        }

                        if (reciveOtp.toString() == otp.toString()) {
                          setState(() {
                            showToastMessage("OTP matched");
                            openMerchantInvestorOnBoarding(context, widget.token);
                          });
                        } else {
                          setState(() {
                            showToastMessage("OTP not matched");
                          });
                        }
                      },
                      child: Container(
                        width:
                        MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 0,
                            left: 25,
                            right: 25,
                            bottom: 10),
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(
                              Radius.circular(25)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              accept.toUpperCase(),
                              style: TextStyle(
                                  fontSize: font13,
                                  color: white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),)),
    );
  }

  _buildInputBox() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 50, vertical: 00),
      child: PinFieldAutoFill(
        controller: otpController,
        cursor: Cursor(
          color: blue,
        ),
        decoration: UnderlineDecoration(
          textStyle: TextStyle(fontSize: 20, color: black),
          colorBuilder: FixedColorBuilder(Colors.black.withOpacity(0.3)),
        ),
        currentCode: otpController.text,
        codeLength: 6,
        onCodeSubmitted: (code) {},
        onCodeChanged: (code) {
          setState(() {
            _code = code!;
          });
        },
      ),
    );
  }

  Future sendOTP(action) async {
    setState(() {
      if (action == 1) loading = true;
      if (action == 2) resendLoader = true;
    });

    var mobile = widget.mobile.toString();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "mobile": mobile,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(investorMobileVerifyAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");

      setState(() {
        loading = false;
        resendLoader = false;
        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
          reciveOtp = data['otp'].toString();
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    }else{
      setState(() {
        loading = false;
        resendLoader = false;
      });
      showToastMessage(status500);
    }


  }
}
