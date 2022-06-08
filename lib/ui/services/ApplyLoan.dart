import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';

class ApplyLoan extends StatefulWidget {
  const ApplyLoan({Key? key}) : super(key: key);

  @override
  _ApplyLoanState createState() => _ApplyLoanState();
}

class _ApplyLoanState extends State<ApplyLoan> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              backgroundColor: white,
              appBar: appBarHome(context, "", 24.0.w),
              body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Card(
                      margin: EdgeInsets.only(left: 10, right: 10, top: 8),
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 210.h,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(15.0),
                          child: Image.asset(
                            "assets/applybanner12.png",
                            fit: BoxFit.fill,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                      child: Text(
                        "Currently you are not eligible for Instant Loan",
                        style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                        ),
                      ),
                    ),
                    Card(
                      elevation: 15,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 15),
                      child: Container(
                        padding: EdgeInsets.only(
                            left: 15, top: 15, right: 15, bottom: 15),
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "How can you get a loan?",
                              style: TextStyle(color: black, fontSize: font16.sp),
                            ),
                            Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 70.h,
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 10,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                          color: boxBg,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          border: Border.all(
                                            color: gray,
                                          )),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, right: 12),
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              "Collect Max amount using Qwikpe.",
                                              style: TextStyle(
                                                  color: black, fontSize: font14.sp),
                                            ),
                                          ),
                                        ),
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      height: 70.h,
                                      width: MediaQuery.of(context).size.width,
                                      margin: EdgeInsets.only(
                                          left: 5,
                                          right: 5,
                                          top: 10,
                                          bottom: 10),
                                      decoration: BoxDecoration(
                                          color: boxBg,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                          border: Border.all(
                                            color: gray,
                                          )),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 12.0, right: 12),
                                          child: FittedBox(
                                            fit: BoxFit.contain,
                                            child: Text(
                                              "Instant Business Loan with easy payment options",
                                              style: TextStyle(
                                                  color: black, fontSize: font14.sp),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ))
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                        _buildBottomSection(),
                  ])),
            )));
  }

  _buildBottomSection() {
    return Wrap(
      children: [
        Container(
          decoration: BoxDecoration(
              color: boxBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
              border: Border.all(
                color: gray,
              )),
          margin: EdgeInsets.only(left: 10, right: 10, bottom: 20),
          width: MediaQuery.of(context).size.width,
          child: Row(
            children: [
              ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image.asset(
                    'assets/loan_bottom.png',
                    height: 120.h,
                  )),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        "We will analysing your information",
                        style: TextStyle(color: lightBlue, fontSize: font18.sp),
                      ),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, right: 10),
                      child: Text(
                        "We will keep you posted about your loan Eligibility",
                        style: TextStyle(color: black, fontSize: font12.sp),
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
        /*InkWell(
          onTap: () {
            setState(() {});
          },
          child: Container(
            height: 45,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
            decoration: BoxDecoration(
              color: lightBlue,
              borderRadius: BorderRadius.all(Radius.circular(25)),
            ),
            child: Center(
              child: Text(
                "Notify me when Loan is Unlock",
                style: TextStyle(fontSize: font16, color: white),
              ),
            ),
          ),
        )*/
      ],
    );
  }
}
