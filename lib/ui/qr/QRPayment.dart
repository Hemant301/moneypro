import 'dart:io';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:cashfree_pg/cashfree_pg.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/UPIList.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:moneypro_new/utils/AppKeys.dart';



class QRPayment extends StatefulWidget {
  final Map map;
  final File file;

  const QRPayment({Key? key, required this.map, required this.file})
      : super(key: key);

  @override
  _QRPaymentState createState() => _QRPaymentState();
}

class _QRPaymentState extends State<QRPayment> {
  var screen = "QR Preview";

  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  var loading = false;

  var name = "";
  var mobile = "";
  var custQR = "";
  late File custImage;
  var pickImage = "";
  var qrNo = "";
  var walletBal = "";
  var virtualQR = "";
  var address = "";
  var base64String = "";

  var isAddressChange = false;
  var payBy = "";

  var companyName = "";
  var companyAddress = "";
  var city = "";
  var district = "";
  var state = "";
  var pincode = "";
  var hideButton = false;

  TextEditingController nameController = new TextEditingController();
  TextEditingController addressController = new TextEditingController();
  TextEditingController cityController = new TextEditingController();
  TextEditingController districtController = new TextEditingController();
  TextEditingController stateController = new TextEditingController();
  TextEditingController pincodeController = new TextEditingController();

  int noOfUPI = 0;
  int upiIndex = 0;
  var upiId = "";

