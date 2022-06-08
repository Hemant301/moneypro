import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/footer/WelcomeOfferPopup.dart';
import 'package:moneypro_new/ui/models/Banks.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/AppKeys.dart';


class BankDetails extends StatefulWidget {
  final Map itemResponse;

  const BankDetails({Key? key, required this.itemResponse}) : super(key: key);

  @override
  _BankDetailsState createState() => _BankDetailsState();
}

class _BankDetailsState extends State<BankDetails> {
  //final accountNameController = new TextEditingController();
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

  var selectedAccName;

  List<String> accNames = [];

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
    setAccNames();
  }

  @override
  void dispose() {
    //accountNameController.dispose();
    accountNoController.dispose();
    ifscController.dispose();
    branchNameController.dispose();
    super.dispose();
  }

  setAccNames() {
    accNames = [
      "${newItem['businessName'].toString().toUpperCase()}",
      "${newItem['client_nam'].toString().toUpperCase()}"
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>WillPopScope(
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
                        height: 40.h,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0),
                        child: Text(
                          "$accDetails",
                          style: TextStyle(
                              color: black,
                              fontSize: font14.sp,
                              fontWeight: FontWeight.bold),
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
                            value: selectedAccName,
                            style: TextStyle(color: black, fontSize: font16.sp),
                            items: accNames
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
                                "Select account name",
                                style: TextStyle(
                                    color: lightBlack, fontSize: font16.sp),
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
                                selectedAccName = value!;
                                FocusScope.of(context)
                                    .requestFocus(new FocusNode());
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
                                      width: 10.w,
                                    ),
                                    (value.logo == "")
                                        ? Container(
                                            height: 24.h,
                                            width: 24.w,
                                            child:
                                                Image.asset('assets/bank.png'),
                                          )
                                        : Image.network(
                                            "$bankIconUrl${value.logo}",
                                            width: 30.w,
                                            height: 30.h,
                                          ),
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(left: 15.0),
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
                            style: TextStyle(color: black, fontSize: font16.sp),
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
                                    color: lightBlack, fontSize: font16.sp),
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
              height: 45.h,
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 30),
              decoration: BoxDecoration(
                color: lightBlue,
                borderRadius: BorderRadius.all(Radius.circular(25)),
              ),
              child: Center(
                child: Text(
                  continue_.toUpperCase(),
                  style: TextStyle(fontSize: font13.sp, color: white),
                ),
              ),
            ),
          ),
        ))));
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
    var accountName = selectedAccName;
    var accountNo = accountNoController.text.toString();
    var ifscCode = ifscController.text.toString();
    var branchName = branchNameController.text.toString();

    if (accountName.length == 0) {
      showToastMessage("Enter account name");
      return;
    } else if (accountNo.length == 0) {
      showToastMessage("Enter account number");
      return;
    } else if (bankName.length == 0 ||
        bankName.toString() == "Select your bank") {
      showToastMessage("select your bank");
      return;
    } else if (ifscCode.length == 0) {
      showToastMessage("Enter IFSC code");
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

    printMessage(screen, "Map data : ${newItem.toString()}");

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
      "com_name": newItem['businessName'],
      "com_type": newItem['businessCat'],
      "business_segment": newItem['businessSeg'],
      "com_address": newItem['address'],
      "contact_name": newItem['client_nam'],
      "gst_no": newItem['gstValue'],
      "pan_no": newItem['pan'],
      "pan_name": newItem['client_nam'],
      "dob": newItem['dob'],
      "account_no": newItem['accountNo'],
      "holder_name": newItem['accountName'],
      "ifsc": newItem['ifscCode'],
      "bnk_name": newItem['bankName'],
      "branch": newItem['branchName'],
      "state": newItem['state'],
      "dict": newItem['dist'],
      "city": newItem['city'],
      "pin": newItem['pin'],
      "adhar": newItem['adhar'],
      "mcc_code": newItem['mccCode'],
      "qr_display_name": newItem['qrDisplayName'],
    };

    //  try{
    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(merchantOnboardAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");

      setState(() {
        Navigator.pop(context);
        var status = data['status'].toString();
        if (data['status'].toString() == "1") {
          getUserAllDetails(status, data['message'].toString());
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

  Future getUserAllDetails(status, message) async {
    var token = await getToken();

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
    };

    final body = {
      "token": token,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(userDetailAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");
      Navigator.pop(context);
      setState(() {
        if (status == "1") {
          saveFirstName("${data['user']['first_name'].toString()}");
          saveLastName("${data['user']['last_name'].toString()}");
          saveEmail("${data['user']['email'].toString()}");
          saveMobile("${data['user']['mobile'].toString()}");
          saveDOB("${data['user']['dob'].toString()}");
          saveComapanyName("${data['user']['company_name'].toString()}");
          saveCompanyType("${data['user']['company_type'].toString()}");
          saveBusinessSegment("${data['user']['business_segment'].toString()}");
          saveCompanyAddress("${data['user']['company_address'].toString()}");
          saveContactName("${data['user']['contact_name'].toString()}");
          saveGSTNo("${data['user']['gst_no'].toString()}");
          savePANNo("${data['user']['pan_no'].toString()}");
          saveKYCStatus("${data['user']['kyc_status'].toString()}");
          saveToken("${data['user']['token'].toString()}");
          saveRole("${data['user']['role'].toString()}");
          saveMerchantID("${data['user']['mherchant_id'].toString()}");
          //saveATMService("${data['user']['atm_service']}");
          var wB = "${data['user']['wallet_balance']}";
          if (wB.toString() == "null") {
            saveWalletBalance("0");
          } else {
            saveWalletBalance("${data['user']['wallet_balance']}");
          }

          var wp = "${data['user']['wp_msg']}";
          if (wp.toString() == "null") {
            saveWhastAppValue("No");
          } else {
            saveWhastAppValue("${data['user']['wp_msg']}");
          }

          saveRetailerUserCode("${data['user']['retailer_user_code']}");
          saveRetailerOnBoardUser("${data['user']['retailer_onboard_user']}");
          saveQRtBalance("${data['user']['qr_wallet']}");
          saveDmtStatus("${data['user']['dmt']}");
          saveMatmStatus("${data['user']['matm']}");
          saveAepsStatus("${data['user']['aeps']}");
          saveAccountNumber("${data['user']['account_no']}");
          saveBranchCity("${data['user']['branch']}");
          saveIFSC("${data['user']['ifsc']}");
          saveAPESToken("${data['user']['aeps_token']}");
          saveVirtualAccId("${data['user']['virtual_accounts_id']}");
          saveVirtualAccNo("${data['user']['virtual_account_number']}");
          saveVirtualAccIFSC("${data['user']['virtual_account_ifsc_code']}");
          saveMATMMerchantId("${data['user']['matm_merchant_id']}");
          saveVPA("${data['user']['vpa']}");
          saveCity("${data['user']['city']}");
          saveAdhar("${data['user']['adhar']}");
          savePinCode("${data['user']['pin']}");
          saveOutLetId("${data['user']['outlet_id']}");
          saveState("${data['user']['state']}");
          saveQRMaxAmt("${data['user']['qr_withdrawl_amount']}");
          saveDistrict("${data['user']['district']}");
          saveEmployeeId("${data['user']['employee_id']}");
          saveQRInvestor("${data['user']['qr_money_invst']}");
          saveAEPSKyc("${data['user']['aeps_kyc']}");
          saveAEPSMerchantId("${data['user']['aeps_merchant_id']}");
          saveWelcomeAmt("${data['user']['welcome_amount']}");
          saveApproved("${data['user']['approved']}");
          saveQRDisplayName("${data['user']['qr_display_name']}");
          saveBranchCreate("${data['user']['branch_create']}");

          printMessage(screen, "All data saved");
          showWelcomeOfferPopup(1);
        }
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
