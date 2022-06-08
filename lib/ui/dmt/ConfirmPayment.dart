import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class ConfirmPayment extends StatefulWidget {
  final  Map itemResponse;
  const ConfirmPayment({Key? key, required this.itemResponse}) : super(key: key);

  @override
  _ConfirmPaymentState createState() => _ConfirmPaymentState();
}

class _ConfirmPaymentState extends State<ConfirmPayment> {

  var screen = "Confirm Transaction";
  var customerCharge = "";
  var merchantRev = "";
  var loading = false;
  final DateFormat formatter = DateFormat('MM/dd/yyyy');
  String createDate = "";
  double moneyProBalc = 0.0;

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    getCommissionCost();
    updateWalletBalances();
    fetchUserAccountBalance();

    setState(() {
      createDate = formatter.format(DateTime.now());
    });
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();
    double mX =0.0;
    double wX=0.0;

    final inheritedWidget = StateContainer.of(context);

    if (mpBalc == null || mpBalc == 0) {
      mpBalc = 0;
      inheritedWidget.updateMPBalc(value: mpBalc);
    } else {
      inheritedWidget.updateMPBalc(value: mpBalc);
    }

    if (qrBalc == null || qrBalc == 0) {
      qrBalc = 0;
      inheritedWidget.updateQRBalc(value: qrBalc);
    } else {
      inheritedWidget.updateQRBalc(value: qrBalc);
    }

    if (walBalc == null || walBalc == 0) {
      walBalc = 0;
      inheritedWidget.updateWelBalc(value: walBalc);
    } else {
      inheritedWidget.updateWelBalc(value: walBalc);
    }


    if (walBalc != null || walBalc != 0) {
      wX = double.parse(walBalc);
    }

