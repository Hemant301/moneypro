import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/BranchPartiTransaction.dart';
import 'package:moneypro_new/ui/models/History.dart';
import 'package:moneypro_new/ui/models/Settelments.dart';
import 'package:moneypro_new/ui/models/SortBranchData.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/AppKeys.dart';

class BranchTransactions extends StatefulWidget {
  final String branchId;
  final String mobile;
  final String branchWallet;
  final String fromDate;
  final String toDate;

  const BranchTransactions(
      {Key? key,
      required this.branchId,
      required this.mobile,
      required this.branchWallet,
      required this.fromDate,
      required this.toDate})
      : super(key: key);

  @override
  _BranchTransactionsState createState() => _BranchTransactionsState();
}

class _BranchTransactionsState extends State<BranchTransactions> {
  var screen = "Branch Transaction";

  int selectedIndex = 1;

  var qrLoading = false;

  var qrSettleLoading = false;

  List<BranchSelfTrans> branchSelfTransList = [];

  //List<RequestList> settlementList = [];
  List<TodayTxn> todayTxns = [];

  bool isQrResponseReload = false;
  int pageQrResponse = 1;
  int qrResponseTotalPage = 0;
  late ScrollController scrollQrResponseController;

  var totalAmt;
  var isSort = false;

  final f = new DateFormat('dd-MM-yyyy');
  DateTime currentFromDate = DateTime.now();
  DateTime currentToDate = DateTime.now();
  final passDateFormat = new DateFormat('yyyy-MM-dd');

  var cDate;

  var isFromDateSelected = false;
  var isToDateSelected = false;
  int pageSort = 1;

  @override
  void initState() {
    super.initState();
    printMessage(screen, "Branch Wallet : ${widget.branchWallet}");
    updateATMStatus(context);
    scrollQrResponseController = new ScrollController()
      ..addListener(_scrollQrResponseListener);
    //scrollSettlementController = new ScrollController()..addListener(_scrollSettlementListener);

    setState(() {
      cDate = f.format(currentFromDate);
    });

    if (widget.fromDate.toString() != "" && widget.toDate.toString() != "") {
      printMessage(screen, "InSide Wiget");
      setState(() {});
      Timer(Duration(seconds: 1), () {
        getDateTransactions(
            widget.fromDate.toString(), widget.toDate.toString(), pageSort);
      });
    } else {
      setState(() {
        if (widget.branchWallet.toString() == "") {
          totalAmt = 0.0;
        } else {
          totalAmt = double.parse(widget.branchWallet);
        }
      });
      getQRTransactions();
    }
  }

