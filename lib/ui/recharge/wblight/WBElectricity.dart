import 'dart:math';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/home/Perspective.dart';
import 'package:moneypro_new/ui/models/KeyValuePair.dart';
import 'package:moneypro_new/ui/models/UPIList.dart';
import 'package:moneypro_new/ui/recharge/mobilerechange/MobilePaymentNew.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';

import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:upi_india/upi_app.dart';

class WBElectricity extends StatefulWidget {
  final Map map;

  const WBElectricity({Key? key, required this.map}) : super(key: key);

  @override
  _WBElectricityState createState() => _WBElectricityState();
}

class _WBElectricityState extends State<WBElectricity> {
  var packageName = "";
  var screen = "West Bill";
  var loading = false;

  var billerId;
  var billerName;
  var paramName;
  var paramName_1;
  var paramName_2;
  var paramName_3;
  var paramName_4;
  var icon;
  var isAdhoc;
  var fetchOption;
  var state;
  var position;

  var paramMain;
  var paramFirst;
  var paramSecond;
  var paramThird;
  var paramFourth;
  var category;

  TextEditingController paramNameController = new TextEditingController();

  final param1Controller = new TextEditingController();
  final param2Controller = new TextEditingController();
  final param3Controller = new TextEditingController();
  final param4Controller = new TextEditingController();

  final partialAmtController = new TextEditingController();

  String bbpsToken = "";

  var requestTimeStamp;
  var refId;

  var accountHolderName;
  var dueDate;
  var getBillDate;

  var showDetails = false;
  var checkedValue = false;

  String moneyProBalc = "0";

  var isCardOpen = false;
  var isUPIOpen = false;

  final cardController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final cardMMController = TextEditingController();
  final cardYYController = TextEditingController();
  final cardCVVController = TextEditingController();
  bool isRequestUpi = false;
  TextEditingController upiController = TextEditingController();
  FocusNode nodeMM = FocusNode();
  FocusNode nodeYY = FocusNode();
  FocusNode nodeCVV = FocusNode();

  List<KeyValuePair> keyPairList = [];

  dynamic currentTime;

  var isQuickPay;

  double cardCharge = 0.0;

  var distributName = "";

  var inputNo;

  double welcomeCharge = 1.2;
  var welcomeAMT = "";
  var isWelcomeOffer = false;
  var showBal = "";

  var actualRechargeAmount = "";
  double remainAmt = 0.0;

  var isWallMore = false;

  var _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  Random _rnd = Random();
  DateTime currentDate = DateTime.now();
  final yearFormat = new DateFormat('yyyy');
  final timeFormat = new DateFormat('HHmm');
  final dateFormat = new DateFormat('DDD');
  var currentYear = "";
  var timeH = "";
  var cDate = "";
  var finalString = "";

  int paramCount = 1;

  var month1Date;
  var month1Amount;
  var month1Period;

  var month2Date;
  var month2Amount;
  var month2Period;

  var month3Date;
  var month3Amount;
  var month3Period;

  var mainWallet;
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

    getBBPSToken();
    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();

    setState(() {
      inputNo = "${widget.map['inputNo']}";
      billerId = "${widget.map['billerId']}";
      billerName = "${widget.map['billerName']}";
      paramName = "${widget.map['paramName']}";
      paramName_1 = "${widget.map['paramName_1']}";
      paramName_2 = "${widget.map['paramName_2']}";
      paramName_3 = "${widget.map['paramName_3']}";
      paramName_4 = "${widget.map['paramName_4']}";
      icon = "${widget.map['icon']}";
      isAdhoc = "${widget.map['isAdhoc']}";
      fetchOption = "${widget.map['fetchOption']}";
      state = "${widget.map['state']}";
      position = "${widget.map['position']}";
      category = "${widget.map['category']}";

      if (paramName_1.toString() == "null") {
        paramName_1 = "";
      }

      if (paramName_2.toString() == "null") {
        paramName_2 = "";
      }

      if (paramName_3.toString() == "null") {
        paramName_3 = "";
      }

      if (paramName_4.toString() == "null") {
        paramName_4 = "";
      }

      if (fetchOption == "MANDATORY") {
        setState(() {
          isQuickPay = false;
        });
      } else {
        setState(() {
          isQuickPay = true;
        });
      }

      if (inputNo.toString() != "") {
        paramNameController =
            TextEditingController(text: "${inputNo.toString()}");
      }

      printMessage(screen, "billerName : $billerName");
    });

    setState(() {
      currentYear = yearFormat.format(currentDate);
      timeH = timeFormat.format(currentDate);
      cDate = dateFormat.format(currentDate);
      currentYear = currentYear[3];

      finalString = "${getRandomString(27)}$currentYear$cDate$timeH";
    });

