import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Countdown.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

//import 'package:telephony/telephony.dart';

import '../../../main.dart';

class InvestorMobileVerify extends StatefulWidget {
  const InvestorMobileVerify({Key? key}) : super(key: key);

  @override
  _InvestorMobileVerifyState createState() => _InvestorMobileVerifyState();
}

class _InvestorMobileVerifyState extends State<InvestorMobileVerify>
    with TickerProviderStateMixin {
  var loading = false;
  var screen = "Investor Mobile";

  var mobileNumber = "";

  late AnimationController _controller;
  int levelClock = 20;

  var reciveOtp;
  var resendLoader = false;

  //TextEditingController otpController = new TextEditingController();

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

  //String _message = "";
 // final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
   // initPlatformState();
    setState(() {
      this.startTimer();
    });
    sendOTP(1);
    getUserDetail();
  }

  getUserDetail() async {
    var mobile = await getMobile();
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
        builder: () =>WillPopScope(
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
                    height: 60.h,
                    width: 60.w,
                    child: Stack(
                      children: [
                        Image.asset(
                          'assets/back_arrow_bg.png',
                          height: 60.h,
                        ),
                        Positioned(
                          top: 16,
                          left: 12,
                          child: Image.asset(
                            'assets/back_arrow.png',
                            height: 16.h,
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
                    width: 60.w,
                  ),
                  SizedBox(
                    width: 10.w,
                  )
                ],
              ),
              body: (loading)
                  ? Center(child: circularProgressLoading(40.0))
                  : SingleChildScrollView(
                    child: Column(
                    children: [
                        appSelectedBanner(context, "invest_banner.png", 150.0.h),
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
                                    height: 20.h,
                                  ),
                                  Center(
                                    child: Container(
                                      color: gray,
                                      width: 50.w,
                                      height: 5.h,
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
                                          fontSize: font14.sp),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
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
                                              fontSize: font12.sp,
                                              fontWeight: FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.h,
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
                                          fontSize: font14.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 10, right: 25),
                                    child: Text(
                                      "$note17",
                                      style:
                                          TextStyle(color: black, fontSize: font13.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 10, right: 25),
                                    child: Text(
                                      "$note18",
                                      style:
                                          TextStyle(color: black, fontSize: font13.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 5, right: 25),
                                    child: Text(
                                      "$note19",
                                      style:
                                          TextStyle(color: black, fontSize: font13.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 5, right: 25),
                                    child: Text(
                                      "$note20",
                                      style:
                                          TextStyle(color: black, fontSize: font13.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 5, right: 25),
                                    child: Text(
                                      "$note21",
                                      style:
                                          TextStyle(color: black, fontSize: font13.sp),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 25.0, top: 5, right: 25, bottom: 20),
                                    child: Text(
                                      "$note22",
                                      style:
                                          TextStyle(color: black, fontSize: font13.sp),
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
                      height: 10.h,
                    ),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          "assets/check_mark.png",
                          height: 16.h,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          iAgree,
                          style: TextStyle(
                              fontSize: font12.sp, color: black),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    InkWell(
                      onTap: () {

                        var _code0 =otp0Controller.text.toString();
                        var _code1 =otp1Controller.text.toString();
                        var _code2 =otp2Controller.text.toString();
                        var _code3 =otp3Controller.text.toString();
                        var _code4 =otp4Controller.text.toString();
                        var _code5 =otp5Controller.text.toString();

                        var otp = "$_code0$_code1$_code2$_code3$_code4$_code5";

                        if (otp.length != 6) {
                          showToastMessage("Enter 6-digit OTP");
                          return;
                        }

                        if (reciveOtp.toString() == otp.toString()) {
                          setState(() {
                            showToastMessage("OTP matched");
                            openInvestorPersonalDetail(context);
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
                                  fontSize: font13.sp,
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
    ));
  }

  _buildInputBox() {
    return Container(
      height: 50.h,
      width: MediaQuery.of(context).size.width,
      child: Row(
        children: [
          SizedBox(width: 60.w,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node00,
              textAlign: TextAlign.center,
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: otp0Controller,
              decoration: new InputDecoration(
                isDense: true,
                border: UnderlineInputBorder(
                    borderSide: BorderSide(style: BorderStyle.solid, width: 0)),
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
          SizedBox(width: 15.w,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node01,
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
                  FocusScope.of(context)
                      .requestFocus(node02);
                }
              },
            ),
          ),
          SizedBox(width: 15.w,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node02,
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
                  FocusScope.of(context)
                      .requestFocus(node03);
                }
              },
            ),
          ),
          SizedBox(width: 15.w,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node03,
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
                  FocusScope.of(context)
                      .requestFocus(node04);
                }
              },
            ),
          ),
          SizedBox(width: 15.w,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node04,
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
                if (val.length == 1) {
                  FocusScope.of(context)
                      .requestFocus(node05);
                }
              },
            ),
          ),
          SizedBox(width: 15.w,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node05,
              textAlign: TextAlign.center,
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              controller: otp5Controller,
              decoration: new InputDecoration(
                isDense: true,
                border: UnderlineInputBorder(
                    borderSide: BorderSide(style: BorderStyle.solid, width: 0)),
                counterText: "",
              ),
              maxLength: 1,
              onChanged: (val) {
                if (val.length == 1) {
                  closeKeyBoard(context);
                }
              },
            ),
          ),
          SizedBox(width: 60.w,),
        ],
      ),
    );
  }

  Future sendOTP(action) async {
    setState(() {
      if (action == 1) loading = true;
      if (action == 2) resendLoader = true;
    });

    var mobile = await getMobile();

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
          // otpController = TextEditingController(text: "$reciveOtp");
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
