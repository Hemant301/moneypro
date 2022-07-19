import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/UPIList.dart';
import 'package:moneypro_new/ui/recharge/mobilerechange/MobilePaymentNew.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';

class LICDetails extends StatefulWidget {
  const LICDetails({Key? key}) : super(key: key);

  @override
  _LICDetailsState createState() => _LICDetailsState();
}

class _LICDetailsState extends State<LICDetails> {
  var screen = "LIC details";

  double mainWallet = 0.0;

  var showDetails = false;
  var checkedValue = false;

  final policyNoController = new TextEditingController();
  final emailController = new TextEditingController();
  final partialAmtController = new TextEditingController();

  double cardCharge = 0.0;
  double remainAmt = 0;

  var jwtToken = "";

  var name;

  var dueDate;

  var billAmount;

  var maxBillAmount;

  var acceptPartPay;

  var isCardOpen = false;
  var isUPIOpen = false;

  final cardController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final cardMMController = TextEditingController();
  final cardYYController = TextEditingController();
  final cardCVVController = TextEditingController();

  FocusNode nodeMM = FocusNode();
  FocusNode nodeYY = FocusNode();
  FocusNode nodeCVV = FocusNode();

  double updateLat = 0.0;
  double updateLng = 0.0;

  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

  Map mapFetch = {};

  var custEmail;
  var custPolicyNo;
  var ad2;
  var ad3;

