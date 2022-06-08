import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Functions.dart';

class BecameMerchant extends StatefulWidget {
  const BecameMerchant({Key? key}) : super(key: key);

  @override
  _BecameMerchantState createState() => _BecameMerchantState();
}

class _BecameMerchantState extends State<BecameMerchant> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 40.h,
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  "assets/becomemer.png",
                  fit: BoxFit.fill,
                  height: 210.h,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(0.0),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  "assets/becommer_2.png",
                  fit: BoxFit.fill,
                  height: 210.h,
                ),
              ),
            ),
            Text(
              "Register and Start Earning",
              style: TextStyle(
                  color: red, fontSize: font20.sp, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, right: 20, bottom: 20, top: 20),
              child: Text(
                "Note*:\nTransactions done through UPI_QR will be settled in your wallet. Please contact admin for any queries related to UPI.",
                style: TextStyle(
                    color: black,
                    fontSize: font14.sp,
                    fontWeight: FontWeight.normal),
                textAlign: TextAlign.left,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Wrap(
        children: [
          Row(
            children: [
              Spacer(),
              Container(
                height: 40.h,
                margin: EdgeInsets.only(left: 20, right: 0, top: 10, bottom: 5),
                decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(25),
                        bottomLeft: Radius.circular(25)),
                    border: Border.all(color: lightBlue)),
                child: InkWell(
                  onTap: () {
                    openMerchantGetStarted(context);
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 40.0, right: 40),
                      child: Text(
                        "REGISTER",
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
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    ));
  }
}
