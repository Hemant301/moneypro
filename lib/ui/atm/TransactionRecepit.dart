import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';

class TransactionRecepit extends StatefulWidget {
  final Map map;

  const TransactionRecepit({Key? key, required this.map}) : super(key: key);

  @override
  _TransactionRecepitState createState() => _TransactionRecepitState();
}

class _TransactionRecepitState extends State<TransactionRecepit> {
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();
  var screen = "AMTA Receipt";

  @override
  void initState() {
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);

    printMessage(screen, "Response : ${widget.map}");

    if (widget.map['removeAll'].toString() == "Yes") {
      if (widget.map['txnType'].toString() == "CW" ||
          widget.map['txnType'].toString() == "cw") {
        submitTransResult();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => WillPopScope(
              onWillPop: () async {
                printMessage(screen, "Mobile back pressed");
                if (widget.map['removeAll'].toString() == "Yes") {
                  removeAllPages(context);
                } else {
                  closeCurrentPage(context);
                }
                return false;
              },
              child: SafeArea(
                  child: Scaffold(
                appBar: AppBar(
                  elevation: 10,
                  centerTitle: false,
                  backgroundColor: white,
                  leading: IconButton(
                    icon: Image.asset(
                      'assets/back_arrow.png',
                      height: 24.h,
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
                        shareTransReceipt(_printKey, "amtm");
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
                  systemOverlayStyle: SystemUiOverlayStyle.light,
                ),
                body: RepaintBoundary(
                  key: _printKey,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: white,
                    child: SingleChildScrollView(
                      child: Column(
                        children: [
                          _buildRecieptHeader(),
                          Container(
                            height: 10.h,
                            width: MediaQuery.of(context).size.width,
                            color: boxBg,
                          ),
                          _buildRecieptDetails(),
                          Container(
                            height: 10.h,
                            width: MediaQuery.of(context).size.width,
                            color: boxBg,
                          ),
                          _buildReceiptBottom(),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
            ));
  }

  Future submitTransResult() async {
    try {
      setState(() {});

      var mId = await getMerchantID();
      var token = await getToken();
      var merchantId = await getMATMMerchantId();
      var amount = widget.map['amount'].toString();
      var cardNo = widget.map['cardNo'].toString();
      var cardType = widget.map['cardType'].toString();
      var terminalId = widget.map['terminalId'].toString();
      var txnDate = widget.map['date'].toString();
      var txnId = widget.map['transId'].toString();
      var bankName = widget.map['bankName'].toString();
      var partnerRefId = widget.map['refId'].toString();
      var message = widget.map['txnStatus'].toString();
      var rrn = widget.map['rrn'].toString();
      var merchantMobileNo = widget.map['mobile'].toString();
      var txnType = widget.map['txnType'].toString();
      var txnid = widget.map['txnid'].toString();
      var bankMessage = widget.map['bankMessage'].toString();
      var balanceAmount = widget.map['balanceAmount'].toString();

      var headers = {
        "Content-Type": "application/json",
        "Authorization": "$authHeader",
      };

      var body = {
        "m_id": "$mId",
        "token": "$token",
        "merchantId": "$merchantId",
        "amount": "$amount",
        "cardNo": "$cardNo",
        "cardType": "$cardType",
        "terminalId": "$terminalId",
        "txndate": "$txnDate",
        "txnId": "$txnId",
        "bank_name": "$bankName",
        "partnerRefId": "$partnerRefId",
        "message": "$message",
        "rrn": "$rrn",
        "txnid": "$txnid",
        "avail_bal": "$balanceAmount",
        "txn_type": "$txnType",
        "bnk_msg": "$bankMessage"
      };

      printMessage(screen, "Body : $body");

      final response = await http.post(Uri.parse(microatmResponseAddAPI),
          body: jsonEncode(body), headers: headers);
      int statusCode = response.statusCode;

      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Final Code : $data");

        setState(() {
          showToastMessage(data['message'].toString());
        });
      } else {
        setState(() {});
        showToastMessage(status500);
      }
    } catch (e) {
      printMessage(screen, "Final Code : $e");
    }
  }

  _buildRecieptHeader() {
    return Column(
      children: [
        SizedBox(
          height: 30.h,
        ),
        Center(
          child: CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 40,
            child: ClipRRect(
                borderRadius: BorderRadius.all(Radius.circular(40)),
                child: (widget.map['txnStatus'].toString().toLowerCase() ==
                            "Failed".toLowerCase() ||
                        widget.map['txnStatus'].toString().toLowerCase() ==
                            "null".toLowerCase())
                    ? Image.asset("assets/failed.png")
                    : Image.asset("assets/pin_alert.png")),
          ),
        ),
        SizedBox(
          height: 20.h,
        ),
        Text(
          "${widget.map['message']}",
          style: TextStyle(
              color: (widget.map['txnStatus'].toString().toLowerCase() ==
                          "Failed".toLowerCase() ||
                      widget.map['txnStatus'].toString().toLowerCase() ==
                          "null".toLowerCase())
                  ? black
                  : green,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          (widget.map['amount'].toString() != "" &&
                  widget.map['amount'].toString() != "0")
              ? "$rupeeSymbol ${widget.map['amount'].toString()}"
              : "$rupeeSymbol ${widget.map['balanceAmount'].toString()}",
          style: TextStyle(
              fontSize: font18.sp, color: black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: MediaQuery.of(context).size.width * .5,
          color: gray,
          height: 1.h,
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          "${widget.map['date']}",
          style: TextStyle(
              color: black, fontSize: font13.sp, fontWeight: FontWeight.bold),
          textAlign: TextAlign.end,
        ),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }

  _buildRecieptDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
      child: Column(
        children: [
          Text(
            "Transactions Details",
            style: TextStyle(
                color: black, fontWeight: FontWeight.w500, fontSize: font16.sp),
          ),
          Divider(
            color: gray,
          ),
          (widget.map['txnType'].toString() == "CW" ||
                  widget.map['txnType'].toString() == "cw")
              ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Available Balance",
                          style:
                              TextStyle(color: lightBlack, fontSize: font13.sp),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            (widget.map['balanceAmount'].toString() == "")
                                ? "NA"
                                : "$rupeeSymbol ${widget.map['balanceAmount']}",
                            style: TextStyle(
                                color: black,
                                fontSize: font16.sp,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: gray,
                    ),
                  ],
                )
              : Container(),
          (widget.map['bankName'].toString() == "null" ||
                  widget.map['bankName'].toString() == "")
              ? Container()
              : Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Bank Name",
                          style:
                              TextStyle(color: lightBlack, fontSize: font13.sp),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${widget.map['bankName']}",
                            style: TextStyle(
                                color: black,
                                fontSize: font13.sp,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: gray,
                    ),
                  ],
                ),
          Row(
            children: [
              Text(
                "$transId",
                style: TextStyle(color: lightBlack, fontSize: font13.sp),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "${widget.map['transId']}",
                  style: TextStyle(
                      color: black,
                      fontSize: font13.sp,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
          Divider(
            color: gray,
          ),
          Row(
            children: [
              Text(
                "$refIdd",
                style: TextStyle(color: lightBlack, fontSize: font13.sp),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "${widget.map['refId']}",
                  style: TextStyle(
                      color: black,
                      fontSize: font13.sp,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
          Divider(
            color: gray,
          ),
          (widget.map['terminalId'].toString() == "null" ||
                  widget.map['terminalId'].toString() == "")
              ? Container()
              : Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Terminal Id",
                          style:
                              TextStyle(color: lightBlack, fontSize: font13.sp),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${widget.map['terminalId']}",
                            style: TextStyle(
                                color: black,
                                fontSize: font13.sp,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: gray,
                    ),
                  ],
                ),
          (widget.map['cardNo'].toString() == "null" ||
                  widget.map['cardNo'].toString() == "")
              ? Container()
              : Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Card No.",
                          style:
                              TextStyle(color: lightBlack, fontSize: font13.sp),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${widget.map['cardNo']}",
                            style: TextStyle(
                                color: black,
                                fontSize: font13.sp,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: gray,
                    ),
                  ],
                ),
          Row(
            children: [
              Text(
                "Mobile No.",
                style: TextStyle(color: lightBlack, fontSize: font13.sp),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "${widget.map['mobile']}",
                  style: TextStyle(
                      color: black,
                      fontSize: font13.sp,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
          Divider(
            color: gray,
          ),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    "Bank Msg",
                    style: TextStyle(color: lightBlack, fontSize: font13.sp),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "${widget.map['bankMessage']}",
                      style: TextStyle(
                          color: black,
                          fontSize: font13.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  )
                ],
              ),
              Divider(
                color: gray,
              ),
            ],
          )
        ],
      ),
    );
  }

  _buildReceiptBottom() {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.only(left: 15, right: 15, bottom: 10, top: 20),
          child: Image.asset(
            'assets/wallet_banner.png',
          ),
        ),
        Divider(
          color: gray,
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
          child: Row(
            children: [
              Text(
                "$customerCare",
                style: TextStyle(color: black, fontSize: font14.sp),
              ),
              Spacer(),
              Text(
                "$merchantMob",
                style: TextStyle(color: black, fontSize: font14.sp),
              )
            ],
          ),
        ),
        Padding(
          padding:
              const EdgeInsets.only(left: 15.0, right: 15, top: 5, bottom: 10),
          child: Row(
            children: [
              Text(
                "$customerEmail",
                style: TextStyle(color: lightBlue, fontSize: font14.sp),
              ),
              Spacer(),
              Text(
                "$mobileChar",
                style: TextStyle(color: lightBlue, fontSize: font14.sp),
              )
            ],
          ),
        ),
      ],
    );
  }
}
