import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';

class AppWallet extends StatefulWidget {
  const AppWallet({Key? key}) : super(key: key);

  @override
  _AppWalletState createState() => _AppWalletState();
}

class _AppWalletState extends State<AppWallet> {
  var screen = "MoneyPro Wallet";

  var loading = false;

  var walletBalnc;
  var upiQRBalnc;

  var role = "";

  var approved = "";

  @override
  void initState() {
    super.initState();
    updateWalletBalances();
    updateATMStatus(context);
    fetchUserAccountBalance();
  }

  updateWalletBalances() async {
    var r = await getRole();
    var app = await getApproved();
    setState(() {
      role = r;
      approved = app;
    });

    walletBalnc = await getWalletBalance();
    upiQRBalnc = await getQRBalance();
    var walBalc = await getWelcomeAmt();


    printMessage(screen, "upiQRBalnc :$upiQRBalnc");

    double mX = 0.0;
    double wX = 0.0;

    final inheritedWidget = StateContainer.of(context);

    if (walletBalnc == null || walletBalnc == 0) {
      walletBalnc = 0;
      inheritedWidget.updateMPBalc(value: walletBalnc);
    } else {
      inheritedWidget.updateMPBalc(value: walletBalnc);
    }

    if (upiQRBalnc == null || upiQRBalnc == 0) {
      upiQRBalnc = 0;
      inheritedWidget.updateQRBalc(value: upiQRBalnc);
    } else {
      inheritedWidget.updateQRBalc(value: upiQRBalnc);
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

    if (walletBalnc != null || walletBalnc != 0) {
      mX = double.parse(walletBalnc);
    }
    setState(() {
      var mWlet = wX + mX;
      walletBalnc = formatDecimal2Digit.format(mWlet);
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
                          height: 20.h,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              titleSpacing: 0,
              title: appLogo(),
              actions: [
                InkWell(
                  onTap: () {},
                  child: Image.asset(
                    'assets/faq.png',
                    width: 30.w,
                    color: orange,
                  ),
                ),
                SizedBox(
                  width: 15.w,
                )
              ],
            ),
            body: (loading)
                ? circularProgressLoading(40.0)
                : SingleChildScrollView(
                  child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        (role.toString() == "3")
                            ? Container(
                                margin: EdgeInsets.all(15),
                                decoration: BoxDecoration(
                                  color: dividerSplash,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 15, top: 10, bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                          height: 45.h,
                                          width: 45.w,
                                          decoration: BoxDecoration(
                                            color: lightBlue, // border color
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: Image.asset(
                                              'assets/wallet_white.png',
                                            ),
                                          )),
                                      SizedBox(
                                        width: 15.w,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "$rupeeSymbol $upiQRBalnc",
                                            style: TextStyle(
                                                color: black,
                                                fontWeight: FontWeight.bold,
                                                fontSize: 24.sp),
                                          ),
                                          Text(
                                            "$upiQRWallet",
                                            style: TextStyle(
                                                color: black, fontSize: font15.sp),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              )
                            : Container(),
                        Container(
                          margin: EdgeInsets.only(left: 15, right: 15),
                          decoration: BoxDecoration(
                            color: dividerSplash,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, right: 15, top: 10, bottom: 10),
                            child: Row(
                              children: [
                                Container(
                                    height: 45.h,
                                    width: 45.w,
                                    decoration: BoxDecoration(
                                      color: lightBlue, // border color
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Image.asset(
                                        'assets/wallet_white.png',
                                      ),
                                    )),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Expanded(
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      //"$rupeeSymbol ${formatDecimal2Digit.format((walletBalnc))}",
                                      "$rupeeSymbol $walletBalnc",
                                      style: TextStyle(
                                          color: black,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 24.sp),
                                    ),
                                    Text(
                                      "$wallet",
                                      style: TextStyle(
                                          color: black, fontSize: font15.sp),
                                    ),
                                  ],
                                )),
                                Container(
                                  decoration: BoxDecoration(
                                      color: orange,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      border: Border.all(color: orange)),
                                  child: InkWell(
                                    onTap: () {
                                      openAddMoneyToWallet(context);
                                    },
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 15,
                                            top: 6,
                                            bottom: 6),
                                        child: Text(
                                          "$addMoney",
                                          style: TextStyle(
                                            color: white,
                                            fontSize: font14.sp,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        _buildTabSection(),
                        Container(
                          margin:
                              EdgeInsets.only(left: 15, right: 15, bottom: 10,top: 10),
                          child: Image.asset(
                            'assets/wallet_banner.png',
                          ),
                        )
                      ],
                    ),
                ))));
  }

  _buildTabSection() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(
                          color: lightBlue,
                        )),
                    width: MediaQuery.of(context).size.width,
                    child: Center(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                              height: 50.h,
                              width: 50.w,
                              decoration: BoxDecoration(
                                color: white, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Image.asset(
                                  'assets/wallet_histry.png',
                                ),
                              )),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(walletHistory,
                              style: TextStyle(
                                  color: white,
                                  fontSize: font15.sp,
                                  fontWeight: FontWeight.bold)),
                          SizedBox(
                            height: 4.h,
                          ),
                          Text(viewWalletTrnx,
                              style: TextStyle(color: white, fontSize: font12.sp)),
                          SizedBox(
                            height: 15.h,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (role.toString() == "3") {
                        openTransactionHistory(context,"","");
                      } else {
                        openTransactionHistoryEmpUser(context);
                      }
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            color: lightBlue,
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: white, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/wallet_blue.png',
                                  ),
                                )),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(walletSummary,
                                style: TextStyle(
                                    color: white,
                                    fontSize: font15.sp,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(viewSummaryWallet,
                                style:
                                    TextStyle(color: white, fontSize: font12.sp)),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 15.h,
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: (){
                   // openReferNEarn(context);
                  },
                  child: Card(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            color: lightBlue,
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: white, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/opts.png',
                                  ),
                                )),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(opts,
                                style: TextStyle(
                                    color: white,
                                    fontSize: font15.sp,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(loyaltyPoints,
                                style: TextStyle(color: white, fontSize: font12.sp)),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      if (approved.toString() != "1") {
                        showToastMessage(notApproved);
                        return;
                      }
                      openAddMoneyToBank(context);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(
                            color: lightBlue,
                          )),
                      width: MediaQuery.of(context).size.width,
                      child: Center(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 15.h,
                            ),
                            Container(
                                height: 50.h,
                                width: 50.w,
                                decoration: BoxDecoration(
                                  color: white, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Image.asset(
                                    'assets/bank.png',
                                  ),
                                )),
                            SizedBox(
                              height: 5.h,
                            ),
                            Text(moveToBank,
                                style: TextStyle(
                                    color: white,
                                    fontSize: font15.sp,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(
                              height: 4.h,
                            ),
                            Text(transferFundBank,
                                style:
                                    TextStyle(color: white, fontSize: font12.sp)),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
