import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moneypro_new/ui/home/Perspective.dart';
import 'package:moneypro_new/ui/models/UPIList.dart';
import 'package:moneypro_new/ui/recharge/mobilerechange/MobilePaymentNew.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';

import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:upi_india/upi_app.dart';

class InvestorPayment extends StatefulWidget {
  final String amount;

  const InvestorPayment({Key? key, required this.amount}) : super(key: key);

  @override
  _InvestorPaymentState createState() => _InvestorPaymentState();
}

class _InvestorPaymentState extends State<InvestorPayment> {
  var screen = "Investor Payment";
  var packageName = "";
  var isCardOpen = false;
  var isUPIOpen = false;
  bool isRequestUpi = false;
  TextEditingController upiController = TextEditingController();

  final cardController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final cardMMController = TextEditingController();
  final cardYYController = TextEditingController();
  final cardCVVController = TextEditingController();

  double cardCharge = 0.0;

  FocusNode nodeMM = FocusNode();
  FocusNode nodeYY = FocusNode();
  FocusNode nodeCVV = FocusNode();
  checkUpiapp() {
    if (apps!.isNotEmpty) {
      packageName = apps!.first.packageName;
    } else {
      Fluttertoast.showToast(msg: "No Upi Found");
    }
  }

  @override
  void initState() {
    super.initState();
    checkUpiapp();
    calculateCharge();
    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();

    final inheritedWidget = StateContainer.of(context);

    inheritedWidget.updateMPBalc(value: mpBalc);
    if (mpBalc == null || mpBalc == 0) {
      mpBalc = 0;
      final inheritedWidget = StateContainer.of(context);
      inheritedWidget.updateMPBalc(value: mpBalc);
    }

    inheritedWidget.updateQRBalc(value: qrBalc);
    if (qrBalc == null || qrBalc == 0) {
      qrBalc = 0;
      final inheritedWidget = StateContainer.of(context);
      inheritedWidget.updateQRBalc(value: qrBalc);
    }
  }

