import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';

class PaymentFailure extends StatefulWidget {
  final Map map;

  const PaymentFailure({Key? key, required this.map}) : super(key: key);

  @override
  _PaymentFailureState createState() => _PaymentFailureState();
}

class _PaymentFailureState extends State<PaymentFailure> {


  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();

    final inheritedWidget = StateContainer.of(context);

    inheritedWidget.updateMPBalc(value: mpBalc);
    if (mpBalc == null || mpBalc == 0) {
      mpBalc = 0;
      final inheritedWidget = StateContainer.of(context);
      inheritedWidget.updateMPBalc(value: mpBalc);
    }

    inheritedWidget.updateQRBalc(value: qrBalc);
    if (qrBalc == null || qrBalc == 0) {
      qrBalc = 0;
      final inheritedWidget = StateContainer.of(context);
      inheritedWidget.updateQRBalc(value: qrBalc);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>WillPopScope(
      onWillPop: () async {
        removeAllPages(context);
        return false;
      },
      child: SafeArea(
          child: Scaffold(
              backgroundColor: white,
              appBar: appBarHome(context, "assets/bbpslogo.png", 80.0.w),
              body: Column(
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20.h,),
                      Center(
                        child: CircleAvatar(
                          backgroundColor: Colors.transparent,
                          radius: 40,
                          child: ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(40)),
                              child: Image.asset("assets/remove.png")),
                        ),
                      ),
                      SizedBox(height: 15.h,),
                      Text(
                        "Transaction ${widget.map['txStatus']}",
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
                        style: TextStyle(
                            fontSize: font18.sp, color: black),
                        textAlign: TextAlign.center,
                      ),SizedBox(
                        height: 5.h,
                      ),
                    ],
                  ),
                  Expanded(
                      flex: 2,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
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
                              SizedBox(height: 30.h,),
                              Center(
                                child: Container(
                                  color: gray,
                                  width: 50.w,
                                  height: 5.h,
                                ),
                              ),
                              (widget.map['txTime'].toString()=="null" ||
                                  widget.map['txTime'].toString()=="")?Container():   Padding(
                                padding:
                                const EdgeInsets.only(top: 40.0, right: 30, left: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      "Date",
                                      style:
                                      TextStyle(color: lightBlack, fontSize: font13.sp),
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
                                padding:
                                const EdgeInsets.only(top: 30.0, right: 30, left: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      "$transactionId",
                                      style:
                                      TextStyle(color: lightBlack, fontSize: font13.sp),
                                    ),
                                    Spacer(),
                                    Text(
                                      "${widget.map['orderId']}",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: font13.sp,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 30.0, right: 30, left: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      "$mode_",
                                      style:
                                      TextStyle(color: lightBlack, fontSize: font13.sp),
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
                              Padding(
                                padding:
                                const EdgeInsets.only(top: 30.0, right: 30, left: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      "$refIdd",
                                      style:
                                      TextStyle(color: lightBlack, fontSize: font13.sp),
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
                                padding:
                                const EdgeInsets.only(top: 30.0, right: 30, left: 30),
                                child: Row(
                                  children: [
                                    Text(
                                      "$remarks",
                                      style:
                                      TextStyle(color: lightBlack, fontSize: font13.sp),
                                    ),SizedBox(width: 20.w,),
                                    Expanded(
                                      flex:1,
                                      child: Text(
                                        "${widget.map['txMsg']}",
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
                              SizedBox(height: 15.h),
                              Divider(
                                color: gray,
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 15.0, right: 15, top: 30),
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
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                const EdgeInsets.only(left: 15.0, right: 15, top: 5),
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
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ))
                ],
              ))),
    ));
  }
}
