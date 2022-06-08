import 'dart:async';
import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:path_provider/path_provider.dart';

class ViewQRCode extends StatefulWidget {
  final int action;

  const ViewQRCode({Key? key, required this.action}) : super(key: key);

  @override
  _ViewQRCodeState createState() => _ViewQRCodeState();
}

class _ViewQRCodeState extends State<ViewQRCode> {
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  var screen = "View QR";

  var loading = false;

  var base64String = "";
  var merchantVpa = "";

  @override
  void initState() {
    super.initState();
    getUserDetails();
    generateQR();
    updateATMStatus(context);
    fetchUserAccountBalance();

    printMessage(screen, "Action : ${widget.action}");
  }

  getUserDetails() async {
    var fn = await getComapanyName();
    var qrName = await getQRDisplayName();
    setState(() {
      if(qrName.toString()=="null" || qrName.toString()==""){
        companyName = fn;
      }else{
        companyName = qrName;
      }

    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>WillPopScope(
        onWillPop: () async {
          printMessage(screen, "Mobile back pressed");
          removeAllPages(context);
          return false;
        },
        child: SafeArea(
            child: Scaffold(
                appBar: AppBar(
                  elevation: 0,
                  centerTitle: false,
                  backgroundColor: white,
                  brightness: Brightness.light,
                  leading: IconButton(
                    icon: Image.asset(
                      'assets/home.png',
                      height: 24.h,
                      color: homeOrage,
                    ),
                    onPressed: () {
                      closeKeyBoard(context);
                      removeAllPages(context);
                    },
                  ),
                  titleSpacing: 0,
                  title: appLogo(),
                  actions: [
                    InkWell(
                      onTap: () {
                        shareTransReceipt(_printKey, "recipt");
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.asset(
                          'assets/share.png',
                          color: lightBlue,
                        ),
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        downloadReceiptAsPDF(_printKey);
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Image.asset(
                          'assets/download_file.png',
                          color: lightBlue,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    )
                  ],
                ),
                body: (loading)
                    ? Center(
                        child: circularProgressLoading(40.0),
                      )
                    : RepaintBoundary(
                        key: _printKey,
                        child: Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.height,
                          color: white,
                          child: Stack(children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height,
                              decoration: BoxDecoration(
                                color: blue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(0)),
                              ),
                              child: Column(
                                children: [
                                  Expanded(
                                      flex: 2,
                                      child: Column(
                                        children: [
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          Image.asset(
                                            'assets/quickpe.png',
                                            height: 45.h,
                                          ),
                                          Container(
                                            margin: EdgeInsets.only(top: 20),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: orange,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                            ),
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Text(
                                                  "$companyName",
                                                  style: TextStyle(
                                                      color: white,
                                                      fontSize: font18.sp),
                                                  textAlign: TextAlign.center,
                                                  maxLines: 1,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(
                                            height: 20.h,
                                          ),
                                          _buildQRSection(),
                                          Padding(
                                            padding: EdgeInsets.all(16),
                                            child: Center(
                                                child: Text(
                                              "${replaceText(merchantVpa)}",
                                              style: TextStyle(
                                                  color: white,
                                                  fontSize: font16.sp,
                                                  fontWeight: FontWeight.w600),
                                            )),
                                          ),
                                          Spacer(),
                                          Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.vertical(
                                                      top: Radius.circular(
                                                          50.0)),
                                              color: white,
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.grey
                                                      .withOpacity(0.5),
                                                  spreadRadius: 10,
                                                  blurRadius: 10,
                                                  offset: Offset(0,
                                                      1), // changes position of shadow
                                                ),
                                              ],
                                            ),
                                            child: Column(
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
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25,
                                                          top: 20),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Expanded(
                                                          child: Image.asset(
                                                        'assets/paytm.png',
                                                        height: 20.h,
                                                      )),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Expanded(
                                                          child: Image.asset(
                                                        'assets/gpay.png',
                                                        height: 20.h,
                                                      )),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Expanded(
                                                          child: Image.asset(
                                                        'assets/upi.png',
                                                        height: 20.h,
                                                      )),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Expanded(
                                                          child: Image.asset(
                                                        'assets/sbibank.png',
                                                        height: 20.h,
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 15.h,
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 25.0,
                                                          right: 25,
                                                          top: 20),
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Expanded(
                                                          child: Image.asset(
                                                        'assets/jiomoney.png',
                                                        height: 36.h,
                                                      )),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Expanded(
                                                          child: Image.asset(
                                                        'assets/freecharge.png',
                                                        height: 36.h,
                                                      )),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Expanded(
                                                          child: Image.asset(
                                                        'assets/phonepe.png',
                                                        height: 36.h,
                                                      )),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Expanded(
                                                          child: Image.asset(
                                                        'assets/oxegn.png',
                                                        height: 36.h,
                                                      )),
                                                      SizedBox(
                                                        width: 2.w,
                                                      ),
                                                      Expanded(
                                                          child: Image.asset(
                                                        'assets/mobiwiki.png',
                                                        height: 36.h,
                                                      )),
                                                    ],
                                                  ),
                                                ),
                                                SizedBox(
                                                  height: 40.h,
                                                ),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Text(
                                                      powered_by,
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: 14.h,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    Image.asset(
                                                      'assets/app_splash_logo.png',
                                                      width: 110.w,
                                                    )
                                                  ],
                                                ),
                                                SizedBox(
                                                  height: 10.h,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                            )
                          ]),
                        ))))));
  }

