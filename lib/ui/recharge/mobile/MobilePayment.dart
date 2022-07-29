import 'dart:math';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

class MobilePayment extends StatefulWidget {
  final Map map;

  const MobilePayment({Key? key, required this.map}) : super(key: key);

  @override
  _MobilePaymentState createState() => _MobilePaymentState();
}

class _MobilePaymentState extends State<MobilePayment> {
  var screen = "Mobile Payment";
  var checkedValue = false;

  var rechargeAmount;

  double remainAmt = 0;
  String moneyProBalc = "0";

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

  double cardCharge = 0.0;
  double welcomeCharge = 0.0;

  dynamic currentTime;

  int noOfUPI = 0;
  int upiIndex = 0;
  var upiId = "";

  double welcomeAMT = 0.0;
  var isWelcomeOffer = false;

  var actualRechargeAmount = "";

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

  @override
  void initState() {
    super.initState();

    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();

    setState(() {
      rechargeAmount = widget.map['price'].toString();
      actualRechargeAmount = widget.map['price'].toString();

      currentYear = yearFormat.format(currentDate);
      timeH = timeFormat.format(currentDate);
      cDate = dateFormat.format(currentDate);

      currentYear = currentYear[3];
    });

    setState(() {
      finalString = "${getRandomString(27)}$currentYear$cDate$timeH";
    });

    printMessage(screen, "Final String : $finalString");
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

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

    var welAmt = await getWelcomeAmt();

    setState(() {
      moneyProBalc = mpBalc;
      if (moneyProBalc.toString() == "") {
        moneyProBalc = "0.0";
      }

      if (welAmt.toString() == "null" ||
          welAmt.toString() == "0" ||
          welAmt.toString() == "") {
        isWelcomeOffer = false;
      } else {
        double xx = double.parse(rechargeAmount);
        welcomeAMT = double.parse(welAmt);
        if (xx > 399) {
          isWelcomeOffer = true;
        } else {
          isWelcomeOffer = false;
        }
        var x = double.parse(moneyProBalc) + welcomeAMT;
        moneyProBalc = "$x";
      }
    });

    printMessage(screen, "Welcome AMT : $welAmt");
    calculateWelcomeAMt(widget.map['price'].toString());
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
    return SafeArea(
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
            height: 60,
            width: 60,
            child: Stack(
              children: [
                Image.asset(
                  'assets/back_arrow_bg.png',
                  height: 60,
                ),
                Positioned(
                  top: 16,
                  left: 12,
                  child: Image.asset(
                    'assets/back_arrow.png',
                    height: 16,
                  ),
                )
              ],
            ),
          ),
        ),
        titleSpacing: 0,
        title: appLogo(),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 20),
              child: Row(
                children: [
                  (widget.map['billerImg'].toString() == "")
                      ? Container()
                      : SizedBox(
                          height: 30,
                          child: Image.network(
                            "$imageSubAPI${widget.map['billerImg'].toString()}",
                          ),
                        ),
                  (widget.map['billerImg'].toString() == "")
                      ? Container()
                      : SizedBox(
                          width: 10,
                        ),
                  SizedBox(
                    width: 0,
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${widget.map['mobileNo']}",
                        style: TextStyle(
                            color: black,
                            fontSize: font15,
                            fontWeight: FontWeight.bold),
                      ),
                      Row(
                        children: [
                          Text(
                            (widget.map['operatorName'].toString() == "")
                                ? "${widget.map['operatorSecName']}"
                                : "${widget.map['operatorName']}",
                            style: TextStyle(
                                color: lightBlack,
                                fontSize: font15,
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            " | ",
                            style: TextStyle(
                                color: lightBlack,
                                fontSize: font15,
                                fontWeight: FontWeight.normal),
                          ),
                          Text(
                            (widget.map['circleName'].toString() == "")
                                ? "${widget.map['stateName']}"
                                : "${widget.map['circleName']}",
                            style: TextStyle(
                                color: lightBlack,
                                fontSize: font15,
                                fontWeight: FontWeight.normal),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 20, right: 25),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$rupeeSymbol ${widget.map['price']}",
                          style: TextStyle(
                              color: dotColor,
                              fontSize: font18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          height: 2,
                        ),
                        Text(
                          "${widget.map['packageDescription']}",
                          style: TextStyle(
                              color: lightBlack,
                              fontSize: font13,
                              fontWeight: FontWeight.normal),
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          "${widget.map['validityDescription']}",
                          style: TextStyle(
                              color: lightBlack,
                              fontSize: font13,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      closeKeyBoard(context);
                      closeCurrentPage(context);
                    },
                    child: Text(
                      "Change Plan",
                      style: TextStyle(color: lightBlue, fontSize: font15),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, top: 5),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 15.0, right: 30, left: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    debitFrom,
                    style: TextStyle(
                        color: black,
                        fontSize: font14,
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
                                  walletValue = double.parse(mpBalc);
                                }

                                if (rechargeAmount.toString() == "") {
                                  rechargeValue = 0;
                                } else {
                                  rechargeValue = double.parse(rechargeAmount);
                                }
                              });

                              if (walletValue < rechargeValue) {
                                setState(() {
                                  remainAmt = rechargeValue - walletValue;
                                });

                                if (isWelcomeOffer) {
                                  remainAmt = remainAmt - welcomeCharge;
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
                        style: TextStyle(fontSize: font14, color: black),
                      ),
                      Spacer(),
                      Container(
                        margin: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            color: walletBg,
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                            border: Border.all(color: walletBg)),
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, top: 5, bottom: 5),
                          child: Wrap(
                            direction: Axis.horizontal,
                            children: [
                              Image.asset(
                                "assets/wallet.png",
                                height: 24,
                              ),
                              Center(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 8.0, right: 8, top: 5),
                                  child: Text(
                                    //"${formatDecimal2Digit.format(double.parse(moneyProBalc))}",
                                    "$moneyProBalc",
                                    style: TextStyle(
                                        color: white, fontSize: font15),
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
                          padding: const EdgeInsets.only(left: 15.0),
                          child: Text(
                            "Remaining amount $rupeeSymbol ${formatNow.format(remainAmt)}",
                            style: TextStyle(color: black, fontSize: font14),
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            (isWelcomeOffer) ? _buildOfferRwo() : Container(),
            _buildUPISection(),
            _buildCardSection(),
          ],
        ),
      ),
      bottomNavigationBar: _buildButtonSection(),
    ));
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

            if (rechargeAmount.toString() == "") {
              rechargeValue = 0;
            } else {
              rechargeValue = double.parse(rechargeAmount);
            }
          });

          if (checkedValue) {
            if (walletValue >= rechargeValue) {
              var id = DateTime.now().millisecondsSinceEpoch;
              setState(() {
                isWallMore = true;
              });
              paymentStatusByWalletOnly(id, formatNow.format(rechargeValue));
            } else {
              setState(() {
                isWallMore = false;
              });
              if (isUPIOpen) {
                setState(() {
                  remainAmt = rechargeValue - walletValue;
                });
                var id = DateTime.now().millisecondsSinceEpoch;

                if (isWelcomeOffer) {
                  remainAmt = remainAmt - welcomeCharge;
                }
                paymentByUPIWallet(id, formatNow.format(remainAmt),
                    formatNow.format(rechargeValue));
              } else {
                showToastMessage("Select any one payment method");
              }
            }
          } else {
            if (isUPIOpen) {
              var id = DateTime.now().millisecondsSinceEpoch;

              if (isWelcomeOffer) {
                rechargeValue = rechargeValue - welcomeCharge;
              }
              setState(() {
                isWallMore = false;
              });
              printMessage(screen, "Recharge Value is : $rechargeValue");

              paymentByPGDirect(id, formatNow.format(rechargeValue));
            } else {
              showToastMessage("Select any one payment method");
            }
          }
        },
        child: Padding(
          padding:
              const EdgeInsets.only(left: 20.0, right: 4, top: 15, bottom: 15),
          child: Row(
            children: [
              Image.asset(
                'assets/upi_ar.png',
                height: 20,
                width: 20,
              ),
              SizedBox(
                width: 10,
              ),
              Row(
                children: [
                  Text(
                    "UPI",
                    style: TextStyle(
                      color: black,
                      fontSize: font15,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "( 0% extra charges )",
                    style: TextStyle(
                      color: lightBlack,
                      fontSize: font12,
                    ),
                  ),
                ],
              ),
              Spacer(),
              SizedBox(
                width: 15,
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
                  calculateCardCheckCharge(remainAmt);
                });
              },
              title: Row(
                children: [
                  Image.asset(
                    'assets/credit_card.png',
                    height: 20,
                    width: 20,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text(
                    "Card",
                    style: TextStyle(
                      color: black,
                      fontSize: font15,
                    ),
                  ),
                  SizedBox(
                    width: 5,
                  ),
                  Text(
                    "( 0.90% or max $rupeeSymbol 20 extra charges )",
                    style: TextStyle(
                      color: lightBlack,
                      fontSize: font12,
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
                        style: TextStyle(color: black, fontSize: font14),
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
                      style: TextStyle(color: black, fontSize: inputFont),
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
                          style: TextStyle(color: lightBlack, fontSize: font14),
                        ),
                      ),
                      maxLength: 19,
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
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.name,
                      textInputAction: TextInputAction.next,
                      controller: cardHolderNameController,
                      textCapitalization: TextCapitalization.characters,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        hintText: "Card holder name",
                        label: Text(
                          "Name",
                          style: TextStyle(color: lightBlack, fontSize: font14),
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
                        height: 50,
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
                                      color: black, fontSize: inputFont),
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
                                          color: lightBlack, fontSize: font14),
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
                                      color: black, fontSize: inputFont),
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
                                          color: lightBlack, fontSize: font14),
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
                            style: TextStyle(color: black, fontSize: inputFont),
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
                                    color: lightBlack, fontSize: font14),
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
                        style: TextStyle(color: black, fontSize: font12),
                      ),
                    )),
                SizedBox(
                  height: 20,
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
          height: 40,
          margin: EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 5),
          decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(25)),
              border: Border.all(color: lightBlue)),
          child: InkWell(
            onTap: () async {
              var mpBalc = await getWalletBalance();

              setState(() {});

              double walletValue = 0;
              double rechargeValue = 0;

              setState(() {
                if (mpBalc.toString() == "") {
                  walletValue = 0;
                } else {
                  walletValue = double.parse(mpBalc);
                }

                if (rechargeAmount.toString() == "") {
                  rechargeValue = 0;
                } else {
                  rechargeValue = double.parse(rechargeAmount);
                }
              });

              if (checkedValue) {
                if (walletValue >= rechargeValue) {
                  setState(() {
                    isWallMore = true;
                  });
                  var id = DateTime.now().millisecondsSinceEpoch;
                  paymentStatusByWalletOnly(
                      id, formatNow.format(rechargeValue));
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
                      remainAmt = rechargeValue - walletValue;
                    });

                    calculateCardCheckCharge(remainAmt);

                    var id = DateTime.now().millisecondsSinceEpoch;

                    remainAmt = remainAmt + cardCharge;

                    if (isWelcomeOffer) {
                      remainAmt = remainAmt - welcomeCharge;
                    }

                    printMessage(screen,
                        "Remaining amount : ${formatNow.format(remainAmt)}");

                    paymentByUPIWallet(
                        id, formatNow.format(remainAmt), rechargeAmount);
                  } else {
                    showToastMessage("Select any one payment method");
                  }
                }
              } else {
                printMessage(screen, "Check card Open : $isCardOpen");
                if (isCardOpen) {
                  setState(() {
                    isWallMore = false;
                  });
                  var id = DateTime.now().millisecondsSinceEpoch;
                  if (isWelcomeOffer) {
                    rechargeValue = rechargeValue - welcomeCharge;
                  }
                  rechargeValue = rechargeValue + cardCharge;
                  paymentByPGDirect(id, formatNow.format(rechargeValue));
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
                  fontSize: font14,
                ),
              ),
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        // Text(
        //   powered_by,
        //   style: TextStyle(
        //       color: black, fontSize: 16, fontWeight: FontWeight.bold),
        // ),
        SizedBox(
          height: 10,
        ),
        Divider(),
        Row(
          children: [
            Expanded(
                child: Image.asset(
              'assets/pci.png',
              height: 24,
            )),
            Expanded(
                child: Image.asset(
              'assets/upi.png',
              height: 20,
            )),
            Expanded(
                child: Image.asset(
              'assets/iso.png',
              height: 30,
            )),
          ],
        ),
        SizedBox(
          height: 10,
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
    double v4 = (amount / v3) * v1;

    if (v4 > 20) {
      cardCharge = 20.0;
    } else {
      cardCharge = v4;
    }
    printMessage(screen, "v4 : ${formatNow.format(v4)}");
    printMessage(screen, "cardCharge : ${formatNow.format(cardCharge)}");
  }

  Future paymentStatusByWalletOnly(id, rechargeAmt) async {
    setState(() {
      currentTime = DateFormat.jm().format(DateTime.now());

      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var token = await getToken();
    var mId;
    var xAmt;
    var mBal = await getWalletBalance();

    var role = await getRole();

    if (role == "3") {
      mId = await getMerchantID();
    } else {
      mId = "";
    }

    if (isWallMore) {
      xAmt = double.parse(actualRechargeAmount);
    } else {
      if (checkedValue) {
        xAmt = double.parse(mBal);
      } else {
        xAmt = 0;
      }
    }

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "operator_code": "${widget.map['operatorSecCode']}",
      "param": "${widget.map['mobileNo']}",
      "circle_code": "${widget.map['stateCode']}",
      "amount": "$actualRechargeAmount",
      "token": "$token",
      "paymentgateway_amount": "0",
      "paymentgateway_txn": "",
      "paymentgateway_mode": "",
      "txTime": "",
      "signature": "",
      "txStatus": "",
      "referenceId": "",
      "m_id": "$mId",
      "wallet": "$xAmt",
      "param1": "",
      "param2": "",
      "param3": "",
      "param4": "",
      "param5": "",
      "operator_name": "${widget.map['operatorSecName']}",
      "category": "${widget.map['category']}",
      "welcome_amount":
          (isWelcomeOffer) ? "${formatNow.format(welcomeCharge)}" : "0",
      //"refId":"$finalString"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(mobileRechargePaymentAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    printMessage(screen, "Status Code : $statusCode");

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response paymentStatusUpdate : $data");

      setState(() {
        var status = data['status'].toString();
        if (status.toLowerCase() == "success") {
          Navigator.pop(context);
          showToastMessage(data['message'].toString());

          var commission = data['commission'];

          var tId = data['transction_id'].toString();

          Map map = {
            "tId": "$tId",
            "TxStatus": "Success",
            "orderAmount": "$rechargeAmt",
            "paymentMode": "MoneyPro Wallet",
            "orderId": "",
            "txTime": "$currentTime",
            "txMsg": "Transaction is successfull",
            "type": "MoneyPro Wallet",
            "referenceId": "",
            "signature": "",
            "operatorName": "${widget.map['operatorName']}",
            "mobile": "${widget.map['mobile']}",
            "commission": "$commission"
          };
          openMobileReceipt(context, map, true);
          //}

        } else if (status.toString() == "2") {
          Navigator.pop(context);
          showToastMessage(somethingWrong);
        } else if (status.toString() == "0") {
          Navigator.pop(context);
          showToastMessage(somethingWrong);
        } else {
          String msg = "";
          String sta = "";

          if (data['status'].toString().toLowerCase() == "pending") {
            setState(() {
              msg = "Transaction is pending";
              sta = "Pending";
            });
          }

          if (data['status'].toString().toLowerCase() == "failure") {
            setState(() {
              msg = "Transaction is failure";
              sta = "Failure";
            });
          }

          printMessage(screen, "Check Status : $sta");
          printMessage(screen, "Check msg : $msg");

          Map map = {
            "txStatus": "$status",
            "orderAmount": "$rechargeAmt",
            "paymentMode": "MoneyPro Wallet",
            "orderId": "NA",
            "txTime": "$currentTime",
            "txMsg": "$msg",
            "type": "MoneyPro Wallet",
            "referenceId": "",
            "signature": ""
          };
          openPaymentFailure(context, map);
        }
      });
    } else {
      Navigator.pop(context);
      showToastMessage(status500);
    }
  }

  paymentByUPIWallet(orderId, amount, rechAmt) async {
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
        movePGByUPIWallet(orderId, token, amount, rechAmt);
      } else {
        Navigator.pop(context);
      }
    });
  }

  movePGByUPIWallet(orderId, token, difAmt, rechAmt) async {
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
          verifySignatureByUPIWallet(value, rechAmt);
        });
        printMessage(screen, "Final result : $value");
      });
    }

    if (isUPIOpen) {
      CashfreePGSDK.getUPIApps().then((value) {
        setState(() {
          getUPIAppNames(value, orderId, difAmt, token, rechAmt);
        });
      });
    }
  }

  verifySignatureByUPIWallet(responsePG, rechAmt) async {
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

    Navigator.pop(context);

    if (responsePG['txStatus'].toString() == "SUCCESS") {
      printMessage(screen, "Transaction is Successful");
      setState(() {
        paymentStatusDirectPG(rechAmt, orderAmount, orderId, paymentMode,
            txTime, signature, txStatus, referenceId, txMsg, type);
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

  Future paymentStatusDirectPG(rechargeAmt, pgAmt, pgTxn, pgMode, pgTxTime,
      pgSign, pgTxStatus, pgRefId, pgTxMsg, pgType) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var token = await getToken();
    var mId;
    var xAmt;

    var mBal = await getWalletBalance();

    var role = await getRole();

    if (role == "3") {
      mId = await getMerchantID();
    } else {
      mId = "";
    }

    if (isWallMore) {
      xAmt = double.parse(actualRechargeAmount);
    } else {
      if (checkedValue) {
        xAmt = double.parse(mBal);
      } else {
        xAmt = 0;
      }
    }

    printMessage(screen, "isWelcomeOffer : $isWelcomeOffer");
    printMessage(screen, "pgAmt : $pgAmt");
    printMessage(screen, "mBal : $mBal");

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "operator_code": "${widget.map['operatorSecCode']}",
      "param": "${widget.map['mobileNo']}",
      "circle_code": "${widget.map['stateCode']}",
      "amount": "$actualRechargeAmount",
      "token": "$token",
      "paymentgateway_amount": "$pgAmt",
      "paymentgateway_txn": "$pgTxn",
      "paymentgateway_mode": "$pgMode",
      "txTime": "$pgTxTime",
      "signature": "$pgSign",
      "txStatus": "$pgTxStatus",
      "referenceId": "$pgRefId",
      "m_id": "$mId",
      "wallet": "$xAmt",
      "param1": "",
      "param2": "",
      "param3": "",
      "param4": "",
      "param5": "",
      "operator_name": "${widget.map['operatorSecName']}",
      "category": "${widget.map['category']}",
      "welcome_amount":
          (isWelcomeOffer) ? "${formatNow.format(welcomeCharge)}" : "0",
      //"refId":"$finalString"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(mobileRechargePaymentAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    printMessage(screen, "Response statusCode : $statusCode");

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response paymentStatusUpdate : $data");
      Navigator.pop(context);
      setState(() {
        var status = data['status'].toString();
        if (status.toLowerCase() == "success") {
          Navigator.pop(context);
          showToastMessage(data['message'].toString());
          var tId = data['transction_id'].toString();
          var commission = data['commission'];
          Map map = {
            "tId": "$tId",
            "TxStatus": "$pgTxStatus",
            "orderAmount": "$pgAmt",
            "paymentMode": "$pgMode",
            "orderId": "$pgTxn",
            "txTime": "$pgTxTime",
            "txMsg": "$pgTxMsg",
            "type": "$pgType",
            "referenceId": "$pgRefId",
            "signature": "$pgSign",
            "operatorName": "${widget.map['operatorName']}",
            "mobile": "${widget.map['mobile']}",
            "commission": "$commission"
          };
          openMobileReceipt(context, map, true);
        } else if (status.toString() == "2") {
          Navigator.pop(context);
          showToastMessage(somethingWrong);
        } else if (status.toString() == "0") {
          Navigator.pop(context);
          showToastMessage(somethingWrong);
        } else {
          String msg = "";
          String sta = "";

          if (data['status'].toString().toLowerCase() == "pending") {
            setState(() {
              msg = "Transaction is pending";
              sta = "Pending";
            });
          }

          if (data['status'].toString().toLowerCase() == "failure") {
            setState(() {
              msg = "Transaction is failure";
              sta = "Failure";
            });
          }

          printMessage(screen, "Check Status : $sta");
          printMessage(screen, "Check msg : $msg");

          Map map = {
            "txStatus": "$status",
            "orderAmount": "$pgAmt",
            "paymentMode": "$pgMode",
            "orderId": "$pgTxn",
            "txTime": "$pgTxTime",
            "txMsg": "$msg",
            "type": "$pgType",
            "referenceId": "$pgRefId",
            "signature": "$pgSign"
          };
          openPaymentFailure(context, map);
          // showToastMessage(data['message'].toString());
        }
      });
    } else {
      Navigator.pop(context);
      showToastMessage(status500);
    }
  }

  getUPIAppNames(result, orderId, difAmt, token, rechAmt) async {
    String orderNote = "Order Note";

    if (result.length == 0) {
      showToastMessage("$noUPIapp");
    } else {
      List<UPIList> list = [];

      setState(() {
        noOfUPI = result.length;
      });

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
          verifySignatureByUPIWallet(value, rechAmt);
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

  paymentByPGDirect(orderId, amount) async {
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
          verifySignatureByPG(value);
        });
        printMessage(screen, "Final result : $value");
      });
    }

    if (isUPIOpen) {
      CashfreePGSDK.getUPIApps().then((value) {
        setState(() {
          getUPIAppNamesUPI(value, orderId, difAmt, token);
        });
      });
    }
  }

  calculateWelcomeAMt(amt) {
    printMessage(screen, "welcomeAMT : $amt");
    if (welcomeAMT != 0) {
      double v1 = 1.1;
      double v2 = double.parse(amt);
      double v3 = 100;

      double v4 = (v2 / v3) * v1;

      if (v4 > 30) {
        welcomeCharge = 30.0;
      } else {
        welcomeCharge = v4;
      }
      printMessage(screen, "v4 : ${formatNow.format(v4)}");
      printMessage(
          screen, "welcomeCharge : ${formatNow.format(welcomeCharge)}");
    }
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
              width: 15,
            ),
            Image.asset(
              'assets/offer_icon.png',
              height: 24,
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              "Welcome offer applied",
              style: TextStyle(color: black, fontSize: font14),
            ),
            Spacer(),
            Text(
              "$rupeeSymbol ${formatNow.format(welcomeCharge)}",
              style: TextStyle(color: green, fontSize: font14),
            ),
            SizedBox(
              width: 15,
            ),
          ],
        ),
      ),
    );
  }

  getUPIAppNamesUPI(result, orderId, difAmt, token) async {
    String orderNote = "Order Note";

    if (result.length == 0) {
      showToastMessage("$noUPIapp");
    } else {
      List<UPIList> list = [];

      setState(() {
        noOfUPI = result.length;
      });

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
          verifySignatureByPG(value);
        });
        printMessage(screen, "doUPIPayment result : $value");
      });
    }
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

    // Navigator.pop(context);

    if (responsePG['txStatus'].toString() == "SUCCESS") {
      printMessage(screen, "Transaction is Successful");
      setState(() {
        paymentStatusDirectPG(orderAmount, orderAmount, orderId, paymentMode,
            txTime, signature, txStatus, referenceId, txMsg, type);
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
}
