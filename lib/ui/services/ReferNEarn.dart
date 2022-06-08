import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:share_plus/share_plus.dart';

import '../../utils/CustomWidgets.dart';

class ReferNEarn extends StatefulWidget {
  const ReferNEarn({Key? key}) : super(key: key);

  @override
  State<ReferNEarn> createState() => _ReferNEarnState();
}

class _ReferNEarnState extends State<ReferNEarn> {
  var screen = "Refer & Earn";

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              backgroundColor: white,
              body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset('assets/refer_n_earn_bg.png'),
                      SizedBox(
                        height: 15.h,
                      ),
                      Center(
                        child: Text(
                          "Referral Code",
                          style: TextStyle(
                              color: black,
                              fontSize: font16.sp,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 5.h,
                      ),
                      Center(
                        child: Text(
                          "CODE@2001",
                          style: TextStyle(
                              color: homeOrage,
                              fontSize: font20.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 5),
                        child: Text(
                          "Terms & Conditions",
                          style: TextStyle(
                            color: black,
                            fontSize: font14.sp,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 5, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1. ",
                              style: TextStyle(
                                color: black,
                                fontSize: font12.sp,
                              ),
                            ),
                            Expanded(
                              flex:1,
                              child: Text(
                                "Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum'",
                                style: TextStyle(
                                  color: lightBlack,
                                  fontSize: font12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 5, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "2. ",
                              style: TextStyle(
                                color: black,
                                fontSize: font12.sp,
                              ),
                            ),
                            Expanded(
                              flex:1,
                              child: Text(
                                "Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum'",
                                style: TextStyle(
                                  color: lightBlack,
                                  fontSize: font12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 5, right: 20),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "3. ",
                              style: TextStyle(
                                color: black,
                                fontSize: font12.sp,
                              ),
                            ),
                            Expanded(
                              flex:1,
                              child: Text(
                                "Many desktop publishing packages and web page editors now use Lorem Ipsum as their default model text, and a search for 'lorem ipsum'",
                                style: TextStyle(
                                  color: lightBlack,
                                  fontSize: font12.sp,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]),
              ),
              bottomNavigationBar: Wrap(
                children: [
                  Center(
                    child: InkWell(
                      onTap: () {
                        var msg =
                            "Hi! Join Moneypro app & earn more than 10% extra. It is trusted by 2 Lakh+ people across the country. Moneypro app is the most reliable and highly paying discount. Download Moneypro app now.\nTap the link\n\nhttps://play.google.com/store/apps/details?id=com.moneyproapp.\n\nUse my referral code for signup: CODE@2001";
                        Share.share('$msg');
                      },
                      child: Container(
                        height: 40.h,
                        width: 120.w,
                        decoration: BoxDecoration(
                            color: homeOrage,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                            border: Border.all(color: homeOrage)),
                        margin: EdgeInsets.only(bottom: 10),
                        child: Center(
                          child: Text(
                            "Refer Now",
                            style: TextStyle(
                              color: white,
                              fontSize: font14.sp,
                            ),
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
