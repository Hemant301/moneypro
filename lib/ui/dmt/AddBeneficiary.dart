import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/Banks.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class AddBeneficiary extends StatefulWidget {
  final String custId;

  const AddBeneficiary({Key? key, required this.custId}) : super(key: key);

  @override
  _AddBeneficiaryState createState() => _AddBeneficiaryState();
}

class _AddBeneficiaryState extends State<AddBeneficiary> {
  var screen = "AddBeneficiary";

  var loading = false;

  final accountNameController = new TextEditingController();
  final accountNoController = new TextEditingController();
  final ifscController = new TextEditingController();
  final mobileController = new TextEditingController();
  final remarksController = new TextEditingController();

  var loadIfsc = false;

  var bankName = "";
  String branchName = "";
  String branchCity = "";
  String branchState = "";
  String branchAddress = "";
  var bankLogo = "";

  var isBankDataLoaded = false;

  List<BankList> bankList = [];
  BankList distL = new BankList();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getBankList();
    updateATMStatus(context);
    updateWalletBalances();
    fetchUserAccountBalance();
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();
    double mX = 0.0;
    double wX = 0.0;

    final inheritedWidget = StateContainer.of(context);

    if (mpBalc == null || mpBalc == 0) {
      mpBalc = 0;
      inheritedWidget.updateMPBalc(value: mpBalc);
    } else {
      inheritedWidget.updateMPBalc(value: mpBalc);
    }

    if (qrBalc == null || qrBalc == 0) {
      qrBalc = 0;
      inheritedWidget.updateQRBalc(value: qrBalc);
    } else {
      inheritedWidget.updateQRBalc(value: qrBalc);
    }

    if (walBalc == null || walBalc == 0) {
      walBalc = 0;
      inheritedWidget.updateWelBalc(value: walBalc);
    } else {
      inheritedWidget.updateWelBalc(value: walBalc);
    }

    if (walBalc != null || walBalc != 0) {
      wX = double.parse(walBalc);
    }

