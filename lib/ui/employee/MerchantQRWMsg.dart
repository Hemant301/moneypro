import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/QRList.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:path_provider/path_provider.dart';

class MerchantQRWMsg extends StatefulWidget {
  final String mToken, name, mobile, companyName,qrDisplayName;

  const MerchantQRWMsg(
      {Key? key,
      required this.mToken,
      required this.name,
      required this.mobile,
      required this.companyName,
      required this.qrDisplayName})
      : super(key: key);

  @override
  _MerchantQRWMsgState createState() => _MerchantQRWMsgState();
}

class _MerchantQRWMsgState extends State<MerchantQRWMsg> {
  var screen = "Merchant Whats Msg";

  var loading = false;

  List<Qr> qrLists = [];

  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  late File imgFile;

  @override
  void initState() {
    super.initState();
    printMessage(screen, "M TOKEN : ${widget.mToken}");
    downloadQR();
    updateATMStatus(context);
    fetchUserAccountBalance();
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
        backgroundColor: white,
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: white,
          leading: InkWell(
            onTap: () {
              closeKeyBoard(context);
              removeAllPages(context);
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
            InkWell(
              onTap: (){
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return sendWhatsAppMsg(
                        token: "${widget.mToken}",
                        name: "${widget.name}",
                        mobile: "${widget.mobile}",
                        mFile: imgFile,
                      );
                    });
              },
              child: Image.asset(
                'assets/whatsapp.png',
                width: 30.w,
              ),
            ),
            SizedBox(
              width: 20.w,
            )
          ],
        ),
        body: (loading)
            ? Center(
                child: circularProgressLoading(40.0),
              )
            : (qrLists.length == 0)
                ? NoDataFound(text: '')
                : _buildQrPreview(),
      )),
    ));
  }

  String replaceText(value) {
    if (value.toString().contains("payu")) {
      value = value.replaceAll("moneypro.payu", "");
    }

    if (value.toString().contains("yellowqr")) {
      value = value.replaceAll("yellowqr.prowealth.", "");
    }

    return "$value";
  }

  _buildQrPreview() {
    return RepaintBoundary(
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
                borderRadius: BorderRadius.all(Radius.circular(0)),
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
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: orange,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  "${widget.qrDisplayName}",
                                  style:
                                      TextStyle(color: white, fontSize: font18.sp),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
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
                              "${replaceText(qrLists[0].merchantVpa)}",
                              style: TextStyle(
                                  color: white,
                                  fontSize: font16.sp,
                                  fontWeight: FontWeight.w600),
                            )),
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(50.0)),
                              color: white,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 10,
                                  blurRadius: 10,
                                  offset: Offset(
                                      0, 1), // changes position of shadow
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
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25, top: 40),
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
                                  height: 20.h,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25, top: 20),
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
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      powered_by,
                                      style: TextStyle(
                                          color: black,
                                          fontSize: 14.sp,
                                          fontWeight: FontWeight.bold),
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
        ));
  }

  _buildQRSection() {
    return Container(
      width: MediaQuery.of(context).size.width * .6,
      height: MediaQuery.of(context).size.height * .30,
      child: Image.memory(
        base64Decode(qrLists[0]
            .qrString
            .toString()
            .replaceAll(RegExp('data:image/png;base64,'), '')),
        fit: BoxFit.cover,
      ),
    );
  }

  Future downloadQR() async {
    setState(() {
      loading = true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "${widget.mToken}",
    };

    printMessage(screen, "headers : $body");

    final response = await http.post(Uri.parse(merchantQrAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          var result =
          QrList.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          qrLists = result.qr;
          printMessage(screen, "Response QR  : ${qrLists.length}");
          autoInvestEnable();
          WhatsAppOptIn();
        } else {
          showToastMessage(somethingWrong);
        }
      });
    }else{
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }


  }

  Future WhatsAppOptIn() async {
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "mobile": "${widget.mobile}",
      "user_token": "${widget.mToken}"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(optInWpAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;
    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Whats Data : $data");
      if (data['status'].toString() == "1") {
        getQRScreenShot();
      }
    }else{
      setState(() {

      });
      showToastMessage(status500);
    }
  }

  getQRScreenShot() async {
    RenderRepaintBoundary boundary =
        _printKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    imgFile = new File('$directory/merchantQR.png');
    await imgFile.writeAsBytes(pngBytes!);

    imgFile.exists();
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return sendWhatsAppMsg(
            token: "${widget.mToken}",
            name: "${widget.name}",
            mobile: "${widget.mobile}",
            mFile: imgFile,
          );
        });
  }

  Future autoInvestEnable() async {

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"token": "${widget.mToken}", "qr_money_invst": "No"};

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
      showToastMessage(status500);
    }


  }
}

class sendWhatsAppMsg extends StatelessWidget {
  final String token;
  final String name;
  final String mobile;
  final File mFile;

  const sendWhatsAppMsg(
      {Key? key,
      required this.token,
      required this.name,
      required this.mobile,
      required this.mFile})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(padding),
      ),
      elevation: 0,
      backgroundColor: Colors.transparent,
      child: contentBox(context),
    );
  }

  contentBox(context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>Container(
      margin: EdgeInsets.only(top: avatarRadius),
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
          shape: BoxShape.rectangle,
          color: Colors.white,
          borderRadius: BorderRadius.circular(padding),
          boxShadow: [
            BoxShadow(
                color: Colors.black, offset: Offset(0, 10), blurRadius: 10),
          ]),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(
            height: 20.h,
          ),
          Image.asset(
            "assets/whatsapp.png",
            height: 60.h,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 10, bottom: 10),
            child: Text(
              "Would you like to send your QR to your Whatsapp number?",
              style: TextStyle(fontSize: font16.sp, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      removeAllPages(context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            color: white,
                          )),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "No",
                            style: TextStyle(fontSize: 18.sp, color: white),
                          ),
                        ),
                      ),
                    )),
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                    onTap: () {
                      Navigator.of(context).pop();
                      uploadQRPreview(mFile,context);
                    },
                    child: Container(
                      margin: EdgeInsets.only(left: 20, right: 10),
                      decoration: BoxDecoration(
                          color: green,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            color: white,
                          )),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Yes",
                            style: TextStyle(fontSize: 18, color: white),
                          ),
                        ),
                      ),
                    )),
              ),
            ],
          ),
          SizedBox(
            height: 25.h,
          ),
        ],
      ),
    ));
  }

  void uploadQRPreview(File file, context) async {

    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromBytes(File(file.path).readAsBytesSync(),
          filename: fileName),
      "token": "$token",
    });

    Dio dio = new Dio();

    dio.post(qrImageUploadMerchantAPI, data: data).then((response) {
      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        if (status == "1") {
          merchantWAMsg();
        } else {
          showToastMessage(msg['message'].toString());
        }
      } else {
        showToastMessage(status500);
        printMessage("screen", "Error : ${response}");
      }
    }).catchError((error) => print(error));
  }

  Future merchantWAMsg() async {
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"token": "$token", "user_name": "$name", "mobile": "$mobile"};

    printMessage("screen", "headers : $body");

    final response = await http.post(Uri.parse(wpMerchantRegAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage("screen", "Response WM  : ${data}");
  }
}
