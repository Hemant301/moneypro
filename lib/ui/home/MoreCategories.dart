import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';

class MoreCategories extends StatefulWidget {
  final double lat, lng;

  const MoreCategories({Key? key, required this.lat, required this.lng})
      : super(key: key);

  @override
  _MoreCategoriesState createState() => _MoreCategoriesState();
}

class _MoreCategoriesState extends State<MoreCategories>
    with SingleTickerProviderStateMixin {
  var screen = "More Categories";

  var role;

  double updateLat = 0.0;
  double updateLng = 0.0;

  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();

    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);

    setState(() {
      updateLat = widget.lat;
      updateLng = widget.lng;
    });
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();
    var rl = await getRole();
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
      role = rl;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
                    Image.asset(
                      'assets/bbps_2.png',
                      width: 24.w,
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                body: Column(
                  children: [
                    appSelectedBanner(context, "recharge_banner.png", 150.0.h),
                    Expanded(
                        child: Container(
                      margin: EdgeInsets.only(top: 20),
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height,
                      decoration: BoxDecoration(
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
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Center(
                            child: Container(
                              color: gray,
                              width: 50.w,
                              height: 5.h,
                            ),
                          ),
                          SizedBox(
                            height: 15.h,
                          ),
                          Expanded(
                            flex: 1,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  _buildRechargeTabs(),
                                  _buildBillPayment(),
                                  (role == "3")
                                      ? _buildFinancialServices()
                                      : (role == "2")
                                          ? _buildFinancialEmpServices()
                                          : _buildFinancialUserServices(),
                                  _buildCardPurchage(),
                                  _buildRentFees(),
                                  _buildTaxServices(),
                                  _buildTravelServices(),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ))
                  ],
                ))));
  }

  _buildRechargeTabs() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: bankBox)),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20.0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Padding(
              padding: const EdgeInsets.only(left: 20.0, top: 15),
              child: Text(
                "Recharge",
                style: TextStyle(
                    color: black,
                    fontSize: font15.sp,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openMobileSelection(context, "");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, right: 3, top: 1, bottom: 1),
                              child: Text(
                                "10% Cashback",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                              height: 45.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/cell_phone.png',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Text(
                                mobilePrepaid,
                                style: TextStyle(
                                    color: black, fontSize: font11.sp),
                                textAlign: TextAlign.center,
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openDTHSelection(
                            context, "DTH", "DTH operator", "DTH Operator");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                              height: 45.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/dth.png',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FittedBox(
                              fit: BoxFit.cover,
                              child: Text(
                                dth,
                                style: TextStyle(
                                    color: black, fontSize: font11.sp),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "FASTAG", "Bank", "Bank");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, right: 3, top: 1, bottom: 1),
                              child: Text(
                                "New",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                              height: 45.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/toll.png',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  fasttag,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                )),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "CABLE", "operator", "Operator");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 30.h,
                          ),
                          Container(
                              height: 45.h,
                              width: 45.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/cabletv.png',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  cableTV,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            InkWell(
              onTap: () {
                openAllOffers(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ColoredBox(
                  color: Colors.blueAccent.withOpacity(1),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 20.0, right: 20, top: 6, bottom: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "$rechTag",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.start,
                          style: TextStyle(color: white, fontSize: font12.sp),
                        ),
                        Icon(
                          Icons.arrow_forward_ios,
                          color: white,
                          size: 12,
                        )
                      ],
                    ),
                  ),
                ),
              ),
            )
          ]),
        ));
  }

  _buildBillPayment() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: bankBox)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20),
                child: Text(
                  "Bill Payments",
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          openRechargeSelection(context, "MOBILE POSTPAID",
                              "operator", "operator");
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: boxBg, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/bill.png',
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    mobilePostpaid,
                                    style: TextStyle(
                                        color: black, fontSize: font11.sp),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          openRechargeSelection(context, "BROADBAND POSTPAID",
                              "Operator", "Operator");
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: boxBg, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/broadband.png',
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    broadband,
                                    style: TextStyle(
                                        color: black, fontSize: font11.sp),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          openRechargeSelection(context, "LANDLINE POSTPAID",
                              "operator", "Operator");
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: boxBg, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/landline.png',
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    landline,
                                    style: TextStyle(
                                        color: black, fontSize: font11.sp),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          openRechargeSelection(context, "ELECTRICITY",
                              "electricity board", "Electricity board");
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: boxBg, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/electricity.png',
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    electricity,
                                    style: TextStyle(
                                        color: black, fontSize: font11.sp),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          openRechargeSelection(
                              context, "LPG GAS", "Agency", "Agency");
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: boxBg, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/gas_tank.png',
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    "LPG GAS",
                                    style: TextStyle(
                                        color: black, fontSize: font11.sp),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          openRechargeSelection(
                              context, "GAS", "agency", "Agency");
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: boxBg, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/lpg.png',
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    "Pipe GAS",
                                    style: TextStyle(
                                        color: black, fontSize: font11.sp),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          openRechargeSelection(
                              context, "WATER", "board", "Board");
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 25.h,
                            ),
                            Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: boxBg, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/water.png',
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    waterBill,
                                    style: TextStyle(
                                        color: black, fontSize: font11.sp),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          openRechargeSelection(
                              context, "CREDIT CARD", "company", "Company");
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 5.h,
                            ),
                            Container(
                              color: Colors.yellow,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 3.0, right: 3, top: 1, bottom: 1),
                                child: Text(
                                  "Zero Surcharge",
                                  style: TextStyle(
                                      color: black, fontSize: font10.sp),
                                  maxLines: 1,
                                ),
                              ),
                            ),
                            SizedBox(
                              height: 5.h,
                            ),
                            Container(
                                height: 40.h,
                                width: 40.w,
                                decoration: BoxDecoration(
                                  color: boxBg, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/credit_cardnew.png',
                                  ),
                                )),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: FittedBox(
                                  fit: BoxFit.cover,
                                  child: Text(
                                    "Credit Card",
                                    style: TextStyle(
                                        color: black, fontSize: font11.sp),
                                    textAlign: TextAlign.center,
                                  )),
                            ),
                            SizedBox(
                              height: 15.h,
                            ),
                          ],
                        ),
                      )),
                ],
              ),
              InkWell(
                onTap: () {
                  //openAllOffers(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ColoredBox(
                    color: Colors.blueAccent.withOpacity(1),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, top: 6, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$rechTag",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start, 
                            style: TextStyle(color: white, fontSize: font12.sp),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: white,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ])));
  }

  _buildFinancialServices() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: bankBox)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 10),
                child: Text(
                  "Financial Services",
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openLICDetails(context);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, right: 3, top: 1, bottom: 1),
                              child: Text(
                                "New",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Image.asset(
                                    'assets/lic_new.png',
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "LIC",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "INSURANCE", "Company", "Company");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/insurancenew.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Insurance",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (role.toString() == "3") {
                          openPancardLanding(context);
                        } else {
                          showToastMessage("$youNotAuthorize");
                        }
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, right: 3, top: 1, bottom: 1),
                              child: Text(
                                "New",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.asset(
                                    'assets/pancard.png',
                                    color: lightBlue,
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "PAN card",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "LOAN", "Company", "Company");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/applyloan.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Loan Repayment",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
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
                      onTap: () {
                        showToastMessage(comingSoon);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/applyloan.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  applyLoan,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        showToastMessage(comingSoon);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/giftcard.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  giftCard,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                  overflow: TextOverflow.ellipsis,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              InkWell(
                onTap: () {
                  //openAllOffers(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ColoredBox(
                    color: Colors.blueAccent.withOpacity(1),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 6, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$fintag",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: white, fontSize: font12.sp),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: white,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ])));
  }

  _buildFinancialUserServices() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: bankBox)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 10),
                child: Text(
                  "Financial Services",
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openLICDetails(context);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, right: 3, top: 1, bottom: 1),
                              child: Text(
                                "New",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Image.asset(
                                    'assets/lic_new.png',
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "LIC",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "INSURANCE", "Company", "Company");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/insurancenew.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Insurance",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "LOAN", "Company", "Company");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/applyloan.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Loan Repayment",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openAxisBankLanding(context);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, right: 3, top: 1, bottom: 1),
                              child: Text(
                                "New",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/axis_logo.png',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Axis Bank",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openUpStoxLanding(context);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, right: 3, top: 1, bottom: 1),
                              child: Text(
                                "New",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/upstox_logo.png',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Upstox Lead",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              InkWell(
                onTap: () {
                  //openAllOffers(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ColoredBox(
                    color: Colors.blueAccent.withOpacity(1),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 6, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$fintag",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: white, fontSize: font12.sp),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: white,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ])));
  }

  _buildFinancialEmpServices() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 20),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: bankBox)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 10),
                child: Text(
                  "Financial Services",
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openLICDetails(context);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, right: 3, top: 1, bottom: 1),
                              child: Text(
                                "New",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(13.0),
                                  child: Image.asset(
                                    'assets/lic_new.png',
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "LIC",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "INSURANCE", "Company", "Company");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/insurancenew.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Insurance",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (role.toString() == "3") {
                          openPancardLanding(context);
                        } else {
                          showToastMessage("$youNotAuthorize");
                        }
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, right: 3, top: 1, bottom: 1),
                              child: Text(
                                "New",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.asset(
                                    'assets/pancard.png',
                                    color: lightBlue,
                                  ),
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "PAN card",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "LOAN", "Company", "Company");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 15.h,
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/applyloan.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Loan Repayment",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openAxisBankLanding(context);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, right: 3, top: 1, bottom: 1),
                              child: Text(
                                "New",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/axis_logo.png',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Axis Bank",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openUpStoxLanding(context);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 5.h,
                          ),
                          Container(
                            color: Colors.yellow,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 3.0, right: 3, top: 1, bottom: 1),
                              child: Text(
                                "New",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                maxLines: 1,
                              ),
                            ),
                          ),
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/upstox_logo.png',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Upstox Lead",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
              InkWell(
                onTap: () {
                  //openAllOffers(context);
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ColoredBox(
                    color: Colors.blueAccent.withOpacity(1),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 20.0, right: 20, top: 6, bottom: 6),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "$fintag",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: white, fontSize: font12.sp),
                          ),
                          Icon(
                            Icons.arrow_forward_ios,
                            color: white,
                            size: 12,
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              )
            ])));
  }

  _buildCardPurchage() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: bankBox)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 10),
                child: Text(
                  "Cards & Purchase",
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        showToastMessage(comingSoon);
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/gift_card.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "Moneypro Gift Card",
                              style:
                                  TextStyle(color: black, fontSize: font11.sp),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        showToastMessage(somethingWrong);
                        // checkCardStatus();
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/debitcard.png',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "My Card",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "SUBSCRIPTION", "Company", "Company");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/subscribe.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Subscriptions",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
            ])));
  }

  _buildRentFees() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: bankBox)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 20),
                child: Text(
                  "Rent & Fees",
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "EDUCATION", "board", "Board");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/education.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  education,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "HOUSING SOCIETY", "soecity", "Soecity");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/housing.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  housingSociety,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(context, "CLUBS AND ASSOCIATIONS",
                            "Company", "Company");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/night_club.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  club,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "APARTMENT", "Company", "Company");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/apartment.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Apartments",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
            ])));
  }

  _buildTaxServices() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: bankBox)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 30.0, top: 20, bottom: 10),
                child: Text(
                  "Taxes & Others",
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(context, "MUNICIPAL SERVICES",
                            "Company", "Company");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/muncipl_services.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  muncipalServices,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "MUNICIPAL TAXES", "board", "Board");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/munciple.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  muncipleTax,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "HOSPITAL", "Company", "Company");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/hospital.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  hospital,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
            ])));
  }

  _buildTravelServices() {
    return Container(
        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
        decoration: BoxDecoration(
            color: white,
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: bankBox)),
        child: ClipRRect(
            borderRadius: BorderRadius.circular(20.0),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 20, bottom: 10),
                child: Text(
                  "Travel",
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        //openRechargeSelection(context, "MUNICIPAL SERVICES", "Company", "Company");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/brandvoucher.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Mumbai Metro",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "TRAVEL-SUB", "board", "Board");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/munciple.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Travel Sub",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openRechargeSelection(
                            context, "TRANSIT CARD", "board", "Board");
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 55.h,
                              width: 55.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Image.asset(
                                  'assets/munciple.png',
                                  color: lightBlue,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: FittedBox(
                                fit: BoxFit.cover,
                                child: Text(
                                  "Transit Cards",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                )),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(),
                    flex: 1,
                  ),
                ],
              ),
              SizedBox(
                height: 15.h,
              ),
            ])));
  }

  _buildOtherServices() {
    return Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
        child: Column(children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    openRechargeSelection(
                        context, "HOSPITAL", "Company", "Company");
                  },
                  child: Column(
                    children: [
                      Container(
                          height: 55.h,
                          width: 55.w,
                          decoration: BoxDecoration(
                            color: boxBg, // border color
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              'assets/hospital.png',
                              color: lightBlue,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FittedBox(
                            fit: BoxFit.cover,
                            child: Text(
                              hospital,
                              style:
                                  TextStyle(color: black, fontSize: font11.sp),
                              textAlign: TextAlign.center,
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Container(),
                flex: 1,
              ),
              Expanded(
                child: Container(),
                flex: 1,
              ),
              Expanded(
                child: Container(),
                flex: 1,
              ),
            ],
          )
        ]));
  }

  Future getAEPSAuthToken() async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var header = {
      "secretKey": "$atmSecrettKey",
      "saltKey": "$atmSaltKey",
      "encryptdecryptKey": "$atmEncDecKey"
    };

    final response = await http.post(Uri.parse(authUrl), headers: header);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "AEPS Response : $data");

    setState(() {
      Navigator.pop(context);
      if (data['isSuccess'].toString() == "true") {
        var authToken = data['data']['token'].toString();
        printMessage(screen, "Auth Token : $authToken");
        checkAEPSKycStatus(authToken);
      } else {
        Navigator.pop(context);
        showToastMessage("Something went wrong. Please after sometime");
      }
    });
  }

  Future checkAEPSKycStatus(authToken) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var mId = await getMATMMerchantId();
    var email = await getEmail();
    var mobile = await getMobile();

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "merchant_id": "$mId",
        "emailId": "$email",
        "mobileNo": "$mobile"
      };

      String result = await platform.invokeMethod("kycStatus", arr);

      printMessage(screen, "Submit json : $result");

      var header = {
        "Authorization": "Bearer $authToken",
        "Content-Type": "application/json"
      };

      final response = await http.post(Uri.parse(merchantStatusKYC),
          headers: header,
          body: (result),
          encoding: Encoding.getByName("utf-8"));

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Status Data : $data");

      setState(() {
        Navigator.pop(context);

        var isSuccess = data['isSuccess'].toString();

        if (isSuccess.toString() == "true") {
          var sta = data['data']['statusDescription'].toString();

          var statusCode = data['data']['statusCode'].toString();

          //PK = Pending For KYC
          //A = Active
          //R = Rejected
          //D = Deactive

          if (statusCode == "A") {
            openAEPSLanding(context, "ICICI");
          } else if (statusCode == "PK") {
            Navigator.of(context).pop();
            openAEPS_SBMOnboarding(context, "ICICI");
          } else if (statusCode == "R") {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ThankYouDialog(
                    text: "$sta",
                    isCloseAll: "2".toString(),
                  );
                });
          } else if (statusCode == "D") {
            Navigator.of(context).pop();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return ThankYouDialog(
                    text: "$sta",
                    isCloseAll: "2".toString(),
                  );
                });
          }
        } else {
          showToastMessage(data['message'].toString());
          //openATMOnBoarding(context);
        }
      });
    }
  }

  applyForServices(index) {
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
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                      border: Border.all(color: white)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Image.asset(
                        'assets/thanks.png',
                        height: 100.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Text(
                        youNotAuthorize,
                        style: TextStyle(fontSize: font15.sp, color: black),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Text(
                        wouldApply,
                        style: TextStyle(
                            fontSize: font15.sp,
                            color: lightBlack,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);

                              if (index == 1) updateRequestStatus(1);

                              if (index == 2) updateRequestStatus(2);

                              if (index == 3) updateRequestStatus(3);
                            },
                            child: Container(
                              height: 40.h,
                              width: 120.w,
                              decoration: BoxDecoration(
                                  color: green,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  border: Border.all(color: green)),
                              child: Center(
                                  child: Text(
                                "Yes",
                                style: TextStyle(
                                    fontSize: font15.sp, color: white),
                              )),
                            ),
                          ),
                          SizedBox(
                            width: 30.w,
                          ),
                          InkWell(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Container(
                              width: 120.w,
                              height: 40.h,
                              decoration: BoxDecoration(
                                  color: white,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                  border: Border.all(color: lightBlue)),
                              child: Center(
                                  child: Text(
                                "No",
                                style: TextStyle(
                                    fontSize: font15.sp, color: lightBlue),
                              )),
                            ),
                          )
                        ],
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

  requestPendingPopUp() {
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
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: white)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Image.asset(
                        'assets/pendingx.png',
                        height: 100.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, bottom: 15, left: 30, right: 30),
                        child: Text(
                          reqPending,
                          style: TextStyle(fontSize: font15.sp, color: black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Container(
                          width: 120.w,
                          height: 40.h,
                          decoration: BoxDecoration(
                              color: lightBlue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              border: Border.all(color: lightBlue)),
                          child: Center(
                              child: Text(
                            "Okay",
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

  Future updateRequestStatus(index) async {
    var mId = await getMerchantID();

    var url;

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    if (index == 1) {
      url = merchantMATMRequestAPI;
    }

    if (index == 2) {
      url = merchantDMTRequestAPI;
    }

    if (index == 3) {
      url = merchantAEPSRequestAPI;
    }

    printMessage("DMT Status", "url : $url");

    final body = {
      "m_id": "$mId",
    };

    printMessage("AEPS Status", "body : $body");

    final response = await http.post(Uri.parse(url),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage("DMT Status", "data : $data");

    setState(() {
      showToastMessage(data['message'].toString());
    });
  }

  Future checkCardStatus() async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();
    var mobile = await getMobile();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"user_token": "$userToken", "mobile": "$mobile"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(checkStatusCardAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage("Status", "data : $data");
      setState(() {
        Navigator.pop(context);
        var status = data['status'].toString();
        if (status.toString() == "1") {
          openMyCardIntro(context);
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