    if (mpBalc != null || mpBalc != 0) {
      mX = double.parse(mpBalc);
    }
    setState(() {
      moneyProBalc =  mX;
    });

  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(child: Scaffold(
      backgroundColor: boxBg,
      body: (loading)?Center(
        child: circularProgressLoading(40.0),
      ):Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 40),
        decoration: new BoxDecoration(
          borderRadius:
          BorderRadius.vertical(top: Radius.circular(50.0)),
          color: white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              spreadRadius: 10,
              blurRadius: 10,
              offset: Offset(0, 1), // changes position of shadow
            ),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                height: 20.h,
              ),
              Container(
                height: 4.h,
                width: 50.w,
                color: gray,
              ),
              SizedBox(
                height: 20.h,
              ),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Image.asset('assets/img4.png'),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0, right: 35),
                child: Center(
                    child: Text(
                      "${widget.itemResponse['sendName']} (91${widget.itemResponse['sendMobile']}) is transferring",
                      style: TextStyle(color: black, fontSize: font16),
                      textAlign: TextAlign.center,
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 35.0, right: 35, top: 10),
                child: Center(
                    child: Text(
                      "$rupeeSymbol ${widget.itemResponse['amount'].toString()}/-",
                      style: TextStyle(
                          color: orange,
                          fontSize: font24,
                          fontWeight: FontWeight.bold),
                    )),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 40.0, right: 30, left: 30),
                child: Row(
                  children: [
                    Text(
                      "Account No.",
                      style: TextStyle(
                          color: lightBlack, fontSize: font13.sp),
                    ),
                    Spacer(),
                    Text(
                      "${widget.itemResponse['accountNo']}",
                      style: TextStyle(
                          color: black,
                          fontSize: font13.sp,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, right: 30, left: 30),
                child: Row(
                  children: [
                    Text(
                      "IFSC Code",
                      style: TextStyle(
                          color: lightBlack, fontSize: font13.sp),
                    ),
                    Spacer(),
                    Text(
                      "${widget.itemResponse['ifsc']}",
                      style: TextStyle(
                          color: black,
                          fontSize: font13.sp,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, right: 30, left: 30),
                child: Row(
                  children: [
                    Text(
                      "Amount",
                      style: TextStyle(
                          color: lightBlack, fontSize: font13.sp),
                    ),
                    Spacer(),
                    Text(
                      "${widget.itemResponse['amount']}",
                      style: TextStyle(
                          color: black,
                          fontSize: font13.sp,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, right: 30, left: 30),
                child: Row(
                  children: [
                    Text(
                      "Mode",
                      style: TextStyle(
                          color: lightBlack, fontSize: font13.sp),
                    ),
                    Spacer(),
                    Text(
                      "${widget.itemResponse['mode']}",
                      style: TextStyle(
                          color: black,
                          fontSize: font13.sp,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 30, left: 30),
                child: Row(
                  children: [
                    Text(
                      "Beneficiary",
                      style: TextStyle(
                          color: lightBlack, fontSize: font13.sp),
                    ),
                    Spacer(),
                    Text(
                      "${widget.itemResponse['holderName']}",
                      style: TextStyle(
                          color: black,
                          fontSize: font13.sp,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    top: 20.0, right: 30, left: 30),
                child: Row(
                  children: [
                    Text(
                      "$senderWallet",
                      style: TextStyle(
                          color: lightBlack, fontSize: font13.sp),
                    ),
Spacer(),
                    Text(
                      // "$rupeeSymbol ${formatDecimal2Digit.format(moneyProBalc)}",
                      "$moneyProBalc",
                      style: TextStyle(
                          color: black,
                          fontSize: font13.sp,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Divider(
                color: gray,
                thickness: 1,
                height: 1.h,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20.0, right: 30, left: 30),
                child: Text("$totalAdhikariCost $rupeeSymbol $customerCharge/-",
                    style: TextStyle(color: lightBlue, fontSize: font15.sp)),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, right: 30, left: 30),
                child: Text("$adhikariComission $rupeeSymbol $merchantRev/-",
                    style: TextStyle(color: black, fontSize: font14.sp)),
              ),
              SizedBox(height: 30.h,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        closeCurrentPage(context);
                      },
                      child: Container(
                        height: 45.h,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            border: Border.all(color: boxBg)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30.0, right: 30),
                              child: Text(
                                cancel,
                                style:
                                TextStyle(color: lightBlue, fontSize: font15.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(32.0),
                    ),
                    child: InkWell(
                      onTap: () {
                        // move to new screen
                        startTransmitting();
                      },
                      child: Container(
                        height: 45.h,
                        decoration: BoxDecoration(
                            color: lightBlue,
                            borderRadius: BorderRadius.all(Radius.circular(30)),
                            border: Border.all(color: lightBlue, width: 1)),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 30.0, right: 30),
                              child: Text(
                                confirm,
                                style: TextStyle(color: white, fontSize: font15.sp),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.h,),
            ],
          ),
        ),
      ),
    )));
  }

  Future getCommissionCost() async {
    setState(() {
      loading = true;
    });

    var mId = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "m_id": mId,
      "amount": widget.itemResponse['amount'].toString(),
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtChargeStatusAPI),
        body: jsonEncode(body), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        loading = false;
        printMessage(screen, "data : $data");
        customerCharge = data['total_charge'].toString();
        merchantRev = data['merchant_com'].toString();
      });
    }else{
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }


  }

  _showAddSenderDialog() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        isDismissible: false,
        backgroundColor: Colors.transparent,
        builder: (context) => InkWell(
            onTap: () {
            },
            child: Center(
              child: Container(
                width: MediaQuery.of(context).size.width,
                margin: EdgeInsets.only(left: 20, right: 20),
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                    border: Border.all(color: white, width: 2)),
                child: Wrap(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 20.h,
                          ),
                          Image.asset(
                            'assets/mob3.png',
                            height: 120.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              transferringMoney,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(0.0),
                            child: Text(
                              pleaseWait,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font15.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )));
  }

  showAddMoneyDialog(msg) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  border: Border.all(color: white, width: 2)),
              child: Wrap(
                children: [
                  Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, bottom: 20),
                          child: Image.asset(
                            'assets/no_money.png',
                            height: 120.h,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          msg,
                          style: TextStyle(
                              color: black,
                              fontSize: font18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(0.0),
                        child: Text(
                          addMoneyToWallet,
                          style: TextStyle(
                              color: black,
                              fontSize: font15.sp,
                              fontWeight: FontWeight.normal),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                              },
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                    color: bankBox,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(
                                        color: bankBox, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                                  child: Center(
                                    child: Text(
                                      "No",
                                      style: TextStyle(
                                          color: lightBlue,
                                          fontSize: font15.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Card(
                            elevation: 10,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(32.0),
                            ),
                            child: InkWell(
                              onTap: () {
                                Navigator.of(context).pop();
                                removeAllPages(context);
                                openAppWallet(context);
                              },
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                    color: lightBlue,
                                    borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(
                                        color: lightBlue, width: 1)),
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 30.0, right: 30),
                                  child: Center(
                                    child: Text(
                                      "Yes",
                                      style: TextStyle(
                                          color: white, fontSize: font15.sp),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 20.h,)
                    ],
                  ),

                ],
              ),
            ),
          ),
        ));
  }

  Future startTransmitting() async {
    setState(() {
      _showAddSenderDialog();
    });

    var mechantId = await getMerchantID();
    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "m_id": mechantId,
      "token": token,
      "beneficiary_id": widget.itemResponse['beneficiaryId'].toString(),
      "amount": widget.itemResponse['amount'].toString(),
      "mode": widget.itemResponse['mode'].toString(),
      "customer_id": widget.itemResponse['senderCustId'].toString(),
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtTransferMoneyAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Payment Data : $data");

      setState(() {
        printMessage(screen, "data : $data");
        var holderName = widget.itemResponse['holderName'];
        var accountNo = widget.itemResponse['accountNo'];
        var mode = widget.itemResponse['mode'];
        var mobile = widget.itemResponse['mobile'];

        Navigator.of(context).pop();

        if (data['status'].toString() == "1") {
          Map map = {
            "date": "$createDate",
            "transId": "${data['transId']}",
            "amount": "${widget.itemResponse['amount'].toString()}",
            "mode": "$mode",
            "status": "SUCCESS",
            "mobile": "$mobile",
            "acc_no": "$accountNo",
            "customer_charge": "$customerCharge",
            "total_payable_amnt": "${data['total_pay']}",
            "merchant_commission": "$merchantRev",
          };

          openDMTRecipt(context, map);
        } else if (data['status'].toString() == "2") {
          showToastMessage(data['message'].toString());
        } else if (data['status'].toString() == "3") {
          //showToastMessage(data['message'].toString());
          showAddMoneyDialog(data['message'].toString());
        }
      });
    }else{
      setState(() {
        Navigator.of(context).pop();
      });
      showToastMessage(status500);
    }


  }

}
