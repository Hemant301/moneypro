import 'dart:io';
import 'dart:typed_data';

import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/CustomWidgets.dart';
import '../../utils/Functions.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'dart:convert';

class SellDetails extends StatefulWidget {
  final String fileName;
  const SellDetails({Key? key, required this.fileName}) : super(key: key);

  @override
  State<SellDetails> createState() => _SellDetailsState();
}

class _SellDetailsState extends State<SellDetails>
    with SingleTickerProviderStateMixin {
  TabController? _tabController;

  var screen = "Sell Details";

  var jsonResponse ;
  
  var loading = false;

  final List<Tab> tabs = <Tab>[
    new Tab(text: "Benefits"),
    new Tab(text: "About"),
    new Tab(text: "How to Achieve & Earn"),
    new Tab(text: "FAQ's"),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: tabs.length);
    setState(() {
      loading= true;
    });
    getData();
  }

  Future<String> getJson() {
    //au_json
    printMessage(screen, "File name : ${widget.fileName}");
    return rootBundle.loadString('assets/file/${widget.fileName}.json');
  }

  Future getData()async{
    jsonResponse = json.decode(await getJson());
    printMessage(screen, "MY Data : ${jsonResponse['bank']['faqs']}");
    setState(() {
      loading=false;
    });
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
              icon: Container(
                height: 24.0.h,
                child: Icon(
                  Icons.arrow_back,
                  color: black,
                ),
              ),
              onPressed: () {
                closeKeyBoard(context);
                closeCurrentPage(context);
              },
            ),
            titleSpacing: -10,
            title: appLogo(),
            actions: <Widget>[
              InkWell(
                onTap: () {
                  closeKeyBoard(context);
                },
                child: Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, top: 10, bottom: 10, right: 15),
                  child: Image.asset(
                    "assets/faq.png",
                    height: 24.h,
                    color: orange,
                  ),
                ),
              ),
            ],
            bottom: new TabBar(
              isScrollable: true,
              unselectedLabelColor: black,
              labelColor: white,
              labelStyle: TextStyle(fontSize: font14),
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: new BubbleTabIndicator(
                indicatorHeight: 25.0,
                indicatorColor: lightBlue,
                tabBarIndicatorSize: TabBarIndicatorSize.tab,
              ),
              tabs: tabs,
              controller: _tabController,
              onTap: (val) {
                printMessage(screen, "Tab on : $val");

                setState(() {});
              },
            )),
        body: (loading)?Center(
          child: circularProgressLoading(40.0),
        ):TabBarView(
          controller: _tabController,
          physics: NeverScrollableScrollPhysics(),
          children: [
            _buildBenefitsSection(),
            _buildAboutSection(),
            _buildAccountSection(),
            _buildFAQsSection(),
          ],
        ),
        bottomNavigationBar: InkWell(
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
            margin: EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 10),
            height: 50.h,
            decoration: BoxDecoration(
              color: black,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Center(
              child: Text(
                "Share to Customer",
                style: TextStyle(fontSize: font16.sp, color: white),
              ),
            ),
          ),
        ),
      )),
    );
  }

  _buildBenefitsSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 20),
              width: MediaQuery.of(context).size.width,
              height: 50.h,
              decoration: BoxDecoration(
                color: greenLight,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20),
                  child: Text("${jsonResponse['bank']['Benefits']['ben_tag']}",
                    style: TextStyle(
                        color: black,
                        fontSize: font14.sp,
                        fontWeight: FontWeight.w600),),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 15),
              child: Text(
                "Watch the training Videos",
                style: TextStyle(
                    color: black,
                    fontWeight: FontWeight.w600,
                    fontSize: font16.sp),
              ),
            ),
            InkWell(
              onTap: () {
                openYoutubeVdoPlayer(context,"a3bGXDRTw_Q");
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Image.asset(
                      'assets/banner_1.png',
                    ),
                    Container(
                        height: 42.h,
                        width: 42.w,
                        decoration: BoxDecoration(
                          color: Colors.white, // border color
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.play_arrow_rounded,
                          color: homeOrage,
                        )),
                  ],
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: greenLight,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text(
                      "How it works",
                      style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                    physics: ScrollPhysics(),
                    itemCount: jsonResponse['bank']['Benefits']['how_works'].length,
                      shrinkWrap: true,
                      itemBuilder: (context, index){
                    return Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15,),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${index +1}. ",
                            style: TextStyle(
                                color: black,
                                fontSize: font14.sp,
                                fontWeight: FontWeight.normal),
                          ),
                          Expanded(
                            flex: 1,
                            child: Text(
                              "${jsonResponse['bank']['Benefits']['how_works'][index]}",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font14.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                  SizedBox(height: 20.h,),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: greenLight,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text(
                      "Terms & Conditions",
                      style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                      itemCount: jsonResponse['bank']['Benefits']['tnc'].length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15,),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index +1}. ",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font14.sp,
                                    fontWeight: FontWeight.normal),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${jsonResponse['bank']['Benefits']['tnc'][index]}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(height: 20.h,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAboutSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: greenLight,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text(
                      "Description",
                      style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${jsonResponse['bank']['about']['description']}",
                            style: TextStyle(
                                color: black,
                                fontSize: font14.sp,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: greenLight,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text(
                      "Features",
                      style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                      itemCount: jsonResponse['bank']['about']['features'].length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15,),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index +1}. ",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font14.sp,
                                    fontWeight: FontWeight.normal),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${jsonResponse['bank']['about']['features'][index]}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(height: 20.h,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildAccountSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      color: white,
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: greenLight,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text(
                      "Process",
                      style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                      itemCount: jsonResponse['bank']['acc_open']['steps'].length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15,),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index +1}. ",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font14.sp,
                                    fontWeight: FontWeight.normal),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${jsonResponse['bank']['acc_open']['steps'][index]}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(height: 20.h,),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: greenLight,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text(
                      "Document Required",
                      style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  ListView.builder(
                      itemCount: jsonResponse['bank']['acc_open']['doc_req'].length,
                      shrinkWrap: true,
                      physics: ScrollPhysics(),
                      itemBuilder: (context, index){
                        return Padding(
                          padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15,),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "${index +1}. ",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font14.sp,
                                    fontWeight: FontWeight.normal),
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  "${jsonResponse['bank']['acc_open']['doc_req'][index]}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp,
                                      fontWeight: FontWeight.normal),
                                ),
                              ),
                            ],
                          ),
                        );
                      }),
                  SizedBox(height: 20.h,),
                ],
              ),
            ),
            (jsonResponse['bank']['acc_open']['location'].toString()=="")?
            Container():
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: greenLight,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text(
                      "Locations",
                      style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${jsonResponse['bank']['acc_open']['location']}",
                            style: TextStyle(
                                color: black,
                                fontSize: font14.sp,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                ],
              ),
            ),
            (jsonResponse['bank']['acc_open']['blocked'].toString()=="")?
            Container():
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                color: greenLight,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10),
                    child: Text(
                      "Blocked Locations",
                      style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15,),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${jsonResponse['bank']['acc_open']['blocked']}",
                            style: TextStyle(
                                color: black,
                                fontSize: font14.sp,
                                fontWeight: FontWeight.normal),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.h,),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _buildFAQsSection() {
    return ListView.builder(
        itemCount: jsonResponse['bank']['faqs'].length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index){
          return Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
          color: greenLight,
          borderRadius: BorderRadius.all(Radius.circular(10)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15,),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10.h,),
                Text(
                  "Qus. ${jsonResponse['bank']['faqs'][index]['q']}",
                  style: TextStyle(
                      color: black,
                      fontSize: font14.sp,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 5.h,),
                Text(
                  "Ans. ${jsonResponse['bank']['faqs'][index]['a']}",
                  style: TextStyle(
                      color: black,
                      fontSize: font14.sp,
                      fontWeight: FontWeight.normal),
                ),
                SizedBox(height: 10.h,),
              ],
            ),
          ));
        });
  }

  _showLeadsPopup() {
    return Wrap(
      children: [
        Container(
          color: white,
          width: MediaQuery.of(context).size.width,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.asset('assets/shop_banner.png'),
              Padding(
                padding: const EdgeInsets.all(15.0),
                child: DottedBorder(
                  borderType: BorderType.RRect,
                  color: black,
                  radius: Radius.circular(10),
                  child: InkWell(
                    onTap: () {

                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: 50.h,
                      decoration: BoxDecoration(
                        color: greenLight,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: 10.w,
                          ),
                          Container(
                            height: 42.h,
                            width: 42.w,
                            decoration: BoxDecoration(
                              color: Colors.white, // border color
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Sanwal Singh",
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: font16.sp,
                                      color: black),
                                ),
                                Text(
                                  "(Authorised Advisor)",
                                  style: TextStyle(
                                      fontWeight: FontWeight.normal,
                                      fontSize: font13.sp,
                                      color: black),
                                ),
                              ],
                            ),
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.phone,
                                size: 16,
                              ),
                              SizedBox(
                                width: 5.w,
                              ),
                              Text(
                                "+91-7742526633",
                                style: TextStyle(
                                  color: black,
                                  fontSize: font14.sp,
                                ),
                              ),
                            ],
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
                margin: EdgeInsets.only(left: 20, right: 20,bottom: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: editBg,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "$sellShareText",
                    style: TextStyle(color: black, fontSize: font14.sp),
                  ),
                ),
              ),
              InkWell(
                onTap: () async{
                  showToastMessage("Click to share");

                  ByteData imagebyte = await rootBundle.load('assets/shop_banner.png');
                  final temp = await getTemporaryDirectory();
                  final path = '${temp.path}/image1.jpg';
                  File(path).writeAsBytesSync(imagebyte.buffer.asUint8List());
                  await Share.shareFiles([path], text: '$sellShareText');
                },
                child: Container(
                  margin: EdgeInsets.only(top: 0, left: 50, right: 50, bottom: 10),
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: black,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Center(
                    child: Text(
                      "Share Now",
                      style: TextStyle(fontSize: font16.sp, color: white),
                    ),
                  ),
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}
