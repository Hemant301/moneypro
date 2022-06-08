import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class AxisBankLanding extends StatefulWidget {
  const AxisBankLanding({Key? key}) : super(key: key);

  @override
  _AxisBankLandingState createState() => _AxisBankLandingState();
}

class _AxisBankLandingState extends State<AxisBankLanding> {
  var screen = "Axis Bank";

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
            backgroundColor: white,
            appBar: appBarHome(context, "", 24.0.w),
            body: SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                            "assets/axis_banner.jpeg",
                            fit: BoxFit.fill,
                            height: 210.h,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                      child: Text(
                        axis_1,
                        style: TextStyle(
                            color: black,
                            fontSize: font20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                      child: Text(
                        axis_2,
                        style: TextStyle(
                            color: black,
                            fontSize: font14.sp,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                      child: Row(
                        children: [
                      Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: lightBlue),
                        shape: BoxShape.circle,
                      ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("1", style: TextStyle(
                              color: lightBlue,
                              fontWeight: FontWeight.bold,
                              fontSize: font16.sp
                            ),),
                          ),
                        )),SizedBox(width: 10.w,),
                          Expanded(
                            child: Text(
                              axis_3,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 5),
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: lightBlue),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("2", style: TextStyle(
                                      color: lightBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: font16.sp
                                  ),),
                                ),
                              )),SizedBox(width: 10.w,),
                          Expanded(
                            child: Text(
                              axis_4,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 5),
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: lightBlue),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("3", style: TextStyle(
                                      color: lightBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: font16.sp
                                  ),),
                                ),
                              )),SizedBox(width: 10.w,),
                          Expanded(
                            child: Text(
                              axis_5,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 5),
                      child: Row(
                        children: [
                          Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: lightBlue),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text("4", style: TextStyle(
                                      color: lightBlue,
                                      fontWeight: FontWeight.bold,
                                      fontSize: font16.sp
                                  ),),
                                ),
                              )),SizedBox(width: 10.w,),
                          Expanded(
                            child: Text(
                              axis_6,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                      child: Text(
                        axis_7,
                        style: TextStyle(
                            color: black,
                            fontSize: font14.sp,
                            fontWeight: FontWeight.w300),
                      ),
                    ),
                  ]),
            ),
        bottomNavigationBar: _buildBotton(),)));
  }

  Future generateJwtToken(action) async {
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

    final body = {};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(jwtTokenAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      Navigator.pop(context);
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          var jwtToken = data['token'].toString();
          if(action==1){
            openCurrentAccount(jwtToken);
          }

          if(action==2){
            openSavingAccount(jwtToken);
          }

        } else {
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  Future openCurrentAccount(token) async {
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

    var userToken = await getToken();
    var merchantcid = await getMerchantID();

    final body = {
      "user_token": "$userToken",
      "merchantcid": "$merchantcid",
      "token": "$token",
      "type":"axis"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(openCurrentAccountAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Axis : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          var url = data['result']['data'].toString();
          openBrowser(url);
        } else {
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

  Future openSavingAccount(token) async {
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

    var userToken = await getToken();
    var merchantcid = await getMerchantID();

    final body = {
      "user_token": "$userToken",
      "merchantcid": "$merchantcid",
      "token": "$token",
      "type":"axis"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(openSavingAccountAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Saving Axis : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          var url = data['result']['data'].toString();
          openBrowser(url);
        } else {
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

  _buildBotton() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
      child: Row(
        children: [
          /*Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  generateJwtToken(1);
                });
              },
              child: Container(
                height: 45.h,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    "Current Account",
                    style: TextStyle(fontSize: font16.sp, color: white),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(width: 20.w,),*/
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                setState(() {
                  generateJwtToken(2);
                });
              },
              child: Container(
                height: 45.h,
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    "Saving Account",
                    style: TextStyle(fontSize: font16.sp, color: white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
