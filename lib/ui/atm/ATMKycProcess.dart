import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:moneypro_new/utils/SharedPrefs.dart';

class ATMKycProcess extends StatefulWidget {
  final String authToken;
  final String mATMId;
  const ATMKycProcess({Key? key,required this.authToken, required this.mATMId}) : super(key: key);

  @override
  _ATMKycProcessState createState() => _ATMKycProcessState();
}

class _ATMKycProcessState extends State<ATMKycProcess> {

  var screen = "ATM Kyc";

  TextEditingController otpController = new TextEditingController();

  var loadresend = false;
  var loadsubmit = false;
  var ekycPrimaryKeyId;
  var ekycTxnId;

  var loading = false;

  var isFingerCapture = false;

  String fingerData = "";

  var selectCatPos = "Select device";

  @override
  void initState() {
    super.initState();
    _getMerchEncyData(widget.mATMId);
    fetchUserAccountBalance();
    updateATMStatus(context);
  }

  @override
  void dispose() {
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
        backgroundColor: white,
        appBar: appBarHome(
        context,
        "",
        24.0.w,
    ),
    body: (loading)
    ? Center(
    child: circularProgressLoading(40.0),
    )
        : SingleChildScrollView(
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      SizedBox(height: 40.h,),
      Padding(
        padding: const EdgeInsets.only(left: 25.0, top:20),
        child: Text(
          "OTP send to your Aadhar linked mobile number",
          style: TextStyle(
            color: black,
            fontSize: font15.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 15, left: padding, right: padding),
        decoration: BoxDecoration(
          color: editBg,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 15.0, right: 15, top: 10, bottom: 10),
          child: TextFormField(
            style: TextStyle(color: black, fontSize: inputFont.sp),
            keyboardType: TextInputType.number,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            controller: otpController,
            decoration: new InputDecoration(
              isDense: true,
              border: InputBorder.none,
              contentPadding: EdgeInsets.only(left: 10),
              counterText: "",
              label: Text("Enter otp"),
            ),
            maxLength: 10,
          ),
        ),
      ),
      Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: editBg)),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            isExpanded: true,
            value: selectCatPos,
            style: TextStyle(color: black, fontSize: font13.sp),
            items:
            deviceList.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0),
                  child: Text(
                    value,
                    style: TextStyle(color: black),
                  ),
                ),
              );
            }).toList(),
            hint: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: Text(
                businessCat,
                style: TextStyle(color: lightBlack, fontSize: font13.sp),
              ),
            ),
            icon: Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Icon(
                // Add this
                Icons.keyboard_arrow_down, // Add this
                color: lightBlue, // Add this
              ),
            ),
            onChanged: (value) {
              setState(() {
                selectCatPos = value!;
                FocusScope.of(context).requestFocus(new FocusNode());
              });
            },
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 15, top: 20),
        child: Text(
          "Click on below icon to capture the fingerprint ",
          style: TextStyle(
            color: black,
            fontSize: font15.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      SizedBox(
        height: 20.h,
      ),
      Center(
        child: InkWell(
          onTap: () {
            printMessage("screen", "selectCatPos : $selectCatPos");
            if (selectCatPos.toString() == "Select device") {
              showToastMessage("Select your device");
            } else {
              getFingerPrintData(selectCatPos);
            }
          },
          child: Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(
                    color: (isFingerCapture) ? green : lightBlue,
                    width: 1)),
            child: Icon(
              Icons.fingerprint_rounded,
              size: 72,
              color: (isFingerCapture) ? green : lightBlue,
            ),
          ),
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25, top: 20),
        child: Text(
          "Before clicking submit, first confirm you have device connected with your mobile device.",
          style: TextStyle(
            color: black,
            fontSize: font13.sp,
          ),
          textAlign: TextAlign.center,
        ),
      ),
      Padding(
        padding: const EdgeInsets.only(top: 20.0, right: 20, left: 20),
        child: Row(
          children: [
            SizedBox(
              width: 5,
            ),
            Expanded(
              flex: 1,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: InkWell(
                  onTap: () {
                    resendOTPReq();
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius:
                        BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: lightBlue)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: (loadresend)
                            ? circularProgressLoading(15.0)
                            : Text(
                          resendOtp,
                          style: TextStyle(
                              color: white,
                              fontSize: font13.sp),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              flex: 1,
              child: Card(
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(32.0),
                ),
                child: InkWell(
                  onTap: () {
                    var otp = otpController.text.toString();

                    if (otp.length == 0) {
                      showToastMessage("Enter the otp");
                      return;
                    }

                    if (isFingerCapture) {
                      submitOTP(fingerData);
                    } else {
                      showToastMessage(
                          "Fingerprint not capture, please try again");
                    }
                  },
                  child: Container(
                    decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius:
                        BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: lightBlue)),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Center(
                        child: (loadsubmit)
                            ? circularProgressLoading(15.0)
                            : Text(
                          submit,
                          style: TextStyle(
                              color: white,
                              fontSize: font13.sp),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(
              width: 5,
            ),
          ],
        ),
      ),
    ])))));
  }

  _getMerchEncyData(merchantId) async {
    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      printMessage(screen, "Value merchantId : $merchantId");

      var arr = {
        "merchantId": "$merchantId",
      };

      String result = await platform.invokeMethod("getMidEnc", arr);

      printMessage(screen, "Mer Eyc Data : $result");

      var header = {
        "Authorization": "Bearer ${widget.authToken}",
        "Content-Type": "application/json"
      };

      final response = await http.post(Uri.parse(merKycATMUrl),
          headers: header,
          body: (result),
          encoding: Encoding.getByName("utf-8"));

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Kyc Response Data : $data");

      setState(() {
        var isSuccess = data['isSuccess'].toString();

        if (isSuccess.toString() == "true") {
          // call for OTP
          printMessage(screen, "Calling OTP");
          getKYCOTP(result);
        } else {
          //Navigator.pop(context);
          showToastMessage(somethingWrong);
        }
      });
    }
  }

  Future getKYCOTP(value) async {
    var header = {
      "Authorization": "Bearer ${widget.authToken}",
      "Content-Type": "application/json"
    };

    final response = await http.post(Uri.parse(kycOTPUrl),
        headers: header, body: (value), encoding: Encoding.getByName("utf-8"));

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "OTP Resoonse Data : $data");

    setState(() {
      var isSuccess = data['isSuccess'].toString();

      if (isSuccess.toString() == "true") {
        ekycPrimaryKeyId = data['data']['EkycPrimaryKeyId'].toString();
        ekycTxnId = data['data']['EkycTxnId'].toString();
      } else {
        Navigator.pop(context);
        showToastMessage(somethingWrong);
      }
    });
  }

  Future getFingerPrintData(deviceTpye) async {
    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "deviceType":"$deviceTpye"
      };

      fingerData = await platform.invokeMethod("getFinger", arr);

      printMessage(screen, "Fingerprint data : $fingerData");

      if (fingerData != "") {
        setState(() {
          isFingerCapture = true;
        });
      } else {
        setState(() {
          isFingerCapture = false;
          showToastMessage(somethingWrong);
        });
      }
    }
  }

  Future resendOTPReq() async {
    setState(() {
      loadresend = true;
    });

    String result = "";

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "ekycPrimaryKeyId": "$ekycPrimaryKeyId",
        "ekycTxnId": "$ekycTxnId",
        "merchant_Id": "${widget.mATMId}",
      };

      result = await platform.invokeMethod("resendOtp", arr);

      printMessage(screen, "Resned OTP json : $result");
    }

    var header = {
      "Authorization": "Bearer ${widget.authToken}",
      "Content-Type": "application/json"
    };

    final response = await http.post(Uri.parse(kycResendOtp),
        headers: header, body: (result), encoding: Encoding.getByName("utf-8"));

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Resend OTP Data : $data");

    setState(() {
      loadresend = false;
      var isSuccess = data['isSuccess'].toString();

      if (isSuccess.toString() == "true") {
        showToastMessage("OTP send to your Aadhar linked mobile number");
      } else {
        showToastMessage(somethingWrong);
      }
    });
  }

  Future submitOTP(fdata) async {
    setState(() {
      loadsubmit = true;
    });

    var otp = otpController.text.toString();

    String result = "";

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "otp": "$otp",
        "ekycPrimaryKeyId": "$ekycPrimaryKeyId",
        "ekycTxnId": "$ekycTxnId",
        "merchant_Id": "${widget.mATMId}",
        "fingerprintData": "$fdata"
      };

      result = await platform.invokeMethod("submitOtp", arr);

      printMessage(screen, "Submit OTP json : $result");
    }

    var header = {
      "Authorization": "Bearer ${widget.authToken}",
      "Content-Type": "application/json"
    };

    final response = await http.post(Uri.parse(kycProcess),
        headers: header, body: (result), encoding: Encoding.getByName("utf-8"));

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Submit OTP Data : $data");

    setState(() {
      loadsubmit = false;
      var isSuccess = data['isSuccess'].toString();

      if (isSuccess.toString() == "true") {
        checkKycStatus();
      } else {
        showToastMessage(data['data']['remarks'].toString());
        // removeAllPages(context);
      }
    });
  }

  Future checkKycStatus() async {
    var email = await getEmail();
    var mobile = await getMobile();

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");
      var arr = {
        "merchant_id": "${widget.mATMId}",
        "emailId": "$email",
        "mobileNo": "$mobile"
      };

      String result = await platform.invokeMethod("kycStatus", arr);
      printMessage(screen, "KYC OTP json : $result");

      var header = {
        "Authorization": "Bearer ${widget.authToken}",
        "Content-Type": "application/json"
      };

      final response = await http.post(Uri.parse(merchantStatusKYC),
          headers: header,
          body: (result),
          encoding: Encoding.getByName("utf-8"));

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "KYC Status Data : $data");

      setState(() {
        loadresend = false;
        var isSuccess = data['isSuccess'].toString();

        if (isSuccess.toString() == "true") {
          Navigator.pop(context);
          var sta = data['data']['statusDescription'].toString();
          var statusCode = data['data']['statusCode'].toString();
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ThankYouDialog(
                  text: "$sta",
                  isCloseAll: "1".toString(),
                );
              });
        } else {
          Navigator.pop(context);
          showToastMessage(somethingWrong);
        }
      });
    }
  }

}
