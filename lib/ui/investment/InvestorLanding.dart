import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:moneypro_new/ui/models/InvestorStatementList.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:moneypro_new/utils/StateContainer.dart';

class InvestorLanding extends StatefulWidget {
  const InvestorLanding({Key? key}) : super(key: key);

  @override
  _InvestorLandingState createState() => _InvestorLandingState();
}

String finalAmt = "0";

class _InvestorLandingState extends State<InvestorLanding> {
  var screen = "Investor Landing";

  var loading = false;

  List<InvList> accStatementList = [];

  int page = 0;

  var investorWallet;
  var investorEarning;

  double earning = 0.0;

  double totalEarning = 0.0;

  var _switchValue = false;

  var approved = "";

  var role;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInvestorKycStatus();
    getQRStatus();
    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();
  }

  getQRStatus() async {
    var status = await getQRInvestor();

    var r = await getRole();
    var app = await getApproved();

    printMessage(
        screen,
        "Value of Status : $status\n"
        "Role : $r");

    setState(() {
      if (status.toString().toLowerCase() == "yes") {
        _switchValue = true;
      } else {
        _switchValue = false;
      }
      role = r;
      approved = app;
    });
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
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
      child: Scaffold(
        backgroundColor: white,
        appBar: appBarHome(context, "assets/lendbox_head.png", 60.0),
        body: (loading)
            ? Center(child: circularProgressLoading(40.0))
            : Column(
                children: [
                  appSelectedBanner(context, "invest_banner.png", 150.0.h),
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: Container(
                      color: gray,
                      width: 50.w,
                      height: 5.h,
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 25.0, right: 25, top: 0),
                    child: Row(
                      children: [
                        Text(
                          "$totalValue",
                          style: TextStyle(
                              color: black,
                              fontSize: font13.sp,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Image.asset(
                          'assets/lendbox_line.png',
                          height: 16.h,
                        ),
                        Spacer(),
                        Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(
                                rupeeSymbol,
                                style: TextStyle(
                                    color: orange,
                                    fontSize: font14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 4.w,
                            ),
                            Text(
                              "${formatNow.format(totalEarning)}",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                  color: orange,
                                  fontSize: 20.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                            SizedBox(
                              width: 2,
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  _buildTwoTabs(),
                  SizedBox(
                    height: 10.h,
                  ),
                  Expanded(
                    child: Container(
                      child: SingleChildScrollView(
                        child: _buildRecentTransaction(),
                      ),
                    ),
                  ),
                ],
              ),
        bottomNavigationBar: _bottomInfo(),
      ),
    ));
  }

  _buildTwoTabs() {
    return Padding(
      padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Container(
                    height: 75.h,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 10),
                              child: Container(
                                  height: 36.h,
                                  width: 36.w,
                                  decoration: BoxDecoration(
                                    color: blue, // border color
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/invest_money.png',
                                    ),
                                  )),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                rupeeSymbol,
                                style: TextStyle(
                                    color: black,
                                    fontSize: font14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "$investorWallet",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                    color: black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            SizedBox(
                              width: 15,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0, top: 0),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "$investment",
                              style:
                                  TextStyle(color: lightBlack, fontSize: font13.sp),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(26),
                  ),
                  child: Container(
                    height: 75.h,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 20.0, top: 10),
                              child: Container(
                                  height: 36.h,
                                  width: 36.w,
                                  decoration: BoxDecoration(
                                    color: orange, // border color
                                    shape: BoxShape.circle,
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Image.asset(
                                      'assets/earnings.png',
                                    ),
                                  )),
                            ),
                            Spacer(),
                            Padding(
                              padding: const EdgeInsets.only(top: 0.0),
                              child: Text(
                                rupeeSymbol,
                                style: TextStyle(
                                    color: black,
                                    fontSize: font14.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            FittedBox(
                              child: Text(
                                "${formatNow.format(earning)}",
                                textAlign: TextAlign.end,
                                style: TextStyle(
                                    color: black,
                                    fontSize: 20.sp,
                                    fontWeight: FontWeight.bold),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            SizedBox(
                              width: 10,
                            ),
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25.0, top: 0),
                          child: Text(
                            "$earning_",
                            style:
                                TextStyle(color: lightBlack, fontSize: font13.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40.h,
                  margin:
                      EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
                  decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: lightBlue)),
                  child: InkWell(
                    onTap: () {
                      _showAmountChoose();
                    },
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "$addMoney",
                          style: TextStyle(
                            color: white,
                            fontSize: font14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 15.w,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40.h,
                  margin:
                      EdgeInsets.only(left: 0, right: 0, top: 10, bottom: 0),
                  decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: lightBlue)),
                  child: InkWell(
                    onTap: () {
                      if (approved.toString() == "1") {
                        openInvestorWithdrawal(context, totalEarning);
                      } else {
                        showToastMessage(notApproved);
                      }
                    },
                    child: Center(
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: Text(
                          "$requestWithdrawal",
                          style: TextStyle(
                            color: white,
                            fontSize: font14.sp,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          (role.toString() == "3")
              ? Padding(
                  padding: EdgeInsets.only(top: 10, left: 15, right: 15),
                  child: Row(
                    children: [
                      Text(
                        autoInvest,
                        style: TextStyle(
                            color: black,
                            fontSize: font13.sp,
                            fontWeight: FontWeight.bold),
                      ),
                      Spacer(),
                      FlutterSwitch(
                          width: 60.0,
                          height: 26.0,
                          valueFontSize: 14.0,
                          toggleSize: 24.0,
                          activeText: "Y",
                          inactiveText: "N",
                          value: _switchValue,
                          borderRadius: 30.0,
                          padding: 4.0,
                          showOnOff: true,
                          onToggle: (value) {
                            setState(() {
                              _switchValue = value;
                              if (value) {
                                autoInvestEnable("Yes");
                              } else {
                                autoInvestEnable("No");
                              }
                            });
                          }),
                    ],
                  ),
                )
              : Container(),
        ],
      ),
    );
  }

  Future getInvestorKycStatus() async {
    setState(() {
      loading = true;
    });

    var mobile = await getMobile();
    var pan = await getPANNo();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "mobile": mobile,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(investorKycStatusAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          investorWallet = data['profile_data']['investment_wallet'];
          investorEarning = data['profile_data']['investment_earning_wallet'];

          earning = double.parse(
              data['profile_data']['investment_earning_wallet'].toString());
          totalEarning =
              double.parse(investorWallet) + double.parse(investorEarning);

          getRecentList(page);

          var withdralStatus =
              data['profile_data']['withdral_status'].toString();
        } else {
          loading = false;
          showToastMessage(data['message'].toString());
        }
      } else {
        setState(() {
          loading = false;
          showToastMessage(status500);
        });
      }
    });
  }

  Future getRecentList(page) async {
    setState(() {});

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {"token": "$token", "page": "$page"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(investmentInterestListAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      loading = false;
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          var result = InvestorStatementList.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          accStatementList = result.invList;
        } else {
          showToastMessage(data['message'].toString());
        }
      }
    });
  }

  _buildRecentTransaction() {
    return (accStatementList.length == 0)
        ? Container(
            height: 80.h,
            child: Center(
              child: Text(
                "No recent transaction found",
                style: TextStyle(color: black, fontSize: font14.sp),
              ),
            ),
          )
        : ListView.builder(
            itemCount:
                (accStatementList.length > 6) ? 6 : accStatementList.length,
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              return (accStatementList[index].status == 1)
                  ? Container(
                      height: 50.h,
                      margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: gray)),
                      child: Row(
                        children: [
                          SizedBox(
                            width: 15,
                          ),
                          Container(
                              height: 36.h,
                              width: 36.w,
                              decoration: BoxDecoration(
                                color: boxBg, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/send.png',
                                ),
                              )),
                          SizedBox(
                            width: 10.w,
                          ),
                          Expanded(
                            flex: 1,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "${accStatementList[index].descp}",
                                  style: TextStyle(
                                    color: black,
                                    fontSize: font14.sp,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                Text("${accStatementList[index].date}",
                                    style: TextStyle(
                                      color: black,
                                      fontSize: font14,
                                    )),
                              ],
                            ),
                          ),
                          Text("+"),
                          Text(
                              "$rupeeSymbol ${accStatementList[index].interset}"),
                          SizedBox(
                            width: 15.w,
                          )
                        ],
                      ),
                    )
                  : InkWell(
                      onTap: () {
                        if (accStatementList[index].merchantRefId.toString() !=
                                "null" &&
                            accStatementList[index].merchantRefId.toString() !=
                                "null") {
                          var id =
                              accStatementList[index].merchantRefId.toString();

                          Map map = {
                            "type": "Withdrawl",
                            "date": "${accStatementList[index].date}",
                            "time": "",
                            "transId":
                                "${accStatementList[index].merchantRefId}",
                            "heading": "${accStatementList[index].descp}",
                            "description": "",
                            "txn_amnt":
                                "${accStatementList[index].investAmount}",
                            "txn_bal": "${accStatementList[index].closingBal}",
                          };

                          generatePayoutToken(id, map);
                        }
                      },
                      child: Container(
                        margin:
                            EdgeInsets.only(left: 20, right: 20, bottom: 15),
                        decoration: BoxDecoration(
                            color: white,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: gray)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10.h,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: 15.w,
                                ),
                                Container(
                                    height: 36.h,
                                    width: 36.w,
                                    decoration: BoxDecoration(
                                      color: boxBg, // border color
                                      shape: BoxShape.circle,
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset(
                                        'assets/send.png',
                                      ),
                                    )),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "${accStatementList[index].descp}",
                                        style: TextStyle(
                                            color: (accStatementList[index]
                                                        .descp
                                                        .toLowerCase() ==
                                                    "withdrawl")
                                                ? red
                                                : green,
                                            fontSize: font14.sp,
                                            fontWeight: FontWeight.normal),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text("${accStatementList[index].date}"),
                                    ],
                                  ),
                                ),
                                Text((accStatementList[index]
                                            .descp
                                            .toLowerCase() ==
                                        "withdrawl")
                                    ? "-"
                                    : "+"),
                                Text(
                                    "$rupeeSymbol ${accStatementList[index].investAmount}"),
                                SizedBox(
                                  width: 15,
                                )
                              ],
                            ),
                            (accStatementList[index].merchantRefId.toString() ==
                                        "null" ||
                                    accStatementList[index]
                                            .merchantRefId
                                            .toString() ==
                                        "null")
                                ? Container()
                                : Padding(
                                    padding: const EdgeInsets.only(
                                        left: 60.0, top: 5, bottom: 10),
                                    child: Text(
                                      "Check your transaction status",
                                      style: TextStyle(
                                          color: red, fontSize: font12.sp),
                                    ),
                                  ),
                            SizedBox(
                              height: 10.h,
                            ),
                          ],
                        ),
                      ),
                    );
            });
  }

  _bottomInfo() {
    return Padding(
      padding: const EdgeInsets.only(left: 25.0, right: 25, top: 0),
      child: Wrap(
        children: [
          Row(
            children: [
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: 75.h,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 6),
                          child: Container(
                              height: 36.h,
                              width: 36.w,
                              decoration: BoxDecoration(
                                color: green, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/portfolio.png',
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 5),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "$portfolio",
                              style:
                                  TextStyle(color: black, fontSize: font12.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () {
                      openInvestorStatement(context);
                    },
                    child: Container(
                      height: 75.h,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 0.0, top: 6),
                            child: Container(
                                height: 36.h,
                                width: 36.w,
                                decoration: BoxDecoration(
                                  color: orange, // border color
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Image.asset(
                                    'assets/acc_statement.png',
                                  ),
                                )),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 0.0, top: 5),
                            child: FittedBox(
                              fit: BoxFit.contain,
                              child: Text(
                                "$acStatement",
                                style:
                                    TextStyle(color: black, fontSize: font12.sp),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Expanded(
                flex: 1,
                child: Card(
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    height: 75.h,
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 6),
                          child: Container(
                              height: 36.h,
                              width: 36.w,
                              decoration: BoxDecoration(
                                color: lightBlue, // border color
                                shape: BoxShape.circle,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Image.asset(
                                  'assets/faq.png',
                                ),
                              )),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 0.0, top: 5),
                          child: FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              "$faqs",
                              style:
                                  TextStyle(color: black, fontSize: font12.sp),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 15, left: 15, right: 15, bottom: 20),
            decoration: BoxDecoration(
                color: boxBg,
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(color: lightBlue)),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/support_icon.png',
                  height: 24.h,
                ),
                SizedBox(
                  width: 5.w,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      callUs,
                      style: TextStyle(color: black, fontSize: font14.sp),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Text(
                      "$helplineNum",
                      style: TextStyle(color: lightBlue, fontSize: font14.sp),
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future autoInvestEnable(vale) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"token": "$token", "qr_money_invst": "$vale"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(marchantQrAutoInvestAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response On : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
          saveQRInvestor("Yes");
        } else if (data['status'].toString() == "4") {
          saveQRInvestor("No");
          showToastMessage(data['message'].toString());
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  _showAmountChoose() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: MyBottomSheet(),
            ));
  }

  _showRazorPayResponse(amount, transId, status) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: AddMoneyResponse(
                  amount: amount, transId: transId, status: status),
            ));
  }

  Future generatePayoutToken(id, Map map) async {
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
      checkTxnStatus(id, token, map);
    } else {
      setState(() {
        showToastMessage(somethingWrong);
      });
    }
  }

  Future checkTxnStatus(id, accessToken, Map map) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait while we check your transaction status");
          });
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$token",
      "access_token": "$accessToken",
      "merchantRefId": "$id",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(investmentPpayoutCheckAPI),
        body: jsonEncode(body), headers: headers);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          var txnStatus = data['result']['data']['transactionDetails'][0]
                  ['txnStatus']
              .toString();
          Map m = {"txnStatus": "$txnStatus"};
          m.addAll(map);
          printMessage(screen, "Map : $m");
          openWalletRecipt(context, m);
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }
}