    getParamCount();
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  @override
  void dispose() {
    paramNameController.dispose();
    param1Controller.dispose();
    param2Controller.dispose();
    param3Controller.dispose();
    param4Controller.dispose();

    cardController.dispose();
    cardHolderNameController.dispose();
    cardMMController.dispose();
    cardYYController.dispose();
    cardCVVController.dispose();

    partialAmtController.dispose();
    super.dispose();
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
      moneyProBalc = mpBalc;
      mainWallet = mpBalc;
      if (moneyProBalc.toString() == "") {
        moneyProBalc = "0.0";
      }

      welcomeAMT = walBalc;
      var x = double.parse(moneyProBalc) + double.parse(welcomeAMT);
      moneyProBalc = "$moneyProBalc";
      showBal = "$x";
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              backgroundColor: white,
              appBar: appBarHome(context, "assets/bbps_2.png", 24.0.w),
              body: (loading)
                  ? Center(child: circularProgressLoading(40.0))
                  : ListView(
                      children: [
                        appSelectedBanner(
                            context, "recharge_banner.png", 150.0.h),
                        _buildInputFields(),
                      ],
                    ),
              bottomNavigationBar: Container(
                margin: EdgeInsets.only(bottom: 10),
                child: (showDetails)
                    ? _buildButtonSection()
                    : Wrap(
                        alignment: WrapAlignment.center,
                        children: [
                          Container(
                            width: MediaQuery.of(context).size.width * .8,
                            height: 40.h,
                            margin: EdgeInsets.only(
                                left: 20, right: 20, top: 10, bottom: 0),
                            decoration: BoxDecoration(
                                color: lightBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                                border: Border.all(color: lightBlue)),
                            child: InkWell(
                              onTap: () {
                                paramMain = paramNameController.text.toString();

                                if (paramMain.toString().length == 0) {
                                  showToastMessage("Enter the $paramName");
                                  return;
                                }

                                if (paramName_1.toString().length != 0) {
                                  paramFirst = param1Controller.text.toString();
                                  if (paramFirst.toString().length == 0) {
                                    showToastMessage("Enter the $paramName_1");
                                    return;
                                  }
                                }

                                if (paramName_2.toString().length != 0) {
                                  paramSecond =
                                      param2Controller.text.toString();
                                  if (paramSecond.toString().length == 0) {
                                    showToastMessage("Enter the $paramName_2");
                                    return;
                                  }
                                }

                                if (paramName_3.toString().length != 0) {
                                  paramThird = param3Controller.text.toString();
                                  if (paramThird.toString().length == 0) {
                                    showToastMessage("Enter the $paramName_3");
                                    return;
                                  }
                                }

                                if (paramName_4.toString().length != 0) {
                                  paramFourth =
                                      param4Controller.text.toString();
                                  if (paramFourth.toString().length == 0) {
                                    showToastMessage("Enter the $paramName_4");
                                    return;
                                  }
                                }

                                if (bbpsToken.toString() == "") {
                                  showToastMessage(somethingWrong);
                                  return;
                                }
                                closeKeyBoard(context);
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                                getBillerDetails();
                              },
                              child: Center(
                                child: Text(
                                  "$search",
                                  style: TextStyle(
                                    color: white,
                                    fontSize: font14.sp,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
              ),
            )));
  }

  _buildInputFields() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
        color: white,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 30.0, left: 25, right: 25),
            child: Row(
              children: [
                SizedBox(
                  child: Image.network(
                    "$billerIconUrl${icon}",
                  ),
                  width: 24.w,
                  height: 24.h,
                ),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "$billerName".trim(),
                        style: TextStyle(
                            color: black,
                            fontSize: font16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Text(
                        state,
                        style: TextStyle(color: lightBlue, fontSize: font13.sp),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: padding,
              left: padding,
              right: padding,
            ),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 12, bottom: 12),
              child: Row(
                children: [
                  Image.asset(
                    'assets/invoice.png',
                    height: 20.h,
                  ),
                  SizedBox(
                    width: 4.w,
                  ),
                  Text(
                    "Sample Bill",
                    style: TextStyle(color: black, fontSize: font14.sp),
                  )
                ],
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: padding,
              left: padding,
              right: padding,
            ),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 10, bottom: 10),
              child: TextFormField(
                style: TextStyle(
                    color: black,
                    fontSize: inputFont.sp,
                    fontWeight: FontWeight.bold),
                keyboardType: TextInputType.text,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.characters,
                controller: paramNameController,
                decoration: new InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10),
                  counterText: "",
                  label: Text("${paramName}"),
                ),
                maxLength: 80,
              ),
            ),
          ),
          (paramName_1.toString() == "")
              ? Container()
              : Container(
                  margin: EdgeInsets.only(
                      top: padding, left: padding, right: padding),
                  decoration: BoxDecoration(
                    color: editBg,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 10, bottom: 10),
                    child: TextFormField(
                      style: TextStyle(color: black, fontSize: inputFont.sp),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.characters,
                      controller: param1Controller,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("${paramName_1}"),
                      ),
                      maxLength: 80,
                    ),
                  ),
                ),
          (paramName_2.toString() == "")
              ? Container()
              : Container(
                  margin: EdgeInsets.only(
                      top: padding, left: padding, right: padding),
                  decoration: BoxDecoration(
                    color: editBg,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 10, bottom: 10),
                    child: TextFormField(
                      textCapitalization: TextCapitalization.characters,
                      style: TextStyle(color: black, fontSize: inputFont.sp),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      controller: param2Controller,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("${paramName_2}"),
                      ),
                      maxLength: 80,
                    ),
                  ),
                ),
          (paramName_3.toString() == "")
              ? Container()
              : Container(
                  margin: EdgeInsets.only(
                      top: padding, left: padding, right: padding),
                  decoration: BoxDecoration(
                    color: editBg,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 10, bottom: 10),
                    child: TextFormField(
                      style: TextStyle(color: black, fontSize: inputFont.sp),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      textCapitalization: TextCapitalization.characters,
                      controller: param3Controller,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("${paramName_3}"),
                      ),
                      maxLength: 80,
                    ),
                  ),
                ),
          (paramName_4.toString() == "")
              ? Container()
              : Container(
                  margin: EdgeInsets.only(
                      top: padding, left: padding, right: padding),
                  decoration: BoxDecoration(
                    color: editBg,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 10, bottom: 10),
                    child: TextFormField(
                      style: TextStyle(color: black, fontSize: inputFont.sp),
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.done,
                      controller: param4Controller,
                      textCapitalization: TextCapitalization.characters,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("${paramName_4}"),
                      ),
                      maxLength: 80,
                    ),
                  ),
                ),
          (showDetails)
              ? Column(
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "Due Amount",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              Spacer(),
                              Text(
                                "$rupeeSymbol $actualRechargeAmount",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        (dueDate.toString() == "" ||
                                dueDate.toString() == "null")
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, right: 30, left: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      "Due Date",
                                      style: TextStyle(
                                          color: lightBlack,
                                          fontSize: font13.sp),
                                    ),
                                    Spacer(),
                                    Text(
                                      "$dueDate",
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
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Customer Name",
                                  style: TextStyle(
                                      color: lightBlack, fontSize: font13.sp),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "$accountHolderName",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font13.sp,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              )
                            ],
                          ),
                        ),
                        (getBillDate.toString() == "" ||
                                getBillDate.toString() == "null")
                            ? Container()
                            : Padding(
                                padding: const EdgeInsets.only(
                                    top: 20.0, right: 30, left: 30, bottom: 15),
                                child: Row(
                                  children: [
                                    Text(
                                      "Bill Date", //wb26k2153
                                      style: TextStyle(
                                          color: lightBlack,
                                          fontSize: font13.sp),
                                    ),
                                    Spacer(),
                                    Text(
                                      "$getBillDate",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: font13.sp,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                        _buildAdditionalDetails(),
                      ],
                    ),
                    Divider(),
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 10.0, right: 30, left: 30),
                      child: Text(
                        billMsg,
                        style:
                            TextStyle(color: lightBlack, fontSize: font14.sp),
                      ),
                    ),
                    (isAdhoc.toString() == "1")
                        ? Container(
                            margin: EdgeInsets.only(
                                top: padding, left: padding, right: padding),
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
                                keyboardType: TextInputType.text,
                                textInputAction: TextInputAction.done,
                                controller: param3Controller,
                                textCapitalization:
                                    TextCapitalization.characters,
                                decoration: new InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 10),
                                  counterText: "",
                                  label: Text("${paramName_3}"),
                                ),
                                maxLength: 80,
                              ),
                            ),
                          )
                        : Container(),
                    (mainWallet.toString() == "0" ||
                            mainWallet.toString() == "0.0" ||
                            mainWallet.toString() == "null")
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(
                                top: 15.0, right: 30, left: 30),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  debitFrom,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.w400),
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Checkbox(
                                        value: checkedValue,
                                        onChanged: (val) async {
                                          var mpBalc = await getWalletBalance();

                                          setState(() {
                                            double walletValue = 0;
                                            double rechargeValue = 0;

                                            setState(() {
                                              if (mpBalc.toString() == "") {
                                                walletValue = 0;
                                              } else {
                                                walletValue =
                                                    double.parse(mpBalc);
                                              }

                                              if (actualRechargeAmount
                                                      .toString() ==
                                                  "") {
                                                rechargeValue = 0;
                                              } else {
                                                rechargeValue = double.parse(
                                                    actualRechargeAmount);
                                              }
                                            });

                                            if (walletValue < rechargeValue) {
                                              setState(() {
                                                remainAmt =
                                                    rechargeValue - walletValue;
                                              });

                                              if (isWelcomeOffer) {
                                                remainAmt =
                                                    remainAmt - welcomeCharge;
                                              }
                                            }

                                            if (walletValue < 0) {
                                              closeKeyBoard(context);
                                              showToastMessage(
                                                  "Your wallet does not have enough balance");
                                            } else {
                                              closeKeyBoard(context);
                                              checkedValue = val!;
                                            }
                                          });
                                        }),
                                    Text(
                                      "$wallet",
                                      style: TextStyle(
                                          fontSize: font14.sp, color: black),
                                    ),
                                    Spacer(),
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                          color: walletBg,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(color: walletBg)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 8.0, top: 5, bottom: 5),
                                        child: Wrap(
                                          direction: Axis.horizontal,
                                          children: [
                                            Image.asset(
                                              "assets/wallet.png",
                                              height: 24.h,
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8.0,
                                                    right: 8,
                                                    top: 5),
                                                child: Text(
                                                  "$showBal",
                                                  style: TextStyle(
                                                      color: white,
                                                      fontSize: font15.sp),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                                (remainAmt != 0 && checkedValue)
                                    ? Padding(
                                        padding:
                                            const EdgeInsets.only(left: 15.0),
                                        child: Text(
                                          "Remaining amount $rupeeSymbol ${formatNow.format(remainAmt)}",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: font14.sp),
                                        ),
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                    (isWelcomeOffer) ? _buildOfferRwo() : Container(),
                  ],
                )
              : Container(),
          Divider(),
          ((showDetails))
              ? Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15.0, left: 25, right: 25),
                      child: Text(
                        selectPayOptions,
                        style: TextStyle(
                            color: black,
                            fontSize: font15,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    displayUpiApps(),
                    _buildUPIRequestSection(),
                    // _buildUPISection(),
                    _buildCardSection(),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }

  getParamCount() {
    if (paramName_1.toString() != "") {
      setState(() {
        paramCount = 2;
      });
    }
    if (paramName_2.toString() != "") {
      setState(() {
        paramCount = 3;
      });
    }
    if (paramName_3.toString() != "") {
      setState(() {
        paramCount = 4;
      });
    }
    if (paramName_4.toString() != "") {
      setState(() {
        paramCount = 5;
      });
    }

    printMessage(screen, "Param Count : $paramCount");
  }

  Future getBBPSToken() async {
    setState(() {
      loading = true;
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
        loading = false;
        var status = data['status'];
        if (status.toString() == "1") {
          bbpsToken = data['bbps_token'].toString();
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

  Future getBillerDetails() async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while we are fetching your bill");
          });
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "token": "$bbpsToken",
      "billerId": "$billerId",
      "param_1": "$paramName",
      "val_1": "$paramMain",
      "param_2": "$paramName_1",
      "val_2": "$paramFirst",
      "param_3": "$paramName_2",
      "val_3": "$paramSecond",
      "param_4": "$paramName_3",
      "val_4": "$paramThird",
      "param_5": "$paramName_4",
      "val_5": "$paramFourth",
      "refId": "$finalString",
      "param_count": "$paramCount"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(billFaceAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");

      setState(() {
        Navigator.pop(context);
        var status = data['status'];
        if (status.toString() == "1") {
          if (data['fetch_details'].toString() != "null") {
            var code = data['fetch_details']['code'];
            if (code.toString() == "200") {
              setState(() {
                showDetails = true;
              });
              requestTimeStamp = data['fetch_details']['payload']
                      ['requestTimeStamp']
                  .toString();

              refId = data['fetch_details']['payload']['refId'].toString();

              actualRechargeAmount =
                  data['fetch_details']['payload']['amount'].toString();
              accountHolderName = data['fetch_details']['payload']
                      ['accountHolderName']
                  .toString();
              dueDate = data['fetch_details']['payload']['dueDate'].toString();
              getBillDate =
                  data['fetch_details']['payload']['billDate'].toString();

              if (billerName.toString() == "Bharat Gas (BPCL)") {
                distributName = data['fetch_details']['payload']
                        ['additionalParams']['Distributor Name']
                    .toString();
              }

              var additional =
                  data['fetch_details']['payload']['additionalParams'];

              printMessage(screen, "Additionl : ${additional.length}");

              if (additional.length != 0) {
                /*Map add = data['fetch_details']['payload']['additionalParams'];
              add.forEach((k, v) => print("Key : $k, Value : $v"));
              add.forEach((k, v) {
                KeyValuePair kV = new KeyValuePair(key: "$k", value: "$v");
                keyPairList.add(kV);
              });*/

                printMessage(screen,
                    "One Month : ${data['fetch_details']['payload']['additionalParams']}");

                month1Date = data['fetch_details']['payload']
                    ['additionalParams']['1 Month Due Date'];
                month1Amount = data['fetch_details']['payload']
                    ['additionalParams']['1 Month Amount'];
                month1Period = data['fetch_details']['payload']
                    ['additionalParams']['1 Month Period'];

                month2Date = data['fetch_details']['payload']
                    ['additionalParams']['2 Months Due Date'];
                month2Amount = data['fetch_details']['payload']
                    ['additionalParams']['2 Months Amount'];
                month2Period = data['fetch_details']['payload']
                    ['additionalParams']['2 Months Period'];

                month3Date = data['fetch_details']['payload']
                    ['additionalParams']['3 Months Due Date'];
                month3Amount = data['fetch_details']['payload']
                    ['additionalParams']['3 Months Amount'];
                month3Period = data['fetch_details']['payload']
                    ['additionalParams']['3 Months Period'];
              }

              if (welcomeAMT.toString() == "null" ||
                  welcomeAMT.toString() == "0" ||
                  welcomeAMT.toString() == "") {
                isWelcomeOffer = false;
              } else {
                isWelcomeOffer = true;
              }

              calculateCharge(actualRechargeAmount);
            } else {
              setState(() {
                var reason =
                    data['fetch_details']['payload']['errors'][0]['reason'];
                showToastMessage(reason.toString());
                showDetails = false;
              });
            }
          } else {
            showToastMessage(somethingWrong);
            setState(() {
              showDetails = false;
            });
          }
        } else {
          showToastMessage(somethingWrong);
          setState(() {
            showDetails = false;
          });
        }
      });
    } else {
      setState(() {
        showDetails = false;
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
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
                  isUPIOpen = false;
                  isRequestUpi = false;
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
                      maxLength: 16,
                    ),
                  ),
                ),
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
                      style: TextStyle(color: black, fontSize: font14.sp),
                      keyboardType: TextInputType.name,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
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
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50.h,
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
                          child: Row(
                            children: [
                              Expanded(
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
                        "Charges paid with Credit/Debit card is : $rupeeSymbol ${formatNow.format(cardCharge)}",
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
                  var mpBalc = await getWalletBalance();
                  setState(() {
                    packageName = app.packageName;

                    isCardOpen = false;
                    isUPIOpen = true;
                    isRequestUpi = false;
                  });

                  double walletValue = 0;
                  double rechargeValue = 0;

                  setState(() {
                    if (mpBalc.toString() == "") {
                      walletValue = 0;
                    } else {
                      walletValue = double.parse(mpBalc);
                    }

                    var amt; // = partPayController.text.toString();

                    if (isAdhoc.toString() == "1") {
                      amt = partialAmtController.text.toString();
                    } else {
                      amt = actualRechargeAmount;
                    }

                    if (amt.length != 0) {
                      actualRechargeAmount = amt;
                    }

                    if (actualRechargeAmount.toString() == "") {
                      rechargeValue = 0;
                    } else {
                      rechargeValue = double.parse(actualRechargeAmount);
                    }
                  });

                  if (rechargeValue == 0) {
                    showToastMessage(
                        "You cannot processed with $rupeeSymbol $rechargeValue");
                    return;
                  }

                  if (checkedValue) {
                    if (walletValue >= rechargeValue) {
                      setState(() {
                        isWallMore = true;
                      });
                      var id = DateTime.now().millisecondsSinceEpoch;
                      if (isWelcomeOffer) {
                        rechargeValue = rechargeValue - welcomeCharge;
                      }
                      paymentByWallet(id, rechargeValue);
                    } else {
                      setState(() {
                        isWallMore = false;
                      });
                      setState(() {
                        remainAmt = rechargeValue - walletValue;
                        if (isWelcomeOffer) {
                          remainAmt = remainAmt - welcomeCharge;
                        }
                      });
                      var id = DateTime.now().millisecondsSinceEpoch;
                      createOrderForUPI(id);
                    }
                  } else {
                    setState(() {
                      isWallMore = false;
                    });
                    var id = DateTime.now().millisecondsSinceEpoch;
                    double pg = rechargeValue;
                    if (isWelcomeOffer) {
                      pg = pg - welcomeCharge;
                    }
                    createOrderForUPIOnly(id, formatNow.format(pg));
                    //createOrderForUPIOnly(id, formatString.format(pg));
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

              var mpBalc = await getWalletBalance();
              setState(() {
                isCardOpen = false;
                isUPIOpen = true;
                isRequestUpi = true;
              });

              double walletValue = 0;
              double rechargeValue = 0;

              setState(() {
                if (mpBalc.toString() == "") {
                  walletValue = 0;
                } else {
                  walletValue = double.parse(mpBalc);
                }

                var amt; // = partPayController.text.toString();

                if (isAdhoc.toString() == "1") {
                  amt = partialAmtController.text.toString();
                } else {
                  amt = actualRechargeAmount;
                }

                if (amt.length != 0) {
                  actualRechargeAmount = amt;
                }

                if (actualRechargeAmount.toString() == "") {
                  rechargeValue = 0;
                } else {
                  rechargeValue = double.parse(actualRechargeAmount);
                }
              });

              if (rechargeValue == 0) {
                showToastMessage(
                    "You cannot processed with $rupeeSymbol $rechargeValue");
                return;
              }

              if (checkedValue) {
                if (walletValue >= rechargeValue) {
                  setState(() {
                    isWallMore = true;
                  });
                  var id = DateTime.now().millisecondsSinceEpoch;
                  if (isWelcomeOffer) {
                    rechargeValue = rechargeValue - welcomeCharge;
                  }
                  paymentByWallet(id, rechargeValue);
                } else {
                  setState(() {
                    isWallMore = false;
                  });
                  setState(() {
                    remainAmt = rechargeValue - walletValue;
                    if (isWelcomeOffer) {
                      remainAmt = remainAmt - welcomeCharge;
                    }
                  });
                  var id = DateTime.now().millisecondsSinceEpoch;
                  createOrderForUPI(id);
                }
              } else {
                setState(() {
                  isWallMore = false;
                });
                var id = DateTime.now().millisecondsSinceEpoch;
                double pg = rechargeValue;
                if (isWelcomeOffer) {
                  pg = pg - welcomeCharge;
                }
                createOrderForUPIOnly(id, formatNow.format(pg));
                //createOrderForUPIOnly(id, formatString.format(pg));
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

  _buildUPISection() {
    return Card(
      color: tabBg,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      elevation: 10,
      margin: EdgeInsets.only(top: 15.0, left: 20, right: 20),
      child: InkWell(
        onTap: () async {
          var mpBalc = await getWalletBalance();
          setState(() {
            isCardOpen = false;
            isUPIOpen = true;
            isRequestUpi = false;
          });

          double walletValue = 0;
          double rechargeValue = 0;

          setState(() {
            if (mpBalc.toString() == "") {
              walletValue = 0;
            } else {
              walletValue = double.parse(mpBalc);
            }

            var amt; // = partPayController.text.toString();

            if (isAdhoc.toString() == "1") {
              amt = partialAmtController.text.toString();
            } else {
              amt = actualRechargeAmount;
            }

            if (amt.length != 0) {
              actualRechargeAmount = amt;
            }

            if (actualRechargeAmount.toString() == "") {
              rechargeValue = 0;
            } else {
              rechargeValue = double.parse(actualRechargeAmount);
            }
          });

          if (rechargeValue == 0) {
            showToastMessage(
                "You cannot processed with $rupeeSymbol $rechargeValue");
            return;
          }

          if (checkedValue) {
            if (walletValue >= rechargeValue) {
              setState(() {
                isWallMore = true;
              });
              var id = DateTime.now().millisecondsSinceEpoch;
              if (isWelcomeOffer) {
                rechargeValue = rechargeValue - welcomeCharge;
              }
              paymentByWallet(id, rechargeValue);
            } else {
              setState(() {
                isWallMore = false;
              });
              setState(() {
                remainAmt = rechargeValue - walletValue;
                if (isWelcomeOffer) {
                  remainAmt = remainAmt - welcomeCharge;
                }
              });
              var id = DateTime.now().millisecondsSinceEpoch;
              createOrderForUPI(id);
            }
          } else {
            setState(() {
              isWallMore = false;
            });
            var id = DateTime.now().millisecondsSinceEpoch;
            double pg = rechargeValue;
            if (isWelcomeOffer) {
              pg = pg - welcomeCharge;
            }
            createOrderForUPIOnly(id, formatNow.format(pg));
            //createOrderForUPIOnly(id, formatString.format(pg));
          }
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

  _buildButtonSection() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .8,
          height: 40.h,
          margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 0),
          decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(25)),
              border: Border.all(color: lightBlue)),
          child: InkWell(
            onTap: () async {
              var mpBalc = await getWalletBalance();
              setState(() {
                //isCardOpen = true;
                //isUPIOpen = false;
              });

              double walletValue = 0;
              double rechargeValue = 0;

              setState(() {
                if (mpBalc.toString() == "") {
                  walletValue = 0;
                } else {
                  walletValue = double.parse(mpBalc);
                }

                var amt; // = partPayController.text.toString();

                if (isAdhoc.toString() == "1") {
                  amt = partialAmtController.text.toString();
                } else {
                  amt = actualRechargeAmount;
                }

                if (amt.length != 0) {
                  actualRechargeAmount = amt;
                }

                if (actualRechargeAmount.toString() == "") {
                  rechargeValue = 0;
                } else {
                  rechargeValue = double.parse(actualRechargeAmount);
                }
              });

              if (rechargeValue == 0) {
                showToastMessage(
                    "You cannot processed with $rupeeSymbol $rechargeValue");
                return;
              }

              if (checkedValue) {
                if (walletValue >= rechargeValue) {
                  setState(() {
                    isWallMore = true;
                  });
                  var id = DateTime.now().millisecondsSinceEpoch;
                  if (isWelcomeOffer) {
                    rechargeValue = rechargeValue - welcomeCharge;
                  }

                  printMessage(screen, "Recharge : $rechargeValue");

                  paymentByWallet(id, rechargeValue);
                } else {
                  if (isCardOpen) {
                    setState(() {
                      isWallMore = false;
                    });
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

                    setState(() {
                      remainAmt =
                          double.parse(actualRechargeAmount) - walletValue;
                    });
                    calculateCardCheckCharge1(remainAmt);
                    var id = DateTime.now().millisecondsSinceEpoch;
                    remainAmt = remainAmt + cardCharge;

                    if (isWelcomeOffer) {
                      remainAmt = remainAmt - welcomeCharge;
                    }
                    remainAmt = double.parse(formatNow.format(remainAmt));

                    createOrderForCard(id);
                  } else {
                    showToastMessage("Select any one payment method");
                  }
                }
              } else {
                if (isCardOpen) {
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

                  setState(() {
                    isWallMore = false;
                  });

                  calculateCardCheckCharge(actualRechargeAmount);
                  var id = DateTime.now().millisecondsSinceEpoch;
                  var pgAmt = double.parse(actualRechargeAmount) + cardCharge;

                  if (isWelcomeOffer) {
                    pgAmt = pgAmt - welcomeCharge;
                  }
                  createOrderForFullCard(id, formatNow.format(pgAmt));
                } else {
                  showToastMessage("Select any one payment method");
                }
              }
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
        ),
        Padding(
          padding: const EdgeInsets.all(4.0),
          child: Text(
            powered_by,
            style: TextStyle(
                color: black, fontSize: 16.sp, fontWeight: FontWeight.bold),
          ),
        ),
        Divider(),
        Row(
          children: [
            Expanded(
                child: Image.asset(
              'assets/pci.png',
              height: 24.h,
            )),
            Expanded(
                child: Image.asset(
              'assets/upi.png',
              height: 20.h,
            )),
            Expanded(
                child: Image.asset(
              'assets/iso.png',
              height: 30.h,
            )),
          ],
        ),
        SizedBox(
          height: 10.h,
        ),
      ],
    );
  }

  calculateCharge(amount) {
    double v1 = 0.9;
    double v2 = double.parse(amount);
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

  calculateCardCheckCharge(amount) {
    double v1 = 0.9;
    double v3 = 100;
    double v4 = (double.parse(amount) / v3) * v1;

    if (v4 > 20) {
      cardCharge = 20.0;
    } else {
      cardCharge = v4;
    }
    printMessage(screen, "v4 : ${formatNow.format(v4)}");
    printMessage(screen, "cardCharge : ${formatNow.format(cardCharge)}");
  }

  calculateCardCheckCharge1(amount) {
    double v1 = 0.9;
    double v3 = 100;
    double v4 = (amount / v3) * v1;

    if (v4 > 20) {
      cardCharge = 20.0;
    } else {
      cardCharge = v4;
    }
    printMessage(screen, "v4 : ${formatNow.format(v4)}");
    printMessage(screen, "cardCharge : ${formatNow.format(cardCharge)}");
  }

  _buildOfferRwo() {
    return Container(
      margin: EdgeInsets.only(top: padding, left: padding, right: padding),
      decoration: BoxDecoration(
        color: editBg,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 15.w,
            ),
            Image.asset(
              'assets/offer_icon.png',
              height: 24.h,
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              "Welcome offer applied",
              style: TextStyle(color: black, fontSize: font14.sp),
            ),
            Spacer(),
            Text(
              "$rupeeSymbol 1.20",
              style: TextStyle(color: green, fontSize: font14.sp),
            ),
            SizedBox(
              width: 15.w,
            ),
          ],
        ),
      ),
    );
  }

  paymentByWallet(id, rechargeValue) async {
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
      "user_token": "$userToken",
      "token": "$bbpsToken",
      "billerId": "$billerId",
      "category": "$category",
      "param_1": "$paramName",
      "val_1": "$paramMain",
      "param_2": "$paramName_1",
      "val_2": "$paramFirst",
      "param_3": "$paramName_2",
      "val_3": "$paramSecond",
      "param_4": "$paramName_3",
      "val_4": "$paramThird",
      "accountHolderName": "$accountHolderName",
      "paidAmount": "$actualRechargeAmount",
      "isQuickPay": "$isQuickPay",
      "refId": "$refId",
      "wallet": "$rechargeValue",
      "billerName": "$billerName",
      "paymentgateway_amount": "0",
      "paymentgateway_txn": "",
      "paymentgateway_mode": "WALLET",
      "txTime": "",
      "signature": "",
      "txStatus": "",
      "referenceId": "",
      "welcome_amount":
          (isWelcomeOffer) ? "${formatNow.format(welcomeCharge)}" : "0",
      "param_count": "$paramCount"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(billPayAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Pay Wallet Response : $data");

      setState(() {
        Navigator.pop(context);
        var code = data['transction']['code'];
        if (code.toString() == "200") {
          var commission = data['commission'];
          var status = data['transction']['status'];
          var requestTimeStamp =
              data['transction']['payload']['requestTimeStamp'];
          var paidAmount = data['transction']['payload']['paidAmount'];
          var refId = data['transction']['payload']['refId'];
          var message = data['transction']['payload']['message'];
          var billerId = data['transction']['payload']['billerId'];
          var txnReferenceId = data['transction']['payload']['additionalParams']
              ['txnReferenceId'];
          var billerReferenceNumber = data['transction']['payload']
              ['additionalParams']['billerReferenceNumber'];

          Map map = {
            "txStatus": "$status",
            "orderAmount": "$paidAmount",
            "paymentMode": "Payment Gateway",
            "orderId": "$id",
            "txTime": "$requestTimeStamp",
            "txMsg": "$message",
            "operatorName": "$billerName",
            "referenceId": "$txnReferenceId",
            "signature": "$billerReferenceNumber",
            "commission": "$commission"
          };
          openPaymentSuccess(context, map, true);
        } else {
          var status = data['status'];
          var reason = data['transction']['payload']['errors'][0]['reason'];
          var errorCode =
              data['transction']['payload']['errors'][0]['errorCode'];
          var refId = data['transction']['payload']['refId'];
          var type = data['transction']['payload']['type'];
          var message = data['transction']['payload']['message'];
          var txnReferenceId = data['transction']['payload']['additionalParams']
              ['txnReferenceId'];

          Map map = {
            "txStatus": "$status",
            "orderAmount": "$rechargeValue",
            "paymentMode": "Wallet",
            "orderId": "$id",
            "txTime": "$currentTime",
            "txMsg": "$reason",
            "type": "$type",
            "referenceId": "$txnReferenceId",
            "signature": ""
          };

          openPaymentFailure(context, map);
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  createOrderForUPI(id) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while we are fetching your bill");
          });
    });

    var headers = {
      "Content-Type": "application/json",
      "x-client-id": "$cashFreeAppId",
      "x-client-secret": "$cashFreeSecretKey"
    };

    var body = {
      "orderId": "$id",
      "orderAmount": "$remainAmt",
      "orderCurrency": "INR"
    };
    final response = await http.post(Uri.parse(cashFreeTokenAPI),
        body: json.encode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "getCashFreeToken : $data");

    setState(() {
      if (data['status'].toString() == "OK") {
        var token = data['cftoken'].toString();
        CashfreePGSDK.getUPIApps().then((value) {
          setState(() {
            getUPIAppNames(value, id, token);
          });
        });
      } else {
        Navigator.pop(context);
      }
    });
  }

  getUPIAppNames(result, orderId, token) async {
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
        "orderAmount": "$remainAmt",
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
        "orderAmount": "$remainAmt",
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
                verifyPaymentForUPI(value);
              });
              printMessage(screen, "doUPIPayment result : $value");
            })
          : CashfreePGSDK.doUPIPayment(inputParams).then((value) {
              setState(() {
                verifyPaymentForUPI(value);
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

  verifyPaymentForUPI(responsePG) async {
    var txStatus = responsePG['txStatus'];
    var orderAmount = responsePG['orderAmount'];
    var paymentMode = responsePG['paymentMode'];
    var orderId = responsePG['orderId'];
    var txTime = responsePG['txTime'];
    var txMsg = responsePG['txMsg'];
    var type = responsePG['type'];
    var referenceId = responsePG['referenceId'];
    var signature = responsePG['signature'];

    printMessage(screen, "responsePG    : $responsePG");
    Navigator.pop(context);
    if (responsePG['txStatus'].toString().toUpperCase() == "SUCCESS" ||
        responsePG['txStatus'].toString().toUpperCase() == "TRUE" ||
        responsePG['txStatus'].toString() == "1") {
      printMessage(screen, "Transaction is Successful");
      setState(() {
        paymentByUPI(orderAmount, orderId, paymentMode, txTime, signature,
            txStatus, referenceId);
      });
    } else if (responsePG['txStatus'].toString() == "FAILED") {
      Map map = {
        "txStatus": "Failed",
        "orderAmount": "$orderAmount",
        "paymentMode": "$paymentMode",
        "orderId": "$orderId",
        "txTime": "$txTime",
        "txMsg": "$txMsg",
        "type": "$type",
        "referenceId": "$referenceId",
        "signature": "$signature"
      };
      openPaymentFailure(context, map);
      printMessage(screen, "Transaction is Pending");
    } else {
      //Navigator.pop(context);
      showToastMessage(txStatus.toString());
    }
  }

  paymentByUPI(orderAmount, orderId, paymentMode, txTime, signature, txStatus,
      referenceId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();
    var moneyProBalc = await getWalletBalance();
    var xAmt;

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    if (isWallMore) {
      xAmt = double.parse(actualRechargeAmount);
    } else {
      if (checkedValue) {
        xAmt = double.parse(moneyProBalc);
      } else {
        xAmt = 0;
      }
    }

    if (paymentMode.toString() == "DEBIT_CARD") {
      setState(() {
        paymentMode = "DC";
      });
    }

    if (paymentMode.toString() == "CREDIT_CARD") {
      setState(() {
        paymentMode = "CC";
      });
    }

    if (paymentMode.toString() == "UPI") {
      setState(() {
        paymentMode = "UPI";
      });
    }

    printMessage(screen, "xAmt Balance : $xAmt");

    final body = {
      "user_token": "$userToken",
      "token": "$bbpsToken",
      "billerId": "$billerId",
      "category": "$category",
      "param_1": "$paramName",
      "val_1": "$paramMain",
      "param_2": "$paramName_1",
      "val_2": "$paramFirst",
      "param_3": "$paramName_2",
      "val_3": "$paramSecond",
      "param_4": "$paramName_3",
      "val_4": "$paramThird",
      "accountHolderName": "$accountHolderName",
      "paidAmount": "$actualRechargeAmount",
      "isQuickPay": "$isQuickPay",
      "refId": "$refId",
      "wallet": "$xAmt",
      "billerName": "$billerName",
      "paymentgateway_amount": "$orderAmount",
      "paymentgateway_txn": "$orderId",
      "paymentgateway_mode": "$paymentMode",
      "txTime": "$txTime",
      "signature": "$signature",
      "txStatus": "$txStatus",
      "referenceId": "$referenceId",
      "welcome_amount":
          (isWelcomeOffer) ? "${formatNow.format(welcomeCharge)}" : "0",
      "param_count": "$paramCount"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(billPayAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Payment By UPI Response : $data");

      setState(() {
        Navigator.pop(context);
        var code = data['transction']['code'];
        if (code.toString() == "200") {
          var commission = data['commission'];
          var status = data['transction']['status'];
          var requestTimeStamp =
              data['transction']['payload']['requestTimeStamp'];
          var paidAmount = data['transction']['payload']['paidAmount'];
          var refId = data['transction']['payload']['refId'];
          var message = data['transction']['payload']['message'];
          var billerId = data['transction']['payload']['billerId'];
          var txnReferenceId = data['transction']['payload']['additionalParams']
              ['txnReferenceId'];
          var billerReferenceNumber = data['transction']['payload']
              ['additionalParams']['billerReferenceNumber'];

          Map map = {
            "txStatus": "$status",
            "orderAmount": "$paidAmount",
            "paymentMode": "Payment Gateway",
            "orderId": "$orderId",
            "txTime": "$requestTimeStamp",
            "txMsg": "$message",
            "operatorName": "$billerName",
            "referenceId": "$txnReferenceId",
            "signature": "$billerReferenceNumber",
            "commission": "$commission"
          };
          openPaymentSuccess(context, map, true);
        } else {
          var status = data['status'];
          var reason = data['transction']['payload']['errors'][0]['reason'];
          var errorCode =
              data['transction']['payload']['errors'][0]['errorCode'];
          var refId = data['transction']['payload']['refId'];
          var type = data['transction']['payload']['type'];
          var message = data['transction']['payload']['message'];
          var txnReferenceId = data['transction']['payload']['additionalParams']
              ['txnReferenceId'];

          Map map = {
            "txStatus": "$status",
            "orderAmount": "$orderAmount",
            "paymentMode": "Payment Gateway",
            "orderId": "$orderId",
            "txTime": "$txTime",
            "txMsg": "$reason",
            "type": "$type",
            "referenceId": "$txnReferenceId",
            "signature": ""
          };
          openPaymentFailure(context, map);
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  createOrderForUPIOnly(id, pgAmt) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while we are fetching your bill");
          });
    });

    var headers = {
      "Content-Type": "application/json",
      "x-client-id": "$cashFreeAppId",
      "x-client-secret": "$cashFreeSecretKey"
    };

    var body = {
      "orderId": "$id",
      "orderAmount": "$pgAmt",
      "orderCurrency": "INR"
    };

    printMessage(screen, "Create Body : $body");

    final response = await http.post(Uri.parse(cashFreeTokenAPI),
        body: json.encode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "getCashFreeToken : $data");

    setState(() {
      if (data['status'].toString() == "OK") {
        var token = data['cftoken'].toString();
        CashfreePGSDK.getUPIApps().then((value) {
          setState(() {
            getUPIAppNamesOnly(value, id, pgAmt, token);
          });
        });
      } else {
        Navigator.pop(context);
      }
    });
  }

  getUPIAppNamesOnly(result, orderId, pgAmt, token) async {
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
        "orderAmount": "$pgAmt",
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
        "orderAmount": "$pgAmt",
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
                verifyPaymentForUPIOnly(value, pgAmt);
              });
              printMessage(screen, "doUPIPayment result : $value");
            })
          : CashfreePGSDK.doUPIPayment(inputParams).then((value) {
              setState(() {
                verifyPaymentForUPIOnly(value, pgAmt);
              });
              printMessage(screen, "doUPIPayment result : $value");
            });
    }
  }

  verifyPaymentForUPIOnly(responsePG, pgAmt) async {
    var txStatus = responsePG['txStatus'];
    var orderAmount = responsePG['orderAmount'];
    var paymentMode = responsePG['paymentMode'];
    var orderId = responsePG['orderId'];
    var txTime = responsePG['txTime'];
    var txMsg = responsePG['txMsg'];
    var type = responsePG['type'];
    var referenceId = responsePG['referenceId'];
    var signature = responsePG['signature'];

    printMessage(screen, "responsePG    : $responsePG");

    Navigator.pop(context);
    if (responsePG['txStatus'].toString().toUpperCase() == "SUCCESS" ||
        responsePG['txStatus'].toString().toUpperCase() == "TRUE" ||
        responsePG['txStatus'].toString() == "1") {
      printMessage(screen, "Transaction is Successful");
      setState(() {
        paymentByUPI(orderAmount, orderId, paymentMode, txTime, signature,
            txStatus, referenceId);
      });
    } else if (responsePG['txStatus'].toString() == "FAILED") {
      Map map = {
        "txStatus": "Failed",
        "orderAmount": "$orderAmount",
        "paymentMode": "$paymentMode",
        "orderId": "$orderId",
        "txTime": "$txTime",
        "txMsg": "$txMsg",
        "type": "$type",
        "referenceId": "$referenceId",
        "signature": "$signature"
      };
      openPaymentFailure(context, map);
      printMessage(screen, "Transaction is Pending");
    } else {
      //Navigator.pop(context);
      showToastMessage(txStatus.toString());
    }
  }

  createOrderForCard(id) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while we are fetching your bill");
          });
    });

    var headers = {
      "Content-Type": "application/json",
      "x-client-id": "$cashFreeAppId",
      "x-client-secret": "$cashFreeSecretKey"
    };

    var body = {
      "orderId": "$id",
      "orderAmount": "$remainAmt",
      "orderCurrency": "INR"
    };
    final response = await http.post(Uri.parse(cashFreeTokenAPI),
        body: json.encode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "getCashFreeToken : $data");

    setState(() {
      if (data['status'].toString() == "OK") {
        var token = data['cftoken'].toString();
        movetoCard(id, token);
      } else {
        Navigator.pop(context);
      }
    });
  }

  movetoCard(id, token) async {
    var name = await getContactName();
    var customerPhone = await getMobile();
    var customerEmail = await getEmail();

    Map<String, dynamic> inputFinalParams = {};

    Map<String, dynamic> inputParams = {
      "orderId": "$id",
      "orderAmount": "$remainAmt",
      "customerName": "$name",
      "orderCurrency": "INR",
      "appId": "$cashFreeAppId",
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "tokenData": "$token",
      "stage": "$cashFreePGMode",
      "orderNote": "Recharge order note",
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
          verifyCardPayment(value);
        });
        printMessage(screen, "Final result : $value");
      });
    }
  }

  verifyCardPayment(responsePG) async {
    var txStatus = responsePG['txStatus'];
    var orderAmount = responsePG['orderAmount'];
    var paymentMode = responsePG['paymentMode'];
    var orderId = responsePG['orderId'];
    var txTime = responsePG['txTime'];
    var txMsg = responsePG['txMsg'];
    var type = responsePG['type'];
    var referenceId = responsePG['referenceId'];
    var signature = responsePG['signature'];

    printMessage(screen, "responsePG    : $responsePG");

    Navigator.pop(context);

    if (responsePG['txStatus'].toString().toUpperCase() == "SUCCESS" ||
        responsePG['txStatus'].toString().toUpperCase() == "TRUE" ||
        responsePG['txStatus'].toString() == "1") {
      printMessage(screen, "Transaction is Successful");
      setState(() {
        paymentByCard(orderAmount, orderId, paymentMode, txTime, signature,
            txStatus, referenceId);
      });
    } else if (responsePG['txStatus'].toString() == "FAILED") {
      Map map = {
        "txStatus": "Failed",
        "orderAmount": "$orderAmount",
        "paymentMode": "$paymentMode",
        "orderId": "$orderId",
        "txTime": "$txTime",
        "txMsg": "$txMsg",
        "type": "$type",
        "referenceId": "$referenceId",
        "signature": "$signature"
      };
      openPaymentFailure(context, map);
      printMessage(screen, "Transaction is Pending");
    } else {
      Navigator.pop(context);
      showToastMessage(txStatus.toString());
    }
  }

  paymentByCard(orderAmount, orderId, paymentMode, txTime, signature, txStatus,
      referenceId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();
    var moneyProBalc = await getWalletBalance();
    var xAmt;

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    if (isWallMore) {
      xAmt = double.parse(actualRechargeAmount);
    } else {
      if (checkedValue) {
        xAmt = double.parse(moneyProBalc);
      } else {
        xAmt = 0;
      }
    }

    if (paymentMode.toString() == "DEBIT_CARD") {
      setState(() {
        paymentMode = "DC";
      });
    }

    if (paymentMode.toString() == "CREDIT_CARD") {
      setState(() {
        paymentMode = "CC";
      });
    }

    if (paymentMode.toString() == "UPI") {
      setState(() {
        paymentMode = "UPI";
      });
    }

    final body = {
      "user_token": "$userToken",
      "token": "$bbpsToken",
      "billerId": "$billerId",
      "category": "$category",
      "param_1": "$paramName",
      "val_1": "$paramMain",
      "param_2": "$paramName_1",
      "val_2": "$paramFirst",
      "param_3": "$paramName_2",
      "val_3": "$paramSecond",
      "param_4": "$paramName_3",
      "val_4": "$paramThird",
      "accountHolderName": "$accountHolderName",
      "paidAmount": "$actualRechargeAmount",
      "isQuickPay": "$isQuickPay",
      "refId": "$refId",
      "wallet": "$xAmt",
      "billerName": "$billerName",
      "paymentgateway_amount": "$orderAmount",
      "paymentgateway_txn": "$orderId",
      "paymentgateway_mode": "$paymentMode",
      "txTime": "$txTime",
      "signature": "$signature",
      "txStatus": "$txStatus",
      "referenceId": "$referenceId",
      "welcome_amount":
          (isWelcomeOffer) ? "${formatNow.format(welcomeCharge)}" : "0",
      "param_count": "$paramCount"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(billPayAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "paymentByCard Response : $data");

      setState(() {
        Navigator.pop(context);
        var code = data['transction']['code'];
        if (code.toString() == "200") {
          var commission = data['commission'];
          var status = data['transction']['status'];
          var requestTimeStamp =
              data['transction']['payload']['requestTimeStamp'];
          var paidAmount = data['transction']['payload']['paidAmount'];
          var refId = data['transction']['payload']['refId'];
          var message = data['transction']['payload']['message'];
          var billerId = data['transction']['payload']['billerId'];
          var txnReferenceId = data['transction']['payload']['additionalParams']
              ['txnReferenceId'];
          var billerReferenceNumber = data['transction']['payload']
              ['additionalParams']['billerReferenceNumber'];

          Map map = {
            "txStatus": "$status",
            "orderAmount": "$paidAmount",
            "paymentMode": "Payment Gateway",
            "orderId": "$orderId",
            "txTime": "$requestTimeStamp",
            "txMsg": "$message",
            "operatorName": "$billerName",
            "referenceId": "$txnReferenceId",
            "signature": "$billerReferenceNumber",
            "commission": "$commission"
          };
          openPaymentSuccess(context, map, true);
        } else {
          var status = data['status'];
          var reason = data['transction']['payload']['errors'][0]['reason'];
          var errorCode =
              data['transction']['payload']['errors'][0]['errorCode'];
          var refId = data['transction']['payload']['refId'];
          var type = data['transction']['payload']['type'];
          var message = data['transction']['payload']['message'];
          var txnReferenceId = data['transction']['payload']['additionalParams']
              ['txnReferenceId'];

          Map map = {
            "txStatus": "$status",
            "orderAmount": "$actualRechargeAmount",
            "paymentMode": "Wallet + Payment Gateway",
            "orderId": "$orderId",
            "txTime": "$txTime",
            "txMsg": "$reason",
            "type": "$type",
            "referenceId": "$txnReferenceId",
            "signature": ""
          };
          openPaymentFailure(context, map);
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  createOrderForFullCard(id, pgAmt) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while we are fetching your bill");
          });
    });

    var headers = {
      "Content-Type": "application/json",
      "x-client-id": "$cashFreeAppId",
      "x-client-secret": "$cashFreeSecretKey"
    };

    var body = {
      "orderId": "$id",
      "orderAmount": "$pgAmt",
      "orderCurrency": "INR"
    };
    final response = await http.post(Uri.parse(cashFreeTokenAPI),
        body: json.encode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "getCashFreeToken : $data");

    setState(() {
      if (data['status'].toString() == "OK") {
        var token = data['cftoken'].toString();
        moveToPaymentFullCard(id, pgAmt, token);
      } else {
        Navigator.pop(context);
      }
    });
  }

  moveToPaymentFullCard(id, pgAmt, token) async {
    String orderNote = "Order Note";

    var name = await getContactName();
    var customerPhone = await getMobile();
    var customerEmail = await getEmail();

    Map<String, dynamic> inputFinalParams = {};

    Map<String, dynamic> inputParams = {
      "orderId": "$id",
      "orderAmount": "$pgAmt",
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
          verifyFullCardPayment(value, pgAmt);
        });
        printMessage(screen, "Final result : $value");
      });
    }
  }

  verifyFullCardPayment(responsePG, pgAmt) async {
    var txStatus = responsePG['txStatus'];
    var orderAmount = responsePG['orderAmount'];
    var paymentMode = responsePG['paymentMode'];
    var orderId = responsePG['orderId'];
    var txTime = responsePG['txTime'];
    var txMsg = responsePG['txMsg'];
    var type = responsePG['type'];
    var referenceId = responsePG['referenceId'];
    var signature = responsePG['signature'];

    printMessage(screen, "responsePG    : $responsePG");
    Navigator.pop(context);
    if (responsePG['txStatus'].toString().toUpperCase() == "SUCCESS" ||
        responsePG['txStatus'].toString().toUpperCase() == "TRUE" ||
        responsePG['txStatus'].toString() == "1") {
      printMessage(screen, "Transaction is Successful");
      setState(() {
        paymentByFullCard(orderAmount, orderId, paymentMode, txTime, signature,
            txStatus, referenceId);
      });
    } else if (responsePG['txStatus'].toString() == "FAILED") {
      Map map = {
        "txStatus": "Failed",
        "orderAmount": "$orderAmount",
        "paymentMode": "$paymentMode",
        "orderId": "$orderId",
        "txTime": "$txTime",
        "txMsg": "$txMsg",
        "type": "$type",
        "referenceId": "$referenceId",
        "signature": "$signature"
      };
      openPaymentFailure(context, map);
      printMessage(screen, "Transaction is Pending");
    } else {
      Navigator.pop(context);
      showToastMessage(txStatus.toString());
    }
  }

  paymentByFullCard(orderAmount, orderId, paymentMode, txTime, signature,
      txStatus, referenceId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();
    var moneyProBalc = await getWalletBalance();
    var xAmt;

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    if (isWallMore) {
      xAmt = double.parse(actualRechargeAmount);
    } else {
      if (checkedValue) {
        xAmt = double.parse(moneyProBalc);
      } else {
        xAmt = 0;
      }
    }

    printMessage(screen, "xAmt Balance : $xAmt");

    if (paymentMode.toString() == "DEBIT_CARD") {
      setState(() {
        paymentMode = "DC";
      });
    }

    if (paymentMode.toString() == "CREDIT_CARD") {
      setState(() {
        paymentMode = "CC";
      });
    }

    if (paymentMode.toString() == "UPI") {
      setState(() {
        paymentMode = "UPI";
      });
    }

    final body = {
      "user_token": "$userToken",
      "token": "$bbpsToken",
      "billerId": "$billerId",
      "category": "$category",
      "param_1": "$paramName",
      "val_1": "$paramMain",
      "param_2": "$paramName_1",
      "val_2": "$paramFirst",
      "param_3": "$paramName_2",
      "val_3": "$paramSecond",
      "param_4": "$paramName_3",
      "val_4": "$paramThird",
      "accountHolderName": "$accountHolderName",
      "paidAmount": "$actualRechargeAmount",
      "isQuickPay": "$isQuickPay",
      "refId": "$refId",
      "wallet": "$xAmt",
      "billerName": "$billerName",
      "paymentgateway_amount": "$orderAmount",
      "paymentgateway_txn": "$orderId",
      "paymentgateway_mode": "$paymentMode",
      "txTime": "$txTime",
      "signature": "$signature",
      "txStatus": "$txStatus",
      "referenceId": "$referenceId",
      "welcome_amount":
          (isWelcomeOffer) ? "${formatNow.format(welcomeCharge)}" : "0",
      "param_count": "$paramCount"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(billPayAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "FullCardPayment Response : $data");

      setState(() {
        Navigator.pop(context);
        var code = data['transction']['code'];
        if (code.toString() == "200") {
          var commission = data['commission'];
          var status = data['transction']['status'];
          var requestTimeStamp =
              data['transction']['payload']['requestTimeStamp'];
          var paidAmount = data['transction']['payload']['paidAmount'];
          var refId = data['transction']['payload']['refId'];
          var message = data['transction']['payload']['message'];
          var billerId = data['transction']['payload']['billerId'];
          var txnReferenceId = data['transction']['payload']['additionalParams']
              ['txnReferenceId'];
          var billerReferenceNumber = data['transction']['payload']
              ['additionalParams']['billerReferenceNumber'];

          Map map = {
            "txStatus": "$status",
            "orderAmount": "$paidAmount",
            "paymentMode": "Payment Gateway",
            "orderId": "$orderId",
            "txTime": "$requestTimeStamp",
            "txMsg": "$message",
            "operatorName": "$billerName",
            "referenceId": "$txnReferenceId",
            "signature": "$billerReferenceNumber",
            "commission": "$commission"
          };
          openPaymentSuccess(context, map, true);
        } else {
          var status = data['status'];
          var reason = data['transction']['payload']['errors'][0]['reason'];
          var errorCode =
              data['transction']['payload']['errors'][0]['errorCode'];
          var refId = data['transction']['payload']['refId'];
          var type = data['transction']['payload']['type'];
          var message = data['transction']['payload']['message'];
          var txnReferenceId = data['transction']['payload']['additionalParams']
              ['txnReferenceId'];

          Map map = {
            "txStatus": "$status",
            "orderAmount": "$orderAmount",
            "paymentMode": "Payment Gateway",
            "orderId": "$orderId",
            "txTime": "$txTime",
            "txMsg": "$reason",
            "type": "$type",
            "referenceId": "$txnReferenceId",
            "signature": ""
          };
          openPaymentFailure(context, map);
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  _buildAdditionalDetails() {
    return Column(
      children: [
        Divider(),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 00),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "One Month Bill",
                    style: TextStyle(
                        fontSize: font14.sp,
                        color: black,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: (month1Date.toString() == "" ||
                                month1Date.toString() == "null")
                            ? Text("Due Date : NA")
                            : Text("Due Date : $month1Date"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Due Amt. : $rupeeSymbol $month1Amount",
                          style: TextStyle(
                              fontSize: font14.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )),
              /*Radio(
                  value: billMonths.one,
                  groupValue: _site,
                  onChanged: (value) {
                    setState(() {
                      _site = billMonths.one;
                      actualRechargeAmount = month1Amount.toString();
                    });
                  })*/
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 0, top: 15),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Two Month Bill",
                    style: TextStyle(
                        fontSize: font14.sp,
                        color: black,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: (month2Date.toString() == "" ||
                                month2Date.toString() == "null")
                            ? Text("Due Date : NA")
                            : Text("Due Date : $month2Date"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Due Amt. : $rupeeSymbol $month2Amount",
                          style: TextStyle(
                              fontSize: font14.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )),
              /*Radio(
                  value: billMonths.two,
                  groupValue: _site,
                  onChanged: (value) {
                    setState(() {
                      _site = billMonths.two;
                      actualRechargeAmount = month2Amount.toString();
                    });
                  })*/
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, right: 0, top: 15),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                children: [
                  Text(
                    "Three Month Bill",
                    style: TextStyle(
                        fontSize: font14.sp,
                        color: black,
                        fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      Expanded(
                        flex: 2,
                        child: (month3Date.toString() == "" ||
                                month3Date.toString() == "null")
                            ? Text("Due Date : NA")
                            : Text("Due Date : $month3Date"),
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Due Amt. : $rupeeSymbol $month3Amount",
                          style: TextStyle(
                              fontSize: font14.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  )
                ],
                crossAxisAlignment: CrossAxisAlignment.start,
              )),
              /*Radio(
                  value: billMonths.three,
                  groupValue: _site,
                  onChanged: (value) {
                    setState(() {
                      _site = billMonths.three;
                      actualRechargeAmount = month3Amount.toString();
                    });
                  })*/
            ],
          ),
        ),
      ],
    );
  }
}
