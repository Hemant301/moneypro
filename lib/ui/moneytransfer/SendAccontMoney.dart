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


class SendAccontMoney extends StatefulWidget {
  final String name;
  final String ifsc;
  final String accNo;
  final String logo;

  const SendAccontMoney(
      {Key? key,
      required this.name,
      required this.ifsc,
      required this.accNo,
      required this.logo})
      : super(key: key);

  @override
  _SendAccontMoneyState createState() => _SendAccontMoneyState();
}

class _SendAccontMoneyState extends State<SendAccontMoney> {
  var loading = false;
  var screen = "Send Money";

  var bankName = "";
  var branch = "";
  var accNo = "";
  var walletBal = "";
  var qrBalc = "";

  TextEditingController amountController = new TextEditingController();
  TextEditingController messageController = new TextEditingController();

  var debitFromWallet = false;
  var debitFromQr = false;

  var approved = "";

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();

    printMessage(screen, "Holder Name : ${widget.name}");
    printMessage(screen, "Bank ifsc : ${widget.ifsc}");
    printMessage(screen, "Bank accNo : ${widget.accNo}");

    if (widget.ifsc.length == 11) {
      generatePayoutToken(widget.ifsc.toString());
    }
    getUserDetails();
  }

  getUserDetails() async {
    var m = await generateXFormat(widget.accNo.toString());

    var wB = await getWalletBalance();
    var qB = await getQRBalance();

    var app = await getApproved();
    setState(() {
      accNo = m;
      walletBal = wB;
      qrBalc = qB;
      approved = app;
    });
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
            width: 24.w,
            color: orange,
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
          : SingleChildScrollView(
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
                                (widget.logo.toString() == "")
                                    ? Image.asset(
                                        'assets/bank.png',
                                        height: 30.h,
                                      )
                                    : SizedBox(
                                        width: 36.w,
                                        height: 36.h,
                                        child: Image.network(
                                          "$bankIconUrl${widget.logo.toString()}",
                                        ),
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
                                            fontSize: font15.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "$accNo",
                                        style: TextStyle(
                                            color: lightBlack,
                                            fontSize: font14.sp,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                      Text(
                                        "$bankName, $branch",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: font14.sp,
                                            fontWeight: FontWeight.normal),
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
                                      color: black, fontSize: inputFont.sp),
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
                                      color: black, fontSize: inputFont.sp),
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

  Future generatePayoutToken(code) async {
    setState(() {
      loading = true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response =
        await http.post(Uri.parse(payoutTokenGenerateAPI), headers: headers);

    var statusCode = response.statusCode;
    if (statusCode == 200) {
      setState(() {
        loading = false;
      });
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Response Token : $data");
      var token = data['result']['access_token'];
      getBankDetails(token, code);
    } else {
      setState(() {
        showToastMessage(somethingWrong);
      });
    }
  }

  Future getBankDetails(accessToken, code) async {
    try {
      setState(() {
        loading = true;
      });

      var headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
        "payoutMerchantId": "$payoutMerchantId"
      };

      final response =
          await http.get(Uri.parse("$ifscCodeAPI$code"), headers: headers);

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "IFSC Code : $data");

      setState(() {
        loading = false;

        if (data['status'].toString() == "0") {
          bankName = data['data']['bank'].toString();
          branch = data['data']['branch'].toString();
          var branchCity = data['data']['city'].toString();
          var branchState = data['data']['state'].toString();
          var branchAddress = data['data']['address'].toString();
        } else {
          showToastMessage(somethingWrong);
        }
      });
    } catch (e) {
      loading = false;
    }
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
      "bene_account": "${widget.accNo}",
      "ifsc_jcode": "${widget.ifsc}",
      "bene_name": "${widget.name}",
      "bene_email": "$email",
      "mobile": "$mobile",
      "purpose": "Wallet Withdrawal",
      "amount": "$amount",
      "receipt_card_no": "",
      "access_token": "$token",
      "wallet_type": (debitFromWallet) ? "wallet" : "qrwallet"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(walletPayoutInitiateAPI),
        body: jsonEncode(body), headers: headers);

    var statusCode = response.statusCode;

    printMessage(screen, "Response Settelment : $statusCode");
    Navigator.pop(context);

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Response Settelment : $data");

      var status = data['status'].toString();

      if (status == "1") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return showMessageDialog(
                  message:
                      "Your request is submitted successfully.\nYou may check your transaction status in History after 5 minutes.",
                  action: 3);
            });
      } else {
        showToastMessage(data['message'].toString());
      }
    } else {
      setState(() {
        showToastMessage(status500);
      });
    }
  }
}
