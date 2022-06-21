import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/Banks.dart';
import 'package:moneypro_new/utils/Apicall.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/AppKeys.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

import '../../utils/CustomWidgets.dart';
import 'package:http/http.dart' as http;

class Withdrwal extends StatefulWidget {
  final bool isMWalletShow;
  final bool isInvestShow;
  final double maxAmt;

  const Withdrwal(
      {Key? key,
      required this.isMWalletShow,
      required this.isInvestShow,
      required this.maxAmt})
      : super(key: key);

  @override
  State<Withdrwal> createState() => _WithdrwalState();
}

class _WithdrwalState extends State<Withdrwal> {
  final amountController = new TextEditingController();
  TextEditingController walletAmtController = new TextEditingController();

  var name = "";
  var accountNo = "";
  var branchName = "";
  var bankName = "";
  var bankIfsc = "";

  var bankLogo = "";

  var screen = "Withdrwal";

  double maxAmount = 0.0;

  var loading = false;

  List<BankList> bankList = [];

  var approved = "";

  var mpWallValue = false;
  var investValue = false;
  var mprWalAmt = "";
  String withdrawOptions = "IMPS";
  BestTutorSite _site = BestTutorSite.imps;

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    getWalletBalFromPrefs();
    printMessage(screen, "Max Amt : ${widget.maxAmt}");
    getBankList();
    setState(() {
      maxAmount = widget.maxAmt;
    });

    fetchBankList();
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

    var walAmt = await getWalletBalance();

    var app = await getApproved();

    setState(() {
      name = "$fn $ln";
      // accountNo = acNo;
      // branchName = bCity;
      // bankName = bName;
      // bankIfsc = bIFSC;
      if (bankName.contains(".")) bankName = bankName.replaceAll(".", "");
      mprWalAmt = walAmt;
      approved = app;
    });

