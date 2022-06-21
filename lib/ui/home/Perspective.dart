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
import 'package:fluttertoast/fluttertoast.dart';
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
import '../../utils/Apicall.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    new FlutterLocalNotificationsPlugin();

final translator = GoogleTranslator();

class Perspective extends StatefulWidget {
  final bool isShowWelcome;

  const Perspective({Key? key, required this.isShowWelcome}) : super(key: key);

  @override
  _PerspectiveState createState() => _PerspectiveState();
}

String storeimg = "";

class _PerspectiveState extends State<Perspective> {
  var screen = "Perspective";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ShowCaseWidget(
        onStart: (index, key) {
          printMessage(screen, 'onStart: $index, $key');
        },
        onComplete: (index, key) async {
          if (index == 1) {
            await Scrollable.ensureVisible(
              key.currentContext!,
              alignment: -1,
            );
          }
        },
        blurValue: 1,
        builder: Builder(
            builder: (context) => PerspectiveDetails(
                  isShowWelcome: widget.isShowWelcome,
                )),
        autoPlayDelay: const Duration(seconds: 3),
      ),
    );
  }
}

/*
*
* Above is added for show case
*
* */

class PerspectiveDetails extends StatefulWidget {
  final bool isShowWelcome;

  const PerspectiveDetails({Key? key, required this.isShowWelcome})
      : super(key: key);

  @override
  State<PerspectiveDetails> createState() => _PerspectiveDetailsState();
}