    if (mpBalc != null || mpBalc != 0) {
      mX = double.parse(mpBalc);
    }
    setState(() {
      //mainWallet = wX + mX;
    });
  }

  @override
  Widget build(BuildContext context) {
    final InheritedWidget = StateContainer.of(context);
    var moneyProBalc = InheritedWidget.mpBalc;
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
              padding: const EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Image.asset(
                    "assets/wallet.png",
                    height: 20.h,
                  ),
                  Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, right: 10, top: 5),
                      child: Text(
                        moneyProBalc,
                        style: TextStyle(color: white, fontSize: font15.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        enterBeneficiary,
                        style: TextStyle(
                            color: black,
                            fontSize: font16.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Container(
                      height: 45.h,
                      margin: EdgeInsets.only(
                          top: 10, left: padding, right: padding),
                      decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: TextFormField(
                          style: TextStyle(color: black, fontSize: inputFont.sp),
                          keyboardType: TextInputType.name,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          controller: accountNameController,
                          decoration: new InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 20),
                            counterText: "",
                            label: Text("Account name"),
                          ),
                          maxLength: 100,
                        ),
                      ),
                    ),
                    Container(
                      height: 45.h,
                      margin: EdgeInsets.only(
                          top: 15, left: padding, right: padding),
                      decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: TextFormField(
                          style: TextStyle(color: black, fontSize: inputFont.sp),
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          controller: accountNoController,
                          decoration: new InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 20),
                            counterText: "",
                            label: Text("Account number"),
                          ),
                          maxLength: 16,
                        ),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 15, left: 20, right: 20),
                      decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                          border: Border.all(color: editBg)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<BankList>(
                          isExpanded: true,
                          value: distL,
                          style: TextStyle(color: black, fontSize: font16.sp),
                          items: bankList.map<DropdownMenuItem<BankList>>(
                              (BankList value) {
                            return DropdownMenuItem<BankList>(
                              value: value,
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10,
                                  ),
                                  (value.logo == "")
                                      ? Container(
                                          height: 24.h,
                                          width: 24.w,
                                          child: Image.asset('assets/bank.png'),
                                        )
                                      : Image.network(
                                          "$bankIconUrl${value.logo}",
                                          width: 30.w,
                                          height: 30.h,
                                        ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 15.0),
                                    child: Text(
                                      value.bankName,
                                      style: TextStyle(
                                          color: black,
                                          fontSize: font14.sp,
                                          fontWeight: FontWeight.normal),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          icon: Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: Colors.blue,
                            ),
                          ),
                          onChanged: (value) {
                            setState(() {
                              closeKeyBoard(context);
                              distL = value!;
                              bankName = distL.bankName!;
                              bankLogo = distL.logo;
                            });
                          },
                        ),
                      ),
                    ),
                    Container(
                      height: 45.h,
                      margin: EdgeInsets.only(
                          top: 15, left: padding, right: padding),
                      decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Center(
                              child: TextFormField(
                                style: TextStyle(
                                    color: black, fontSize: inputFont.sp),
                                keyboardType: TextInputType.text,
                                textCapitalization:
                                    TextCapitalization.characters,
                                textInputAction: TextInputAction.next,
                                controller: ifscController,
                                decoration: new InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding: EdgeInsets.only(left: 20),
                                  counterText: "",
                                  label: Text("IFSC code"),
                                ),
                                maxLength: 11,
                                onChanged: (val) {
                                  if (val.length == 11) {
                                    closeKeyBoard(context);
                                    generatePayoutToken(
                                        ifscController.text.toString());
                                  }
                                },
                              ),
                            ),
                          ),
                          (loadIfsc)
                              ? Padding(
                                  padding: const EdgeInsets.only(right: 15.0),
                                  child: circularProgressLoading(20.0),
                                )
                              : Container()
                        ],
                      ),
                    ),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 25.0, top: 5, bottom: 10),
                      child: Text(
                        ifscTag,
                        style: TextStyle(
                            color: black,
                            fontSize: font12.sp,
                            fontWeight: FontWeight.normal),
                      ),
                    ),
                    Container(
                      height: 45.h,
                      margin: EdgeInsets.only(
                          top: 15, left: padding, right: padding),
                      decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: TextFormField(
                          style: TextStyle(color: black, fontSize: inputFont.sp),
                          keyboardType: TextInputType.number,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          controller: mobileController,
                          decoration: new InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 20),
                            counterText: "",
                            label: Text(bankMob),
                          ),
                          maxLength: 10,
                        ),
                      ),
                    ),
                    Container(
                      height: 45.h,
                      margin: EdgeInsets.only(
                          top: 15, left: padding, right: padding),
                      decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                      ),
                      child: Center(
                        child: TextFormField(
                          style: TextStyle(color: black, fontSize: inputFont.sp),
                          keyboardType: TextInputType.text,
                          textCapitalization: TextCapitalization.characters,
                          textInputAction: TextInputAction.next,
                          controller: remarksController,
                          decoration: new InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 20),
                            counterText: "",
                            label: Text(bankRemarks),
                          ),
                          maxLength: 100,
                        ),
                      ),
                    ),
                    (isBankDataLoaded)
                        ? Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, top: 20),
                            child: Container(
                              decoration: BoxDecoration(
                                  color: bankBox,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(color: bankBox, width: 2)),
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, top: 15, bottom: 15),
                                child: Row(
                                  children: [
                                    Image.network(
                                      "$bankIconUrl${bankLogo}",
                                      width: 55.w,
                                      height: 55.h,
                                    ),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, top: 0),
                                            child: Text(
                                              bankName,
                                              style: TextStyle(
                                                color: black,
                                                fontSize: font16.sp,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, top: 4),
                                            child: Text(
                                              "Branch Name : $branchName",
                                              style: TextStyle(
                                                color: black,
                                                fontSize: font16.sp,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, top: 4),
                                            child: Text(
                                              "City : $branchCity",
                                              style: TextStyle(
                                                color: black,
                                                fontSize: font16.sp,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, top: 4),
                                            child: Text(
                                              "State : $branchState",
                                              style: TextStyle(
                                                color: black,
                                                fontSize: font16.sp,
                                              ),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10.0, top: 4),
                                            child: Text(
                                              "Address : $branchAddress",
                                              style: TextStyle(
                                                color: black,
                                                fontSize: font16.sp,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          )
                        : Container(),
                  ]),
            ),
      bottomNavigationBar: _buildBottomSection(),
    )));
  }

  _buildBottomSection() {
    return Container(
      height: 60.h,
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          InkWell(
            onTap: () {
              setState(() {
                addBeneficiary();
              });
            },
            child: Container(
              height: 50.h,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 0),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Text(
                  "Add",
                  style: TextStyle(fontSize: font15.sp, color: white),
                ),
              ),
            ),
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
          BankList dState1 = new BankList(
              id: "0",
              bankName: "Select your bank",
              status: "",
              logo: "",
              createdAt: "",
              updatedAt: "");
          bankList = result.data;
          bankList.insert(0, dState1);
          distL = bankList[0];
        }
      }
    });
  }

  Future generatePayoutToken(code) async {
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
      getBankDetails(token, code);
    } else {
      setState(() {
        showToastMessage(somethingWrong);
      });
    }
  }

  Future getBankDetails(accessToken, code) async {
    try {
      setState(() {
        loadIfsc = true;
      });

      var headers = {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
        "payoutMerchantId": "$payoutMerchantId"
      };

      final response =
          await http.get(Uri.parse("$ifscCodeAPI$code"), headers: headers);

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "IFSC Code : $data");

      setState(() {
        loadIfsc = false;

        if (data['status'].toString() == "0") {
          bankName = data['data']['bank'].toString();
          branchName = data['data']['branch'].toString();
          branchCity = data['data']['city'].toString();
          branchState = data['data']['state'].toString();
          branchAddress = data['data']['address'].toString();
          isBankDataLoaded = true;
        } else {
          isBankDataLoaded = false;
        }
      });
    } catch (e) {
      loadIfsc = false;
    }
  }

  Future addBeneficiary() async {
    var mechantId = await getMerchantID();
    var holderName = accountNameController.text.toString();
    var accountNumber = accountNoController.text.toString();
    var mobile = mobileController.text.toString();
    var ifsc = ifscController.text.toString();

    if (holderName.length < 2) {
      showToastMessage("Enter name");
      return;
    } else if (accountNumber.length < 8) {
      showToastMessage("Enter account number");
      return;
    } else if (ifsc.length != 11) {
      showToastMessage("Enter 11 digit IFSC Code number");
      return;
    }

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

    final body = {
      "m_id": mechantId,
      "accountNumber": accountNumber,
      "mobile": mobile,
      "ifsc": ifsc,
      "holderName": holderName,
      "favourit": "0",
      "customer_id": widget.custId,
    };

    printMessage(screen, "headers : $body");

    final response = await http.post(Uri.parse(dmtAddBeneficialAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "IFSC Code : $data");

      setState(() {
        Navigator.pop(context);

        if (data['status'].toString() == "1") {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ThankYouDialog(
                  text: data['message'].toString(),
                  isCloseAll: "0".toString(),
                );
              });
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    }else{
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }

  }
}
