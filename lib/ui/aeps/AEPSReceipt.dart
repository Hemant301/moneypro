import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/footer/ShowCashback.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class AEPSReceipt extends StatefulWidget {
  final Map map;
  final bool isShowDialog;
  const AEPSReceipt({Key? key, required this.map, required this.isShowDialog})
      : super(key: key);

  @override
  _AEPSReceiptState createState() => _AEPSReceiptState();
}

class _AEPSReceiptState extends State<AEPSReceipt>
    with SingleTickerProviderStateMixin {
  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();
  var screen = "Mobile Receipt";
  String ad = "";

  @override
  void initState() {
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);

    getX();
  }

  getX() async {
    var v = await generateXFormat(widget.map['adhar'].toString());
    setState(() {
      ad = v;
    });

    Timer(Duration(seconds: 2), () {
      if (widget.isShowDialog &&
          widget.map['merComm'].toString() != "0" &&
          widget.map['merComm'].toString() != "") {
        cashbackPopup();
      }
    });
  }

  int active = 0;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => WillPopScope(
              onWillPop: () async {
                printMessage(screen, "Mobile back pressed");
                if (widget.isShowDialog) {
                  removeAllPages(context);
                } else {
                  closeCurrentPage(context);
                }
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
                      closeCurrentPage(context);
                    },
                  ),
                  titleSpacing: 0,
                  title: appLogo(),
                  actions: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          active = 1;
                        });
                        shareTransReceipt(_printKey, "aeps");
                        Future.delayed(Duration(seconds: 5), () {
                          setState(() {
                            active = 0;
                          });
                        });
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
                        setState(() {
                          active = 1;
                          downloadReceiptAsPDF(_printKey);
                        });
                        Future.delayed(Duration(seconds: 5), () {
                          setState(() {
                            active = 0;
                          });
                        });
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
                body: Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height,
                  color: white,
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildRecieptHeader(),
                        Container(
                          height: 10.h,
                          width: MediaQuery.of(context).size.width,
                          color: boxBg,
                        ),
                        _buildRecieptDetails(),
                        Container(
                          height: 10.h,
                          width: MediaQuery.of(context).size.width,
                          color: boxBg,
                        ),
                        _buildReciptBotton(),
                        SizedBox(
                          height: 100,
                        ),
                        active == 0
                            ? Container()
                            : RepaintBoundary(
                                key: _printKey,
                                child: Column(
                                  children: [
                                    _buildscreenRecieptDetails(),
                                  ],
                                ),
                              )
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
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => ShowCashback(
              commission: widget.map['merComm'].toString(),
              id: "",
            ));
  }

  _buildRecieptHeader() {
    return Column(
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
                    (widget.map['status'].toString().toLowerCase() == "success")
                        ? Image.asset("assets/pin_alert.png")
                        : (widget.map['status'].toString().toLowerCase() ==
                                "pending")
                            ? Image.asset("assets/pending.png")
                            : Image.asset("assets/failed.png")),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        Text(
          "Transaction ${widget.map['status']}",
          style: TextStyle(
              color:
                  (widget.map['status'].toString().toLowerCase() == "success")
                      ? green
                      : black,
              fontSize: 22.sp,
              fontWeight: FontWeight.bold),
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          "$rupeeSymbol ${widget.map['amount']}",
          style: TextStyle(
              fontSize: font18.sp, color: black, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        SizedBox(
          height: 5.h,
        ),
        Container(
          width: MediaQuery.of(context).size.width * .5.w,
          color: gray,
          height: 1,
        ),
        SizedBox(
          height: 5.h,
        ),
        Text(
          "${widget.map['date']}",
          style: TextStyle(
              color: black, fontSize: font13.sp, fontWeight: FontWeight.bold),
          textAlign: TextAlign.end,
        ),
        SizedBox(
          height: 30.h,
        ),
      ],
    );
  }

  _buildRecieptDetails() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
      child: Column(
        children: [
          Text(
            "Transactions Details",
            style: TextStyle(
                color: black, fontWeight: FontWeight.w500, fontSize: font16.sp),
          ),
          Divider(
            color: gray,
          ),
          Row(
            children: [
              Text(
                "Avaiable Balance",
                style: TextStyle(color: lightBlack, fontSize: font13.sp),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  (widget.map['balance'].toString() == "null")
                      ? "NA"
                      : "$rupeeSymbol ${widget.map['balance']}",
                  style: TextStyle(
                      color: black,
                      fontSize: font16.sp,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
          Divider(
            color: gray,
          ),
          Row(
            children: [
              Text(
                "$transactionId",
                style: TextStyle(color: lightBlack, fontSize: font13.sp),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                flex: 1,
                child: InkWell(
                  onTap: () {
                    print('${widget.map['transId']}');
                  },
                  child: Text(
                    (widget.map['transId'].toString() == "null" ||
                            widget.map['transId'].toString() == "")
                        ? "NA"
                        : "${widget.map['transId']}",
                    style: TextStyle(
                        color: black,
                        fontSize: font13.sp,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                ),
              )
            ],
          ),
          Divider(
            color: gray,
          ),
          Row(
            children: [
              Text(
                "$refIdd",
                style: TextStyle(color: lightBlack, fontSize: font13.sp),
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
          Divider(
            color: gray,
          ),
          Row(
            children: [
              Text(
                "$mode_",
                style: TextStyle(color: lightBlack, fontSize: font13.sp),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "${widget.map['mode']}",
                  style: TextStyle(
                      color: black,
                      fontSize: font13.sp,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
          Divider(
            color: gray,
          ),
          Row(
            children: [
              Text(
                "Adhaar No.",
                style: TextStyle(color: lightBlack, fontSize: font13.sp),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                flex: 1,
                child: Text(
                  "$ad",
                  style: TextStyle(
                      color: black,
                      fontSize: font13.sp,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
                ),
              )
            ],
          ),
          Divider(
            color: gray,
          ),
          Row(
            children: [
              Text(
                "Mobile No.",
                style: TextStyle(color: lightBlack, fontSize: font13.sp),
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
          Divider(
            color: gray,
          ),
          (widget.map['mode'].toString().toLowerCase() == "ap" &&
                  widget.map['customerCharge'].toString() != "null")
              ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Customer Charges",
                          style:
                              TextStyle(color: lightBlack, fontSize: font13.sp),
                        ),
                        SizedBox(
                          width: 20.sp,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "$rupeeSymbol ${widget.map['customerCharge']}",
                            style: TextStyle(
                                color: black,
                                fontSize: font13.sp,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: gray,
                    ),
                  ],
                )
              : Container(),
          (widget.map['mode'].toString().toLowerCase() == "ap" &&
                  widget.map['stan'].toString() != "null")
              ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "STAN",
                          style:
                              TextStyle(color: lightBlack, fontSize: font13.sp),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${widget.map['stan']}",
                            style: TextStyle(
                                color: black,
                                fontSize: font13.sp,
                                fontWeight: FontWeight.bold),
                            textAlign: TextAlign.end,
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: gray,
                    ),
                  ],
                )
              : Container(),
          (widget.map['mode'].toString().toLowerCase() == "ap" &&
                  widget.map['bankName'].toString() != "null")
              ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "Bank Name",
                          style:
                              TextStyle(color: lightBlack, fontSize: font13.sp),
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
                    Divider(
                      color: gray,
                    ),
                  ],
                )
              : Container(),
          (widget.map['mode'].toString().toLowerCase() == "ap" &&
                  widget.map['rrn'].toString() != "null")
              ? Column(
                  children: [
                    Row(
                      children: [
                        Text(
                          "RRN",
                          style:
                              TextStyle(color: lightBlack, fontSize: font13.sp),
                        ),
                        SizedBox(
                          width: 20.w,
                        ),
                        Expanded(
                          flex: 1,
                          child: InkWell(
                            onTap: () {
                              print(widget.map['rrn']);
                            },
                            child: Text(
                              widget.map['rrn'].toString() == ""
                                  ? "N/A"
                                  : "${widget.map['rrn']}",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font13.sp,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        )
                      ],
                    ),
                    Divider(
                      color: gray,
                    ),
                  ],
                )
              : Container(),
          Column(
            children: [
              Row(
                children: [
                  Text(
                    "Bank Msg",
                    style: TextStyle(color: lightBlack, fontSize: font13.sp),
                  ),
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () {
                        print("${widget.map['bankmsg']}");
                      },
                      child: Text(
                        "${widget.map['bankmsg']}",
                        style: TextStyle(
                            color: black,
                            fontSize: font13.sp,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.end,
                      ),
                    ),
                  )
                ],
              ),
              Divider(
                color: gray,
              ),
            ],
          ),
        ],
      ),
    );
  }

  _buildscreenRecieptDetails() {
    return Container(
      color: Color.fromARGB(255, 219, 247, 255),
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
        child: Column(
          children: [
            Image.asset(
              'assets/app_splash_logo.png',
              height: 50,
            ),
            Text(
              "Transactions Details",
              style: TextStyle(
                  color: black,
                  fontWeight: FontWeight.w500,
                  fontSize: font16.sp),
            ),
            Divider(
              color: gray,
            ),
            Row(
              children: [
                Text(
                  "Avaiable Balance",
                  style: TextStyle(color: lightBlack, fontSize: font13.sp),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    (widget.map['balance'].toString() == "null")
                        ? "NA"
                        : "$rupeeSymbol ${widget.map['balance']}",
                    style: TextStyle(
                        color: black,
                        fontSize: font16.sp,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
            Divider(
              color: gray,
            ),
            Row(
              children: [
                Text(
                  "$transactionId",
                  style: TextStyle(color: lightBlack, fontSize: font13.sp),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  flex: 1,
                  child: InkWell(
                    onTap: () {
                      print('${widget.map['transId']}');
                    },
                    child: Text(
                      (widget.map['transId'].toString() == "null" ||
                              widget.map['transId'].toString() == "")
                          ? "NA"
                          : "${widget.map['transId']}",
                      style: TextStyle(
                          color: black,
                          fontSize: font13.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.end,
                    ),
                  ),
                )
              ],
            ),
            Divider(
              color: gray,
            ),
            Row(
              children: [
                Text(
                  "$refIdd",
                  style: TextStyle(color: lightBlack, fontSize: font13.sp),
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
            Divider(
              color: gray,
            ),
            Row(
              children: [
                Text(
                  "$mode_",
                  style: TextStyle(color: lightBlack, fontSize: font13.sp),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "${widget.map['mode']}",
                    style: TextStyle(
                        color: black,
                        fontSize: font13.sp,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
            Divider(
              color: gray,
            ),
            Row(
              children: [
                Text(
                  "Adhaar No.",
                  style: TextStyle(color: lightBlack, fontSize: font13.sp),
                ),
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "$ad",
                    style: TextStyle(
                        color: black,
                        fontSize: font13.sp,
                        fontWeight: FontWeight.bold),
                    textAlign: TextAlign.end,
                  ),
                )
              ],
            ),
            Divider(
              color: gray,
            ),
            Row(
              children: [
                Text(
                  "Mobile No.",
                  style: TextStyle(color: lightBlack, fontSize: font13.sp),
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
            Divider(
              color: gray,
            ),
            (widget.map['mode'].toString().toLowerCase() == "ap" &&
                    widget.map['customerCharge'].toString() != "null")
                ? Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "Customer Charges",
                            style: TextStyle(
                                color: lightBlack, fontSize: font13.sp),
                          ),
                          SizedBox(
                            width: 20.sp,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "$rupeeSymbol ${widget.map['customerCharge']}",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font13.sp,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: gray,
                      ),
                    ],
                  )
                : Container(),
            (widget.map['mode'].toString().toLowerCase() == "ap" &&
                    widget.map['stan'].toString() != "null")
                ? Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "STAN",
                            style: TextStyle(
                                color: lightBlack, fontSize: font13.sp),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${widget.map['stan']}",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font13.sp,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.end,
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: gray,
                      ),
                    ],
                  )
                : Container(),
            (widget.map['mode'].toString().toLowerCase() == "ap" &&
                    widget.map['bankName'].toString() != "null")
                ? Column(
                    children: [
                      Row(
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
                      Divider(
                        color: gray,
                      ),
                    ],
                  )
                : Container(),
            (widget.map['mode'].toString().toLowerCase() == "ap" &&
                    widget.map['rrn'].toString() != "null")
                ? Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            "RRN",
                            style: TextStyle(
                                color: lightBlack, fontSize: font13.sp),
                          ),
                          SizedBox(
                            width: 20.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                print(widget.map['rrn']);
                              },
                              child: Text(
                                widget.map['rrn'].toString() == ""
                                    ? "N/A"
                                    : "${widget.map['rrn']}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13.sp,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            ),
                          )
                        ],
                      ),
                      Divider(
                        color: gray,
                      ),
                    ],
                  )
                : Container(),
            Column(
              children: [
                Row(
                  children: [
                    Text(
                      "Bank Msg",
                      style: TextStyle(color: lightBlack, fontSize: font13.sp),
                    ),
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      flex: 1,
                      child: InkWell(
                        onTap: () {
                          print("${widget.map['bankmsg']}");
                        },
                        child: Text(
                          "${widget.map['bankmsg']}",
                          style: TextStyle(
                              color: black,
                              fontSize: font13.sp,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    )
                  ],
                ),
                Divider(
                  color: gray,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  _buildReciptBotton() {
    return Padding(
      padding:
          const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 20),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                "$customerCare",
                style: TextStyle(color: black, fontSize: font14.sp),
              ),
              Spacer(),
              Text(
                "$merchantMob",
                style: TextStyle(color: black, fontSize: font14.sp),
              )
            ],
          ),
          Row(
            children: [
              Text(
                "$customerEmail",
                style: TextStyle(color: lightBlue, fontSize: font14.sp),
              ),
              Spacer(),
              Text(
                "$mobileChar",
                style: TextStyle(color: lightBlue, fontSize: font14.sp),
              )
            ],
          ),
        ],
      ),
    );
  }
}
