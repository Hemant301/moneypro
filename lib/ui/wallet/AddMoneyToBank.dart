import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:moneypro_new/ui/models/Banks.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class AddMoneyToBank extends StatefulWidget {
  const AddMoneyToBank({Key? key}) : super(key: key);

  @override
  _AddMoneyToBankState createState() => _AddMoneyToBankState();
}

class _AddMoneyToBankState extends State<AddMoneyToBank> {
  var loading = false;

  var name = "";
  var accountNo = "";
  var branchName = "";
  var bankName = "";
  var bankIFSC = "";
  var bankLogo = "";

  var screen = "Add Money Bank";

  List<BankList> bankList = [];

  var _isAutoInvest = false;
  var showMpWall = false;

  var qrAmount = "";
  var mprWalAmt = "";
  var settleType = "";

  TextEditingController upiAmtController = new TextEditingController();
  TextEditingController walletAmtController = new TextEditingController();

  var upiQRvalue = false;
  var mpWallValue = false;
  String withdrawOptions = "IMPS";

  BestTutorSite _site = BestTutorSite.imps;

  var approved = "";

  @override
  void initState() {
    super.initState();
    getUserDetails();
    updateATMStatus(context);
    fetchUserAccountBalance();
    getWalletBalFromPrefs();

    getBankList();
  }

  getWalletBalFromPrefs() async {
    var role = await getRole();
    var bC = await getBranchCreate();

    printMessage(screen, "Role : $role");

    var qrAmt = await getQRMaxAmt();

    var walAmt = await getWalletBalance();
    var status = await getQRInvestor();

    var mAtmStatus = await getMatmStatus();
    var aepsStatus = await getAepsStatus();
    var dmtStatus = await getDmtStatus();

    var fn = await getFirstName();
    var ln = await getLastName();
    var na = await getHolderName();

    var acNo = await getAccountNumber();
    var bCity = await getBranchCity();
    var bName = await getBankName();

    var s = await getSettlementType();

    var app = await getApproved();

    setState(() {
      if (status.toString().toLowerCase() == "yes") {
        _isAutoInvest = true;
      } else {
        _isAutoInvest = false;
      }
      approved = app;
    });

    setState(() {
      name = "$na";
      accountNo = acNo;
      branchName = bCity;
      bankName = bName;
      if (bankName.contains(".")) bankName = bankName.replaceAll(".", "");
      settleType = s;
    });

    setState(() {
      printMessage(screen, "bC : $bC");
      if (bC.toString() == "1") {
        getMaxWithdrlAmt();
      } else {
        qrAmount = qrAmt;
      }

      mprWalAmt = walAmt;

      if (mAtmStatus.toString() == "1" ||
          aepsStatus.toString() == "1" ||
          dmtStatus.toString() == "1") {
        if (role.toString() == "3") {
          showMpWall = true;
        }
      }

      printMessage(screen, "Show MP Wall : $showMpWall");
    });

    printMessage(screen, "bankName : $bankName");
  }

  getUserDetails() async {
    var fn = await getFirstName();
    var ln = await getLastName();

    var acNo = await getAccountNumber();
    var bCity = await getBranchCity();
    var iCode = await getIFSC();

    setState(() {
      name = "$fn $ln";
      accountNo = acNo;
      branchName = bCity;
      bankIFSC = iCode;
    });
  }

