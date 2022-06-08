import 'package:moneypro_new/utils/AppKeys.dart';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/QRList.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EmpViewMerchantQR extends StatefulWidget {
  final String mToken;

  const EmpViewMerchantQR({Key? key, required this.mToken}) : super(key: key);

  @override
  _EmpViewMerchantQRState createState() => _EmpViewMerchantQRState();
}

class _EmpViewMerchantQRState extends State<EmpViewMerchantQR> {
  var screen = "Merchant View QR";

  var loading = false;

  List<Qr> qrLists = [];

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
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: white,
        brightness: Brightness.light,
        leading: InkWell(
          onTap: () {
            closeKeyBoard(context);
            closeCurrentPage(context);
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
            width: 30.w,
            color: orange,
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
              : _displayQR(),
    )));
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

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        loading = false;

        if (data['status'].toString() == "1") {
          var result =
              QrList.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          qrLists = result.qr;

          printMessage(screen, "Response QR  : ${qrLists.length}");
        } else {
          showToastMessage(somethingWrong);
        }
      });
    } else {
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }
  }

  _displayQR() {
    return ListView.builder(
        itemCount: qrLists.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 10),
            padding: EdgeInsets.only(left: 15, top: 10, bottom: 10, right: 15),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(40)),
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              children: [
                Container(
                    width: 120.w,
                    height: 120.h,
                    child: Image.memory(
                      base64Decode(qrLists[index]
                          .qrString
                          .toString()
                          .replaceAll(RegExp('data:image/png;base64,'), '')),
                      fit: BoxFit.cover,
                    )),
                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${replaceText(qrLists[index].merchantVpa)}",
                      style: TextStyle(
                          color: black,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          );
        });
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
}
