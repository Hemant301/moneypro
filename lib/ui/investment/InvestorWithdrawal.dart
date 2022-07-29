import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/ui/models/Banks.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';

import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class InvestorWithdrawal extends StatefulWidget {
  final double maxAmt;

  const InvestorWithdrawal({Key? key, required this.maxAmt}) : super(key: key);

  @override
  _InvestorWithdrawalState createState() => _InvestorWithdrawalState();
}

class _InvestorWithdrawalState extends State<InvestorWithdrawal> {
  final amountController = new TextEditingController();

  var name = "";
  var accountNo = "";
  var branchName = "";
  var bankName = "";
  var bankIfsc = "";

  var bankLogo = "";

  var screen = "Investor Withdraw";

  double maxAmount = 0.0;

  var loading = false;

  List<BankList> bankList = [];

  String withdrawOptions = "IMPS";

  var approved = "";

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    getBankList();
    fetchUserAccountBalance();
    getWalletBalFromPrefs();
    printMessage(screen, "Max Amt : ${widget.maxAmt}");
    setState(() {
      maxAmount = widget.maxAmt;
    });
  }

  getWalletBalFromPrefs() async {
    var role = await getRole();
    printMessage(screen, "Role : $role");

    var fn = await getFirstName();
    var ln = await getLastName();

    var acNo = await getAccountNumber();
    var bCity = await getBranchCity();
    var bName = await getBankName();
    var bIFSC = await getIFSC();

    var app = await getApproved();

    setState(() {
      name = "$fn $ln";
      accountNo = acNo;
      branchName = bCity;
      bankName = bName;
      bankIfsc = bIFSC;
      if (bankName.contains(".")) bankName = bankName.replaceAll(".", "");

      approved = app;
    });

    printMessage(screen, "bankName : $bankName");
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
        builder: () => SafeArea(
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
                  InkWell(
                    onTap: () {
                      print(bankName);
                    },
                    child: Image.asset(
                      'assets/faq.png',
                      width: 30.w,
                      color: orange,
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
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
                          appSelectedBanner(
                              context, "invest_banner.png", 150.0.h),
                          _buildInputSection(),
                          _buildAccountSection(),
                        ])),
              bottomNavigationBar: InkWell(
                onTap: () {
                  setState(() {
                    closeKeyBoard(context);

                    var amount = amountController.text.toString();

                    if (amount == "0" || amount.length == 0) {
                      showToastMessage("enter amount");
                      return;
                    }

                    double a = double.parse(amount);

                    printMessage(screen, "Amount is : $a");
                    printMessage(screen, "Amount max : $maxAmount");

                    if (a > maxAmount) {
                      showToastMessage("You do not have enough balance");
                    } else {
                      _showConfirmWithDr(
                          "$name", "$a", "$accountNo", "$branchName");
                    }
                  });
                },
                child: Container(
                  height: 45.h,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
                  decoration: BoxDecoration(
                    color: lightBlue,
                    borderRadius: BorderRadius.all(Radius.circular(25)),
                  ),
                  child: Center(
                    child: Text(
                      submit.toUpperCase(),
                      style: TextStyle(fontSize: font13.sp, color: white),
                    ),
                  ),
                ),
              ),
            )));
  }

  _buildInputSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 20, right: 20, top: 20, bottom: 0),
      decoration: BoxDecoration(
        color: invBoxBg,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 25, top: 20),
            child: Text(
              enterAmount,
              style: TextStyle(
                  color: black,
                  fontSize: font15.sp,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            height: 40.h,
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 15.0, right: 15, top: 10, bottom: 10),
                child: TextFormField(
                  style: TextStyle(color: black, fontSize: inputFont.sp),
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  controller: amountController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    counterText: "",
                  ),
                  maxLength: 7,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, top: 10),
            child: Text(
              "$youCanWithdraw $rupeeSymbol ${formatDecimal2Digit.format(maxAmount)}",
              style: TextStyle(
                  color: black,
                  fontSize: font13.sp,
                  fontWeight: FontWeight.normal),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
        ],
      ),
    );
  }

  _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25, top: 15, bottom: 10),
          child: Text(
            myAccount,
            style: TextStyle(
                color: black, fontSize: font15.sp, fontWeight: FontWeight.bold),
          ),
        ),
        Container(
          margin: EdgeInsets.only(left: 20, right: 20, top: 0, bottom: 0),
          decoration: BoxDecoration(
            color: tabBg,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 15),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0, top: 0, right: 15),
                  child: (bankLogo == "")
                      ? Image.asset(
                          'assets/bank.png',
                          height: 30.h,
                        )
                      : Image.network(
                          "$bankIconUrl$bankLogo",
                          width: 30.w,
                          height: 30.h,
                        ),
                ),
                Expanded(
                  flex: 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(name,
                          style: TextStyle(
                              color: black,
                              fontSize: font15.sp,
                              fontWeight: FontWeight.bold)),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text(accountNo,
                          style: TextStyle(color: black, fontSize: font12.sp)),
                      SizedBox(
                        height: 2.h,
                      ),
                      Text("Branch : $branchName",
                          style: TextStyle(color: black, fontSize: font12.sp)),
                    ],
                  ),
                )
              ],
            ),
          ),
        )
      ],
    );
  }

  _showConfirmWithDr(name, amount, accNo, branch) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: ConfirmWithDrl(
                name: name,
                amount: amount,
                accNo: accNo,
                branch: branch,
                mode: withdrawOptions,
                bankIfsc: bankIfsc,
              ),
            ));
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

    // print("response: ${response.body}");
    setState(() {
      loading = false;
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        if (data['status'].toString() == "1") {
          var result =
              Banks.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          bankList = result.data;
          // print("bankList: $bankList");

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
      } else {
        print("statusCode $statusCode");
      }
    });
  }
}

