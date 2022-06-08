import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/Banks.dart';
import 'package:moneypro_new/ui/models/FinoBanks.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

import '../../../../utils/AppKeys.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../../utils/CustomWidgets.dart';

class AePSFinoTransaction extends StatefulWidget {
  final String txnType;
  final String lat;
  final String lng;

  const AePSFinoTransaction(
      {Key? key,
      required this.txnType,
      required this.lat,
      required this.lng})
      : super(key: key);

  @override
  State<AePSFinoTransaction> createState() => _AePSFinoTransactionState();
}

class _AePSFinoTransactionState extends State<AePSFinoTransaction> {
  var screen = "AePS Fino Details";

  final adharController = new TextEditingController();
  final searchName = new TextEditingController();
  final amountController = new TextEditingController();
  final mobileController = new TextEditingController();

  List<Datum> bankList = [];
  List<Datum> bankListFiltered = [];

  var loading = false;

  var showFilterBank = false;

  var bankName = "Tap to select bank";
  var scannerDevice = "Tap to select device";
  var bankIIN = "";

  var mobile ="";


  var alertValue = false;

  var isFingerCapture = false;

  String fingerData = "";
  var adhar = "";

  var amount="";

  @override
  void initState() {
    super.initState();
    printMessage(screen, "Txn Type : ${widget.txnType}");
    getBankList();
  }