  @override
  void dispose() {
    cardController.dispose();
    cardHolderNameController.dispose();
    cardMMController.dispose();
    cardYYController.dispose();
    cardCVVController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              backgroundColor: gray,
              appBar: appBarHome(context, "assets/lendbox_head.png", 60.0.w),
              body: Column(
                children: [
                  appSelectedBanner(context, "invest_banner.png", 150.0.h),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      margin: EdgeInsets.only(top: 10),
                      decoration: BoxDecoration(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(50.0)),
                        color: white,
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
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
                              Container(
                                margin: EdgeInsets.only(top: 15, left: 25),
                                width: MediaQuery.of(context).size.width,
                                child: Row(
                                  children: [
                                    Text(
                                      "Amount to be pay : $rupeeSymbol",
                                      style: TextStyle(
                                          color: black, fontSize: font14.sp),
                                    ),
                                    Text(" ${widget.amount}",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: font16.sp,
                                            fontWeight: FontWeight.bold)),
                                  ],
                                ),
                              ),
                              displayUpiApps(),
                              _buildUPIRequestSection(),
                              // _buildUPISection(),
                              _buildCardSection(),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
              bottomNavigationBar: _buildButtonSection(),
            )));
  }

  Widget displayUpiApps() {
    if (apps == null)
      return Center(child: CircularProgressIndicator());
    else if (apps!.length == 0)
      return Center(
        child: Text(
          "No apps found to handle transaction.",
        ),
      );
    else
      return Align(
        alignment: Alignment.topCenter,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Wrap(
            children: apps!.map<Widget>((UpiApp app) {
              return GestureDetector(
                onTap: () async {
                  setState(() {
                    packageName = app.packageName;
                    isUPIOpen = true;
                    isCardOpen = false;
                    isRequestUpi = false;
                  });
                  var id = DateTime.now().millisecondsSinceEpoch;
                  paymentByPGDirect(id, "${widget.amount}");
                },
                child: Container(
                  height: 100,
                  width: 100,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Image.memory(
                        app.icon,
                        height: 60,
                        width: 60,
                      ),
                      Text(app.name),
                    ],
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      );
  }

  _buildUPIRequestSection() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
              height: 50,
              width: MediaQuery.of(context).size.width / 2,
              child: TextFormField(
                controller: upiController,
                decoration: InputDecoration(hintText: 'Enter UPI ID'),
              )),
          InkWell(
            onTap: () async {
              if (upiController.text == "") {
                Fluttertoast.showToast(msg: "Enter UPI ID");
                return;
              }
              print(isRequestUpi);
              setState(() {
                isUPIOpen = true;
                isCardOpen = false;
                isRequestUpi = true;
              });
              var id = DateTime.now().millisecondsSinceEpoch;
              paymentByPGDirect(id, "${widget.amount}");
            },
            child: Container(
              width: MediaQuery.of(context).size.width / 4,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: lightBlue, borderRadius: BorderRadius.circular(20)),
              child: Center(
                child: Text(
                  "Pay",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  _buildUPISection() {
    return Card(
      color: tabBg,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      elevation: 10,
      margin: EdgeInsets.only(top: 15.0, left: 20, right: 20),
      child: InkWell(
        onTap: () {
          setState(() {
            isUPIOpen = true;
            isCardOpen = false;
            isRequestUpi = false;
          });
          var id = DateTime.now().millisecondsSinceEpoch;
          paymentByPGDirect(id, "${widget.amount}");
        },
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 4, top: 15, bottom: 15),
          child: Row(
            children: [
              Image.asset(
                'assets/upi_ar.png',
                height: 20.h,
                width: 20.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Row(
                children: [
                  Text(
                    "UPI",
                    style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Text(
                    "( 0% extra charges )",
                    style: TextStyle(
                      color: lightBlack,
                      fontSize: font12.sp,
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: 15.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  _buildCardSection() {
    return Card(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      elevation: 10,
      margin: EdgeInsets.only(top: 15.0, left: 20, right: 20, bottom: 20),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child: ExpansionTile(
              initiallyExpanded: isCardOpen,
              collapsedBackgroundColor: tabBg,
              backgroundColor: tabBg,
              onExpansionChanged: (val) {
                printMessage(screen, "Val : $val");
                setState(() {
                  isCardOpen = val;
                });
              },
              title: Row(
                children: [
                  Image.asset(
                    'assets/credit_card.png',
                    height: 20.h,
                    width: 20.w,
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Text(
                    "Card",
                    style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                    ),
                  ),
                  SizedBox(
                    width: 5.w,
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      "( 0.90% or max $rupeeSymbol 20 extra charges )",
                      style: TextStyle(
                        color: lightBlack,
                        fontSize: font12.sp,
                      ),
                    ),
                  ),
                ],
              ),
              children: [
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0),
                      child: Text(
                        "Debit card, Credit card are supported",
                        style: TextStyle(color: black, fontSize: font14.sp),
                      ),
                    )),
                Container(
                  margin: EdgeInsets.only(
                    top: padding,
                    left: 15,
                    right: 15,
                  ),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 10, bottom: 10),
                    child: TextFormField(
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        new CustomInputFormatter()
                      ],
                      style: TextStyle(color: black, fontSize: inputFont.sp),
                      keyboardType: TextInputType.number,
                      textInputAction: TextInputAction.next,
                      controller: cardController,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        hintText: "1234-5678-9012",
                        label: Text(
                          "Card No",
                          style:
                              TextStyle(color: lightBlack, fontSize: font14.sp),
                        ),
                      ),
                      maxLength: 19,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  margin: EdgeInsets.only(
                    left: 15,
                    right: 15,
                  ),
                  decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 10, bottom: 10),
                    child: TextFormField(
                      style: TextStyle(color: black, fontSize: inputFont.sp),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      textCapitalization: TextCapitalization.characters,
                      controller: cardHolderNameController,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        hintText: "Card holder name",
                        label: Text(
                          "Name",
                          style:
                              TextStyle(color: lightBlack, fontSize: font14.sp),
                        ),
                      ),
                      maxLength: 40,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 0, bottom: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0,
                                      right: 15,
                                      top: 10,
                                      bottom: 10),
                                  child: TextFormField(
                                    focusNode: nodeMM,
                                    style: TextStyle(
                                        color: black, fontSize: inputFont.sp),
                                    keyboardType: TextInputType.datetime,
                                    textInputAction: TextInputAction.next,
                                    controller: cardMMController,
                                    decoration: new InputDecoration(
                                      isDense: true,
                                      border: InputBorder.none,
                                      contentPadding: EdgeInsets.only(left: 0),
                                      counterText: "",
                                      label: Text(
                                        "MM",
                                        style: TextStyle(
                                            color: lightBlack,
                                            fontSize: font14.sp),
                                      ),
                                    ),
                                    maxLength: 2,
                                    onChanged: (val) {
                                      if (val.length == 2) {
                                        FocusScope.of(context)
                                            .requestFocus(nodeYY);
                                      }
                                    },
                                  ),
                                ),
                              ),
                              Expanded(
                                child: TextFormField(
                                  focusNode: nodeYY,
                                  style: TextStyle(
                                      color: black, fontSize: inputFont.sp),
                                  keyboardType: TextInputType.datetime,
                                  textInputAction: TextInputAction.next,
                                  controller: cardYYController,
                                  decoration: new InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 0),
                                    counterText: "",
                                    label: Text(
                                      "YYYY",
                                      style: TextStyle(
                                          color: lightBlack,
                                          fontSize: font14.sp),
                                    ),
                                  ),
                                  maxLength: 4,
                                  onChanged: (val) {
                                    if (val.length == 4) {
                                      FocusScope.of(context)
                                          .requestFocus(nodeCVV);
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                        ),
                        decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 10, bottom: 10),
                          child: TextFormField(
                            focusNode: nodeCVV,
                            style:
                                TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            controller: cardCVVController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                              counterText: "",
                              hintText: "123",
                              label: Text(
                                "CVV",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font14.sp),
                              ),
                            ),
                            maxLength: 3,
                            onChanged: (val) {
                              if (val.length == 3) {
                                closeKeyBoard(context);
                              }
                            },
                          ),
                        ),
                      ),
                      flex: 1,
                    )
                  ],
                ),
                Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10.0, top: 10),
                      child: Text(
                        "Charges paid with Credit/Debit card is : $rupeeSymbol ${formatDecimal2Digit.format(cardCharge)}",
                        style: TextStyle(color: black, fontSize: font12.sp),
                      ),
                    )),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildButtonSection() {
    return Container(
      height: (isCardOpen) ? 127.h : 120.h,
      color: white,
      child: Column(
        children: [
          (isCardOpen)
              ? Container(
                  width: MediaQuery.of(context).size.width * .8,
                  height: 40.h,
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 5, bottom: 0),
                  decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: lightBlue)),
                  child: InkWell(
                    onTap: () {
                      var cardNo =
                          cardController.text.replaceAll(' ', '').toString();
                      var cardName = cardHolderNameController.text.toString();
                      var month = cardMMController.text.toString();
                      var year = cardYYController.text.toString();
                      var cardCVV = cardCVVController.text.toString();

                      if (cardNo.length == 0) {
                        showToastMessage("Enter card number");
                        return;
                      } else if (cardName.length == 0) {
                        showToastMessage("Enter card name");
                        return;
                      } else if (month.length == 0) {
                        showToastMessage("Enter card expire month");
                        return;
                      } else if (year.length != 4) {
                        showToastMessage("Enter card expire year");
                        return;
                      } else if (cardCVV.length != 3) {
                        showToastMessage("Enter card cvv");
                        return;
                      }

                      var id = DateTime.now().millisecondsSinceEpoch;
                      var amount = double.parse(widget.amount);
                      amount = amount + cardCharge;
                      printMessage(screen, "Paid Amount : $amount");
                      paymentByPGDirect(id, "$amount");
                    },
                    child: Center(
                      child: Text(
                        "$recharge_",
                        style: TextStyle(
                          color: white,
                          fontSize: font14.sp,
                        ),
                      ),
                    ),
                  ),
                )
              : Container(
                  height: 40.h,
                ),
          SizedBox(
            height: 5.h,
          ),
          // Text(
          //   powered_by,
          //   style: TextStyle(
          //       color: black, fontSize: 16.sp, fontWeight: FontWeight.bold),
          // ),
          SizedBox(
            height: 5.h,
          ),
          Divider(),
          Row(
            children: [
              Expanded(
                  child: Image.asset(
                'assets/pci.png',
                height: 16.h,
              )),
              Expanded(
                  child: Image.asset(
                'assets/upi.png',
                height: 16.h,
              )),
              Expanded(
                  child: Image.asset(
                'assets/iso.png',
                height: 16.h,
              )),
            ],
          ),
          SizedBox(
            height: 5.h,
          ),
        ],
      ),
    );
  }

  paymentByPGDirect(orderId, amount) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, move to payment gateway");
          });
    });

    var headers = {
      "Content-Type": "application/json",
      "x-client-id": "$cashFreeAppId",
      "x-client-secret": "$cashFreeSecretKey"
    };

    var body = {
      "orderId": "$orderId",
      "orderAmount": "$amount",
      "orderCurrency": "INR"
    };

    final response = await http.post(Uri.parse(cashFreeTokenAPI),
        body: json.encode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "getCashFreeToken : $data");

    setState(() {
      if (data['status'].toString() == "OK") {
        var token = data['cftoken'].toString();
        moveToPaymentGateway(orderId, token, amount);
      } else {
        Navigator.pop(context);
      }
    });
  }

  moveToPaymentGateway(orderId, token, difAmt) async {
    String orderNote = "Order Note";

    var name = await getContactName();
    var customerPhone = await getMobile();
    var customerEmail = await getEmail();

    Map<String, dynamic> inputFinalParams = {};

    Map<String, dynamic> inputParams = {
      "orderId": "$orderId",
      "orderAmount": "$difAmt",
      "customerName": "$name",
      "orderCurrency": "INR",
      "appId": "$cashFreeAppId",
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "tokenData": "$token",
      "stage": "$cashFreePGMode",
      "orderNote": orderNote,
    };

    if (isCardOpen) {
      var cardNo = cardController.text.replaceAll(' ', '').toString();
      var cardName = cardHolderNameController.text.toString();
      var month = cardMMController.text.toString();
      var year = cardYYController.text.toString();
      var cardCVV = cardCVVController.text.toString();

      Map<String, dynamic> inputCardParams = {
        "paymentOption": "card",
        "card_number": "$cardNo",
        "card_expiryMonth": "$month",
        "card_expiryYear": "$year",
        "card_holder": "$cardName",
        "card_cvv": "$cardCVV",
      };

      inputFinalParams.addAll(inputCardParams);

      inputFinalParams.addAll(inputParams);

      printMessage(screen, "Input Params : $inputFinalParams");

      CashfreePGSDK.doPayment(inputFinalParams).then((value) {
        setState(() {
          verifySignature(value);
        });
        printMessage(screen, "Final result : $value");
      });
    }

    if (isUPIOpen) {
      CashfreePGSDK.getUPIApps().then((value) {
        setState(() {
          getUPIAppNames(value, orderId, difAmt, token);
        });
      });
    }
  }

  verifySignature(responsePG) async {
    // if (Platform.isAndroid) {
    //  const platform = const MethodChannel("MICRO_ATM_CHANNEL");

    var txStatus = responsePG['txStatus'];
    var orderAmount = responsePG['orderAmount'];
    var paymentMode = responsePG['paymentMode'];
    var orderId = responsePG['orderId'];
    var txTime = responsePG['txTime'];
    var txMsg = responsePG['txMsg'];
    var type = responsePG['type'];
    var referenceId = responsePG['referenceId'];
    var signature = responsePG['signature'];

    printMessage(screen, "TxStatus    : $txStatus");
    printMessage(screen, "orderAmount : $orderAmount");
    printMessage(screen, "paymentMode : $paymentMode");
    printMessage(screen, "orderId     : $orderId");
    printMessage(screen, "txTime      : $txTime");
    printMessage(screen, "txMsg       : $txMsg");
    printMessage(screen, "type        : $type");
    printMessage(screen, "referenceId : $referenceId");
    printMessage(screen, "signature   : $signature");

    var arr = {
      "orderId": "$orderId",
      "orderAmount": "$orderAmount",
      "referenceId": "$referenceId",
      "txStatus": "$txStatus",
      "paymentMode": "$paymentMode",
      "txMsg": "$txMsg}",
      "txTime": "$txTime}",
    };

    if (responsePG['txStatus'].toString() == "SUCCESS") {
      printMessage(screen, "Transaction is Successful");
      setState(() {
        if (isCardOpen) {
          sendResponse(orderId, "${widget.amount}", signature, referenceId);
        } else {
          sendResponse(orderId, orderAmount, signature, referenceId);
        }
      });
    } else if (responsePG['txStatus'].toString() == "FAILED") {
      printMessage(screen, "Transaction is FAILED");
      Navigator.pop(context);
      showErrorAlert("${widget.amount}", orderId, "FAILED");
    } else if (responsePG['txStatus'].toString() == "CANCELLED") {
      printMessage(screen, "Transaction is CANCELLED");
      Navigator.pop(context);
      showErrorAlert("${widget.amount}", orderId, "CANCELLED");
    } else {
      Navigator.pop(context);
      showToastMessage(txStatus.toString());
    }
  }

  getUPIAppNames(result, orderId, difAmt, token) async {
    if (result.length == 0) {
      showToastMessage("$noUPIapp");
    } else {
      String orderNote = "Order Note";
      var upiId = "";
      List<UPIList> list = [];

      for (int i = 0; i < result.length; i++) {
        var displayName = result[i]['displayName'];
        var id = result[i]['id'];
        printMessage(screen, "Display Name : $displayName with Index : $id");
        UPIList w2 = new UPIList(name: "$displayName", id: "$id");
        list.add(w2);
      }

      if (checkIdPresent(list, "PhonePe")) {
        upiId = "com.phonepe.app";
      } else if (checkIdPresent(list, "GPay")) {
        upiId = "com.google.android.apps.nbu.paisa.user";
      } else if (checkIdPresent(list, "Paytm")) {
        upiId = "net.one97.paytm";
      } else if (checkIdPresent(list, "Amazon")) {
        upiId = "in.amazon.mShop.android.shopping";
      } else if (checkIdPresent(list, "Bhim")) {
        upiId = "in.org.npci.upiapp";
      } else if (checkIdPresent(list, "Truecaller")) {
        upiId = "com.truecaller";
      } else if (checkIdPresent(list, "iMobile Pay")) {
        upiId = "com.csam.icici.bank.imobile";
      } else {
        upiId = result[0]['id'].toString();
      }

      var name = await getContactName();
      var customerPhone = await getMobile();
      var customerEmail = await getEmail();

      Map<String, dynamic> inputParams = {
        "orderId": "$orderId",
        "orderAmount": "$difAmt",
        "customerName": "$name",
        "orderCurrency": "INR",
        "appId": "$cashFreeAppId",
        "customerPhone": customerPhone,
        "customerEmail": customerEmail,
        "tokenData": "$token",
        "stage": "$cashFreePGMode",
        "orderNote": orderNote,
        "appName": packageName,
      };
      Map<String, dynamic> requestinputParams = {
        "paymentOption": "upi",
        "upi_vpa": upiController.text,
        "orderId": "$orderId",
        "orderAmount": "$difAmt",
        "customerName": "$name",
        "orderCurrency": "INR",
        "appId": "$cashFreeAppId",
        "customerPhone": customerPhone,
        "customerEmail": customerEmail,
        "tokenData": "$token",
        "stage": "$cashFreePGMode",
        "orderNote": orderNote,
      };

      isRequestUpi == true
          ? printMessage(screen, "Input Params : $requestinputParams")
          : printMessage(screen, "Input Params : $inputParams");

      isRequestUpi == true
          ? CashfreePGSDK.doPayment(requestinputParams).then((value) {
              setState(() {
                verifySignature(value);
              });
              printMessage(screen, "doUPIPayment result : $value");
            })
          : CashfreePGSDK.doUPIPayment(inputParams).then((value) {
              setState(() {
                verifySignature(value);
              });
              printMessage(screen, "doUPIPayment result : $value");
            });
    }
  }

  checkIdPresent(List<UPIList> list, value) {
    var isPass = false;
    for (int i = 0; i < list.length; i++) {
      if (value == list[i].name) {
        isPass = true;
        break;
      } else {
        isPass = false;
      }
    }
    return isPass;
  }

  Future sendResponse(orderId, orderAmount, signature, referenceId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "orderId": "$orderId",
      "token": "$token",
      "amount": "$orderAmount",
      "signature": "$signature",
      "referenceId": "$referenceId"
    };

    printMessage(screen, "Send body : $body");

    final response = await http.post(Uri.parse(addfundResposeAddAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        Navigator.pop(context);
        printMessage(screen, "Send Response : ${data}");
        if (data['status'].toString() == "1") {
          closeCurrentPage(context);
          //showToastMessage(data['message'].toString());
          showErrorAlert(orderAmount, orderId, "Success");
        } else {
          //showToastMessage(data['message'].toString());
          showErrorAlert(orderAmount, orderId, "Failed");
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  showErrorAlert(amount, orderId, status) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AddMoneyResponse(
                amount: amount,
                transId: orderId,
                status: status,
              ),
            ));
  }

  calculateCharge() {
    double v1 = 0.09;
    double v2 = double.parse(widget.amount);
    double v3 = 100;

    double v4 = (v2 / v3) * v1;

    if (v4 > 20) {
      cardCharge = 20.0;
    } else {
      cardCharge = v4;
    }
    printMessage(screen, "v4 : ${formatNow.format(v4)}");
    printMessage(screen, "cardCharge : ${formatNow.format(cardCharge)}");
  }
}

