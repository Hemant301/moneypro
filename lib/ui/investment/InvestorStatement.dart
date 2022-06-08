import 'dart:convert';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'package:http/http.dart' as http;
import 'package:moneypro_new/ui/models/InvestorStatementList.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class InvestorStatement extends StatefulWidget {
  const InvestorStatement({Key? key}) : super(key: key);

  @override
  _InvestorStatementState createState() => _InvestorStatementState();
}

class _InvestorStatementState extends State<InvestorStatement>
    with SingleTickerProviderStateMixin {
  var screen = "Investor Statement";

  var loading1 = false;
  var loading2 = false;

  int pageAc = 1;
  int pageErn = 1;
  int headerIndex = 0;

  var stateLoaded = false;
  var earnLoaded = false;

  bool isReload = false;
  late ScrollController _scrollController;

  int pageNo = 0;

  final List<Tab> tabs = <Tab>[
    new Tab(text: "A/c Statement"),
    new Tab(text: "Interest Earning"),
  ];

  TabController? _tabController;

  List<InvList> accStatementList = [];
  List<InvList> earningStatementList = [];

  @override
  void initState() {
    super.initState();
    _scrollController = new ScrollController()..addListener(_scrollListener);
    fetchUserAccountBalance();
    updateATMStatus(context);
    getRecentList(pageAc);
    _tabController = new TabController(vsync: this, length: tabs.length);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollListener() {
    if (_scrollController.position.extentAfter < 200) {
      printMessage(screen, "ON SCROLL CALLED");
      setState(() {
        isReload = true;
        if (isReload) {
          isReload = false;
          pageNo = pageNo + 1;
          getRecentListOnScroll(pageNo);
        }
      });
    }
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
              'assets/faq.png',
              width: 30.w,
              color: orange,
            ),
            SizedBox(
              width: 20.w,
            )
          ],
          bottom: TabBar(
            isScrollable: false,
            unselectedLabelColor: black,
            labelColor: lightBlue,
            labelStyle: TextStyle(fontSize: font14.sp),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: new BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: white,
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
                if (accStatementList.length == 0) getRecentList(pageAc);
              } else if (val == 1) {
                if (earningStatementList.length == 0) getRecentList(pageErn);
              }
            },
          )),
      body: (loading1)
          ? Center(
              child: circularProgressLoading(40.0),
            )
          : TabBarView(
              controller: _tabController,
              physics: NeverScrollableScrollPhysics(),
              children: [
                _buildRecentTransaction(),
                _buildEarningTransaction(),
              ],
            ),
      bottomNavigationBar: InkWell(
        onTap: () {
          _showDateChoose();
        },
        child: Container(
          height: (isReload) ? 90.h : 83.h,
          child: Column(
            children: [
              (isReload)
                  ? Center(
                      child: circularProgressLoading(20.0),
                    )
                  : Container(),
              Container(
                height: 45.h,
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 15),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    reqStatement,
                    style: TextStyle(fontSize: font13.sp, color: white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    )));
  }

  Future getRecentList(page) async {
    setState(() {
      loading1 = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {"token": "$token", "page": "$page"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(investmentInterestListAPI),
        body: jsonEncode(body), headers: headers);


    setState(() {
      loading1 = false;
      var statusCode = response.statusCode;
      if (statusCode == 200) {

        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Response statusCode : ${data}");

        if (data['status'].toString() == "1") {
          var result = InvestorStatementList.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          accStatementList = result.invList;

          for (int i = 0; i < accStatementList.length; i++) {
            if (accStatementList[i].status == 1) {
              String date = accStatementList[i].date;
              String investAmount = accStatementList[i].investAmount;
              String interset = accStatementList[i].interset;
              String closingBal = accStatementList[i].closingBal;
              String descp = accStatementList[i].descp;
              int status = accStatementList[i].status;
              String interestDate = accStatementList[i].interestDate;
              var merchantRefId = accStatementList[i].merchantRefId;

              InvList inv = new InvList(
                  date: date,
                  investAmount: investAmount,
                  interset: interset,
                  closingBal: closingBal,
                  descp: descp,
                  status: status,
                  interestDate: interestDate,
                  merchantRefId: merchantRefId);

              earningStatementList.add(inv);
            }
          }
        } else {
          showToastMessage(data['message'].toString());
        }
      }
    });
  }

  Future getRecentListOnScroll(page) async {
    setState(() {
      isReload = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {"token": "$token", "page": "$page"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(investmentInterestListAPI),
        body: jsonEncode(body), headers: headers);



    setState(() {
      isReload = false;
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Response statusCode : ${data}");

        if (data['status'].toString() == "1") {
          var result = InvestorStatementList.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));

          List<InvList> newList = result.invList;

          //accStatementList = accStatementList.insertAll(0, newList);

          accStatementList = accStatementList..addAll(newList);

          for (int i = 0; i < accStatementList.length; i++) {
            if (accStatementList[i].status == 1) {
              String date = accStatementList[i].date;
              String investAmount = accStatementList[i].investAmount;
              String interset = accStatementList[i].interset;
              String closingBal = accStatementList[i].closingBal;
              String descp = accStatementList[i].descp;
              int status = accStatementList[i].status;
              String interestDate = accStatementList[i].interestDate;
              var merchantRefId = accStatementList[i].merchantRefId;

              InvList inv = new InvList(
                  date: date,
                  investAmount: investAmount,
                  interset: interset,
                  closingBal: closingBal,
                  descp: descp,
                  status: status,
                  interestDate: interestDate,
                  merchantRefId: merchantRefId);

              earningStatementList.add(inv);
            }
          }
        } else {
          // showToastMessage(data['message'].toString());
        }
      }
    });
  }

  _buildRecentTransaction() {
    return (accStatementList.length == 0)
        ? Container(
            child: Container(
              height: 80.h,
              child: Center(
                child: Text(
                  "No recent transaction found",
                  style: TextStyle(color: black, fontSize: font14.sp),
                ),
              ),
            ),
          )
        : ListView.builder(
            itemCount: accStatementList.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            controller: _scrollController,
            itemBuilder: (context, index) {
              return (accStatementList[index].status == 1)
                  ? Container(
                      height: 50.h,
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: gray)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15.w,
                          ),
                          Container(
                              height: 36.h,
                              width: 36.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/send.png',
                                ),
                              )),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${accStatementList[index].descp}",
                                  style:
                                      TextStyle(color: black, fontSize: font14.sp),
                                ),
                                Text(
                                  "${accStatementList[index].date}",
                                  style:
                                      TextStyle(color: black, fontSize: font11.sp),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "+ ",
                            style: TextStyle(color: green, fontSize: font20.sp),
                          ),
                          Text(
                            "$rupeeSymbol ${accStatementList[index].interset}",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                          SizedBox(
                            width: 15.w,
                          )
                        ],
                      ),
                    )
                  : Container(
                      height: 50.h,
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: gray)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15.w,
                          ),
                          Container(
                              height: 36.h,
                              width: 36.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/send.png',
                                ),
                              )),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("${accStatementList[index].descp}",
                                    style: TextStyle(
                                        color: black, fontSize: font14.sp)),
                                Text(
                                  "${accStatementList[index].date}",
                                  style:
                                      TextStyle(color: black, fontSize: font11.sp),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            (accStatementList[index].descp.toLowerCase() ==
                                    "withdrawl")
                                ? "- "
                                : "+ ",
                            style: TextStyle(
                                color: (accStatementList[index]
                                            .descp
                                            .toLowerCase() ==
                                        "withdrawl")
                                    ? red
                                    : green,
                                fontSize: font22.sp),
                          ),
                          Text(
                              "$rupeeSymbol ${accStatementList[index].investAmount}"),
                          SizedBox(
                            width: 15.w,
                          )
                        ],
                      ),
                    );
            });
  }

  _buildEarningTransaction() {
    return (earningStatementList.length == 0)
        ? Container(
            child: Center(
              child: NoDataFound(text: ""),
            ),
          )
        : SingleChildScrollView(
            controller: _scrollController,
            child: ListView.builder(
              itemCount: earningStatementList.length,
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {},
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: gray)),
                        child: Row(
                          children: [
                            Container(
                                height: 36.h,
                                width: 36.w,
                                decoration: BoxDecoration(
                                  color: boxBg, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/send.png',
                                  ),
                                )),
                            Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8, top: 10, bottom: 10),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${earningStatementList[index].descp}",
                                            style: TextStyle(
                                                color: black, fontSize: font14.sp),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "$rupeeSymbol ${earningStatementList[index].investAmount}",
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                                color: black,
                                                fontSize: font14.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "$rupeeSymbol ${earningStatementList[index].interset}",
                                            textAlign: TextAlign.end,
                                            style: TextStyle(
                                                color: green,
                                                fontSize: font14.sp,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        SizedBox(
                                          width: 15.w,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      "${earningStatementList[index].interestDate}",
                                      style: TextStyle(
                                          color: black, fontSize: font12.sp),
                                    ),
                                    SizedBox(
                                      height: 4.h,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          );
  }

  _showDateChoose() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => MyBottomSheet());
  }
}