  @override
  void dispose() {
    adharController.dispose();
    searchName.dispose();
    amountController.dispose();
    mobileController.dispose();
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
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                    color: black,
                  ),
                  onPressed: () {
                    closeKeyBoard(context);
                    closeCurrentPage(context);
                  },
                ),
                titleSpacing: 0,
                title: Container(
                  child: Center(
                    child: Image.asset(
                      'assets/app_splash_logo.png',
                      width: 120,
                    ),
                  ),
                ),
              ),
              body: (loading)
                  ? Center(
                      child: circularProgressLoading(40.0),
                    )
                  : SingleChildScrollView(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                          Card(
                            margin: EdgeInsets.all(20),
                            elevation: 2,
                            child: Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Column(
                                children: [
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/national_emblem.png',
                                        height: 50.h,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                          child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Container(
                                            height: 10.h,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .3,
                                            color: Colors.orange,
                                          ),
                                          Container(
                                            height: 10.h,
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            color: white,
                                          ),
                                          Container(
                                            height: 10.h,
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                .4,
                                            color: green,
                                          ),
                                        ],
                                      )),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Image.asset(
                                        'assets/adhar_logo.jpg',
                                        height: 50.h,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 15.h,
                                  ),
                                  Row(
                                    children: [
                                      Image.asset(
                                        'assets/ic_dummy_user.png',
                                        height: 30,
                                      ),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Expanded(
                                          child: Column(
                                        children: [
                                          SizedBox(
                                            height: 10.h,
                                          ),
                                          TextFormField(
                                            style: TextStyle(
                                                color: black,
                                                fontSize: inputFont),
                                            keyboardType: TextInputType.number,
                                            textInputAction:
                                                TextInputAction.done,
                                            controller: adharController,
                                            decoration: new InputDecoration(
                                              isDense: false,
                                              counterText: "",
                                              label: Text(
                                                "Enter Aadhaar Number",
                                                textAlign: TextAlign.center,
                                              ),
                                            ),
                                            maxLength: 12,
                                          )
                                        ],
                                      )),
                                      SizedBox(
                                        width: 20.w,
                                      ),
                                      Image.asset(
                                        'assets/new_qr_code.png',
                                        height: 30,
                                      ),
                                    ],
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  Divider(
                                    color: red,
                                  )
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Select Bank",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 10, right: 20),
                            child: InkWell(
                              onTap: () {
                                closeKeyBoard(context);
                                _showBankList();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: gray,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text("$bankName"),
                                      Spacer(),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              "Select Biometric device",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 10, right: 20),
                            child: InkWell(
                              onTap: () {
                                closeKeyBoard(context);
                                _showDeviceList();
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                  color: gray,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Text("$scannerDevice"),
                                      Spacer(),
                                      Icon(
                                        Icons.keyboard_arrow_down,
                                        size: 18,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Container(
                              decoration: BoxDecoration(
                                color: gray,
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                              ),
                              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: TextFormField(
                                style: TextStyle(
                                    color: black,
                                    fontSize: inputFont),
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.number,
                                textInputAction:
                                TextInputAction.done,
                                controller: mobileController,
                                decoration: new InputDecoration(
                                  isDense: false,
                                  border: InputBorder.none,
                                  counterText: "",
                                  contentPadding: EdgeInsets.only(left: 15),
                                  label: Text(
                                    "Enter mobile number",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                maxLength: 10,
                              ),
                            ),
                          (widget.txnType.toString().toLowerCase()=="cw"
                           || widget.txnType.toString().toLowerCase()=="ap")?Container(
                              decoration: BoxDecoration(
                                color: gray,
                                borderRadius:
                                BorderRadius.all(Radius.circular(20)),
                              ),
                              margin: EdgeInsets.only(left: 20, right: 20, top: 20),
                              child: TextFormField(
                                style: TextStyle(
                                    color: black,
                                    fontSize: inputFont),
                                textAlign: TextAlign.left,
                                keyboardType: TextInputType.number,
                                textInputAction:
                                TextInputAction.done,
                                controller: amountController,
                                decoration: new InputDecoration(
                                  isDense: false,
                                  border: InputBorder.none,
                                  counterText: "",
                                  contentPadding: EdgeInsets.only(left: 15),
                                  label: Text(
                                    "Enter amount",
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                maxLength: 6,
                              ),
                            ):Container()
                        ])),
              bottomNavigationBar: Wrap(
                children: [
                  InkWell(
                    onTap: () {
                      adhar = adharController.text.toString();
                      mobile = mobileController.text.toString();
                      if (adhar.length != 12) {
                        showToastMessage("Enter vaild 12-digit adhaar number");
                        return;
                      } else if (bankName.length == 0 ||
                          bankName.toString() == "Tap to select bank") {
                        showToastMessage("Select your bank");
                        return;
                      } else if (scannerDevice.length == 0 ||
                          bankName.toString() == "Tap to select device") {
                        showToastMessage("Select biometric device");
                        return;
                      }else if (mobile.length == 0) {
                        showToastMessage("Please enter Mobile Number");
                        return;
                      } else if (mobile.length != 10) {
                        showToastMessage("Mobile number must 10 digits");
                        return;
                      } else if (!mobilePattern.hasMatch(mobile)) {
                        showToastMessage("Please enter valid Mobile Number");
                        return;
                      }

                      if(widget.txnType.toLowerCase()=="cw" ||widget.txnType.toLowerCase()=="ap"){
                        amount = amountController.text.toString();
                        if (amount.length == 0
                            || amount.toString() == "0"
                            || amount.toString() == "0.0") {
                          showToastMessage("enter the amount");
                          return;
                        }
                      }

                      _showAlertDialog(adhar);
                    },
                    child: Container(
                      height: 45,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          top: 0, left: 20, right: 20, bottom: 0),
                      decoration: BoxDecoration(
                        color: green,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Center(
                        child: Text(
                          "Proceed".toUpperCase(),
                          style: TextStyle(fontSize: font13, color: white),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.lock,
                          color: green,
                        ),
                        SizedBox(
                          width: 10.w,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "100% secure transaction",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(
                              "256 bit encryption",
                              style: TextStyle(color: black, fontSize: font12),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )));
  }

  Future getBankList() async {
    setState(() {
      loading = true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader"
    };

    final response =
        await http.post(Uri.parse(aepsFinoBanklistAPI), headers: headers);

    setState(() {
      loading = false;
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Bank list response : $data");

        if (data['status'].toString() == "1") {
          var result =
              FinoBanks.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          bankList = result.response.banklist.data;
        }
      }
    });
  }

  _showBankList() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _searchBankByName(),
                      (showFilterBank)
                          ? Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: bankListFiltered.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        printMessage(screen,
                                            "Selected Bank : ${bankListFiltered[index].bankName}");
                                        bankName =
                                            bankListFiltered[index].bankName;
                                        bankIIN = bankListFiltered[index].iinno;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Container(
                                                height: 24.h,
                                                width: 24.w,
                                                child: Image.asset(
                                                    'assets/bank.png'),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 15.0,
                                                          top: 10,
                                                          bottom: 0,
                                                          right: 15),
                                                  child: Text(
                                                    "${bankListFiltered[index].bankName}",
                                                    style: TextStyle(
                                                        color: black,
                                                        fontSize: font14.sp,
                                                        fontWeight:
                                                            FontWeight.normal),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                            ],
                                          ),
                                          Divider(),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: bankList.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return InkWell(
                                    onTap: () {
                                      setState(() {
                                        printMessage(screen,
                                            "Selected Bank : ${bankList[index].bankName}");
                                        bankName = bankList[index].bankName;
                                        bankIIN = bankList[index].iinno;
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                            Container(
                                              height: 24.h,
                                              width: 24.w,
                                              child: Image.asset(
                                                  'assets/bank.png'),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 15.0,
                                                    top: 10,
                                                    bottom: 0,
                                                    right: 15),
                                                child: Text(
                                                  "${bankList[index].bankName}",
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: font14.sp,
                                                      fontWeight:
                                                          FontWeight.normal),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              width: 10.w,
                                            ),
                                          ],
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ));
  }

  _showDeviceList() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, top: 20, bottom: 15),
                        child: Text(
                          "Select Biometric Device",
                          style: TextStyle(
                              color: black,
                              fontSize: font18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            scannerDevice = "MANTRA";
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            "MANTRA",
                            style: TextStyle(color: black, fontSize: font16.sp),
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            scannerDevice = "MORPHO";
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            "MORPHO",
                            style: TextStyle(color: black, fontSize: font16.sp),
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            scannerDevice = "TATVIK";
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            "TATVIK",
                            style: TextStyle(color: black, fontSize: font16.sp),
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            scannerDevice = "STARTEK";
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            "STARTEK",
                            style: TextStyle(color: black, fontSize: font16.sp),
                          ),
                        ),
                      ),
                      Divider(),
                      InkWell(
                        onTap: () {
                          setState(() {
                            scannerDevice = "EVOLUTE";
                          });
                          Navigator.pop(context);
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 25.0),
                          child: Text(
                            "EVOLUTE",
                            style: TextStyle(color: black, fontSize: font16.sp),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  ),
                )
              ],
            ));
  }

  _showAlertDialog(adhar) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, top: 20, bottom: 15),
                        child: Text(
                          "Consent",
                          style: TextStyle(
                              color: black,
                              fontSize: font18,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Divider(),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, top: 0, bottom: 0, right: 30),
                        child: Text(
                          "I submit my Aadhaar number and voluntarily give my consent to send my Aadhaar number with my aforesaid account and authenticate with UIDAI. I hereby authorixe MONEYPRO FINTECH PVT LTD merchant to authenticate and use all such necessary details retrieved or to be retrieved from UIDAI through AADHAAR Number and IRIS/biometric authentication for the purpose of this transaction. In case of any discrepancies, the Bank reserves the sole right to block my account/relation and transaction without any further notice or intimation. The above consent and purpose of collection information has been explained to me in my local language.",
                          style: TextStyle(color: black, fontSize: font14),
                        ),
                      ),
                      Row(
                        children: [
                          Checkbox(
                              value: alertValue,
                              onChanged: (val) {
                                setState(() {
                                  closeKeyBoard(context);
                                  alertValue = val!;
                                });
                              }),
                          Text(
                            "Accept Consent",
                            style: TextStyle(color: black, fontSize: font14),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          closeKeyBoard(context);
                          getFingerPrintData(scannerDevice);
                        },
                        child: Container(
                          height: 45,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(
                              top: 10, left: 20, right: 20, bottom: 0),
                          decoration: BoxDecoration(
                            color: green,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Center(
                            child: Text(
                              "Submit",
                              style: TextStyle(fontSize: font13, color: white),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 20.h,
                      )
                    ],
                  ),
                )
              ],
            ));
  }

  _searchBankByName() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 50, right: 15, left: 15),
      child: Row(
        children: [
          SizedBox(
            width: 15.w,
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: searchName,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                hintText: "Search",
                hintStyle: TextStyle(color: black),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              maxLength: 20,
              onFieldSubmitted: (val) {
                onSearchNameChanged(val.toString());
              },
              onChanged: (val) {
                setState(() {
                  if (val.length == 0) {
                    showFilterBank = false;
                  } else {
                    onSearchNameChanged(val.toString());
                  }
                });
              },
            ),
          ),
          SizedBox(
            width: 15.w,
          )
        ],
      ),
    );
  }

  onSearchNameChanged(String text) async {
    printMessage(screen, "Case 0 : $text");
    bankListFiltered.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    bankList.forEach((userDetail) {
      if (userDetail.bankName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        printMessage(screen, "Case 2 :");
        bankListFiltered.add(userDetail);
      }
    });

    setState(() {
      printMessage(screen, "Case 3 : ${bankListFiltered.length}");
      if (bankListFiltered.length != 0) {
        showFilterBank = true;
      }
    });
  }

  Future getFingerPrintData(deviceTpye) async {
    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {"deviceType": "$deviceTpye"};

      fingerData = await platform.invokeMethod("getAepsFinger", arr);

      printMessage(screen, "Fingerprint data : $fingerData");

      if (fingerData != "") {
        setState(() {
          isFingerCapture = true;

          //openMailOptions(fingerData.toString());

          if (widget.txnType.toString() == "BE") {
            getBalanceEnq();
          }

          if (widget.txnType.toString() == "CW") {
            getCashWithdrwl();
          }

          if (widget.txnType.toString() == "AP") {
            getAPWithdrwl();
          }

          if (widget.txnType.toString() == "MS") {
            getMiniStatement();
          }

        });
      } else {
        setState(() {
          isFingerCapture = false;
          showToastMessage(somethingWrong);
        });
      }
    }
  }

  Future getBalanceEnq() async {
    setState(() {
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
      "Authorization": "$authHeader"
    };

    var body = {
      "user_token": "$userToken",
      "fingerdata": "$fingerData",
      "adhar": "$adhar",
      "lat": "${widget.lat}",
      "long": "${widget.lng}",
      "bankIIN": "$bankIIN",
      "mobile": "$mobile"
    };

    printMessage(screen, "user_token : $userToken");
    printMessage(screen, "adhar : $adhar");
    printMessage(screen, "lat : ${widget.lat}");
    printMessage(screen, "long : ${widget.lng}");
    printMessage(screen, "bankIIN : $bankIIN");
    printMessage(screen, "mobile : $mobile");

    final response = await http.post(Uri.parse(aepsFinoBalanceEnqueryAPI),
        headers: headers, body: jsonEncode(body));

    setState(() {
      var statusCode = response.statusCode;
      Navigator.pop(context);
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "BE response : $data");

        if(data['status'].toString()=="1"){

          if(data['response']['response_code'].toString()=="1"){
            var balanceamount = data['response']['balanceamount'].toString();
            var bankrrn = data['response']['bankrrn'].toString();
            var clientrefno = data['response']['clientrefno'].toString();
            var message = data['response']['message'].toString();

            Map map = {
              "bankName": "$bankName",
              "balance": "$balanceamount",
              "adharNo": "$adhar",
              "mobile": "$mobile",
              "partnerRefId": "$clientrefno",
              "rrn": "$bankrrn",
              "bankResponseMsg":"$message"
            };
            openAEPS_BalanceEnq(context, map);
          }else{
            var message = data['response']['message'].toString();
            showToastMessage(message);
          }


        }else{
          var message = data['message'].toString();
          showToastMessage(message);
        }

      }
    });
  }

  Future getCashWithdrwl() async {

    var now = DateTime.now();
    var formatterDate = DateFormat('dd/MM/yy');
    var formatterTime = DateFormat('kk:mm');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);

    setState(() {
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
      "Authorization": "$authHeader"
    };

    var body = {
      "user_token": "$userToken",
      "fingerdata": "$fingerData",
      "adhar": "$adhar",
      "lat": "${widget.lat}",
      "long": "${widget.lng}",
      "bankIIN": "$bankIIN",
      "mobile": "$mobile",
      "amount":"$amount"
    };

    printMessage(screen, "Body CW : $body");

    final response = await http.post(Uri.parse(aepsFinoCashWithdrawlAPI),
        headers: headers, body: jsonEncode(body));

    setState(() {
      var statusCode = response.statusCode;

      printMessage(screen, "CW statusCode : $statusCode");


      Navigator.pop(context);
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "CW response : $data");

        if(data['status'].toString()=="1"){

          if(data['response']['response_code'].toString()=="1"){
            var ackno = data['response']['ackno'].toString();
            var bankrrn = data['response']['bankrrn'].toString();
            var clientrefno = data['response']['clientrefno'].toString();
            var message = data['response']['message'].toString();
            var amount = data['response']['amount'].toString();
            var balanceamount = data['response']['balanceamount'].toString();

            Map map = {
              "date": "$actualDate $actualTime",
              "transId": "$ackno",
              "refId": "$clientrefno",
              "amount": "$amount",
              "mode": "CW",
              "status": "success",
              "adhar": "$adhar",
              "mobile": "$mobile",
              "merComm": "",
              "balance": "$balanceamount",
              "customerCharge": "",
              "stan": "",
              "rrn": "$bankrrn",
              "bankResponseMsg": "$message",
              "npciCode": "",
              "bankName": "$bankName"
            };
            openAEPSReceipt(context, map, true);
          }else{
            var message = data['response']['message'].toString();
            showToastMessage(message);
          }
        }else{
          var message = data['message'].toString();
          showToastMessage(message);
        }

      }
    });
  }

  Future getAPWithdrwl() async {

    var now = DateTime.now();
    var formatterDate = DateFormat('dd/MM/yy');
    var formatterTime = DateFormat('kk:mm');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);

    setState(() {
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
      "Authorization": "$authHeader"
    };


    var body = {
      "user_token": "$userToken",
      "fingerdata": "$fingerData",
      "adhar": "$adhar",
      "lat": "${widget.lat}",
      "long": "${widget.lng}",
      "bankIIN": "$bankIIN",
      "mobile": "$mobile",
      "amount":"$amount"
    };

    printMessage(screen, "Body AP : $body");

    final response = await http.post(Uri.parse(aepsFinoAdharpayAPI),
        headers: headers, body: jsonEncode(body));

    setState(() {
      var statusCode = response.statusCode;
      Navigator.pop(context);
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "AP response : $data");

        if(data['status'].toString()=="1"){

          if(data['response'].toString()!="null"){
            if(data['response']['response_code'].toString()=="1"){
              var ackno = data['response']['ackno'].toString();
              var bankrrn = data['response']['bankrrn'].toString();
              var clientrefno = data['response']['clientrefno'].toString();
              var message = data['response']['message'].toString();
              var balanceamount = data['response']['balanceamount'].toString();

              Map map = {
                "date": "$actualDate $actualTime",
                "transId": "$ackno",
                "refId": "$clientrefno",
                "amount": "$amount",
                "mode": "AP",
                "status": "success",
                "adhar": "$adhar",
                "mobile": "$mobile",
                "merComm": "",
                "balance": "$balanceamount",
                "customerCharge": "",
                "stan": "",
                "rrn": "$bankrrn",
                "bankResponseMsg": "$message",
                "npciCode": "",
                "bankName": "$bankName"
              };
              openAEPSReceipt(context, map, true);
            }else{
              var message = data['response']['message'].toString();
              showToastMessage(message);
            }
          }else{
            showToastMessage("Something went wrong");
          }




        }else{
          var message = data['message'].toString();
          showToastMessage(message);
        }

      }
    });
  }

  Future getMiniStatement() async {

    var now = DateTime.now();
    var formatterDate = DateFormat('dd/MM/yy');
    var formatterTime = DateFormat('kk:mm');
    String actualDate = formatterDate.format(now);
    String actualTime = formatterTime.format(now);

    setState(() {
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
      "Authorization": "$authHeader"
    };


    var body = {
      "user_token": "$userToken",
      "fingerdata": "$fingerData",
      "adhar": "$adhar",
      "lat": "${widget.lat}",
      "long": "${widget.lng}",
      "bankIIN": "$bankIIN",
      "mobile": "$mobile",
    };

    printMessage(screen, "Body MS : $body");

    final response = await http.post(Uri.parse(aepsFinoMiniStatementAPI),
        headers: headers, body: jsonEncode(body));

    setState(() {
      var statusCode = response.statusCode;
      printMessage(screen, "Status COde : $statusCode");
      Navigator.pop(context);
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "MS response : $data");

        if(data['status'].toString()=="1"){

          if(data['response'].toString()!="null"){
            if(data['response']['response_code'].toString()=="1"){
              openAePSFinoMiniStatement(context, data);
            }else{
              var message = data['response']['message'].toString();
              showToastMessage(message);
            }
          }else{
            showToastMessage("Something went wrong");
          }

        }else{
          var message = data['message'].toString();
          showToastMessage(message);
        }

      }
    });
  }
}
