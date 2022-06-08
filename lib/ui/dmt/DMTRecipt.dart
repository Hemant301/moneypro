import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class DMTRecipt extends StatefulWidget {
  final Map map;

  const DMTRecipt({Key? key, required this.map}) : super(key: key);

  @override
  _DMTReciptState createState() => _DMTReciptState();
}

class _DMTReciptState extends State<DMTRecipt> {
  var screen = "DMT Transaction Recipt";

  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  var rechargeStatus;

  String ad = "";

  @override
  void initState() {
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);
    getX();
    setState(() {
      rechargeStatus = widget.map['status'].toString();
    });
  }

  getX() async {
    var v = await generateXFormat(widget.map['acc_no'].toString());
    setState(() {
      ad = v;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => WillPopScope(
              onWillPop: () async {
                printMessage(screen, "Mobile back pressed");
                removeAllPages(context);
                return false;
              },
              child: SafeArea(
                  child: Scaffold(
                backgroundColor: white,
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
                        shareTransReceipt(_printKey, "DMTrecipt");
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
                    child: Stack(
                      children: [
                        Column(
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
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(40)),
                                        child: (rechargeStatus == "null" ||
                                                rechargeStatus
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "failure")
                                            ? Image.asset(
                                                "assets/failed.png")
                                            : (rechargeStatus
                                                        .toString()
                                                        .toLowerCase() ==
                                                    "pending")
                                                ? Image.asset(
                                                    "assets/pending.png")
                                                : Image.asset(
                                                    "assets/pin_alert.png")),
                                  ),
                                ),
                                SizedBox(
                                  height: 20.h,
                                ),
                                Text(
                                  (rechargeStatus == "null")
                                      ? "Transaction Failed"
                                      : "Transaction $rechargeStatus",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "$rupeeSymbol ${widget.map['amount']}",
                                  style: TextStyle(
                                      fontSize: font18.sp, color: black),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            ),
                            Expanded(
                                flex: 2,
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(50.0)),
                                    color: white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.5),
                                        spreadRadius: 10,
                                        blurRadius: 10,
                                        offset: Offset(
                                            0, 1), // changes position of shadow
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
                                                    color: lightBlack,
                                                    fontSize: font13.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                "${widget.map['transId']}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                    color: lightBlack,
                                                    fontSize: font13.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                (widget.map['date']
                                                            .toString() ==
                                                        "null")
                                                    ? "NA"
                                                    : "${widget.map['date']}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                "Mode",
                                                style: TextStyle(
                                                    color: lightBlack,
                                                    fontSize: font13.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                "${widget.map['mode']}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                "Account No.",
                                                style: TextStyle(
                                                    color: lightBlack,
                                                    fontSize: font13.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                "$ad",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                "Customer Charge",
                                                style: TextStyle(
                                                    color: lightBlack,
                                                    fontSize: font13.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                "${widget.map['customer_charge']}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                "Total Payable Amt",
                                                style: TextStyle(
                                                    color: lightBlack,
                                                    fontSize: font13.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                "${widget.map['total_payable_amnt']}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
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
                                                "Mobile",
                                                style: TextStyle(
                                                    color: lightBlack,
                                                    fontSize: font13.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                "${widget.map['mobile']}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(height: 15.h),
                                        Divider(
                                          color: gray,
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 15, top: 15),
                                          child: Row(
                                            children: [
                                              Text(
                                                "$customerCare",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font14.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                "$merchantMob",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font14.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 15.0, right: 15, top: 5),
                                          child: Row(
                                            children: [
                                              Text(
                                                "$customerEmail",
                                                style: TextStyle(
                                                    color: lightBlue,
                                                    fontSize: font14.sp),
                                              ),
                                              Spacer(),
                                              Text(
                                                "$mobileChar",
                                                style: TextStyle(
                                                    color: lightBlue,
                                                    fontSize: font14.sp),
                                              )
                                            ],
                                          ),
                                        ),
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                      ],
                                    ),
                                  ),
                                ))
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              )),
            ));
  }
}
