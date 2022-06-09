import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';

class MerchantInvestorBank extends StatefulWidget {
  final Map map;
  const MerchantInvestorBank({Key? key, required this.map}) : super(key: key);

  @override
  _MerchantInvestorBankState createState() => _MerchantInvestorBankState();
}

class _MerchantInvestorBankState extends State<MerchantInvestorBank> {
  TextEditingController accountNameController = new TextEditingController();
  TextEditingController accountNoController = new TextEditingController();
  TextEditingController ifscController = new TextEditingController();
  TextEditingController bankNameController = new TextEditingController();
  TextEditingController branchNameController = new TextEditingController();

  List<String> accountTypes = [
    "CURRENT",
    "SAVINGS",
  ];

  var selectAccountType;

  var screen = "Investor Bank detail";

  var loadIfsc = false;

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    getUserDetails();
  }

  @override
  void dispose() {
    accountNameController.dispose();
    accountNoController.dispose();
    ifscController.dispose();
    bankNameController.dispose();
    branchNameController.dispose();
    super.dispose();
  }

  getUserDetails() async {
    var accountName = "${widget.map['accountName']}";
    var accountNo = "${widget.map['accountNumber']}";
    var ifscCode = "${widget.map['ifsc']}";
    var fName = "${widget.map['fname']}";
    var lName = "${widget.map['lname']}";
    var name = "$fName $lName";

    printMessage(
        screen,
        "accountName : $accountName\n"
        "accountNo : $accountNo\n"
        "ifscCode : $ifscCode");

    setState(() {
      if (accountName.toString() == "null" || accountName.toString() == "") {
        accountNameController =
            TextEditingController(text: "${name.toString()}");
      } else {
        accountNameController =
            TextEditingController(text: "${accountName.toString()}");
      }

      accountNoController =
          TextEditingController(text: "${accountNo.toString()}");
      ifscController = TextEditingController(text: "${ifscCode.toString()}");

      if (ifscCode.toString().length == 11) {
        generatePayoutToken(ifscCode.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        printMessage(screen, "Mobile back pressed");
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return exitProcess();
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
                    return exitProcess();
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
          titleSpacing: 0,
          title: appLogo(),
          actions: [
            Image.asset(
              'assets/lendbox_head.png',
              width: 60,
            ),
            SizedBox(
              width: 10,
            )
          ],
        ),
        body: SingleChildScrollView(
            child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 10, bottom: 10),
              child: TextFormField(
                enabled: true,
                style: TextStyle(color: black, fontSize: inputFont),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                controller: accountNameController,
                decoration: new InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10),
                  counterText: "",
                  label: Text("Account name"),
                ),
                maxLength: 100,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 10, bottom: 10),
              child: TextFormField(
                enabled: true,
                style: TextStyle(color: black, fontSize: inputFont),
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                controller: accountNoController,
                decoration: new InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10),
                  counterText: "",
                  label: Text("Account no."),
                ),
                maxLength: 20,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 10, bottom: 10),
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      enabled: true,
                      style: TextStyle(color: black, fontSize: inputFont),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
                      textInputAction: TextInputAction.next,
                      controller: ifscController,
                      decoration: new InputDecoration(
                        isDense: true,
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.only(left: 10),
                        counterText: "",
                        label: Text("IFSC code"),
                      ),
                      maxLength: 11,
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
          ),
          Container(
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 10, bottom: 10),
              child: TextFormField(
                enabled: true,
                style: TextStyle(color: black, fontSize: inputFont),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                controller: bankNameController,
                decoration: new InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10),
                  counterText: "",
                  label: Text("Bank name"),
                ),
                maxLength: 100,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(20)),
            ),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 15.0, right: 15, top: 10, bottom: 10),
              child: TextFormField(
                enabled: true,
                style: TextStyle(color: black, fontSize: inputFont),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                controller: branchNameController,
                decoration: new InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 10),
                  counterText: "",
                  label: Text("Branch name"),
                ),
                maxLength: 100,
              ),
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 20, left: 25, right: 25),
            decoration: BoxDecoration(
                color: editBg,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: editBg)),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                isExpanded: true,
                value: selectAccountType,
                style: TextStyle(color: black, fontSize: font15),
                items:
                    accountTypes.map<DropdownMenuItem<String>>((String value) {
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
                    accountType,
                    style: TextStyle(color: lightBlack, fontSize: font15),
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
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
              ),
            ),
          ),
        ])),
        bottomNavigationBar: InkWell(
          onTap: () {
            setState(() {
              closeKeyBoard(context);

              var accountName = accountNameController.text.toString();
              var accountNo = accountNoController.text.toString();
              var ifscCode = ifscController.text.toString();
              var bankName = bankNameController.text.toString();
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
              } else if (bankName.length == 0) {
                showToastMessage("Enter account name");
                return;
              } else if (branchName.length == 0) {
                showToastMessage("Enter branch name");
                return;
              } else if (selectAccountType.toString() == "null") {
                showToastMessage("Select account type");
                return;
              }

              saveBankDetails(accountNo, ifscCode, accountName,
                  selectAccountType, bankName, branchName);
            });
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
      )),
    );
  }

  Future generatePayoutToken(code) async {
    setState(() {
      loadIfsc = true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response =
        await http.post(Uri.parse(payoutTokenGenerateAPI), headers: headers);

    var statusCode = response.statusCode;

    setState(() {
      loadIfsc = false;
    });
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

          bankNameController = TextEditingController(text: "$bankName");
          branchNameController = TextEditingController(text: "$branchName");
        } else {
          showToastMessage(somethingWrong);
        }
      });
    } catch (e) {
      loadIfsc = false;
    }
  }

  Future saveBankDetails(accountNumber, ifsc, holderName, accountType, bankName,
      branchName) async {
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
      "token": "${widget.map['token']}",
      "accountNumber": "$accountNumber",
      "ifsc": "$ifsc",
      "holderName": "$holderName",
      "accountType": "$accountType",
      "bankName": "$bankName",
      "branchName": "$branchName",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(investorBankDetailsAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
          openMerchantInvestorDoc(
              context, widget.map['pan'], widget.map['token']);
        } else {
          showToastMessage(data['message'].toString());
          openMerchantInvestorDoc(
              context, widget.map['pan'], widget.map['token']);
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
