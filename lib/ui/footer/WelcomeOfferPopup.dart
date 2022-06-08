import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Functions.dart';

class WelcomeOfferPopup extends StatefulWidget {
  final int action;

  const WelcomeOfferPopup({Key? key, required this.action}) : super(key: key);

  @override
  _WelcomeOfferPopupState createState() => _WelcomeOfferPopupState();
}

class _WelcomeOfferPopupState extends State<WelcomeOfferPopup> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>Center(
      child: Material(
        color: Colors.transparent,
        child: Wrap(
          children: [
            Container(
              margin: EdgeInsets.only(left: 30, right: 30),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                    topLeft: Radius.circular(25),
                    bottomRight: Radius.circular(25),
                    bottomLeft: Radius.circular(25),
                  ),
                  border: Border.all(color: white)),
              child: Column(
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Card(
                    margin: EdgeInsets.only(left: 10, right: 10, top: 8),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          "assets/welcome_off_banner.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Text(
                      "$rupeeSymbol 100",
                      style: TextStyle(
                          color: lightBlue,
                          fontSize: font26.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Text(
                      "Credited in your wallet as",
                      style: TextStyle(
                          color: lightBlack,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15,top: 5),
                    child: Text(
                      "WELCOME OFFER",
                      style: TextStyle(
                          color: black,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 15.0, right: 15),
                    child: Text(
                      "use this amount to recharge or pay your bills",
                      style: TextStyle(
                          color: lightBlack,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.normal),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      if (widget.action == 1) {
                        openPaymentOptions(context);
                      } else if (widget.action == 2) {
                        removeAllPages(context);
                      } else if (widget.action == 3) {
                        removeAllPages(context);
                      }
                    },
                    child: Container(
                      height: 45.h,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.only(
                          top: 20, left: 25, right: 25, bottom: 20),
                      decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                      ),
                      child: Center(
                        child: Text(
                          "OK",
                          style: TextStyle(fontSize: font16.sp, color: white),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ));
  }
}