  @override
  void initState() {
    super.initState();
    updateWalletBalances();
    setState(() {
      name = widget.map['name'].toString();
      mobile = widget.map['mobile'].toString();
      qrNo = widget.map['qrNo'].toString();
      custQR = widget.map['custQR'].toString();
      custImage = widget.file;
      pickImage = widget.map['pickImage'].toString();
    });

    printMessage(screen, "custQR : ${custQR}");

    setState(() {

      if (custQR.toString().contains("payu")) {
        custQR = custQR.replaceAll("moneypro.payu", "");
      }


      if (custQR.toString().contains("yellowqr")) {
        custQR = custQR.replaceAll("yellowqr.prowealth.", "");
      }

      if (custQR.toString().contains(".")) {
        custQR = custQR.replaceAll(".", "");
      }

    });

    printMessage(screen, "pickImage : ${pickImage.length}");
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();

    var cname = await getComapanyName();
    var caddress = await getCompanyAddress();
    var ccity = await getCity();
    var cdistrict = await getDistrict();
    var cstate = await getState();
    var cpin = await getPinCode();

    final inheritedWidget = StateContainer.of(context);

    if (mpBalc == null || mpBalc == 0) {
      mpBalc = "0";
      inheritedWidget.updateMPBalc(value: mpBalc);
    } else {
      inheritedWidget.updateMPBalc(value: mpBalc);
    }

    setState(() {
      walletBal = mpBalc;
      companyName = cname;
      companyAddress = caddress;
      city = ccity;
      district = cdistrict;
      state = cstate;
      pincode = cpin;

      address =
          "$companyName, \n$companyAddress $city $district $state -$pincode";

      nameController = TextEditingController(text: "${companyName.toString()}");

      addressController =
          TextEditingController(text: "${companyAddress.toString()}");

      cityController = TextEditingController(text: "${city.toString()}");

      districtController =
          TextEditingController(text: "${district.toString()}");

      stateController = TextEditingController(text: "${state.toString()}");

      pincodeController = TextEditingController(text: "${pincode.toString()}");
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    addressController.dispose();
    cityController.dispose();
    districtController.dispose();
    stateController.dispose();
    pincodeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: RepaintBoundary(
      key: _printKey,
      child: Scaffold(
        backgroundColor: white,
        body: (loading)
            ? Center(
                child: circularProgressLoading(40.0),
              )
            : SingleChildScrollView(
                child: Column(children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Image.asset(
                    'assets/quickpe.png',
                    height: 65.h,
                  ),
                  Container(
                    margin: EdgeInsets.only(top: 10, left: 0, right: 0),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: orange,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Text(
                          "$name",
                          style: TextStyle(color: white, fontSize: font18.sp),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  (custImage.path.length != 0 || pickImage.length != 0)
                      ? _buildCustomImage()
                      : Container(),
                  Container(
                    height: 240.h,
                    child: _buildQRSection(),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 10, bottom: 0),
                    child: Center(
                        child: Text(
                      /*(qrNo.length == 0) ? "$virtualQR" :*/ "$custQR",
                      style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                          fontWeight: FontWeight.bold),
                    )),
                  ),
                ]),
              ),
        bottomNavigationBar: _bottomSection(),
      ),
    )));
  }

  _bottomSection() {
    return Wrap(
      children: [
        Container(
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
          child: Column(
            children: [
              SizedBox(
                height: 20.h,
              ),
              Center(
                child: Container(
                  color: gray,
                  width: 50.w,
                  height: 5.h,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 25.0, right: 25, top: 20),
                child: Row(
                  children: [
                    Expanded(
                        child: Image.asset(
                      'assets/paytm.png',
                      height: 20.h,
                    )),
                    Expanded(
                        child: Image.asset(
                      'assets/gpay.png',
                      height: 20.h,
                    )),
                    Expanded(
                        child: Image.asset(
                      'assets/upi.png',
                      height: 20.h,
                    )),
                    Expanded(
                        child: Image.asset(
                      'assets/phonepe.png',
                      height: 32.h,
                    )),
                  ],
                ),
              ),
              SizedBox(
                height: 20.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    powered_by,
                    style: TextStyle(
                        color: black,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  Image.asset(
                    'assets/app_splash_logo.png',
                    height: 20.h,
                  )
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              (hideButton)
                  ? Container(
                      height: 10.h,
                    )
                  : InkWell(
                      onTap: () {
                        double x = double.parse(walletBal);
                        printMessage(screen, "Wallet Balance : $walletBal");
                        if (x < 50) {
                          setState(() {
                            payBy = "UPI";
                          });
                          addressPopup();
                        } else {
                          paymentPopup();
                        }
                      },
                      child: Container(
                        height: 45.h,
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.only(
                            top: 5, left: 25, right: 25, bottom: 10),
                        decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                        ),
                        child: Center(
                          child: Text(
                            "Get Customize QR for Rs.50",
                            style: TextStyle(fontSize: font16.sp, color: white),
                          ),
                        ),
                      ),
                    ),
            ],
          ),
        ),
      ],
    );
  }

  _buildCustomImage() {
    return Container(
      margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
      decoration: BoxDecoration(
        color: bankBox,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 0.0, top: 0, bottom: 0),
        child: Row(
          children: [
            Expanded(
              flex: 1,
              child: (pickImage.length != 0)
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(20.0),
                      child: Container(
                          height: 120.h,
                          width: 120.w,
                          child: Image.network(pickImage)))
                  : (custImage.path.length != 0)
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20.0),
                          child: Container(
                            height: 140.h,
                            width: 120.w,
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: FileImage(File(custImage.path)),
                                    fit: BoxFit.cover)),
                          ),
                        )
                      : Container(),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.only(right: 20.0, top: 0, bottom: 0),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        "Pay Here Safely",
                        style: TextStyle(
                          color: black,
                          fontSize: font20.sp,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  paymentPopup() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                      border: Border.all(color: white)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 20.h,
                      ),
                      Image.asset(
                        'assets/pay_now_banner.png',
                        height: 100.h,
                      ),
                      SizedBox(
                        height: 20.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25),
                        child: Text(
                          "Your wallet have $rupeeSymbol $walletBal. Pay either by Wallet or UPI.",
                          style: TextStyle(fontSize: font15.sp, color: black),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                setState(() {
                                  hideButton = true;
                                });
                                setState(() {
                                  payBy = "Wallet";
                                });
                                addressPopup();
                              },
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                    color: green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    border: Border.all(color: green)),
                                child: Center(
                                    child: Text(
                                  "Wallet Payment",
                                  style:
                                      TextStyle(fontSize: font15.sp, color: white),
                                )),
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
                                Navigator.pop(context);
                                setState(() {
                                  hideButton = true;
                                });
                                setState(() {
                                  payBy = "UPI";
                                });
                                addressPopup();
                              },
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                    color: lightBlue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    border: Border.all(color: lightBlue)),
                                child: Center(
                                    child: Text(
                                  "UPI Payment",
                                  style:
                                      TextStyle(fontSize: font15.sp, color: white),
                                )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  addressPopup() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                      border: Border.all(color: white)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25),
                        child: Text(
                          "Are you sure?\nContinue with below address or wish to change.",
                          style: TextStyle(
                              fontSize: font15.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/map_marker_b.png',
                              height: 24.h,
                              color: lightBlue,
                            ),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "$address",
                                style: TextStyle(
                                    fontSize: font15.sp,
                                    color: black,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 15.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: InkWell(
                              onTap: () {
                                Navigator.pop(context);
                                addressChangePopup();
                              },
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                    color: green,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    border: Border.all(color: green)),
                                child: Center(
                                    child: Text(
                                  "Change",
                                  style:
                                      TextStyle(fontSize: font15.sp, color: white),
                                )),
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
                                Navigator.pop(context);
                                setState(() {
                                  hideButton = true;
                                });
                                printMessage(screen, "Payment By : $payBy");

                                printMessage(screen,
                                    "File length : ${custImage.path.length}");

                                if (payBy.toString() == "Wallet") {
                                  if (custImage.path.length == 0) {
                                    paymenyByWalletWithoutFile(
                                        "50", "0", "", "", "", "", "");
                                    printMessage(
                                        screen, "Call without file function");
                                  } else {
                                    paymenyByWalletWithFile(custImage, "50",
                                        "0", "", "", "", "", "");
                                    printMessage(
                                        screen, "Call with file function");
                                  }
                                } else if (payBy.toString() == "UPI") {
                                  paymentByUPI();
                                }
                              },
                              child: Container(
                                height: 40.h,
                                decoration: BoxDecoration(
                                    color: lightBlue,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    border: Border.all(color: lightBlue)),
                                child: Center(
                                    child: Text(
                                  "Continue",
                                  style:
                                      TextStyle(fontSize: font15.sp, color: white),
                                )),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 15.w,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  addressChangePopup() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                      border: Border.all(color: white)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, right: 25),
                        child: Text(
                          "New Address for QR delivery",
                          style: TextStyle(
                              fontSize: font15.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        height: 45.h,
                        margin: EdgeInsets.only(
                            top: 15, left: padding, right: padding),
                        decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            controller: nameController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              counterText: "",
                              label: Text("Company name/Name"),
                            ),
                            maxLength: 80,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.h,
                        margin: EdgeInsets.only(
                            top: 15, left: padding, right: padding),
                        decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            controller: addressController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              counterText: "",
                              label: Text("Address"),
                            ),
                            maxLength: 120,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.h,
                        margin: EdgeInsets.only(
                            top: 15, left: padding, right: padding),
                        decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            controller: cityController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              counterText: "",
                              label: Text("City"),
                            ),
                            maxLength: 120,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.h,
                        margin: EdgeInsets.only(
                            top: 15, left: padding, right: padding),
                        decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            controller: districtController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              counterText: "",
                              label: Text("District"),
                            ),
                            maxLength: 120,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.h,
                        margin: EdgeInsets.only(
                            top: 15, left: padding, right: padding),
                        decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            controller: stateController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              counterText: "",
                              label: Text("State"),
                            ),
                            maxLength: 120,
                          ),
                        ),
                      ),
                      Container(
                        height: 45.h,
                        margin: EdgeInsets.only(
                            top: 15, left: padding, right: padding),
                        decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            controller: pincodeController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              counterText: "",
                              label: Text("Pincode"),
                            ),
                            maxLength: 6,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);

                          setState(() {
                            hideButton = true;
                          });

                          setState(() {
                            companyName = nameController.text.toString();
                            companyAddress = addressController.text.toString();
                            city = cityController.text.toString();
                            district = districtController.text.toString();
                            state = stateController.text.toString();
                            pincode = pincodeController.text.toString();
                          });

                          printMessage(screen, "Payment By : $payBy");
                          printMessage(
                              screen, "File length : ${custImage.path.length}");

                          if (payBy.toString() == "Wallet") {
                            if (custImage.path.length == 0) {
                              paymenyByWalletWithoutFile(
                                  "50", "0", "", "", "", "", "");
                              printMessage(
                                  screen, "Call without file function");
                            } else {
                              printMessage(screen, "Call with file function");
                              paymenyByWalletWithFile(
                                  custImage, "50", "0", "", "", "", "", "");
                            }
                          } else if (payBy.toString() == "UPI") {
                            paymentByUPI();
                          }
                        },
                        child: Container(
                          height: 40.h,
                          width: MediaQuery.of(context).size.width,
                          margin: EdgeInsets.only(left: 30, right: 30, top: 20),
                          decoration: BoxDecoration(
                              color: lightBlue,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              border: Border.all(color: lightBlue)),
                          child: Center(
                              child: Text(
                            "Save & Continue",
                            style: TextStyle(fontSize: font15.sp, color: white),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  Future paymenyByWalletWithoutFile(
      walletAMT, upiAMT, pgTxn, pgMode, pgTime, pgSign, pgStatus) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": token,
      "company_name": "$companyName",
      "vpa": "$qrNo",
      "address": "$companyAddress",
      "city": "$city",
      "state": "$state",
      "pincode": "$pincode",
      "wallet": "$walletAMT",
      "paymentgateway_amount": "$upiAMT",
      "files": "",
      "image_id": "${widget.map['pickImageId']}",
      "paymentgateway_txn": "$pgTxn",
      "paymentgateway_mode": "$pgMode",
      "pgateway_txTime": "$pgTime",
      "signature": "$pgSign",
      "p_txStatus": "$pgStatus",
    };

    printMessage(screen, "BODY : $body");

    final response = await http.post(Uri.parse(customQROrderAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response QR  : ${data}");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          _paymentSuccess(data['message'].toString());
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    }else{
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }


  }

  void paymenyByWalletWithFile(File file, walletAMT, upiAMT, pgTxn, pgMode,
      pgTime, pgSign, pgStatus) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    String fileName = file.path.split('/').last;

    var token = await getToken();

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": token,
      "company_name": "$companyName",
      "vpa": "$qrNo",
      "address": "$companyAddress",
      "city": "$city",
      "state": "$state",
      "pincode": "$pincode",
      "wallet": "$walletAMT",
      "paymentgateway_amount": "$upiAMT",
      "image_id": "${widget.map['pickImageId']}",
      "paymentgateway_txn": "$pgTxn",
      "paymentgateway_mode": "$pgMode",
      "pgateway_txTime": "$pgTime",
      "signature": "$pgSign",
      "p_txStatus": "$pgStatus",
    });

    Dio dio = new Dio();

    dio.options.headers['Content-Type'] = 'application/json';
    dio.options.headers['Authorization'] = "$authHeader";

    dio.post(customQROrderAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());
      Navigator.pop(context);
      printMessage(screen, "Status Code : ${msg['message']}");
      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            _paymentSuccess(msg['message'].toString());
          } else {
            showToastMessage(msg['message'].toString());
          }
        });
      } else {
        showToastMessage(status500);
        printMessage(screen, "Error : ${response}");
      }
    }).catchError((error) => print(error));
  }

  paymentByUPI() async {
    var orderId = DateTime.now().millisecondsSinceEpoch;

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
      "x-client-id": "$cashFreeAppId",
      "x-client-secret": "$cashFreeSecretKey"
    };

    var body = {
      "orderId": "$orderId",
      "orderAmount": "50",
      "orderCurrency": "INR"
    };

    final response = await http.post(Uri.parse(cashFreeTokenAPI),
        body: json.encode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "getCashFreeToken : $data");

    setState(() {
      Navigator.pop(context);
      if (data['status'].toString() == "OK") {
        var token = data['cftoken'].toString();
        moveToPaymentGateway(orderId, token);
      } else {
        Navigator.pop(context);
      }
    });
  }

  moveToPaymentGateway(orderId, token) async {
    String orderNote = "Order Note";

    var name = await getContactName();
    var customerPhone = await getMobile();
    var customerEmail = await getEmail();

    Map<String, dynamic> inputFinalParams = {};

    Map<String, dynamic> inputParams = {
      "orderId": "$orderId",
      "orderAmount": "50",
      "customerName": "$name",
      "orderCurrency": "INR",
      "appId": "$cashFreeAppId",
      "customerPhone": customerPhone,
      "customerEmail": customerEmail,
      "tokenData": "$token",
      "stage": "$cashFreePGMode",
      "orderNote": orderNote,
    };

    CashfreePGSDK.getUPIApps().then((value) {
      setState(() {
        getUPIAppNamesUPI(value, orderId, token);
      });
    });
  }

  getUPIAppNamesUPI(result, orderId, token) async {
    String orderNote = "Order Note";

    if (result.length == 0) {
      showToastMessage("$noUPIapp");
    } else {
      List<UPIList> list = [];

      setState(() {
        noOfUPI = result.length;
      });

      for (int i = 0; i < result.length; i++) {
        var displayName = result[i]['displayName'];
        var id = result[i]['id'];
        printMessage(screen, "Display Name : $displayName with Index : $id");
        UPIList w2 = new UPIList(name: "$displayName", id: "$id");
        list.add(w2);
      }

      if (checkIdPresent(list, "PhonePe")) {
        upiId = "com.phonepe.app";
      } else if (checkIdPresent(list, "GPay")) {
        upiId = "com.google.android.apps.nbu.paisa.user";
      } else if (checkIdPresent(list, "Paytm")) {
        upiId = "net.one97.paytm";
      } else if (checkIdPresent(list, "Amazon")) {
        upiId = "in.amazon.mShop.android.shopping";
      } else if (checkIdPresent(list, "Bhim")) {
        upiId = "in.org.npci.upiapp";
      } else if (checkIdPresent(list, "Truecaller")) {
        upiId = "com.truecaller";
      } else if (checkIdPresent(list, "iMobile Pay")) {
        upiId = "com.csam.icici.bank.imobile";
      } else {
        upiId = result[0]['id'].toString();
      }

      var name = await getContactName();
      var customerPhone = await getMobile();
      var customerEmail = await getEmail();

      Map<String, dynamic> inputParams = {
        "orderId": "$orderId",
        "orderAmount": "50",
        "customerName": "$name",
        "orderCurrency": "INR",
        "appId": "$cashFreeAppId",
        "customerPhone": customerPhone,
        "customerEmail": customerEmail,
        "tokenData": "$token",
        "stage": "$cashFreePGMode",
        "orderNote": orderNote,
        "appName": upiId,
      };

      printMessage(screen, "Input Params : $inputParams");

      CashfreePGSDK.doUPIPayment(inputParams).then((value) {
        setState(() {
          verifySignatureByPG(value);
        });
        printMessage(screen, "doUPIPayment result : $value");
      });
    }
  }

  verifySignatureByPG(responsePG) async {
    var txStatus = responsePG['txStatus'];
    var orderAmount = responsePG['orderAmount'];
    var paymentMode = responsePG['paymentMode'];
    var orderId = responsePG['orderId'];
    var txTime = responsePG['txTime'];
    var txMsg = responsePG['txMsg'];
    var type = responsePG['type'];
    var referenceId = responsePG['referenceId'];
    var signature = responsePG['signature'];

    printMessage(screen, "TxStatus    : $txStatus");
    printMessage(screen, "orderAmount : $orderAmount");
    printMessage(screen, "paymentMode : $paymentMode");
    printMessage(screen, "orderId     : $orderId");
    printMessage(screen, "txTime      : $txTime");
    printMessage(screen, "txMsg       : $txMsg");
    printMessage(screen, "type        : $type");
    printMessage(screen, "referenceId : $referenceId");
    printMessage(screen, "signature   : $signature");

    // Navigator.pop(context);

    if (responsePG['txStatus'].toString() == "SUCCESS") {
      printMessage(screen, "Transaction is Successful");
      setState(() {
        if (custImage.path.length == 0) {
          paymenyByWalletWithoutFile(
              "0", "50", orderId, paymentMode, txTime, signature, txStatus);
          printMessage(screen, "Call without file function");
        } else {
          paymenyByWalletWithFile(custImage, "0", "50", orderId, paymentMode,
              txTime, signature, txStatus);
          printMessage(screen, "Call with file function");
        }
      });
    } else if (responsePG['txStatus'].toString() == "FAILED") {
      showToastMessage(txStatus.toString());
    } else {
      Navigator.pop(context);
      showToastMessage(txStatus.toString());
    }
  }

  checkIdPresent(List<UPIList> list, value) {
    var isPass = false;
    for (int i = 0; i < list.length; i++) {
      if (value == list[i].name) {
        isPass = true;
        break;
      } else {
        isPass = false;
      }
    }
    return isPass;
  }

  _buildQRSection() {
    return Container(
      child: Image.memory(
        base64Decode("${widget.map['qrString'].toString()}"),
        fit: BoxFit.cover,
      ),
    );
  }

  _paymentSuccess(msg) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(50),
                        topLeft: Radius.circular(50),
                      ),
                      border: Border.all(color: white)),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 30.h,
                      ),
                      Image.asset(
                        'assets/thanks.png',
                        height: 48.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25, top: 20),
                        child: Text(
                          "Thankyou",
                          style: TextStyle(
                              fontSize: font15.sp,
                              color: black,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25, top: 10),
                        child: Text(
                          "$msg",
                          style: TextStyle(
                              fontSize: font14.sp,
                              color: black,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 25.0, right: 25, top: 5),
                        child: Text(
                          "Your QR will be delivered within 7-10 working days.",
                          style: TextStyle(
                              fontSize: font14.sp,
                              color: black,
                              fontWeight: FontWeight.normal),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pop(context);
                          shareTransReceipt(_printKey);
                        },
                        child: Container(
                          height: 40.h,
                          width: MediaQuery.of(context).size.width * .6,
                          decoration: BoxDecoration(
                              color: green,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25)),
                              border: Border.all(color: green)),
                          child: Center(
                              child: Text(
                            "Ok",
                            style: TextStyle(fontSize: font15.sp, color: white),
                          )),
                        ),
                      ),
                      SizedBox(
                        height: 30.h,
                      ),
                    ],
                  ),
                ),
              ],
            ));
  }

  void uploadQRPreview(File file) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while uploading your data to server");
          });
    });

    String fileName = file.path.split('/').last;

    var token = await getToken();

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromBytes(File(file.path).readAsBytesSync(),
          filename: fileName),
      "token": token,
    });

    Dio dio = new Dio();

    dio.post(qrImageUploadAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());
      Navigator.pop(context);

      printMessage(screen, "Status Code : ${msg['message']}");

      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            //removeAllPages(context);
          } else {
            showToastMessage(msg['message'].toString());
          }
        });
      } else {
        showToastMessage(status500);
        printMessage(screen, "Error : ${response}");
      }
    }).catchError((error) => print(error));
  }

  shareTransReceipt(_printKey) async {
    RenderRepaintBoundary boundary =
        _printKey.currentContext?.findRenderObject() as RenderRepaintBoundary;
    ui.Image image = await boundary.toImage();
    final directory = (await getApplicationDocumentsDirectory()).path;
    ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    Uint8List? pngBytes = byteData?.buffer.asUint8List();
    // print(pngBytes);
    File imgFile = new File('$directory/customQr.png');
    await imgFile.writeAsBytes(pngBytes!);

    imgFile.exists();
    uploadQRPreview(imgFile);
    // Share.shareFiles([imgFile.path]);
  }
}
