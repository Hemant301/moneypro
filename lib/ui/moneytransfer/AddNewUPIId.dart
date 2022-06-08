import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class AddNewUPIId extends StatefulWidget {
  const AddNewUPIId({Key? key}) : super(key: key);

  @override
  _AddNewUPIIdState createState() => _AddNewUPIIdState();
}

class _AddNewUPIIdState extends State<AddNewUPIId> {
  var screen = "Add new UPI id";

  TextEditingController upiIdController = new TextEditingController();

  var isUPIEntered = false;

  var isUPIValid = false;

  var upiName = "";

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              backgroundColor: white,
              appBar: AppBar(
                elevation: 0,
                centerTitle: false,
                backgroundColor: white,
                leading: InkWell(
                  onTap: () {
                    closeKeyBoard(context);
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
                    'assets/faq.png',
                    width: 24.w,
                    color: orange,
                  ),
                  SizedBox(
                    width: 10.w,
                  )
                ],
              ),
              body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    SizedBox(
                      height: 20.h,
                    ),
                    Card(
                      elevation: 10,
                      margin: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 20),
                              child: Text(
                                "Add your UPI ID",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              height: 10.h,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, top: 0),
                              child: Text(
                                "You can send or request money to the UPI ID of your contact. The name of the contact is returned on successful verification of the UPI ID.",
                                style: TextStyle(
                                  color: lightBlack,
                                  fontSize: font14.sp,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 0,
                            ),
                            Container(
                              height: 40.h,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  top: 15, left: 15, right: 15, bottom: 15),
                              decoration: BoxDecoration(
                                color: editBg,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Center(
                                child: TextFormField(
                                  style: TextStyle(
                                      color: black, fontSize: 14.sp),
                                  keyboardType: TextInputType.text,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  textInputAction: TextInputAction.next,
                                  controller: upiIdController,
                                  decoration: new InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 20),
                                    counterText: "",
                                    label: Text("UPI id"),
                                  ),
                                  maxLength: 30,
                                  onChanged: (val) {
                                    if (val.toString().contains("@")) {
                                      setState(() {
                                        isUPIEntered = true;
                                      });
                                    } else {
                                      setState(() {
                                        isUPIEntered = false;
                                      });
                                    }
                                  },
                                ),
                              ),
                            ),
                            (isUPIValid)
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 20.0, bottom: 5),
                                    child: Text(
                                      "Registered Name",
                                      style: TextStyle(
                                          color: black, fontSize: font13.sp),
                                    ),
                                  )
                                : Container(),
                            (isUPIValid)
                                ? Container(
                                    height: 40,
                                    width: MediaQuery.of(context).size.width,
                                    margin: EdgeInsets.only(
                                        top: 0,
                                        left: 15,
                                        right: 15,
                                        bottom: 20),
                                    decoration: BoxDecoration(
                                      color: editBg,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Padding(
                                      padding:
                                          EdgeInsets.only(left: 20, top: 14),
                                      child: Text(
                                        "$upiName",
                                        style: TextStyle(
                                            color: black, fontSize: 14.sp),
                                      ),
                                    ),
                                  )
                                : Container(),
                            (isUPIValid)?Container():  Row(
                              children: [
                                Spacer(),
                                InkWell(
                                  onTap: () {
                                    var upiId = upiIdController.text.toString();
                                    if (upiId.length == 0) {
                                      showToastMessage("enter your UPI ID");
                                      return;
                                    }
                                    closeKeyBoard(context);
                                    generatePayoutToken(upiId);
                                  },
                                  child: Container(
                                    height: 40.h,
                                    margin: EdgeInsets.only(
                                        top: 0, left: 0, right: 10, bottom: 20),
                                    decoration: BoxDecoration(
                                      color: (isUPIEntered) ? lightBlue : gray,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30.0, right: 30),
                                        child: Text(
                                          "Verify",
                                          style: TextStyle(
                                              fontSize: font16.sp, color: white),
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ])),
              bottomNavigationBar: _buildButton(),
            )));
  }

  _buildButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
      child: InkWell(
        onTap: () {
          var id = upiIdController.text.toString();
          openSendUPIMoney(context, upiName, id, true);
        },
        child: Container(
          height: 45.h,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
          decoration: BoxDecoration(
            color: (isUPIValid) ? lightBlue : gray,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Center(
            child: Text(
              "Send Money".toUpperCase(),
              style: TextStyle(fontSize: font16.sp, color: white),
            ),
          ),
        ),
      ),
    );
  }

  Future generatePayoutToken(upiId) async {
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

    final response =
        await http.post(Uri.parse(payoutTokenGenerateAPI), headers: headers);

    var statusCode = response.statusCode;
    Navigator.pop(context);
    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Response Token : $data");
      var token = data['result']['access_token'];
      validateUPIId(token, upiId);
    } else {
      setState(() {
        showToastMessage(somethingWrong);
      });
    }
  }

  Future validateUPIId(accessToken, code) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, we will check your UPI ID");
          });
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    printMessage(screen, "headers : $headers");

    final body = {"vpa": "$code".toString(), "access_token": accessToken};

    printMessage(screen, "BODY : $body");

    final response = await http.post(Uri.parse("$upiIdCheckingAPI"),
        headers: headers, body: jsonEncode(body));

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "IFSC Code : $data");

      Navigator.pop(context);

      setState(() {
        if (data['status'].toString() == "1") {
          if (data['result']['status'].toString() == "0") {
            upiName = data['result']['data']['name'].toString();
            isUPIValid = true;
          } else {
            showToastMessage("${data['result']['data']['message'].toString()}");
            isUPIValid = false;
          }
        } else {
          isUPIValid = false;
          showToastMessage(somethingWrong);
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
        isUPIValid = false;
      });
      showToastMessage(status500);
    }
  }
}