class ConfirmWithDrl extends StatefulWidget {
  final String name;
  final String amount;
  final String accNo;
  final String branch;
  final String mode;
  final String bankIfsc;

  const ConfirmWithDrl(
      {Key? key,
      required this.name,
      required this.amount,
      required this.accNo,
      required this.branch,
      required this.mode,
      required this.bankIfsc})
      : super(key: key);

  @override
  _ConfirmWithDrlState createState() => _ConfirmWithDrlState();
}

class _ConfirmWithDrlState extends State<ConfirmWithDrl> {
  var now = DateTime.now();
  var inputFormat = DateFormat('HH:mm');
  var exitTime = DateTime(DateTime.now().year, DateTime.now().month,
      DateTime.now().day, 18, 00, 00);

  var screen = "Confim Screen";

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => Wrap(
              children: [
                Container(
                    width: MediaQuery.of(context).size.width,
                    decoration: new BoxDecoration(
                        color: Colors.white,
                        borderRadius: new BorderRadius.only(
                            topLeft: const Radius.circular(40.0),
                            topRight: const Radius.circular(40.0))),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            height: 40.h,
                          ),
                          Center(
                              child: Image.asset(
                            'assets/pin_alert.png',
                            height: 72.h,
                          )),
                          SizedBox(
                            height: 10.h,
                          ),
                          Center(
                            child: Text(
                              "Withdrawal Request",
                              style:
                                  TextStyle(color: green, fontSize: font16.sp),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, top: 10),
                            child: Center(
                              child: Text(
                                "Amount will be transferred to your bank a/c\nwithin 24 working hours.",
                                style: TextStyle(
                                    color: black, fontSize: font13.sp),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40.0, right: 40, top: 20),
                            child: Row(
                              children: [
                                Text(
                                  "Amount",
                                  style: TextStyle(
                                      color: lightBlack, fontSize: font14.sp),
                                ),
                                Spacer(),
                                Text(
                                  "$rupeeSymbol ${widget.amount}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font16.sp,
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                          Divider(),
                          SizedBox(
                            height: 10.h,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 40.0, right: 30, top: 00),
                            child: Text(
                              "Transfer to",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font14.sp,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 40, top: 15, bottom: 10),
                                child: Text(
                                  myAccount,
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font15.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: EdgeInsets.only(
                                    left: 20, right: 20, top: 0, bottom: 0),
                                decoration: BoxDecoration(
                                  color: tabBg,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 15.0, bottom: 15),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: 25.0, top: 0, right: 15),
                                        child: Image.asset(
                                          'assets/banksym.png',
                                          height: 30.h,
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text("${widget.name}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font15.sp,
                                                    fontWeight:
                                                        FontWeight.bold)),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Text("${widget.accNo}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font12.sp)),
                                            SizedBox(
                                              height: 2.h,
                                            ),
                                            Text("Branch : ${widget.branch}",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font12.sp)),
                                          ],
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                          SizedBox(
                            height: 20.h,
                          ),
                          InkWell(
                            onTap: () {
                              /*if (now.isAfter(exitTime)) {
                        showAlertDialog(context, "${widget.amount}");
                      } else {
                        generatePayoutToken("${widget.amount}");
                      }*/
                              generatePayoutToken("${widget.amount}");
                            },
                            child: Container(
                              height: 45.h,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  top: 0, left: 30, right: 30, bottom: 20),
                              decoration: BoxDecoration(
                                color: lightBlue,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25)),
                              ),
                              child: Center(
                                child: Text(
                                  "Confirm".toUpperCase(),
                                  style: TextStyle(
                                      fontSize: font13.sp, color: white),
                                ),
                              ),
                            ),
                          )
                        ]))
              ],
            ));
  }

  Future generatePayoutToken(amount) async {
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
      withdrawWalletRequest(amount, token);
    } else {
      setState(() {
        showToastMessage(somethingWrong);
      });
    }
  }

  Future withdrawWalletRequest(amount, token) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();
    var email = await getEmail();
    var mobile = await getMobile();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "bene_account": "${widget.accNo}",
      "ifsc_jcode": "${widget.bankIfsc}",
      "bene_name": "${widget.name}",
      "bene_email": "$email",
      "mobile": "$mobile",
      "purpose": "Investment Withdrawal",
      "amount": "$amount",
      "paymentType": "${widget.mode}",
      "receipt_card_no": "",
      "access_token": "$token"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(payoutInvestmentAPI),
        body: jsonEncode(body), headers: headers);

    var statusCode = response.statusCode;

    Navigator.pop(context);

    printMessage(screen, "Response statusCode : $statusCode");

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Settelment : $data");

      var status = data['status'].toString();

      if (status == "1") {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return showMessageDialog(
                  message:
                      "Your request is submitted successfully.\nYou may check your transaction status in Investor dashboard after 5 minutes.",
                  action: 4);
            });
      } else {
        showToastMessage(data['message'].toString());
      }
    } else {
      setState(() {
        showToastMessage(status500);
      });
    }
  }
}
