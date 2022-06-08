import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class TransPayoutRecipt extends StatefulWidget {
  final Map map;

  const TransPayoutRecipt({Key? key, required this.map}) : super(key: key);

  @override
  _TransPayoutReciptState createState() => _TransPayoutReciptState();
}

class _TransPayoutReciptState extends State<TransPayoutRecipt> {
  var screen = "Txn Recipt";

  var accNo = "";

  @override
  void initState() {
    super.initState();
    setXFormat();
  }

  setXFormat() async {
    if (widget.map['bene_account'].toString().contains("@")) {
      setState(() {
        accNo = widget.map['bene_account'].toString();
      });
    } else {
      var x = await generateXFormat(widget.map['bene_account'].toString());
      setState(() {
        accNo = x;
      });
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
              ),
              body: Column(
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
                          child:
                              (widget.map['status'].toString().toLowerCase() ==
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
                    height: 5.h,
                  ),
                  Text(
                    "$rupeeSymbol ${widget.map['amount'].toString()}",
                    style: TextStyle(fontSize: font18.sp, color: black),
                    textAlign: TextAlign.center,
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
                                        color: lightBlack, fontSize: font13.sp),
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
                                    "Ref Id",
                                    style: TextStyle(
                                        color: lightBlack, fontSize: font13.sp),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${widget.map['merchantRefId']}",
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
                            (widget.map['bene_name'].toString() == "null")
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25.0, right: 30, left: 30),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Bene. Name",
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font13.sp),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${widget.map['bene_name']}",
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
                            (accNo.toString() == "null")
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25.0, right: 30, left: 30),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Bene. A/c no",
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font13.sp),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "$accNo",
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
                            (widget.map['ifsc_jcode'].toString() == "null")
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25.0, right: 30, left: 30),
                                    child: Row(
                                      children: [
                                        Text(
                                          "IFSC",
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font13.sp),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${widget.map['ifsc_jcode']}",
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
                            (widget.map['mobile'].toString() == "null")
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        top: 25.0, right: 30, left: 30),
                                    child: Row(
                                      children: [
                                        Text(
                                          "Mobile no.",
                                          style: TextStyle(
                                              color: lightBlack,
                                              fontSize: font13.sp),
                                        ),
                                        SizedBox(
                                          width: 20.w,
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Text(
                                            "${widget.map['mobile']}",
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
                                    "Debited From",
                                    style: TextStyle(
                                        color: lightBlack, fontSize: font13.sp),
                                  ),
                                  SizedBox(
                                    width: 20.w,
                                  ),
                                  Expanded(
                                    flex: 1,
                                    child: Text(
                                      "${widget.map['wallet_type']}"
                                          .toUpperCase(),
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
                                    style:
                                        TextStyle(color: black, fontSize: font14.sp),
                                  ),
                                  Spacer(),
                                  Text(
                                    "$merchantMob",
                                    style:
                                        TextStyle(color: black, fontSize: font14.sp),
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
                    ),
                  )
                ],
              ),
            )));
  }
}
