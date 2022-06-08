import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class BBSPRecipt extends StatefulWidget {
  final Map map;

  const BBSPRecipt({Key? key, required this.map}) : super(key: key);

  @override
  _BBSPReciptState createState() => _BBSPReciptState();
}

class _BBSPReciptState extends State<BBSPRecipt> {
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();
  var screen = "Mobile Receipt";
  var role;

  var statusLoading = false;

  var rechargeStatus;

  @override
  void initState() {
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);
    getUserDetails();

    setState(() {
      rechargeStatus = widget.map['TxStatus'].toString();
      //rechargeStatus = "Pending";
      printMessage(screen, "RefId : ${widget.map['referenceId']}");
    });
  }

  getUserDetails() async {
    var r = await getRole();

    setState(() {
      role = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              appBar: AppBar(
                elevation: 0,
                centerTitle: false,
                backgroundColor: white,
                brightness: Brightness.light,
                leading: IconButton(
                  icon: Image.asset(
                    'assets/back_arrow.png',
                    height: 24.h,
                  ),
                  onPressed: () {
                    closeKeyBoard(context);
                    closeCurrentPage(context);
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
              body: RepaintBoundary(
                key: _printKey,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: white,
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          Column(
                            children: [
                              SizedBox(
                                height: 30.h,
                              ),
                              Center(
                                child: CircleAvatar(
                                  backgroundColor: Colors.transparent,
                                  radius: 40,
                                  child: ClipRRect(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(40)),
                                      child: (rechargeStatus == "null" ||
                                              rechargeStatus
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "failure")
                                          ? Image.asset("assets/failed.png")
                                          : (rechargeStatus
                                                      .toString()
                                                      .toLowerCase() ==
                                                  "pending")
                                              ? Image.asset(
                                                  "assets/pending.png")
                                              : Image.asset(
                                                  "assets/pin_alert.png")),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              Text(
                                (rechargeStatus == "null")
                                    ? "Transaction Failed"
                                    : "Transaction $rechargeStatus",
                                style: TextStyle(
                                    color: black,
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                "$rupeeSymbol ${widget.map['orderAmount']}",
                                style:
                                    TextStyle(fontSize: font18.sp, color: black),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 40.h,
                          ),
                          Expanded(
                              child: Container(
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
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 40.h,
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
                                        top: 40.0, right: 30, left: 30),
                                    child: Row(
                                      children: [
                                        Text(
                                          "$transactionId",
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font13.sp),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${widget.map['tId']}",
                                            style: TextStyle(
                                                color: black,
                                                fontSize: font13.sp,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.end,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, right: 30, left: 30),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Date",
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font13.sp),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            (widget.map['txTime'].toString() ==
                                                    "null")
                                                ? "NA"
                                                : "${widget.map['txTime']}",
                                            style: TextStyle(
                                                color: black,
                                                fontSize: font13.sp,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.end,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, right: 30, left: 30),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Operator",
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font13.sp),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            (widget.map['operatorName']
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "prepaid")
                                                ? "${widget.map['category']}"
                                                : "${widget.map['operatorName']}",
                                            style: TextStyle(
                                                color: black,
                                                fontSize: font13.sp,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.end,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, right: 30, left: 30),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Reference ID",
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font13.sp),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            (widget.map['referenceId']
                                                        .toString() ==
                                                    "null")
                                                ? "NA"
                                                : "${widget.map['referenceId']}",
                                            style: TextStyle(
                                                color: black,
                                                fontSize: font13.sp,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.end,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 30.0, right: 30, left: 30),
                                    child: Row(
                                      children: [
                                        Text(
                                          "$mode_",
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font13.sp),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${widget.map['paymentMode']}",
                                            style: TextStyle(
                                                color: black,
                                                fontSize: font13.sp,
                                                fontWeight: FontWeight.bold),
                                            textAlign: TextAlign.end,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 15.h),
                                  Divider(
                                    color: gray,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15, top: 0),
                                    child: Row(
                                      children: [
                                        Text(
                                          "$customerCare",
                                          style: TextStyle(
                                              color: black, fontSize: font14.sp),
                                        ),
                                        Spacer(),
                                        (role == "3")
                                            ? Text(
                                                "$merchantMob",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font14.sp),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, right: 15, top: 5),
                                    child: Row(
                                      children: [
                                        Text(
                                          "$customerEmail",
                                          style: TextStyle(
                                              color: lightBlue,
                                              fontSize: font14.sp),
                                        ),
                                        Spacer(),
                                        (role == "3")
                                            ? Text(
                                                "$mobileChar",
                                                style: TextStyle(
                                                    color: lightBlue,
                                                    fontSize: font14.sp),
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  (rechargeStatus.toString().toLowerCase() ==
                                          "success")
                                      ? Container()
                                      : Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          printMessage(screen,
                                              "Txt Key ${widget.map['txnKey']}");

                                          var txtKey = widget
                                              .map['txnKey']
                                              .toString();
                                          var refId = widget
                                              .map['referenceId']
                                              .toString();
                                          var opName = widget
                                              .map['operatorName']
                                              .toString();

                                          if (txtKey.toString() ==
                                              "null" ||
                                              txtKey.toString() == "") {
                                            showToastMessage(
                                                somethingWrong);
                                          } else if (txtKey.toString() ==
                                              "payu") {
                                            getBBPSToken(refId);
                                          } else if (txtKey.toString() ==
                                              "LIC") {
                                          } else if (opName.toString() ==
                                              "PREPAID") {
                                            generateJWTToken(txtKey);
                                          } else {
                                            getTxnStatus("$txtKey");
                                          }
                                        },
                                        child: Text(
                                          "Check your recharge status",
                                          style: TextStyle(
                                              color: red,
                                              fontSize: font16.sp,
                                              fontWeight:
                                              FontWeight.w600),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Container(
                                    margin: EdgeInsets.only(
                                        left: 15,
                                        right: 15,
                                        bottom: 10,
                                        top: 10),
                                    child: Image.asset(
                                      'assets/wallet_banner.png',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                        ],
                      ),
                      Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: Center(
                          child: SizedBox(
                            height: 48.h,
                            width: 48.w,
                            child: Image.asset("assets/bbps_new.png"),
                          ),
                        ),
                      ),
                      (statusLoading)
                          ? Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              child: Center(
                                child: circularProgressLoading(60.0),
                              ),
                            )
                          : Container()
                    ],
                  ),
                ),
              ),
              bottomNavigationBar: Container(
                width: MediaQuery.of(context).size.width,
                height: 40.h,
                margin:
                    EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    border: Border.all(color: lightBlue)),
                child: InkWell(
                  onTap: () {
                    var mode = "";
                    var wallAmt = widget.map['walAmt'].toString();
                    var pgAmt = widget.map['pgAmt'].toString();

                    var opName = widget.map['operatorName'].toString();
                    var category = widget.map['category'].toString();

                    if (wallAmt != "0" && pgAmt != "0") {
                      mode = "Wallet + Payment Gateway";
                    } else if (wallAmt != "0" && pgAmt == "0") {
                      mode = "Wallet";
                    } else if (wallAmt == "0" && pgAmt != "0") {
                      mode = "Payment Gateway";
                    }

                    /*openRaisedTicket(
                context,
                widget.map['tId'].toString(),
                widget.map['orderAmount'].toString(),
                widget.map['TxStatus'].toString(),
                mode,
                opName,
                category,
                pgAmt);*/
                  },
                  child: Center(
                    child: Text(
                      "Raised Ticket",
                      style: TextStyle(
                        color: white,
                        fontSize: font14.sp,
                      ),
                    ),
                  ),
                ),
              ),
            )));
  }

  Future getTxnStatus(txnKey) async {
    try {
      setState(() {
        statusLoading = true;
      });

      var header = {
        "Content-Type": "application/json",
        "Authorization": "$authHeader",
      };

      final body = {"txn_key": "$txnKey"};

      printMessage(screen, "body : $body");

      final response = await http.post(Uri.parse(checkTransctionStatusAPI),
          body: jsonEncode(body), headers: header);

      int statusCode = response.statusCode;

      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Response Update : $data");

        setState(() {
          statusLoading = false;
          var status = data['status'].toString();
          if (status == "1") {
            showToastMessage(data['message'].toString());
            setState(() {
              rechargeStatus = "${data['message']}";
            });
          } else {
            showToastMessage(data['message'].toString());
          }
        });
      } else {
        setState(() {
          statusLoading = false;
        });
        showToastMessage(status500);
      }
    } catch (e) {
      printMessage(screen, "Error : ${e.toString()}");
    }
  }

  Future getBBPSToken(refId) async {
    setState(() {
      statusLoading = true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response =
        await http.post(Uri.parse(generateTokenBbpsAPI), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "TOKEN : ${data}");

      setState(() {
        statusLoading = false;
        var status = data['status'];
        if (status.toString() == "1") {
          var bbpsToken = data['bbps_token'].toString();
          getTxnPayUStatus(refId, bbpsToken);
        } else {
          showToastMessage(somethingWrong);
        }
      });
    } else {
      setState(() {
        statusLoading = false;
      });
      showToastMessage(status500);
    }
  }

  Future getTxnPayUStatus(refId, bbpsToken) async {
    try {
      setState(() {
        statusLoading = true;
      });

      var header = {
        "Content-Type": "application/json",
        "Authorization": "$authHeader",
      };

      var userToken = await getToken();

      final body = {
        "user_token": "$userToken",
        "refId": "$refId",
        "token": "$bbpsToken",
      };

      printMessage(screen, "body : $body");

      final response = await http.post(Uri.parse(checkRechargeStatus),
          body: jsonEncode(body), headers: header);

      int statusCode = response.statusCode;

      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Response Update : $data");

        setState(() {
          statusLoading = false;
          var status = data['status'].toString();
          if (status == "1") {
            var code = data['result']['code'].toString();
            if (code.toString() == "200") {
              setState(() {
               var  rechStatus = data['result']['payload']['txnStatus'];

               if(rechStatus.toString().contains("FAILURE")
                   || rechStatus.toString().contains("FAIL")
                   || rechStatus.toString().contains("FAILED")){
                 setState(() {
                   rechargeStatus = "FAILURE";
                 });
               }else{
                 setState(() {
                   rechargeStatus = "$rechStatus";
                 });
               }

              });
            } else {
              showToastMessage(somethingWrong);
            }
          } else {
            showToastMessage(data['message'].toString());
          }
        });
      } else {
        setState(() {
          statusLoading = false;
        });
        showToastMessage(status500);
      }
    } catch (e) {
      printMessage(screen, "Error : ${e.toString()}");
    }
  }

  Future generateJWTToken(txnId) async {
    setState(() {
      statusLoading = true;
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

    printMessage(screen, "Response JWT : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      statusLoading = false;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          var jwtToken = data['token'].toString();
          getTxnPaysprintStatus(txnId, jwtToken);
        } else {
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  Future getTxnPaysprintStatus(refId, bbpsToken) async {
    try {
      setState(() {
        statusLoading = true;
      });

      var header = {
        "Content-Type": "application/json",
        "Authorization": "$authHeader",
      };

      var userToken = await getToken();

      final body = {
        "user_token": "$userToken",
        "referenceid": "$refId",
        "token": "$bbpsToken",
      };

      printMessage(screen, "body : $body");

      final response = await http.post(Uri.parse(statusEnqueryAPI),
          body: jsonEncode(body), headers: header);

      int statusCode = response.statusCode;

      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Response Update : $data");

        setState(() {
          statusLoading = false;
          var status = data['status'].toString();
          if (status == "1") {
            var code = data['result']['status'].toString();
            if (code.toString() == "true") {
              setState(() {
                rechargeStatus = "Success";
              });
            } else {
              showToastMessage(somethingWrong);
            }
          } else {
            showToastMessage(data['message'].toString());
          }
        });
      } else {
        setState(() {
          statusLoading = false;
        });
        showToastMessage(status500);
      }
    } catch (e) {
      printMessage(screen, "Error : ${e.toString()}");
    }
  }
}
