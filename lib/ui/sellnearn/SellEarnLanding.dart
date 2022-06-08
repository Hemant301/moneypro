import 'dart:async';

import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:video_player/video_player.dart';
import '../../utils/Apis.dart';
import '../../utils/AppKeys.dart';
import '../../utils/Constants.dart';
import '../../utils/CustomWidgets.dart';
import '../../utils/Functions.dart';
import '../footer/WelcomeOfferPopup.dart';
import '../models/Banners.dart';

class SellEarnLanding extends StatefulWidget {
  const SellEarnLanding({Key? key}) : super(key: key);

  @override
  State<SellEarnLanding> createState() => _SellEarnLandingState();
}

class _SellEarnLandingState extends State<SellEarnLanding> {
  var screen = "Sell N Earn";

  double moneyProBalc = 0.0;

  List<BannerList> bannerList = [];

  var loading = false;

  late PageController _pageController;

  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();
    getBannerImage();
    if (mounted) {
      _pageController = PageController();
     // autoAnimateBanner();
    }
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var welComeBalc = await getWelcomeAmt();
    double mX = 0.0;
    double wX = 0.0;

    final inheritedWidget = StateContainer.of(context);

    if (mpBalc == null || mpBalc == 0) {
      mpBalc = 0;
      inheritedWidget.updateMPBalc(value: mpBalc);
    } else {
      inheritedWidget.updateMPBalc(value: mpBalc);
    }

    if (qrBalc == null || qrBalc == 0) {
      qrBalc = 0;
      inheritedWidget.updateQRBalc(value: qrBalc);
    } else {
      inheritedWidget.updateQRBalc(value: qrBalc);
    }

    if (welComeBalc == null || welComeBalc == 0) {
      welComeBalc = 0;
      inheritedWidget.updateWelBalc(value: welComeBalc);
    } else {
      inheritedWidget.updateWelBalc(value: welComeBalc);
    }

    if (welComeBalc != null || welComeBalc != 0) {
      wX = double.parse(welComeBalc);
    }

