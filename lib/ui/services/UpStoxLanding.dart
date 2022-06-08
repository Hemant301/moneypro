import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/AppKeys.dart';



class UpStoxLanding extends StatefulWidget {
  const UpStoxLanding({Key? key}) : super(key: key);

  @override
  _UpStoxLandingState createState() => _UpStoxLandingState();
}

class _UpStoxLandingState extends State<UpStoxLanding> {
  var screen = "Upstox Landing";

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(context, "", 24.0.w),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                        "assets/upstox_banner_2.jpeg",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
        Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 10),
          child: Text(
            upstox_1,
            style: TextStyle(
                color: black, fontSize: font20.sp, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
        ),
        Center(
          child: Text(
            upstox_2,
            style: TextStyle(
                color: black, fontSize: font16.sp, fontWeight: FontWeight.bold),
          ),
        ),
        Center(
          child: Text(
            upstox_3,
            style: TextStyle(
                color: black, fontSize: font14.sp, fontWeight: FontWeight.normal),
          ),
        ),
        Center(
          child: Padding(
            padding: const EdgeInsets.only(
                left: 60.0, right: 60, top: 20, bottom: 10),
            child: Text(
              upstox_4,
              style: TextStyle(
                  color: black, fontSize: font15.sp, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        Row(
          children: [
            SizedBox(
              width: 10.w,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$rupeeSymbol 0",
                  style: TextStyle(
                      color: black,
                      fontSize: font26.sp,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  upstox_5,
                  style: TextStyle(
                      color: black,
                      fontSize: font26.sp,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                  child: Text(
                    upstox_7,
                    style: TextStyle(
                        color: black,
                        fontSize: font14.sp,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )),
            SizedBox(
              width: 10.w,
            ),
            Expanded(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "$rupeeSymbol 0",
                  style: TextStyle(
                      color: black,
                      fontSize: font26.sp,
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  upstox_6,
                  style: TextStyle(
                      color: black,
                      fontSize: font26.sp,
                      fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30, top: 5),
                  child: Text(
                    upstox_8,
                    style: TextStyle(
                        color: black,
                        fontSize: font14.sp,
                        fontWeight: FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                )
              ],
            )),
            SizedBox(
              width: 10.w,
            ),
          ],
        ),
      ])),
      bottomNavigationBar: _buildBotton(),
    )));
  }

  Future generateJwtToken() async {
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
          openUpstoxLeadGenerate(jwtToken);
        } else {
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  Future openUpstoxLeadGenerate(token) async {
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
      "type": "upstox"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(openUpstoxLeadAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Upstox : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          var url = data['result']['data'].toString();
          openBrowser(url);
        } else {
          showToastMessage(somethingWrong);
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
    return Wrap(
      children: [
        InkWell(
          onTap: () {
            setState(() {
              generateJwtToken();
            });
          },
          child: Container(
            height: 45.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Center(
              child: Text(
                "INVEST NOW",
                style: TextStyle(fontSize: font16.sp, color: white),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
