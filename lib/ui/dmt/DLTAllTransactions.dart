import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/DMTTransactions.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class DLTAllTransactions extends StatefulWidget {
  const DLTAllTransactions({Key? key}) : super(key: key);

  @override
  _DLTAllTransactionsState createState() => _DLTAllTransactionsState();
}

class _DLTAllTransactionsState extends State<DLTAllTransactions> {
  var screen = "DTL Transaction";

  List<DMTList> transctionList = [];

  String moneyProBalc = "0";

  List<int> pageNo = [];

  int pages = 0;

  int selectedPage = 1;

  var isReload = false;

  var loading = false;

  late ScrollController scrollOtherController;

  @override
  void initState() {
    super.initState();
    scrollOtherController = new ScrollController()..addListener(_scrollListener);
    getAllTransaction("$selectedPage");
    updateATMStatus(context);
    updateWalletBalances();
    fetchUserAccountBalance();
  }

  void _scrollListener() {

    if(selectedPage<=pages){
      if (scrollOtherController.position.extentAfter < 500) {
        setState(() {
          isReload = true;
          if (isReload) {
            isReload = false;
            selectedPage = selectedPage + 1;
            getScrollTransaction(selectedPage);
          }
        });
      }
    }
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();

    final inheritedWidget = StateContainer.of(context);

    inheritedWidget.updateMPBalc(value: mpBalc);
    if (mpBalc == null || mpBalc == 0) {
      mpBalc = 0;
      final inheritedWidget = StateContainer.of(context);
      inheritedWidget.updateMPBalc(value: mpBalc);
    }

    inheritedWidget.updateQRBalc(value: qrBalc);
    if (qrBalc == null || qrBalc == 0) {
      qrBalc = 0;
      final inheritedWidget = StateContainer.of(context);
      inheritedWidget.updateQRBalc(value: qrBalc);
    }
  }

  @override
  Widget build(BuildContext context) {
    final InheritedWidget = StateContainer.of(context);
    var moneyProBalc = InheritedWidget.mpBalc;
    var mproBalc = InheritedWidget.qrBalc;
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
                  actions: [
                    Container(
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: walletBg,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                          border: Border.all(color: walletBg)),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 5, bottom: 5),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Image.asset(
                              "assets/wallet.png",
                              height: 20.h,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, top: 5),
                                child: Text(
                                  moneyProBalc,
                                  style:
                                      TextStyle(color: white, fontSize: font15.sp),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    )
                  ],
                ),
                body: (loading)
                    ? Center(child: circularProgressLoading(40.0),)
                    : SingleChildScrollView(
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
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(
                                "assets/banner_1.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 10),
                          child: Text(
                            "Transactions",
                            style: TextStyle(
                                color: black,
                                fontWeight: FontWeight.bold,
                                fontSize: font16.sp),
                          ),
                        ),
                        (transctionList.length == 0)
                            ? NoDataFound(text: 'No data found')
                            : _buildTransactions(),

                      ]),
                ),
            bottomNavigationBar: (isReload)?Container(
              height: 50.h,
              child: Center(
                child: circularProgressLoading(40.0),
              ),
            ):Container(height: 1.h,),)));
  }

  _buildTransactions() {
    return ListView.builder(
      itemCount: transctionList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Map map = {
              "date": "${transctionList[index].date}",
              "transId": "${transctionList[index].transctionId}",
              "amount": "${transctionList[index].amount}",
              "mode": "${transctionList[index].mode}",
              "status": "${transctionList[index].status}",
              "mobile": "${transctionList[index].mobile}",
              "acc_no": "${transctionList[index].accNo}",
              "customer_charge": "${transctionList[index].customerCharge}",
              "total_payable_amnt": "${transctionList[index].totalPayableAmnt}",
              "merchant_commission":
                  "${transctionList[index].merchantCommission}",
            };

            openDMTRecipt(context, map);
          },
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            padding: EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                border: Border.all(color: gray)),
            child: Row(
              children: [
                Container(
                    height: 36.h,
                    width: 36.w,
                    decoration: BoxDecoration(
                      color: invBoxBg, // border color
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/bank.png',
                        color: lightBlue,
                      ),
                    )),
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0, top: 0),
                          child: Text(
                            "$transId : ${transctionList[index].transctionId}",
                            style: TextStyle(color: black, fontSize: font15.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "$mode_ : ${transctionList[index].mode}",
                            style: TextStyle(color: black, fontSize: font15.sp),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            "Status : ${transctionList[index].status}",
                            style: TextStyle(color: black, fontSize: font15),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    )),
                Column(
                  children: [
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                      child: Text(
                        "$rupeeSymbol ${transctionList[index].amount}",
                        style: TextStyle(color: orange, fontSize: font16.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, bottom: 8),
                      child: Text("Debited",
                          style: TextStyle(color: black, fontSize: font13.sp)),
                    )
                  ],
                ),
                SizedBox(
                  width: 5,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future getAllTransaction(page) async {
    setState(() {
      loading = true;
    });

    var mechantId = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"m_id": "$mechantId", "page": "$page"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtAllTransctionAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response All Transaction : $data");

      setState(() {
        loading = false;

        if (data['status'].toString() == "1") {
          transctionList.clear();
          var result = DmtTransactions.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          transctionList = result.transctionList;
          pages = result.totalPages;
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    }else{
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }


  }

  Future getScrollTransaction(page) async {
    setState(() {
      isReload = true;
    });

    //var mechantId = await getMerchantID();
    var mechantId ="M428509";

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"m_id": "$mechantId", "page": "$page"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtAllTransctionAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response All Transaction : $data");

    setState(() {
      isReload = false;
      if (data['status'].toString() == "1") {
        var result = DmtTransactions.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        transctionList = result.transctionList;
      } else {
        showToastMessage(data['message'].toString());
      }
    });
  }
}