class AddMoneyResponse extends StatelessWidget {
  final String amount;
  final String transId;
  final String status;

  const AddMoneyResponse(
      {Key? key,
      required this.amount,
      required this.transId,
      required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0))),
            child: Wrap(children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 40, bottom: 0, right: 20),
                child: Row(
                  children: [
                    Container(
                      height: 30.h,
                      width: 30.w,
                      decoration: BoxDecoration(
                          color: (status.toString() == "Success") ? green : red,
                          shape: BoxShape.circle),
                      child: Center(
                        child: (status.toString() == "Success")
                            ? Image.asset(
                                'assets/tick.png',
                                height: 16.h,
                                color: white,
                              )
                            : Icon(
                                Icons.clear,
                                size: 16,
                                color: white,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$status",
                          style: TextStyle(color: black, fontSize: font16.sp),
                        ),
                        Text(
                          "$transId",
                          style:
                              TextStyle(color: lightBlack, fontSize: font14.sp),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, top: 20, right: 60),
                child: Row(
                  children: [
                    Text(
                      "Amount",
                      style: TextStyle(color: lightBlack, fontSize: font14.sp),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "$rupeeSymbol $amount",
                        style: TextStyle(
                            color: black,
                            fontSize: font16.sp,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 60.0, right: 60, top: 10, bottom: 20),
                child: Row(
                  children: [
                    Text(
                      "Transfer to",
                      style: TextStyle(color: lightBlack, fontSize: font14.sp),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Investment Account",
                        style: TextStyle(
                            color: black,
                            fontSize: font16.sp,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.right,
                      ),
                    )
                  ],
                ),
              ),
              InkWell(
                onTap: () {
                  removeAllPages(context);
                },
                child: Container(
                  height: 45.h,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 20),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Center(
                    child: Text(
                      "Ok".toUpperCase(),
                      style: TextStyle(fontSize: font13.sp, color: white),
                    ),
                  ),
                ),
              )
            ])));
  }
}
