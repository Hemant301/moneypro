import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:moneypro_new/ui/home/Perspective.dart';
import 'package:moneypro_new/ui/models/Banks.dart';
import 'package:moneypro_new/ui/models/UPIList.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/AppKeys.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:upi_india/upi_app.dart';

class AddMoneyToWallet extends StatefulWidget {
  const AddMoneyToWallet({Key? key}) : super(key: key);

  @override
  _AddMoneyToWalletState createState() => _AddMoneyToWalletState();
}

class _AddMoneyToWalletState extends State<AddMoneyToWallet> {
  var screen = "Add Money";
  var loading = false;

  var moneyProBalc = "";
  var virAcc = "";
  var virIFSC = "";
  var accName = "";

  double mainWallet = 0.0;

  List<BankList> bankList = [];

  @override
  void initState() {
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);
    updateWalletBalances();
    getUserDetail();
  }

  getUserDetail() async {
    var vAc = await getVirtualAccNo();
    var vIF = await getVirtualAccIFSC();
    var role = await getRole();
    var rName = await getContactName();
    var comName = await getComapanyName();
    var na = await getHolderName();
    var fName = await getFirstName();
    var lName = await getLastName();

    setState(() {
      virAcc = vAc;
      virIFSC = vIF;

      printMessage(screen, "vAc : $vAc");
      printMessage(screen, "vIF : $vIF");
      printMessage(screen, "role : $role");
      printMessage(screen, "rName : $rName");
      printMessage(screen, "comName : $comName");

      /*if (role == "1") {
        accName = rName.toString();
      } else if (role == "2") {
        accName = "${fName.toString()} ${lName.toString()}";
      } else*/
      if (role == "3") {
        //accName = comName.toString();
        accName = na;
      } else {
        accName = "$comName}";
      }
    });
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();
    double mX = 0.0;
    double wX = 0.0;

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
      mainWallet = wX + mX;
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
                  Container(
                    margin: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        color: walletBg,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: walletBg)),
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
                      child: Wrap(
                        direction: Axis.horizontal,
                        children: [
                          Image.asset(
                            "assets/wallet.png",
                            height: 20.h,
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 10, top: 5),
                              child: Text(
                                "${formatDecimal2Digit.format(mainWallet)}",
                                // "$mainWallet",
                                style: TextStyle(
                                    color: white, fontSize: font15.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                      height: 40.h,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 30.0, right: 30),
                      child: Text(
                        "Kindly add the below given virtual account number as a benefinciary to your registerered account and tranfer amount instantly in your account.",
                        style: TextStyle(fontSize: font14.sp, color: black),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: Text(
                          "Your virtual account detail",
                          style: TextStyle(
                              color: black,
                              fontSize: font18.sp,
                              fontWeight: FontWeight.bold,
                              decoration: TextDecoration.underline),
                        ),
                      ),
                    ),
                    Center(
                      child: Image.asset(
                        'assets/icici-bank-vector-logo.png',
                        height: 120.h,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, top: 20, bottom: 5),
                      child: Row(
                        children: [
                          Text(
                            "A/c Name",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                          Spacer(),
                          Text(
                            "$companyName",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: gray,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, top: 10, bottom: 5),
                      child: Row(
                        children: [
                          Text(
                            "Virtual A/c No.",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                          Spacer(),
                          Text(
                            "$virAcc",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: gray,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 25.0, right: 25, top: 10, bottom: 5),
                      child: Row(
                        children: [
                          Text(
                            "IFSC Code",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                          Spacer(),
                          Text(
                            "$virIFSC",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          )
                        ],
                      ),
                    ),
                    Divider(
                      color: gray,
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 15),
                      child: Text(
                        "Note:",
                        style: TextStyle(
                            color: black,
                            fontSize: font18.sp,
                            fontWeight: FontWeight.bold,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20, left: 15),
                      child: Text(
                        "Instantly load you wallet through your virtual account number",
                        style: TextStyle(
                          color: black,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 5, left: 15),
                      child: Text(
                        "Amount transferred from your registered bank account will be credited instantly to your wallet. ",
                        style: TextStyle(
                          color: black,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    )
                  ],
                ),
              ),
              bottomNavigationBar: _buildBotton(),
            )));
  }

  _buildBotton() {
    return InkWell(
      onTap: () {
        setState(() {
          showAddMoneyPopup();
        });
      },
      child: Container(
        height: 45.h,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Center(
          child: Text(
            "ADD MONEY",
            style: TextStyle(fontSize: font16.sp, color: white),
          ),
        ),
      ),
    );
  }

  showAddMoneyPopup() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => AddMoneyPopup());
  }
}

class AddMoneyPopup extends StatefulWidget {
  const AddMoneyPopup({Key? key}) : super(key: key);

  @override
  _AddMoneyPopupState createState() => _AddMoneyPopupState();
}

class _AddMoneyPopupState extends State<AddMoneyPopup> {
  final amountController = new TextEditingController();

  var screen = "Add money popup";

  int upiIndex = 0;
  var upiId = "";
  var packageName = "";
  bool isRequestUpi = false;
  TextEditingController upiController = TextEditingController();

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => Center(
              child: Material(
                color: Colors.transparent,
                child: Wrap(
                  children: [
                    Container(
                      margin: EdgeInsets.only(left: 30, right: 30),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.only(
                            topRight: Radius.circular(25),
                            topLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25),
                            bottomLeft: Radius.circular(25),
                          ),
                          border: Border.all(color: white)),
                      child: Column(
                        children: [
                          Container(
                            margin: EdgeInsets.only(
                                top: 40, left: padding, right: padding),
                            decoration: BoxDecoration(
                              color: editBg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 10, bottom: 10),
                              child: TextFormField(
                                style: TextStyle(
                                    color: black, fontSize: inputFont.sp),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.next,
                                controller: amountController,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: new InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 10),
                                  counterText: "",
                                  label: Text("Enter amount"),
                                ),
                                maxLength: 6,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 5),
                            child: Text(
                              "Minimum amount is $rupeeSymbol 100",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font14.sp),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          displayUpiApps(),
                          _buildUPIRequestSection(),
                          SizedBox(
                            height: 20,
                          )
                          // InkWell(
                          //   onTap: () {
                          //     var id = DateTime.now().millisecondsSinceEpoch;
                          //     var amount = amountController.text.toString();

                          //     if (amount.length == 0) {
                          //       showToastMessage("Enter the amount");
                          //     } else {
                          //       closeKeyBoard(context);
                          //       double x = double.parse(amount);
                          //       if (x < 100) {
                          //         showToastMessage(
                          //             "Minimum amount is $rupeeSymbol 100");
                          //       } else {
                          //         paymentByUPI(id, amount);
                          //       }
                          //     }
                          //   },
                          //   child: Container(
                          //     height: 45.h,
                          //     width: MediaQuery.of(context).size.width,
                          //     margin: EdgeInsets.only(
                          //         top: 20, left: 25, right: 25, bottom: 20),
                          //     decoration: BoxDecoration(
                          //       color: lightBlue,
                          //       borderRadius:
                          //           BorderRadius.all(Radius.circular(25)),
                          //     ),
                          //     child: Center(
                          //       child: Text(
                          //         "ADD MONEY",
                          //         style: TextStyle(
                          //             fontSize: font16.sp, color: white),
                          //       ),
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ));
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
                isRequestUpi = true;
                ;
              });
              var id = DateTime.now().millisecondsSinceEpoch;
              var amount = amountController.text.toString();

              if (amount.length == 0) {
                showToastMessage("Enter the amount");
              } else {
                closeKeyBoard(context);
                double x = double.parse(amount);
                if (x < 100) {
                  showToastMessage("Minimum amount is $rupeeSymbol 100");
                } else {
                  paymentByUPI(id, amount);
                }
              }
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
                    isRequestUpi = false;
                  });
                  var id = DateTime.now().millisecondsSinceEpoch;
                  var amount = amountController.text.toString();

                  if (amount.length == 0) {
                    showToastMessage("Enter the amount");
                  } else {
                    closeKeyBoard(context);
                    double x = double.parse(amount);
                    if (x < 100) {
                      showToastMessage("Minimum amount is $rupeeSymbol 100");
                    } else {
                      paymentByUPI(id, amount);
                    }
                  }
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

  paymentByUPI(orderId, amount) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: "$pleaseWait");
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
      Navigator.pop(context);
      if (data['status'].toString() == "OK") {
        var token = data['cftoken'].toString();
        CashfreePGSDK.getUPIApps().then((value) {
          setState(() {
            getUPIAppNamesUPI(value, orderId, amount, token);
          });
        });
      } else {
        Navigator.pop(context);
      }
    });
  }

  getUPIAppNamesUPI(result, orderId, amount, token) async {
    String orderNote = "Order Note";

    if (result.length == 0) {
      showToastMessage("$noUPIapp");
    } else {
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
        "orderAmount": "$amount",
        "customerName": "$name",
        "orderCurrency": "INR",
        "appId": "$cashFreeAppId",
        "customerPhone": customerPhone,
        "customerEmail": customerEmail,
        "tokenData": "$token",
        "stage": "$cashFreePGMode",
        "orderNote": orderNote,
        "appName": packageName
      };
      Map<String, dynamic> requestinputParams = {
        "paymentOption": "upi",
        "upi_vpa": upiController.text,
        "orderId": "$orderId",
        "orderAmount": "$amount",
        "customerName": "$name",
        "orderCurrency": "INR",
        "appId": "$cashFreeAppId",
        "customerPhone": customerPhone,
        "customerEmail": customerEmail,
        "tokenData": "$token",
        "stage": "$cashFreePGMode",
        "orderNote": orderNote,
        // "appName": packageName
      };

      isRequestUpi == true
          ? printMessage(screen, "Input Params : $requestinputParams")
          : printMessage(screen, "Input Params : $inputParams");

      isRequestUpi == true
          ? CashfreePGSDK.doPayment(requestinputParams).then((value) {
              setState(() {
                verifySignatureByPG(value);
              });
              printMessage(screen, "doUPIPayment result : $value");
            })
          : CashfreePGSDK.doUPIPayment(inputParams).then((value) {
              setState(() {
                verifySignatureByPG(value);
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

  verifySignatureByPG(responsePG) async {
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

    if (responsePG['txStatus'].toString() == "SUCCESS") {
      printMessage(screen, "Transaction is Successful");
      setState(() {
        paymentStatusServer(
            orderId, orderAmount, paymentMode, txTime, signature, txStatus);
      });
    } else {
      showToastMessage(txMsg.toString());
    }
  }

  Future paymentStatusServer(paymentgateway_txn, paymentgateway_amount,
      paymentgateway_mode, txTime, signature, txStatus) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: "$pleaseWait");
          });
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$token",
      "paymentgateway_txn": "$paymentgateway_txn",
      "paymentgateway_amount": "$paymentgateway_amount",
      "paymentgateway_mode": "$paymentgateway_mode",
      "txTime": "$txTime",
      "signature": "$signature",
      "txStatus": "$txStatus",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(addWalletBalAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    printMessage(screen, "Response statusCode : $statusCode");

    setState(() {
      Navigator.pop(context);

      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Response paymentStatusUpdate : $data");
        _paymentSuccess(data['message'].toString());
      } else {
        showToastMessage(status500);
      }
    });
  }

  _paymentSuccess(msg) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                      border: Border.all(color: white)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      Image.asset(
                        'assets/thanks.png',
                        height: 48.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25, top: 20),
                        child: Text(
                          "Thankyou",
                          style: TextStyle(
                              fontSize: font15.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25, top: 10),
                        child: Text(
                          "$msg",
                          style: TextStyle(
                              fontSize: font14.sp,
                              color: black,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          removeAllPages(context);
                        },
                        child: Container(
                          height: 40.h,
                          width: MediaQuery.of(context).size.width * .6,
                          decoration: BoxDecoration(
                              color: green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              border: Border.all(color: green)),
                          child: Center(
                              child: Text(
                            "Ok",
                            style: TextStyle(fontSize: font15.sp, color: white),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }
}
