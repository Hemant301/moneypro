import 'dart:async';
import 'dart:io';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/AEPS.dart';
import 'package:moneypro_new/ui/models/BBPSTransaction.dart';
import 'package:moneypro_new/ui/models/BranchTransHistory.dart';
import 'package:moneypro_new/ui/models/DMTTransactions.dart';
import 'package:moneypro_new/ui/models/History.dart';
import 'package:moneypro_new/ui/models/MATMTransactions.dart';
import 'package:moneypro_new/ui/models/PayoutList.dart';
import 'package:moneypro_new/ui/models/Settelments.dart';
import 'package:moneypro_new/ui/models/SortBranchData.dart';
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

class TransactionHistory extends StatefulWidget {
  final String fromDate;
  final String toDate;

  const TransactionHistory(
      {Key? key, required this.fromDate, required this.toDate})
      : super(key: key);

  @override
  _TransactionHistoryState createState() => _TransactionHistoryState();
}

class _TransactionHistoryState extends State<TransactionHistory>
    with SingleTickerProviderStateMixin {
  var screen = "Trans History";

  var loading1 = false;
  var loading2 = false;
  var loading3 = false;
  var loading4 = false;
  var loading5 = false;
  var loading6 = false;
  var loading7 = false;

  final List<Tab> tabs = <Tab>[
    new Tab(text: "Wallet"),
    new Tab(text: "UPI QR"),
    new Tab(text: "M-ATM"),
    new Tab(text: "AEPS"),
    new Tab(text: "DMT"),
    new Tab(text: "Transactions"),
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
  List<MATMTransaction> matmTransctionLists = [];
  List<AEPSTransaction> aepsTransaction = [];
  List<DMTList> dmtTransactions = [];
  List<TransctionList> branchTransHistories = [];
  List<PayoutListElement> payoutList = [];

  List<TodayTxn> todayTxns = [];
  var isSort = false;

  var showSearchResult = false;

  bool isReload = false;
  int pageOtherNo = 1;
  int otherTotalPage = 0;
  late ScrollController scrollOtherController;

  bool isWalletReload = false;
  int pageWalletNo = 1;
  int walletTotalPage = 0;
  late ScrollController scrollWalletController;

  bool isUPITxnReload = false;
  int pageUPITxn = 1;
  int UPITxnTotalPage = 0;
  late ScrollController scrollUPITxnController;

  var branchCreate = "";

  var totalAmt;

  bool isBranchReload = false;
  int pageBranch = 1;
  int pageSort = 1;
  int BranchTotalPage = 0;
  late ScrollController scrollBranchController;
  ScrollController scrollsortController = ScrollController();

  @override
  void initState() {
    super.initState();
    scrollOtherController = new ScrollController()
      ..addListener(_scrollListener);
    scrollWalletController = new ScrollController()
      ..addListener(_scrollWalletListener);
    scrollUPITxnController = new ScrollController()
      ..addListener(_scrollUPITxnListener);

    scrollBranchController = new ScrollController()
      ..addListener(_scrollBranchListener);
    print('at scroller');
    scrollsortController.addListener(_scrollEvent);

    fetchUserAccountBalance();
    _tabController = new TabController(vsync: this, length: tabs.length);
    getWalletTransactions(pageWalletNo);
    updateATMStatus(context);
    updateWalletBalances();

    Timer(Duration(seconds: 2), () {
      if (widget.fromDate.toString() != "" && widget.toDate.toString() != "") {
        printMessage(screen, "InSide Wiget");
        setState(() {
          _tabController?.animateTo(1);
        });
        getDateTransactions(
            widget.fromDate.toString(), widget.toDate.toString(), pageSort);
      }
    });
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();
    double mX = 0.0;
    double wX = 0.0;
    var bC = await getBranchCreate();

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
      mX = double.parse(mpBalc); //7639876246
    }
    setState(() {
      walletBal = wX + mX;
      branchCreate = bC;
      printMessage(screen, "branchCreate : $branchCreate");
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

  void _scrollEvent() {
    print('jst litening');
    if (scrollsortController.position.pixels ==
        scrollsortController.position.maxScrollExtent) {
      print('scroll ho rha');
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

  void _scrollUPITxnListener() {
    if (pageUPITxn <= UPITxnTotalPage) {
      if (scrollUPITxnController.position.extentAfter < 500) {
        setState(() {
          isUPITxnReload = true;
          if (isUPITxnReload) {
            isUPITxnReload = false;
            pageUPITxn = pageUPITxn + 1;
            getPayoutTransactionOnScroll(pageUPITxn);
          }
        });
      }
    }
  }

  void _scrollBranchListener() {
    if (isSort == true) {
      if (scrollBranchController.position.pixels ==
          scrollBranchController.position.maxScrollExtent) {
        setState(() {
          pageSort = pageSort + 1;
          getSortedDateTransactions(widget.fromDate, widget.toDate, pageSort);
        });
      }
    }
    if (pageBranch <= BranchTotalPage) {
      // if (scrollBranchController.position.extentAfter < 500) {
      if (scrollBranchController.position.pixels ==
          scrollBranchController.position.maxScrollExtent) {
        setState(() {
          isBranchReload = true;
          if (isBranchReload) {
            isBranchReload = false;
            pageBranch = pageBranch + 1;
            getBranchTransactionsOnScroll(pageBranch);

            //getQRTransactionsOnScroll(pageBranch);
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
      builder: () => SafeArea(
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
                              height: 20,
                            ),
                          )
                        : Container()
                  ],
                  bottom: new TabBar(
                    isScrollable: true,
                    unselectedLabelColor: black,
                    labelColor: white,
                    labelStyle: TextStyle(fontSize: font14),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: new BubbleTabIndicator(
                      indicatorHeight: 25.0,
                      indicatorColor: lightBlue,
                      tabBarIndicatorSize: TabBarIndicatorSize.tab,
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
                      } else if (val == 1) {
                        if (branchCreate.toString() == "1") {
                          if (widget.fromDate.toString() != "" &&
                              widget.toDate.toString() != "") {
                            getDateTransactions(widget.fromDate.toString(),
                                widget.toDate.toString(), pageSort);
                          } else {
                            getBranchTransactions();
                          }
                        } else {
                          getQRTransactions();
                        }
                      } else if (val == 2) {
                        // M ATM response here
                        if (matmTransctionLists.length == 0)
                          getMATMTransactions(1);
                      } else if (val == 3) {
                        //calling AEPS response here
                        if (aepsTransaction.length == 0) getAEPSTransactions(0);
                      } else if (val == 4) {
                        //calling DMT response here
                        if (dmtTransactions.length == 0) getDMTTransactions(0);
                      } else if (val == 5) {
                        // Other response here
                        if (payoutList.length == 0) getPayoutTransaction();
                      } else if (val == 6) {
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
                  _buildUPIHistory(),
                  _buildMATMHistory(),
                  _buildAEPSHistory(),
                  _buildDMTHistory(),
                  _buildBankUPITransaction(),
                  _buildOtherHistory(),
                ],
              ))),
    );
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
                                                                        font14
                                                                            .sp),
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
                                                                          font14
                                                                              .sp,
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
                                                                          font11
                                                                              .sp,
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
                                                            fontSize:
                                                                font13.sp),
                                                      ),
                                                      Text(
                                                        "Balc. $rupeeSymbol ${walletList[index].comBal}",
                                                        style: TextStyle(
                                                            color: green,
                                                            fontSize:
                                                                font13.sp),
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
                                                                      font14
                                                                          .sp),
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
                                                                        font14
                                                                            .sp,
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
                                                                        font11
                                                                            .sp,
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
                                                                          font14
                                                                              .sp),
                                                                ),
                                                                Text(
                                                                  "${walletList[index].description}",
                                                                  style: TextStyle(
                                                                      color:
                                                                          lightBlack,
                                                                      fontSize:
                                                                          font13
                                                                              .sp),
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
                                                                      .txn_type ==
                                                                  "Cr")
                                                              ? "+"
                                                              : "-",
                                                          style: TextStyle(
                                                              color: (walletList[
                                                                              index]
                                                                          .txn_type ==
                                                                      "Cr")
                                                                  ? green
                                                                  : red,
                                                              fontSize:
                                                                  font18.sp),
                                                        ),
                                                        SizedBox(
                                                          width: 2.w,
                                                        ),
                                                        Text(
                                                          "$rupeeSymbol ${walletList[index].txnAmnt}",
                                                          style: TextStyle(
                                                              color: orange,
                                                              fontSize:
                                                                  font13.sp),
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
                                                          ? "Balc. $rupeeSymbol $walletBal"
                                                          : (walletList[index]
                                                                      .txnBal
                                                                      .toString() ==
                                                                  "null")
                                                              ? "Balc. $rupeeSymbol ${walletList[index].comBal}"
                                                              : (walletList[index]
                                                                              .txnBal
                                                                              .toString() ==
                                                                          "0" ||
                                                                      walletList[index]
                                                                              .txnBal
                                                                              .toString() ==
                                                                          "0.0")
                                                                  ? "Balc. 0.0"
                                                                  : "Balc. $rupeeSymbol ${formatDecimal2Digit.format(double.parse(walletList[index].txnBal))}",
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
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

  _buildUPIHistory() {
    return (loading2)
        ? Center(
            child: circularProgressLoading(40.0),
          )
        : SingleChildScrollView(
            controller: scrollBranchController,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              SizedBox(
                height: 10,
              ),
              _buildTabSection(),
              (isSort)
                  ? InkWell(
                      onTap: () {
                        print(isSort);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, top: 10, bottom: 10),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/qr_menu.png',
                              height: 16.h,
                            ),
                            SizedBox(
                              width: 5.w,
                            ),
                            Text(
                              "Total $rupeeSymbol ${formatDecimal2Digit.format(totalAmt)}",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font20.sp,
                                  fontWeight: FontWeight.bold),
                            )
                          ],
                        ),
                      ),
                    )
                  : Container(),
              (selectedIndex == 1)
                  ? (branchCreate.toString() == "1")
                      ? (isSort)
                          ? (todayTxns.length == 0)
                              ? NoDataFound(
                                  text: "No transaction found",
                                )
                              : _buildTodayTransactions()
                          : _buildBranchTransHistory()
                      : (qrResponse.length == 0)
                          ? NoDataFound(
                              text: "No transaction found",
                            )
                          : _buildTransactions()
                  : (settlementList.length == 0)
                      ? NoDataFound(
                          text: "No transaction found",
                        )
                      : _buildSettlements(),
              (isBranchReload)
                  ? Center(
                      child: circularProgressLoading(20.0),
                    )
                  : Container(
                      height: 1,
                    )
            ]));
  }

  _buildBranchTransHistory() {
    return (loading2)
        ? Center(
            child: circularProgressLoading(40.0),
          )
        : SingleChildScrollView(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            (branchTransHistories.length == 0)
                ? NoDataFound(
                    text: "No transaction found",
                  )
                : ListView.builder(
                    itemCount: branchTransHistories.length,
                    shrinkWrap: true,
                    scrollDirection: Axis.vertical,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, right: 20, top: 0),
                        child: InkWell(
                          onTap: () {
                            print('object');
                          },
                          child: Container(
                            margin: EdgeInsets.only(top: 10),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                color: white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
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
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                              ("${branchTransHistories[index].transctionId.toString()}" ==
                                                      "null")
                                                  ? "Trans Id : NA"
                                                  : "Trans Id : ${branchTransHistories[index].transctionId}",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: font15.sp),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                              "${branchTransHistories[index].name}",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: font13.sp),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                              "${branchTransHistories[index].date} | ${branchTransHistories[index].time}",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: font13.sp),
                                              textAlign: TextAlign.left,
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Text(
                                              ("${branchTransHistories[index].branchName.toString()}" ==
                                                      "null")
                                                  ? "Bank Name : NA"
                                                  : "Bank Name : ${branchTransHistories[index].branchName}",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: font13.sp),
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
                                          "$rupeeSymbol ${branchTransHistories[index].amount}",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: font16.sp),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    width: 5.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ]));
  }

  _buildMATMHistory() {
    return (loading3)
        ? Center(
            child: circularProgressLoading(40.0),
          )
        : (matmTransctionLists.length == 0)
            ? NoDataFound(text: "No transaction found")
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: matmTransctionLists.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                      child: InkWell(
                        onTap: () {
                          var status = matmTransctionLists[index].status;

                          printMessage(screen, "MATM Status : $status");

                          if (status.toString().toLowerCase() != "success" &&
                              status.toString().toLowerCase() != "fail" &&
                              status.toString().toLowerCase() != "failed" &&
                              status.toString().toLowerCase() != "failure") {
                            var txid = matmTransctionLists[index].txnid;
                            if (txid.toString() != "null") {
                              getATMAuthToken(txid);
                            }
                          } else {
                            Map map = {
                              "date": "${matmTransctionLists[index].date}",
                              "transId":
                                  "${matmTransctionLists[index].transctionId}",
                              "refId": "${matmTransctionLists[index].refId}",
                              "amount": "${matmTransctionLists[index].amount}",
                              "bankName":
                                  "${matmTransctionLists[index].bankName}",
                              "status": "${matmTransctionLists[index].status}",
                              "card_no": "${matmTransctionLists[index].cardNo}",
                              "terminalId":
                                  "${matmTransctionLists[index].terminalId}",
                              "merchCommin":
                                  "${matmTransctionLists[index].merchantCommission}",
                              "mobile": "$mobileChar",
                            };
                            openMATMReceipt(context, map);
                          }
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
                            child: Column(
                              children: [
                                Row(
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
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Text(
                                                (matmTransctionLists[index]
                                                            .rrn
                                                            .toString() ==
                                                        "null")
                                                    ? "Txn Id : NA"
                                                    : "Txn Id : ${matmTransctionLists[index].rrn}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font14.sp),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Text(
                                                (matmTransctionLists[index]
                                                            .bankName
                                                            .toString() ==
                                                        "null")
                                                    ? "Bank : NA"
                                                    : "Bank : ${matmTransctionLists[index].bankName}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp),
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
                                            (matmTransctionLists[index]
                                                        .amount
                                                        .toString() ==
                                                    "null")
                                                ? "NA"
                                                : "$rupeeSymbol ${matmTransctionLists[index].amount}",
                                            style: TextStyle(
                                                color: black,
                                                fontSize: font16.sp),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8, bottom: 8),
                                          child: Text(
                                              "${matmTransctionLists[index].status}",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: font13.sp)),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                  ],
                                ),
                                (matmTransctionLists[index]
                                                .status
                                                .toString()
                                                .toLowerCase() !=
                                            "success" &&
                                        matmTransctionLists[index]
                                                .status
                                                .toString()
                                                .toLowerCase() !=
                                            "fail" &&
                                        matmTransctionLists[index]
                                                .status
                                                .toString()
                                                .toLowerCase() !=
                                            "failed" &&
                                        matmTransctionLists[index]
                                                .status
                                                .toString()
                                                .toLowerCase() !=
                                            "failure")
                                    ? Text(
                                        "Check transaction Status",
                                        style: TextStyle(
                                            color: red, fontSize: font14.sp),
                                      )
                                    : Container()
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              );
    ;
  }

  _buildAEPSHistory() {
    return (loading4)
        ? Center(
            child: circularProgressLoading(40.0),
          )
        : (aepsTransaction.length == 0)
            ? NoDataFound(text: "No transaction found")
            : Container(
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: ListView.builder(
                  itemCount: aepsTransaction.length,
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                      child: InkWell(
                        onTap: () {
                          if (aepsTransaction[index]
                                      .status
                                      .toString()
                                      .toLowerCase() !=
                                  "success" &&
                              aepsTransaction[index]
                                      .status
                                      .toString()
                                      .toLowerCase() !=
                                  "fail" &&
                              aepsTransaction[index]
                                      .status
                                      .toString()
                                      .toLowerCase() !=
                                  "failed" &&
                              aepsTransaction[index]
                                      .status
                                      .toString()
                                      .toLowerCase() !=
                                  "failure") {
                            var txnId = aepsTransaction[index].txnid.toString();

                            printMessage(screen, "txnId : $txnId");

                            if (txnId.toString() != "null") {
                              getAEPSTransIdToken(txnId);
                            }
                          } else {
                            Map map = {
                              "date": "${aepsTransaction[index].date}",
                              "transId":
                                  "${aepsTransaction[index].transctionId}",
                              "refId": "${aepsTransaction[index].refId}",
                              "amount": "${aepsTransaction[index].amount}",
                              "mode": "${aepsTransaction[index].mode}",
                              "status": "${aepsTransaction[index].status}",
                              "adhar": "${aepsTransaction[index].adhar}",
                              "mobile": "${aepsTransaction[index].mobile}",
                              "merComm":
                                  "${aepsTransaction[index].merchantCommission}",
                              'bankmsg': "${aepsTransaction[index].bank_msg}",
                            };
                            openAEPSReceipt(context, map, false);
                          }
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
                            child: Column(
                              children: [
                                Row(
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
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Text(
                                                (aepsTransaction[index]
                                                            .status
                                                            .toString() ==
                                                        "Pending")
                                                    ? "Txn Id : NA"
                                                    : (aepsTransaction[index]
                                                                .transctionId
                                                                .toString() ==
                                                            "null")
                                                        ? "Txn Id : ${aepsTransaction[index].txnid}"
                                                        : "Txn Id : ${aepsTransaction[index].transctionId}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font14.sp),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Text(
                                                (aepsTransaction[index]
                                                            .mobile
                                                            .toString() ==
                                                        "null")
                                                    ? "Mobile :"
                                                    : "Mobile : ${aepsTransaction[index].mobile}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp),
                                                textAlign: TextAlign.left,
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 10.0),
                                              child: Text(
                                                (aepsTransaction[index]
                                                            .mode
                                                            .toString() ==
                                                        "null")
                                                    ? "Trans Type :"
                                                    : "Trans Type : ${aepsTransaction[index].mode}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp),
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
                                            (aepsTransaction[index]
                                                        .amount
                                                        .toString() ==
                                                    "null")
                                                ? ""
                                                : "$rupeeSymbol ${aepsTransaction[index].amount}",
                                            style: TextStyle(
                                                color: black,
                                                fontSize: font16.sp),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 8.0, right: 8, bottom: 8),
                                          child: Text(
                                              "${aepsTransaction[index].status}",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: font13.sp)),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: 5.w,
                                    ),
                                  ],
                                ),
                                // (aepsTransaction[
                                //                     index]
                                //                 .status
                                //                 .toString()
                                //                 .toLowerCase() !=
                                //             "success" &&
                                //         aepsTransaction[index]
                                //                 .status
                                //                 .toString()
                                //                 .toLowerCase() !=
                                //             "fail" &&
                                //         aepsTransaction[index]
                                //                 .status
                                //                 .toString()
                                //                 .toLowerCase() !=
                                //             "failed" &&
                                //         aepsTransaction[index]
                                //                 .status
                                //                 .toString()
                                //                 .toLowerCase() !=
                                //             "failure")
                                //     ? Text(
                                //         "Check transaction Status",
                                //         style: TextStyle(
                                //             color: red, fontSize: font14.sp),
                                //       )
                                //     : Container(),
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
                                                color: black,
                                                fontSize: font14.sp),
                                            textAlign: TextAlign.left,
                                          ),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 10.0),
                                          child: Text(
                                            "Date: ${dmtTransactions[index].date}",
                                            style: TextStyle(
                                                color: black,
                                                fontSize: font13.sp),
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
                                              color: black,
                                              fontSize: font13.sp)),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  width: 5.w,
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
              controller: searchTrans,
              textCapitalization: TextCapitalization.characters,
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
                                              color: black,
                                              fontSize: font14.sp),
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
                                            (othersTransactions[index]
                                                        .operator_name
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "prepaid")
                                                ? "Operator ${othersTransactions[index].category}"
                                                : "Operator ${othersTransactions[index].operator_name}",
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
                                            color: lightBlue,
                                            fontSize: font14.sp),
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

  _buildTabSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          SizedBox(
            width: 5.w,
          ),
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 1;
                  if (branchCreate.toString() == "1") {
                    if (branchTransHistories.length == 0)
                      getBranchTransactions();
                  } else {
                    if (qrResponse.length == 0) getQRTransactions();
                  }
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: (selectedIndex == 1) ? lightBlue : white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(color: lightBlue)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 10, bottom: 10, right: 20),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        transactions,
                        style: TextStyle(
                            color: (selectedIndex == 1) ? white : lightBlue,
                            fontSize: font13.sp),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          ),
          Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32.0),
            ),
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = 2;
                  if (settlementList.length == 0) getAllSettlements();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                    color: (selectedIndex == 2) ? lightBlue : white,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                    border: Border.all(color: lightBlue)),
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 10, bottom: 10, right: 20),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        settlements,
                        style: TextStyle(
                            color: (selectedIndex == 2) ? white : lightBlue,
                            fontSize: font13.sp),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Spacer(),
          (selectedIndex == 1 && branchCreate.toString() == "1")
              ? GestureDetector(
                  onTapDown: (TapDownDetails details) {
                    showPopupMenuUPI(details.globalPosition);
                  },
                  child: Image.asset(
                    'assets/filter_opt.png',
                    height: 20.h,
                    color: lightBlue,
                  ),
                )
              : Container(),
          SizedBox(
            width: 15.w,
          ),
        ],
      ),
    );
  }

  _buildTransactions() {
    return ListView.builder(
      itemCount: qrResponse.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 0),
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "${qrResponse[index].name}",
                                style: TextStyle(
                                    color: black, fontSize: font15.sp),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "${qrResponse[index].date} | ${qrResponse[index].time}",
                                style: TextStyle(
                                    color: black, fontSize: font13.sp),
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
                            "$rupeeSymbol ${qrResponse[index].amount}",
                            style: TextStyle(color: black, fontSize: font16.sp),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 8),
                          child: Text("Credited",
                              style:
                                  TextStyle(color: black, fontSize: font13.sp)),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildSettlements() {
    return ListView.builder(
      itemCount: settlementList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 0),
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                ("${settlementList[index].transctionId.toString()}" ==
                                        "null")
                                    ? "Trans Id : NA"
                                    : "Trans Id : ${settlementList[index].transctionId}",
                                style: TextStyle(
                                    color: black, fontSize: font14.sp),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "${settlementList[index].date}",
                                style: TextStyle(
                                    color: black, fontSize: font13.sp),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                (settlementList[index].branch.toString() == "0")
                                    ? ("${settlementList[index].bankName.toString()}" ==
                                            "null")
                                        ? "Bank Name : NA"
                                        : "Bank Name : ${settlementList[index].bankName}"
                                    : "Branch : ${settlementList[index].branch}",
                                style: TextStyle(
                                    color: black, fontSize: font13.sp),
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
                            "$rupeeSymbol ${settlementList[index].amount}",
                            style: TextStyle(color: black, fontSize: font16.sp),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, bottom: 8),
                          child: Text("${settlementList[index].status}",
                              style:
                                  TextStyle(color: black, fontSize: font13.sp)),
                        )
                      ],
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  _buildBankUPITransaction() {
    return (loading7)
        ? Center(
            child: circularProgressLoading(40.0),
          )
        : SingleChildScrollView(
            controller: scrollUPITxnController,
            child: Column(
              children: [
                SizedBox(
                  height: 10.h,
                ),
                (payoutList.length == 0)
                    ? NoDataFound(text: "No result found")
                    : Padding(
                        padding:
                            const EdgeInsets.only(left: 0.0, right: 0, top: 0),
                        child: ListView.builder(
                          itemCount: payoutList.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, right: 20, top: 10),
                              child: InkWell(
                                onTap: () {
                                  if (payoutList[
                                                  index]
                                              .status
                                              .toString()
                                              .toLowerCase() !=
                                          "success" &&
                                      payoutList[index]
                                              .status
                                              .toString()
                                              .toLowerCase() !=
                                          "fail" &&
                                      payoutList[index]
                                              .status
                                              .toString()
                                              .toLowerCase() !=
                                          "failed" &&
                                      payoutList[index]
                                              .status
                                              .toString()
                                              .toLowerCase() !=
                                          "failure") {
                                    var mTransId =
                                        payoutList[index].merchantRefId;
                                    var accNo = payoutList[index].beneAccount;
                                    var walletType =
                                        payoutList[index].walletType;
                                    generateTransPayoutToken(
                                        mTransId, accNo, walletType);
                                  } else {
                                    var date = payoutList[index].date;
                                    var merchantRefId =
                                        payoutList[index].merchantRefId;
                                    var bene_account =
                                        payoutList[index].beneAccount;
                                    var ifsc_jcode =
                                        payoutList[index].ifscJcode;
                                    var bene_name = payoutList[index].beneName;
                                    var mobile = payoutList[index].mobile;
                                    var amount = payoutList[index].amount;
                                    var status = payoutList[index].status;
                                    var wallet_type =
                                        payoutList[index].walletType;

                                    Map map = {
                                      "date": "$date",
                                      "merchantRefId": "$merchantRefId",
                                      "bene_account": "$bene_account",
                                      "ifsc_jcode": "$ifsc_jcode",
                                      "bene_name": "$bene_name",
                                      "mobile": "$mobile",
                                      "amount": "$amount",
                                      "status": "$status",
                                      "wallet_type": "$wallet_type"
                                    };

                                    openTransPayoutRecipt(context, map);
                                  }
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
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                            Image.asset(
                                              'assets/ic_v_right.png',
                                              height: 24.h,
                                            ),
                                            Expanded(
                                                flex: 1,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: Text(
                                                        "Paid to",
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize:
                                                                font14.sp),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: Text(
                                                        (payoutList[index]
                                                                    .beneName
                                                                    .toString() ==
                                                                "null")
                                                            ? "${payoutList[index].beneAccount}"
                                                            : "${payoutList[index].beneName}",
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize:
                                                                font14.sp),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: Text(
                                                        "Txn Id : ${payoutList[index].merchantRefId}",
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize:
                                                                font14.sp),
                                                        textAlign:
                                                            TextAlign.left,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                            Column(
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          top: 8),
                                                  child: Text(
                                                    "$rupeeSymbol ${payoutList[index].amount}",
                                                    style: TextStyle(
                                                        color: black,
                                                        fontSize: font16.sp),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0,
                                                          right: 8,
                                                          bottom: 8),
                                                  child: Text(
                                                      "${payoutList[index].status}",
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: font13.sp)),
                                                )
                                              ],
                                            ),
                                            SizedBox(
                                              width: 5.w,
                                            ),
                                          ],
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 0.0),
                                          child: Row(
                                            children: [
                                              SizedBox(
                                                width: 35.w,
                                              ),
                                              Text(
                                                "${payoutList[index].date}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp),
                                                textAlign: TextAlign.left,
                                              ),
                                              Spacer(),
                                              Text(
                                                "Debited from ${payoutList[index].walletType}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp),
                                                textAlign: TextAlign.left,
                                              ),
                                            ],
                                          ),
                                        ),
                                        Center(
                                          child: (payoutList[index]
                                                          .status
                                                          .toString()
                                                          .toLowerCase() !=
                                                      "success" &&
                                                  payoutList[index]
                                                          .status
                                                          .toString()
                                                          .toLowerCase() !=
                                                      "fail" &&
                                                  payoutList[index]
                                                          .status
                                                          .toString()
                                                          .toLowerCase() !=
                                                      "failed" &&
                                                  payoutList[index]
                                                          .status
                                                          .toString()
                                                          .toLowerCase() !=
                                                      "failure")
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10.0, top: 5),
                                                  child: Text(
                                                    "Check your transaction status",
                                                    style: TextStyle(
                                                        color: red,
                                                        fontSize: font12.sp),
                                                  ),
                                                )
                                              : Container(),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                (isUPITxnReload)
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

  _buildTodayTransactions() {
    return ListView.builder(
      // controller: scrollBranchController,
      itemCount: todayTxns.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 0),
          child: InkWell(
            onTap: () {
              print('yahi h');
            },
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
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
                            'assets/ic_branch_office.png',
                            color: white,
                          ),
                        )),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                "Txn Id: ${todayTxns[index].transctionId}",
                                style: TextStyle(
                                    color: black, fontSize: font14.sp),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                "${todayTxns[index].name}",
                                style: TextStyle(
                                    color: black, fontSize: font14.sp),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                "${todayTxns[index].date} | ${todayTxns[index].time}",
                                style: TextStyle(
                                    color: black, fontSize: font12.sp),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
                        )),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 0),
                          child: Text(
                            "$rupeeSymbol ${todayTxns[index].amount}",
                            style: TextStyle(
                                color: black,
                                fontSize: font16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
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
    // print(authHeader);

    final response = await http.post(Uri.parse(walletBalanceHistroyAPI),
        body: jsonEncode(body), headers: headers);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
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
    } else {
      setState(() {
        loading1 = false;
      });
      showToastMessage(status500);
    }
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
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Wallet Transaction : $data");

      setState(() {
        isWalletReload = false;
        if (data['status'].toString() == "1") {
          /*var result = WalletTransactions.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));*/
          List<WalletList> walList = [];

          if (data['wallet_list'].length != 0) {
            for (int i = 0; i < data['wallet_list'].length; i++) {
              var type = data['wallet_list'][i]['type'];
              var txn_type = data['wallet_list'][i]['txn_type'];
              var date = data['wallet_list'][i]['date'];
              var time = data['wallet_list'][i]['time'];
              var transctionId = data['wallet_list'][i]['transction_id'];
              var heading = data['wallet_list'][i]['heading'];
              var description = data['wallet_list'][i]['description'];
              var txnAmnt = data['wallet_list'][i]['txn_amnt'];
              var txnBal = data['wallet_list'][i]['txn_bal'];
              var commission = data['wallet_list'][i]['commission'];
              var comBal = data['wallet_list'][i]['com_bal'];
              var headingS = data['wallet_list'][i]['heading_s'];
              var descriptionS = data['wallet_list'][i]['description_s'];

              WalletList listW = WalletList(
                  type: type,
                  txn_type: txn_type,
                  date: date,
                  time: time,
                  transctionId: transctionId,
                  heading: heading,
                  description: description,
                  txnAmnt: txnAmnt,
                  txnBal: txnBal,
                  commission: commission,
                  comBal: comBal,
                  headingS: headingS,
                  descriptionS: descriptionS);

              walList.add(listW);
            }
            walletList.insertAll(walletList.length, walList);
          }
        }
      });
    } else {
      setState(() {
        isWalletReload = false;
      });
      showToastMessage(status500);
    }
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

  Future getAEPSTransactions(page) async {
    setState(() {
      loading4 = true;
    });

    var mechantId = await getMerchantID();
    var token = await getToken();
    var aepsToken = await getAPESToken();
    var aepsActive = await getMatmAepsActive();

    var outletId;
    if (aepsToken.toString() == "1" && aepsActive.toString() == "0") {
      outletId = await getOutLetId();
    }

    if (aepsToken.toString() == "1" && aepsActive.toString() == "1") {
      outletId = await getAEPSMerchantId();
    }

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$token",
      "m_id": "$mechantId",
      "outlet_id": "$outletId",
      "page": "$page"
    };

    printMessage(screen, "AEPS body : $body");

    final response = await http.post(Uri.parse(aepsAppResponseListAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response AEPS Transaction : $data");

      setState(() {
        loading4 = false;
        if (data['status'].toString() == "1") {
          aepsTransaction.clear();
          var result =
              Aeps.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          aepsTransaction = result.transctionList;
          var totalPage = result.totalPages;
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        loading4 = false;
      });
      showToastMessage(status500);
    }
  }

  Future getMATMTransactions(page) async {
    setState(() {
      loading3 = true;
    });

    var mechantId = await getMerchantID();
    var token = await getToken();
    var outletId = await getOutLetId();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$token",
      "m_id": "$mechantId",
      "outlet_id": "$outletId",
      "page": "$page"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(matmAppResponseListAPI),
        body: jsonEncode(body), headers: headers);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response MATM Transaction : $data");

      setState(() {
        loading3 = false;
        if (data['status'].toString() == "1") {
          matmTransctionLists.clear();
          var result = MatmTransactions.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          matmTransctionLists = result.transctionList;
        }
      });
    } else {
      setState(() {
        loading3 = false;
      });
      showToastMessage(status500);
    }
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

  Future getQRTransactionsOnScroll(page) async {
    setState(() {
      loading2 = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"token": token, "page": page};

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

    setState(() {
      Navigator.pop(context);
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Response : $data");
        if (data['status'].toString() == "1") {
          int tLen = data['result']['data']['transactionDetails'].length;

          printMessage(screen, "Get length : $tLen");

          if (tLen != 0) {
            var txnStatus = data['result']['data']['transactionDetails'][0]
                    ['txnStatus']
                .toString();
            Map m = {"txnStatus": "$txnStatus"};
            m.addAll(map);
            printMessage(screen, "Map : $m");
            openWalletRecipt(context, m);
          } else {
            showToastMessage(somethingWrong);
          }
        } else {
          showToastMessage(data['message'].toString());
        }
      } else {
        showToastMessage(status500);
      }
    });
  }

  Future getAEPSTransIdToken(txnId) async {
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
    print(atmSecrettKey);
    print(atmSaltKey);
    print(atmEncDecKey);
    final response = await http.post(Uri.parse(authUrl), headers: header);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "AEPS Response : $data");

    setState(() {
      print('inside sets');
      Navigator.pop(context);
      if (data['isSuccess'].toString() == "true") {
        var authToken = data['data']['token'].toString();
        _checkAEPSTransId(authToken, txnId);
      }
    });
  }

  _checkAEPSTransId(token, txnId) async {
    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {"PartnerRefIdStan": "$txnId"};

      String result = await platform.invokeMethod("aepsId", arr);
      printMessage(screen, "AEPS ID Response : $result");

      if (result != null && result.length != 0 && result != "") {
        callAESPStatusCheck(token, result, txnId);
      }
    }
  }

  Future callAESPStatusCheck(token, result, txnId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var header = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    final response = await http.post(Uri.parse(checkAEPSTransStatus),
        headers: header, body: (result), encoding: Encoding.getByName("utf-8"));

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "AEPS callAESPStatusCheck - $data");

    setState(() {
      Navigator.pop(context);

      if (data.containsKey("isSuccess")) {
        printMessage(screen, "Is Success");
        try {
          //var json = jsonDecode(data);
          var json = data;
          var isSuccess = json['isSuccess'];
          var message = json['message'];

          if (isSuccess.toString() == "true") {
            var partnerRefId = json['data'][0]['partnerRefId'];
            var amount = json['data'][0]['amount'];
            var bankResponseMsg = json['data'][0]['bankResponseMsg'];
            var merchantMobileNo = json['data'][0]['merchantMobileNo'];
            var aadhaarNo = json['data'][0]['aadharNo'];
            var txnCode = "NA";
            var rrn = json['data'][0]['rrn'];
            var bankIIN = json['data'][0]['bankIIN'];
            var stan = json['data'][0]['stan'];
            var txnDate = json['data'][0]['txnDate'];

            updateCWStatus(
                partnerRefId,
                amount,
                message,
                bankResponseMsg,
                merchantMobileNo,
                aadhaarNo,
                txnCode,
                rrn,
                bankIIN,
                stan,
                txnDate,
                txnId);
          } else {
            printMessage(screen, "Is Failed");
            setState(() {});
          }
        } catch (e) {
          printMessage(screen, "AEPS ERROR - ${e.toString()}");
        }
      } else {
        printMessage(screen, "Is Failed");
      }
    });
  }

  Future updateCWStatus(
      partnerRefId,
      amount,
      message,
      bankResponseMsg,
      merchantMobileNo,
      aadhaarNo,
      txnCode,
      rrn,
      bankIIN,
      stan,
      txnDate,
      txnId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var mId = await getMerchantID();
    var aepsId = await getAEPSMerchantId();
    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    var body = {
      "m_id": "$mId",
      "merchant_Id": "$aepsId",
      "partnerRefId": "$partnerRefId",
      "amount": "$amount",
      "message": "$message",
      "bankResponseMsg": "$bankResponseMsg",
      "merchantMobileNo": "$merchantMobileNo",
      "aadhaarNo": "$aadhaarNo",
      "txnCode": "$txnCode",
      "rrn": "$rrn",
      "bankIIN": "$bankIIN",
      "stan": "$stan",
      "txnDate": "$txnDate",
      "token": "$token",
      "txnid": "$txnId"
    };

    printMessage(screen, "AEPS Check Body : $body");

    final response = await http.post(Uri.parse(aeps2ResponseAPI),
        headers: headers, body: jsonEncode(body));
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "AEPS Check  Response : $data");

      setState(() {
        Navigator.pop(context);

        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
          var commission = data['commission'].toString();
          Map map = {
            "date": "$txnDate",
            "transId": "$rrn",
            "refId": "$partnerRefId",
            "amount": "$amount",
            "mode": "$txnCode",
            "status": "$message",
            "adhar": "$aadhaarNo",
            "mobile": "$merchantMobileNo",
            "merComm": "$commission",
          };
          openAEPSReceipt(context, map, false);
        } else {
          showToastMessage("Something went wrong. Please after sometime");
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  Future getATMAuthToken(matmTxnId) async {
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
        _checkMatmTransId(authToken, matmTxnId);
      } else {
        showToastMessage("Something went wrong. Please after sometime");
      }
    });
  }

  _checkMatmTransId(token, matmTxnId) async {
    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {"PartnerRefIdStan": "$matmTxnId"};

      String result = await platform.invokeMethod("aepsId", arr);
      printMessage(screen, "MATM ID Response : $result");

      if (result != null && result.length != 0 && result != "") {
        callMATMStatusCheck(token, result, matmTxnId);
      }
    }
  }

  Future callMATMStatusCheck(token, result, txnId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var header = {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json"
    };

    final response = await http.post(Uri.parse(checkMATMCWTxnStatus),
        headers: header, body: (result), encoding: Encoding.getByName("utf-8"));

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "MATM Status Check - $data");

    setState(() {
      Navigator.pop(context);
      if (data.containsKey("isSuccess")) {
        printMessage(screen, "Is Success");
        try {
          var json = data;
          var isSuccess = json['isSuccess'];
          var message = json['message'];

          if (isSuccess.toString() == "true") {
            var stan = json['data'][0]['stan'];
            var amount = json['data'][0]['amount'];
            var cardNo = json['data'][0]['cardNo'];
            var cardType = json['data'][0]['cardType'];
            var txnDate = json['data'][0]['txnDate'];
            var bankName = json['data'][0]['bankName'];
            var merchant_Id = json['data'][0]['merchant_Id'];
            var merchantEmailId = json['data'][0]['merchantEmailId'];
            var merchantMobileNo = json['data'][0]['merchantMobileNo'];
            var merchantName = json['data'][0]['merchantName'];
            var txnCode = json['data'][0]['txnCode'];
            var rrn = json['data'][0]['rrn'];
            var terminalId = json['data'][0]['terminalId'];
            var partnerRefId = json['data'][0]['partnerRefId'];
            var merchantAddress = json['data'][0]['merchantAddress'];

            /*if (txnCode.toString() == "CW" || txnCode.toString() == "cw") {
              submitTransResult(amount, cardNo, cardType, terminalId, txnDate,
                  txnId, bankName, partnerRefId, message, rrn, txnId);
            }*/

            Map p = {
              "message": "Transaction Success",
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
              "txnid": "$txnId",
              "removeAll": "No",
              "txnStatus": "$message"
            };

            openTransactionRecpit(context, p);
          } else {
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
              "txnid": "$txnId",
              "removeAll": "No",
              "txnStatus": "$message"
            };
            openTransactionRecpit(context, p);

            showToastMessage(json['message'].toString());
          }
        } catch (e) {
          printMessage(screen, "AEPS ERROR - ${e.toString()}");
        }
      } else {
        printMessage(screen, "Is Failed");
      }
    });
  }

  Future getPayoutTransaction() async {
    setState(() {
      loading7 = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"user_token": token, "page": "1"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(walletMerchantTransctionAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        loading7 = false;
        if (data['status'].toString() == "1") {
          var result =
              PayoutList.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          payoutList = result.payoutList;
          UPITxnTotalPage = result.totalPages;
        }
      });
    } else {
      setState(() {
        loading7 = false;
      });
      showToastMessage(status500);
    }
  }

  Future getPayoutTransactionOnScroll(pageNo) async {
    setState(() {
      isUPITxnReload = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"user_token": token, "page": "$pageNo"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(walletMerchantTransctionAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        isUPITxnReload = false;
        if (data['status'].toString() == "1") {
          //var result = PayoutList.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          //payoutList = result.payoutList;

          List<PayoutListElement> payoutListNew = [];
          if (data['payout_list'].length != 0) {
            for (int i = 0; i < data['payout_list'].length; i++) {
              var date = data['payout_list'][i]['date'];
              var merchantRefId = data['payout_list'][i]['merchantRefId'];
              var beneAccount = data['payout_list'][i]['bene_account'];
              var ifscJcode = data['payout_list'][i]['ifsc_jcode'];
              var beneName = data['payout_list'][i]['bene_name'];
              var mobile = data['payout_list'][i]['mobile'];
              var amount = data['payout_list'][i]['amount'];
              var status = data['payout_list'][i]['status'];
              var walletType = data['payout_list'][i]['wallet_type'];

              PayoutListElement pay = new PayoutListElement(
                  date: date,
                  merchantRefId: merchantRefId,
                  beneAccount: beneAccount,
                  ifscJcode: ifscJcode,
                  beneName: beneName,
                  mobile: mobile,
                  amount: amount,
                  status: status,
                  walletType: walletType);

              payoutListNew.add(pay);
              payoutList.insertAll(payoutList.length, payoutListNew);
            }
          }
        }
      });
    } else {
      setState(() {
        isUPITxnReload = false;
      });
      showToastMessage(status500);
    }
  }

  Future generateTransPayoutToken(mTransId, accNo, walletType) async {
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
      getCheckTransStatus(token, mTransId, accNo, walletType);
    } else {
      setState(() {
        showToastMessage(somethingWrong);
      });
    }
  }

  Future getCheckTransStatus(token, mTransId, accNo, walletType) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait while we check your transaction status");
          });
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": userToken,
      "access_token": "$token",
      "merchantRefId": "$mTransId",
      "wallet_type": "$walletType"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(walletPayoutStatusCheckAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "CHeck status response : $data");

      setState(() {
        Navigator.pop(context);

        if (data['status'].toString() == "1") {
          printMessage(
              screen, "${data['result']['data']['transactionDetails']}");

          var txnStatus =
              data['result']['data']['transactionDetails'][0]['txnStatus'];
          var txnId = data['result']['data']['transactionDetails'][0]['txnId'];
          var mRefId =
              data['result']['data']['transactionDetails'][0]['merchantRefId'];
          var name = data['result']['data']['transactionDetails'][0]
              ['beneficiaryName'];
          var purpose =
              data['result']['data']['transactionDetails'][0]['purpose'];
          var amount =
              data['result']['data']['transactionDetails'][0]['amount'];
          var txnDate =
              data['result']['data']['transactionDetails'][0]['txnDate'];

          Map map1 = {
            "txnStatus": txnStatus,
            "txnId": txnId,
            "mRefId": mRefId,
            "name": name,
            "purpose": purpose,
            "amount": amount,
            "txnDate": txnDate,
            "accNo": "$accNo"
          };

          Map map = {
            "date": "$txnDate",
            "merchantRefId": "$mRefId",
            "bene_account": "$accNo",
            "ifsc_jcode": "null",
            "bene_name": "$name",
            "mobile": "null",
            "amount": "$amount",
            "status": "$txnStatus",
            "wallet_type": "$purpose"
          };

          openTransPayoutRecipt(context, map);
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

/*Future submitTransResult(amount, cardNo, cardType, terminalId, txnDate, txnId,
      bankName, partnerRefId, message, rrn, txnid) async {
    try {
      setState(() {});

      var mId = await getMerchantID();
      var token = await getToken();
      var merchantId = await getMATMMerchantId();

      var headers = {
        "Content-Type": "application/json",
        "Authorization": "$authHeader",
      };

      var body = {
        "m_id": "$mId",
        "token": "$token",
        "merchantId": "$merchantId",
        "amount": "$amount",
        "cardNo": "$cardNo",
        "cardType": "$cardType",
        "terminalId": "$terminalId",
        "txndate": "$txnDate",
        "txnId": "$txnId",
        "bank_name": "$bankName",
        "partnerRefId": "$partnerRefId",
        "message": "$message",
        "rrn": "$rrn",
        "txnid": "$txnid"
      };

      printMessage(screen, "Body : $body");

      final response = await http.post(Uri.parse(microatmResponseAddAPI),
          body: jsonEncode(body), headers: headers);

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Final Code : $data");

      setState(() {
        showToastMessage(data['message'].toString());
      });
    } catch (e) {
      printMessage(screen, "Final Code : $e");
    }
  }*/

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

  Future getBranchTransactions() async {
    setState(() {
      loading2 = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"user_token": token, "page": "1"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchTransctionAllAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "All Hist : $data");

      setState(() {
        loading2 = false;
        if (data['status'].toString() == "1") {
          var result = BranchTransHistory.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          branchTransHistories = result.transctionList;

          BranchTotalPage = result.totalPages;
        }
      });
    } else {
      setState(() {
        loading2 = false;
      });
      showToastMessage(status500);
    }
  }

  Future getBranchTransactionsOnScroll(pageBranch) async {
    setState(() {
      isBranchReload = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"user_token": token, "page": "$pageBranch"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchTransctionAllAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "All Hist : $data");

      setState(() {
        isBranchReload = false;
        if (data['status'].toString() == "1") {
          var result = BranchTransHistory.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));

          List<TransctionList> branchHistories = result.transctionList;

          branchTransHistories.insertAll(
              branchTransHistories.length, branchHistories);

          printMessage(screen, "QR Size : ${branchTransHistories.length}");
        }
      });
    } else {
      setState(() {
        isBranchReload = false;
      });
      showToastMessage(status500);
    }
  }

  Future getTodayTransactions() async {
    setState(() {
      todayTxns.clear();
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
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(qrTodayTransctionsAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    Navigator.pop(context);

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Today Txn : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          var result = SortBranchData.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          todayTxns = result.todayTxn;

          totalAmt = data['total_amount'];

          if (todayTxns.length != 0) {
            isSort = true;
          } else {
            isSort = false;
          }
        } else {
          isSort = true;
          totalAmt = 0.0;
        }
      });
    } else {
      setState(() {
        isSort = false;
      });
      showToastMessage(status500);
    }
  }

  showPopupMenuUPI(Offset globalPosition) {
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
                Text("Today")
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
                Text("By Date")
              ],
            ),
            value: '2'),
      ],
      elevation: 8.0,
    ).then<void>((itemSelected) {
      if (itemSelected == null) return;

      if (itemSelected == "1") {
        getTodayTransactions();
      } else if (itemSelected == "2") {
        openSwitchDates(context, 1, "", "", "");
      }
    });
  }

  Future getDateTransactions(fromDate, toDate, page) async {
    setState(() {
      todayTxns.clear();
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
      "from_date": "$fromDate",
      "to_date": "$toDate",
      'page': "$page"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(qrTransctionsSortingAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    Navigator.pop(context);

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "All b Txn : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          var result = SortBranchData.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          // todayTxns.addAll(result.todayTxn);
          todayTxns = result.todayTxn;
          totalAmt = result.totalAmount;

          if (todayTxns.length != 0) {
            isSort = true;
          } else {
            isSort = false;
          }
        } else {
          isSort = true;
          totalAmt = 0.0;
        }
      });
    } else {
      setState(() {
        isSort = false;
      });
      showToastMessage(status500);
    }
  }

  Future getSortedDateTransactions(fromDate, toDate, page) async {
    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "from_date": "$fromDate",
      "to_date": "$toDate",
      'page': "$page"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(qrTransctionsSortingAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "All b Txn : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          var result = SortBranchData.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          todayTxns.addAll(result.todayTxn);
          // todayTxns = result.todayTxn;
          totalAmt = totalAmt + result.totalAmount;

          if (todayTxns.length != 0) {
            isSort = true;
          } else {
            isSort = false;
          }
        } else {
          isSort = true;
          totalAmt = 0.0;
        }
      });
    } else {
      setState(() {
        isSort = false;
      });
      showToastMessage(status500);
    }
  }
}
