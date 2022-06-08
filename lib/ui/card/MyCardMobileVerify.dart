import 'dart:io';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:moneypro_new/ui/models/District.dart';
import 'package:moneypro_new/ui/models/States.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MyCardMobileVerify extends StatefulWidget {
  const MyCardMobileVerify({Key? key}) : super(key: key);

  @override
  _MyCardMobileVerifyState createState() => _MyCardMobileVerifyState();
}

class _MyCardMobileVerifyState extends State<MyCardMobileVerify> {


  var loading = false;

  var screen = "Card Mobile";

  var mobileNumber = "";

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

  var otpReference = "";

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    getUserDetail();
    getOtpForMobile();
  }

  getUserDetail() async {
    var mobile = await getMobile();
    var m = await generateXFormat(mobile.toString());
    setState(() {
      mobileNumber = m;
    });


  }


  @override
  void dispose() {
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
    return SafeArea(
        child: Scaffold(
      backgroundColor: white,
      body: (loading)?Center(
        child: circularProgressLoading(40.0),
      ):SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(20.0)),
                    color: lightBlue,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 15.0, top: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            InkWell(
                              onTap: () {
                                closeKeyBoard(context);
                                closeCurrentPage(context);
                              },
                              child: Icon(
                                Icons.arrow_back,
                                color: white,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, top: 10, right: 25),
                              child: Text(
                                "Avail your card credit limit at 0% interest",
                                style: TextStyle(color: white, fontSize: 25),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 25.0, right: 25, top: 10, bottom: 20),
                              child: Text(
                                "Enter the OTP sent to your mobile number +91-$mobileNumber  to complete the process.",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: white,
                                  fontSize: font15,),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Card(
              margin: EdgeInsets.only(left: 10, right: 10, top: 8),
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: Image.asset(
                    "assets/kyc_banner.png",
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 20),
              child: Text("Enter OTP",
              style: TextStyle(
                color: black, fontSize: font16
              ),),
            ),
            _buildInputBox(),

          ],
        ),
      ),
      bottomNavigationBar: InkWell(
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

          submitOTP(otp);

        },
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Center(
            child: Text(
              "$submit".toUpperCase(),
              style: TextStyle(fontSize: font16, color: white),
            ),
          ),
        ),
      ),
    ));
  }

  Future getOtpForMobile() async {
    setState(() {
      loading = true;
    });

    var userToken = await getToken();
    var mobile = await getMobile();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "mobile":"$mobile"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(userRegistrationCardAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
          otpReference = data['otpReference'].toString();
        }else{
          showToastMessage(data['message'].toString());
        }
      });
    }else{
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }


  }

  _buildInputBox() {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        color: editBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      margin:
      EdgeInsets.only(top: 10, left: padding, right: padding),
      child: Row(
        children: [
          SizedBox(width: 60,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node00,
              textAlign: TextAlign.center,
              style: TextStyle(color: black, fontSize: inputFont),
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
          SizedBox(width: 15,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node01,
              textAlign: TextAlign.center,
              style: TextStyle(color: black, fontSize: inputFont),
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
          SizedBox(width: 15,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node02,
              textAlign: TextAlign.center,
              style: TextStyle(color: black, fontSize: inputFont),
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
          SizedBox(width: 15,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node03,
              textAlign: TextAlign.center,
              style: TextStyle(color: black, fontSize: inputFont),
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
          SizedBox(width: 15,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node04,
              textAlign: TextAlign.center,
              style: TextStyle(color: black, fontSize: inputFont),
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
          SizedBox(width: 15,),
          Expanded(
            flex: 1,
            child: TextFormField(
              focusNode: node05,
              textAlign: TextAlign.center,
              style: TextStyle(color: black, fontSize: inputFont),
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
          SizedBox(width: 60,),
        ],
      ),
    );
  }

  Future submitOTP(otp) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();
    var mobile = await getMobile();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "mobile":"$mobile",
      "otpReference":"$otpReference",
      "otp":"$otp"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(verifyUserRegistrationCardAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
          //openMyCardCongrats(context);
          var authToken = data['authToken'].toString();
          openMyCardKyc(context, authToken);
        }else{
          showToastMessage(data['message'].toString());
        }
      });
    }else{
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }


  }

}
