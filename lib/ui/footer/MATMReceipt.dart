import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class MATMReceipt extends StatefulWidget {
  final Map map;
  const MATMReceipt({Key? key, required this.map}) : super(key: key);

  @override
  _MATMReceiptState createState() => _MATMReceiptState();
}

class _MATMReceiptState extends State<MATMReceipt> {
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();
  var screen = "ATM Receipt";

  @override
  void initState() {
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(deviceWidth, deviceHeight),
      builder: () => SafeArea(
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
              closeCurrentPage(context);
            },
          ),
          titleSpacing: 0,
          title: appLogo(),
          actions: [
            InkWell(
              onTap: () {
                shareTransReceipt(_printKey, "amtm");
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
                            child: (widget.map['status']
                                        .toString()
                                        .toLowerCase() ==
                                    "success")
                                ? Image.asset("assets/pin_alert.png")
                                : Image.asset("assets/failed.png")),
                      ),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    Text(
                      "Transaction ${widget.map['status']}",
                      style: TextStyle(
                          color: black,
                          fontSize: 22.sp,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      "$rupeeSymbol ${widget.map['amount'].toString()}",
                      style: TextStyle(fontSize: font18.sp, color: black),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
                SizedBox(
                  height: 30.h,
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
                              top: 20.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "Date",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${widget.map['date']}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font13.sp,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "Bank Name",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${widget.map['bankName']}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font13.sp,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "$transId",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              SizedBox(
                                width: 20,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${widget.map['transId']}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font13.sp,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "$refIdd",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${widget.map['refId']}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font13.sp,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "Terminal Id",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${widget.map['terminalId']}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font13.sp,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "Card No.",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${widget.map['card_no']}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font13.sp,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              top: 25.0, right: 30, left: 30),
                          child: Row(
                            children: [
                              Text(
                                "Mobile No.",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13.sp),
                              ),
                              SizedBox(
                                width: 20.w,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "$mobileChar",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font13.sp,
                                      fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.end,
                                ),
                              )
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
                        Divider(
                          color: gray,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 20),
                          child: Row(
                            children: [
                              Text(
                                "$customerCare",
                                style: TextStyle(
                                    color: black, fontSize: font14.sp),
                              ),
                              Spacer(),
                              Text(
                                "$merchantMob",
                                style: TextStyle(
                                    color: black, fontSize: font14.sp),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 5, bottom: 10),
                          child: Row(
                            children: [
                              Text(
                                "$customerEmail",
                                style: TextStyle(
                                    color: lightBlue, fontSize: font14.sp),
                              ),
                              Spacer(),
                              Text(
                                "$mobileChar",
                                style: TextStyle(
                                    color: lightBlue, fontSize: font14.sp),
                              )
                            ],
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
    );
  }
}