class _PerspectiveDetailsState extends State<PerspectiveDetails>
    with SingleTickerProviderStateMixin {
  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  late PageController _pageController;
  late AnimationController _animationController;

  int currentIndex = 0;

  var screen = "Home";

  late String matmStatus;
  late String dmtStatus;
  String matmAepsSBM = "";

  late String aepsStatus;
  late String aepsKYCStatus;
  late String aepsToken;
  var _fingerPrint = false;
  var _audioSound = true;
  var address = "";
  var role;
  var kycStatus;

  var loading = false;

  FlutterTts flutterTts = FlutterTts();

  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;
  double lat = 0.0;
  double lng = 0.0;

  double totalEarning = 0.0;
  double walletBal = 0.0;
  double qrWalletBal = 0.0;
  double avblBalc = 0.0;

  var district;
  var currentAddress;

  var profilePic = "";
  var profilePicId = "";

  var centerLoading = false;
  var approved = "";
  var branchCreate = "0";
  var virtualAccountNumber, virtualAccountIfscCode, virtualCompanyName;

  List<Team> teams = [];

  var isManagerShow = false;

  List<BannerList> bannerList = [];

  final GlobalKey _one = GlobalKey();
  final GlobalKey _two = GlobalKey();
  final GlobalKey _three = GlobalKey();
  final GlobalKey _four = GlobalKey();

  var isShowInvestor = false;
  var isShowMPWallet = false;

  var regType = "";

  @override
  void initState() {
    super.initState();

    if (mounted) {
      _pageController = PageController();
      autoAnimateBanner();
    }

    getUserAllDetails();
    _determinePosition();
    updateATMStatus(context);
    fetchUserAccountBalance();
    handleFCMNotification();
    this.fcmSubscribe();
    getUserProfilePic();
    getTeamList();
    trackScreens(screen);
    printMessage(screen, "isShowWelcome :${widget.isShowWelcome}");

    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);

    /*_animationQRController=new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat(reverse: true);*/

    var initializationSettingsAndroid =
        new AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettingsIOS = new IOSInitializationSettings();
    var initializationSettings = new InitializationSettings(
        android: initializationSettingsAndroid, iOS: initializationSettingsIOS);

    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: openNotificationCase);
    getLang();
    refreshPage();
  }

  refreshPage() {
    print('refresh');
    Future.delayed(Duration(seconds: 3), () {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animationController.dispose();
    //_animationQRController.dispose();
    super.dispose();
  }

  getLang() async {
    List<dynamic> languages = await flutterTts.getLanguages;

    await flutterTts.setLanguage("hi-IN");

    List<dynamic> getV = await flutterTts.getVoices;

    for (int i = 0; i < languages.length; i++) {
      // printMessage(screen, "Voice Name : ${languages[i]}");
      // printMessage(screen, "Voice locale : ${getV[i]['locale']}");
    }

    //flutterTts.setLanguage("hi-IN");
    flutterTts.setSpeechRate(0.0);
    //flutterTts.setVoice({"name": "hi-in-x-hia", "locale": "hi-IN"});
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();

    double mX = 0.0;
    double wX = 0.0;

    printMessage(screen, "Wallet AMT : $mpBalc");
    printMessage(screen, "QR AMT : $qrBalc");
    printMessage(screen, "Welcome AMT : $walBalc");

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
      walletBal = wX + mX;
    });
  }

  @override
  Widget build(BuildContext context) {
    final InheritedWidget = StateContainer.of(context);
    qrWalletBal = double.parse(InheritedWidget.qrBalc);
    var deviceWidth = 380.0;
    var deviceHeight = 800.0;
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              key: _drawerKey,
              backgroundColor: (loading) ? white : lightBlue,
              drawer: (role.toString() == "3")
                  ? _appDrawerMerchant(profilePic)
                  : (role.toString() == "2")
                      ? _appDrawerEmpolyee(profilePic)
                      : _appDrawerUser(profilePic),
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
                              InkWell(
                                onTap: () {
                                  openProfile(
                                      context, profilePic, profilePicId);
                                },
                                child: Showcase(
                                  key: _one,
                                  description:
                                      "You can check your Profile & other settings.",
                                  shapeBorder: CircleBorder(),
                                  radius: BorderRadius.all(Radius.circular(50)),
                                  overlayPadding: EdgeInsets.all(15),
                                  child: (profilePic.toString() == "")
                                      ? Image.asset(
                                          'assets/profile.png',
                                          height: 40.h,
                                        )
                                      : Container(
                                          height: 36.h,
                                          width: 36.w,
                                          decoration: BoxDecoration(
                                            color: white, // border color
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(0.0),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(16.0),
                                              child: Image.network(profilePic,
                                                  height: 40.h,
                                                  fit: BoxFit.fill),
                                            ),
                                          )),
                                ),
                              ),
                              SizedBox(
                                width: 4.w,
                              ),
                              Expanded(
                                flex: 1,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      (role == "3")
                                          ? "$companyName"
                                          : "$nameChar",
                                      style: TextStyle(
                                          color: white, fontSize: font14.sp),
                                      maxLines: 1,
                                    ),
                                    (currentAddress.toString() == "null" ||
                                            currentAddress.toString() == "")
                                        ? Container()
                                        : Text(
                                            "$currentAddress",
                                            style: TextStyle(
                                                color: white,
                                                fontSize: font12.sp),
                                            maxLines: 1,
                                          ),
                                  ],
                                ),
                              ),
                              (role.toString() == "3")
                                  ? SizedBox(
                                      width: 20.w,
                                    )
                                  : Container(),
                              (role.toString() == "3")
                                  ? Container(
                                      decoration: BoxDecoration(
                                          color: walletBg,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10)),
                                          border: Border.all(color: walletBg)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 6.0,
                                            top: 10,
                                            bottom: 10,
                                            right: 6),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              "assets/wallet.png",
                                              height: 20.h,
                                            ),
                                            Center(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 6.0,
                                                    right: 6,
                                                    top: 0),
                                                child: Text(
                                                  "${formatDecimal2Digit.format(walletBal)}",
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
                                  : Container(),
                              SizedBox(
                                width: 20.w,
                              ),
                              (!isManagerShow)
                                  ? InkWell(
                                      onTap: () {
                                        if (regType.toString().toLowerCase() ==
                                            "web") {
                                          if (kycStatus.toString() == "1") {
                                            openViewQRCode(context, 0);
                                          } else {
                                            openMerchantWebDetails(context);
                                          }
                                        } else {
                                          if (kycStatus.toString() == "1" &&
                                              role == "3") {
                                            openViewQRCode(context, 0);
                                          } else {
                                            openBecameMerchant(context);
                                          }
                                        }
                                      },
                                      child: Showcase(
                                        key: _two,
                                        description:
                                            "You can check your QR code or become Merchant.",
                                        shapeBorder: CircleBorder(),
                                        radius: BorderRadius.all(
                                            Radius.circular(50)),
                                        overlayPadding: EdgeInsets.all(15),
                                        child: SizedBox(
                                          height: 10,
                                          width: 10,
                                          child: ScaleTransition(
                                              scale: Tween(begin: 0.0, end: 2.0)
                                                  .animate(
                                                CurvedAnimation(
                                                    parent:
                                                        _animationController,
                                                    curve: Curves.elasticOut),
                                              ),
                                              child: Image.asset(
                                                'assets/qr_menu.png',
                                                color: white,
                                                height: 10.h,
                                              )),
                                        ),
                                      ),
                                    )
                                  : Container(),
                              (!isManagerShow)
                                  ? SizedBox(
                                      width: 20.w,
                                    )
                                  : Container(),
                              InkWell(
                                onTap: () {
                                  openWithdrwal(context, true, true, 100.0);
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
                          (role.toString() == "3" &&
                                  virtualAccountIfscCode.toString() != "null")
                              ? _buildMerchantDetails()
                              : _buildTopHeader(),
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
                child: customBottomNav(context, role, false),
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
          openStoreApp(context);
        } else if (index == 3) {
          if (role.toString() == "3") {
            openTransactionHistory(context, "", "");
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
                (walletBal.toString() != "0" && walletBal.toString() != "null")
                    ? Expanded(
                        flex: 1,
                        child: Container(
                          child: InkWell(
                            onTap: () {
                              openAppWallet(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 15.0),
                                  child: Text(
                                    "$wallet",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: gray, fontSize: font14.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          rupeeSymbol,
                                          style: TextStyle(
                                              color: gray, fontSize: font14.sp),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Text(
                                        "${formatNow.format(walletBal)}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: gray, fontSize: 28.sp),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                (role.toString() == "3" &&
                        qrWalletBal.toString() != "0" &&
                        qrWalletBal.toString() != "null")
                    ? Expanded(
                        flex: 1,
                        child: Container(
                          child: InkWell(
                            onTap: () {
                              openAppWallet(context);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 10.0),
                                  child: Text(
                                    "$upiQRWallet",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: gray, fontSize: font14.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          rupeeSymbol,
                                          style: TextStyle(
                                              color: gray, fontSize: font14.sp),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Text(
                                        "${formatNow.format(qrWalletBal)}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: gray, fontSize: 28.sp),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
                (totalEarning != 0.0)
                    ? Expanded(
                        flex: 1,
                        child: Container(
                          child: InkWell(
                            onTap: () async {
                              if (role == "3") {
                                var dob = await getDOB();
                                if (isAdult(dob)) {
                                  getInvestorKycStatus();
                                } else {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        CustomInfoDialog(
                                      title: "Alert",
                                      description:
                                          "To became Investor, your age must be above or equal to 18 years.",
                                      buttonText: "Okay",
                                    ),
                                  );
                                }
                              } else {
                                getInvestorKycStatus();
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(left: 12.0),
                                  child: Text(
                                    "$investmentAc",
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                        color: gray, fontSize: font14.sp),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                FittedBox(
                                  fit: BoxFit.cover,
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(top: 10.0),
                                        child: Text(
                                          rupeeSymbol,
                                          style: TextStyle(
                                              color: gray, fontSize: font14.sp),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 4.w,
                                      ),
                                      Text(
                                        "${formatNow.format(totalEarning)}",
                                        textAlign: TextAlign.left,
                                        style: TextStyle(
                                            color: gray, fontSize: 28.sp),
                                      ),
                                      SizedBox(
                                        width: 2.w,
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          (role.toString() == "3")
              ? Container(
                  margin: EdgeInsets.only(left: 0, right: 0, top: 20),
                  height: 50.h,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: [
                      SizedBox(
                        width: 20.w,
                      ),
                      InkWell(
                        onTap: () {
                          if (approved.toString() == "1") {
                            openMoneyTransferLanding(context);
                          } else {
                            showToastMessage(notApproved);
                          }
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: boxBg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              border: Border.all(
                                color: white,
                              )),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Row(
                              children: [
                                Container(
                                    height: 36.h,
                                    width: 36.w,
                                    decoration: BoxDecoration(
                                      color: lightBlue, // border color
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(4.0),
                                      child: Image.asset(
                                        'assets/fixedd.png',
                                        color: white,
                                      ),
                                    )),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  "Transfer Money",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      InkWell(
                        onTap: () {
                          // if (approved.toString() == "1") {
                          if (role.toString() == "3") {
                            openTransactionHistory(context, "", "");
                          } else {
                            openTransactionHistoryEmpUser(context);
                          }
                          /*} else {
                            showToastMessage(notApproved);
                          }*/
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: boxBg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(50)),
                              border: Border.all(
                                color: white,
                              )),
                          child: Padding(
                            padding:
                                const EdgeInsets.only(left: 10.0, right: 10),
                            child: Row(
                              children: [
                                Container(
                                    height: 36.h,
                                    width: 36.w,
                                    decoration: BoxDecoration(
                                      color: lightBlue, // border color
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(9.0),
                                      child: Image.asset(
                                        'assets/qr_menu.png',
                                        color: white,
                                      ),
                                    )),
                                SizedBox(
                                  width: 4.w,
                                ),
                                Text(
                                  "Qr Statement",
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                )
              : Container(
                  height: 20.h,
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
                (role == "3")
                    ? _buildFinancialSection()
                    : _buildFinancialUserEmpSection(),
                (bannerList.length == 0)
                    ? Container()
                    : _buildBannerSection(_pageController),
                (bannerList.length == 0)
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(bottom: 8.0, top: 5),
                        child: Center(
                          child:
                              indicatorsTop(_pageController, bannerList.length),
                        ),
                      ),
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
                        openMoreCategories(context, lat, lng);
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
                        Expanded(
                          flex: 1,
                          child: Text(
                            "$rechTag",
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.start,
                            style: TextStyle(color: white, fontSize: font12.sp),
                          ),
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
                        onTap: () async {
                          // check for user and empolyee
                          if (role == "3") {
                            var dob = await getDOB();

                            if (isAdult(dob)) {
                              getInvestorKycStatus();
                            } else {
                              showDialog(
                                context: context,
                                builder: (BuildContext context) =>
                                    CustomInfoDialog(
                                  title: "Alert",
                                  description:
                                      "To became Investor, your age must be above or equal to 18 years.",
                                  buttonText: "Okay",
                                ),
                              );
                            }
                          } else {
                            getInvestorKycStatus();
                          }
                        },
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
            (dmtStatus.toString() == "1" ||
                    aepsStatus.toString() == "1" ||
                    matmStatus.toString() == "1" ||
                    matmAepsSBM.toString() == "1")
                ? Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () async {
                            var matmID = await getMATMMerchantId();

                            printMessage(screen, "matmStatus : $matmStatus");
                            printMessage(screen, "matmID : $matmID");

                            if (matmStatus == "1") {
                              if (matmID != "" && matmID != "null") {
                                printMessage(screen, "Call SDK Part");
                                //getMATMTxnId();
                                openMATMProcess(context);
                              } else {
                                openATMOnBoarding(context);
                              }
                            } else if (matmStatus == "2") {
                              requestPendingPopUp();
                            } else {
                              applyForServices(1);
                            }
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
                                          'assets/microatm.png',
                                          color: lightBlue,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  microAtm,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () async {
                            var outId = await getOutLetId();
                            var aepsActive = await getMatmAepsActive();
                            var aepsMId = await getAEPSMerchantId();

                            setState(() {
                              if (aepsStatus == "1") {
                                /*if (aepsStatus.toString() == "1" &&
                                aepsActive.toString() == "0") {
                              // check for AEPS ICICI
                              printMessage(screen, "AEPS ICICI");
                              if (outId.toString() == "null" ||
                                  outId.toString() == "") {
                                if (aepsToken == "1") {
                                  openAEPSVerifyMobile(context);
                                } else {
                                  var url = "$apesWebUrl$aepsToken";
                                  printMessage(screen, "AEPS Url :  $url");
                                  openShowWebViews(context, url);
                                }
                              } else {
                                generateAEPSToken(outId);
                              }
                            } else*/
                                if (aepsStatus.toString() == "1") {
                                  // check for AEPS SBM
                                  printMessage(screen, "AEPS ICICI");
                                  if (aepsMId.toString() == "null" ||
                                      aepsMId.toString() == "") {
                                    if (aepsKYCStatus == "1" &&
                                        aepsMId.toString() != "null" &&
                                        aepsMId.toString() != "") {
                                      getAEPSAuthToken();
                                    } else {
                                      openAEPS_SBMOnboarding(context, "ICICI");
                                    }
                                  } else {
                                    openAEPSLanding(context, "ICICI");

                                    // checkKyc() async {
                                    //   HomeApi _api = HomeApi();
                                    //   Map data = await _api.doCheckKyc();
                                    //   print(data);
                                    //   if (data['response']['statusCode'] ==
                                    //       "000") {
                                    //     openAEPSLanding(context, "ICICI");
                                    //   } else {
                                    //     Fluttertoast.showToast(
                                    //         msg: data['response']['data']
                                    //             ['statusDescription']);
                                    //     return;
                                    //   }
                                    // }

                                    // checkKyc();
                                  }
                                }
                              } else if (aepsStatus == "2") {
                                requestPendingPopUp();
                              } else {
                                applyForServices(3);
                              }
                            });
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
                                          'assets/aeps.png',
                                          color: lightBlue,
                                        ),
                                      ),
                                    ],
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  aeps,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
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
                            printMessage(screen, "DTM Status : $dmtStatus");
                            setState(() {
                              if (dmtStatus == "1") {
                                openDMTLanding(context);
                              } else if (dmtStatus == "2") {
                                requestPendingPopUp();
                              } else {
                                applyForServices(2);
                              }
                            });
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset(
                                      'assets/dmt.png',
                                      color: lightBlue,
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  dmt,
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      // Expanded(
                      //   flex: 1,
                      //   child: InkWell(
                      //     onTap: () {
                      //       openAePSFinoLanding(context);
                      //     },
                      //     child: Column(
                      //       children: [
                      //         SizedBox(
                      //           height: 5.h,
                      //         ),
                      //         Container(
                      //             height: 60.h,
                      //             width: 60.w,
                      //             decoration: BoxDecoration(
                      //               color: boxBg, // border color
                      //               shape: BoxShape.circle,
                      //             ),
                      //             child: Padding(
                      //               padding: const EdgeInsets.all(15.0),
                      //               child: Image.asset(
                      //                 'assets/aeps.png',
                      //                 color: lightBlue,
                      //               ),
                      //             )),
                      //         Padding(
                      //           padding: const EdgeInsets.all(8.0),
                      //           child: Text(
                      //             "AePS Fino",
                      //             style: TextStyle(
                      //                 color: black, fontSize: font11.sp),
                      //             textAlign: TextAlign.center,
                      //             maxLines: 2,
                      //             overflow: TextOverflow.ellipsis,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //   ),
                      // ),
                      Expanded(
                        flex: 1,
                        child: InkWell(
                          onTap: () {
                            openSellEarnLanding(context);
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
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Image.asset(
                                      'assets/referral.png',
                                      color: lightBlue,
                                    ),
                                  )),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Refer & Earn",
                                  style: TextStyle(
                                      color: black, fontSize: font11.sp),
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
                  )
                : Container(),
            // Row(
            //   children: [
            //     Expanded(
            //       flex: 1,
            //       child: InkWell(
            //         onTap: () {
            //           openSellEarnLanding(context);
            //         },
            //         child: Column(
            //           children: [
            //             SizedBox(
            //               height: 5.h,
            //             ),
            //             Container(
            //                 height: 60.h,
            //                 width: 60.w,
            //                 decoration: BoxDecoration(
            //                   color: boxBg, // border color
            //                   shape: BoxShape.circle,
            //                 ),
            //                 child: Padding(
            //                   padding: const EdgeInsets.all(15.0),
            //                   child: Image.asset(
            //                     'assets/referral.png',
            //                     color: lightBlue,
            //                   ),
            //                 )),
            //             Padding(
            //               padding: const EdgeInsets.all(8.0),
            //               child: Text(
            //                 "Refer & Earn",
            //                 style: TextStyle(color: black, fontSize: font11.sp),
            //                 textAlign: TextAlign.center,
            //                 maxLines: 2,
            //                 overflow: TextOverflow.ellipsis,
            //               ),
            //             ),
            //           ],
            //         ),
            //       ),
            //     ),
            //     Expanded(child: Container(), flex: 1),
            //     Expanded(child: Container(), flex: 1),
            //     Expanded(child: Container(), flex: 1),
            //   ],
            // ),
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

  _buildFinancialUserEmpSection() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10),
      decoration: BoxDecoration(
          color: white,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: bankBox)),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 0.0, right: 20, top: 15),
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
                    SizedBox(height: 5.h),
                    InkWell(
                      onTap: () async {
                        // check for user and empolyee
                        if (role == "3") {
                          var dob = await getDOB();
                          if (isAdult(dob)) {
                            getInvestorKycStatus();
                          } else {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  CustomInfoDialog(
                                title: "Alert",
                                description:
                                    "To became Investor, your age must be above or equal to 18 years.",
                                buttonText: "Okay",
                              ),
                            );
                          }
                        } else {
                          getInvestorKycStatus();
                        }
                      },
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
          Row(
            children: [
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    printMessage(screen, "DTM Status : $dmtStatus");
                    setState(() {
                      if (dmtStatus == "1") {
                        openDMTLanding(context);
                      } else if (dmtStatus == "2") {
                        requestPendingPopUp();
                      } else {
                        applyForServices(2);
                      }
                    });
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
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              'assets/dmt.png',
                              color: lightBlue,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          dmt,
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
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    openRechargeSelection(
                        context, "INSURANCE", "Company", "Company");
                  },
                  child: Column(
                    children: [
                      Container(
                          height: 60.h,
                          width: 60.w,
                          decoration: BoxDecoration(
                            color: boxBg, // border color
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Image.asset(
                              'assets/lic.png',
                              color: lightBlue,
                            ),
                          )),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          insurance,
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
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    openRechargeSelection(
                        context, "LOAN", "Company", "Company");
                  },
                  child: Column(
                    children: [
                      Container(
                          height: 60.h,
                          width: 60.w,
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
                        child: Text(
                          "Loan Repayment",
                          style: TextStyle(color: black, fontSize: font11.sp),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(child: Container()),
            ],
          ),
        ],
      ),
    );
  }

  _buildBannerSection(controller) {
    return Padding(
      padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
      child: Column(
        children: [
          Container(
              height: MediaQuery.of(context).size.height * .16,
              child: PageView.builder(
                controller: controller,
                scrollDirection: Axis.horizontal,
                itemCount: bannerList.length,
                onPageChanged: (index) {
                  setState(() {});
                },
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Image.network(
                        "$bannerBaseUrl${bannerList[index].image}",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  );
                },
              )),
        ],
      ),
    );
  }

  autoAnimateBanner() {
    try {
      Timer.periodic(Duration(seconds: 6), (Timer timer) {
        if (currentIndex < bannerList.length) {
          currentIndex++;
        } else {
          currentIndex = 0;
        }

        /*if (_pageController.hasClients)
          _pageController.animateToPage(
            currentIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );*/
      });
    } catch (e) {
      printMessage(screen, "ERROR -> ${e.toString()}");
    }
  }

  Future getUserAllDetails() async {
    setState(() {
      loading = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "token": "$token",
    };

    printMessage(screen, "All detail : $body");

    final response = await http.post(Uri.parse(userDetailAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");

      if (data['status'].toString() == "1") {
        setState(() {
          storeimg = "${data['user']['store_img'].toString()}";
          saveFirstName("${data['user']['first_name'].toString()}");
          saveLastName("${data['user']['last_name'].toString()}");
          saveEmail("${data['user']['email'].toString()}");
          saveMobile("${data['user']['mobile'].toString()}");
          saveDOB("${data['user']['dob'].toString()}");
          saveComapanyName("${data['user']['company_name'].toString()}");
          saveCompanyType("${data['user']['company_type'].toString()}");
          saveBusinessSegment("${data['user']['business_segment'].toString()}");
          saveCompanyAddress("${data['user']['company_address'].toString()}");
          saveContactName("${data['user']['contact_name'].toString()}");
          saveGSTNo("${data['user']['gst_no'].toString()}");
          savePANNo("${data['user']['pan_no'].toString()}");
          saveKYCStatus("${data['user']['kyc_status'].toString()}");
          saveToken("${data['user']['token'].toString()}");
          saveRole("${data['user']['role'].toString()}");
          saveMerchantID("${data['user']['mherchant_id'].toString()}");
          //saveATMService("${data['user']['atm_service']}");

          var wB = "${data['user']['wallet_balance']}";
          if (wB.toString() == "null") {
            saveWalletBalance("0");
          } else {
            saveWalletBalance("${data['user']['wallet_balance']}");
          }

          var wp = "${data['user']['wp_msg']}";
          if (wp.toString() == "null") {
            saveWhastAppValue("No");
          } else {
            saveWhastAppValue("${data['user']['wp_msg']}");
          }

          saveRetailerUserCode("${data['user']['retailer_user_code']}");
          saveRetailerOnBoardUser("${data['user']['retailer_onboard_user']}");
          saveQRtBalance("${data['user']['qr_wallet']}");
          saveDmtStatus("${data['user']['dmt']}");
          saveMatmStatus("${data['user']['matm']}");
          saveAepsStatus("${data['user']['aeps']}");
          saveAccountNumber("${data['user']['account_no']}");
          saveBranchCity("${data['user']['branch']}");
          saveBankName("${data['user']['bank_name']}");
          saveIFSC("${data['user']['ifsc']}");
          saveAPESToken("${data['user']['aeps_token']}");
          dmtStatus = data['user']['dmt'].toString();
          aepsStatus = data['user']['aeps'].toString();
          matmStatus = data['user']['matm'].toString();
          aepsToken = data['user']['aeps_token'].toString();
          saveVirtualAccId("${data['user']['virtual_accounts_id']}");
          saveVirtualAccNo("${data['user']['virtual_account_number']}");
          saveVirtualAccIFSC("${data['user']['virtual_account_ifsc_code']}");
          saveMATMMerchantId("${data['user']['matm_merchant_id']}");
          saveVPA("${data['user']['vpa']}");
          saveCity("${data['user']['city']}");
          saveAdhar("${data['user']['adhar']}");
          savePinCode("${data['user']['pin']}");
          saveOutLetId("${data['user']['outlet_id']}");
          saveState("${data['user']['state']}");
          saveQRMaxAmt("${data['user']['qr_withdrawl_amount']}");
          saveDistrict("${data['user']['district']}");
          saveEmployeeId("${data['user']['employee_id']}");
          saveQRInvestor("${data['user']['qr_money_invst']}");
          aepsKYCStatus = "${data['user']['aeps_kyc'].toString()}";
          saveAEPSKyc("${data['user']['aeps_kyc']}");
          saveAEPSMerchantId("${data['user']['aeps_merchant_id']}");
          saveMatmAepsActive("${data['user']['matm_aeps_active']}");
          saveWelcomeAmt("${data['user']['welcome_amount']}");
          saveSettlementType("${data['user']['settlement_type']}");
          saveApproved("${data['user']['approved']}");
          approved = data['user']['approved'].toString();
          saveQRDisplayName("${data['user']['qr_display_name']}");
          saveBranchCreate("${data['user']['branch_create']}");
          branchCreate = data['user']['branch_create'].toString();
          var managerValue = data['user']['manager'].toString();
          virtualAccountNumber =
              data['user']['virtual_account_number'].toString();
          virtualAccountIfscCode =
              data['user']['virtual_account_ifsc_code'].toString();
          virtualCompanyName = data['user']['company_name'].toString();

          regType = data['user']['reg_type'].toString();

          saveUserType(data['user']['reg_type'].toString());

          saveHolderName(data['user']['holder_name'].toString());

          var xqr = data['user']['qr_wallet'].toString();

          if (xqr.toString() == "" || xqr.toString() == "null") {
            avblBalc = 0.0;
          } else {
            double qeB = double.parse(xqr);
            avblBalc = avblBalc + qeB;
          }

          if (managerValue.toString() == "1") {
            setState(() {
              isManagerShow = true;
            });
          } else {
            setState(() {
              isManagerShow = false;
            });
          }

          if (dmtStatus.toString() == "1" ||
              aepsStatus.toString() == "1" ||
              matmStatus.toString() == "1" ||
              matmAepsSBM.toString() == "1") {
            setState(() {
              isShowMPWallet = true;
            });
          }

          matmAepsSBM = data['user']['matm_aeps_active'].toString();
        });

        setUserDetails();
      } else {
        removeAllPrefs();
        removeAllPageForLogout(context);
        openSignUpScreen(context);
      }

      setState(() {
        loading = false;
      });
    } else {
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }
  }

  setUserDetails() async {
    final rol = await getRole();
    final kycSts = await getKYCStatus();

    final now = new DateTime.now();
    String currentDate = DateFormat('yMd').format(now);

    var fname = await getFirstName();
    var lname = await getLastName();

    int adsCount = await getAdsCount();

    printMessage(screen, "Current Date : $currentDate");

    mobileChar = await getMobile();

    var add = await getCompanyAddress();

    var comName = await getComapanyName();

    var bal = await getWalletBalance();
    var qrBalc = await getQRBalance();

    String dmtS = await getDmtStatus();
    String aepsS = await getAepsStatus();
    String apesK = await getAEPSKyc();
    String mtStatus = await getMatmStatus();
    String aepsT = await getAPESToken();

    var rCode = await getRetailerUserCode();

    var scVal = await getfingerprint();

    var adVal = await getAudioSound();

    var getCDate = await getCurrentDate();

    var fRun = await getFirstRun();

    var lTy = await getLngType();

    printMessage(screen, "Lang Type : $lTy");

    setState(() {
      nameChar = "$fname $lname";

      dmtStatus = dmtS;
      aepsStatus = aepsS;
      aepsKYCStatus = apesK;
      aepsToken = aepsT;
      matmStatus = mtStatus;
      kycStatus = kycSts;

      if (comName.toString() == "null") {
        companyName = "";
      } else {
        companyName = comName;
      }

      _fingerPrint = scVal;
      _audioSound = adVal;

      if (add.toString() == "null") {
        address = "";
      } else {
        address = add;
      }

      role = rol;

      if (role == "1") {
        roleType = "User";
      } else if (role == "2") {
        roleType = "Employee";
      } else if (role == "3") {
        roleType = "Merchant";
      }

      fChar = fname[0];
      lChar = lname[0];

      printMessage(
          screen,
          "Role Type :$roleType\n"
          "Name : $nameChar\n"
          "Address : $address\n"
          "F=> $fChar\n"
          "L=> $lChar\n"
          "Mobile : $mobileChar\n"
          "KycStatus : $kycStatus\n"
          "DTM Status : $dmtStatus\n");
    });

    /*if (kycStatus.toString() == "0" && role == "3") {
      printMessage(screen, "User KYC not complete and User is Merchant");
      openMerchantGetStarted(context);
    }*/

    if (kycStatus.toString() == "1" && role == "3" && widget.isShowWelcome) {
      printMessage(screen, "Show welcome dialog");
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => WelcomeOfferPopup(action: 0));
    }

    if (role == "1" && widget.isShowWelcome) {
      printMessage(screen, "User KYC not complete and User is User Type");
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (context) => WelcomeOfferPopup(action: 0));
    }

    if (kycStatus.toString() == "0" && role == "2") {
      printMessage(
          screen, "Employee KYC not complete and User is Employee Type");
      // openEmpSelfPanVerify(context);
    }

    updateWalletBalances();
    getInvestorEarning();
    getBannerImage();

    /*if (!fRun) {
      WidgetsBinding.instance!.addPostFrameCallback(
            (_) => ShowCaseWidget.of(context)!
            .startShowCase([_one, _two, _three, _four]),
      );
    }else{
      if (getCDate.toString() == currentDate.toString()) {
        printMessage(screen, "Date Mactched");
        printMessage(screen, "Ads Count : $adsCount");
        if (adsCount < 3) {
          getAdsImage();
        }
      } else {
        saveCurrentDate(currentDate);
        saveAdsCount(0);
        getAdsImage();
      }
    }

    setState(() {
      saveFirstRun(true);
    });*/
  }

  void handleFCMNotification() {
    // onMessage: When the app is open and it receives a push notification
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("onMessage data: ${message.notification?.title}");
      //showToastMessage(message.data.toString());
      String? title = message.notification?.title.toString();
      String? msg = message.notification?.body.toString();
      showNotification(title, msg, _audioSound);
    });

    // replacement for onResume: When the app is in the background and opened directly from the push notification.
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('onMessageOpenedApp data: ${message.data}');
      //showToastMessage(message.data.toString());
      String title = message.data['title'].toString();
      String msg = message.data['body'].toString();
      showNotification(title, msg, _audioSound);
    });

    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
  }

  void fcmSubscribe() {
    _firebaseMessaging.subscribeToTopic('app_update');
  }

  Future<dynamic> openNotificationCase(var payload) async {
    setState(() {
      printMessage(screen, "PAYLOAD : $payload");

      try {
        //  FCMNotification note = FCMNotification.fromRawJson(payload);
        setState(() {});
      } catch (e) {
        printMessage(screen, "Error : ${e.toString()}");
      }
    });
  }

  Future getInvestorEarning() async {
    var mobile = await getMobile();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "mobile": "$mobile",
    };

    printMessage(screen, "Investor Body : $body");

    final response = await http.post(Uri.parse(investorKycStatusAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          var investorWallet = data['profile_data']['investment_wallet'];
          var investorEarning =
              data['profile_data']['investment_earning_wallet'];

          double earning = double.parse(
              data['profile_data']['investment_earning_wallet'].toString());
          totalEarning =
              double.parse(investorWallet) + double.parse(investorEarning);

          setState(() {
            isShowInvestor = true;
          });

          avblBalc = avblBalc + totalEarning;
        } else {
          setState(() {
            isShowInvestor = false;
          });
        }
      }
    });
  }

  Future getUserProfilePic() async {
    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "token": "$token",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(getUserProfileAPI),
        body: jsonEncode(body), headers: headers);

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Profile Image : ${data}");
        if (data['status'].toString() == "1") {
          var img = data['selfi'].toString();
          var picId = data['id'].toString();
          if (img.toString() != "" && img.toString() != "null") {
            profilePic = "$profilePicBase$img";
            profilePicId = picId;
          }
        }
      }
    });

    //createWalletList();
  }

  Future _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    printMessage(screen, "Location 2 Permission : $permission");

    var getCDate = await getCurrentDate();
    final now = new DateTime.now();
    String currentDate = DateFormat('yMd').format(now);
    int adsCount = await getAdsCount();

    if (permission == LocationPermission.denied) {
      shopPermissionPopup();
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getCurrentLocation();
      if (getCDate.toString() == currentDate.toString()) {
        printMessage(screen, "Date Mactched");
        printMessage(screen, "Ads Count : $adsCount");
        if (adsCount < 3) {
          getAdsImage();
        }
      } else {
        saveCurrentDate(currentDate);
        saveAdsCount(0);
        getAdsImage();
      }
    }
  }

  Future<Position> _determineSecondPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    printMessage(screen, "Location Permission : $serviceEnabled");

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    printMessage(screen, "Location 2 Permission : $permission");

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.

    var fRun = await getFirstRun();

    var getCDate = await getCurrentDate();
    final now = new DateTime.now();
    String currentDate = DateFormat('yMd').format(now);
    int adsCount = await getAdsCount();

    if (!fRun) {
      WidgetsBinding.instance!.addPostFrameCallback(
        (_) => ShowCaseWidget.of(context)!
            .startShowCase([_one, _two, _three, _four]),
      );
    } else {
      if (getCDate.toString() == currentDate.toString()) {
        printMessage(screen, "Date Mactched");
        printMessage(screen, "Ads Count : $adsCount");
        if (adsCount < 3) {
          getAdsImage();
        }
      } else {
        saveCurrentDate(currentDate);
        saveAdsCount(0);
        getAdsImage();
      }
    }

    setState(() {
      saveFirstRun(true);
    });

    return await Geolocator.getCurrentPosition();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        loading = false;
        //_currentPosition = position;
        lat = position.latitude;
        lng = position.longitude;
        saveLatitude(lat);
        saveLongitude(lng);
        getAddress(screen, lat, lng);
      });
    }).catchError((e) {
      print(e);
    });
  }

  getAddress(screen, double lat, double lng) async {
    printMessage(screen, "lat : $lat\nlng : $lng");

    if (lat != 0) {
      List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.length != 0) {
        setState(() {
          district = "${placemarks[0].subAdministrativeArea}";
          currentState = "${placemarks[0].administrativeArea}";

          currentAddress = "$district, $currentState";

          savelocState(currentState);
        });
      }
    }
  }

  Future getInvestorKycStatus() async {
    setState(() {
      centerLoading = true;
    });

    var mobile = await getMobile();
    var pan = await getPANNo();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "mobile": mobile,
    };

    printMessage(screen, "investor body : $body");

    final response = await http.post(Uri.parse(investorKycStatusAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Investor : $data");

      setState(() {
        centerLoading = false;
        var statusCode = response.statusCode;
        if (statusCode == 200) {
          if (data['status'].toString() == "1") {
            if (data['profile_data']['account_no'].toString() == "" ||
                data['profile_data']['account_no'].toString() == "null") {
              openInvestorBankDetail(context, pan);
            } else {
              openInvestorLanding(context);
            }
          } else if (data['status'].toString() == "3") {
            openInvestorDocument(context, pan);
          } else if (data['status'].toString() == "2") {
            openInvestorOnboarding(context);
          } else {
            showToastMessage(data['message'].toString());
          }
        }
      });
    } else {
      setState(() {
        centerLoading = false;
      });
      showToastMessage(status500);
    }
  }

  bool isAdult(String birthDateString) {
    String datePattern = "dd-MM-yyyy";

    // Current time - at this moment
    DateTime today = DateTime.now();

    // Parsed date to check
    DateTime birthDate = DateFormat(datePattern).parse(birthDateString);

    // Date to check but moved 18 years ahead
    DateTime adultDate = DateTime(
      birthDate.year + 18,
      birthDate.month,
      birthDate.day,
    );
    return adultDate.isBefore(today);
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
                        height: 10,
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

    getUserAllDetails();
  }

  Future generateAEPSToken(outId) async {
    setState(() {
      centerLoading = true;
    });

    var url = "https://cyrusrecharge.in/api/AepsBank.aspx";

    var body = {
      "MerchantID": "AP469556",
      "MerchantKey": "Rst5XLNsdjaWg1BbwXbUzo7IoZAmvCd1NlyQYhs/wBg=",
      "MethodName": "GETTOKEN",
      "OutLetID": "$outId"
    };

    final response = await http.post(Uri.parse(url), body: (body));

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "AEPS Code : $data");

    setState(() {
      var statuscode = data['statuscode'];

      if (statuscode.toString() == "TXN") {
        var AuthoKey = data['data']['AuthoKey'].toString();
        printMessage(screen, "AuthoKey : $AuthoKey");
        userAEPSKyc(outId, AuthoKey);
      }
    });
  }

  Future userAEPSKyc(outId, AuthoKey) async {
    setState(() {});

    var mId = await getMerchantID();
    var pan = await getPANNo();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "m_id": "$mId",
      "pan": "$pan",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(getKycAepsAPI),
        body: jsonEncode(body), headers: headers);

    setState(() {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Data Response : $data");
      if (data['status'].toString() == "1") {
        _moveToAEPS(AuthoKey);
      } else if (data['status'].toString() == "4") {
        showToastMessage("Your KYC is under process.");
      } else {
        openAEPSDocument(context, pan);
      }

      centerLoading = false;
    });
  }

  _moveToAEPS(key) async {
    var mobile = await getMobile();
    var email = await getEmail();

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "authKey": "$key",
        "message": "Hello How are you?",
        "mobile": "$mobile",
        "email": "$email"
      };

      String result = await platform.invokeMethod("aepsCall", arr);
      printMessage(screen, "AEPS Response : $result");

      if (result.toString() == "null") {
        //openTimePass(context, result.toString());
      } else {
        var json = jsonDecode(result);
        printMessage(screen, "Reg json : $json");
      }
    }
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
          Navigator.pop(context);
          showToastMessage(data['message'].toString());
          // openATMOnBoarding(context);
        }
      });
    }
  }

  Future getATMAuthToken(aepsTxnId) async {
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

    printMessage(screen, "MATM Response : $data");

    setState(() {
      Navigator.pop(context);
      if (data['isSuccess'].toString() == "true") {
        var authToken = data['data']['token'].toString();
        printMessage(screen, "Auth Token : $authToken");
        checkKycStatus(authToken, aepsTxnId);
      } else {
        showToastMessage("Something went wrong. Please after sometime");
      }
    });
  }

  Future checkKycStatus(authToken, aepsTxnId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, checking your KYC status");
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
            _moveToMATM(authToken, aepsTxnId);
          } else if (statusCode == "PK") {
            Navigator.of(context).pop();
            _moveToMATM(authToken, aepsTxnId);
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
          Navigator.pop(context);
          showToastMessage(data['message'].toString());
          openATMOnBoarding(context);
        }
      });
    }
  }

  _moveToMATM(authToken, aepsTxnId) async {
    String result = "";
    var merchantId = await getMATMMerchantId();
    var merchantEmailId = await getEmail();
    var merchantMobileNo = await getMobile();

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "merchantId": "$merchantId",
        "merchantEmailId": "$merchantEmailId",
        "merchantMobileNo": "$merchantMobileNo",
        "token": "$authToken",
        "enryptdecryptKey": "$atmEncDecKey",
        "pipe": "ICICI",
        "partnerRefId": "$aepsTxnId"
      };

      printMessage(screen, "Calling SKD : $arr");
      result = await platform.invokeMethod("moveATM", arr);
    }

    printMessage(screen, "Reg : $result");
    _setMATMResults(result, aepsTxnId);
  }

  _setMATMResults(result, aepsTxnId) {
    var json = jsonDecode(result);

    var message = json['message'];
    var sts = json['sts'];

    if (message.toString() == "Success") {
      var txnType = json['txnType'];

      printMessage(screen, "Tans Type : $txnType");

      var amount = json['transactionAmount'].toString();
      var balanceAmount = json['balanceAmount'].toString();
      var cardNo = json['cardNo'].toString();
      var terminalId = json['terminalId'].toString();
      var txnDate = json['txnDate'].toString();
      var txnId = json['txnId'].toString();
      var bankName = json['bankName'].toString();
      var partnerRefId = json['partnerRefId'].toString();
      var merchantMobileNo = json['merchantMobileNo'].toString();
      var cardType = json['cardType'].toString();
      var rrn = json['rrn'].toString();

      Map p = {
        "message": "Transaction Success",
        "date": "$txnDate",
        "bankName": "$bankName",
        "cardNo": "$cardNo",
        "cardType": "$cardType",
        "txnType": "$txnType",
        "amount": "$amount",
        "refId": "$partnerRefId",
        "transId": "$txnId",
        "terminalId": "$terminalId",
        "mobile": "$merchantMobileNo",
        "balanceAmount": "$balanceAmount",
        "rrn": "$rrn",
        "txnid": "$aepsTxnId"
      };
      openTransactionRecpit(context, p);
    } else {
      if (sts.toString() != "1008") {
        var amount = json['data'][0]['amount'];
        var cardNo = json['data'][0]['cardNo'];
        var cardType = json['data'][0]['cardType'];
        var txnDate = json['data'][0]['txnDate'];
        var bankName = json['data'][0]['bankName'];
        var txnCode = json['data'][0]['txnCode'];
        var rrn = json['data'][0]['rrn'];
        var terminalId = json['data'][0]['terminalId'];
        var partnerRefId = json['data'][0]['partnerRefId'];
        var merchantMobileNo = json['data'][0]['merchantMobileNo'];
        var txnId = json['txnId'].toString();

        Map p = {
          "message": "Transaction Failed",
          "date": "$txnDate",
          "bankName": "$bankName",
          "cardNo": "$cardNo",
          "cardType": "$cardType",
          "txnType": "$txnCode",
          "amount": "$amount",
          "refId": "$partnerRefId",
          "transId": "$txnId",
          "terminalId": "$terminalId",
          "mobile": "$merchantMobileNo",
          "balanceAmount": "",
          "rrn": "$rrn",
          "txnid": "$aepsTxnId"
        };
        openTransactionRecpit(context, p);
      }
      showToastMessage(message);
    }
  }

  _appDrawerMerchant(profilePic) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      //openProfile(context, profilePic, profilePicId);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (profilePic.toString() == "")
                              ? Image.asset(
                                  'assets/profile.png',
                                  height: 40.h,
                                )
                              : Container(
                                  height: 50.h,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    color: white, // border color
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.network(profilePic,
                                        height: 50.h, fit: BoxFit.fill),
                                  )),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nameChar,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  mobileChar,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: font13.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: lightBlue),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                        top: 3,
                                        bottom: 3),
                                    child: Text(
                                      roleType,
                                      style: TextStyle(
                                          fontSize: font11.sp, color: white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openProfile(context, profilePic, profilePicId);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/ic_dummy_user.png',
                              height: 18.h,
                              width: 18.w,
                              color: lightBlue,
                            ),
                          ),
                          Text(
                            "My Profile",
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openViewQRCode(context, 0);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/qr_menu.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            myQRCode,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openRequestQR(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/req_qr.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            requestQR,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/upi_menu.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            myUPIId,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  (branchCreate.toString() == "0")
                      ? Container()
                      : Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                              left: 20, right: 10, bottom: 10, top: 0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              openMerchantBranch(context, isManagerShow);
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 10,
                                      bottom: 10,
                                      right: 15),
                                  child: Image.asset(
                                    'assets/ic_branch_office.png',
                                    height: 18.h,
                                    width: 18.w,
                                    color: lightBlue,
                                  ),
                                ),
                                Text(
                                  "Branches",
                                  style: TextStyle(
                                      color: black, fontSize: font15.sp),
                                )
                              ],
                            ),
                          ),
                        ),
                  (isManagerShow)
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                              left: 20, right: 10, bottom: 10, top: 0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              openManagerBranchTranactions(context);
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 10,
                                      bottom: 10,
                                      right: 15),
                                  child: Image.asset(
                                    'assets/ic_branch_office.png',
                                    height: 18.h,
                                    width: 18.w,
                                    color: lightBlue,
                                  ),
                                ),
                                Text(
                                  "Branch Transactions",
                                  style: TextStyle(
                                      color: black, fontSize: font15.sp),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/notification_menu.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            notification,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        if (teams.length == 0) {
                          openAddTeamIntro(context);
                        } else {
                          openTeamMemberList(context);
                        }
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/addTeam.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            addTeam,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openUpdatePin(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/change_pin.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            changePin,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openComplaintManagement(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/complain.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            complaint,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openShowWebViews(context, mpPrivacyPolicyUrl);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/ploicy.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            policyTerms,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, right: 10, bottom: 10, top: 0),
            child: InkWell(
              onTap: () {
                // Navigator.pop(context);
                LogoutPopup();
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10, bottom: 10, right: 15),
                    child: Image.asset(
                      'assets/exit.png',
                      height: 18.h,
                      width: 18.w,
                    ),
                  ),
                  Text(
                    logout,
                    style: TextStyle(
                        color: lightBlack,
                        fontSize: font15.sp,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appDrawerUser(profilePic) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 40.h),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      //openProfile(context, profilePic, profilePicId);
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 20),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (profilePic.toString() == "")
                              ? Image.asset(
                                  'assets/profile.png',
                                  height: 40.h,
                                )
                              : Container(
                                  height: 50.h,
                                  width: 50.w,
                                  decoration: BoxDecoration(
                                    color: white, // border color
                                    shape: BoxShape.circle,
                                  ),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(16.0),
                                    child: Image.network(profilePic,
                                        height: 50.h, fit: BoxFit.fill),
                                  )),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nameChar,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Text(
                                  mobileChar,
                                  style: TextStyle(
                                    color: black,
                                    fontSize: font13.sp,
                                  ),
                                ),
                                SizedBox(
                                  height: 2.h,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(10)),
                                      color: lightBlue),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10.0,
                                        top: 3,
                                        bottom: 3),
                                    child: Text(
                                      roleType,
                                      style: TextStyle(
                                          fontSize: font11.sp, color: white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 20),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openProfile(context, profilePic, profilePicId);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/ic_dummy_user.png',
                              height: 18.h,
                              width: 18.w,
                              color: lightBlue,
                            ),
                          ),
                          Text(
                            "My Profile",
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/upi_menu.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            myUPIId,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  (isManagerShow)
                      ? Container(
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                              left: 20, right: 10, bottom: 10, top: 0),
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
                              openMerchantBranch(context, isManagerShow);
                            },
                            child: Row(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0,
                                      top: 10,
                                      bottom: 10,
                                      right: 15),
                                  child: Image.asset(
                                    'assets/ic_branch_office.png',
                                    height: 18.h,
                                    width: 18.w,
                                    color: lightBlue,
                                  ),
                                ),
                                Text(
                                  "Branch Transactions",
                                  style: TextStyle(
                                      color: black, fontSize: font15.sp),
                                )
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/notification_menu.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            notification,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 20, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openUpdatePin(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/change_pin.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            changePin,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openComplaintManagement(context);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/complain.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            complaint,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        left: 10, right: 10, bottom: 10, top: 0),
                    child: InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openShowWebViews(context, mpPrivacyPolicyUrl);
                      },
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 10, bottom: 10, right: 15),
                            child: Image.asset(
                              'assets/ploicy.png',
                              height: 18.h,
                              width: 18.w,
                            ),
                          ),
                          Text(
                            policyTerms,
                            style: TextStyle(color: black, fontSize: font15.sp),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(left: 20, right: 10, bottom: 10, top: 0),
            child: InkWell(
              onTap: () {
                // Navigator.pop(context);
                LogoutPopup();
              },
              child: Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10.0, top: 10, bottom: 10, right: 15),
                    child: Image.asset(
                      'assets/exit.png',
                      height: 18.h,
                      width: 18.w,
                    ),
                  ),
                  Text(
                    logout,
                    style: TextStyle(
                        color: lightBlack,
                        fontSize: font15.sp,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  _appDrawerEmpolyee(profilePic) {
    return StatefulBuilder(
        builder: (BuildContext context, StateSetter setState) {
      return Drawer(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 40.h),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        //openProfile(context, profilePic, profilePicId);
                      },
                      child: Padding(
                        padding: EdgeInsets.only(left: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            (profilePic.toString() == "")
                                ? Image.asset(
                                    'assets/profile.png',
                                    height: 40.h,
                                  )
                                : Container(
                                    height: 50.h,
                                    width: 50.w,
                                    decoration: BoxDecoration(
                                      color: white, // border color
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(16.0),
                                      child: Image.network(profilePic,
                                          height: 50.h, fit: BoxFit.fill),
                                    )),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    nameChar,
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Text(
                                    mobileChar,
                                    style: TextStyle(
                                      color: black,
                                      fontSize: font13.sp,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 2.h,
                                  ),
                                  Container(
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        color: lightBlue),
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10.0,
                                          right: 10.0,
                                          top: 3,
                                          bottom: 3),
                                      child: Text(
                                        roleType,
                                        style: TextStyle(
                                            fontSize: font11.sp, color: white),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: 15.w,
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 20, right: 10, bottom: 10, top: 20),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          openProfile(context, profilePic, profilePicId);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 10, right: 15),
                              child: Image.asset(
                                'assets/ic_dummy_user.png',
                                height: 18.h,
                                width: 18.w,
                                color: lightBlue,
                              ),
                            ),
                            Text(
                              "My Profile",
                              style:
                                  TextStyle(color: black, fontSize: font15.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 20, right: 10, bottom: 10, top: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 10, right: 15),
                              child: Image.asset(
                                'assets/upi_menu.png',
                                height: 18.h,
                                width: 18.w,
                              ),
                            ),
                            Text(
                              myUPIId,
                              style:
                                  TextStyle(color: black, fontSize: font15.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                    /*Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 20, right: 10, bottom: 10, top: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          openMyAddress(context);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 10, right: 15),
                              child: Image.asset(
                                'assets/my_address.png',
                                height: 18.h,
                                width: 18.w,
                              ),
                            ),
                            Text(
                              myAddress,
                              style: TextStyle(color: black, fontSize: font15.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 20, right: 10, bottom: 10, top: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          openBankAccount(context);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 10, right: 15),
                              child: Image.asset(
                                'assets/bank.png',
                                height: 18.h,
                                width: 18.w,
                              ),
                            ),
                            Text(
                              manageBankAccount,
                              style: TextStyle(color: black, fontSize: font15.sp),
                            )
                          ],
                        ),
                      ),
                    ),*/
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 20, right: 10, bottom: 10, top: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 10, right: 15),
                              child: Image.asset(
                                'assets/notification_menu.png',
                                height: 18.h,
                                width: 18.w,
                              ),
                            ),
                            Text(
                              notification,
                              style:
                                  TextStyle(color: black, fontSize: font15.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 20, right: 10, bottom: 10, top: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          openUpdatePin(context);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 10, right: 15),
                              child: Image.asset(
                                'assets/change_pin.png',
                                height: 18.h,
                                width: 18.w,
                              ),
                            ),
                            Text(
                              changePin,
                              style:
                                  TextStyle(color: black, fontSize: font15.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                    /*Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 20, right: 10, bottom: 10, top: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, top: 10, bottom: 10, right: 15),
                              child: Image.asset(
                                'assets/fingerprint.png',
                                height: 18.h,
                                width: 18.w,
                              ),
                            ),
                            Text(
                              screenLock,
                              style: TextStyle(color: black, fontSize: font15.sp),
                            ),
                            Spacer(),
                            FlutterSwitch(
                                width: 55.0,
                                height: 24.0,
                                valueFontSize: 14.0,
                                toggleSize: 24.0,
                                activeText: "",
                                inactiveText: "",
                                value: _fingerPrint,
                                borderRadius: 30.0,
                                padding: 4.0,
                                showOnOff: true,
                                onToggle: (value) {
                                  setState(() {
                                    _fingerPrint = value;
                                    saveFingerprint(_fingerPrint);
                                  });
                                }),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                      ),
                    ),*/
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          openComplaintManagement(context);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, top: 10, bottom: 10, right: 15),
                              child: Image.asset(
                                'assets/complain.png',
                                height: 18.h,
                                width: 18.w,
                              ),
                            ),
                            Text(
                              complaint,
                              style:
                                  TextStyle(color: black, fontSize: font15.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                    (isManagerShow)
                        ? Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                left: 20, right: 10, bottom: 10, top: 0),
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                openMerchantBranch(context, isManagerShow);
                              },
                              child: Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        top: 10,
                                        bottom: 10,
                                        right: 15),
                                    child: Image.asset(
                                      'assets/ic_branch_office.png',
                                      height: 18.h,
                                      width: 18.w,
                                      color: lightBlue,
                                    ),
                                  ),
                                  Text(
                                    "Branch Transactions",
                                    style: TextStyle(
                                        color: black, fontSize: font15.sp),
                                  )
                                ],
                              ),
                            ),
                          )
                        : Container(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          openShowWebViews(context, mpPrivacyPolicyUrl);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, top: 10, bottom: 10, right: 15),
                              child: Image.asset(
                                'assets/ploicy.png',
                                height: 18.h,
                                width: 18.w,
                              ),
                            ),
                            Text(
                              policyTerms,
                              style:
                                  TextStyle(color: black, fontSize: font15.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          left: 10, right: 10, bottom: 10, top: 0),
                      child: InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          openEmployeeLanding(context);
                        },
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, top: 10, bottom: 10, right: 15),
                              child: Image.asset(
                                'assets/emp_icon.png',
                                height: 18.h,
                                width: 18.w,
                              ),
                            ),
                            Text(
                              empSection,
                              style:
                                  TextStyle(color: black, fontSize: font15.sp),
                            )
                          ],
                        ),
                      ),
                    ),
                    Divider(),
                  ],
                ),
              ),
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(left: 20, right: 10, bottom: 10, top: 0),
              child: InkWell(
                onTap: () {
                  // Navigator.pop(context);
                  LogoutPopup();
                },
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10, bottom: 10, right: 15),
                      child: Image.asset(
                        'assets/exit.png',
                        height: 18.h,
                        width: 18.w,
                      ),
                    ),
                    Text(
                      logout,
                      style: TextStyle(
                          color: lightBlack,
                          fontSize: font15.sp,
                          fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    });
  }

  Future getTeamList() async {
    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "token": "$token",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(memberListAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Add Team Response : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          var result =
              TeamMember.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          teams = result.teams;
        }
      });
    }
  }

  noInternetPopup() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: white,
        builder: (context) => NoInternet());
  }

  shopPermissionPopup() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: false,
        backgroundColor: white,
        builder: (context) => SafeArea(
              child: Scaffold(
                backgroundColor: white,
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 100.h,
                      ),
                      appLogo(),
                      Card(
                        elevation: 10,
                        margin: EdgeInsets.only(
                            left: 20, top: 20, right: 20, bottom: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Container(
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Text(
                              "We take the following permission to ensure a safe & enjoyable experience for you",
                              style:
                                  TextStyle(color: black, fontSize: font16.sp),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.contacts,
                              color: lightBlue,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Contact (mandatory)",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "We need this permission to get your contact list for Recharge, bill payment etc.",
                                    style: TextStyle(
                                        color: lightBlack, fontSize: font14.sp),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.location_on,
                              color: lightBlue,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Location (mandatory)",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "We need this permission to while doing AEPS, MATM, DTM transactions",
                                    style: TextStyle(
                                        color: lightBlack, fontSize: font14.sp),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.sms,
                              color: lightBlue,
                            ),
                            SizedBox(
                              width: 10.w,
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Bluetooth (mandatory)",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font16.sp,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "We need this permission for connect MATM devices for transactions",
                                    style: TextStyle(
                                        color: lightBlack, fontSize: font14.sp),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                bottomNavigationBar: InkWell(
                  onTap: () {
                    Navigator.pop(context);
                    _determineSecondPosition();
                    _getCurrentLocation();
                  },
                  child: Wrap(
                    children: [
                      Center(
                        child: Text(
                          "By continuing, agree to our Trems & Conditions and Privacy Policy",
                          style:
                              TextStyle(color: lightBlack, fontSize: font13.sp),
                        ),
                      ),
                      Container(
                        height: 45.h,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 10, left: 25, right: 25, bottom: 10),
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Center(
                          child: Text(
                            "Let's Go".toUpperCase(),
                            style: TextStyle(fontSize: font16.sp, color: white),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ));
  }

  LogoutPopup() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Center(
              child: Wrap(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(25.0),
                    child: Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.only(
                              left: padding,
                              top: avatarRadius + padding,
                              right: padding,
                              bottom: padding),
                          margin: EdgeInsets.only(top: avatarRadius),
                          decoration: BoxDecoration(
                              shape: BoxShape.rectangle,
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(padding),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black,
                                    offset: Offset(0, 10),
                                    blurRadius: 10),
                              ]),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "Are you sure to exit the app?",
                                style: TextStyle(
                                    fontSize: 22.sp,
                                    fontWeight: FontWeight.w600),
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              SizedBox(
                                height: 15.h,
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 15.0, right: 15),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: Container(
                                          child: Text(
                                            "Cancel",
                                            style: TextStyle(fontSize: 18.sp),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: InkWell(
                                        onTap: () {
                                          userLogout(context);
                                        },
                                        child: Container(
                                          height: 30.h,
                                          child: Text(
                                            "Exit",
                                            style: TextStyle(fontSize: 18.sp),
                                            textAlign: TextAlign.end,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10.h,
                              ),
                            ],
                          ),
                        ),
                        Positioned(
                          left: padding,
                          right: padding,
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: avatarRadius,
                            child: ClipRRect(
                                borderRadius: BorderRadius.all(
                                    Radius.circular(avatarRadius)),
                                child: Image.asset("assets/stop.png")),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ));
  }

  Future userLogout(context) async {
    // print('inside function ');
    setState(() {
      centerLoading = true;
    });

    final token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };
    final body = {
      "token": token,
    };

    final response = await http.post(Uri.parse(logoutAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage("Logout Function", "data : ${data}");

    setState(() {
      centerLoading = false;
      removeAllPrefs();
      removeAllPageForLogout(context);
    });
  }

  Future getMATMTxnId() async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();
    var mId = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    var body = {"user_token": "$userToken", "m_id": "$mId"};

    printMessage(screen, "Body : $body");

    final response = await http.post(Uri.parse(matmAppTxnStatusAPI),
        headers: headers, body: jsonEncode(body));

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Update Response : $data");

    setState(() {
      Navigator.pop(context);
      if (data['status'].toString() == "1") {
        var aepsTxnId = data['txn_id'].toString();
        getATMAuthToken(aepsTxnId);
      }
    });
  }

  /*Future getManagerTxn() async {
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    var mobile = await getMobile();

    final body = {
      "mobile": "$mobile",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchManagerTxnListAPI),
        body: jsonEncode(body), headers: headers);

    var statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Manager Transaction : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          isManagerShow = true;
        } else {
          isManagerShow = false;
        }
      });
    } else {
      setState(() {
        isManagerShow = false;
      });
    }
  }*/

  Future getAdsImage() async {
    int adsCount = await getAdsCount();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response = await http.post(Uri.parse(adsBannerAPI), headers: headers);

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Ads Image : ${data}");
        if (data['status'].toString() == "1") {
          var image = data['ads_list'][0]['image'].toString();
          var location = data['ads_list'][0]['location'].toString();

          saveAdsCount(adsCount + 1);

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ShowAds(
                    logo: image,
                    location: location,
                    role: "$role",
                    kycStatus: "$kycStatus");
              });
        }
      }
    });
  }

  Future getBannerImage() async {
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response = await http.post(Uri.parse(bannerImgAPI), headers: headers);

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Banner Image Response : ${data}");
        if (data['status'].toString() == "1") {
          var result =
              Banners.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          bannerList = result.bannerList;
        }
      }
    });
  }

  _buildMerchantDetails() {
    return Column(
      children: [
        InkWell(
          onTap: () {
            openProfile(context, profilePic, profilePicId);
          },
          child: Card(
            elevation: 4.0,
            margin: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            child: Container(
              height: 180.h,
              padding:
                  const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 22.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Color(0xFF330066),
                    Color(0xFF330099),
                    Color(0xFF3300CC),
                  ],
                  begin: Alignment.bottomLeft,
                  end: Alignment.topRight,
                ),
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 12.0),
                    child: Row(
                      children: [
                        Image.asset(
                          "assets/contact_less.png",
                          height: 20.h,
                          width: 18.w,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Text(
                          "My Account Details",
                          style: TextStyle(
                            color: white,
                            fontSize: font16.sp,
                          ),
                        )
                      ],
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'A/c Name',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: font13.sp,
                            ),
                          ),
                          Text(
                            '$virtualCompanyName',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: font16.sp,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'A/c No.',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: font13.sp,
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                '$virtualAccountNumber',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: font16.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            )
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              'IFSC Code',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: font13.sp,
                              ),
                            ),
                            Text(
                              '$virtualAccountIfscCode',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: font16.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Avbl Balc.',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: font13.sp,
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                '$rupeeSymbol ',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: font13.sp,
                                ),
                              ),
                              Text(
                                '${formatDecimal2Digit.format(avblBalc)}',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: font18.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        (role.toString() == "3")
            ? Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        if (approved.toString() == "1") {
                          openMoneyTransferLanding(context);
                        } else {
                          showToastMessage(notApproved);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 24.h,
                              width: 24.w,
                              child: Image.asset(
                                'assets/transfer_rupee.png',
                                color: white,
                                width: 24.w,
                                height: 24.h,
                              )),
                          Text(
                            "Transfer Money",
                            style: TextStyle(color: white, fontSize: font14.sp),
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
                          openTransactionHistory(context, "", "");
                        } else {
                          openTransactionHistoryEmpUser(context);
                        }
                      },
                      child: Column(
                        children: [
                          Container(
                              height: 24.h,
                              width: 24.w,
                              child: Image.asset(
                                'assets/passbook.png',
                                color: white,
                                width: 24.w,
                                height: 24.h,
                              )),
                          Text(
                            "Passbook",
                            style: TextStyle(color: white, fontSize: font14.sp),
                          ),
                        ],
                      ),
                    ),
                  ),
                  (isShowInvestor || isShowMPWallet)
                      ? Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              openWithdrwal(context, isShowMPWallet,
                                  isShowInvestor, totalEarning);
                            },
                            child: Column(
                              children: [
                                Container(
                                    height: 24.h,
                                    width: 24.w,
                                    child: Image.asset(
                                      'assets/with_rup_atm.png',
                                      color: white,
                                      width: 24.w,
                                      height: 24.h,
                                    )),
                                Text(
                                  "Withdrawal",
                                  style: TextStyle(
                                      color: white, fontSize: font14.sp),
                                ),
                              ],
                            ),
                          ),
                        )
                      : Expanded(flex: 1, child: Container()),
                ],
              )
            : Container(),
      ],
    );
  }
}

Future<void> showNotification(title, msg, _audioSound) async {
  var lTy = await getLngType();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/applogo');
  printMessage("showNotification", "Lang Type : $lTy");

  var androidPlatformChannelSpecifics = new AndroidNotificationDetails(
    "com.moneyproapp",
    "MP Android",
    "com.moneyproapp",
    playSound: true,
    importance: Importance.max,
    color: Colors.blue,
    priority: Priority.high,
  );

  var iOSPlatformChannelSpecifics =
      new IOSNotificationDetails(presentSound: false);
  var platformChannelSpecifics = new NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: iOSPlatformChannelSpecifics);

  if (title.toString() == "UPI QR" && _audioSound) {
    var translation =
        await translator.translate("$msg", from: 'en', to: '$lTy');
    printMessage("showNotification", "translation : $translation");
    FlutterTts flutterTts = FlutterTts();
    flutterTts.speak(translation.toString());
    Navigator.push(
        StateContainer.navigatorKey.currentState!.context,
        MaterialPageRoute(
          builder: (context) => Perspective(isShowWelcome: false),
        ));
  }

  await flutterLocalNotificationsPlugin.show(
    randNumber(),
    title,
    msg,
    platformChannelSpecifics,
    payload: "This is payload message",
  );
}
