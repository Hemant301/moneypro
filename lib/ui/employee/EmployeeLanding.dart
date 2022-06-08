import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class EmployeeLanding extends StatefulWidget {
  const EmployeeLanding({Key? key}) : super(key: key);

  @override
  _EmployeeLandingState createState() => _EmployeeLandingState();
}

class _EmployeeLandingState extends State<EmployeeLanding> {

  var screen = "Emplyee Landing";


  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
            backgroundColor: boxBg,
            appBar: appBarHome(context, "", 24.0.w),
            body: Column(
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
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(15.0),
                        child: Image.asset(
                          "assets/emp_banner.png",
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                      flex: 1,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15, bottom: 15),
                        child: SingleChildScrollView(
                    child: Column(
                        children: [
                          InkWell(
                            onTap: (){
                              openEmpMerchantBusinessDetails(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.all(Radius.circular(15)),),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 50.h,
                                         width: 50.w,
                                        decoration: BoxDecoration(
                                          color: lightBlue, // border color
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                            'assets/m_onboard.png',
                                            color: white,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:10.0,left: 10,right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Merchant OnBoarding",
                                              style: TextStyle(color: black, fontSize: font14.sp),
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Add new UPI QR Merchants",
                                              style: TextStyle(color: lightBlack, fontSize: font14.sp),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0, right: 5, left: 5),
                                      child: Icon(Icons.arrow_forward_ios, color: lightBlue,size: 12,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h,),
                          InkWell(
                            onTap: (){
                              openMerchantList(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.all(Radius.circular(15)),),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 50.h,
                                         width: 50.w,
                                        decoration: BoxDecoration(
                                          color: lightBlue, // border color
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                            'assets/mechntlist.png',
                                            color: white,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:10.0,left: 10,right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Merchant List",
                                              style: TextStyle(color: black, fontSize: font14.sp),
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Manage all your merchants",
                                              style: TextStyle(color: lightBlack, fontSize: font14.sp),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0, right: 5, left: 5),
                                      child: Icon(Icons.arrow_forward_ios, color: lightBlue,size: 12,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h,),
                          InkWell(
                            onTap: (){
                              openLoanCollection(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.all(Radius.circular(15)),),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 50.h,
                                         width: 50.w,
                                        decoration: BoxDecoration(
                                          color: lightBlue, // border color
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                            'assets/emi_cal.png',
                                            color: white,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:10.0,left: 10,right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "EMI Collections",
                                              style: TextStyle(color: black, fontSize: font14.sp),
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Collect EMI's from Borrowers",
                                              style: TextStyle(color: lightBlack, fontSize: font14.sp),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0, right: 5, left: 5),
                                      child: Icon(Icons.arrow_forward_ios, color: lightBlue,size: 12,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h,),
                          InkWell(
                            onTap: (){
                              openEMICalculator(context);
                            },
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.all(Radius.circular(15)),),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 50.h,
                                         width: 50.w,
                                        decoration: BoxDecoration(
                                          color: lightBlue, // border color
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                            'assets/emi_calc.png',
                                            color: white,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:10.0,left: 10,right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "EMI Calculate",
                                              style: TextStyle(color: black, fontSize: font14.sp),
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Calculate Daily,Monthly and Weekly EMI",
                                              style: TextStyle(color: lightBlack, fontSize: font14.sp),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0, right: 5, left: 5),
                                      child: Icon(Icons.arrow_forward_ios, color: lightBlue,size: 12,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 15.h,),
                          InkWell(
                            onTap: (){openEmployeSelfService(context);},
                            child: Container(
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                color: white,
                                borderRadius: BorderRadius.all(Radius.circular(15)),),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        height: 50.h,
                                         width: 50.w,
                                        decoration: BoxDecoration(
                                          color: lightBlue, // border color
                                          shape: BoxShape.circle,
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Image.asset(
                                            'assets/emp_self_resume.png',
                                            color: white,
                                          ),
                                        )),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(top:10.0,left: 10,right: 10),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              "Employee Self Service",
                                              style: TextStyle(color: black, fontSize: font14.sp),
                                              textAlign: TextAlign.start,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              "Manage Attendance, Leave and payslip",
                                              style: TextStyle(color: lightBlack, fontSize: font14.sp),
                                              textAlign: TextAlign.start,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 20.0, right: 5, left: 5),
                                      child: Icon(Icons.arrow_forward_ios, color: lightBlue,size: 12,),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                    ),
                  ),
                      ))

                ]))));
  }
}