    printMessage(screen, "bankName : $bankName");
  }

  @override
  void dispose() {
    amountController.dispose();
    walletAmtController.dispose();
    super.dispose();
  }

  fetchBankList() async {
    Map data = await homeapi.fetchBankList();
    print(data);
    if (data['status'].toString() == "1") {
      setState(() {
        bankData = data;
      });
    } else {
      setState(() async {
        selectLabel = await getAccountNumber();
        accountNo = await getAccountNumber();
        branchName = await getBranchCity();
        bankName = await getBankName();
        bankIfsc = await getIFSC();
        is_selected = 1;
      });
    }
    ;
  }

  String selectLabel = "Select Bank Account";
  bool dropdownIndex = false;
  int is_selected = 0;

  Map bankData = {};

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
              body: SingleChildScrollView(
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    // _buildAccountSection(),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 22),
                      child: Column(
                        children: [
                          InkWell(
                            onTap: () {
                              if (bankData.isEmpty) {
                                return;
                              }
                              if (dropdownIndex == false) {
                                setState(() {
                                  dropdownIndex = true;
                                });
                              } else {
                                setState(() {
                                  dropdownIndex = false;
                                });
                              }
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 14),
                              decoration: BoxDecoration(
                                  color: editBg,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text('$selectLabel'),
                                    bankData.isEmpty
                                        ? Container()
                                        : Icon(dropdownIndex == true
                                            ? Icons.arrow_upward
                                            : Icons.arrow_downward)
                                  ]),
                            ),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          dropdownIndex == false
                              ? Container()
                              // : bankData['accounts'].length == 0
                              //     ? Text('No data found')
                              : Column(
                                  children: List.generate(
                                  bankData['accounts'].length,
                                  (index) => Align(
                                      alignment: Alignment.topLeft,
                                      child: InkWell(
                                        onTap: () {
                                          setState(() {
                                            is_selected = 1;
                                            selectLabel = bankData['accounts']
                                                [index]['account'];
                                            accountNo = bankData['accounts']
                                                    [index]['account']
                                                .toString();
                                            branchName = bankData['accounts']
                                                    [index]['bank_name']
                                                .toString();
                                            bankName = bankData['accounts']
                                                    [index]['bank_name']
                                                .toString();
                                            bankIfsc = bankData['accounts']
                                                    [index]['ifsc']
                                                .toString();
                                            dropdownIndex = false;
                                          });
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(4.0),
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width -
                                              50,
                                          decoration: BoxDecoration(
                                            color: editBg,
                                          ),
                                          child: Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(bankData['accounts']
                                                      [index]['bank_name']),
                                                  Text(
                                                    bankData['accounts'][index]
                                                        ['account'],
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                  Divider()
                                                ],
                                              )),
                                        ),
                                      )),
                                )),
                          is_selected == 1
                              ? Container(
                                  padding: EdgeInsets.symmetric(
                                      vertical: 20, horizontal: 20),
                                  decoration: BoxDecoration(
                                      color: invBoxBg,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Row(
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Account No',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Branch Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Bank Name',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            'Bank Ifsc',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                      SizedBox(
                                        width: 20,
                                      ),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text('$accountNo'),
                                          Text('$branchName'),
                                          Text("$bankName"),
                                          Text('$bankIfsc'),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    (widget.isMWalletShow) ? _buildMoneyWallet() : Container(),
                    (widget.isInvestShow) ? _buildInputSection() : Container(),
                  ])),
              bottomNavigationBar: InkWell(
                onTap: () {
                  if (is_selected == 0) {
                    Fluttertoast.showToast(
                        msg: 'Select Bank Account to proceed');
                    return;
                  }
                  setState(() {
                    closeKeyBoard(context);

                    if (!investValue && !mpWallValue) {
                      showToastMessage("Select any one");
                      return;
                    }

                    if (investValue) {
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
                    }

                    if (mpWallValue) {
                      printMessage(screen, "Options : $_site");

                      if (_site.toString() == "BestTutorSite.imps") {
                        setState(() {
                          withdrawOptions = "IMPS";
                        });
                      } else if (_site.toString() == "BestTutorSite.neft") {
                        setState(() {
                          withdrawOptions = "NEFT";
                        });
                      }

                      var amount = walletAmtController.text.toString();

                      if (amount == "0" || amount.length == 0) {
                        showToastMessage("enter amount");
                        return;
                      } else if (withdrawOptions.length == 0) {
                        showToastMessage("Select IMPS or NEFT");
                        return;
                      }

                      printMessage(screen, "Amount is : $amount");

                      double amt = double.parse(amount);
                      double maxAmount = double.parse(mprWalAmt);

                      printMessage(screen, "Amount is : $amt");
                      printMessage(screen, "Amount max : $maxAmount");

                      if (amt > maxAmount) {
                        showToastMessage("You do not have enough balance");
                      } else {
                        generatePayoutToken(amount);
                      }
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

  _buildMoneyWallet() {
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
            padding: EdgeInsets.only(left: 25, top: 5),
            child: Row(
              children: [
                Text(
                  "$wallet",
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Checkbox(
                    value: mpWallValue,
                    onChanged: (val) {
                      setState(() {
                        closeKeyBoard(context);
                        mpWallValue = val!;
                        investValue = false;
                      });
                    }),
                SizedBox(
                  width: 10.w,
                )
              ],
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
                  textInputAction: TextInputAction.done,
                  controller: walletAmtController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 10),
                    counterText: "",
                    hintText: "$enterAmount",
                    hintStyle: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                    ),
                  ),
                  maxLength: 7,
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, top: 10),
            child: Text(
              //"Wallet amount $rupeeSymbol ${formatDecimal2Digit.format(double.parse(mprWalAmt))}",
              "Wallet amount $rupeeSymbol $mprWalAmt",
              style: TextStyle(
                  color: black,
                  fontSize: font13.sp,
                  fontWeight: FontWeight.normal),
            ),
          ),
          Row(
            children: [
              Expanded(
                flex: 1,
                child: ListTile(
                  title: const Text('IMPS'),
                  minLeadingWidth: 10.0,
                  leading: Radio(
                      value: BestTutorSite.imps,
                      groupValue: _site,
                      onChanged: (value) {
                        setState(() {
                          _site = BestTutorSite.imps;
                        });
                      }),
                ),
              ),
              Expanded(
                flex: 1,
                child: ListTile(
                  title: const Text('NEFT'),
                  minLeadingWidth: 10.0,
                  leading: Radio(
                      value: BestTutorSite.neft,
                      groupValue: _site,
                      onChanged: (value) {
                        setState(() {
                          _site = BestTutorSite.neft;
                        });
                      }),
                ),
              ),
            ],
          ),
          _buildChangesNotes(),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
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
            padding: EdgeInsets.only(left: 25, top: 20, right: 25),
            child: Row(
              children: [
                Text(
                  "Investment Withdrawal",
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Checkbox(
                    value: investValue,
                    onChanged: (val) {
                      setState(() {
                        closeKeyBoard(context);
                        investValue = val!;
                        mpWallValue = false;
                      });
                    }),
                SizedBox(
                  width: 10.w,
                )
              ],
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
                    hintText: "$enterAmount",
                    hintStyle: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                    ),
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
                      : SizedBox(
                          width: 30.w,
                          height: 30.h,
                          child: Image.network(
                            "$bankIconUrl$bankLogo",
                            width: 30.w,
                            height: 30.h,
                          ),
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

  _buildChangesNotes() {
    return Padding(
      padding: const EdgeInsets.only(left: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "*Charges are applicable",
            style: TextStyle(
                color: black, fontSize: font14.sp, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            "For IMPS transaction",
            style: TextStyle(
                color: black,
                fontSize: font14.sp,
                decoration: TextDecoration.underline),
          ),
          Text(
            "$rupeeSymbol 5/transaction upto $rupeeSymbol 25,000 and above $rupeeSymbol 25,000 $rupeeSymbol 10/transaction ",
            style: TextStyle(color: black, fontSize: font13.sp),
          ),
          SizedBox(
            height: 4.h,
          ),
          Text(
            "For NEFT transaction",
            style: TextStyle(
                color: black,
                fontSize: font14.sp,
                decoration: TextDecoration.underline),
          ),
          Text(
            "$rupeeSymbol 3/transaction",
            style: TextStyle(color: black, fontSize: font13.sp),
          ),
          SizedBox(
            height: 10.h,
          ),
        ],
      ),
    );
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
      "bene_account": "$accountNo",
      "ifsc_jcode": "$bankIfsc",
      "bene_name": "$name",
      "bene_email": "$email",
      "mobile": "$mobile",
      "purpose": "Wallet Withdrawal",
      "amount": "$amount",
      "paymentType": "$withdrawOptions",
      "receipt_card_no": "",
      "access_token": "$token"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(payoutInitiateAPI),
        body: jsonEncode(body), headers: headers);

    var statusCode = response.statusCode;

    printMessage(screen, "Response Settelment : $statusCode");
    Navigator.pop(context);

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
                      "Your request is submitted successfully.\nYou may check your transaction status in History after 5 minutes.",
                  action: 3);
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
