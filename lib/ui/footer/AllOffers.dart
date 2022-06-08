import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';

class AllOffers extends StatefulWidget {
  const AllOffers({Key? key}) : super(key: key);

  @override
  _AllOffersState createState() => _AllOffersState();
}

class _AllOffersState extends State<AllOffers> {

  var screen = "All offers";


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
            backgroundColor: white,
            appBar: appBarHome(context, "", 24.0.w),
            body: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                  appSelectedBanner(context, "recharge_banner.png", 150.0.h),
                  _buildWelcomOffer(),
                ])))));
  }

  _buildWelcomOffer() {
    return InkWell(
      onTap: () {
        showWelcomeTnC();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(left: 15, right: 15, top: 10),
        decoration: BoxDecoration(
          color: editBg,
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(100.0),
                child: Image.asset(
                  "assets/welcome_offer.jpg",
                  fit: BoxFit.fill,
                  height: 90.h,
                ),
              ),
              SizedBox(
                width: 10.w,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Welcome offer",
                      style: TextStyle(
                          color: green,
                          fontWeight: FontWeight.bold,
                          fontSize: font18.sp),
                    ),
                    SizedBox(
                      height: 10.h,
                    ),
                    Text(
                      "Rs.100 will be credited to main wallet on successful completion of your profile.",
                      style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w300,
                          fontSize: font14.sp),
                    ),SizedBox(
                      height: 5.h,
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
              Icon(Icons.arrow_forward_ios_rounded, size: 16),
              SizedBox(
                width: 5.w,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showWelcomeTnC() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25),
                      ),
                      border: Border.all(color: white)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20, bottom: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "$termNCondition",
                          style: TextStyle(color: black, fontSize: font16.sp, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 10.h,),
                        Row(
                          children: [
                            Text(
                              "1. ",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                            Text(
                              "$wel_1",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "2. ",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                            Expanded(
                              child: Text(
                                "$wel_2",
                                style: TextStyle(color: black, fontSize: font14.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "3. ",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                            Expanded(
                              child: Text(
                                "$wel_3",
                                style: TextStyle(color: black, fontSize: font14.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "4. ",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                            Expanded(
                              child: Text(
                                "$wel_4",
                                style: TextStyle(color: black, fontSize: font14.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "5. ",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                            Expanded(
                              child: Text(
                                "$wel_5",
                                style: TextStyle(color: black, fontSize: font14.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "6. ",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                            Expanded(
                              child: Text(
                                "$wel_6",
                                style: TextStyle(color: black, fontSize: font14.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "7. ",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                            Expanded(
                              child: Text(
                                "$wel_7",
                                style: TextStyle(color: black, fontSize: font14.sp),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 5.h,),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "8. ",
                              style: TextStyle(color: black, fontSize: font14.sp),
                            ),
                            Expanded(
                              child: Text(
                                "$wel_8",
                                style: TextStyle(color: black, fontSize: font14.sp),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ));
  }
}