  var mainWal;

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();
    _getCurrentLocation();
  }

  @override
  void dispose() {
    policyNoController.dispose();
    emailController.dispose();
    partialAmtController.dispose();

    cardController.dispose();
    cardHolderNameController.dispose();
    cardMMController.dispose();
    cardYYController.dispose();
    cardCVVController.dispose();

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
      mainWal = mpBalc;
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
              appBar: appBarHome(context, "assets/bbps_2.png", 24.0.w),
              body: SingleChildScrollView(
                  child: Column(
                children: [
                  appSelectedBanner(context, "recharge_banner.png", 150.0.h),
                  _buildInputFields(),
                ],
              )),
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
                                custPolicyNo =
                                    policyNoController.text.toString();
                                custEmail = emailController.text.toString();

                                if (custPolicyNo.length == 0) {
                                  showToastMessage("enter the policy number");
                                  return;
                                }
                                if (custEmail.length == 0) {
                                  showToastMessage("please enter your email");
                                  return;
                                }
                                if (!emailPattern.hasMatch(custEmail)) {
                                  showToastMessage("Invalid email");
                                  return;
                                }
                                closeKeyBoard(context);
                                generatePANToken(custPolicyNo, custEmail);
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
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
        color: white,
        /*boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 10,
            blurRadius: 10,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],*/
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              children: [
                Image.asset(
                  'assets/lic_logo.png',
                  width: 60.w,
                )
              ],
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 20,
              left: padding,
              right: padding,
            ),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 5, bottom: 5),
              child: TextFormField(
                style: TextStyle(
                    color: black,
                    fontSize: inputFont.sp,
                    fontWeight: FontWeight.bold),
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                textCapitalization: TextCapitalization.characters,
                controller: policyNoController,
                decoration: new InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10),
                  counterText: "",
                  label: Text("enter policy number"),
                ),
                maxLength: 80,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(
              top: 10,
              left: padding,
              right: padding,
            ),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 5, bottom: 5),
              child: TextFormField(
                style: TextStyle(
                    color: black,
                    fontSize: inputFont.sp,
                    fontWeight: FontWeight.bold),
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                controller: emailController,
                decoration: new InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10),
                  counterText: "",
                  label: Text("enter email"),
                ),
                maxLength: 80,
              ),
            ),
          ),
          (showDetails)
              ? Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 25.0, right: 30, left: 30),
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
                              "$name",
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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 25.0, right: 30, left: 30),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Due Date",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font13.sp),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "$dueDate",
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
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 25.0, right: 30, left: 30),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Bill Amount",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font13.sp),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "$rupeeSymbol $billAmount",
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
                    (acceptPartPay.toString() == "true")
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
                                textCapitalization:
                                    TextCapitalization.characters,
                                controller: partialAmtController,
                                decoration: new InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 10),
                                  counterText: "",
                                  label: Text("enter amount"),
                                ),
                                maxLength: 7,
                                onChanged: (val) {
                                  if (val.length != 0) {
                                    calculateCharge(val.toString());
                                  }
                                },
                              ),
                            ),
                          )
                        : Container(),
                    (acceptPartPay.toString() == "true")
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Max recharge amount is $rupeeSymbol $maxBillAmount",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font12.sp),
                            ),
                          )
                        : Container(),
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
                    (mainWal.toString() == "0" ||
                            mainWal.toString() == "0.0" ||
                            mainWal.toString() == "null")
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
                                        onChanged: (val) {
                                          setState(() {
                                            double walletValue = mainWallet;
                                            double rechargeValue = 0;

                                            setState(() {
                                              /*if (moneyProBalc.toString() == "") {
                                          walletValue = 0;
                                        } else {
                                          walletValue =
                                              double.parse(moneyProBalc);
                                        }*/

                                              var amt;
                                              if (acceptPartPay.toString() ==
                                                  "true") {
                                                amt = partialAmtController.text
                                                    .toString();
                                              } else {
                                                amt = billAmount;
                                              }

                                              if (amt.toString() == "") {
                                                showToastMessage(
                                                    "enter the amount");
                                                return;
                                              } else {
                                                rechargeValue =
                                                    double.parse(amt);
                                              }
                                            });

                                            if (walletValue < rechargeValue) {
                                              setState(() {
                                                remainAmt =
                                                    rechargeValue - walletValue;
                                              });
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
                                                  //"${formatDecimal2Digit.format(mainWallet)}",
                                                  "$mainWallet",
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
                  ],
                )
              : Container(),
          Divider(),
          (showDetails)
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(top: 15.0, left: 25, right: 25),
                      child: Text(
                        selectPayOptions,
                        style: TextStyle(
                            color: black,
                            fontSize: font15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    _buildUPISection(),
                    _buildCardSection(),
                  ],
                )
              : Container(),
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
          });

          double walletValue = 0;
          double rechargeValue = 0;

          setState(() {
            if (mpBalc.toString() == "") {
              walletValue = 0;
            } else {
              walletValue = double.parse(mpBalc);
            }

            var amt;
            if (acceptPartPay.toString() == "true") {
              amt = partialAmtController.text.toString();
            } else {
              amt = billAmount;
            }

            if (amt.toString() == "") {
              showToastMessage("enter the amount");
              return;
            } else {
              rechargeValue = double.parse(amt);
            }

            if (acceptPartPay.toString() == "true" &&
                maxBillAmount.toString() != "") {
              double minDb = double.parse(maxBillAmount);
              if (rechargeValue > minDb) {
                showToastMessage(
                    "Maximum recharge is $rupeeSymbol $maxBillAmount");
                return;
              }
            }

            if (checkedValue) {
              if (walletValue >= rechargeValue) {
                var id = DateTime.now().millisecondsSinceEpoch;
                getWalletJWTToken(id, rechargeValue);
              } else {
                if (isUPIOpen) {
                  setState(() {
                    remainAmt = rechargeValue - walletValue;
                  });
                  var id = DateTime.now().millisecondsSinceEpoch;
                  getCardJWTToken(id, rechargeValue, remainAmt, walletValue);
                } else {
                  showToastMessage("Select any one payment method");
                }
              }
            } else {
              if (isUPIOpen) {
                var id = DateTime.now().millisecondsSinceEpoch;
                getCardPaymentJWTToken(id, rechargeValue);
              } else {
                showToastMessage("Select any one payment method");
              }
            }
          });
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
                  isUPIOpen = false;
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

  _buildButtonSection() {
    return Wrap(
      alignment: WrapAlignment.center,
      children: [
        Container(
          width: MediaQuery.of(context).size.width * .8,
          height: 40.h,
          margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
          decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(25)),
              border: Border.all(color: lightBlue)),
          child: InkWell(
            onTap: () async {
              var id = DateTime.now().millisecondsSinceEpoch;

              var amt;
              if (acceptPartPay.toString() == "true") {
                amt = partialAmtController.text.toString();
              } else {
                amt = billAmount;
              }
              //generateSecontPANToken(id, amt);

              setState(() {});

              double walletValue = 0;
              double rechargeValue = 0;

              var mpBalc = await getWalletBalance();

              setState(() {
                if (mpBalc.toString() == "") {
                  walletValue = 0;
                } else {
                  walletValue = double.parse(mpBalc);
                }

                var amt;
                if (acceptPartPay.toString() == "true") {
                  amt = partialAmtController.text.toString();
                } else {
                  amt = billAmount;
                }

                if (amt.toString() == "") {
                  showToastMessage("enter the amount");
                  return;
                } else {
                  rechargeValue = double.parse(amt);
                }

                if (acceptPartPay.toString() == "true" &&
                    maxBillAmount.toString() != "") {
                  double minDb = double.parse(maxBillAmount);
                  if (rechargeValue > minDb) {
                    showToastMessage(
                        "Maximum recharge is $rupeeSymbol $maxBillAmount");
                    return;
                  }
                }

                if (checkedValue) {
                  if (walletValue >= rechargeValue) {
                    var id = DateTime.now().millisecondsSinceEpoch;
                    getWalletJWTToken(id, rechargeValue);
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
                        remainAmt = rechargeValue - walletValue;
                      });

                      calculateCardCheckCharge(remainAmt);

                      var id = DateTime.now().millisecondsSinceEpoch;

                      remainAmt = remainAmt + cardCharge;

                      printMessage(screen,
                          "Remaining amount : ${formatNow.format(remainAmt)}");

                      getCardJWTToken(id, rechargeValue,
                          formatNow.format(remainAmt), walletValue);
                    } else {
                      showToastMessage("Select any one payment method");
                    }
                  }
                } else {
                  printMessage(screen, "Check card Open : $isCardOpen");
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

                    rechargeValue = rechargeValue + cardCharge;
                    var id = DateTime.now().millisecondsSinceEpoch;
                    getCardPaymentJWTToken(id, formatNow.format(rechargeValue));
                  } else {
                    showToastMessage("Select any one payment method");
                  }
                }
              });
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
        SizedBox(
          height: 10.h,
        ),
        Text(
          powered_by,
          style: TextStyle(
              color: black, fontSize: 16.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 10.h,
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

  Future generatePANToken(policy, email) async {
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

    final body = {};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(jwtTokenAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          var jwtToken = data['token'].toString();
          getLicDetails(policy, email, jwtToken);
        } else {
          Navigator.pop(context);
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  Future getLicDetails(policy, email, jwtToken) async {
    setState(() {});

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    var userToken = await getToken();

    final body = {
      "user_token": "$userToken",
      "canumber": "$policy",
      "ad1": "$email",
      "jwttoken": "$jwtToken",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(licBillFacthAPI),
        body: jsonEncode(body), headers: headers);

    setState(() {
      Navigator.pop(context);
      var statusCode = response.statusCode;

      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Response statusCode : ${data}");

        if (data['status'].toString() == "1") {
          var responseCode = data['fatch_list']['response_code'].toString();

          if (responseCode.toString() == "0") {
            var message = data['fatch_list']['message'];
            showToastMessage(message);
            showDetails = false;
          } else {
            showDetails = true;
            name = data['fatch_list']['name'];
            dueDate = data['fatch_list']['duedate'];
            billAmount = data['fatch_list']['amount'];
            maxBillAmount = data['fatch_list']['bill_fetch']['maxBillAmount'];
            acceptPartPay = data['fatch_list']['bill_fetch']['acceptPartPay'];
            ad2 = data['fatch_list']['ad2'];
            ad3 = data['fatch_list']['ad2'];

            mapFetch = data['fatch_list']['bill_fetch'];
          }
        } else {
          showToastMessage(status500);
          showDetails = false;
        }
      }
    });
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        updateLat = position.latitude;
        updateLng = position.longitude;
      });
      printMessage(
          screen, "Update LAT : $updateLat and Update LNG : $updateLng");
    }).catchError((e) {
      print(e);
    });
  }

  Future getWalletJWTToken(id, amt) async {
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

    final body = {};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(jwtTokenAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          var jwtToken = data['token'].toString();
          paymentByWallet(id, amt, jwtToken);
        } else {
          Navigator.pop(context);
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  Future getCardJWTToken(id, rechargeValue, remainAmt, walletValue) async {
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

    final body = {};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(jwtTokenAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          jwtToken = data['token'].toString();
          createOrderForCard(
              id, rechargeValue, formatNow.format(remainAmt), walletValue);
        } else {
          Navigator.pop(context);
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  Future getCardPaymentJWTToken(id, rechargeValue) async {
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

    final body = {};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(jwtTokenAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          jwtToken = data['token'].toString();
          createOrderForFullCard(id, rechargeValue);
        } else {
          Navigator.pop(context);
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  /*Future generateSecontPANToken(id, amt) async {
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

    final body = {};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(jwtTokenAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          jwtToken = data['token'].toString();
          finalPayment(id, amt);
        } else {
          Navigator.pop(context);
          showToastMessage(somethingWrong);
        }
      }
    });
  }*/

  Future paymentByWallet(id, amt, jwtToken) async {
    var currentTime = DateFormat.jm().format(DateTime.now());

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
      "jwttoken": "$jwtToken",
      "userToken": "$userToken",
      "wallet": "$amt", //(if not use send 0)
      "paymentgatewayAmount": "0",
      "paymentgatewayTxn": "",
      "paymentgatewayMode": "",
      "txTime": "",
      "signature": "",
      "txStatus": "",
      "welcomeAmount": "0"
    };

    printMessage(screen, "Header : $headers");

    Map body = {
      "canumber": "$custPolicyNo",
      "mode": "offline",
      "amount": "$amt",
      "ad1": "$custEmail",
      "ad2": "$ad2",
      "ad3": "$ad3",
      "referenceid": "$id",
      "latitude": "$updateLat",
      "longitude": "$updateLng",
      "bill_fetch": "$mapFetch",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(licBillPayAPI),
        body: jsonEncode(body), headers: headers);

    var statusCode = response.statusCode;
    printMessage(screen, "Response statusCode : ${response.body}");

    setState(() {
      Navigator.pop(context);
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['status'].toString() == "1") {
          if (data['data']['status'].toString() == "true") {
            var message = data['data']['message'].toString();

            Map map = {
              "TxStatus": "Success",
              "orderAmount": "$amt",
              "paymentMode": "Wallet",
              "tId": "$id",
              "txTime": "$currentTime",
              "txMsg": "$message",
              "operatorName": "LIC",
              "referenceId": "",
              "signature": ""
            }; //{status: 1, data: {status: true, response_code: 0, operatorid: , ackno: 12021396, message: Transaction Initiated.}, commission: 5.4}
            openMobileReceipt(context, map, false);
          } else {
            var message = data['data']['message'].toString();
            Map map = {
              "TxStatus": "Failure",
              "orderAmount": "$amt",
              "paymentMode": "Wallet",
              "tId": "$id",
              "txTime": "$currentTime",
              "txMsg": "$message",
              "operatorName": "LIC",
              "referenceId": "",
              "signature": ""
            };
            openPaymentFailure(context, map);
          }
          showToastMessage(data['data']['message'].toString());
        } else {
          showToastMessage(somethingWrong);
        }
      } else {
        showToastMessage(status500);
      }
    });
  }

  createOrderForCard(id, rechargeValue, remainAmt, walletValue) async {
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
        moveToPaymentCard(id, rechargeValue, remainAmt, walletValue, token);
      } else {
        Navigator.pop(context);
      }
    });
  }

  moveToPaymentCard(id, rechargeValue, remainAmt, walletValue, token) async {
    String orderNote = "Order Note";

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
          verifyCardPayment(value, rechargeValue, remainAmt, walletValue);
        });
        printMessage(screen, "Final result : $value");
      });
    }

    if (isUPIOpen) {
      CashfreePGSDK.getUPIApps().then((value) {
        setState(() {
          getUPIAppNames(value, id, remainAmt, token);
        });
      });
    }
  }

  verifyCardPayment(responsePG, rechargeValue, remainAmt, walletValue) async {
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
        //call final API here
        paymentByCardPayment(orderId, walletValue, remainAmt, referenceId,
            paymentMode, txTime, signature, txStatus, orderAmount);
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

  Future paymentByCardPayment(orderId, walletAmt, pgAmt, pgTxn, pgMode, txTime,
      signature, txStatus, orderAmount) async {
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
      "jwttoken": "$jwtToken",
      "userToken": "$userToken",
      "wallet": "$walletAmt", //(if not use send 0)
      "paymentgatewayAmount": "$pgAmt",
      "paymentgatewayTxn": "$pgTxn",
      "paymentgatewayMode": "$pgMode",
      "txTime": "$txTime",
      "signature": "$signature",
      "txStatus": "$txStatus",
      "welcomeAmount": "0"
    };

    printMessage(screen, "Header : $headers");

    Map body = {
      "canumber": "$custPolicyNo",
      "mode": "offline",
      "amount": "$orderAmount",
      "ad1": "$custEmail",
      "ad2": "$ad2",
      "ad3": "$ad3",
      "referenceid": "$pgTxn",
      "latitude": "$updateLat",
      "longitude": "$updateLng",
      "bill_fetch": "$mapFetch",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(licBillPayAPI),
        body: jsonEncode(body), headers: headers);

    var statusCode = response.statusCode;
    printMessage(screen, "Response statusCode : ${response.statusCode}");

    setState(() {
      Navigator.pop(context);

      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['status'].toString() == "1") {
          if (data['data']['status'].toString() == "true") {
            var message = data['data']['message'].toString();

            Map map = {
              "TxStatus": "$txStatus",
              "orderAmount": "$orderAmount",
              "paymentMode": "Payment Gateway",
              "tId": "$orderId",
              "txTime": "$txTime",
              "txMsg": "$message",
              "operatorName": "LIC",
              "referenceId": "$pgTxn",
              "signature": "$signature"
            };
            openMobileReceipt(context, map, true);
          } else {
            var message = data['data']['message'].toString();
            Map map = {
              "TxStatus": "$txStatus",
              "orderAmount": "$orderAmount",
              "paymentMode": "Payment Gateway",
              "tId": "$orderId",
              "txTime": "$txTime",
              "txMsg": "$message",
              "operatorName": "LIC",
              "referenceId": "$pgTxn",
              "signature": "$signature"
            };
            openPaymentFailure(context, map);
          }
          showToastMessage(data['data']['message'].toString());
        } else {
          showToastMessage(somethingWrong);
        }
      } else {
        showToastMessage(status500);
      }
    });
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
        "appName": upiId,
      };

      printMessage(screen, "Input Params : $inputParams");

      CashfreePGSDK.doUPIPayment(inputParams).then((value) {
        setState(() {
          verifyFullCardPayment(value);
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

  verifyFullCardPayment(responsePG) async {
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
        paymentByCardPayment(orderId, "0", orderAmount, referenceId,
            paymentMode, txTime, signature, txStatus, orderAmount);
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

  createOrderForFullCard(
    id,
    rechargeValue,
  ) async {
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
      "orderAmount": "$rechargeValue",
      "orderCurrency": "INR"
    };
    final response = await http.post(Uri.parse(cashFreeTokenAPI),
        body: json.encode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "getCashFreeToken : $data");

    setState(() {
      if (data['status'].toString() == "OK") {
        var token = data['cftoken'].toString();
        moveToPaymentFullCard(id, rechargeValue, token);
      } else {
        Navigator.pop(context);
      }
    });
  }

  moveToPaymentFullCard(id, rechargeValue, token) async {
    String orderNote = "Order Note";

    var name = await getContactName();
    var customerPhone = await getMobile();
    var customerEmail = await getEmail();

    Map<String, dynamic> inputFinalParams = {};

    Map<String, dynamic> inputParams = {
      "orderId": "$id",
      "orderAmount": "$rechargeValue",
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
          verifyFullCardPayment(value);
        });
        printMessage(screen, "Final result : $value");
      });
    }

    if (isUPIOpen) {
      CashfreePGSDK.getUPIApps().then((value) {
        setState(() {
          getUPIAppNames(value, id, rechargeValue, token);
        });
      });
    }
  }

  calculateCardCheckCharge(amount) {
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
}