class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

enum selectOptions { last7days, last30days, FY2021_20, custom }

class _MyBottomSheetState extends State<MyBottomSheet> {
  selectOptions? _character = selectOptions.last7days;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: 336,
      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0))),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 30, bottom: 10),
            child: Text(
              "Request statement for",
              style: TextStyle(
                  color: lightBlue,
                  fontSize: font15,
                  fontWeight: FontWeight.w700),
            ),
          ),
          Divider(
            height: 1,
            color: gray,
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 0,
            title: Text('Last 7 Days',
                style: TextStyle(
                  color: lightBlue,
                  fontSize: font13,
                )),
            leading: Radio<selectOptions>(
              value: selectOptions.last7days,
              groupValue: _character,
              onChanged: (selectOptions? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
            color: gray,
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 0,
            title: Text('Last 30 Days',
                style: TextStyle(
                  color: lightBlue,
                  fontSize: font13,
                )),
            leading: Radio<selectOptions>(
              value: selectOptions.last30days,
              groupValue: _character,
              onChanged: (selectOptions? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
            color: gray,
          ),
          ListTile(
            dense: true,
            horizontalTitleGap: 0,
            title: Text('FY 2021-20',
                style: TextStyle(
                  color: lightBlue,
                  fontSize: font13,
                )),
            leading: Radio<selectOptions>(
              value: selectOptions.FY2021_20,
              groupValue: _character,
              onChanged: (selectOptions? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
            color: gray,
          ),
          ListTile(
            horizontalTitleGap: 0,
            title: Text('Custom Dates',
                style: TextStyle(
                  color: lightBlue,
                  fontSize: font13,
                )),
            dense: true,
            leading: Radio<selectOptions>(
              value: selectOptions.custom,
              groupValue: _character,
              onChanged: (selectOptions? value) {
                setState(() {
                  _character = value;
                });
              },
            ),
          ),
          Divider(
            height: 1,
            color: gray,
          ),
          InkWell(
            onTap: () {
              setState(() {
                closeKeyBoard(context);
                Navigator.pop(context);
              });
            },
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 10, left: 15, right: 15, bottom: 10),
              decoration: BoxDecoration(
                color: green,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Text(
                  reqStatement,
                  style: TextStyle(fontSize: font13, color: white),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