  @override
  void dispose() {
    upiAmtController.dispose();
    walletAmtController.dispose();
    super.dispose();
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
        actions: [
          Image.asset(
            'assets/faq.png',
            width: 30.w,
            color: orange,
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
                  appSelectedBanner(context, "invest_banner.png", 150.0.h),
                 // _buildUPIWallet(),
                  (showMpWall) ? _buildMoneyWallet() : Container(),
                  (showMpWall)
                      ? Padding(
                          padding:
                              EdgeInsets.only(top: 15, left: 25, right: 25),
                          child: Row(
                            children: [
                              Text(
                                autoInvest,
                                style:
                                    TextStyle(color: black, fontSize: font16.sp),
                              ),
                              Spacer(),
                              FlutterSwitch(
                                  width: 60.0,
                                  height: 26.0,
                                  valueFontSize: 14.0,
                                  toggleSize: 24.0,
                                  activeText: "Y",
                                  inactiveText: "N",
                                  value: _isAutoInvest,
                                  borderRadius: 30.0,
                                  padding: 4.0,
                                  showOnOff: true,
                                  onToggle: (value) {
                                    setState(() {
                                      _isAutoInvest = value;
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
                  _buildAccountSection(),
                  SizedBox(
                    height: 20.h,
                  ),
                ])),
      bottomNavigationBar: _buildBottonSubmit(),
    )));
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

  _buildUPIWallet() {
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
                  "$upiQRWallet",
                  style: TextStyle(
                      color: black,
                      fontSize: font15.sp,
                      fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Checkbox(
                    value: upiQRvalue,
                    onChanged: (val) {
                      setState(() {
                        closeKeyBoard(context);
                        upiQRvalue = val!;
                        mpWallValue = false;
                      });
                    }),
                SizedBox(
                  width: 10.w,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, top: 0),
            child: Text(
              enterAmount,
              style: TextStyle(
                  color: black, fontSize: font15.sp, fontWeight: FontWeight.bold),
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
                  controller: upiAmtController,
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
              "$youCanWithdraw $rupeeSymbol $qrAmount",
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
                        upiQRvalue = false;
                      });
                    }),
                SizedBox(
                  width: 10.w,
                )
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25, top: 0),
            child: Text(
              enterAmount,
              style: TextStyle(
                  color: black, fontSize: font15.sp, fontWeight: FontWeight.bold),
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

  _buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.only(left: 25, top: 10, bottom: 10),
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
                      ? SizedBox(
                          height: 30.h,
                          width: 30.w,
                          child: Image.asset(
                            'assets/bank.png',
                            height: 30.h,
                          ),
                        )
                      : SizedBox(
                          height: 30.h,
                          width: 30.w,
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

  _buildBottonSubmit() {
    return InkWell(
      onTap: () {
        setState(() {
          closeKeyBoard(context);

          if (/*!upiQRvalue && */!mpWallValue) {
            showToastMessage("Select wallet to withdraw amount");
            return;
          }

          /*if (upiQRvalue) {
            var amount = upiAmtController.text.toString();

            if (amount == "0" || amount.length == 0) {
              showToastMessage("enter amount");
              return;
            }

            double a = double.parse(amount);
            double maxAmount = double.parse(qrAmount);

            printMessage(screen, "Amount is : $a");
            printMessage(screen, "Amount max : $maxAmount");

            if (a > maxAmount) {
              showToastMessage("You do not have enough balance");
            } else {
              if (settleType.toString().toLowerCase() == "default") {
                withdrawUPIRequest(amount);
              } else {
                showToastMessage(
                    "You are not eligible to withdraw as your withdrawal set to $settleType. To change please contact customer support.");
              }
            }
          }*/

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

            /*if (withdrawOptions.toString() == "IMPS") {
              if (amt < 25000) {
                amt = amt + 5;
              } else {
                amt = amt + 10;
              }
            } else {
              amt = amt + 3;
            }*/

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
        margin: EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
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
    );
  }

  Future withdrawUPIRequest(amount) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var m_id = await getMerchantID();
    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"m_id": m_id, "amount": "$amount", "token": "$token"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(merchantQrWithdrawlAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Settelment : $data");

      setState(() {
        Navigator.pop(context);
        showToastMessage(data['message'].toString());
        updateATMStatus(context);
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  Future withdrawWalletRequest1(amount) async {
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

    final body = {
      "token": token,
      "amount": "$amount",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(walletBalanceWithdrawlAPI),
        body: jsonEncode(body), headers: headers);

    var statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Settelment : $data");

      setState(() {
        Navigator.pop(context);
        showToastMessage(data['message'].toString());
        updateATMStatus(context);
        closeCurrentPage(context);
      });
    } else {
      setState(() {
        Navigator.pop(context);
        showToastMessage(somethingWrong);
      });
    }
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
      "ifsc_jcode": "$bankIFSC",
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

  Future getMaxWithdrlAmt() async {
    setState(() {
      loading = true;
    });

    var token = await getToken();
    var qrWltAmt = await getQRBalance();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$token",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchMaxWithdrawlAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Branch : $data");

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          var xx = data['branch_total'];
          double mXXAmt = double.parse(qrWltAmt) - xx;
          qrAmount = mXXAmt.toString();
        }
      });
    } else {
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }
  }
}