    if (mpBalc != null || mpBalc != 0) {
      mX = double.parse(mpBalc);
    }
    setState(() {
      moneyProBalc = wX + mX;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              appBar: appBarHome(context, "", 24.0.w),
              backgroundColor: boxBg,
              body: (loading)?Center(
                child: circularProgressLoading(40.0),
              ):ListView(
                children: [
                  _buildWalletSection(),
                  SizedBox(height: 20.h,),
                  _buildDetailSection(),
                ],
              ),
            )));
  }

  _buildWalletSection() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),// 200963597
          Row(
            children: [
              SizedBox(
                width: 15.w,
              ),
              Container(
                  height: 45.h,
                  width: 45.w,
                  decoration: BoxDecoration(
                    color: gray, // border color
                    shape: BoxShape.circle,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Image.asset(
                      'assets/wallet_blue.png',
                      color: lightBlue,
                    ),
                  )),
              SizedBox(
                width: 10.w,
              ),
              InkWell(
                onTap: (){
                  openSellWallet(context);
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "BALANCE",
                      style: TextStyle(color: lightBlack, fontSize: font14.sp),
                    ),
                    SizedBox(height: 3.h,),
                    Text("$rupeeSymbol ${formatDecimal2Digit.format(moneyProBalc)}",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: font22.sp,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Spacer(),
              InkWell(
                onTap: () {
                  setState(() {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent,
                        builder: (context) => _showLeadsPopup());
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                      child: Text(
                        "ADD LEAD & EARN",
                        style: TextStyle(fontSize: font16.sp, color: white),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, right: 15, top: 8, bottom: 8),
            child: DottedLine(
              direction: Axis.horizontal,
              lineLength: double.infinity,
              lineThickness: 1.0,
              dashLength: 4.0,
              dashColor: lightBlack,
              dashRadius: 1.0,
              dashGapLength: 4.0,
              dashGapColor: Colors.transparent,
              dashGapRadius: 0.0,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [

                Text("TOTAL EARNING", style: TextStyle(
                  color: lightBlack, fontSize: font16.sp,
                ),),
                Text("$rupeeSymbol 0.00", style: TextStyle(
                  color: black, fontSize: font18.sp,fontWeight: FontWeight.bold
                ),),

              ],
            ),
          ),
          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }

  _buildDetailSection(){
    return Container(
      width: MediaQuery.of(context).size.width,
      color: white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBannerSection(_pageController),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: Text("Sell & Earn", style: TextStyle(
              color: lightBlack, fontWeight: FontWeight.w600, fontSize: font16.sp
            ),),
          ),
          _buildCustomGrid(),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: Text("Top Selling Brands", style: TextStyle(
                color: lightBlack, fontWeight: FontWeight.w600, fontSize: font16.sp
            ),),
          ),
          _buildTopSelling(),
          Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 15),
            child: Text("Featured Videos", style: TextStyle(
                color: lightBlack, fontWeight: FontWeight.w600, fontSize: font16.sp
            ),),
          ),
          _buildFeatureVideos(),
          SizedBox(height: 20.h,),
        ],
      ),
    );
  }

  _buildBannerSection(controller) {
    return Column(
      children: [
        Container(
            color: white,
            height: MediaQuery.of(context).size.height * .17,
            child: PageView.builder(
              controller: controller,
              scrollDirection: Axis.horizontal,
              itemCount: bannerList.length,
              onPageChanged: (index) {

              },
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: (){

                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.network(
                        "$bannerBaseUrl${bannerList[index].image}",
                        fit: BoxFit.fitHeight,
                      ),
                    ),
                  ),
                );
              },
            )),
      ],
    );
  }

  _buildCustomGrid() {
    return Padding(
      padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(child: InkWell(
                onTap: () {
                  openOptoinsLists(context,"saving_acc");
                },
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                        color: greenLight,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 15.w,),
                                  Expanded(
                                      flex: 1,
                                      child: Text("Savings Account", style: TextStyle(
                                          fontSize: font18.sp,
                                          fontWeight: FontWeight.w600
                                      ),)),
                                  SizedBox(width: 5.w,),
                                  Container(
                                      height: 45.h,
                                      width: 45.w,
                                      decoration: BoxDecoration(
                                        color: gray, // border color
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/saving_acc.png',
                                          color: orange,
                                        ),
                                      )),
                                  SizedBox(width: 15.w,),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: black)
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "EARN UPTO $rupeeSymbol 500",
                                        style: TextStyle(fontSize: font13.sp, color: black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ))),
                ),
              ),flex: 1,),
              SizedBox(width: 10.w,),
              Expanded(child: InkWell(
                onTap: () {
                  openOptoinsLists(context,"demat_acc");
                },
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 15.w,),
                                  Expanded(
                                      flex: 1,
                                      child: Text("Demat Account", style: TextStyle(
                                          fontSize: font18.sp,
                                          fontWeight: FontWeight.w600
                                      ),)),
                                  SizedBox(width: 5.w,),
                                  Container(
                                      height: 45.h,
                                      width: 45.w,
                                      decoration: BoxDecoration(
                                        color: gray, // border color
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/demat_acc.png',
                                          color: orange,
                                        ),
                                      )),
                                  SizedBox(width: 15.w,),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: black)
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "EARN UPTO $rupeeSymbol 450",
                                        style: TextStyle(fontSize: font13.sp, color: black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ))),
                ),
              ),flex: 1,),
            ],
          ),
          SizedBox(height: 15.h,),
          Row(
            children: [
              Expanded(child: InkWell(
                onTap: () {
                  openOptoinsLists(context,"credit_card");
                },
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                        color: seaGreenLight,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 15.w,),
                                  Expanded(
                                      flex: 1,
                                      child: Text("Credit Cards", style: TextStyle(
                                          fontSize: font18.sp,
                                          fontWeight: FontWeight.w600
                                      ),)),
                                  SizedBox(width: 5.w,),
                                  Container(
                                      height: 45.h,
                                      width: 45.w,
                                      decoration: BoxDecoration(
                                        color: gray, // border color
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/iccredit_card.png',
                                          color: orange,
                                        ),
                                      )),
                                  SizedBox(width: 15.w,),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: black)
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "EARN UPTO $rupeeSymbol 2000",
                                        style: TextStyle(fontSize: font13.sp, color: black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ))),
                ),
              ),flex: 1,),
              SizedBox(width: 10.w,),
              Expanded(child: InkWell(
                onTap: () {
                 // openEarnDetails(context,"demat_acc");
                },
                child: Center(
                  child: Container(
                      decoration: BoxDecoration(
                        color: homeOrageLight,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Column(
                            children: [
                              SizedBox(
                                height: 20.h,
                              ),
                              Row(
                                children: [
                                  SizedBox(width: 15.w,),
                                  Expanded(
                                      flex: 1,
                                      child: Text("Loan Services", style: TextStyle(
                                          fontSize: font18.sp,
                                          fontWeight: FontWeight.w600
                                      ),)),
                                  SizedBox(width: 5.w,),
                                  Container(
                                      height: 45.h,
                                      width: 45.w,
                                      decoration: BoxDecoration(
                                        color: gray, // border color
                                        shape: BoxShape.circle,
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(10.0),
                                        child: Image.asset(
                                          'assets/ic_loan.png',
                                          color: orange,
                                        ),
                                      )),
                                  SizedBox(width: 15.w,),
                                ],
                              ),
                              Container(
                                margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: black)
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                    child: FittedBox(
                                      fit: BoxFit.contain,
                                      child: Text(
                                        "EARN UPTO 5%",
                                        style: TextStyle(fontSize: font13.sp, color: black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),

                            ],
                          ))),
                ),
              ),flex: 1,),
            ],
          ),
        ],
      ),
    );
  }

  _buildTopSelling(){
    return Container(
      height: 140.h,
      child: ListView(
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        children: [
          InkWell(
            onTap: (){
              openSellDetails(context, "au_json");
            },
            child: Container(
              width: 120.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h,),
                  Container(
                      height: 56.h,
                      width: 56.w,
                      decoration: BoxDecoration(
                        // color: Colors.black26, // border color
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/au_logo.png',
                        ),
                      )),
                  SizedBox(
                    height: 40.h,
                    width: 90.w,
                    child: Center(
                      child: Text(
                        "AU Bank",
                        style: TextStyle(
                            color: black,fontSize: font14.sp,
                            fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    "Earn $rupeeSymbol 150",
                    style: TextStyle(
                        color: homeOrage,fontSize: font12.sp,
                        fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  )
                ],

              ),
            ),
          ),
          InkWell(
            onTap: (){
              //equitas
              openSellDetails(context, "equitas");
            },
            child: Container(
              width: 120.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h,),
                  Container(
                      height: 56.h,
                      width: 56.w,
                      decoration: BoxDecoration(
                        // color: Colors.black26, // border color
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/equitas_logo.png',
                        ),
                      )),
                  SizedBox(
                    height: 40.h,
                    width: 90.w,
                    child: Center(
                      child: Text(
                        "Equitas",
                        style: TextStyle(
                            color: black,fontSize: font14.sp,
                            fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    "Earn $rupeeSymbol 150",
                    style: TextStyle(
                        color: homeOrage,fontSize: font12.sp,
                        fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  )
                ],

              ),
            ),
          ),
          InkWell(
            onTap: (){
              openSellDetails(context, "kotak_json");
            },
            child: Container(
              width: 120.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h,),
                  Container(
                      height: 56.h,
                      width: 56.w,
                      decoration: BoxDecoration(
                        //color: Colors.black26, // border color
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/kotak_logo.png',
                        ),
                      )),
                  SizedBox(
                    height: 40.h,
                    width: 90.w,
                    child: Center(
                      child: Text(
                        "Kotak Bank",
                        style: TextStyle(
                            color: black,fontSize: font14.sp,
                            fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    "Earn $rupeeSymbol 150",
                    style: TextStyle(
                        color: homeOrage,fontSize: font12.sp,
                        fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  )
                ],

              ),
            ),
          ),
          InkWell(
            onTap: (){
              openSellDetails(context, "niyox_json");
            },
            child: Container(
              width: 120.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h,),
                  Container(
                      height: 56.h,
                      width: 56.w,
                      decoration: BoxDecoration(
                       // color: Colors.black26, // border color
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/niyox_logo.png',
                        ),
                      )),
                  SizedBox(
                    height: 40.h,
                    width: 90.w,
                    child: Center(
                      child: Text(
                        "NiyoX",
                        style: TextStyle(
                            color: black,fontSize: font14.sp,
                            fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    "Earn $rupeeSymbol 100",
                    style: TextStyle(
                        color: homeOrage,fontSize: font12.sp,
                        fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  )
                ],

              ),
            ),
          ),
          InkWell(
            onTap: (){
              openSellDetails(context, "indusind_json");
            },
            child: Container(
              width: 120.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h,),
                  Container(
                      height: 56.h,
                      width: 56.w,
                      decoration: BoxDecoration(
                        //color: Colors.black26, // border color
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/indusind_logo.png',
                        ),
                      )),
                  SizedBox(
                    height: 40.h,
                    width: 90.w,
                    child: Center(
                      child: Text(
                        "IndusInd Bank",
                        style: TextStyle(
                            color: black,fontSize: font14.sp,
                            fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    "Earn $rupeeSymbol 150",
                    style: TextStyle(
                        color: homeOrage,fontSize: font12.sp,
                        fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  )
                ],

              ),
            ),
          ),
          InkWell(
            onTap: (){
              openSellDetails(context, "fimoney_json");
            },
            child: Container(
              width: 120.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 20.h,),
                  Container(
                      height: 56.h,
                      width: 56.w,
                      decoration: BoxDecoration(
                       // color: Colors.black26, // border color
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/fimoney_logo.png',
                        ),
                      )),
                  SizedBox(
                    height: 40.h,
                    width: 90.w,
                    child: Center(
                      child: Text(
                        "Fi Money",
                        style: TextStyle(
                            color: black,fontSize: font14.sp,
                            fontWeight: FontWeight.w600
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  Text(
                    "Earn $rupeeSymbol 150",
                    style: TextStyle(
                        color: homeOrage,fontSize: font12.sp,
                        fontWeight: FontWeight.w700
                    ),
                    textAlign: TextAlign.center,
                  )
                ],

              ),
            ),
          ),

        ],
      ),
    );
  }

  _buildFeatureVideos(){
    return Container(
      height: 100.h,
      child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemCount: 10,
          itemBuilder: (context, index){
            return InkWell(
              onTap: (){
                openYoutubeVdoPlayer(context,"a3bGXDRTw_Q");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset('assets/banner_1.png', width: 240.w,),
                    Container(
                        height: 42.h,
                        width: 42.w,
                        decoration: BoxDecoration(
                          color: Colors.white, // border color
                          shape: BoxShape.circle,
                        ),
                        child: Icon(Icons.play_arrow_rounded, color: homeOrage,)),
                  ],
                ),
              ),
            );
          }),
    );
  }

  Future getBannerImage() async {

    setState(() {
      loading=true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response = await http.post(Uri.parse(bannerImgAPI), headers: headers);

    setState(() {
      var statusCode = response.statusCode;
      loading=false;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Banner Image Response : ${data}");
        if (data['status'].toString() == "1") {
          var result =
          Banners.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          bannerList = result.bannerList;
        }
      }
    });
  }

  autoAnimateBanner() {
    try {
      Timer.periodic(Duration(seconds: 6), (Timer timer) {
        if (currentIndex < bannerList.length) {
          currentIndex++;
        } else {
          currentIndex = 0;
        }

        if (_pageController.hasClients)
          _pageController.animateToPage(
            currentIndex,
            duration: Duration(milliseconds: 500),
            curve: Curves.easeIn,
          );
      });
    } catch (e) {
      printMessage(screen, "ERROR -> ${e.toString()}");
    }
  }

  _showLeadsPopup(){
    return Wrap(
      children: [
        Container(
          color: white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 15.0, top: 15),
                child: Row(
                  children: [
                    Text("Select and Add a Lead", style: TextStyle(
                        color: black, fontWeight: FontWeight.bold, fontSize: font16.sp
                    ),),
                    Spacer(),
                    Image.asset('assets/close_menu.png', height: 36,),
                    SizedBox(width: 15.w,),
                  ],
                ),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 20, bottom: 20),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(child: InkWell(
                          onTap: () {

                          },
                          child: Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: greenLight,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 15.w,),
                                            Expanded(
                                                flex: 1,
                                                child: Text("Savings Account", style: TextStyle(
                                                    fontSize: font18.sp,
                                                    fontWeight: FontWeight.w600
                                                ),)),
                                            Image.asset('assets/pay_online.png',
                                              height: 45.h,width: 45.w,),
                                            SizedBox(width: 15.w,),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: black)
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  "EARN UPTO $rupeeSymbol 500",
                                                  style: TextStyle(fontSize: font13.sp, color: black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ))),
                          ),
                        ),flex: 1,),
                        SizedBox(width: 10.w,),
                        Expanded(child: InkWell(
                          onTap: () {

                          },
                          child: Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: editBg,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 15.w,),
                                            Expanded(
                                                flex: 1,
                                                child: Text("Demat Account", style: TextStyle(
                                                    fontSize: font18.sp,
                                                    fontWeight: FontWeight.w600
                                                ),)),
                                            Image.asset('assets/pay_online.png',
                                              height: 45.h,width: 45.w,),
                                            SizedBox(width: 15.w,),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: black)
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  "EARN UPTO $rupeeSymbol 450",
                                                  style: TextStyle(fontSize: font13.sp, color: black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ))),
                          ),
                        ),flex: 1,),
                      ],
                    ),
                    SizedBox(height: 15.h,),
                    Row(
                      children: [
                        Expanded(child: InkWell(
                          onTap: () {

                          },
                          child: Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: seaGreenLight,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 15.w,),
                                            Expanded(
                                                flex: 1,
                                                child: Text("Credit Cards", style: TextStyle(
                                                    fontSize: font18.sp,
                                                    fontWeight: FontWeight.w600
                                                ),)),
                                            Image.asset('assets/pay_online.png',
                                              height: 45.h,width: 45.w,),
                                            SizedBox(width: 15.w,),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: black)
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  "EARN UPTO $rupeeSymbol 2000",
                                                  style: TextStyle(fontSize: font13.sp, color: black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ))),
                          ),
                        ),flex: 1,),
                        SizedBox(width: 10.w,),
                        Expanded(child: InkWell(
                          onTap: () {

                          },
                          child: Center(
                            child: Container(
                                decoration: BoxDecoration(
                                  color: homeOrageLight,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Column(
                                      children: [
                                        SizedBox(
                                          height: 20.h,
                                        ),
                                        Row(
                                          children: [
                                            SizedBox(width: 15.w,),
                                            Expanded(
                                                flex: 1,
                                                child: Text("Loan Services", style: TextStyle(
                                                    fontSize: font18.sp,
                                                    fontWeight: FontWeight.w600
                                                ),)),
                                            Image.asset('assets/pay_online.png',
                                              height: 45.h,width: 45.w,),
                                            SizedBox(width: 15.w,),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: black)
                                          ),
                                          child: Center(
                                            child: Padding(
                                              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                              child: FittedBox(
                                                fit: BoxFit.contain,
                                                child: Text(
                                                  "EARN UPTO 5%",
                                                  style: TextStyle(fontSize: font13.sp, color: black),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),

                                      ],
                                    ))),
                          ),
                        ),flex: 1,),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
      ],
    );
}

}
