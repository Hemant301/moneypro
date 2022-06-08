import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/AEPS.dart';
import 'package:moneypro_new/ui/models/BBPSTransaction.dart';
import 'package:moneypro_new/ui/models/DMTTransactions.dart';
import 'package:moneypro_new/ui/models/History.dart';
import 'package:moneypro_new/ui/models/MATMTransactions.dart';
import 'package:moneypro_new/ui/models/Settelments.dart';
import 'package:moneypro_new/ui/models/WalletTransactions.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:moneypro_new/utils/custom_popup/popup_menu.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


List<QrResponse> qrResponse = [];

class TransactionHistoryEmpUser extends StatefulWidget {
  const TransactionHistoryEmpUser({Key? key}) : super(key: key);

  @override
  _TransactionHistoryEmpUserState createState() =>
      _TransactionHistoryEmpUserState();
}

class _TransactionHistoryEmpUserState extends State<TransactionHistoryEmpUser>
    with SingleTickerProviderStateMixin {
  var screen = "Trans User History";

  var loading1 = false;
  var loading2 = false;

  var loading5 = false;
  var loading6 = false;

  final List<Tab> tabs = <Tab>[
    new Tab(text: "Wallet"),
    new Tab(text: "DMT"),
    new Tab(text: "Others"),
  ];

  TabController? _tabController;

  var walletBal;

  final searchTrans = new TextEditingController();

  int headerIndex = 0;
  int selectedIndex = 1;
  var selectCatPos;

  List<BBPSTransaction> othersTransactions = [];
  List<BBPSTransaction> othersFiltersTransactions = [];

  List<WalletList> walletList = [];
  List<RequestList> settlementList = [];
  List<DMTList> dmtTransactions = [];

  var showSearchResult = false;

  bool isReload = false;
  int pageOtherNo = 1;
  int otherTotalPage = 0;
  late ScrollController scrollOtherController;

  bool isWalletReload = false;
  int pageWalletNo = 1;
  int walletTotalPage = 0;
  late ScrollController scrollWalletController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    scrollOtherController = new ScrollController()
      ..addListener(_scrollListener);
    scrollWalletController = new ScrollController()
      ..addListener(_scrollWalletListener);
    fetchUserAccountBalance();
    _tabController = new TabController(vsync: this, length: tabs.length);
    getWalletTransactions(pageWalletNo);
    updateATMStatus(context);
    updateWalletBalances();
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
      walletBal = wX + mX;
    });
  }

  void _scrollListener() {
    if (pageOtherNo <= otherTotalPage) {
      if (scrollOtherController.position.extentAfter < 500) {
        setState(() {
          isReload = true;
          if (isReload) {
            isReload = false;
            pageOtherNo = pageOtherNo + 1;
            getOthersReloadTransactions(pageOtherNo);
          }
        });
      }
    }
  }

  void _scrollWalletListener() {
    if (pageWalletNo <= walletTotalPage) {
      if (scrollWalletController.position.extentAfter < 500) {
        setState(() {
          isReload = true;
          if (isReload) {
            isReload = false;
            pageWalletNo = pageWalletNo + 1;
            getWalletTransactionsOnScroll(pageWalletNo);
          }
        });
      }
    }
  }

  @override
  void dispose() {
    searchTrans.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder:()=> SafeArea(
        child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
                elevation: 10,
                centerTitle: false,
                backgroundColor: white,
                brightness: Brightness.light,
                leading: IconButton(
                  icon: Container(
                    height: 24.0.h,
                    child: Icon(
                      Icons.arrow_back,
                      color: black,
                    ),
                  ),
                  onPressed: () {
                    closeKeyBoard(context);
                    closeCurrentPage(context);
                  },
                ),
                titleSpacing: -10,
                title: appLogo(),
                actions: <Widget>[
                  InkWell(
                    onTap: () {
                      closeKeyBoard(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 15.0, top: 10, bottom: 10, right: 15),
                      child: Image.asset(
                        "assets/faq.png",
                        height: 24.h,
                        color: orange,
                      ),
                    ),
                  ),
                  (headerIndex == 5)
                      ? Padding(
                          padding: const EdgeInsets.only(
                              right: 10.0, top: 10, bottom: 10),
                          child: Image.asset(
                            "assets/bbps_2.png",
                            height: 20.h,
                          ),
                        )
                      : Container()
                ],
                bottom: new TabBar(
                  isScrollable: false,
                  unselectedLabelColor: black,
                  labelColor: white,
                  labelStyle: TextStyle(fontSize: font14),
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: new BubbleTabIndicator(
                    indicatorHeight: 25.0,
                    indicatorColor: lightBlue,
                    tabBarIndicatorSize: TabBarIndicatorSize.tab,
                    // Other flags
                    // indicatorRadius: 1,
                    // insets: EdgeInsets.all(1),
                    // padding: EdgeInsets.all(10)
                  ),
                  tabs: tabs,
                  controller: _tabController,
                  onTap: (val) {
                    printMessage(screen, "Tab on : $val");

                    setState(() {
                      headerIndex = val;
                    });

                    if (val == 0) {
                      // default call here
                    }
                    /*else if (val == 1) {
                      // UPI QR response here
                      getQRTransactions();
                    }*/
                    else if (val == 1) {
                      //calling DMT response here
                      if (dmtTransactions.length == 0) getDMTTransactions(0);
                    } else if (val == 2) {
                      // Other response here
                      if (othersTransactions.length == 0)
                        getOthersTransactions(pageOtherNo);
                    }
                  },
                )),
            body: TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildWalletHistory(),
                //_buildUPIHistory(),
                _buildDMTHistory(),
                _buildOtherHistory(),
              ],
            ))));
  }

  _buildWalletHistory() {
    return (loading1)
        ? Center(
            child: circularProgressLoading(40.0),
          )
        : SingleChildScrollView(
            controller: scrollWalletController,
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                (walletList.length == 0)
                    ? NoDataFound(text: "No result found")
                    : Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 10),
                        child: ListView.builder(
                            itemCount: walletList.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {
                                  if (walletList[index].heading.toString() ==
                                      "Moneypro-Wallet| Withdrawal") {
                                    //
                                    var transId =
                                        walletList[index].transctionId;

                                    Map map = {
                                      "type": "${walletList[index].type}",
                                      "date": "${walletList[index].date}",
                                      "time": "${walletList[index].time}",
                                      "transId":
                                          "${walletList[index].transctionId}",
                                      "heading": "${walletList[index].heading}",
                                      "description":
                                          "${walletList[index].description}",
                                      "txn_amnt":
                                          "${walletList[index].txnAmnt}",
                                      "txn_bal": "${walletList[index].txnBal}",
                                    };

                                    generatePayoutToken(transId, map);
                                  }
                                },
                                child: Column(
                                  children: [
                                    (walletList[index]
                                                    .headingS
                                                    .toString() ==
                                                "null" ||
                                            walletList[index]
                                                    .commission
                                                    .toString() ==
                                                "0" ||
                                            walletList[index]
                                                    .commission
                                                    .toString() ==
                                                "0.00" ||
                                            walletList[index]
                                                    .commission
                                                    .toString() ==
                                                "0.0" ||
                                            walletList[index]
                                                    .commission
                                                    .toString() ==
                                                "")
                                        ? Container()
                                        : Container(
                                            margin: EdgeInsets.only(top: 10),
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                                color: white,
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(20)),
                                                border:
                                                    Border.all(color: gray)),
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0,
                                                  right: 20,
                                                  top: 10,
                                                  bottom: 10),
                                              child: Row(
                                                children: [
                                                  Container(
                                                      height: 45.h,
                                                      width: 45.w,
                                                      decoration: BoxDecoration(
                                                        color:
                                                            boxBg, // border color
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Image.asset(
                                                          'assets/cell_phone.png',
                                                          color: lightBlue,
                                                        ),
                                                      )),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Column(
                                                      children: [
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15.0,
                                                                  right: 20,
                                                                  top: 0),
                                                          child: Row(
                                                            children: [
                                                              Text(
                                                                "$transId : ",
                                                                style: TextStyle(
                                                                    color:
                                                                        black,
                                                                    fontSize:
                                                                        font14.sp),
                                                              ),
                                                              Expanded(
                                                                child: Text(
                                                                  (walletList[index].transctionId.toString() ==
                                                                              "" ||
                                                                          walletList[index].transctionId.toString() ==
                                                                              "null")
                                                                      ? "Pending"
                                                                      : "${walletList[index].transctionId}",
                                                                  style: TextStyle(
                                                                      color:
                                                                          black,
                                                                      fontSize:
                                                                          font14.sp,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis),
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 15.0,
                                                                  right: 20,
                                                                  top: 2),
                                                          child: Row(
                                                            children: [
                                                              Expanded(
                                                                child: Text(
                                                                  (walletList[index]
                                                                              .date
                                                                              .toString() ==
                                                                          "null")
                                                                      ? "NA"
                                                                      : "${walletList[index].date} | ${walletList[index].time}",
                                                                  style: TextStyle(
                                                                      color:
                                                                          lightBlack,
                                                                      fontSize:
                                                                          font12.sp,
                                                                      overflow:
                                                                          TextOverflow
                                                                              .ellipsis),
                                                                  maxLines: 1,
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                        Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 10.0,
                                                                  right: 15,
                                                                  top: 5),
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            children: [
                                                              SizedBox(
                                                                width: 5.w,
                                                              ),
                                                              Expanded(
                                                                  child: Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Text(
                                                                    "${walletList[index].headingS}",
                                                                    style: TextStyle(
                                                                        color:
                                                                            lightBlue,
                                                                        fontSize:
                                                                            font14.sp),
                                                                  ),
                                                                  Text(
                                                                    "${walletList[index].descriptionS}",
                                                                    style: TextStyle(
                                                                        color:
                                                                            lightBlack,
                                                                        fontSize:
                                                                            font13.sp),
                                                                  ),
                                                                ],
                                                              )),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment.end,
                                                    children: [
                                                      Text(
                                                        (walletList[
                                                                            index]
                                                                        .commission
                                                                        .toString() ==
                                                                    "0" ||
                                                                walletList[
                                                                            index]
                                                                        .commission
                                                                        .toString() ==
                                                                    "0.00" ||
                                                                walletList[index]
                                                                        .commission
                                                                        .toString() ==
                                                                    "0.0" ||
                                                                walletList[index]
                                                                        .commission
                                                                        .toString() ==
                                                                    "")
                                                            ? ""
                                                            : "+ $rupeeSymbol ${walletList[index].commission}",
                                                        style: TextStyle(
                                                            color: orange,
                                                            fontSize: font13.sp),
                                                      ),
                                                      Text(
                                                        "Balance $rupeeSymbol ${walletList[index].comBal}",
                                                        style: TextStyle(
                                                            color: green,
                                                            fontSize: font13.sp),
                                                        textAlign:
                                                            TextAlign.center,
                                                      ),
                                                    ],
                                                  )
                                                ],
                                              ),
                                            ),
                                          ),
                                    Container(
                                      margin: EdgeInsets.only(top: 10),
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          border: Border.all(color: gray)),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 10.0,
                                            right: 20,
                                            top: 10,
                                            bottom: 10),
                                        child: Column(
                                          children: [
                                            Row(
                                              children: [
                                                Container(
                                                    height: 45.h,
                                                    width: 45.w,
                                                    decoration: BoxDecoration(
                                                      color:
                                                          boxBg, // border color
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Image.asset(
                                                        'assets/cell_phone.png',
                                                        color: lightBlue,
                                                      ),
                                                    )),
                                                Expanded(
                                                  flex: 1,
                                                  child: Column(
                                                    children: [
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 15.0,
                                                                right: 20,
                                                                top: 0),
                                                        child: Row(
                                                          children: [
                                                            Text(
                                                              "$transId : ",
                                                              style: TextStyle(
                                                                  color: black,
                                                                  fontSize:
                                                                      font14.sp),
                                                            ),
                                                            Expanded(
                                                              child: Text(
                                                                (walletList[index].transctionId.toString() ==
                                                                            "" ||
                                                                        walletList[index].transctionId.toString() ==
                                                                            "null")
                                                                    ? "Pending"
                                                                    : "${walletList[index].transctionId}",
                                                                style: TextStyle(
                                                                    color:
                                                                        black,
                                                                    fontSize:
                                                                        font14.sp,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                                maxLines: 1,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 15.0,
                                                                right: 20,
                                                                top: 2),
                                                        child: Row(
                                                          children: [
                                                            Expanded(
                                                              child: Text(
                                                                (walletList[index]
                                                                            .date
                                                                            .toString() ==
                                                                        "null")
                                                                    ? "NA"
                                                                    : "${walletList[index].date} | ${walletList[index].time}",
                                                                style: TextStyle(
                                                                    color:
                                                                        lightBlack,
                                                                    fontSize:
                                                                        font12.sp,
                                                                    overflow:
                                                                        TextOverflow
                                                                            .ellipsis),
                                                                maxLines: 1,
                                                              ),
                                                              flex: 1,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 10.0,
                                                                right: 15,
                                                                top: 5),
                                                        child: Row(
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            SizedBox(
                                                              width: 5.w,
                                                            ),
                                                            Expanded(
                                                                child: Column(
                                                              crossAxisAlignment:
                                                                  CrossAxisAlignment
                                                                      .start,
                                                              children: [
                                                                Text(
                                                                  "${walletList[index].heading}",
                                                                  style: TextStyle(
                                                                      color:
                                                                          lightBlue,
                                                                      fontSize:
                                                                          font14.sp),
                                                                ),
                                                                Text(
                                                                  "${walletList[index].description}",
                                                                  style: TextStyle(
                                                                      color:
                                                                          lightBlack,
                                                                      fontSize:
                                                                          font13.sp),
                                                                ),
                                                              ],
                                                            )),
                                                          ],
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.end,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Text(
                                                          (walletList[index]
                                                                      .type ==
                                                                  "Cr")
                                                              ? "+"
                                                              : "-",
                                                          style: TextStyle(
                                                              color: (walletList[
                                                                              index]
                                                                          .type ==
                                                                      "Cr")
                                                                  ? green
                                                                  : red,
                                                              fontSize: font18.sp),
                                                        ),
                                                        SizedBox(
                                                          width: 2.w,
                                                        ),
                                                        Text(
                                                          "$rupeeSymbol ${walletList[index].txnAmnt}",
                                                          style: TextStyle(
                                                              color: orange,
                                                              fontSize: font13.sp),
                                                        ),
                                                      ],
                                                    ),
                                                    Text(
                                                      (walletList[index]
                                                                      .transctionId
                                                                      .toString() ==
                                                                  "" ||
                                                              walletList[index]
                                                                      .transctionId
                                                                      .toString() ==
                                                                  "null")
                                                          ? "Balance $rupeeSymbol $walletBal"
                                                          : (walletList[index]
                                                                      .txnBal
                                                                      .toString() ==
                                                                  "null")
                                                              ? "Balance $rupeeSymbol ${walletList[index].comBal}"
                                                              : "Balance $rupeeSymbol ${walletList[index].txnBal}",
                                                      style: TextStyle(
                                                          color: green,
                                                          fontSize: font12.sp),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                            (walletList[index]
                                                        .heading
                                                        .toString() ==
                                                    "Moneypro-Wallet| Withdrawal")
                                                ? Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 60.0, top: 5),
                                                    child: Text(
                                                      "Check your transaction status",
                                                      style: TextStyle(
                                                          color: red,
                                                          fontSize: font12.sp),
                                                    ),
                                                  )
                                                : Container()
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      ),
                (isWalletReload)
                    ? Center(
                        child: circularProgressLoading(20.0),
                      )
                    : Container(
                        height: 1,
                      )
              ],
            ),
          );
  }

  _buildDMTHistory() {
    return (loading5)
        ? Center(
            child: circularProgressLoading(40.0),
          )
        : (dmtTransactions.length == 0)
            ? NoDataFound(text: "No transaction found")
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: dmtTransactions.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                      child: InkWell(
                        onTap: () {
                          Map map = {
                            "date": "${dmtTransactions[index].date}",
                            "transId": "${dmtTransactions[index].transctionId}",
                            "amount": "${dmtTransactions[index].amount}",
                            "mode": "${dmtTransactions[index].mode}",
                            "status": "${dmtTransactions[index].status}",
                            "mobile": "${dmtTransactions[index].mobile}",
                            "acc_no": "${dmtTransactions[index].accNo}",
                            "customer_charge":
                                "${dmtTransactions[index].customerCharge}",
                            "total_payable_amnt":
                                "${dmtTransactions[index].totalPayableAmnt}",
                            "merchant_commission":
                                "${dmtTransactions[index].merchantCommission}",
                          };
                          openDMTRecipt(context, map);
                        },
                        child: Container(
                          margin: EdgeInsets.only(top: 10),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                              border: Border.all(color: gray)),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 5.w,
                                ),
                                Container(
                                    height: 45.h,
                                    width: 45.w,
                                    decoration: BoxDecoration(
                                      color: lightBlue, // border color
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(9.0),
                                      child: Image.asset(
                                        'assets/wallet_white.png',
                                      ),
                                    )),
                                SizedBox(
                                  width: 5.w,
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            "$transId : ${dmtTransactions[index].transctionId}",
                                            style: TextStyle(
                                                color: black, fontSize: font15.sp),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            "Date: ${dmtTransactions[index].date}",
                                            style: TextStyle(
                                                color: black, fontSize: font15.sp),
                                            textAlign: TextAlign.left,
                                          ),
                                        )
                                      ],
                                    )),
                                Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8, top: 8),
                                      child: Text(
                                        "$rupeeSymbol ${dmtTransactions[index].amount}",
                                        style: TextStyle(
                                            color: black, fontSize: font16.sp),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 8.0, right: 8, bottom: 8),
                                      child: Text("Debited",
                                          style: TextStyle(
                                              color: black, fontSize: font13.sp)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
  }

  _buildOtherHistory() {
    return (loading6)
        ? Center(
            child: circularProgressLoading(40.0),
          )
        : SingleChildScrollView(
            controller: scrollOtherController,
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                _buildSearchSection(),
                (showSearchResult)
                    ? (othersFiltersTransactions.length == 0)
                        ? NoDataFound(text: "No result found")
                        : _buildOtherFiltersTransaction()
                    : (othersTransactions.length == 0)
                        ? NoDataFound(text: "No transaction found")
                        : _buildOtherTransaction()
              ],
            ),
          );
  }

  _buildSearchSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 10, right: 15, left: 15),
      height: 50.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: gray)),
      child: Row(
        children: [
          SizedBox(
            width: 15.w,
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              style: TextStyle(color: lightBlue, fontSize: inputFont.sp),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              controller: searchTrans,
              decoration: new InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                hintText: "Search Transaction",
                hintStyle: TextStyle(color: lightBlue),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              maxLength: 30,
              onFieldSubmitted: (val) {
                onFilterTransId(val.toString());
              },
              onChanged: (val) {
                if (val.length > 3) {
                  onFilterTransId(val.toString());
                }

                if (val.length == 0) {
                  setState(() {
                    showSearchResult = false;
                    othersFiltersTransactions.clear();
                  });
                }
              },
            ),
          ),
          SizedBox(
            width: 5.w,
          ),
          GestureDetector(
            onTapDown: (TapDownDetails details) {
              showPopupMenu(details.globalPosition);
            },
            child: Image.asset(
              'assets/filter_opt.png',
              height: 20.h,
              color: lightBlue,
            ),
          ),
          SizedBox(
            width: 15.w,
          ),
        ],
      ),
    );
  }

  _buildOtherTransaction() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
          child: ListView.builder(
              itemCount: othersTransactions.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: ScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    var type;
                    var pAmt = othersTransactions[index].paymentgateway_amount;

                    if (pAmt.toString() == "null" || pAmt.toString() == "0") {
                      type = "MoneyPro Wallet";
                    } else {
                      type = "Payment Gateway";
                    }

                    Map map = {
                      "tId": "${othersTransactions[index].transction_id}",
                      "TxStatus": "${othersTransactions[index].status}",
                      "orderAmount": "${othersTransactions[index].amount}",
                      "paymentMode": "$type",
                      "orderId": "",
                      "txTime": "${othersTransactions[index].date}",
                      "referenceId": "${othersTransactions[index].refId}",
                      "signature": "",
                      "operatorName":
                          "${othersTransactions[index].operator_name}",
                      "mobile": "${othersTransactions[index].parameter}",
                      "txnKey": "${othersTransactions[index].txnKey}",
                      "category": "${othersTransactions[index].category}",
                      "walAmt": "${othersTransactions[index].wallet}",
                      "pgAmt":
                          "${othersTransactions[index].paymentgateway_amount}",
                    };
                    openBBSPRecipt(context, map);
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 10),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        border: Border.all(color: gray)),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 20, top: 10, bottom: 10),
                      child: Row(
                        children: [
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
                                  color: lightBlue,
                                ),
                              )),
                          Expanded(
                            flex: 1,
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 20, top: 0),
                                  child: Row(
                                    children: [
                                      Text(
                                        "$transId : ",
                                        style: TextStyle(
                                            color: black, fontSize: font14.sp),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${othersTransactions[index].transction_id}",
                                          style: TextStyle(
                                              color: black, fontSize: font14.sp),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 15.0, right: 20, top: 2),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          (othersTransactions[index]
                                                      .date
                                                      .toString() ==
                                                  "null")
                                              ? "NA"
                                              : "${othersTransactions[index].date}",
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font12.sp),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, right: 15, top: 5),
                                  child: Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "Operator ${othersTransactions[index].operator_name}",
                                            style: TextStyle(
                                                color: lightBlue,
                                                fontSize: font14.sp),
                                          ),
                                          Text(
                                            "Recharge to ${othersTransactions[index].parameter}",
                                            style: TextStyle(
                                                color: lightBlack,
                                                fontSize: font13.sp),
                                          ),
                                        ],
                                      )),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "$rupeeSymbol ${othersTransactions[index].amount}",
                            style: TextStyle(
                                color: (othersTransactions[index]
                                            .status
                                            .toString()
                                            .toLowerCase() ==
                                        "SUCCESS".toLowerCase())
                                    ? green
                                    : red,
                                fontSize: font18.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
        ),
        (isReload)
            ? Center(
                child: circularProgressLoading(20.0),
              )
            : Container(
                height: 1,
              )
      ],
    );
  }

  _buildOtherFiltersTransaction() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: ListView.builder(
          itemCount: othersFiltersTransactions.length,
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                var type;
                var pAmt =
                    othersFiltersTransactions[index].paymentgateway_amount;

                if (pAmt.toString() == "null" || pAmt.toString() == "0") {
                  type = "MoneyPro Wallet";
                } else {
                  type = "Payment Gateway";
                }

                Map map = {
                  "tId": "${othersFiltersTransactions[index].transction_id}",
                  "TxStatus": "${othersFiltersTransactions[index].status}",
                  "orderAmount": "${othersFiltersTransactions[index].amount}",
                  "paymentMode": "$type",
                  "orderId": "",
                  "txTime": "${othersFiltersTransactions[index].date}",
                  "txMsg": "Transaction is successful",
                  "type": "CashFree",
                  "referenceId": "${othersFiltersTransactions[index].refId}",
                  "signature": "",
                  "operatorName":
                      "${othersFiltersTransactions[index].operator_name}",
                  "mobile": "${othersFiltersTransactions[index].parameter}",
                  "txnKey": "${othersFiltersTransactions[index].txnKey}",
                  "category": "${othersFiltersTransactions[index].category}",
                  "walAmt": "${othersFiltersTransactions[index].wallet}",
                  "pgAmt":
                      "${othersFiltersTransactions[index].paymentgateway_amount}",
                };
                openBBSPRecipt(context, map);
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: gray)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 10.0, right: 20, top: 10, bottom: 10),
                  child: Row(
                    children: [
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
                              color: lightBlue,
                            ),
                          )),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 20, top: 0),
                              child: Row(
                                children: [
                                  Text(
                                    "$transId : ",
                                    style: TextStyle(
                                        color: black, fontSize: font14.sp),
                                  ),
                                  Expanded(
                                    child: Text(
                                      "${othersFiltersTransactions[index].transction_id}",
                                      style: TextStyle(
                                          color: black, fontSize: font14.sp),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 20, top: 2),
                              child: Row(
                                children: [
                                  Text(
                                    (othersFiltersTransactions[index]
                                                .date
                                                .toString() ==
                                            "null")
                                        ? "NA"
                                        : "${othersFiltersTransactions[index].date}",
                                    style: TextStyle(
                                        color: lightBlack, fontSize: font12.sp),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 10.0, right: 15, top: 5),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                  Expanded(
                                      child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "Operator ${othersFiltersTransactions[index].operator_name}",
                                        style: TextStyle(
                                            color: lightBlue, fontSize: font14.sp),
                                      ),
                                      Text(
                                        "Recharge to ${othersFiltersTransactions[index].parameter}",
                                        style: TextStyle(
                                            color: lightBlack,
                                            fontSize: font13.sp),
                                      ),
                                    ],
                                  )),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        "$rupeeSymbol ${othersTransactions[index].amount}",
                        style: TextStyle(
                            color: (othersTransactions[index]
                                        .status
                                        .toString()
                                        .toLowerCase() ==
                                    "SUCCESS".toLowerCase())
                                ? green
                                : red,
                            fontSize: font18.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
    );
  }


  Future getOthersTransactions(page) async {
    setState(() {
      loading6 = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"token": "$token", "page": "$page"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(otherTransactionsAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        loading6 = false;

        if (data['status'].toString() == "1") {
          if (data['transction_list'].length != 0) {
            for (int i = 0; i < data['transction_list'].length; i++) {
              var date = data['transction_list'][i]['date'];
              var transctionId = data['transction_list'][i]['transction_id'];
              var refId = data['transction_list'][i]['refId'];
              var amount = data['transction_list'][i]['amount'];
              var category = data['transction_list'][i]['category'];
              var operatorName = data['transction_list'][i]['operator_name'];
              var status = data['transction_list'][i]['status'];
              var parameter = data['transction_list'][i]['parameter'];
              var wallet = data['transction_list'][i]['wallet'];
              var paymentgatewayAmount =
                  data['transction_list'][i]['paymentgateway_amount'];
              var paymentgatewayTxn =
                  data['transction_list'][i]['paymentgateway_txn'];
              var commission = data['transction_list'][i]['commission'];
              var txnKey = data['transction_list'][i]['txn_key'];

              BBPSTransaction other = new BBPSTransaction(
                date: date,
                transction_id: transctionId,
                refId: refId,
                amount: amount,
                category: category,
                operator_name: operatorName,
                status: status,
                parameter: parameter,
                wallet: wallet,
                paymentgateway_amount: paymentgatewayAmount,
                paymentgateway_txn: paymentgatewayTxn,
                commission: commission,
                txnKey: txnKey,
              );
              othersTransactions.add(other);

              otherTotalPage = int.parse(data['total_pages'].toString());
            }
          }
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        loading6 = false;
      });
      showToastMessage(status500);
    }
  }

  Future getOthersReloadTransactions(pageNo) async {
    setState(() {
      isReload = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$token",
      "page": "$pageNo",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(otherTransactionsAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        isReload = false;

        List<BBPSTransaction> othersTrans = [];

        if (data['status'].toString() == "1") {
          if (data['transction_list'].length != 0) {
            for (int i = 0; i < data['transction_list'].length; i++) {
              var date = data['transction_list'][i]['date'];
              var transctionId = data['transction_list'][i]['transction_id'];
              var refId = data['transction_list'][i]['refId'];
              var amount = data['transction_list'][i]['amount'];
              var category = data['transction_list'][i]['category'];
              var operatorName = data['transction_list'][i]['operator_name'];
              var status = data['transction_list'][i]['status'];
              var parameter = data['transction_list'][i]['parameter'];
              var wallet = data['transction_list'][i]['wallet'];
              var paymentgatewayAmount =
                  data['transction_list'][i]['paymentgateway_amount'];
              var paymentgatewayTxn =
                  data['transction_list'][i]['paymentgateway_txn'];
              var commission = data['transction_list'][i]['commission'];
              var txnKey = data['transction_list'][i]['txn_key'];

              BBPSTransaction other = new BBPSTransaction(
                date: date,
                transction_id: transctionId,
                refId: refId,
                amount: amount,
                category: category,
                operator_name: operatorName,
                status: status,
                parameter: parameter,
                wallet: wallet,
                paymentgateway_amount: paymentgatewayAmount,
                paymentgateway_txn: paymentgatewayTxn,
                commission: commission,
                txnKey: txnKey,
              );
              othersTrans.add(other);
            }

            othersTransactions.insertAll(
                othersTransactions.length, othersTrans);
          }
        }
      });
    } else {
      setState(() {
        isReload = false;
      });
      showToastMessage(status500);
    }
  }

  onFilterStatus(String text) async {
    printMessage(screen, "Case 0 : $text");
    othersFiltersTransactions.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    othersTransactions.forEach((userDetail) {
      if (userDetail.status.toString().toLowerCase() == text.toLowerCase()) {
        printMessage(screen, "Case 2 :");
        othersFiltersTransactions.add(userDetail);
      }
    });

    setState(() {
      printMessage(screen, "Case 3 : ${othersFiltersTransactions.length}");
      if (othersFiltersTransactions.length != 0) {
        showSearchResult = true;
      }
    });
  }

  onFilterTransId(String text) async {
    printMessage(screen, "Case 0 : $text");
    othersFiltersTransactions.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    othersTransactions.forEach((userDetail) {
      if (userDetail.transction_id
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        printMessage(screen, "Case 2 :");
        othersFiltersTransactions.add(userDetail);
      }
    });

    setState(() {
      printMessage(screen, "Case 3 : ${othersFiltersTransactions.length}");
      if (othersFiltersTransactions.length != 0) {
        showSearchResult = true;
      }
    });
  }

  Future getWalletTransactions(pageWalletNo) async {
    setState(() {
      loading1 = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$token",
      "page": "$pageWalletNo",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(walletBalanceHistroyAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Wallet Transaction : $data");

    setState(() {
      loading1 = false;
      if (data['status'].toString() == "1") {
        walletList.clear();
        var result = WalletTransactions.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        walletList = result.walletList;

        walletTotalPage = int.parse(data['total_pages'].toString());
      } else {
        showToastMessage(data['message'].toString());
      }
    });
  }

  Future getWalletTransactionsOnScroll(pageWalletNo) async {
    setState(() {
      isWalletReload = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$token",
      "page": "$pageWalletNo",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(walletBalanceHistroyAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Wallet Transaction : $data");

    setState(() {
      isWalletReload = false;
      if (data['status'].toString() == "1") {
        var result = WalletTransactions.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        walletList = result.walletList;
      }
    });
  }

  Future getDMTTransactions(page) async {
    setState(() {
      loading5 = true;
    });

    var mechantId = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"m_id": "$mechantId", "page": "$page"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtAllTransctionAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response All Transaction : $data");

    setState(() {
      loading5 = false;
      if (data['status'].toString() == "1") {
        dmtTransactions.clear();
        var result = DmtTransactions.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        dmtTransactions = result.transctionList;
      } else {
        showToastMessage(data['message'].toString());
      }
    });
  }

  Future getQRTransactions() async {
    setState(() {
      loading2 = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": token,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(merchantQrResponseAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        loading2 = false;
        if (data['status'].toString() == "1") {
          var result =
              History.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          qrResponse = result.qrResponse;

          qrResponse.sort((a, b) => b.date.compareTo(a.date));
          printMessage(screen, "QR Size : ${qrResponse.length}");
        } else {
          // showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        loading2 = false;
      });
      showToastMessage(status500);
    }
  }

  Future getAllSettlements() async {
    setState(() {
      settlementList.clear();
      loading2 = true;
    });

    var m_id = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "m_id": m_id,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(merchantQrRequestListAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Settelment : $data");

      setState(() {
        loading2 = false;
        if (data['status'].toString() == "1") {
          var result =
              Settelments.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          settlementList = result.requestList;
        } else {
          // showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        loading2 = false;
      });
      showToastMessage(status500);
    }
  }

  searchByDate() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => seachByData());
  }

  Future generatePayoutToken(id, Map map) async {
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

    final response =
        await http.post(Uri.parse(payoutTokenGenerateAPI), headers: headers);

    var statusCode = response.statusCode;
    Navigator.pop(context);
    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Response Token : $data");

      var token = data['result']['access_token'];
      checkTxnStatus(id, token, map);
    } else {
      setState(() {
        showToastMessage(somethingWrong);
      });
    }
  }

  Future checkTxnStatus(id, accessToken, Map map) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait while we check your transaction status");
          });
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$token",
      "access_token": "$accessToken",
      "merchantRefId": "$id",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(payoutStatusCheckAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          var txnStatus = data['result']['data']['transactionDetails'][0]
                  ['txnStatus']
              .toString();
          Map m = {"txnStatus": "$txnStatus"};
          m.addAll(map);
          printMessage(screen, "Map : $m");
          openWalletRecipt(context, m);
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  showPopupMenu(Offset globalPosition) {
    double left = globalPosition.dx;
    double top = globalPosition.dy;
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
            child: Row(
              children: [
                //Icon(Icons.history_rounded),
                SizedBox(
                  width: 4,
                ),
                Text("Success")
              ],
            ),
            value: '1'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                //Icon(Icons.edit),
                SizedBox(
                  width: 4,
                ),
                Text("Pending")
              ],
            ),
            value: '2'),
        PopupMenuItem<String>(
            child: Row(
              children: [
                //Icon(Icons.delete_rounded),
                SizedBox(
                  width: 4,
                ),
                Text("Failure")
              ],
            ),
            value: '3'),
      ],
      elevation: 8.0,
    ).then<void>((itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        onFilterStatus("Success");
      } else if (itemSelected == "2") {
        onFilterStatus("Pending");
      } else if (itemSelected == "3") {
        onFilterStatus("Failure");
      }
    });
  }
}

