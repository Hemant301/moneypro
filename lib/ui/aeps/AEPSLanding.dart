import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/AppKeys.dart';

class AEPSLanding extends StatefulWidget {
  final String pipe;
  const AEPSLanding({Key? key, required this.pipe}) : super(key: key);

  @override
  _AEPSLandingState createState() => _AEPSLandingState();
}

class _AEPSLandingState extends State<AEPSLanding> {
  var selectCatPos;

  var screen = "AESP Landing";

  int actionIndex = 3;

  var loading = false;
  var authToken;

  var aepsTxnId = "";

  AepsOption apes = AepsOption.balcEnq;

  @override
  void initState() {
    super.initState();
    printMessage(screen, "PIPE : ${widget.pipe}");
    getAEPSAuthToken();
    setState(() {
      txn_type = "BE";
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  String txn_type = "BE";
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
                  InkWell(
                      onTap: () {
                        //openYoutubeVdoPlayer(context,"a3bGXDRTw_Q");
                      },
                      child: Container(
                          height: 30.h,
                          margin: EdgeInsets.only(
                              top: 14, left: 10, right: 10, bottom: 14),
                          decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              border: Border.all(color: black)),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              Image.asset(
                                'assets/ic_youtube.png',
                                width: 20.w,
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Text(
                                "HELP VIDEOS",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                            ],
                          ))),
                  SizedBox(
                    width: 10.w,
                  )
                ],
              ),
              body: (loading)
                  ? Center(child: circularProgressLoading(40.0))
                  : SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          appSelectedBanner(
                              context, "recharge_banner.png", 150.0),
                          SizedBox(
                            height: 20.h,
                          ),
                          _buildTabSection(),
                          Divider(),
                          Padding(
                            padding: const EdgeInsets.only(left: 15.0, top: 20),
                            child: Text(
                              "Notes:",
                              style:
                                  TextStyle(color: black, fontSize: font16.sp),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 10, right: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "1. ",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "AEPS withdrawal available 24X7, 365 days",
                                    style: TextStyle(
                                        color: black, fontSize: font14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 10, right: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "2. ",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "To avail commission min trans amount is Rs.200",
                                    style: TextStyle(
                                        color: black, fontSize: font14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 10, right: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "3. ",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "All commission and actual amount will added to Merchant's main wallet.",
                                    style: TextStyle(
                                        color: black, fontSize: font14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 10, right: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "4. ",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "Payout charges applicable as per bank predefined slab and may change time to time.",
                                    style: TextStyle(
                                        color: black, fontSize: font14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 10, right: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "5. ",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "No commission for Bal Inquiry and Mini Statement.",
                                    style: TextStyle(
                                        color: black, fontSize: font14.sp),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 10, right: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "6. ",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                                Text(
                                  "Minimum withdrawal amount is Rs. 100",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 10, right: 15),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "7. ",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                                Text(
                                  "Aadhar Pay charges 1% of the withdrawal amount",
                                  style:
                                      TextStyle(color: red, fontSize: font16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
              bottomNavigationBar: _buildBottomSection(),
            )));
  }

  _buildTabSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            children: [
              Image.asset(
                "assets/recipt.png",
                color: lightBlue,
                height: 20.h,
                width: 20.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    '$withdraw',
                    style: TextStyle(color: black, fontSize: font16.sp),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Radio(
                  value: AepsOption.withdrl,
                  groupValue: apes,
                  onChanged: (value) {
                    setState(() {
                      apes = AepsOption.withdrl;
                      actionIndex = 1;
                      txn_type = "CW";
                    });
                  })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            children: [
              Image.asset(
                "assets/notice.png",
                color: lightBlue,
                height: 20.h,
                width: 20.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    '$miniState',
                    style: TextStyle(color: black, fontSize: font16.sp),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Radio(
                  value: AepsOption.miniStatement,
                  groupValue: apes,
                  onChanged: (value) {
                    setState(() {
                      apes = AepsOption.miniStatement;
                      actionIndex = 2;
                      txn_type = "MS";
                    });
                  })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            children: [
              Image.asset(
                "assets/aeps.png",
                color: lightBlue,
                height: 20.h,
                width: 20.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    'Aadhar Pay',
                    style: TextStyle(color: black, fontSize: font16.sp),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Radio(
                  value: AepsOption.aadharPay,
                  groupValue: apes,
                  onChanged: (value) {
                    setState(() {
                      apes = AepsOption.aadharPay;
                      actionIndex = 4;
                      txn_type = "AP";
                    });
                  })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            children: [
              Image.asset(
                "assets/filter.png",
                color: lightBlue,
                height: 20.h,
                width: 20.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    '$balcEnquiry',
                    style: TextStyle(color: black, fontSize: font16.sp),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Radio(
                  value: AepsOption.balcEnq,
                  groupValue: apes,
                  onChanged: (value) {
                    setState(() {
                      apes = AepsOption.balcEnq;
                      actionIndex = 3;
                      txn_type = "BE";
                    });
                  })
            ],
          ),
        ),
      ],
    );
  }

  _buildBottomSection() {
    return Container(
      height: 60.h,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                if (actionIndex == 1) {
                  getAEPSTxnId("CW");
                } else if (actionIndex == 2) {
                  getAEPSTxnId("MS");
                } else if (actionIndex == 3) {
                  getAEPSTxnId("BE");
                } else if (actionIndex == 4) {
                  getAEPSTxnId("AP");
                }
              });
            },
            child: Container(
              height: 50.h,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 0),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Text(
                  /*(actionIndex == 1)
                      ? withdrawNow
                      : (actionIndex == 2)
                          ? miniState
                          : checkBalc,*/
                  (actionIndex == 1)
                      ? withdrawNow
                      : (actionIndex == 2)
                          ? miniState
                          : (actionIndex == 3)
                              ? checkBalc
                              : "Aadhar Pay",
                  style: TextStyle(fontSize: font15.sp, color: white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _moveToSDKWithdrawal(txnCode, aepsTxnId) async {
    var aespMId = await getAEPSMerchantId();
    var email = await getEmail();
    var mobile = await getMobile();
    // var id = DateTime.now().millisecondsSinceEpoch;

    //saveAESPTransId(id.toString());

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");
      print('${aespMId.length} santosh');
      var arr = {
        "merchantId": "$aespMId",
        "merchantEmailId": "$email",
        "merchantMobileNo": "$mobile",
        "partnerRefId": "$aepsTxnId",
        "txnCode": "$txnCode",
        "pipe": "${widget.pipe}",
        "token": "$authToken",
        "enryptdecryptKey": "$atmEncDecKey",
      };

      printMessage(screen, "passing val : $arr");

      String result = await platform.invokeMethod("aepsSBMCall", arr);

      printMessage(screen, "Response : $result");

      if (result.contains("isSuccess")) {
        try {
          var json = jsonDecode(result);
          var isSuccess = json['isSuccess'];

          //if (isSuccess.toString() == "true") {

          var partnerRefId = json['data']['partnerRefId'];
          var amount = json['data']['amount'];
          var message = json['message'] ?? "Pending";
          var bankResponseMsg = json['data']['bankResponseMsg'];
          var merchantMobileNo = json['data']['merchantMobileNo'];
          var aadhaarNo = json['data']['aadhaarNo'];
          var rrn = json['data']['rrn'];
          var bankIIN = json['data']['bankIIN'];
          var stan = json['data']['stan'];
          var txnDate = json['data']['txnDate'];
          var bankName = json['data']['bankName'];
          var balance = json['data']['remainingBalance'];
          var adharNo = json['data']['aadhaarNo'];
          var mobile = json['data']['customerMobileNo'];
          var txnFee = json['data']['txnFee'];
          var npciCode = json['data']['npciCode'];
          var aepsStatusCode = json['statusCode'];

          updateCWStatus(
              aepsStatusCode,
              partnerRefId,
              amount,
              message,
              bankResponseMsg,
              merchantMobileNo,
              aadhaarNo,
              txnCode,
              rrn,
              bankIIN,
              stan,
              txnDate,
              result,
              bankName,
              balance,
              adharNo,
              mobile,
              txnFee,
              npciCode);
          // }
          /*else {
            var bankResponseMsg = json['data']['bankResponseMsg'];
            showToastMessage(bankResponseMsg);
          }*/
        } catch (e) {
          printMessage(screen, "Error--> : ${e.toString()}");
          showToastMessage(somethingWrong);
        }
      } else {
        //saveAESPTransId("");
        showToastMessage(result.toString());
      }
    }
  }

  Future getAEPSAuthToken() async {
    setState(() {
      loading = true;
    });

    var header = {
      "secretKey": "$atmSecrettKey",
      "saltKey": "$atmSaltKey",
      "encryptdecryptKey": "$atmEncDecKey"
    };

    printMessage(screen, "Header : $header");

    final response = await http.post(Uri.parse(authUrl), headers: header);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "data : $data");

    setState(() {
      loading = false;
      if (data['isSuccess'].toString() == "true") {
        authToken = data['data']['token'].toString();
      } else {
        showToastMessage("Something went wrong. Please after sometime");
      }
    });
  }

  Future updateCWStatus(
    aepsStatusCode,
    partnerRefId,
    amount,
    message,
    bankResponseMsg,
    merchantMobileNo,
    aadhaarNo,
    txnCode,
    rrn,
    bankIIN,
    stan,
    txnDate,
    result,
    bankName,
    balance,
    adharNo,
    mobile,
    txnFee,
    npciCode,
  ) async {
    try {
      var mId = await getMerchantID();
      var aepsId = await getAEPSMerchantId();
      var token = await getToken();

      var custCharge = 0.0;

      if (txnCode.toString().toLowerCase() == "ap") {
        custCharge = (1 / 100) * amount;
      }

      setState(() {
        _showConfirmTransaction();
      });

      var headers = {
        "Content-Type": "application/json",
        "Authorization": "$authHeader",
      };

      var body = {
        "m_id": "$mId",
        "merchant_Id": "$aepsId",
        "partnerRefId": "$partnerRefId",
        "amount": "$amount",
        "message": "$message",
        "bankResponseMsg": "$bankResponseMsg",
        "merchantMobileNo": "$merchantMobileNo",
        "aadhaarNo": "$aadhaarNo",
        "bank_name": "$bankName",
        // "txnCode": "$txnCode",
        "txnCode": "$aepsStatusCode",
        "rrn": "$rrn",
        "bankIIN": "$bankIIN",
        "stan": "$stan",
        "txnDate": "$txnDate",
        "token": "$token",
        "txnid": "$aepsTxnId",
        "txnFee": (txnCode.toString().toLowerCase() == "ap") ? "$txnFee" : "0",
        "customer_charge":
            (txnCode.toString().toLowerCase() == "ap") ? "$custCharge" : "0",
      };
      printMessage(screen, "Body : $body");

      final response = await http.post(Uri.parse(aeps2ResponseAPI),
          headers: headers, body: jsonEncode(body));
      int statusCode = response.statusCode;

      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Update Response : $data");

        setState(() {
          Navigator.pop(context);
          if (data['status'].toString() == "1") {
            var commission = data['commission'].toString();
            showToastMessage(data['message'].toString());

            if (txnCode.toString() == "BE") {
              setState(() {
                Map map = {
                  "bankName": "$bankName",
                  "balance": "$balance",
                  "adharNo": "$adharNo",
                  "mobile": "$mobile",
                  "partnerRefId": "$partnerRefId",
                  "rrn": "$rrn",
                  "bankResponseMsg": "$bankResponseMsg"
                };
                openAEPS_BalanceEnq(context, map);
              });
            }

            if (txnCode.toString() == "MS") {
              setState(() {
                openAEPSMiniStatement(context, result);
              });
            }

            if (txnCode.toString() == "CW" || txnCode.toString() == "AP") {
              Map map = {
                "date": "$txnDate",
                "transId": "$rrn",
                "refId": "$partnerRefId",
                "amount": "$amount",
                "mode": "$txnCode",
                "status": "$message",
                "adhar": "$aadhaarNo",
                "mobile": "$merchantMobileNo",
                "merComm": "$commission",
                "balance": "$balance",
                "customerCharge": "$custCharge",
                "stan": "$stan",
                "rrn": "$rrn",
                "bankmsg": "$bankResponseMsg",
                "npciCode": "$npciCode",
                "bankName": "$bankName"
              };
              openAEPSReceipt(context, map, true);
            }
          } else {
            showToastMessage("Something went wrong. Please after sometime");
          }
        });
      } else {
        setState(() {
          Navigator.pop(context);
        });
        showToastMessage('${status500}');
      }
    } catch (e) {
      e.toString();
    }
  }

  Future getAEPSTxnId(txnCode) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    var body = {"user_token": "$userToken", "txn_type": "$txn_type"};

    printMessage(screen, "Body : $body");

    final response = await http.post(Uri.parse(aepsTxnStatusAPI),
        headers: headers, body: jsonEncode(body));

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Update Response : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          aepsTxnId = data['txn_id'].toString();
          _moveToSDKWithdrawal("$txnCode", aepsTxnId);
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  _showConfirmTransaction() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (context) => InkWell(
            onTap: () {
              //Navigator.of(context).pop();
            },
            child: Container(
              margin: EdgeInsets.only(left: 20, right: 20),
              child: Center(
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 250.h,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: white, width: 2)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Image.asset(
                        'assets/img4.png',
                        height: 120.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              circularProgressLoading(20.0),
                              SizedBox(
                                width: 10.w,
                              ),
                              Text(
                                "Please wait...",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: lightBlue,
                                    fontSize: font18.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            )));
  }
}
