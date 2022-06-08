import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class AddTeamIntro extends StatefulWidget {
  const AddTeamIntro({Key? key}) : super(key: key);

  @override
  _AddTeamIntroState createState() => _AddTeamIntroState();
}

class _AddTeamIntroState extends State<AddTeamIntro> {
  var screen = "Team Intro";

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(context, "", 24.0),
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
            child: Image.asset('assets/store_2.png'),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 25),
            child: Text(
              "Add Team Member",
              style: TextStyle(
                  color: black, fontSize: font20.sp, fontWeight: FontWeight.w500),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 5, right: 25),
            child: Text(
              "$addTeamMsg",
              style: TextStyle(color: black, fontSize: font15.sp),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 15, right: 25),
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: lightBlue, // border color
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/easy_use.png',
                          height: 36.h,
                          color: white,
                        ),
                      ),
                    )),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Easy step process",
                        style: TextStyle(
                            color: black,
                            fontSize: font16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "You may add any one from your store",
                        style: TextStyle(
                            color: black,
                            fontSize: font14.sp,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 20, right: 25),
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: lightBlue, // border color
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/control_team.png',
                          height: 36.h,
                          color: white,
                        ),
                      ),
                    )),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Your are always Incharge",
                        style: TextStyle(
                            color: black,
                            fontSize: font16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "You can change permission and add-remove anyone at anytime",
                        style: TextStyle(
                            color: black,
                            fontSize: font14.sp,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 20, right: 25),
            child: Row(
              children: [
                Container(
                    decoration: BoxDecoration(
                      color: lightBlue, // border color
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.all(6.0),
                        child: Image.asset(
                          'assets/free_use.png',
                          height: 36.h,
                          color: white,
                        ),
                      ),
                    )),
                SizedBox(
                  width: 10.w,
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Absolutely free",
                        style: TextStyle(
                            color: black,
                            fontSize: font16.sp,
                            fontWeight: FontWeight.w500),
                      ),
                      Text(
                        "There is no hidden charges. It's free.",
                        style: TextStyle(
                            color: black,
                            fontSize: font14.sp,
                            fontWeight: FontWeight.normal),
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ]),
      ),
      bottomNavigationBar: _buildBotton(),
    )));
  }

  _buildBotton() {
    return InkWell(
      onTap: () {
        setState(() {
          openTeamMemberList(context);
        });
      },
      child: Container(
        height: 45.h,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Center(
          child: Text(
            "Proceed",
            style: TextStyle(fontSize: font16.sp, color: white),
          ),
        ),
      ),
    );
  }
}
