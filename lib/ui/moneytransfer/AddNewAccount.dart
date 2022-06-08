import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:moneypro_new/utils/SharedPrefs.dart';

class AddNewAccount extends StatefulWidget {
  final String bankName;
  final String bankLogo;

  const AddNewAccount(
      {Key? key, required this.bankName, required this.bankLogo})
      : super(key: key);

  @override
  _AddNewAccountState createState() => _AddNewAccountState();
}

class _AddNewAccountState extends State<AddNewAccount> {
  var screen = "Add new Account";

  var isValidIFSC = false;

  var loadIfsc = false;

  var branchName = "";

  TextEditingController accNoController = new TextEditingController();
  TextEditingController confirmAccNoController = new TextEditingController();
  TextEditingController ifscController = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  TextEditingController mobileController = new TextEditingController();
  TextEditingController nickNameController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    printMessage(screen, "Bank Name : ${widget.bankName}");
    printMessage(screen, "Bank Logo : ${widget.bankLogo}");
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
      body: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
            height: 20.h,
          ),
          Padding(
            padding: EdgeInsets.only(top: 15, left: padding, right: padding),
            child: Container(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (widget.bankLogo.toString() == "")
                      ? Image.asset(
                          'assets/bank.png',
                          height: 36.h,
                        )
                      : SizedBox(
                          width: 36.h,
                          child: Image.network(
                            "$bankIconUrl${widget.bankLogo}",
                          ),
                        ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Selected bank",
                          style: TextStyle(
                              color: lightBlack,
                              fontSize: font14.sp,
                              fontWeight: FontWeight.normal),
                        ),
                        Text(
                          "${widget.bankName}",
                          style: TextStyle(
                              color: black,
                              fontSize: font16.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      closeKeyBoard(context);
                      closeCurrentPage(context);
                    },
                    child: Icon(
                      Icons.edit,
                      size: 20,
                      color: lightBlue,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 20.h,
          ),
          Container(
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Center(
              child: TextFormField(
                style: TextStyle(color: black, fontSize: 14.sp),
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                controller: accNoController,
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
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Center(
              child: TextFormField(
                style: TextStyle(color: black, fontSize: 14.sp),
                keyboardType: TextInputType.number,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                controller: confirmAccNoController,
                decoration: new InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20),
                  counterText: "",
                  label: Text("Confirm account number"),
                ),
                maxLength: 16,
              ),
            ),
          ),
          Container(
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Center(
              child: Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: TextFormField(
                      style: TextStyle(color: black, fontSize: 14.sp),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.characters,
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
                          generatePayoutToken(ifscController.text.toString());
                        } else {
                          setState(() {
                            isValidIFSC = false;
                          });
                        }
                      },
                    ),
                  ),
                  (loadIfsc)
                      ? Center(
                          child: circularProgressLoading(20.0),
                        )
                      : Container(),
                  (ifscController.text.toString().length == 11 && isValidIFSC)
                      ? Image.asset(
                          'assets/green_tick.png',
                          height: 20.h,
                        )
                      : Container(),
                  SizedBox(
                    width: 10,
                  ),
                ],
              ),
            ),
          ),
          (branchName.toString() == "")
              ? Container()
              : Container(
                  height: 50.h,
                  width: MediaQuery.of(context).size.width,
                  margin:
                      EdgeInsets.only(top: 15, left: padding, right: padding),
                  decoration: BoxDecoration(
                    color: editBg,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0, top: 16),
                    child: Text(
                      branchName,
                      style: TextStyle(color: black, fontSize: font16.sp),
                    ),
                  ),
                ),
          Container(
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Center(
              child: TextFormField(
                style: TextStyle(color: black, fontSize: 14.sp),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                controller: nameController,
                decoration: new InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20),
                  counterText: "",
                  label: Text("Account holder name"),
                ),
                maxLength: 20,
              ),
            ),
          ),
          Container(
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Center(
              child: TextFormField(
                style: TextStyle(color: black, fontSize: 14.sp),
                keyboardType: TextInputType.phone,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                controller: mobileController,
                decoration: new InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20),
                  counterText: "",
                  label: Text("Phone number (optional)"),
                ),
                maxLength: 10,
              ),
            ),
          ),
          Container(
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 15, left: padding, right: padding),
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            child: Center(
              child: TextFormField(
                style: TextStyle(color: black, fontSize: 14.sp),
                keyboardType: TextInputType.name,
                textCapitalization: TextCapitalization.characters,
                textInputAction: TextInputAction.next,
                controller: nickNameController,
                decoration: new InputDecoration(
                  isDense: true,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.only(left: 20),
                  counterText: "",
                  label: Text("Nike name (optional)"),
                ),
                maxLength: 20,
              ),
            ),
          ),
        ]),
      ),
      bottomNavigationBar: _buildButton(),
    )));
  }

  _buildButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
      child: InkWell(
        onTap: () {
          var accNo = accNoController.text.toString();
          var confAccNo = confirmAccNoController.text.toString();
          var ifsc = ifscController.text.toString();
          var name = nameController.text.toString();
          var mobile = mobileController.text.toString();
          var nikeName = nickNameController.text.toString();

          if (accNo.length == 0) {
            showToastMessage("enter account number");
            return;
          } else if (confAccNo.length == 0) {
            showToastMessage("enter confirm account number");
            return;
          } else if (accNo.toString() != confAccNo.toString()) {
            showToastMessage("account number not match");
            return;
          } else if (ifsc.length == 0) {
            showToastMessage("enter ifsc code");
            return;
          } else if (!isValidIFSC) {
            showToastMessage("enter ifsc code is not valid");
            return;
          } else if (name.length == 0) {
            showToastMessage("enter account holder name");
            return;
          } else if (regExpName.hasMatch(name)) {
            showToastMessage(
                "Special characters or numbers are not allowed in name");
            return;
          }
          closeKeyBoard(context);
          addBankAccount(accNo, ifsc, name);
        },
        child: Container(
          height: 45.h,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Center(
            child: Text(
              "Add New Account".toUpperCase(),
              style: TextStyle(fontSize: font16.sp, color: white),
            ),
          ),
        ),
      ),
    );
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
          branchName = data['data']['branch'].toString();
          var branchCity = data['data']['city'].toString();
          var branchState = data['data']['state'].toString();
          var branchAddress = data['data']['address'].toString();

          isValidIFSC = true;
        } else {
          isValidIFSC = false;
          showToastMessage(somethingWrong);
        }
      });
    } catch (e) {
      loadIfsc = false;
    }
  }

  Future addBankAccount(accountNo, ifsc, accHolderHame) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader"
    };

    final body = {
      "user_token": userToken,
      "account_no": accountNo,
      "ifsc": ifsc,
      "acc_holder_name": accHolderHame,
      "bank_name": "${widget.bankName}"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(accountAddAPI),
        body: jsonEncode(body), headers: headers);
    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Add acc Response : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());

          showDialog(
              context: context,
              builder: (BuildContext context) {
                return ThankYouDialog(
                  text: "${data['message'].toString()}",
                  isCloseAll: "3".toString(),
                );
              });
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
