import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/AppKeys.dart';

class AePSFinoLanding extends StatefulWidget {
  const AePSFinoLanding({Key? key}) : super(key: key);

  @override
  State<AePSFinoLanding> createState() => _AePSFinoLandingState();
}

class _AePSFinoLandingState extends State<AePSFinoLanding> {
  var selectCatPos;

  var screen = "AESP Landing";

  int actionIndex = 3;

  var loading = false;
  var authToken;

  var aepsTxnId = "";

  AepsOption apes = AepsOption.balcEnq;

  double lat = 0.0;
  double lng = 0.0;

  final GeolocatorPlatform geolocator = GeolocatorPlatform.instance;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  @override
  void dispose() {
    super.dispose();
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
                  InkWell(
                      onTap: (){
                        //openYoutubeVdoPlayer(context,"a3bGXDRTw_Q");
                      },
                      child: Container(
                          height: 30.h,
                          margin: EdgeInsets.only(top: 14, left: 10, right: 10, bottom: 14),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: black)
                          ),
                          child: Row(
                            children: [
                              SizedBox(width: 10.w,),
                              Image.asset('assets/ic_youtube.png', width: 20.w,),
                              SizedBox(width: 4.w,),
                              Text("HELP VIDEOS", style: TextStyle(
                                  color: black, fontSize: font12.sp
                              ),),
                              SizedBox(width: 10.w,),
                            ],
                          ))),
                  SizedBox(
                    width: 10.w,
                  )
                ],
              ),
              body: (loading)
                  ? Center(child: circularProgressLoading(40.0))
                  : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    appSelectedBanner(context, "recharge_banner.png", 150.0),
                    SizedBox(
                      height: 20.h,
                    ),
                    _buildTabSection(),
                    Divider(),
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 20),
                      child: Text(
                        "Notes:",
                        style: TextStyle(color: black, fontSize: font16.sp),
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "1. ",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "AEPS withdrawal available 24X7, 365 days",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "2. ",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "To avail commission min trans amount is Rs.200",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "3. ",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "All commission and actual amount will added to Merchant's main wallet.",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "4. ",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Payout charges applicable as per bank predefined slab and may change time to time.",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "5. ",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "No commission for Bal Inquiry and Mini Statement.",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "6. ",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                          Text(
                            "Minimum withdrawal amount is Rs. 100",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                      const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "7. ",
                            style: TextStyle(color: black, fontSize: font14.sp),
                          ),
                          Text(
                            "Aadhar Pay charges 1% of the withdrawal amount",
                            style: TextStyle(color: red, fontSize: font16),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              bottomNavigationBar: _buildBottomSection(),
            )));
  }

  _buildTabSection() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            children: [
              Image.asset(
                "assets/recipt.png",
                color: lightBlue,
                height: 20.h,
                width: 20.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    '$withdraw',
                    style: TextStyle(color: black, fontSize: font16.sp),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Radio(
                  value: AepsOption.withdrl,
                  groupValue: apes,
                  onChanged: (value) {
                    setState(() {
                      apes = AepsOption.withdrl;
                      actionIndex = 1;
                    });
                  })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            children: [
              Image.asset(
                "assets/notice.png",
                color: lightBlue,
                height: 20.h,
                width: 20.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    '$miniState',
                    style: TextStyle(color: black, fontSize: font16.sp),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Radio(
                  value: AepsOption.miniStatement,
                  groupValue: apes,
                  onChanged: (value) {
                    setState(() {
                      apes = AepsOption.miniStatement;
                      actionIndex = 2;
                    });
                  })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            children: [
              Image.asset(
                "assets/aeps.png",
                color: lightBlue,
                height: 20.h,
                width: 20.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    'Aadhar Pay',
                    style: TextStyle(color: black, fontSize: font16.sp),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Radio(
                  value: AepsOption.aadharPay,
                  groupValue: apes,
                  onChanged: (value) {
                    setState(() {
                      apes = AepsOption.aadharPay;
                      actionIndex = 4;
                    });
                  })
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20),
          child: Row(
            children: [
              Image.asset(
                "assets/filter.png",
                color: lightBlue,
                height: 20.h,
                width: 20.w,
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                  flex: 1,
                  child: Text(
                    '$balcEnquiry',
                    style: TextStyle(color: black, fontSize: font16.sp),
                  )),
              SizedBox(
                width: 10.w,
              ),
              Radio(
                  value: AepsOption.balcEnq,
                  groupValue: apes,
                  onChanged: (value) {
                    setState(() {
                      apes = AepsOption.balcEnq;
                      actionIndex = 3;
                    });
                  })
            ],
          ),
        ),
      ],
    );
  }

  _buildBottomSection() {
    return Container(
      height: 60.h,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {

                if(lat==0.0 || lng==0.0){
                  _determineSecondPosition();
                  showToastMessage("Please wait, while we are getting your location");
                  return;
                }


                var txnType = "";

                if(actionIndex==1){
                  setState(() {
                    txnType="CW";
                  });
                }
                else if(actionIndex==2){
                  setState(() {
                    txnType="MS";
                  });
                }
                else if(actionIndex==3){
                  setState(() {
                    txnType="BE";
                  });
                }
                else if(actionIndex==4){
                  setState(() {
                    txnType="AP";
                  });
                }



                _checkUserKyc(txnType);

              });
            },
            child: Container(
              height: 50.h,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 0),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Text(
                  (actionIndex == 1)
                      ? withdrawNow
                      : (actionIndex == 2)
                      ? miniState
                      : (actionIndex == 3)
                      ? checkBalc
                      : "Aadhar Pay",
                  style: TextStyle(fontSize: font15.sp, color: white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _checkUserKyc(txnType)async {

    var mCode = await getMerchantID();
    var mobile = await getMobile();
    var firm = await getComapanyName();
    var email = await getEmail();

    if (Platform.isAndroid) {
      const platform = const MethodChannel("MICRO_ATM_CHANNEL");

      var arr = {
        "pId":"$partnerId",
        "pApiKey":"$partnerKey",
        "mCode":"$mCode",
        "mobile":"$mobile",
        "lat":"$lat",
        "lng":"$lng",
        "firm":"$firm",
        "email":"$email"
      };

      String result = await platform.invokeMethod("aepsfino", arr);

      printMessage(screen, "AEPS Fino Response : $result");

      if (result.toString() == "null") {

      } else {
        if(result=="Account is activated"){
          //openAePSMobileVerify(context,txnType,lat.toString(),lng.toString());

          openAePSFinoTransaction(context, txnType, lat.toString(),lng.toString());
        }
      }
    }
  }

  Future _determinePosition() async {
    LocationPermission permission = await Geolocator.checkPermission();
    printMessage(screen, "Location 2 Permission : $permission");

    if (permission == LocationPermission.denied) {
      _determineSecondPosition();
      _getCurrentLocation();
    } else if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _getCurrentLocation();
    }
  }

  Future<Position> _determineSecondPosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    printMessage(screen, "Location Permission : $serviceEnabled");

    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();

    printMessage(screen, "Location 2 Permission : $permission");

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    return await Geolocator.getCurrentPosition();
  }

  _getCurrentLocation() {
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        lat = position.latitude;
        lng = position.longitude;
        printMessage(screen, "Get location : $lat $lng");
      });
    }).catchError((e) {
      print(e);
    });
  }

}