class MyBottomSheet extends StatefulWidget {
  @override
  _MyBottomSheetState createState() => _MyBottomSheetState();
}

class _MyBottomSheetState extends State<MyBottomSheet> {
  TextEditingController amountController = new TextEditingController();
  int selectedAmountIndex = 0;

  var loading = false;

  var amount;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>Container(
      width: MediaQuery.of(context).size.width,

      decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
              topLeft: const Radius.circular(40.0),
              topRight: const Radius.circular(40.0))),
      child: Wrap(
        //crossAxisAlignment: CrossAxisAlignment.start,
        //mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: WrapCrossAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 30, bottom: 10),
            child: Text(
              "Add money to Investment A/c",
              style: TextStyle(
                  color: black, fontSize: font16.sp, fontWeight: FontWeight.w700),
            ),
          ),
          Divider(
            color: gray,
          ),
          Container(
            margin: EdgeInsets.only(top: 10, left: 15, right: 15,bottom: 10),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(25)),
                border: Border.all(color: editBg)),
            child: TextFormField(
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              controller: amountController,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 20),
                counterText: "",
                hintText: "Enter the amount",
                hintStyle: TextStyle(fontSize: font15, color: lightBlack),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              maxLength: 8,
            ),
          ),
          SizedBox(
            height: 10.h,
          ),
          /*Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedAmountIndex = 1;
                    amount = "1000";
                    amountController = TextEditingController(text: "$amount");
                    // Navigator.pop(context);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: (selectedAmountIndex == 1) ? lightBlue : white,
                    border: Border.all(color: blue),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12, top: 6, bottom: 6),
                    child: Text(
                      "$rupeeSymbol 1000",
                      style: TextStyle(
                          color: (selectedAmountIndex == 1) ? white : lightBlue,
                          fontSize: font14.sp),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedAmountIndex = 2;
                    amount = "5000";
                    amountController = TextEditingController(text: "$amount");
                    // Navigator.pop(context);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: (selectedAmountIndex == 2) ? lightBlue : white,
                    border: Border.all(color: blue),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12, top: 6, bottom: 6),
                    child: Text(
                      "$rupeeSymbol 5000",
                      style: TextStyle(
                          color: (selectedAmountIndex == 2) ? white : lightBlue,
                          fontSize: font14.sp),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedAmountIndex = 3;
                    amount = "10000";
                    amountController = TextEditingController(text: "$amount");
                    // Navigator.pop(context);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: (selectedAmountIndex == 3) ? lightBlue : white,
                    border: Border.all(color: blue),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12, top: 6, bottom: 6),
                    child: Text(
                      "$rupeeSymbol 10000",
                      style: TextStyle(
                          color: (selectedAmountIndex == 3) ? white : lightBlue,
                          fontSize: font14.sp),
                    ),
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedAmountIndex = 4;
                    amount = "50000";
                    amountController = TextEditingController(text: "$amount");
                    //  Navigator.pop(context);
                  });
                },
                child: Container(
                  margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                  decoration: BoxDecoration(
                    color: (selectedAmountIndex == 4) ? lightBlue : white,
                    border: Border.all(color: blue),
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12.0, right: 12, top: 6, bottom: 6),
                    child: Text(
                      "$rupeeSymbol 50000",
                      style: TextStyle(
                          color: (selectedAmountIndex == 4) ? white : lightBlue,
                          fontSize: font14.sp),
                    ),
                  ),
                ),
              ),
            ],
          ),*/

          Container(
            height: 50.h,
            child: ListView(
              shrinkWrap: true,
              physics: ScrollPhysics(),
              scrollDirection: Axis.horizontal,
              children: [
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedAmountIndex = 1;
                      amount = "1000";
                      amountController = TextEditingController(text: "$amount");
                      // Navigator.pop(context);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 0, left: 10, right: 10),
                    decoration: BoxDecoration(
                      color: (selectedAmountIndex == 1) ? lightBlue : white,
                      border: Border.all(color: blue),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12, top: 6, bottom: 6),
                      child: Center(
                        child: Text(
                          "$rupeeSymbol 1000",
                          style: TextStyle(
                              color: (selectedAmountIndex == 1) ? white : lightBlue,
                              fontSize: font14.sp),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedAmountIndex = 2;
                      amount = "5000";
                      amountController = TextEditingController(text: "$amount");
                      // Navigator.pop(context);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 0, left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: (selectedAmountIndex == 2) ? lightBlue : white,
                      border: Border.all(color: blue),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12, top: 6, bottom: 6),
                      child: Center(
                        child: Text(
                          "$rupeeSymbol 5000",
                          style: TextStyle(
                              color: (selectedAmountIndex == 2) ? white : lightBlue,
                              fontSize: font14.sp),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedAmountIndex = 3;
                      amount = "10000";
                      amountController = TextEditingController(text: "$amount");
                      // Navigator.pop(context);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 0, left: 5, right: 5),
                    decoration: BoxDecoration(
                      color: (selectedAmountIndex == 3) ? lightBlue : white,
                      border: Border.all(color: blue),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12, top: 6, bottom: 6),
                      child: Center(
                        child: Text(
                          "$rupeeSymbol 10000",
                          style: TextStyle(
                              color: (selectedAmountIndex == 3) ? white : lightBlue,
                              fontSize: font14.sp),
                        ),
                      ),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      selectedAmountIndex = 4;
                      amount = "50000";
                      amountController = TextEditingController(text: "$amount");
                      //  Navigator.pop(context);
                    });
                  },
                  child: Container(
                    margin: EdgeInsets.only(top: 0, left: 5, right: 10),
                    decoration: BoxDecoration(
                      color: (selectedAmountIndex == 4) ? lightBlue : white,
                      border: Border.all(color: blue),
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.only(
                          left: 12.0, right: 12, top: 6, bottom: 6),
                      child: Center(
                        child: Text(
                          "$rupeeSymbol 50000",
                          style: TextStyle(
                              color: (selectedAmountIndex == 4) ? white : lightBlue,
                              fontSize: font14.sp),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          InkWell(
            onTap: () {
              setState(() {
                closeKeyBoard(context);

                var amount = amountController.text.toString();

                if (amount.length == 0) {
                  showToastMessage("Enter the amount");
                  return;
                }
                printMessage("Continue", "Amount : $amount");
                finalAmt = amount;
                Navigator.pop(context);
                openInvestorPayment(context, amount);
              });
            },
            child: Container(
              height: 45.h,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 20, left: 15, right: 15, bottom: 20),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: (loading)
                    ? circularProgressLoading(20.0)
                    : Text(
                        continue_.toUpperCase(),
                        style: TextStyle(fontSize: font13.sp, color: white),
                      ),
              ),
            ),
          )
        ],
      ),
    ));
  }

}

