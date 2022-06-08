import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../../../utils/Apis.dart';

class EmployeSelfService extends StatefulWidget {
  const EmployeSelfService({Key? key}) : super(key: key);

  @override
  State<EmployeSelfService> createState() => _EmployeSelfServiceState();
}

class _EmployeSelfServiceState extends State<EmployeSelfService> {
  var screen = "Emp Self Care";

  var loading = false;

  var profilePic = "";

  var fullName = "";

  @override
  void initState() {
    super.initState();
    getUserProfilePic();
    getUserDetails();
  }

  getUserDetails() async {
    var fname = await getFirstName();
    var lname = await getLastName();

    setState(() {
      fullName = "$fname $lname";
    });

    printMessage(screen, "First Name : $fname, Last Name : $lname");
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
            child: Scaffold(
                backgroundColor: boxBg,
                appBar: appBarHome(context, "", 24.0.w),
                body: (loading)
                    ? Center(
                        child: circularProgressLoading(40.0),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                            Container(
                              width: MediaQuery.of(context).size.width,
                              child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Column(
                                    children: [
                                      SizedBox(height: 25.h,),
                                      (profilePic.toString() == "")
                                          ? Image.asset(
                                              'assets/profile.png',
                                              height: 80.h,
                                            )
                                          : Container(
                                              height: 80.h,
                                              width: 80.w,
                                              decoration: BoxDecoration(
                                                color: white, // border color
                                                shape: BoxShape.circle,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(0.0),
                                                child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          16.0),
                                                  child: Image.network(
                                                      profilePic,
                                                      height: 40.h,
                                                      fit: BoxFit.fill),
                                                ),
                                              )),
                                      SizedBox(height: 10.h,),
                                      Text(
                                        "Hi,",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: font16.sp,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(height: 10.h,),
                                      Text(
                                        fullName,
                                        style: TextStyle(
                                            color: black,
                                            fontSize: font18.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: 0.h,),
                                    ],
                                  )),
                            ),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0,
                                      right: 20,
                                      top: 15,
                                      bottom: 15),
                                  child: SingleChildScrollView(
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            openEmpMarkAttendance(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      height: 50.h,
                                                      width: 50.w,
                                                      decoration: BoxDecoration(
                                                        color: lightBlue,
                                                        // border color
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Image.asset(
                                                          'assets/mark_attanc.png',
                                                          color: white,
                                                        ),
                                                      )),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              left: 10,
                                                              right: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Mark Attendance",
                                                            style: TextStyle(
                                                                color: black,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text(
                                                            "Mark your daily attendance.",
                                                            style: TextStyle(
                                                                color:
                                                                    lightBlack,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            right: 5,
                                                            left: 5),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: lightBlue,
                                                      size: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            openEmpViewAttandance(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      height: 50.h,
                                                      width: 50.w,
                                                      decoration: BoxDecoration(
                                                        color: lightBlue,
                                                        // border color
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Image.asset(
                                                          'assets/view_attanc.png',
                                                          color: white,
                                                        ),
                                                      )),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              left: 10,
                                                              right: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "View Attendance",
                                                            style: TextStyle(
                                                                color: black,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text(
                                                            "Check all attendance and leave in calendar",
                                                            style: TextStyle(
                                                                color:
                                                                    lightBlack,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            right: 5,
                                                            left: 5),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: lightBlue,
                                                      size: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            openHolidayList(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      height: 50.h,
                                                      width: 50.w,
                                                      decoration: BoxDecoration(
                                                        color: lightBlue,
                                                        // border color
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Image.asset(
                                                          'assets/holidays.png',
                                                          color: white,
                                                        ),
                                                      )),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              left: 10,
                                                              right: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Holiday List",
                                                            style: TextStyle(
                                                                color: black,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text(
                                                            "Check your Holidays list for current FY",
                                                            style: TextStyle(
                                                                color:
                                                                    lightBlack,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            right: 5,
                                                            left: 5),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: lightBlue,
                                                      size: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        InkWell(
                                          onTap: () {
                                            openEmpManageLeave(context);
                                          },
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      height: 50.h,
                                                      width: 50.w,
                                                      decoration: BoxDecoration(
                                                        color: lightBlue,
                                                        // border color
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Image.asset(
                                                          'assets/manage_leave.png',
                                                          color: white,
                                                        ),
                                                      )),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              left: 10,
                                                              right: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Manage Leave",
                                                            style: TextStyle(
                                                                color: black,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text(
                                                            "Apply leave and check Status",
                                                            style: TextStyle(
                                                                color:
                                                                    lightBlack,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            right: 5,
                                                            left: 5),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: lightBlue,
                                                      size: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      height: 50.h,
                                                      width: 50.w,
                                                      decoration: BoxDecoration(
                                                        color: lightBlue,
                                                        // border color
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Image.asset(
                                                          'assets/remib.png',
                                                          color: white,
                                                        ),
                                                      )),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              left: 10,
                                                              right: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Reimbursement",
                                                            style: TextStyle(
                                                                color: black,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text(
                                                            "Apply all allowances and check status",
                                                            style: TextStyle(
                                                                color:
                                                                    lightBlack,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            right: 5,
                                                            left: 5),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: lightBlue,
                                                      size: 12,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 15.h,
                                        ),
                                        InkWell(
                                          onTap: () {},
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                .size
                                                .width,
                                            decoration: BoxDecoration(
                                              color: white,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(15)),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                      height: 50.h,
                                                      width: 50.w,
                                                      decoration: BoxDecoration(
                                                        color: lightBlue,
                                                        // border color
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12.0),
                                                        child: Image.asset(
                                                          'assets/payslip.png',
                                                          color: white,
                                                        ),
                                                      )),
                                                  Expanded(
                                                    flex: 1,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              top: 10.0,
                                                              left: 10,
                                                              right: 10),
                                                      child: Column(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Text(
                                                            "Download PaySlip ",
                                                            style: TextStyle(
                                                                color: black,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            maxLines: 2,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                          Text(
                                                            "Download your salary slip month wise.",
                                                            style: TextStyle(
                                                                color:
                                                                    lightBlack,
                                                                fontSize:
                                                                    font14.sp),
                                                            textAlign:
                                                                TextAlign.start,
                                                            overflow:
                                                                TextOverflow
                                                                    .ellipsis,
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            top: 20.0,
                                                            right: 5,
                                                            left: 5),
                                                    child: Icon(
                                                      Icons.arrow_forward_ios,
                                                      color: lightBlue,
                                                      size: 12,
                                                    ),
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

  Future getUserProfilePic() async {
    setState(() {
      loading = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "token": "$token",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(getUserProfileAPI),
        body: jsonEncode(body), headers: headers);

    setState(() {
      var statusCode = response.statusCode;
      loading = false;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Profile Image : ${data}");
        if (data['status'].toString() == "1") {
          var img = data['selfi'].toString();
          var picId = data['id'].toString();
          if (img.toString() != "" && img.toString() != "null") {
            profilePic = "$profilePicBase$img";
            var profilePicId = picId;
          }
        }
      }
    });

    //createWalletList();
  }
}
