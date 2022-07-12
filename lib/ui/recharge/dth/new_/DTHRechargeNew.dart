import 'dart:math';

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/UPIList.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';

class DTHRechargeNew extends StatefulWidget {
  final Map map;
  const DTHRechargeNew({Key? key, required this.map}) : super(key: key);

  @override
  _DTHRechargeNewState createState() => _DTHRechargeNewState();
}

class _DTHRechargeNewState extends State<DTHRechargeNew> {
  var screen = "DTH Recharge New";

  var loading = false;

  TextEditingController mobileController = new TextEditingController();

  TextEditingController amountController = new TextEditingController();

  var showDetails = false;

  String moneyProBalc = "0";

  var vc;

  var checkedValue = false;

  double remainAmt = 0;

  final cardController = TextEditingController();
  final cardHolderNameController = TextEditingController();
  final cardMMController = TextEditingController();
  final cardYYController = TextEditingController();
  final cardCVVController = TextEditingController();

  FocusNode nodeMM = FocusNode();
  FocusNode nodeYY = FocusNode();
  FocusNode nodeCVV = FocusNode();

  var isCardOpen = false;
  var isUPIOpen = false;

  double cardCharge = 0.0;
  double welcomeCharge = 0.0;
  var welcomeAMT = "";
  var isWelcomeOffer = false;

  dynamic currentTime;

  int noOfUPI = 0;
  int upiIndex = 0;
  var upiId = "";

  var isError = false;
  var isWallMore = false;

  var inputNo;

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

  var MonthlyRecharge;
  var Balance;
  var customerName;
  var status;
  var NextRechargeDate;
  var lastrechargeamount;
  var lastrechargedate;
  var planname;
  var minLimit;

  var jwtToken = "";
  var mainWallet;

  @override
  void initState() {
    super.initState();

    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();

    printMessage(screen, "ICON : ${widget.map}");

    setState(() {
      inputNo = "${widget.map['inputNo']}";
    });

    if (inputNo.toString() != "") {
      mobileController = TextEditingController(text: "${inputNo.toString()}");
    }

    setState(() {
      currentYear = yearFormat.format(currentDate);
      timeH = timeFormat.format(currentDate);
      cDate = dateFormat.format(currentDate);

      currentYear = currentYear[3];
    });

    setState(() {
      minLimit = widget.map['minLimit'];
      finalString = "${getRandomString(27)}$currentYear$cDate$timeH";
    });

    printMessage(screen, "Final String : $finalString");
  }

  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();
    double mX = 0.0;
    double wX = 0.0;

