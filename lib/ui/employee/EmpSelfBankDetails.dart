import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moneypro_new/ui/footer/WelcomeOfferPopup.dart';
import 'package:moneypro_new/ui/models/Banks.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/AppKeys.dart';


class EmpSelfBankDetails extends StatefulWidget {
  final Map itemResponse;

  const EmpSelfBankDetails({Key? key, required this.itemResponse})
      : super(key: key);

  @override
  _EmpSelfBankDetailsState createState() => _EmpSelfBankDetailsState();
}

class _EmpSelfBankDetailsState extends State<EmpSelfBankDetails> {
  TextEditingController accountNameController = new TextEditingController();
  final accountNoController = new TextEditingController();
  final ifscController = new TextEditingController();

  late TextEditingController branchNameController;

  List<String> accountTypes = [
    "Current Account",
    "Saving Account",
    "OD Account",
  ];

  var selectAccountType;

  var screen = "Bank detail";

  Map newItem = {};

  var loading = false;

  var loadIfsc = false;

  var bankName = "";

  List<BankList> bankList = [];
  BankList distL = new BankList();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      branchNameController = new TextEditingController();
    }
    updateATMStatus(context);
    fetchUserAccountBalance();
    setState(() {
      newItem = widget.itemResponse;
    });

    getBankList();

    setState(() {
      accountNameController = TextEditingController(
          text: "${newItem['client_nam'].toString().toUpperCase()}");
    });
  }

  @override
  void dispose() {
    accountNameController.dispose();
    accountNoController.dispose();
    ifscController.dispose();
    branchNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          printMessage(screen, "Mobile back pressed");
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return NoExitDialog();
              });
          return false;
        },
        child: SafeArea(
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
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return NoExitDialog();
                    });
              },
              child: Container(
                height: 60,
                width: 60,
                child: Stack(
                  children: [
                    Image.asset(
                      'assets/back_arrow_bg.png',
                      height: 60,
                    ),
                    Positioned(
                      top: 16,
                      left: 12,
                      child: Image.asset(
                        'assets/back_arrow.png',
                        height: 16,
                      ),
                    )
                  ],
                ),
              ),
            ),
            actions: [
              Image.asset(
                'assets/faq.png',
                width: 24,
                color: orange,
              ),
              SizedBox(
                width: 10,
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
                        height: 40,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "$accDetails",
                          style: TextStyle(
                              color: black,
                              fontSize: font14,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      Container(
                        height: 45,
                        margin: EdgeInsets.only(
                            top: 25, left: padding, right: padding),
                        decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(color: black, fontSize: inputFont),
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
                        height: 45,
                        margin: EdgeInsets.only(
                            top: 15, left: padding, right: padding),
                        decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(color: black, fontSize: inputFont),
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
                            style: TextStyle(color: black, fontSize: font16),
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
                                            height: 24,
                                            width: 24,
                                            child:
                                                Image.asset('assets/bank.png'),
                                          )
                                        : Image.network(
                                            "$bankIconUrl${value.logo}",
                                            width: 30,
                                            height: 30,
                                          ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
                                      child: Text(
                                        value.bankName,
                                        style: TextStyle(
                                            color: black,
                                            fontSize: font14,
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
                              });
                            },
                          ),
                        ),
                      ),
                      Container(
                        height: 45,
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
                                      color: black, fontSize: inputFont),
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
                      Container(
                        height: 45,
                        margin: EdgeInsets.only(
                            top: 15, left: padding, right: padding),
                        decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(color: black, fontSize: inputFont),
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            controller: branchNameController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              counterText: "",
                              label: Text("Branch name"),
                            ),
                            maxLength: 80,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
                        decoration: BoxDecoration(
                            color: editBg,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            border: Border.all(color: editBg)),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: selectAccountType,
                            style: TextStyle(color: black, fontSize: font13),
                            items: accountTypes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Text(
                                    value,
                                    style: TextStyle(color: black),
                                  ),
                                ),
                              );
                            }).toList(),
                            hint: Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Text(
                                "Account type",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font13),
                              ),
                            ),
                            icon: Padding(
                              padding: const EdgeInsets.only(right: 15.0),
                              child: Icon(
                                // Add this
                                Icons.keyboard_arrow_down, // Add this
                                color: lightBlue, // Add this
                              ),
                            ),
                            onChanged: (value) {
                              setState(() {
                                selectAccountType = value!;
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
                              });
                            },
                          ),
                        ),
                      ),
                    ])),
          bottomNavigationBar: InkWell(
            onTap: () {
              getDetail();
            },
            child: Container(
              height: 45,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Text(
                  continue_.toUpperCase(),
                  style: TextStyle(fontSize: font13, color: white),
                ),
              ),
            ),
          ),
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

  getDetail() {
    var accountName = accountNameController.text.toString();
    var accountNo = accountNoController.text.toString();
    var ifscCode = ifscController.text.toString();
    var branchName = branchNameController.text.toString();

    if (accountName.length == 0) {
      showToastMessage("Enter account name");
      return;
    } else if (accountNo.length == 0) {
      showToastMessage("Enter account number");
      return;
    } else if (ifscCode.length == 0) {
      showToastMessage("Enter IFSC code");
      return;
    } else if (bankName.length == 0 ||
        bankName.toString() == "Select your bank") {
      showToastMessage("select your bank");
      return;
    } else if (branchName.length == 0) {
      showToastMessage("Enter branch name");
      return;
    } else if (selectAccountType.toString() == "null") {
      showToastMessage("Select account type");
      return;
    }

    newItem['accountName'] = accountName.toString();
    newItem['accountNo'] = accountNo.toString();
    newItem['ifscCode'] = ifscCode.toString();
    newItem['bankName'] = bankName.toString();
    newItem['branchName'] = branchName.toString();
    newItem['selectAccountType'] = selectAccountType.toString();

    printMessage(screen, "Account Type : $newItem");

    saveDetails();
  }

  Future saveDetails() async {
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
    };

    final body = {
      "token": token,
      "pan": newItem['pan'],
      "account_no": newItem['accountNo'],
      "holder_name": newItem['accountName'],
      "ifsc": newItem['ifscCode'],
      "bnk_name": newItem['bankName'],
      "branch": newItem['branchName'],
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(userOnBoardingAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          showWelcomeOfferPopup(3);
        }

        showToastMessage(data['message'].toString());
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
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
          var bankName = data['data']['bank'].toString();
          var branchName = data['data']['branch'].toString();
          var branchCity = data['data']['city'].toString();
          var branchState = data['data']['state'].toString();
          var branchAddress = data['data']['address'].toString();

          branchNameController = TextEditingController(text: "$branchName");
        } else {
          showToastMessage(somethingWrong);
        }
      });
    } catch (e) {
      loadIfsc = false;
    }
  }

  showWelcomeOfferPopup(action) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => WelcomeOfferPopup(action: action));
  }
}
