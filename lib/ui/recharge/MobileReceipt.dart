import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/footer/ShowCashback.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class MobileReceipt extends StatefulWidget {
  final Map map;
  final bool isShowDialog;

  const MobileReceipt({Key? key, required this.map, required this.isShowDialog})
      : super(key: key);

  @override
  _MobileReceiptState createState() => _MobileReceiptState();
}

class _MobileReceiptState extends State<MobileReceipt>
    with SingleTickerProviderStateMixin {
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();
  var screen = "Mobile Receipt";
  var role;

  @override
  void initState() {
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);
    getUserDetails();
    Timer(Duration(seconds: 2), () {
      if (widget.isShowDialog &&
          widget.map['commission'].toString() != "null" &&
          widget.isShowDialog &&
          widget.map['commission'].toString() != "0" &&
          widget.map['commission'].toString() != "") {
        cashbackPopup();
      }
    });
  }

  getUserDetails() async {
    var r = await getRole();
    setState(() {
      role = r;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>WillPopScope(
      onWillPop: () async {
        printMessage(screen, "Mobile back pressed");
        removeAllPages(context);
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          backgroundColor: white,
          brightness: Brightness.light,
          leading: IconButton(
            icon: Image.asset(
              'assets/back_arrow.png',
              height: 24.h,
            ),
            onPressed: () {
              closeKeyBoard(context);
              removeAllPages(context);
            },
          ),
          titleSpacing: 0,
          title: appLogo(),
          actions: [
            InkWell(
              onTap: () {
                shareTransReceipt(_printKey, "recipt");
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(
                  'assets/share.png',
                  color: lightBlue,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                downloadReceiptAsPDF(_printKey);
              },
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Image.asset(
                  'assets/download_file.png',
                  color: lightBlue,
                ),
              ),
            ),
            SizedBox(
              width: 10.w,
            )
          ],
        ),
        body: RepaintBoundary(
          key: _printKey,
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            color: white,
            child: Column(
              children: [
                Column(
                  children: [
                    SizedBox(
                      height: 30.h,
                    ),
                    Center(
                      child: CircleAvatar(
                        backgroundColor: Colors.transparent,
                        radius: 40,
                        child: ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(40)),
                            child: Image.asset("assets/pin_alert.png")),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Transaction ${widget.map['TxStatus']}",
                      style: TextStyle(
                          color: black,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Text(
                      "$rupeeSymbol ${widget.map['orderAmount']}",
                      style: TextStyle(fontSize: font18.sp, color: black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40.h,
                ),
                Expanded(
                    child: Container(
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
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        SizedBox(
                          height: 40.h,
                        ),
                        Center(
                          child: Container(
                            color: gray,
                            width: 50.w,
                            height: 5.h,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 40.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "$transactionId",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              Spacer(),
                              Text(
                                "${widget.map['tId']}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "Date",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              Spacer(),
                              Text(
                                "${widget.map['txTime']}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "Operator",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              Spacer(),
                              Text(
                                "${widget.map['operatorName']}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "Reference ID",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              Spacer(),
                              Text(
                                "${widget.map['referenceId']}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 30.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "$mode_",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              Spacer(),
                              Text(
                                "${widget.map['paymentMode']}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13.sp,
                                    fontWeight: FontWeight.bold),
                              )
                            ],
                          ),
                        ),
                        SizedBox(height: 25.h),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 0),
                          child: Row(
                            children: [
                              Text(
                                "$customerCare",
                                style:
                                    TextStyle(color: black, fontSize: font14.sp),
                              ),
                              Spacer(),
                              (role == "3")
                                  ? Text(
                                      "$merchantMob",
                                      style: TextStyle(
                                          color: black, fontSize: font14.sp),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 5, bottom: 20),
                          child: Row(
                            children: [
                              Text(
                                "$customerEmail",
                                style: TextStyle(
                                    color: lightBlue, fontSize: font14.sp),
                              ),
                              Spacer(),
                              (role == "3")
                                  ? Text(
                                      "$mobileChar",
                                      style: TextStyle(
                                          color: lightBlue, fontSize: font14.sp),
                                    )
                                  : Container(),
                            ],
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.only(
                              left: 15, right: 15, bottom: 10, top: 20),
                          child: Image.asset(
                            'assets/wallet_banner.png',
                          ),
                        ),
                      ],
                    ),
                  ),
                ))
              ],
            ),
          ),
        ),
      )),
    ));
  }

  cashbackPopup() {
    showModalBottomSheet(
        context: context,
        enableDrag: false,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ShowCashback(
              commission: widget.map['commission'].toString(),
              id: "",
            ));
  }
}
