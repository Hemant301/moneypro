import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/MerchantStart.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class MerchantGetStarted extends StatefulWidget {
  const MerchantGetStarted({Key? key}) : super(key: key);

  @override
  _MerchantGetStartedState createState() => _MerchantGetStartedState();
}

class _MerchantGetStartedState extends State<MerchantGetStarted> {
  var screen = "Merchant Get Started";
  List<MerchantStart> list = [];
  var loading = false;

  late PageController _pageController;

  var showButton = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    if (mounted) {
      _pageController = PageController();
    }
    setData();
  }

  setData() {
    MerchantStart m1 = new MerchantStart(
        image: "assets/mob1.png",
        title: "Fastest way to grow your business starts here",
        subTitle: "");
    MerchantStart m2 = new MerchantStart(
        image: "assets/mob2.png",
        title: "List your store",
        subTitle:
            "Create your online store in a few clicks and be seen by lakhs of customers near you.");
    MerchantStart m3 = new MerchantStart(
        image: "assets/mob3.png",
        title: "List your store",
        subTitle:
            "Create your online store in a few clicks and be seen by lakhs of customers near you.");
    list.insert(0, m1);
    list.insert(1, m2);
    list.insert(2, m3);

    setState(() {
      loading = false;
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>WillPopScope(
      onWillPop: () async {
        printMessage(screen, "Mobile back pressed");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return NoExitDialog();
            });
        return false;
      },
      child: SafeArea(
          child: Scaffold(
        backgroundColor: white,
        body: (loading)
            ? Center(
                child: circularProgressLoading(40.0),
              )
            : Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: PageView.builder(
                  controller: _pageController,
                  scrollDirection: Axis.horizontal,
                  itemCount: list.length,
                  onPageChanged: (index) {
                    setState(() {
                      if (index == 2) {
                        setState(() {
                          showButton = true;
                        });
                      } else {
                        setState(() {
                          showButton = false;
                        });
                      }
                    });
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(
                          left: 6.0, right: 6, top: 5, bottom: 5),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 120.h,
                          ),
                          Image.asset(
                            list[index].image,
                            height: 250.h,
                          ),
                          SizedBox(
                            height: 60.h,
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 30.0, right: 30),
                            child: Text(
                              list[index].title,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16.sp,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 30.0, right: 30, top: 20),
                            child: Text(
                              list[index].subTitle,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font14.sp,
                                  fontWeight: FontWeight.normal),
                              textAlign: TextAlign.center,
                            ),
                          ),
                          /*(showButton)
                              ? Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 40,
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 100, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: lightBlue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      border: Border.all(color: lightBlue)),
                                  child: InkWell(
                                    onTap: () {
                                      openBusinessDetails(context);
                                    },
                                    child: Center(
                                      child: Text(
                                        "$getStarted",
                                        style: TextStyle(
                                          color: white,
                                          fontSize: font14,
                                        ),
                                      ),
                                    ),
                                  ),
                                )
                              : Container(),*/
                        ],
                      ),
                    );
                  },
                ),
              ),
        bottomNavigationBar: Container(
          height: (showButton) ? 95.h : 50.h,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0, top: 5),
                child: Center(
                  child: indicatorsMerchant(_pageController, list.length),
                ),
              ),
              (showButton)
                  ? Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40.h,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 10, bottom: 0),
                      decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          border: Border.all(color: lightBlue)),
                      child: InkWell(
                        onTap: () {
                          openBusinessDetails(context);
                        },
                        child: Center(
                          child: Text(
                            "$getStarted",
                            style: TextStyle(
                              color: white,
                              fontSize: font14.sp,
                            ),
                          ),
                        ),
                      ),
                    )
                  : Container(
                      height: 1.h,
                    )
            ],
          ),
        ),
      )),
    ));
  }
}
