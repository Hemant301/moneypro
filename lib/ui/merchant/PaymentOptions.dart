import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class PaymentOptions extends StatefulWidget {
  const PaymentOptions({Key? key}) : super(key: key);

  @override
  _PaymentOptionsState createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
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
              brightness: Brightness.light,
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
                Image.asset(
                  'assets/faq.png',
                  width: 30.w,
                  color: orange,
                ),
                SizedBox(
                  width: 20.w,
                )
              ],
            ),
            body: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 20),
                  child: Text(
                    startAccept,
                    style: TextStyle(
                        color: black,
                        fontSize: font15.sp,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 0, right: 25, bottom: 20),
                  child: Text(
                    paymentOption,
                    style: TextStyle(
                        color: lightBlue,
                        fontSize: font12.sp,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Container(
                  height: 50.h,
                  margin: EdgeInsets.only(top: 10, left: 25, right: 25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: Colors.blueAccent, width: 2.w)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          'assets/upi.jpeg',
                          height: 30.h,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              bhimUpi,
                              style: TextStyle(
                                  color: black,
                                  fontSize: font12.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              netCharge,
                              style: TextStyle(
                                  color: lightBlack,
                                  fontSize: font12.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Image.asset(
                        'assets/tick2.png',
                        height: 20.h,
                        color: lightBlue,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
                Container(
                  height: 50.h,
                  margin: EdgeInsets.only(top: 20, left: 25, right: 25),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: Colors.blueAccent, width: 2.w)),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 1,
                        child: Image.asset(
                          'assets/app_splash_logo.png',
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                        flex: 2,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Wallet",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font12.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                            Text(
                              netCharge,
                              style: TextStyle(
                                  color: lightBlack,
                                  fontSize: font12.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Image.asset(
                        'assets/tick2.png',
                        height: 20.h,
                        color: lightBlue,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 20, right: 25, bottom: 20),
                  child: Text(
                    noetAll,
                    style: TextStyle(
                        color: black,
                        fontSize: font12.sp,
                        fontWeight: FontWeight.normal),
                  ),
                ),
                Spacer(),
                InkWell(
                  onTap: () {
                    setState(() {
                      closeKeyBoard(context);
                     openQRDownload(context);
                    });
                  },
                  child: Container(
                    height: 45.h,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Center(
                      child: Text(
                        continue_.toUpperCase(),
                        style: TextStyle(fontSize: font13.sp, color: white),
                      ),
                    ),
                  ),
                ),
              ],
            ))));
  }



}
