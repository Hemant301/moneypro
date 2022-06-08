import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:moneypro_new/ui/models/Banks.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/AppKeys.dart';


class EmpMerchantBankDetails extends StatefulWidget {
  final Map itemResponse;
  final File storeImage;
  final File docImage;
  final File selfiImage;
  final File adhFront;
  final File adhBack;

  const EmpMerchantBankDetails(
      {Key? key,
      required this.itemResponse,
      required this.storeImage,
      required this.docImage,
      required this.selfiImage,
        required this.adhFront,
        required this.adhBack})
      : super(key: key);

  @override
  _EmpMerchantBankDetailsState createState() => _EmpMerchantBankDetailsState();
}

class _EmpMerchantBankDetailsState extends State<EmpMerchantBankDetails> {
  //TextEditingController accountNameController = new TextEditingController();
  TextEditingController accountNoController = new TextEditingController();
  TextEditingController ifscController = new TextEditingController();
  TextEditingController branchNameController = new TextEditingController();

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
    updateATMStatus(context);
    fetchUserAccountBalance();
    setState(() {
      newItem = widget.itemResponse;
    });

    printMessage(screen, "QR : ${widget.itemResponse['customQRReq']}");

    getBankList();
    setAccNames();
  }

  @override
  void dispose() {
    // accountNameController.dispose();
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

  getDetail() {
    var accountName = selectedAccName;
    var accountNo = accountNoController.text.toString();
    var ifscCode = ifscController.text.toString();

    var branchName = branchNameController.text.toString();

    printMessage(screen, "selectedAccName : $selectedAccName");
    printMessage(screen, "accountName : $accountName");

    if (accountName.toString() == "null" || accountName.length == 0) {
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
    printMessage(screen, "Array : $newItem");
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

    final tagName = newItem['client_nam'].toString();
    var fname = "", lname = "";

    if (tagName.toString().contains(" ")) {
      final split = tagName.split(' ');
      final Map<int, String> values = {
        for (int i = 0; i < split.length; i++) i: split[i]
      };
      fname = values[0].toString();
      var ch = tagName.toString().replaceAll("$fname", "");
      printMessage(screen, "TAG NAME : $ch");
      lname = ch.toString().trim();
    } else {
      fname = tagName;
      lname = "NA";
    }

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "token": token,
      "fname": fname,
      "lname": lname,
      "email": newItem['email'],
      "mobile": newItem['mobile'],
      "com_name": newItem['businessName'],
      "com_type": newItem['businessCat'],
      "business_segment": newItem['businessSeg'],
      "com_address": newItem['address'],
      "contact_name": newItem['client_nam'],
      "gst_no": newItem['gstValue'],
      "pan_no": newItem['pan'],
      "pan_name": newItem['client_nam'],
      "pan_status": "",
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
      "wp_msg": "Yes",
      "qr_display_name": newItem['qrDisplayName'],
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(employeOnBoardingAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Bank Save Response : ${data}");

      setState(() {
        Navigator.pop(context);
        var status = data['status'].toString();
        if (data['status'].toString() == "1" ||
            data['status'].toString() == "3") {
          var token = data['token'].toString();
          _showFileUploadPopup(token);
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

  _showFileUploadPopup(token) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: FileUploading(
                storeImage: widget.storeImage,
                docImage: widget.docImage,
                token: token,
                qrPrefs: "${widget.itemResponse["qr_prefs"].toString()}",
                customQRReq: "${widget.itemResponse['customQRReq'].toString()}",
                selfiImage: widget.selfiImage,
                name: "${newItem['client_nam'].toString()}",
                mobile: "${newItem['mobile'].toString()}",
                companyName: "${newItem['businessName'].toString()}",
                qrDisplayName: "${newItem['qrDisplayName'].toString()}",
                  adhFront: widget.adhFront,
                  adhBack: widget.adhBack,
              ),
            ));
  }
}

class FileUploading extends StatefulWidget {
  final File storeImage;
  final File docImage;
  final String token;
  final String qrPrefs;
  final String customQRReq;
  final File selfiImage;
  final String name;
  final String mobile;
  final String companyName;
  final String qrDisplayName;
  final File adhFront;
  final File adhBack;

  const FileUploading(
      {Key? key,
      required this.storeImage,
      required this.docImage,
      required this.token,
      required this.qrPrefs,
      required this.customQRReq,
      required this.selfiImage,
      required this.name,
      required this.mobile,
      required this.companyName,
      required this.qrDisplayName,
      required this.adhFront,
        required this.adhBack})
      : super(key: key);

  @override
  _FileUploadingState createState() => _FileUploadingState();
}

class _FileUploadingState extends State<FileUploading> {
  var storeLoading = false;
  var docLoading = false;
  var selfiLoading = false;

  var adhFrontLoading = false;
  var adhBackLoading = false;

  var isStoreUploaded = false;
  var isDocuUploaded = false;
  var isSelfiUploaded = false;

  var isAdhFrontUploaded = false;
  var isAdhBackUploaded = false;

  var screen = "File Upload";

  final qrNoController = new TextEditingController();

  @override
  void initState() {
    super.initState();

    if (widget.storeImage.path != "") {
      _uploadStoreLogo(widget.storeImage);
    }
  }

  @override
  void dispose() {
    qrNoController.dispose();
    super.dispose();
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
              return exitProcess();
            });
        return false;
      },
      child: Wrap(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                    topLeft: const Radius.circular(40.0),
                    topRight: const Radius.circular(40.0))),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 30.0, bottom: 15, left: 20, right: 20),
                  child: Text(
                    "Please wait, while we are uploading your document(s)",
                    style: TextStyle(fontSize: font16.sp),
                  ),
                ),
                Divider(),
                (widget.customQRReq == "false")
                    ? Container()
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 25.0, bottom: 5),
                            child: Text(
                              "Enter your custom QR number",
                              style: TextStyle(color: black, fontSize: font16.sp),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(
                                top: 5,
                                left: padding,
                                right: padding,
                                bottom: 0),
                            decoration: BoxDecoration(
                              color: editBg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 15.0, right: 15, top: 15, bottom: 15),
                              child: TextFormField(
                                style: TextStyle(
                                    color: black, fontSize: inputFont.sp),
                                keyboardType: TextInputType.number,
                                textCapitalization:
                                    TextCapitalization.characters,
                                textInputAction: TextInputAction.next,
                                controller: qrNoController,
                                decoration: new InputDecoration(
                                  isDense: true,
                                  border: InputBorder.none,
                                  contentPadding:
                                      EdgeInsets.only(left: 10, right: 10),
                                  counterText: "",
                                  prefix: Text(
                                    "MPQR ",
                                    style: TextStyle(
                                        color: black, fontSize: inputFont.sp),
                                  ),
                                  suffix: Text(
                                    "@indus ",
                                    style: TextStyle(
                                        color: black, fontSize: inputFont.sp),
                                  ),
                                ),
                                maxLength: 8,
                                onChanged: (val) {
                                  if (val.length == 8) {
                                    closeKeyBoard(context);
                                  }
                                },
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 25.0, top: 2, bottom: 10),
                            child: Text(
                              "You may enter any desired 8-digit number",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font12.sp),
                            ),
                          ),
                        ],
                      ),
                (widget.storeImage.path == "")
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 20.0,),
                        child: Row(
                          children: [
                            Text(
                              "Store Image/Logo",
                              style: TextStyle(color: black, fontSize: font15.sp),
                            ),
                            Spacer(),
                            (storeLoading)
                                ? circularProgressLoading(20.0)
                                : Container(),
                            SizedBox(
                              width: 20.w,
                            ),
                            (isStoreUploaded)
                                ? Container(
                                    height: 24.h,
                                    width: 24.w,
                                    decoration: BoxDecoration(
                                        color: green, shape: BoxShape.circle),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/tick.png',
                                        height: 16.h,
                                        color: white,
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              width: 20.w,
                            ),
                          ],
                        ),
                      ),
                (widget.docImage.path == "")
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 20.0, top: 15),
                        child: Row(
                          children: [
                            Text(
                              "Document",
                              style: TextStyle(color: black, fontSize: font15.sp),
                            ),
                            Spacer(),
                            (docLoading)
                                ? circularProgressLoading(20.0)
                                : Container(),
                            SizedBox(
                              width: 20.w,
                            ),
                            (isDocuUploaded)
                                ? Container(
                                    height: 24.h,
                                    width: 24.w,
                                    decoration: BoxDecoration(
                                        color: green, shape: BoxShape.circle),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/tick.png',
                                        height: 16.h,
                                        color: white,
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              width: 20.w,
                            ),
                          ],
                        ),
                      ),
                (widget.selfiImage.path == "")
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 20.0,top: 15),
                        child: Row(
                          children: [
                            Text(
                              "Selfi",
                              style: TextStyle(color: black, fontSize: font15.sp),
                            ),
                            Spacer(),
                            (selfiLoading)
                                ? circularProgressLoading(20.0)
                                : Container(),
                            SizedBox(
                              width: 20.w,
                            ),
                            (isSelfiUploaded)
                                ? Container(
                                    height: 24.h,
                                    width: 24.w,
                                    decoration: BoxDecoration(
                                        color: green, shape: BoxShape.circle),
                                    child: Center(
                                      child: Image.asset(
                                        'assets/tick.png',
                                        height: 16.h,
                                        color: white,
                                      ),
                                    ),
                                  )
                                : Container(),
                            SizedBox(
                              width: 20.w,
                            ),
                          ],
                        ),
                      ),
                (widget.adhFront.path == "")
                    ? Container()
                    : Padding(
                  padding: const EdgeInsets.only(left: 20.0,top:15),
                  child: Row(
                    children: [
                      Text(
                        "Adhar Front",
                        style: TextStyle(color: black, fontSize: font15.sp),
                      ),
                      Spacer(),
                      (adhFrontLoading)
                          ? circularProgressLoading(20.0)
                          : Container(),
                      SizedBox(
                        width: 20.w,
                      ),
                      (isAdhFrontUploaded)
                          ? Container(
                        height: 24.h,
                        width: 24.w,
                        decoration: BoxDecoration(
                            color: green, shape: BoxShape.circle),
                        child: Center(
                          child: Image.asset(
                            'assets/tick.png',
                            height: 16.h,
                            color: white,
                          ),
                        ),
                      )
                          : Container(),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
                (widget.adhFront.path == "")
                    ? Container()
                    : Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 15),
                  child: Row(
                    children: [
                      Text(
                        "Adhar Back",
                        style: TextStyle(color: black, fontSize: font15.sp),
                      ),
                      Spacer(),
                      (adhBackLoading)
                          ? circularProgressLoading(20.0)
                          : Container(),
                      SizedBox(
                        width: 20.w,
                      ),
                      (isAdhBackUploaded)
                          ? Container(
                        height: 24.h,
                        width: 24.w,
                        decoration: BoxDecoration(
                            color: green, shape: BoxShape.circle),
                        child: Center(
                          child: Image.asset(
                            'assets/tick.png',
                            height: 16.h,
                            color: white,
                          ),
                        ),
                      )
                          : Container(),
                      SizedBox(
                        width: 20.w,
                      ),
                    ],
                  ),
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      /*Navigator.pop(context);
                        removeAllPages(context);
                        printMessage(screen, "All data saved");
                        openMerchantList(context);
                        */
                      if (widget.customQRReq == "false") {
                        assignQR("");
                      } else {
                        var qrNo = qrNoController.text.toString();
                        if (qrNo.length != 8) {
                          showToastMessage("Enter 8-digit number");
                          return;
                        }
                        assignQR("MPQR$qrNo");
                      }
                    });
                  },
                  child: Container(
                    height: 45.h,
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.only(
                        top: 20, left: 20, right: 20, bottom: 10),
                    decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                    ),
                    child: Center(
                      child: Text(
                        "Assign QR",
                        style: TextStyle(fontSize: font13.sp, color: white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    ));
  }

  void _uploadStoreLogo(File file) async {
    setState(() {
      storeLoading = true;
    });
    String fileName = file.path.split('/').last;

    printMessage(screen, "Token : ${widget.token}");

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": "${widget.token}",
      "doc_name": "StoreImage"
    });

    Dio dio = new Dio();

    dio.post(marchantDocsEmpAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");
      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            isStoreUploaded = true;
          } else {
            isStoreUploaded = false;
          }
        });
        //getImagePath();
      } else {
        printMessage(screen, "Error : ${response}");
        showToastMessage(status500);
      }
      setState(() {
        storeLoading = false;

        if (widget.selfiImage.path != "") {
          _uploadSelfi(widget.selfiImage);
        }

      });
    }).catchError((error) => print(error));
  }

  void _uploadDocumentLogo(File file) async {
    setState(() {
      docLoading = true;
    });
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": "${widget.token}",
      "doc_name": "DocImage"
    });

    Dio dio = new Dio();

    dio.post(marchantDocsEmpAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");

      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            isDocuUploaded = true;
          } else {
            isDocuUploaded = false;
          }
        });
        //getImagePath();
      } else {
        printMessage(screen, "Error : ${response}");
        showToastMessage(status500);
      }
      setState(() {
        docLoading = false;
      });
    }).catchError((error) => print(error));
  }

  Future assignQR(qrNo) async {
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
      "token": "${widget.token}",
      "size": "${widget.qrPrefs}",
      "vpa": "$qrNo"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(marchantQrAssignAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response Settelment : $data");

    setState(() {
      Navigator.pop(context);
      if (data['status'].toString() == "1") {
        showToastMessage(data['message'].toString());
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return showMerchantKycByEmp(
                  text: "${data['message'].toString()}",
                  token: "${widget.token}",
                  name: "${widget.name}",
                  mobile: "${widget.mobile}",
                  companyName: "${widget.companyName}",
                  qrDisplayName: "${widget.qrDisplayName}");
            });
      } else {
        showToastMessage(data['message'].toString());
      }
    });
  }

  void _uploadSelfi(File file) async {
    setState(() {
      selfiLoading = true;
    });
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": "${widget.token}",
      "doc_name": "selfi"
    });

    Dio dio = new Dio();

    dio.post(marchantDocsEmpAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");

      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            isSelfiUploaded = true;
          } else {
            isSelfiUploaded = false;
          }
        });
        //getImagePath();
      } else {
        printMessage(screen, "Error : ${response}");
        showToastMessage(status500);
      }
      setState(() {
        selfiLoading = false;

        if (widget.docImage.path != "") {
          _uploadDocumentLogo(widget.docImage);
        }else{
          if (widget.adhFront.path != "") {
            _uploadAdharFront(widget.adhFront);
          }

        }

      });
    }).catchError((error) => print(error));
  }

  void _uploadAdharFront(File file) async {
    setState(() {
      adhFrontLoading = true;
    });
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": "${widget.token}",
      "doc_name": "Adhar front"
    });

    printMessage(screen, "Adhar Data : ${data.fields}");

    Dio dio = new Dio();

    dio.post(marchantDocsEmpAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");

      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            isAdhFrontUploaded = true;
          } else {
            isAdhFrontUploaded = false;
          }
        });
        //getImagePath();
      } else {
        printMessage(screen, "Error : ${response}");
        showToastMessage(status500);
      }
      setState(() {
        adhFrontLoading = false;
        if (widget.adhBack.path != "") {
          _uploadAdharBack(widget.adhBack);
        }
      });
    }).catchError((error) => print(error));
  }

  void _uploadAdharBack(File file) async {
    setState(() {
      adhBackLoading = true;
    });
    String fileName = file.path.split('/').last;

    FormData data = FormData.fromMap({
      "files": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
      "token": "${widget.token}",
      "doc_name": "Adhar back"
    });

    printMessage(screen, "Adhar Data : ${data.fields}");

    Dio dio = new Dio();

    dio.post(marchantDocsEmpAPI, data: data).then((response) {
      var msg = jsonDecode(response.toString());

      printMessage(screen, "Status Code : ${msg['message']}");

      if (response.statusCode == 200) {
        var msg = jsonDecode(response.toString());
        showToastMessage(msg['message'].toString());
        var status = msg['status'].toString();
        setState(() {
          if (status == "1") {
            isAdhBackUploaded = true;
          } else {
            isAdhBackUploaded = false;
          }
        });
        //getImagePath();
      } else {
        printMessage(screen, "Error : ${response}");
        showToastMessage(status500);
      }
      setState(() {
        adhBackLoading = false;
      });
    }).catchError((error) => print(error));
  }
}
