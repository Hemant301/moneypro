import 'dart:async';
import 'dart:io';
import 'dart:math';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:contacts_service/contacts_service.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:flutter_tts/flutter_tts.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/footer/WelcomeOfferPopup.dart';
import 'package:moneypro_new/ui/models/Banners.dart';

import 'package:moneypro_new/ui/models/TeamMember.dart';
import 'package:moneypro_new/ui/services/ShowAds.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/MyConnectivity.dart';
import 'package:moneypro_new/utils/NoInternet.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:showcaseview/showcaseview.dart';
import 'package:moneypro_new/utils/AppKeys.dart';

import '../../main.dart';
import 'package:translator/translator.dart';

class AppIntroScreen extends StatefulWidget {
  const AppIntroScreen({Key? key})
      : super(key: key);

  @override
  _AppIntroScreenState createState() => _AppIntroScreenState();
}

class _AppIntroScreenState extends State<AppIntroScreen> {
  var screen = "AppIntroScreen";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        onStart: (index, key) {
          //printMessage(screen, 'onStart: $index, $key');
        },
        onComplete: (index, key) async{
          printMessage(screen, 'onComplete: $index, ${key.currentContext}');
          if (index == 1) {
            await Scrollable.ensureVisible(
              key.currentContext!,
              alignment: -1,
            );

          }
        },
        blurValue: 1,
        builder: Builder(builder: (context) => AppIntroScreenDetails()),
        autoPlayDelay: const Duration(seconds: 3),
      ),
    );
  }
}

class AppIntroScreenDetails extends StatefulWidget {
  const AppIntroScreenDetails({Key? key}) : super(key: key);

  @override
  State<AppIntroScreenDetails> createState() => _AppIntroScreenDetailsState();
}

class _AppIntroScreenDetailsState extends State<AppIntroScreenDetails> {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  int currentIndex = 0;

  var screen = "Home";

  var loading = false;

