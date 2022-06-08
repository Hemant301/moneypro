import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/home/Perspective.dart';
import 'package:moneypro_new/ui/models/Complaint.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/NoInternet.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class ComplaintManagement extends StatefulWidget {
  const ComplaintManagement({Key? key}) : super(key: key);

  @override
  _ComplaintManagementState createState() => _ComplaintManagementState();
}

class _ComplaintManagementState extends State<ComplaintManagement> {
  var screen = "Complaint Manage";

  List<ComList> comList = [];

  var loading = false;

  @override
  void initState() {
    super.initState();
    getComplaintList();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
            backgroundColor: white,
            appBar: appBarHome(
              context,
              "assets/bbpslogo.png",
              70.0.w,
            ),
            body: (loading)
                ? Center(child: circularProgressLoading(40.0))
                : SingleChildScrollView(
                    child: Column(children: [
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
                              "assets/banner_1.png",
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                      (comList.length == 0)
                          ? NoDataFound(text: "")
                          : _buildListSection(),
                    ]),
                  ))));
  }

  Future getComplaintList() async {
    setState(() {
      loading = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": token,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(bbpsComplainListAPI),
        body: jsonEncode(body), headers: headers);

    setState(() {
      loading = false;

      var statusCode = response.statusCode;

      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Response : $data");
        if (data['status'].toString() == "1") {
          var result =
              Complaint.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          comList = result.comList;
        } else {
          showToastMessage(data['message'].toString());
        }
      } else {
        showToastMessage(status500);
      }
    });
  }

  _buildListSection() {
    return ListView.builder(
      itemCount: comList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return Column(
          children: [
            Container(
              margin: EdgeInsets.only(left: 15, right: 15, top: 15),
              decoration: BoxDecoration(
                  color: boxBg,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(color: boxBg)),
              child: Column(
                children: [
                  Row(
                    children: [
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                          flex: 3,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 15.0, top: 10, bottom: 10),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Ticket Id : ",
                                      style: TextStyle(
                                          color: black, fontSize: font14.sp),
                                    ),
                                    Text(
                                      "${comList[index].ticketId}",
                                      style: TextStyle(
                                          color: black, fontSize: font14.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Operator : ",
                                      style: TextStyle(
                                          color: black, fontSize: font14.sp),
                                    ),
                                    Text(
                                      "${comList[index].comListOperator}",
                                      style: TextStyle(
                                          color: black, fontSize: font14.sp),
                                    ),
                                  ],
                                ),
                                SizedBox(
                                  height: 4.h,
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Amount : ",
                                      style: TextStyle(
                                          color: black, fontSize: font14.sp),
                                    ),
                                    Text(
                                      "$rupeeSymbol ${comList[index].amount}",
                                      style: TextStyle(
                                          color: black, fontSize: font14.sp),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          )),
                      Container(
                        height: 40.h,
                        color: gray,
                        width: 1.w,
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                      Expanded(
                          child: Text(
                        "${comList[index].status}",
                        style: TextStyle(
                            color: (comList[index]
                                        .status
                                        .toString()
                                        .toLowerCase() ==
                                    "Refund".toString().toLowerCase())
                                ? green
                                : red,
                            fontSize: font18.sp,
                            fontWeight: FontWeight.bold),
                      ))
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}
