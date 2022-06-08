import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/AppKeys.dart';


class SendUPIMoney extends StatefulWidget {
  final String name;
  final String vpa;
  final bool isAddNew;

  const SendUPIMoney(
      {Key? key, required this.name, required this.vpa, required this.isAddNew})
      : super(key: key);

  @override
  _SendUPIMoneyState createState() => _SendUPIMoneyState();
}

class _SendUPIMoneyState extends State<SendUPIMoney> {
  var screen = "Send UPI Money";

  TextEditingController amountController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();

  var debitFromWallet = false;
  var debitFromQr = false;

  var walletBal = "";
  var qrBalc = "";

  var approved = "";

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();

    printMessage(screen, "Holder Name : ${widget.name}");
    printMessage(screen, "Bank accNo : ${widget.vpa}");

    getUserDetails();
  }

  getUserDetails() async {
    var wB = await getWalletBalance();
    var qB = await getQRBalance();
    var app = await getApproved();
    setState(() {
      walletBal = wB;
      qrBalc = qB;
      approved = app;
    });
  }

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
                brightness: Brightness.light,
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
                      margin: EdgeInsets.all(15),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: padding, right: padding, bottom: 20),
                        child: Container(
                          child: Column(
                            children: [
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Image.asset(
                                    'assets/upi_ar.png',
                                    height: 30.h,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${widget.name}",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: font16.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          "${widget.vpa}",
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font14.sp,
                                              fontWeight: FontWeight.normal),
                                        ),
                                        SizedBox(
                                          height: 4.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                ],
                              ),
                              Container(
                                height: 40.h,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    top: 15, left: padding, right: padding),
                                decoration: BoxDecoration(
                                  color: editBg,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Center(
                                  child: TextFormField(
                                    style: TextStyle(
                                        color: black, fontSize: 14.sp),
                                    keyboardType: TextInputType.number,
                                    textCapitalization:
                                        TextCapitalization.characters,
                                    textInputAction: TextInputAction.next,
                                    controller: amountController,
                                    decoration: new InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 20),
                                      counterText: "",
                                      label: Text("enter amount"),
                                    ),
                                    maxLength: 7,
                                  ),
                                ),
                              ),
                              Container(
                                height: 40.h,
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    top: 15, left: padding, right: padding),
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
                                    controller: messageController,
                                    decoration: new InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 20),
                                      counterText: "",
                                      label: Text("Add a message (optional)"),
                                    ),
                                    maxLength: 100,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Card(
                      margin: EdgeInsets.all(15),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: EdgeInsets.only(
                            top: 20, left: padding, right: padding, bottom: 20),
                        child: Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Debited from",
                                style: TextStyle(
                                    color: black,
                                    fontWeight: FontWeight.bold,
                                    fontSize: font16.sp),
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/wallet.png",
                                    height: 20.h,
                                    color: lightBlue,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      //"Wallet : $rupeeSymbol ${formatDecimal2Digit.format(double.parse(walletBal))}",
                                      "Wallet : $rupeeSymbol $walletBal",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: font14.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Checkbox(
                                      value: debitFromWallet,
                                      onChanged: (val) {
                                        setState(() {
                                          closeKeyBoard(context);
                                          debitFromWallet = val!;
                                          debitFromQr = false;
                                        });
                                      }),
                                ],
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "assets/qr_menu.png",
                                    height: 20.h,
                                    color: lightBlue,
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  Expanded(
                                    child: Text(
                                      "UPI QR : $rupeeSymbol $qrBalc",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: font14.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Checkbox(
                                      value: debitFromQr,
                                      onChanged: (val) {
                                        setState(() {
                                          closeKeyBoard(context);
                                          debitFromQr = val!;
                                          debitFromWallet = false;
                                        });
                                      }),
                                ],
                              ),
                            ],
                          ),
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
          var amount = amountController.text.toString();
          var msg = messageController.text.toString();

          if (amount.length == 0) {
            showToastMessage("enter mount");
            return;
          }
          double x = double.parse(amount);
          if (x <= 0) {
            showToastMessage("enter mount");
            return;
          }

          if (debitFromWallet) {
            double xMax = double.parse(walletBal);
            if (x > xMax) {
              showToastMessage(
                  "You cannot withdraw amount maximum to $rupeeSymbol $walletBal");
              return;
            }
          }

          if (debitFromQr) {
            double xMax = double.parse(qrBalc);
            if (x > xMax) {
              showToastMessage(
                  "You cannot withdraw amount maximum to $rupeeSymbol $qrBalc");
              return;
            }
          }

          if (!debitFromQr && !debitFromWallet) {
            showToastMessage("select any on option to withdrawal");
            return;
          }

          closeKeyBoard(context);

          generatePayoutTokenWithd(amount);
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
              "Send Money".toUpperCase(),
              style: TextStyle(fontSize: font16.sp, color: white),
            ),
          ),
        ),
      ),
    );
  }

  Future generatePayoutTokenWithd(amount) async {
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
      withdrawWalletRequest(amount, token);
    } else {
      setState(() {
        showToastMessage(somethingWrong);
      });
    }
  }

  Future withdrawWalletRequest(amount, token) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();
    var email = await getEmail();
    var mobile = await getMobile();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "holder_name": "${widget.name}",
      "vpa": "${widget.vpa}",
      "bene_email": "$email",
      "mobile": "$mobile",
      "purpose": "QR Withdrawal",
      "amount": "$amount",
      "access_token": "$token",
      "wallet_type": (debitFromWallet) ? "wallet" : "qrwallet"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(upiInitiatePayoutAPI),
        body: jsonEncode(body), headers: headers);

    var statusCode = response.statusCode;

    printMessage(screen, "Response Settelment : $statusCode");
    Navigator.pop(context);

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Response Settelment : $data");

      var status = data['status'].toString();

      if (status == "1") {
        transPopup();
      } else {
        showToastMessage(data['message'].toString());
      }
    } else {
      setState(() {
        showToastMessage(status500);
      });
    }
  }

  transPopup() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: padding,
                          top: avatarRadius + padding,
                          right: padding,
                          bottom: padding),
                      margin: EdgeInsets.only(
                          top: avatarRadius, left: 20, right: 20),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(padding),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                offset: Offset(0, 10),
                                blurRadius: 10),
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 15.h,
                          ),
                          Text(
                            "Your request is submitted successfully.\nYou may check your transaction status in History after 5 minutes.",
                            style: TextStyle(fontSize: 14.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                  if (widget.isAddNew) {
                                    showAddNewUPI();
                                  } else {
                                    removeAllPages(context);
                                    openMoneyTransferLanding(context);
                                  }
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40.h,
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: lightBlue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      border: Border.all(color: lightBlue)),
                                  child: Center(
                                    child: Text(
                                      "Ok",
                                      style: TextStyle(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: white),
                                    ),
                                  ),
                                )),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: padding,
                      right: padding,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: avatarRadius,
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(avatarRadius)),
                            child: Image.asset("assets/pin_alert.png")),
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }

  showAddNewUPI() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(
                          left: padding,
                          top: avatarRadius + padding,
                          right: padding,
                          bottom: padding),
                      margin: EdgeInsets.only(
                          top: avatarRadius, left: 20, right: 20),
                      decoration: BoxDecoration(
                          shape: BoxShape.rectangle,
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(padding),
                          boxShadow: [
                            BoxShadow(
                                color: Colors.black,
                                offset: Offset(0, 10),
                                blurRadius: 10),
                          ]),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          SizedBox(
                            height: 15.h,
                          ),
                          Text(
                            "Would you like to save ${widget.name} UPI ID?",
                            style: TextStyle(fontSize: 14.sp),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      onTap: () {
                                        removeAllPages(context);
                                        openMoneyTransferLanding(context);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 40.h,
                                        margin: EdgeInsets.only(
                                            left: 10,
                                            right: 5,
                                            top: 10,
                                            bottom: 0),
                                        decoration: BoxDecoration(
                                            color: lightBlue,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                            border:
                                                Border.all(color: lightBlue)),
                                        child: Center(
                                          child: Text(
                                            "No",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                                color: white),
                                          ),
                                        ),
                                      )),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                      onTap: () {
                                        addUPIId(context, "${widget.name}",
                                            "${widget.vpa}");
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 40.h,
                                        margin: EdgeInsets.only(
                                            left: 5,
                                            right: 10,
                                            top: 10,
                                            bottom: 0),
                                        decoration: BoxDecoration(
                                            color: green,
                                            borderRadius: BorderRadius.all(
                                                Radius.circular(25)),
                                            border: Border.all(color: green)),
                                        child: Center(
                                          child: Text(
                                            "Yes",
                                            style: TextStyle(
                                                fontSize: 18.sp,
                                                fontWeight: FontWeight.bold,
                                                color: white),
                                          ),
                                        ),
                                      )),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      left: padding,
                      right: padding,
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: avatarRadius,
                        child: ClipRRect(
                            borderRadius:
                                BorderRadius.all(Radius.circular(avatarRadius)),
                            child: Image.asset("assets/pin_alert.png")),
                      ),
                    ),
                  ],
                ),
              ],
            ));
  }

  Future addUPIId(context, holderName, upiId) async {
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

    final body = {
      "upi_id": "$upiId",
      "user_token": userToken,
      "holder_name": "$holderName"
    };

    printMessage("screen", "BODY : $body");

    final response = await http.post(Uri.parse("$upiAddAPI"),
        headers: headers, body: jsonEncode(body));

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      Navigator.pop(context);
      showToastMessage("${data['message'].toString()}");
      setState(() {
        if (data['status'].toString() == "1") {
          removeAllPages(context);
          openMoneyTransferLanding(context);
        } else {
          removeAllPages(context);
          openMoneyTransferLanding(context);
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }
}
