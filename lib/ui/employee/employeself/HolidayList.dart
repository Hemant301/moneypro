import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Functions.dart';

import '../../../utils/Constants.dart';
import '../../../utils/CustomWidgets.dart';
import '../../models/Holidays.dart';

class HolidayList extends StatefulWidget {
  const HolidayList({Key? key}) : super(key: key);

  @override
  State<HolidayList> createState() => _HolidayListState();
}

class _HolidayListState extends State<HolidayList> {
  var screen = "Holiday List";

  var loading = false;

  List<Holidays> holidays = [];

  @override
  void initState() {
    super.initState();
    setHolidayData();
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
                    : ListView(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 15, bottom: 15),
                            child: Text(
                              "All Holidays",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font18.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          ListView.builder(
                              itemCount: holidays.length,
                              shrinkWrap: true,
                              physics: ScrollPhysics(),
                              itemBuilder: (context, index) {
                                return Container(
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  margin: EdgeInsets.only(
                                      left: 20, right: 20, top: 10),
                                  child: Padding(
                                    padding: const EdgeInsets.all(12.0),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                            height: 36.h,
                                            width: 36.w,
                                            decoration: BoxDecoration(
                                              color: green,
                                              // border color
                                              shape: BoxShape.circle,
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(7.0),
                                              child: Image.asset(
                                                'assets/holidays.png',
                                                color: white,
                                              ),
                                            )),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 5.0, left: 10, right: 10),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "${holidays[index].holidayName}",
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: font14.sp),
                                                  textAlign: TextAlign.start,
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                Row(
                                                  children: [
                                                    Text(
                                                      "${holidays[index].date}",
                                                      style: TextStyle(
                                                          color: lightBlack,
                                                          fontSize: font14.sp),
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                    Spacer(),
                                                    Text(
                                                      "${holidays[index].holidayType}",
                                                      style: TextStyle(
                                                          color: black,
                                                          fontSize: font14.sp),
                                                      textAlign:
                                                          TextAlign.start,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                          SizedBox(
                            height: 20.h,
                          ),
                        ],
                      ))));
  }

  setHolidayData() {
    setState(() {
      loading = true;
    });

    holidays.insert(
        0,
        new Holidays(
            id: "1",
            date: "15 Apr 2022",
            holidayType: "Full Day",
            holidayName: "Good Friday"));
    holidays.insert(
        1,
        new Holidays(
            id: "2",
            date: "15 Apr 2022",
            holidayType: "Full Day",
            holidayName: "Bengali New Year's Day (Nababarsha)"));
    holidays.insert(
        2,
        new Holidays(
            id: "3",
            date: "03 May 2022",
            holidayType: "Full Day",
            holidayName: "Eid-Ul-Fitr"));
    holidays.insert(
        3,
        new Holidays(
            id: "4",
            date: "10 July 2022",
            holidayType: "Full Day",
            holidayName: "Bakri Id"));
    holidays.insert(
        4,
        new Holidays(
            id: "5",
            date: "09 Aug 2022",
            holidayType: "Full Day",
            holidayName: "Muharram"));
    holidays.insert(
        5,
        new Holidays(
            id: "6",
            date: "15 Aug 2022",
            holidayType: "Full Day",
            holidayName: "Independence Day"));
    holidays.insert(
        6,
        new Holidays(
            id: "7",
            date: "02 Oct 2022",
            holidayType: "Full Day",
            holidayName: "Durga Puja Saptami"));
    holidays.insert(
        7,
        new Holidays(
            id: "8",
            date: "03 Oct 2022",
            holidayType: "Full Day",
            holidayName: "Durga Puja Astami"));
    holidays.insert(
        8,
        new Holidays(
            id: "9",
            date: "04 Oct 2022",
            holidayType: "Full Day",
            holidayName: "Durga Puja Nabami"));
    holidays.insert(
        9,
        new Holidays(
            id: "10",
            date: "05 Oct 2022",
            holidayType: "Full Day",
            holidayName: "Durga Puja Dasami"));
    holidays.insert(
        10,
        new Holidays(
            id: "11",
            date: "24 Oct 2022",
            holidayType: "Full Day",
            holidayName: "Kali Puja"));
    holidays.insert(
        11,
        new Holidays(
            id: "12",
            date: "26 Oct 2022",
            holidayType: "Half Day",
            holidayName: "Bhai Dhuj"));
    holidays.insert(
        12,
        new Holidays(
            id: "13",
            date: "08 Nov 2022",
            holidayType: "Full Day",
            holidayName: "Birth Day og Guru Nanak"));
    holidays.insert(
        13,
        new Holidays(
            id: "14",
            date: "25 Dec 2022",
            holidayType: "Full Day",
            holidayName: "Christmas Day"));
    holidays.insert(
        14,
        new Holidays(
            id: "15",
            date: "26 Jan 2023",
            holidayType: "Full Day",
            holidayName: "Republic Day"));
    holidays.insert(
        15,
        new Holidays(
            id: "16",
            date: "05 Feb 2023",
            holidayType: "Full Day",
            holidayName: "**Saraswati Puja [Sree Panchami]"));
    holidays.insert(
        16,
        new Holidays(
            id: "17",
            date: "18 Mar 2023",
            holidayType: "Full Day",
            holidayName: "Diljotra"));

    printMessage(screen, "Holiday list : ${holidays.length}");

    setState(() {
      loading = false;
    });
  }
}