  _buildQRSection() {
    return Container(
      width: MediaQuery.of(context).size.width * .6.w,
      height: MediaQuery.of(context).size.height * .30.h,
      child: Image.memory(
        base64Decode(base64String),
        fit: BoxFit.cover,
      ),
    );
  }

  Future generateQR() async {
    setState(() {
      loading = true;
    });

    var token = await getToken();
    var companyName = await getComapanyName();
    var qrName = await getQRDisplayName();

    if (companyName.length > 20) {
      companyName = companyName
          .toString()
          .substring(0, 20);
    }

    printMessage(screen, "Compant Name : $companyName");

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": token,
      "company_name": (qrName.toString()=="null" || qrName.toString()=="")?companyName:qrName,
    };

    printMessage(screen, "body qr : $body");

    final response = await http.post(Uri.parse(qrGenerateMerchantAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Generate QR : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
        }
        downloadQR();
      });
    }else{
      setState(() {

      });
      showToastMessage("$status500");
    }


  }

  Future downloadQR() async {
    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": token,
    };

    printMessage(screen, "headers : $body");

    final response = await http.post(Uri.parse(merchantQrAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response QR  : ${data}");

      setState(() {
        final myString = data['qr'][0]['qrString'].toString();
        merchantVpa = data['qr'][0]['merchantVpa'].toString();
        base64String = myString.replaceAll(RegExp('data:image/png;base64,'), '');
        loading = false;
      });

      if (widget.action == 1) {
        printMessage(screen, "Taking screenshot");
        Timer(Duration(seconds: 2), () {
          getQRScreenShot();
          autoInvestEnable();
        });

      }else{
      setState(() {
        loading = false;
      });
    }

   }
  }

  String replaceText(value) {
    if (value.toString().contains("payu")) {
      value = value.replaceAll("moneypro.payu", "");
    }

    if (value.toString().contains("yellowqr")) {
      value = value.replaceAll("yellowqr.prowealth.", "");
    }
    if (value.toString().contains(".")) {
      value = value.replaceAll(".", "");
    }
    return "$value";
  }

  getQRScreenShot() async {
    RenderRepaintBoundary boundary =
        _printKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    File imgFile = new File('$directory/merchantQR.png');
    await imgFile.writeAsBytes(pngBytes!);

    imgFile.exists();
    uploadQRPreview(imgFile);
  }

  void uploadQRPreview(File file) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while uploading your data to server");
          });
    });

    String fileName = file.path.split('/').last;

    var token = await getToken();

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromBytes(File(file.path).readAsBytesSync(),
          filename: fileName),
      "token": token,
    });

    Dio dio = new Dio();

    dio.post(qrImageUploadMerchantAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      Navigator.pop(context);

      printMessage(screen, "Status Code : ${msg['message']}");

      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            merchantWAMsg();
          } else {
            showToastMessage(msg['message'].toString());
          }
        });
      } else {
        showToastMessage("$status500");
        printMessage(screen, "Error : ${response}");
      }
    }).catchError((error) => print(error));
  }

  Future merchantWAMsg() async {
    var token = await getToken();
    var fname = await getFirstName();
    var lname = await getLastName();
    var mobile = await getMobile();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": token,
      "user_name":"$fname $lname",
      "mobile":"$mobile"

    };

    printMessage(screen, "headers : $body");

    final response = await http.post(Uri.parse(wpMerchantRegAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response WM  : ${data}");

    setState(() {

    });
  }

  Future autoInvestEnable() async {

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"token": "$token", "qr_money_invst": "No"};

    printMessage(screen, "Auto body : $body");

    final response = await http.post(Uri.parse(marchantQrAutoInvestAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Auto Response On : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          saveQRInvestor("Yes");
        } else if (data['status'].toString() == "4") {
          saveQRInvestor("No");
        }
      });
    }else{
      setState(() {

      });
      showToastMessage("$status500");
    }


  }
}