    setState(() {
      moneyProBalc = mpBalc;
      mainWallet = mpBalc;
      if (moneyProBalc.toString() == "") {
        moneyProBalc = "0.0";
      }
    });

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
      welcomeAMT = walBalc;
      var x = double.parse(moneyProBalc) + double.parse(welcomeAMT);
      moneyProBalc = formatDecimal2Digit.format(x);
      ;
    });
  }

  @override
  void dispose() {
    mobileController.dispose();
    amountController.dispose();
    super.dispose();
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
                  : SingleChildScrollView(
                      child: Column(
                        children: [
                          appSelectedBanner(
                              context, "recharge_banner.png", 150.0.h),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: 30.0, left: 25, right: 25),
                            child: Row(
                              children: [
                                SizedBox(
                                  child: Image.network(
                                    "$billerIconUrl${widget.map['billerImg']}",
                                    width: 24.w,
                                  ),
                                  width: 24.w,
                                  height: 24.h,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.map['billerName']}",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: font16.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${widget.map['stateName']}",
                                        style: TextStyle(
                                            color: lightBlue,
                                            fontSize: font13.sp),
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                                    style: TextStyle(
                                        color: black, fontSize: font14.sp),
                                  )
                                ],
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
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 10, bottom: 10),
                              child: TextFormField(
                                style: TextStyle(
                                    color: black,
                                    fontSize: inputFont.sp,
                                    fontWeight: FontWeight.bold),
                                keyboardType: TextInputType.number,
                                textInputAction: TextInputAction.done,
                                textCapitalization:
                                    TextCapitalization.characters,
                                controller: mobileController,
                                decoration: new InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 10),
                                  counterText: "",
                                  label: Text("DTH number "),
                                ),
                                maxLength: 20,
                              ),
                            ),
                          ),
                          (showDetails) ? _buildPayDetails() : Container()
                        ],
                      ),
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
                                var number = mobileController.text.toString();
                                if (number.length == 0) {
                                  showToastMessage(
                                      "Enter the mobile no/DTH number");
                                  return;
                                }

                                var dishOperator =
                                    widget.map['billerName'].toString();
                                var dishCode = "";

                                printMessage(screen, "DTH number : $number");
                                printMessage(
                                    screen, "DTH Code : $dishOperator");

                                //getDTHDetails(number, dishCode);

                                if (dishOperator.toString().toString() ==
                                    "Airtel Digital TV") {
                                  setState(() {
                                    dishCode = "Airteldth";
                                  });
                                } else if (dishOperator.toString().toString() ==
                                    "Dish TV") {
                                  setState(() {
                                    dishCode = "Dishtv";
                                  });
                                } else if (dishOperator.toString().toString() ==
                                    "Sun Direct") {
                                  setState(() {
                                    dishCode = "Sundirect";
                                  });
                                } else if (dishOperator.toString().toString() ==
                                    "Tata Play") {
                                  setState(() {
                                    dishCode = "TataSky";
                                  });
                                } else if (dishOperator.toString().toString() ==
                                    "d2h") {
                                  setState(() {
                                    dishCode = "Videocon";
                                  });
                                }

                                closeKeyBoard(context);

                                generateJWTToken(number, dishCode, 1);
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

  _buildPayDetails() {
    return Column(
      children: [
        (isError)
            ? Container()
            : Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 30.0, right: 30, left: 30),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Name",
                            style: TextStyle(
                                color: lightBlack, fontSize: font13.sp),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "$customerName",
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
                        const EdgeInsets.only(top: 20.0, right: 30, left: 30),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "Balance",
                            style: TextStyle(
                                color: lightBlack, fontSize: font13.sp),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            "$rupeeSymbol $Balance",
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
                  (NextRechargeDate.toString() == "")
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Next Recharge Date",
                                  style: TextStyle(
                                      color: lightBlack, fontSize: font13.sp),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "$NextRechargeDate",
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
                  (MonthlyRecharge.toString() == "")
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Monthly Recharge",
                                  style: TextStyle(
                                      color: lightBlack, fontSize: font13.sp),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "$rupeeSymbol $MonthlyRecharge",
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
                  (planname.toString() == "")
                      ? Container()
                      : Padding(
                          padding: const EdgeInsets.only(
                              top: 20.0, right: 30, left: 30, bottom: 15),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "Plan", //wb26k2153
                                  style: TextStyle(
                                      color: lightBlack, fontSize: font13.sp),
                                ),
                              ),
                              Expanded(
                                flex: 2,
                                child: Text(
                                  "$planname",
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
                ],
              ),
        Container(
          margin: EdgeInsets.only(
            top: 15,
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
              //enabled: false,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              controller: amountController,
              decoration: new InputDecoration(
                isDense: true,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                label: Text("Amount"),
              ),
              maxLength: 6,
              onChanged: (val) {
                if (val.length != 0) {
                  double xx = double.parse(val);

                  setState(() {
                    if (welcomeAMT.toString() == "null" ||
                        welcomeAMT.toString() == "0" ||
                        welcomeAMT.toString() == "") {
                      isWelcomeOffer = false;
                    } else {
                      if (xx > 300) {
                        isWelcomeOffer = true;
                        calculateWelcomeAMt(val.toString());
                      } else {
                        isWelcomeOffer = false;
                      }
                    }
                  });
                }
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "Min recharge amount is $rupeeSymbol $minLimit",
            style: TextStyle(color: lightBlack, fontSize: font12.sp),
            textAlign: TextAlign.center,
          ),
        ),
        (isWelcomeOffer) ? _buildOfferRwo() : Container(),
        Divider(),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, right: 30, left: 30),
          child: Text(
            billMsg,
            style: TextStyle(color: lightBlack, fontSize: font14.sp),
          ),
        ),
        (mainWallet.toString() == "0" ||
                mainWallet.toString() == "0.0" ||
                mainWallet.toString() == "null")
            ? Container()
            : Padding(
                padding: const EdgeInsets.only(top: 15.0, right: 30, left: 30),
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

                                var rechargeAmount =
                                    amountController.text.toString();

                                setState(() {
                                  if (mpBalc.toString() == "") {
                                    walletValue = 0;
                                  } else {
                                    walletValue = double.parse(moneyProBalc);
                                  }

                                  if (rechargeAmount.toString() == "") {
                                    rechargeValue = 0;
                                  } else {
                                    rechargeValue =
                                        double.parse(rechargeAmount);
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
                          style: TextStyle(fontSize: font14.sp, color: black),
                        ),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                              color: walletBg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
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
                                        left: 8.0, right: 8, top: 5),
                                    child: Text(
                                      //  "${formatDecimal2Digit.format(double.parse(moneyProBalc))}",
                                      "$moneyProBalc",
                                      style: TextStyle(
                                          color: white, fontSize: font15.sp),
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
                              style:
                                  TextStyle(color: black, fontSize: font14.sp),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
        _buildUPISection(),
        _buildCardSection(),
      ],
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
              var mpBalc = await getWalletBalance();
              setState(() {});

              double walletValue = 0;
              double rechargeValue = 0;

              var rechargeAmount = amountController.text.toString();

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

              if (minLimit.toString() != "null" && minLimit.toString() != "") {
                double minDb = double.parse(minLimit);
                if (rechargeValue < minDb) {
                  showToastMessage(
                      "Minimum recharge is $rupeeSymbol ${widget.map['minLimit']}");
                  return;
                }
              }

              if (checkedValue) {
                if (walletValue >= rechargeValue) {
                  setState(() {
                    isWallMore = true;
                  });
                  var id = DateTime.now().millisecondsSinceEpoch;

                  var number = mobileController.text.toString();
                  generateJWTToken(number, formatNow.format(rechargeValue), 2);
                } else {
                  if (isCardOpen) {
                    setState(() {
                      isWallMore = false;
                    });
                    var cardNo = cardController.text.toString();
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

                    generateJWTTokenWPG(
                        id, formatNow.format(remainAmt), rechargeAmount);
                  } else {
                    showToastMessage("Select any one payment method");
                  }
                }
              } else {
                printMessage(screen, "Check card Open : $isCardOpen");
                if (isCardOpen) {
                  var id = DateTime.now().millisecondsSinceEpoch;
                  if (isWelcomeOffer) {
                    rechargeValue = rechargeValue - welcomeCharge;
                  }
                  setState(() {
                    isWallMore = false;
                  });

                  rechargeValue = rechargeValue + cardCharge;

                  generateJWTTokenPG(id, formatNow.format(rechargeValue));
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

  Future generateJWTToken(dthNo, dthName, action) async {
    print(dthNo);
    print(dthName);
    print(action);
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
      Navigator.pop(context);
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          var jwtToken = data['token'].toString();
          if (action == 1) {
            getDTHDetailsInfo(jwtToken, dthNo, dthName);
          }
          if (action == 2) {
            paymentStatusByWalletOnly(jwtToken, dthName);
          }
        } else {
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  Future generateJWTTokenWPG(id, remainAmt, rechargeAmount) async {
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
      Navigator.pop(context);
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          jwtToken = data['token'].toString();
          paymentByUPIWallet(id, remainAmt, rechargeAmount);
        } else {
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  Future generateJWTTokenPG(id, rechargeValue) async {
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
      Navigator.pop(context);
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          jwtToken = data['token'].toString();
          paymentByPGDirect(id, rechargeValue);
        } else {
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  getDTHDetailsInfo(jwtToken, dthNo, dthName) async {
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

    var body = {
      "user_token": "$userToken",
      "token": "$jwtToken",
      "canumber": "$dthNo",
      "op": "$dthName",
    };

    printMessage(screen, "Body : $body");

    final response = await http.post(Uri.parse(dthInfoAPI),
        headers: headers, body: jsonEncode(body));

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response DTH : ${data}");

      setState(() {
        Navigator.pop(context);

        var status = data['status'].toString();

        if (status.toString() == "1") {
          if (data['data']['status'].toString() == "true") {
            MonthlyRecharge = data['data']['info'][0]['MonthlyRecharge'];
            Balance = data['data']['info'][0]['Balance'];
            customerName = data['data']['info'][0]['customerName'];
            status = data['data']['info'][0]['status'];
            NextRechargeDate = data['data']['info'][0]['NextRechargeDate'];
            lastrechargeamount = data['data']['info'][0]['lastrechargeamount'];
            lastrechargedate = data['data']['info'][0]['lastrechargedate'];
            planname = data['data']['info'][0]['planname'];

            amountController =
                TextEditingController(text: "${MonthlyRecharge.toString()}");
          }

          setState(() {
            showDetails = true;
            isError = false;
          });

          /*vc = data['DATA']['VC'];
        Name = data['DATA']['Name'];
        Rmn = data['DATA']['Rmn'];
        Balance = data['DATA']['Balance'];
        Monthly = data['DATA']['Monthly'];
        nextDate = data['DATA']['Next Recharge Date'];
        Plan = data['DATA']['Plan'];
        Address = data['DATA']['Address'];
        City = data['DATA']['City'];
        District = data['DATA']['District'];
        State = data['DATA']['State'];
        pinCode = data['DATA']['PIN Code'];*/
        } else {
          setState(() {
            showDetails = false;
            isError = true;
          });
          showToastMessage(data['Message'].toString());
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
        showDetails = false;
        isError = true;
      });
      showToastMessage(status500);
    }
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

            var amt = amountController.text.toString();

            if (amt.toString() == "") {
              showToastMessage("enter the amount");
              return;
            } else {
              rechargeValue = double.parse(amt);
            }

            if (minLimit.toString() != "null" && minLimit.toString() != "") {
              double minDb = double.parse(minLimit);
              if (rechargeValue < minDb) {
                showToastMessage(
                    "Minimum recharge is $rupeeSymbol ${widget.map['minLimit']}");
                return;
              }
            }

            /* if(maxLimit.toString()!="null" && maxLimit.toString()!=""){
              double maxDb = double.parse(maxLimit);
              if(rechargeValue>maxDb){
                showToastMessage("Maximum recharge is $rupeeSymbol ${widget.map['maxLimit']}");
                return;
              }
            }*/

            if (checkedValue) {
              if (walletValue >= rechargeValue) {
                setState(() {
                  isWallMore = true;
                });
                var id = DateTime.now().millisecondsSinceEpoch;
                // paymentStatusByWalletOnly(id, formatNow.format(rechargeValue));
                var number = mobileController.text.toString();
                generateJWTToken(number, formatNow.format(rechargeValue), 2);
              } else {
                if (isUPIOpen) {
                  setState(() {
                    remainAmt = rechargeValue - walletValue;
                  });

                  if (isWelcomeOffer) {
                    remainAmt = remainAmt - welcomeCharge;
                  }
                  setState(() {
                    isWallMore = false;
                  });

                  var id = DateTime.now().millisecondsSinceEpoch;
                  //paymentByUPIWallet(id, formatNow.format(remainAmt), formatNow.format(rechargeValue));
                  generateJWTTokenWPG(id, formatNow.format(remainAmt),
                      formatNow.format(rechargeValue));
                } else {
                  showToastMessage("Select any one payment method");
                }
              }
            } else {
              if (isUPIOpen) {
                var id = DateTime.now().millisecondsSinceEpoch;
                setState(() {
                  isWallMore = false;
                });
                if (isWelcomeOffer) {
                  rechargeValue = rechargeValue - welcomeCharge;
                }

                //paymentByPGDirect(id, formatNow.format(rechargeValue));
                generateJWTTokenPG(id, formatNow.format(rechargeValue));
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

  Future paymentStatusByWalletOnly(jwtToken, rechargeAmt) async {
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
    double xAmt;
    var mBal = await getWalletBalance();

    var dthNo = mobileController.text.toString();

    var role = await getRole();

    if (role == "3") {
      mId = await getMerchantID();
    } else {
      mId = "";
    }

    var lat = await getLatitude();
    var long = await getLongitude();
    var amt = amountController.text.toString();

    if (isWallMore) {
      xAmt = double.parse(amt);
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
      /*"operator_code": "${widget.map['operatorSecCode']}",
      "param": "$number",
      "circle_code": "${widget.map['stateCode']}",
      "amount": "$amt",
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
      "welcome_amount":(isWelcomeOffer)?"${formatNow.format(welcomeCharge)}":"0",
      //"refId":"$finalString"*/

      "user_token": "$token",
      // "token":"$jwtToken",
      "spkey": "${widget.map['billerId']}",
      "operator_code": "${widget.map['billerId']}",
      "mobile": "$dthNo",
      "amount": "$amt",
      "wallet": "$xAmt",
      "category": "${widget.map['billerName']}", //operator name
      //"operator_name":"${widget.map['operatorName']}",
      "operator_name": "PREPAID",
      //"circle":"${widget.map['circleName']}",
      "circle": "WB",
      "welcome_amount":
          (isWelcomeOffer) ? "${formatNow.format(welcomeCharge)}" : "0",
      "lat": "${lat.toStringAsFixed(4)}",
      "long": "${long.toStringAsFixed(4)}",
      "m_id": "$mId",
      "paymentgateway_amount": "0",
      // "paymentgateway_orderId":"",
      "paymentgateway_txn": "",
      "paymentgateway_mode": "",
      "txTime": "",
      "signature": "",
      "txStatus": "",
      "referenceId": ""
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(doRechargeinstantPay),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response paymentStatusUpdate : $data");

      setState(() {
        var status = data['status'].toString();
        if (status.toLowerCase() == "success" || status.toLowerCase() == "1") {
          Navigator.pop(context);
          showToastMessage(data['response']['status'].toString());

          var tId = data['response']['data']['ipay_id'].toString();
          var commission = data['commission'].toString();
          Map map = {
            "tId": "$tId",
            "TxStatus": "Success",
            "orderAmount": "$rechargeAmt",
            "paymentMode": "MoneyPro Wallet",
            "orderId": "",
            "txTime": "$currentTime",
            "txMsg": "Transaction is successfull",
            "type": "MoneyPro Wallet",
            "referenceId": "${data['response']['data']['orderid']}",
            "signature": "",
            "operatorName": "${widget.map['operatorName']}",
            "mobile": "${widget.map['mobile']}",
            "commission": "$commission"
          };
          openMobileReceipt(context, map, true);
          //}

        } else if (status.toString() == "2") {
          Navigator.pop(context);
          showToastMessage(data['response']['status'].toString());
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
            "referenceId": "${data['response']['data']['orderid']}",
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
      var cardNo = cardController.text.toString();
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

    if (responsePG['txStatus'].toString().toUpperCase() == "SUCCESS" ||
        responsePG['txStatus'].toString().toUpperCase() == "TRUE" ||
        responsePG['txStatus'].toString() == "1") {
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

  verifySignature(responsePG) async {
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

    /*if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "orderId": "$orderId",
        "orderAmount": "$orderAmount",
        "referenceId": "$referenceId",
        "txStatus": "$txStatus",
        "paymentMode": "$paymentMode",
        "txMsg": "$txMsg}",
        "txTime": "$txTime}",
      };

      String result = await platform.invokeMethod("verifySign", arr);
      //var json = jsonDecode(result);

      printMessage(screen, "Mobile json : $result");
    }*/

    Navigator.pop(context);

    if (responsePG['txStatus'].toString().toUpperCase() == "SUCCESS" ||
        responsePG['txStatus'].toString().toUpperCase() == "TRUE" ||
        responsePG['txStatus'].toString() == "1") {
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

    var dthNo = mobileController.text.toString();

    var role = await getRole();

    if (role == "3") {
      mId = await getMerchantID();
    } else {
      mId = "";
    }
    var lat = await getLatitude();
    var long = await getLongitude();
    var amt = amountController.text.toString();

    var number = mobileController.text.toString();

    if (isWallMore) {
      xAmt = double.parse(amt);
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
      /*"operator_code": "${widget.map['operatorSecCode']}",
      //"param": "${widget.map['mobileNo']}",
      "param":"$number",
      "circle_code": "${widget.map['stateCode']}",
      "amount": "$amt",
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
      "welcome_amount":(isWelcomeOffer)?"${formatNow.format(welcomeCharge)}":"0",
      //"refId":"$finalString"*/

      "user_token": "$token",
      "spkey": "${widget.map['billerId']}",
      // "token": "$jwtToken",
      "operator_code": "${widget.map['billerId']}",
      "mobile": "$dthNo",
      "amount": "$amt",
      "wallet": "$xAmt",
      "category": "${widget.map['billerName']}", //operator name
      //"operator_name":"${widget.map['operatorName']}",
      "operator_name": "PREPAID",
      //"circle":"${widget.map['circleName']}",
      "circle": "WB",
      "welcome_amount":
          (isWelcomeOffer) ? "${formatNow.format(welcomeCharge)}" : "0",
      "lat": "${lat.toStringAsFixed(4)}",
      "long": "${long.toStringAsFixed(4)}",
      "m_id": "$mId",
      "paymentgateway_amount": "$pgAmt",
      // "paymentgateway_orderId":"$pgTxn",
      "paymentgateway_txn": "$pgTxn",
      "paymentgateway_mode": "$pgMode",
      "txTime": "$pgTxTime",
      "signature": "$pgSign",
      "txStatus": "$pgTxStatus",
      "referenceId": "$pgRefId"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(doRechargeinstantPay),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    printMessage(screen, "Response statusCode : $statusCode");

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response paymentStatusUpdate : $data");

      setState(() {
        var status = data['status'].toString();
        if (status.toLowerCase() == "success" || status.toString() == "1") {
          Navigator.pop(context);
          showToastMessage(data['message'].toString());
          var tId = data['transction_id'].toString();
          var commission = data['commission'].toString();
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
          showToastMessage(data['response']['status'].toString());
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
      var cardNo = cardController.text.toString();
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
          verifySignature(value);
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

  calculateWelcomeAMt(amt) {
    printMessage(screen, "welcomeAMT : $amt");
    if (welcomeAMT != "") {
      double v1 = 1.2;
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
              width: 15.w,
            ),
            Image.asset('assets/offer_icon.png', height: 24.h),
            SizedBox(
              width: 10.w,
            ),
            Text(
              "Welcome offer applied",
              style: TextStyle(color: black, fontSize: font14.sp),
            ),
            Spacer(),
            Text(
              "$rupeeSymbol ${formatNow.format(welcomeCharge)}",
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
}