class AddMoneyResponse extends StatelessWidget {
  final String amount;
  final String transId;
  final String status;

  const AddMoneyResponse(
      {Key? key,
      required this.amount,
      required this.transId,
      required this.status})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: MediaQuery.of(context).size.width,
        height: 245,
        decoration: new BoxDecoration(
            color: Colors.white,
            borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(40.0),
                topRight: const Radius.circular(40.0))),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(
                    left: 20.0, top: 20, bottom: 0, right: 0),
                child: Row(
                  children: [
                    Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: (status.toString() == "Success") ? green : red,
                          shape: BoxShape.circle),
                      child: Center(
                        child: (status.toString() == "Success")
                            ? Image.asset(
                                'assets/tick.png',
                                height: 16,
                                color: white,
                              )
                            : Icon(
                                Icons.clear,
                                size: 16,
                                color: white,
                              ),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$status",
                          style: TextStyle(color: black, fontSize: font16),
                        ),
                        Text(
                          "$transId",
                          style: TextStyle(color: lightBlack, fontSize: font14),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, right: 30, top: 20),
                child: Text(
                  "Amount",
                  style: TextStyle(color: lightBlack, fontSize: font14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, right: 30, top: 5),
                child: Text(
                  "$rupeeSymbol $amount",
                  style: TextStyle(
                      color: black,
                      fontSize: font16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 60.0, right: 30, top: 20),
                child: Text(
                  "Transfer to",
                  style: TextStyle(color: lightBlack, fontSize: font14),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(
                    left: 60.0, right: 30, top: 5, bottom: 20),
                child: Text(
                  "Investment Account",
                  style: TextStyle(
                      color: black,
                      fontSize: font16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Container(
                  height: 45,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 20),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Center(
                    child: Text(
                      "Ok".toUpperCase(),
                      style: TextStyle(fontSize: font13, color: white),
                    ),
                  ),
                ),
              )
            ]));
  }
}