class seachByData extends StatefulWidget {
  const seachByData({Key? key}) : super(key: key);

  @override
  _seachByDataState createState() => _seachByDataState();
}

class _seachByDataState extends State<seachByData> {
  var screen = "Seach by Data";

  DateTime currentFromDate = DateTime.now();
  DateTime currentToDate = DateTime.now();
  final f = new DateFormat('dd-MM-yyyy');

  var isFromDate = false;
  var isToDate = false;

  @override
  Widget build(BuildContext context) {
    return Wrap(
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
                height: 20,
              ),
              Image.asset(
                'assets/search_calander.png',
                height: 100,
              ),
              SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () {
                      _selectFromDate(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/calendar.png',
                          height: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text((isFromDate)
                            ? "${f.format(currentFromDate)}"
                            : "Select form Date"),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _selectToDate(context);
                    },
                    child: Row(
                      children: [
                        Image.asset(
                          'assets/calendar.png',
                          height: 24,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text((isToDate)
                            ? "${f.format(currentToDate)}"
                            : "Select to Date"),
                      ],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 30,
              ),
              InkWell(
                onTap: () {
                  getQRTransactions(currentFromDate, currentToDate);
                },
                child: Container(
                  height: 40,
                  width: MediaQuery.of(context).size.width * .8,
                  decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: green)),
                  child: Center(
                      child: Text(
                    "Search",
                    style: TextStyle(fontSize: font15, color: white),
                  )),
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentFromDate,
        firstDate: DateTime(2019),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentFromDate) {
      setState(() {
        currentFromDate = pickedDate;
        isFromDate = true;
      });
    } else {
      setState(() {
        isFromDate = false;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentToDate,
        firstDate: DateTime(2019),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentToDate) {
      setState(() {
        currentToDate = pickedDate;
        isToDate = true;
      });
    } else {
      isToDate = false;
    }
  }

  Future getQRTransactions(fromDate, toDate) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var token = await getToken();
    final form = new DateFormat('yyyy-MM--dd');

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    var startDate = form.format(fromDate);
    var endDate = form.format(toDate);

    final body = {
      "token": token,
      "start_date": "$startDate",
      "end_date": "$endDate",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(qrSearchByDateAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          qrResponse.clear();
          var result =
              History.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          qrResponse = result.qrResponse;
          qrResponse.sort((a, b) => b.date.compareTo(a.date));

          printMessage(screen, "QR Size : ${qrResponse.length}");
        } else {
          showToastMessage(data['message'].toString());
        }
        closeCurrentPage(context);
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }
}
