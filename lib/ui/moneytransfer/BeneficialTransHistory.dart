import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/BeneHistory.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/AppKeys.dart';


class BeneficialTransHistory extends StatefulWidget {
  final String accNo;

  const BeneficialTransHistory({Key? key, required this.accNo})
      : super(key: key);

  @override
  _BeneficialTransHistoryState createState() => _BeneficialTransHistoryState();
}

class _BeneficialTransHistoryState extends State<BeneficialTransHistory> {
  var screen = "Bene History";

  var loading = false;

  List<PayoutList> payoutList = [];

  bool isBeneReload = false;
  int pageBene = 1;
  int beneTotalPage = 0;
  late ScrollController scrollBeneController;

  @override
  void initState() {
    super.initState();
    scrollBeneController = new ScrollController()
      ..addListener(_scrollBeneListener);
    getBeneHistory();

    printMessage(screen, "Get accNo : ${widget.accNo}");
  }

  void _scrollBeneListener() {
    if (pageBene <= beneTotalPage) {
      if (scrollBeneController.position.extentAfter < 500) {
        setState(() {
          isBeneReload = true;
          if (isBeneReload) {
            isBeneReload = false;
            pageBene = pageBene + 1;
            getBeneHistoryOnScroll(pageBene);
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
            body: (loading)
                ? Center(
                    child: circularProgressLoading(40.0),
                  )
                : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        (payoutList.length == 0)
                            ? NoDataFound(
                                text: "No records found",
                              )
                            : _buildTransactionSection()
                      ])))));
  }

  Future getBeneHistory() async {
    setState(() {
      loading = true;
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader"
    };

    final body = {
      "user_token": userToken,
      "page": "1",
      "bene_account": "${widget.accNo}"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(walletBeneficialTransctionAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    setState(() {
      loading = false;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Bank Code : $data");
        if (data['status'].toString() == "1") {
          var result =
              BeneHistory.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          payoutList = result.payoutList;
          beneTotalPage = result.totalPages;
        }
      } else {
        setState(() {});
        showToastMessage(status500);
      }
    });
  }

  Future getBeneHistoryOnScroll(page) async {
    setState(() {
      isBeneReload = true;
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader"
    };

    final body = {
      "user_token": userToken,
      "page": "$page",
      "bene_account": "${widget.accNo}"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(walletBeneficialTransctionAPI),
        body: jsonEncode(body), headers: headers);



    int statusCode = response.statusCode;

    setState(() {
      isBeneReload = false;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Bank Code : $data");

        List<PayoutList> payout = [];
        if (data['status'].toString() == "1") {
          if (data['payout_list'].length != 0) {
            for (int i = 0; i < data['payout_list'].length; i++) {
              var date = data['payout_list']['date'];
              var merchantRefId = data['payout_list']['merchantRefId'];
              var beneAccount = data['payout_list']['bene_account'];
              var ifscJcode = data['payout_list']['ifsc_jcode'];
              var beneName = data['payout_list']['bene_name'];
              var mobile = data['payout_list']['mobile'];
              var amount = data['payout_list']['amount'];
              var status = data['payout_list']['status'];
              var walletType = data['payout_list']['wallet_type'];

              PayoutList list = new PayoutList(
                  date: date,
                  merchantRefId: merchantRefId,
                  beneAccount: beneAccount,
                  ifscJcode: ifscJcode,
                  beneName: beneName,
                  mobile: mobile,
                  amount: amount,
                  status: status,
                  walletType: walletType);
              payout.add(list);
            }
          }

          payoutList.insertAll(payoutList.length, payout);
        }
      }else{
        setState(() {

        });
        showToastMessage(status500);
      }
    });
  }

  _buildTransactionSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: ListView.builder(
        itemCount: payoutList.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
            child: InkWell(
              onTap: () {
                if (payoutList[index].status.toString().toLowerCase() ==
                    "success") {
                  var date = payoutList[index].date;
                  var merchantRefId = payoutList[index].merchantRefId;
                  var accNo = payoutList[index].beneAccount;
                  var ifscCode = payoutList[index].ifscJcode;
                  var name = payoutList[index].beneName;
                  var mobile = payoutList[index].mobile;
                  var amount = payoutList[index].amount;
                  var status = payoutList[index].status;
                  var purpose = payoutList[index].walletType;

                  Map map = {
                    "date": "$date",
                    "merchantRefId": "$merchantRefId",
                    "bene_account": "$accNo",
                    "ifsc_jcode": "$ifscCode",
                    "bene_name": "$name",
                    "mobile": "$mobile",
                    "amount": "$amount",
                    "status": "$status",
                    "wallet_type": "$purpose"
                  };
                  openTransPayoutRecipt(context, map);
                } else {

                  var mTransId = payoutList[index].merchantRefId;
                  var walletType = payoutList[index].walletType;
                  generateTransPayoutToken(mTransId, walletType);
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: 10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    color: white,
                    borderRadius: BorderRadius.all(Radius.circular(20)),
                    border: Border.all(color: gray)),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 5.w,
                          ),
                          Image.asset(
                            'assets/ic_v_right.png',
                            height: 24.h,
                          ),
                          Expanded(
                              flex: 1,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Paid to",
                                      style: TextStyle(
                                          color: black, fontSize: font14.sp),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      (payoutList[index].beneName.toString() ==
                                              "null")
                                          ? "${payoutList[index].beneAccount}"
                                          : "${payoutList[index].beneName}",
                                      style: TextStyle(
                                          color: black, fontSize: font15.sp),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10.0),
                                    child: Text(
                                      "Txn Id : ${payoutList[index].merchantRefId}",
                                      style: TextStyle(
                                          color: black, fontSize: font14.sp),
                                      textAlign: TextAlign.left,
                                    ),
                                  ),
                                ],
                              )),
                          Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8, top: 8),
                                child: Text(
                                  "$rupeeSymbol ${payoutList[index].amount}",
                                  style:
                                      TextStyle(color: black, fontSize: font16.sp),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 8.0, right: 8, bottom: 8),
                                child: Text("${payoutList[index].status}",
                                    style: TextStyle(
                                        color: black, fontSize: font13.sp)),
                              )
                            ],
                          ),
                          SizedBox(
                            width: 5.w,
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 35.0),
                        child: Row(
                          children: [
                            Text(
                              "${payoutList[index].date}",
                              style: TextStyle(color: black, fontSize: font13.sp),
                              textAlign: TextAlign.left,
                            ),
                            Spacer(),
                            Text(
                              "Debitd from ${payoutList[index].walletType}",
                              style: TextStyle(color: black, fontSize: font13.sp),
                              textAlign: TextAlign.left,
                            ),
                          ],
                        ),
                      ),
                      Center(
                        child: (payoutList[index].status.toString().toLowerCase() != "success"
                            && payoutList[index].status.toString().toLowerCase() != "fail"
                            && payoutList[index].status.toString().toLowerCase() != "failed"
                            && payoutList[index].status.toString().toLowerCase() != "failure")
                            ? Padding(
                                padding:
                                    const EdgeInsets.only(left: 10.0, top: 5),
                                child: Text(
                                  "Check your transaction status",
                                  style:
                                      TextStyle(color: red, fontSize: font12.sp),
                                ),
                              )
                            : Container(),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Future generateTransPayoutToken(mTransId, walletType) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response =
        await http.post(Uri.parse(payoutTokenGenerateAPI), headers: headers);

    var statusCode = response.statusCode;
    Navigator.pop(context);
    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));
      printMessage(screen, "Response Token : $data");
      var token = data['result']['access_token'];
      getCheckTransStatus(token, mTransId, walletType);
    } else {
      setState(() {
        showToastMessage(somethingWrong);
      });
    }
  }

  Future getCheckTransStatus(token, mTransId, walletType) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait while we check your transaction status");
          });
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": userToken,
      "access_token": "$token",
      "merchantRefId": "$mTransId",
      "wallet_type": "$walletType",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(walletPayoutStatusCheckAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "CHeck status response : $data");

    setState(() {
      Navigator.pop(context);

      if (data['status'].toString() == "1") {
        printMessage(screen, "${data['result']['data']['transactionDetails']}");

        var txnStatus =
            data['result']['data']['transactionDetails'][0]['txnStatus'];

        var txnId = data['result']['data']['transactionDetails'][0]['txnId'];

        var mRefId =
            data['result']['data']['transactionDetails'][0]['merchantRefId'];

        var name =
            data['result']['data']['transactionDetails'][0]['beneficiaryName'];

        var purpose =
            data['result']['data']['transactionDetails'][0]['purpose'];

        var amount = data['result']['data']['transactionDetails'][0]['amount'];

        var txnDate =
            data['result']['data']['transactionDetails'][0]['txnDate'];

        Map map = {
          "date": "$txnDate",
          "merchantRefId": "$mRefId",
          "bene_account": "null",
          "ifsc_jcode": "null",
          "bene_name": "$name",
          "mobile": "null",
          "amount": "$amount",
          "status": "$txnStatus",
          "wallet_type": "$purpose"
        };

        openTransPayoutRecipt(context, map);
      }
    });
  }
}
