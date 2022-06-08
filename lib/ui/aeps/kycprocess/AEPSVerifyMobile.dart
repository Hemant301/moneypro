import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Countdown.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:moneypro_new/utils/AppKeys.dart';


class AEPSVerifyMobile extends StatefulWidget {
  const AEPSVerifyMobile({Key? key}) : super(key: key);

  @override
  _AEPSVerifyMobileState createState() => _AEPSVerifyMobileState();
}

class _AEPSVerifyMobileState extends State<AEPSVerifyMobile>
    with TickerProviderStateMixin {
  var screen = "AEPS Verify Mobile";
  var showOTP = false;

  final otpController = new TextEditingController();

  var completeAddress = "";
  var pincode = "";
  var mobileNumber = "";
  String _code = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);
    updateWalletBalances();
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();
    double mX =0.0;
    double wX=0.0;
    var m = await getMobile();

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
    setState(() {
      mobileNumber = m;
    });


    sendOTPTask(mobileNumber);

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(
        context,
        "",
        24.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            Center(
                child: Image.asset(
              'assets/otp_get.png',
              height: 250,
            )),
            SizedBox(
              height: 40,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35),
              child: Text(
                "We have sent 6 Digit OTP to your mobile number",
                style: TextStyle(
                    color: black,
                    fontSize: font13,
                    height: 1.5,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 35.0, right: 35),
              child: Text(
                "+91-$mobileNumber",
                style: TextStyle(
                    color: black,
                    fontSize: font16,
                    height: 1.5,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            Card(
                elevation: 15,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                margin: EdgeInsets.only(top: 20, left: 15, right: 15),
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          _buildInputBox(),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            height: 40,
                            margin: EdgeInsets.only(
                                left: 40, right: 40, top: 20, bottom: 20),
                            decoration: BoxDecoration(
                                color: lightBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                border: Border.all(color: lightBlue)),
                            child: InkWell(
                              onTap: () {
                                var _code = otpController.text.toString();

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
                                    fontSize: font14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ]))),
            SizedBox(
              height: 40,
            ),
            InkWell(
              onTap: () {
                //reSendOTP(widget.mobile);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Re-send OTP",
                    style: TextStyle(color: lightBlue, fontSize: font12),
                  ),
                  SizedBox(
                    width: 3,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ));
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
        onCodeSubmitted: (code) {},
        onCodeChanged: (code) {
          setState(() {
            _code = code!;
          });
        },
      ),
    );
  }

  Future sendOTPTask(mobileNumber) async {
    printMessage(screen, "Phone : $mobileNumber");

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

    final body = {
      "mobile": mobileNumber,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(userAEPSOnboardingAPI),
        body: jsonEncode(body), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : $data");

      setState(() {
        Navigator.pop(context);
        var status = data['status'];

        if (status.toString() == "1") {
          showOTP = true;
        }
        showToastMessage(data['message']);
      });
    }else{
      setState(() {
        Navigator.pop(context);
        showOTP = false;
      });
      showToastMessage(status500);
    }


  }

  Future submitOTPTask(otp) async {
    var mId = await getMerchantID();
    var email = await getEmail();
    var company = await getComapanyName();
    var name = await getContactName();
    var pan = await getPANNo();
    var mobile = await getMobile();

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

    final body = {
      "m_id": "$mId",
      "mobile": "$mobile",
      "email": "$email",
      "company": "$company",
      "name": "$name",
      "pan": "$pan",
      "pincode": "$pincode",
      "address": "$completeAddress",
      "otp": otp,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(userRegistrationAepsAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");

      setState(() {
        Navigator.pop(context);
        var status = data['status'];

        if (status.toString() == "1") {
          openAEPSDocument(context, pan);
        }
        showToastMessage(data['message']);
      });
    }else{
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }


  }
}
