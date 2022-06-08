import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class QRDownload extends StatefulWidget {
  const QRDownload({Key? key}) : super(key: key);

  @override
  _QRDownloadState createState() => _QRDownloadState();
}

class _QRDownloadState extends State<QRDownload> {
  var screen = "QR Download";

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
            SizedBox(
              height: 80.h,
            ),
            Image.asset(
              'assets/img4.png',
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 25.0, top: 40, right: 25),
              child: Center(
                child: Text(
                  yahYouCan,
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 60.0, top: 20, right: 60),
              child: Center(
                child: Text(
                  yourMonthly,
                  style: TextStyle(
                      color: lightBlack,
                      fontSize: font12.sp,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            Spacer(),
            InkWell(
              onTap: () {
                setState(() {
                  closeKeyBoard(context);
                   openViewQRCode(context,1);
                });
              },
              child: Container(
                height: 45.h,
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(top: 30, left: 30, right: 30, bottom: 30),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    downloadQRUPI.toUpperCase(),
                    style: TextStyle(fontSize: font13.sp, color: white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
