import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/Banks.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/AppKeys.dart';


class AEPS_BalanceEnq extends StatefulWidget {
  final Map map;

  const AEPS_BalanceEnq({Key? key, required this.map}) : super(key: key);

  @override
  _AEPS_BalanceEnqState createState() => _AEPS_BalanceEnqState();
}

class _AEPS_BalanceEnqState extends State<AEPS_BalanceEnq> {


  List<BankList> bankList = [];

  var loading = false;

  var screen ="Balc Enq";

  var bankName = "";

  var bankLogo = "";

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    getUserDetails();
    getBankList();
  }


  getUserDetails()async{
    var bName = await getBankName();
    setState(() {
      bankName = bName;
      if (bankName.contains(".")) bankName = bankName.replaceAll(".", "");
    });

    printMessage(screen, "bankName : $bankName");
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
            ),
            body: (loading)?Center(child: circularProgressLoading(40.0),)
                :SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      appSelectedBanner(context, "recharge_banner.png", 150.0),
                  Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      margin: EdgeInsets.only(
                          top: 20, left: 10, right: 10, bottom: 20),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          children: [
                            SizedBox(
                              height: 20.h,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15.w,
                                ),
                                (bankLogo == "")
                                    ? Image.asset(
                                  'assets/bank.png',
                                  height: 30.h,
                                )
                                    : Image.network(
                                  "$bankIconUrl$bankLogo",
                                  width: 30.w,
                                  height: 30.h,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Text(
                                  widget.map['bankName'],
                                  style: TextStyle(
                                      color: black, fontSize: font16.sp),
                                )
                              ],
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 60.w,
                                ),
                                Text(
                                  "Account Balance",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp),
                                ),
                                Spacer(),
                                Text(
                                  "$rupeeSymbol ${widget.map['balance']}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font16.sp,
                                  fontWeight: FontWeight.bold),
                                ),
                                SizedBox(
                                  width: 40.w,
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h,),
                            Row(
                              children: [
                                SizedBox(
                                  width: 60.w,
                                ),
                                Text(
                                  "Adhaar No.",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp),
                                ),
                                Spacer(),
                                Text(
                                  "${widget.map['adharNo']}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font16.sp,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  width: 40.w,
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h,),
                            Row(
                              children: [
                                SizedBox(
                                  width: 60.w,
                                ),
                                Text(
                                  "Customer Mobile No.",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp),
                                ),
                                Spacer(),
                                Text(
                                  "${widget.map['mobile']}",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font16.sp,
                                      fontWeight: FontWeight.normal),
                                ),
                                SizedBox(
                                  width: 40.w,
                                ),
                              ],
                            ),
                            SizedBox(height: 4.h,),
                            Row(
                              children: [
                                SizedBox(
                                  width: 60.w,
                                ),
                                Text(
                                  "Bank Response",
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font14.sp),
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    "${widget.map['bankResponseMsg']}",
                                    textAlign: TextAlign.end,
                                    style: TextStyle(
                                        color: black,
                                        fontSize: font16.sp,
                                        fontWeight: FontWeight.normal),
                                  ),
                                ),
                                SizedBox(
                                  width: 40.w,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.h,
                            ),

                          ],
                        ),
                      ))
                ])))));
  }

  Future getBankList() async {
    setState(() {
      loading = true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader"
    };

    final response = await http.post(Uri.parse(bankListAPI), headers: headers);


    setState(() {
      loading = false;
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['status'].toString() == "1") {
          var result =
          Banks.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          bankList = result.data;

          for (int i = 0; i < bankList.length; i++) {
            var bname = bankList[i].bankName;
            if (bname.contains(".")) {
              bname = bname.replaceAll(".", "");
            }
            if (bankName.toString().toLowerCase() ==
                bname.toString().toLowerCase()) {
              printMessage(screen, "Bank Logo : ${bankList[i].logo}");
              setState(() {
                bankLogo = bankList[i].logo;
              });
              break;
            }
          }
        }
      }
    });
  }
}
