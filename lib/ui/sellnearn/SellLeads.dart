import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/Constants.dart';
import '../../utils/CustomWidgets.dart';

class SellLeads extends StatefulWidget {
  const SellLeads({Key? key}) : super(key: key);

  @override
  State<SellLeads> createState() => _SellLeadsState();
}

class _SellLeadsState extends State<SellLeads> {
  var selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
            child: Scaffold(
                appBar: appBarHome(context, "", 24.0.w),
                backgroundColor: boxBg,
                body: SingleChildScrollView(
                    child: Column(children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 0),
                          decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 15, bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "1",
                                  style: TextStyle(
                                      fontSize: font18.sp,
                                      color: white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "TOTAL\nLEADS",
                                  style: TextStyle(
                                      fontSize: font16.sp, color: white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 0),
                          decoration: BoxDecoration(
                            color: homeOrage,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 15, bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "1",
                                  style: TextStyle(
                                      fontSize: font18.sp,
                                      color: white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "LEADS\nIN PROCESS",
                                  style: TextStyle(
                                      fontSize: font16.sp, color: white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                      Expanded(
                        child: Container(
                          margin: EdgeInsets.only(
                              top: 20, left: 10, right: 10, bottom: 0),
                          decoration: BoxDecoration(
                            color: black,
                            borderRadius: BorderRadius.all(Radius.circular(25)),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 15, bottom: 15),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "0",
                                  style: TextStyle(
                                      fontSize: font18.sp,
                                      color: white,
                                      fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  height: 5.h,
                                ),
                                Text(
                                  "LEADS\nCOMPLETED",
                                  style: TextStyle(
                                      fontSize: font16.sp, color: white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                        flex: 1,
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Container(
                    height: 36.h,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedIndex = 1;
                                  });
                                },
                                child: Container(
                                  margin: EdgeInsets.only(
                                      top: 0, left: 10, right: 0, bottom: 0),
                                  decoration: BoxDecoration(
                                      color: white,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(25)),
                                      border: Border.all(
                                          color: (selectedIndex == 1)
                                              ? lightBlue
                                              : gray)),
                                  child: Center(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          left: 15.0,
                                          right: 15,
                                          top: 4,
                                          bottom: 4),
                                      child: Text(
                                        "In Process",
                                        style: TextStyle(
                                            fontSize: font14.sp,
                                            color: (selectedIndex == 1)
                                                ? lightBlue
                                                : black),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = 2;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 0, left: 10, right: 0, bottom: 0),
                                    decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        border: Border.all(
                                            color: (selectedIndex == 2)
                                                ? lightBlue
                                                : gray)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 15,
                                            top: 4,
                                            bottom: 4),
                                        child: Text(
                                          "Completed",
                                          style: TextStyle(
                                              fontSize: font14.sp,
                                              color: (selectedIndex == 2)
                                                  ? lightBlue
                                                  : black),
                                        ),
                                      ),
                                    ),
                                  )),
                              InkWell(
                                  onTap: () {
                                    setState(() {
                                      selectedIndex = 3;
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(
                                        top: 0, left: 10, right: 0, bottom: 0),
                                    decoration: BoxDecoration(
                                        color: white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(25)),
                                        border: Border.all(
                                            color: (selectedIndex == 3)
                                                ? lightBlue
                                                : gray)),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 15,
                                            top: 4,
                                            bottom: 4),
                                        child: Text(
                                          "Rejected",
                                          style: TextStyle(
                                              fontSize: font14.sp,
                                              color: (selectedIndex == 3)
                                                  ? lightBlue
                                                  : black),
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ),
                        Container(
                          height: 40.h,
                          width: 40.w,
                          margin: EdgeInsets.only(
                              top: 0, left: 10, right: 15, bottom: 0),
                          decoration: BoxDecoration(
                              color: white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                              border: Border.all(color: lightBlue)),
                          child: Icon(
                            Icons.filter_list_alt,
                            color: lightBlue,
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        top: 15, left: 10, right: 10, bottom: 0),
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10, top: 15, bottom: 15),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Row(
                            children: [
                              Container(
                                height: 40.h,
                                width: 50.w,
                                margin: EdgeInsets.only(
                                    top: 0, left: 10, right: 15, bottom: 0),
                                decoration: BoxDecoration(
                                  color: greenLight,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Image.asset(
                                    'assets/ic_dummy_user.png',
                                    color: orange,
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Rahul Chakarboarty",
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font16.sp,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  Text(
                                    "8296754313",
                                    style: TextStyle(
                                        color: lightBlack,
                                        fontSize: font14.sp,
                                        fontWeight: FontWeight.w600),
                                  )
                                ],
                              )),
                              Container(
                                margin: EdgeInsets.only(
                                    top: 0, left: 10, right: 0, bottom: 0),
                                decoration: BoxDecoration(
                                    color: white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(25)),
                                    border: Border.all(color: black)),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0,
                                        right: 10,
                                        top: 4,
                                        bottom: 4),
                                    child: Text(
                                      "10-Apr-2022",
                                      style: TextStyle(
                                          fontSize: font12.sp, color: black),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 0),
                            decoration: BoxDecoration(
                              color: greenLight,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Lead Added",
                                    style:
                                    TextStyle(color: homeOrage, fontSize: font16.sp),
                                  ),
                                  SizedBox(height: 10.h,),
                                  Text(
                                    "$sellLeadText",
                                    style:
                                        TextStyle(color: black, fontSize: font14.sp),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ])))));
  }
}
