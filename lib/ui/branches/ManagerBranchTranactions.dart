import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/BranchPartiTransaction.dart';
import 'package:moneypro_new/ui/models/History.dart';
import 'package:moneypro_new/ui/models/Settelments.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/AppKeys.dart';


class ManagerBranchTranactions extends StatefulWidget {
  const ManagerBranchTranactions({Key? key}) : super(key: key);

  @override
  _ManagerBranchTranactionsState createState() => _ManagerBranchTranactionsState();
}

class _ManagerBranchTranactionsState extends State<ManagerBranchTranactions> {
  var screen = "Branch Transaction";

  int selectedIndex = 1;

  var qrLoading = false;

  var qrSettleLoading = false;

  List<BranchSelfTrans> branchSelfTransList =[];


  bool isQrResponseReload = false;
  int pageQrResponse= 1;
  int qrResponseTotalPage = 0;
  late ScrollController scrollQrResponseController;

  var totalAmt ="";

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    scrollQrResponseController = new ScrollController()
      ..addListener(_scrollQrResponseListener);
    getQRTransactions();
  }

  void _scrollQrResponseListener() {
    if (pageQrResponse <= qrResponseTotalPage) {
      if (scrollQrResponseController.position.extentAfter < 500) {
        setState(() {
          isQrResponseReload = true;
          if (isQrResponseReload) {
            isQrResponseReload = false;
            pageQrResponse = pageQrResponse + 1;
            getQRTransactionsOnScroll(pageQrResponse);
          }
        });
      }
    }
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
                closeCurrentPage(context);
                closeKeyBoard(context);
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
            actions: [
              Image.asset(
                'assets/faq.png',
                width: 24.w,
                color: orange,
              ),
              SizedBox(
                width: 10.w,
              )
            ],
          ),
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
              height: 10.w,
            ),
            Row(
              children: [
                SizedBox(
                  width: 20.w,
                ),
                Expanded(
                    child: Column(
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              selectedIndex = 1;
                            });

                            if(branchSelfTransList.length==0){
                              getQRTransactions();
                            }

                          },
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "QR Transaction",
                              style: TextStyle(
                                  color: (selectedIndex == 1) ? lightBlue : black,
                                  fontSize: font16.sp,
                                  fontWeight: (selectedIndex == 1)
                                      ? FontWeight.bold
                                      : FontWeight.normal),
                            ),
                          ),
                        ),
                        Divider(
                          color: (selectedIndex == 1) ? blue : white,
                          thickness: 3,
                        ),
                      ],
                    )),
                Expanded(
                    child: Container()),
                SizedBox(
                  width: 20.w
                ),
              ],
            ),
            Divider(),
            SizedBox(
              height: 10.w,
            ),
            (qrLoading)
                ? Center(
              child: circularProgressLoading(40.0),
            )
                : Expanded(
                child: SingleChildScrollView(
                    controller: scrollQrResponseController,
                    child: (branchSelfTransList.length==0)?_emptyData():Column(children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Row(
                          children: [
                            Image.asset('assets/qr_menu.png', height: 20,),
                            SizedBox(width: 5.w,),
                            Text("Total $rupeeSymbol $totalAmt", style: TextStyle(
                                color: black, fontSize: font18.sp, fontWeight: FontWeight.bold
                            ),)
                          ],
                        ),
                      ),
                      _buildTransactions()
                    ],)
                )),
          ]),
        )));
  }

  _emptyData() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 150.h,
          ),
          Image.asset(
            'assets/no_member.png',
            height: 210.h,
          ),
          Text(
            "No record found",
            style: TextStyle(
                color: black, fontSize: font16.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  _buildTransactions() {
    return ListView.builder(
      itemCount: branchSelfTransList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 0),
          child: InkWell(
            onTap: () {},
            child: Container(
              margin: EdgeInsets.only(top: 10),
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(30)),
                  border: Border.all(color: gray)),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    Container(
                        height: 45.h,
                        width: 45.w,
                        decoration: BoxDecoration(
                          color: lightBlue, // border color
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(9.0),
                          child: Image.asset(
                            'assets/ic_branch_office.png',
                            color: white,
                          ),
                        )),
                    SizedBox(
                      width: 5.w,
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "Txn Id: ${branchSelfTransList[index].transctionId}",
                                style:
                                TextStyle(color: black, fontSize: font14.sp),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "${branchSelfTransList[index].branchName}",
                                style:
                                TextStyle(color: black, fontSize: font15.sp),
                                textAlign: TextAlign.left,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Text(
                                "${branchSelfTransList[index].date}",
                                style:
                                TextStyle(color: black, fontSize: font13.sp),
                                textAlign: TextAlign.left,
                              ),
                            )
                          ],
                        )),
                    Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 8, top: 0),
                          child: Text(
                            "$rupeeSymbol ${branchSelfTransList[index].amount}",
                            style: TextStyle(color: black, fontSize: font16.sp, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future getQRTransactions() async {
    setState(() {
      qrLoading = true;
    });

    var mobile = await getMobile();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "mobile":"$mobile",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchManagerTxnListAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Manager Transaction : $data");

      setState(() {
        qrLoading = false;
        if (data['status'].toString() == "1") {
          var result =
          BranchPartiTransaction.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          branchSelfTransList = result.transctionList;
          qrResponseTotalPage = int.parse(data['total_pages'].toString());
          totalAmt = data['total_amount'].toString();
        }
      });
    }else{
      setState(() {
        qrLoading = false;
      });
      showToastMessage(status500);
    }


  }

  Future getQRTransactionsOnScroll(page) async {
    setState(() {
      isQrResponseReload = true;
    });

    var mobile = await getMobile();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "mobile":"$mobile",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchManagerTxnListAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    setState(() {
      isQrResponseReload = false;
      if (data['status'].toString() == "1") {

        List<BranchSelfTrans> branchSelfTransListNew =[];

        if(data['transction_list'].length!=0){
          for (int i = 0; i < data['transction_list'].length; i++) {
            var date = data['transction_list'][i]['date'];
            var transctionId= data['transction_list'][i]['transction_id'];
            var amount= data['transction_list'][i]['amount'];
            var branchName= data['transction_list'][i]['branch_name'];
            var time= data['transction_list'][i]['time'];
            var name= data['transction_list'][i]['name'];

            BranchSelfTrans pay = new BranchSelfTrans(
              date:date,
              transctionId:transctionId,
              amount:amount,
              branchName:branchName,
                time:time,
                name:name
            );

            branchSelfTransListNew.add(pay);
            branchSelfTransList.insertAll(branchSelfTransList.length, branchSelfTransListNew);
          }
        }
      }
    });
  }

}