  var centerLoading = false;

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback(
            (_) => ShowCaseWidget.of(context)!
            .startShowCase([_one, _two, _three, _four]),);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              key: _drawerKey,
              backgroundColor: (loading) ? white : lightBlue,
              body: (loading)
                  ? Center(child: circularProgressLoading(40.0))
                  : SingleChildScrollView(
                    child: Column(
                        children: [
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              InkWell(
                                onTap: () {
                                  _drawerKey.currentState!.openDrawer();
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
                                          'assets/menu.png',
                                          height: 16.h,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Showcase(
                                  key: _one,
                                  description:
                                  "You can check your Profile & other settings.",
                                  shapeBorder: CircleBorder(),
                                  radius: BorderRadius.all(Radius.circular(50)),
                                  overlayPadding: EdgeInsets.all(15),
                                  child: Image.asset(
                                'assets/profile.png',
                                height: 40.h,
                              )),
                              SizedBox(
                                width: 4.w,
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [

                                  ],
                                ),
                              ),
                              Spacer(),
                              SizedBox(
                                width: 20.w,
                              ),
                              Showcase(
                                    key: _two,
                                    description:
                                        "You can check your QR code or become Merchant.",
                                    shapeBorder: CircleBorder(),
                                radius: BorderRadius.all(Radius.circular(50)),
                                overlayPadding: EdgeInsets.all(15),
                                    child: SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: Image.asset(
                                        'assets/qr_menu.png',
                                        color: white,
                                        height: 20.h,
                                      ),
                                    ),
                                  ),
                              SizedBox(
                                width: 20.w,
                              ),
                              InkWell(
                                onTap: () {
                                  WidgetsBinding.instance!.addPostFrameCallback(
                                        (_) => ShowCaseWidget.of(context)!
                                        .startShowCase([_one, _two, _three, _four]),);
                                },
                                child: Image.asset(
                                  'assets/notification.png',
                                  height: 20.h,
                                ),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                            ],
                          ),
                          _buildTopHeader(),
                          Stack(
                            children: [
                              _buildRechargeSection(),
                              (centerLoading)
                                  ? Positioned(
                                      top: MediaQuery.of(context).size.height *
                                          .4,
                                      child: Container(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: circularProgressLoading(40.0)))
                                  : Container()
                            ],
                          ),
                        ],
                      ),
                  ),
              bottomNavigationBar: StyleProvider(
                style: Style(),
                child: customBottomNav(context, "3", false),
              ),
            )));
  }

  Widget customBottomNav(context, role, isHome) {
    return ConvexAppBar(
      style: TabStyle.fixed,
      backgroundColor: white,
      color: black,
      activeColor: black,
      items: [
        TabItem(
            icon: Image.asset(
              'assets/home_gray.png',
            ),
            title: 'Home',
            isIconBlend: false),
        TabItem(
            icon: Image.asset(
              'assets/loan.png',
            ),
            title: 'Apply Loan',
            isIconBlend: false),
        TabItem(
            icon: Container(
              decoration: BoxDecoration(
                color: lightBlue, // border color
                shape: BoxShape.circle,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Image.asset(
                  'assets/ic_shop_icon.png',
                  color: white,
                ),
              ),
            ),
            title: 'Store',
            isIconBlend: false),
        TabItem(
            icon: Showcase(
              key: _four,
              description: "You can check your all transaction history",
              shapeBorder: CircleBorder(),
              radius: BorderRadius.all(Radius.circular(50)),
              overlayPadding: EdgeInsets.all(15),
              child: Image.asset(
                'assets/history.png',
              ),
            ),
            title: 'History',
            isIconBlend: false),
        TabItem(
            icon: Image.asset(
              'assets/discount.png',
            ),
            title: 'Offer',
            isIconBlend: false),
      ],
      initialActiveIndex: 0,
      onTap: (index) {
        if (index == 0) {
          if (isHome) {
            removeAllPages(context);
          }
        } else if (index == 1) {
          openApplyLoan(context);
        } else if (index == 2) {
          //openStoreHome(context);
        } else if (index == 3) {
          if (role.toString() == "3") {
            openTransactionHistory(context,"","");
          } else {
            openTransactionHistoryEmpUser(context);
          }
        } else if (index == 4) {
          openAllOffers(context);
        }
      },
    );
  }

  _buildTopHeader() {
    return Container(
      color: lightBlue,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 20, right: 20),
            child: Row(
              children: [
                Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buildRechargeSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(30.0)),
        color: white,
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Center(
            child: Container(
              color: gray,
              width: 50.w,
              height: 5.h,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                _buildRechargeTabs(),
                _buildOfferSection(),
                _buildFinancialSection()

              ],
            ),
          )
        ],
      ),
    );
  }

  _buildRechargeTabs() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: bankBox)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 0.w,
                ),
                /*Image.asset(
                  'assets/b_logo.png',
                  height: 20.h,
                  width: 20.w,
                ),*/
                Padding(
                  padding:
                      const EdgeInsets.only(left: 10.0, top: 15, bottom: 10),
                  child: Row(
                    children: [
                      Text(
                        recharge,
                        style: TextStyle(
                            color: black,
                            fontSize: font15.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        width: 4.w,
                      ),
                      Text(
                        utilities,
                        style: TextStyle(
                            color: black,
                            fontSize: font15.sp,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        openMobileSelection(context, "");
                        //openPayUMobilePlans(context, "8296745319", _contacts);
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
                              fit: BoxFit.contain,
                              child: Text(
                                "$mobilePrepaid",
                                style: TextStyle(
                                    color: black, fontSize: font11.sp),
                                textAlign: TextAlign.center,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                        openRechargeSelection(
                            context, "MOBILE POSTPAID", "operator", "operator");
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25.h,
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
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
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
                            height: 25.h,
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
                            child: Text(
                              dth,
                              style:
                                  TextStyle(color: black, fontSize: font11.sp),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
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
                              height: 45.h,
                              width: 45.w,
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
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
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
              height: 0.h,
            ),
            Row(
              children: [
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
                            child: Text(
                              fasttag,
                              style:
                                  TextStyle(color: black, fontSize: font11.sp),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 0.h,
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
                              height: 45.h,
                              width: 45.w,
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
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 0.h,
                          ),
                        ],
                      ),
                    )),
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
                              height: 45.h,
                              width: 45.w,
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
                            child: Text(
                              "LPG Gas",
                              style:
                                  TextStyle(color: black, fontSize: font11.sp),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 0.h,
                          ),
                        ],
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        //openMoreCategories(context, lat, lng);
                      },
                      child: Column(
                        children: [
                          SizedBox(
                            height: 25.h,
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
                                  'assets/more.png',
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              more,
                              style:
                                  TextStyle(color: black, fontSize: font11.sp),
                              textAlign: TextAlign.center,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          SizedBox(
                            height: 0.h,
                          ),
                        ],
                      ),
                    )),
              ],
            ),
            SizedBox(
              height: 10.h,
            ),
            InkWell(
              onTap: () {
                openAllOffers(context);
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: ColoredBox(
                  color: Colors.blueAccent.withOpacity(0.45),
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
          ],
        ),
      ),
    );
  }

  _buildOfferSection() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 20),
      child: Row(
        children: [
          Expanded(
              child: InkWell(
            onTap: () {
              openAllOffers(context);
            },
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset('assets/existing_offer.png'),
              ),
            ),
          )),
          SizedBox(
            width: 10.w,
          ),
          Expanded(
              child: InkWell(
            onTap: () {
              openRewardsList(context);
            },
            child: Container(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8.0),
                child: Image.asset('assets/earn_more.png'),
              ),
            ),
          ))
        ],
      ),
    );
  }

  _buildFinancialSection() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: bankBox)),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.0),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 0.0, right: 20, top: 20),
              child: Row(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, top: 0, bottom: 10),
                    child: Row(
                      children: [
                        Text(
                          financial,
                          style: TextStyle(
                              color: black,
                              fontSize: font15.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 4.w,
                        ),
                        Text(
                          services,
                          style: TextStyle(
                              color: black,
                              fontSize: font15.sp,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Container(
                        color: Colors.yellow,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 3.0, right: 3, top: 1, bottom: 1),
                          child: Text(
                            "*9% Interest",
                            style: TextStyle(color: black, fontSize: font12.sp),
                            maxLines: 1,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {},
                        child: Showcase(
                          key: _three,
                          description:
                              "You can check your Investment related transaction.",
                          shapeBorder: CircleBorder(),
                          radius: BorderRadius.all(Radius.circular(50)),
                          overlayPadding: EdgeInsets.all(15),
                          child: Container(
                              height: 60.h,
                              width: 60.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Stack(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset(
                                      'assets/myinvest.png',
                                      color: lightBlue,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          myInvestment,
                          style: TextStyle(color: black, fontSize: font10.sp),
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
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
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: boxBg, // border color
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.asset(
                                    'assets/axis_logo.png',
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Axis Bank",
                            style: TextStyle(color: black, fontSize: font11.sp),
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
                      openUpStoxLanding(context);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: boxBg, // border color
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: Image.asset(
                                    'assets/upstox_logo.png',
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Upstox Lead",
                            style: TextStyle(color: black, fontSize: font11.sp),
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
                      openLICDetails(context);
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 5.h,
                        ),
                        Container(
                            height: 60.h,
                            width: 60.w,
                            decoration: BoxDecoration(
                              color: boxBg, // border color
                              shape: BoxShape.circle,
                            ),
                            child: Stack(
                              children: [
                                Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset(
                                      'assets/lic_new.png',
                                    ),
                                  ),
                                ),
                              ],
                            )),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            lic,
                            style: TextStyle(color: black, fontSize: font11.sp),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
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
            Container(
              width: MediaQuery.of(context).size.width,
              child: ColoredBox(
                color: Colors.blueAccent.withOpacity(0.45),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, right: 20, top: 6, bottom: 6),
                  child: Text(
                    "$fintag",
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.start,
                    style: TextStyle(color: white, fontSize: font12.sp),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

}