  void _scrollQrResponseListener() {
    if (isSort == true) {
      // print('issort his h');
      if (scrollQrResponseController.position.pixels ==
          scrollQrResponseController.position.maxScrollExtent) {
        setState(() {
          pageSort = pageSort + 1;
          getSortDateTransactions(
              widget.fromDate.toString(), widget.toDate.toString(), pageSort);
        });
      }
    }
    if (pageQrResponse <= qrResponseTotalPage) {
      // if (scrollQrResponseController.position.extentAfter < 500) {
      if (scrollQrResponseController.position.pixels ==
          scrollQrResponseController.position.maxScrollExtent) {
        setState(() {
          isQrResponseReload = true;
          if (isQrResponseReload) {
            isQrResponseReload = false;
            pageQrResponse = pageQrResponse + 1;
            getQRTransactionsOnScroll(pageQrResponse);
          }
        });
      }
    }
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
                leading: InkWell(
                  onTap: () {
                    closeCurrentPage(context);
                    closeKeyBoard(context);
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
                    width: 24.w,
                    color: orange,
                  ),
                  SizedBox(
                    width: 10.w,
                  )
                ],
              ),
              body: RefreshIndicator(
                  onRefresh: () async {
                    getQRTransactionsOnRefresh();
                  },
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                                child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "QR Transaction",
                                    style: TextStyle(
                                        color: (selectedIndex == 1)
                                            ? lightBlue
                                            : black,
                                        fontSize: font16.sp,
                                        fontWeight: (selectedIndex == 1)
                                            ? FontWeight.bold
                                            : FontWeight.normal),
                                  ),
                                ),
                                Divider(
                                  color: (selectedIndex == 1) ? blue : white,
                                  thickness: 3,
                                ),
                              ],
                            )),
                            Expanded(child: Container()),
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
                              width: 20.w,
                            ),
                          ],
                        ),
                        Divider(),
                        SizedBox(
                          height: 10.h,
                        ),
                        (qrLoading)
                            ? Center(
                                child: circularProgressLoading(40.0),
                              )
                            : Expanded(
                                child: SingleChildScrollView(
                                    physics: AlwaysScrollableScrollPhysics(),
                                    controller: scrollQrResponseController,
                                    child: (isSort)
                                        ? (todayTxns.length == 0)
                                            ? _emptyData()
                                            : Column(
                                                children: [
                                                  InkWell(
                                                    onTap: () {
                                                      print('object');
                                                    },
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 25.0),
                                                      child: Row(
                                                        children: [
                                                          Image.asset(
                                                            'assets/qr_menu.png',
                                                            height: 20.h,
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Text(
                                                            "Total $rupeeSymbol $totalAmt",
                                                            style: TextStyle(
                                                                color: black,
                                                                fontSize:
                                                                    font18.sp,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold),
                                                          )
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  _buildTodayTransactions()
                                                ],
                                              )
                                        : (branchSelfTransList.length == 0)
                                            ? _emptyData()
                                            : Column(
                                                children: [
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 25.0),
                                                    child: Row(
                                                      children: [
                                                        Image.asset(
                                                          'assets/qr_menu.png',
                                                          height: 20.h,
                                                        ),
                                                        SizedBox(
                                                          width: 5.w,
                                                        ),
                                                        Text(
                                                          "Total $rupeeSymbol ${formatDecimal2Digit.format(totalAmt)}",
                                                          style: TextStyle(
                                                              color: black,
                                                              fontSize:
                                                                  font18.sp,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  _buildTransactions(),
                                                  isQrResponseReload == true
                                                      ? Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8.0),
                                                          child:
                                                              CircularProgressIndicator(),
                                                        )
                                                      : Container()
                                                ],
                                              ))),
                      ])),
            )));
  }

  _emptyData() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 150.h,
          ),
          Image.asset(
            'assets/no_member.png',
            height: 210.h,
          ),
          Text(
            "No record found",
            style: TextStyle(
                color: black, fontSize: font16.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  _buildTransactions() {
    return ListView.builder(
      itemCount: branchSelfTransList.length,
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
                                "Txn Id: ${branchSelfTransList[index].transctionId}",
                                style: TextStyle(
                                    color: black, fontSize: font14.sp),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                "${branchSelfTransList[index].name}",
                                style: TextStyle(
                                    color: black, fontSize: font14.sp),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                "${branchSelfTransList[index].branchName}",
                                style: TextStyle(
                                    color: black, fontSize: font14.sp),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 0.0),
                              child: Text(
                                "${branchSelfTransList[index].date} | ${branchSelfTransList[index].time}",
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
                            "$rupeeSymbol ${branchSelfTransList[index].amount}",
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

  _buildTodayTransactions() {
    return ListView.builder(
      itemCount: todayTxns.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 0),
          child: InkWell(
            onTap: () {
              print('ye lo');
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

  Future getQRTransactions() async {
    setState(() {
      qrLoading = true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "branch_id": "${widget.branchId}",
      "mobile": "${widget.mobile}",
      "page": "1",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchTransctionAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Branch Txn : $data");
      setState(() {
        qrLoading = false;
        if (data['status'].toString() == "1") {
          var result = BranchPartiTransaction.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          branchSelfTransList = result.transctionList;
          qrResponseTotalPage = int.parse(data['total_pages'].toString());
        }
      });
    } else {
      setState(() {
        qrLoading = false;
      });
      showToastMessage(status500);
    }
  }

  Future getQRTransactionsOnRefresh() async {
    setState(() {
      //qrLoading = true;
      branchSelfTransList.clear();
      qrResponseTotalPage = 0;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "branch_id": "${widget.branchId}",
      "mobile": "${widget.mobile}",
      "page": "1",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchTransctionAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Branch Txn : $data");
      setState(() {
        //qrLoading = false;
        if (data['status'].toString() == "1") {
          var result = BranchPartiTransaction.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          branchSelfTransList = result.transctionList;
          qrResponseTotalPage = int.parse(data['total_pages'].toString());
        }
      });
    } else {
      setState(() {
        //qrLoading = false;
      });
      showToastMessage(status500);
    }
  }

  Future getQRTransactionsOnScroll(page) async {
    setState(() {
      isQrResponseReload = true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "branch_id": "${widget.branchId}",
      "mobile": "${widget.mobile}",
      "page": "$page"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchTransctionAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        isQrResponseReload = false;
        if (data['status'].toString() == "1") {
          List<BranchSelfTrans> branchSelfTransListNew = [];

          if (data['transction_list'].length != 0) {
            for (int i = 0; i < data['transction_list'].length; i++) {
              var date = data['transction_list'][i]['date'];
              var transctionId = data['transction_list'][i]['transction_id'];
              var amount = data['transction_list'][i]['amount'];
              var branchName = data['transction_list'][i]['branch_name'];
              var time = data['transction_list'][i]['time'];
              var name = data['transction_list'][i]['name'];

              BranchSelfTrans pay = new BranchSelfTrans(
                  date: date,
                  transctionId: transctionId,
                  amount: amount,
                  branchName: branchName,
                  time: time,
                  name: name);

              branchSelfTransListNew.add(pay);
              branchSelfTransList.insertAll(
                  branchSelfTransList.length, branchSelfTransListNew);
            }
          }
        }
      });
    } else {
      setState(() {
        isQrResponseReload = false;
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
        openSwitchDates(
            context, 2, widget.branchId, widget.mobile, widget.branchWallet);
      }
    });
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

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "branch_id": "${widget.branchId}",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(qrBranchTodayTransctionsAPI),
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
          totalAmt = result.totalAmount;

          if (todayTxns.length != 0) {
            isSort = true;
          } else {
            isSort = false;
          }
        } else {
          setState(() {
            isSort = true;
            totalAmt = 0.0;
          });
        }
      });
    } else {
      setState(() {
        isSort = false;
      });
      showToastMessage(status500);
    }
  }

  requestPendingPopUp() {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(padding),
        ),
        elevation: 0,
        backgroundColor: Colors.transparent,
        child: Wrap(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  border: Border.all(color: white)),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 15),
                    child: Text(
                      "Search transaction by Date",
                      style: TextStyle(
                          color: black,
                          fontSize: font16,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20.0, right: 20, bottom: 0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              _selectFromDate();
                              //  pickFromDate();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: editBg,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  (cDate.toString() ==
                                          f.format(currentFromDate).toString())
                                      ? "Select from date"
                                      : f.format(currentFromDate),
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 15.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              _selectToDate();
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: editBg,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  (cDate.toString() ==
                                          f.format(currentToDate).toString())
                                      ? "Select to date"
                                      : f.format(currentToDate),
                                  style: TextStyle(
                                      color: black, fontSize: font14.sp),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      onTap: () {
                        printMessage(screen,
                            "From Date : ${passDateFormat.format(currentFromDate)}");
                        printMessage(screen,
                            "From Date : ${passDateFormat.format(currentToDate)}");

                        Navigator.pop(context);

                        getDateTransactions(
                            passDateFormat.format(currentFromDate),
                            passDateFormat.format(currentToDate),
                            pageSort);
                      },
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 0, left: 0, right: 0, bottom: 10),
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Center(
                          child: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text(
                              submit.toUpperCase(),
                              style: TextStyle(fontSize: font15, color: white),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }

  Future _selectFromDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentFromDate,
        firstDate: DateTime(2021),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      setState(() {
        currentFromDate = pickedDate;
        printMessage(screen, "From Date : $currentFromDate");
        isFromDateSelected = true;
      });
    } else {
      setState(() {
        isFromDateSelected = false;
      });
    }
  }

  Future _selectToDate() async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentToDate,
        firstDate: DateTime(2021),
        lastDate: DateTime.now());
    if (pickedDate != null) {
      setState(() {
        currentToDate = pickedDate;
        printMessage(screen, "To Date : $currentToDate");
        isToDateSelected = true;
      });
    } else {
      setState(() {
        isToDateSelected = false;
      });
    }
  }

  Future getDateTransactions(fromDate, toDate, pageSort) async {
    setState(() {
      todayTxns.clear();
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

    final body = {
      "branch_id": "${widget.branchId}",
      "from_date": "$fromDate",
      "to_date": "$toDate",
      'page': pageSort
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(qrBranchTransctionsSortingAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    Navigator.pop(context);

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "All Today Txn : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          var result = SortBranchData.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
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

  Future getSortDateTransactions(fromDate, toDate, pageSort) async {
    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "branch_id": "${widget.branchId}",
      "from_date": "$fromDate",
      "to_date": "$toDate",
      'page': '$pageSort'
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(qrBranchTransctionsSortingAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "All Today Txn : $data");

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
