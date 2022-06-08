import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class InvestorOnboarding extends StatefulWidget {
  const InvestorOnboarding({Key? key}) : super(key: key);

  @override
  _InvestorOnboardingState createState() => _InvestorOnboardingState();
}

class _InvestorOnboardingState extends State<InvestorOnboarding> {

  var screen = "My Investment";

  var checkedValue = false;

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
        builder: () =>SafeArea(
        child: Scaffold(
          backgroundColor: white,
          appBar: appBarHome(context, "assets/lendbox_head.png", 60.0.w),
          body: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                appSelectedBanner(context, "invest_home.png", 190.0.h),
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
                  padding: const EdgeInsets.only(left: 25.0, top: 30, bottom: 15),
                  child: Text(
                    keyTrmsNCB,
                    style: TextStyle(
                        color: black,
                        fontSize: font14.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 10, right: 15),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/bullets.png",
                        height: 15.h,
                        color: lightBlue,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          note9,
                          style: TextStyle(color: black, fontSize: font13.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8, right: 15),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/bullets.png",
                        height: 15.h,
                        color: lightBlue,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          note10,
                          style: TextStyle(color: black, fontSize: font13.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8, right: 15),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/bullets.png",
                        height: 15.h,
                        color: lightBlue,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          note11,
                          style: TextStyle(color: black, fontSize: font13.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8, right: 15),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/bullets.png",
                        height: 15.h,
                        color: lightBlue,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          note12,
                          style: TextStyle(color: black, fontSize: font13.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8, right: 15),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/bullets.png",
                        height: 15.h,
                        color: lightBlue,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          note13,
                          style: TextStyle(color: black, fontSize: font13.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 8, right: 15),
                  child: Row(
                    children: [
                      Image.asset(
                        "assets/bullets.png",
                        height: 15.h,
                        color: lightBlue,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 1,
                        child: Text(
                          note14,
                          style: TextStyle(color: black, fontSize: font13.sp),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20.h,
                ),
              ],
            ),
          ),
          bottomNavigationBar: Wrap(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    channelPartner,
                    style: TextStyle(color: black, fontSize: font13.sp),
                  ),
                  SizedBox(width: 4.w,),
                  Image.asset(
                    'assets/app_splash_logo.png',
                    width: 80.w,
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                      value: checkedValue,
                      onChanged: (val) {
                        setState(() {
                          closeKeyBoard(context);
                          checkedValue = val!;
                        });
                      }),
                  Text(
                    iAgree,
                    style: TextStyle(fontSize: font13.sp, color: black),
                  ),
                ],
              ),
              InkWell(
                onTap: () {
                  if (checkedValue) {
                    openInvestorMobileVerify(context);
                  } else {
                    showToastMessage("Accept terms & conditions");
                  }
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  margin:
                  EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        accept.toUpperCase(),
                        style: TextStyle(fontSize: font13.sp, color: white),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        )));
  }
}
