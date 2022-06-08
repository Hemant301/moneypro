import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/Circles.dart';
import 'package:moneypro_new/ui/models/MPContacts.dart';
import 'package:moneypro_new/ui/models/MobilePlan.dart';
import 'package:moneypro_new/ui/models/MyContacts.dart';
import 'package:moneypro_new/ui/models/Operators.dart';
import 'package:moneypro_new/ui/models/Plans.dart';
import 'package:moneypro_new/ui/models/RecentTransaction.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:permission_handler/permission_handler.dart';

class PrepaidMobileRecharge extends StatefulWidget {
  final String mobileNo;

  const PrepaidMobileRecharge({Key? key, required this.mobileNo})
      : super(key: key);

  @override
  _PrepaidMobileRechargeState createState() => _PrepaidMobileRechargeState();
}

class _PrepaidMobileRechargeState extends State<PrepaidMobileRecharge> {
  var screen = "Mobile recharge";

  TextEditingController phoneController = new TextEditingController();

  final searchAmount = new TextEditingController();
  final searchName = new TextEditingController();

  var loading = false;

  String bbpsToken = "";

  var iOSLocalizedLabels = false;

  String operatorFirstCode = "";
  String operatorFirstName = "";
  String circleFirstName = "";
  String circleFirstefID = "";

  List<String> rechargeTypes = [];

  List<MobilePlan> mobilePlans = [];
  List<MobilePlan> mobilePlansFiltered = [];
  List<PlanList> planList = [];
  List<ResentList> resentList = [];

  int typeIndex = 0;

  var showSearchResult = false;

  var isPickContact = false;

  List<OperatorNames> operatorNames = [];

  List<StateList> stateList = [];

  String billerImg = "";

  String operatorSecName = "";
  String stateName = "";
  String stateCode = "";
  String operatorSecCode = "";

  List<Contact> _contacts = [];
  List<Contact> _contactFilter = [];

  //List<MyContacts> myContacts = [];

  List<MyContacts> myContacts = [];
  List<MyContacts> myFilteredContacts = [];
  List<Map<String, bool>> phoneListn = [];

  var showFiltedContact = false;

  String category = "MOBILE PREPAID";

  var recentLoading = false;

  var isPlanVisible = false;

  double mainWallet = 0.0;

  @override
  void initState() {
    super.initState();
    getBBPSToken();
    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();
    _askContactPermissions();
    getRecentTransactions();
  }

  @override
  void dispose() {
    phoneController.dispose();
    searchAmount.dispose();
    searchName.dispose();
    super.dispose();
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
      mainWallet = wX + mX;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                Container(
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                      color: walletBg,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      border: Border.all(color: walletBg)),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
                    child: Wrap(
                      direction: Axis.horizontal,
                      children: [
                        Image.asset(
                          "assets/wallet.png",
                          height: 20,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 5),
                            child: Text(
                              //"${formatDecimal2Digit.format(mainWallet)}",
                              "$mainWallet",
                              style: TextStyle(color: white, fontSize: font15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
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
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (mobilePlans.length == 0)
                          ? appSelectedBanner(
                              context, "recharge_banner.png", 150.0)
                          : Container(),
                      Container(
                        margin: EdgeInsets.only(
                            top: padding, left: padding, right: padding),
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
                                  style: TextStyle(
                                      color: black,
                                      fontSize: inputFont,
                                      fontWeight: FontWeight.bold),
                                  keyboardType: TextInputType.phone,
                                  textInputAction: TextInputAction.done,
                                  controller: phoneController,
                                  decoration: new InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 10),
                                    counterText: "",
                                    label: Text("Phone number"),
                                  ),
                                  maxLength: 10,
                                  onChanged: (val) {
                                    if (val.length == 10) {
                                      closeKeyBoard(context);
                                      rechargeTypes.clear();
                                      mobilePlans.clear();
                                      mobilePlansFiltered.clear();
                                      getMobileDetails(val.toString());
                                    }
                                  },
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  if (_contacts.length == 0) {
                                    showToastMessage(
                                        "Please wait, while we are loading your contacts");
                                  } else {
                                    _showContactList();
                                  }
                                },
                                child: Image.asset(
                                  'assets/phonebook.png',
                                  height: 20,
                                ),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                      (isPickContact)
                          ? Container()
                          : Expanded(
                              flex: 1,
                              child: _buildContactSection(),
                            ),
                      (stateName == "")
                          ? Container()
                          : Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, top: 15, right: 20),
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: editBg,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              _showOperatorList();
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Select Operator",
                                                  style: TextStyle(
                                                      color: lightBlack,
                                                      fontSize: font13),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  children: [
                                                    (billerImg == "")
                                                        ? Container()
                                                        : SizedBox(
                                                            height: 16,
                                                            child:
                                                                Image.network(
                                                              "$imageSubAPI${billerImg}",
                                                            ),
                                                          ),
                                                    (billerImg == "")
                                                        ? Container()
                                                        : SizedBox(
                                                            width: 10,
                                                          ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        operatorSecName,
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize: font15),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Icon(
                                                      // Add this
                                                      Icons
                                                          .keyboard_arrow_down, // Add this
                                                      color:
                                                          lightBlue, // Add this
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Expanded(
                                      flex: 1,
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: editBg,
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(20)),
                                        ),
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: InkWell(
                                            onTap: () {
                                              _showStateList();
                                            },
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Select State",
                                                  style: TextStyle(
                                                      color: lightBlack,
                                                      fontSize: font13),
                                                ),
                                                SizedBox(
                                                  height: 2,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        stateName,
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize: font15),
                                                        overflow:
                                                            TextOverflow.fade,
                                                        maxLines: 1,
                                                      ),
                                                    ),
                                                    Spacer(),
                                                    Icon(
                                                      // Add this
                                                      Icons
                                                          .keyboard_arrow_down, // Add this
                                                      color:
                                                          lightBlue, // Add this
                                                    )
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      )),
                                ],
                              ),
                            ),
                      (stateName == "")
                          ? Container()
                          : Expanded(
                              flex: 1,
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(50.0)),
                                  color: white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.grey.withOpacity(0.5),
                                      spreadRadius: 10,
                                      blurRadius: 10,
                                      offset: Offset(
                                          0, 1), // changes position of shadow
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    SizedBox(
                                      height: 20,
                                    ),
                                    Center(
                                      child: Container(
                                        color: gray,
                                        width: 50,
                                        height: 5,
                                      ),
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(
                                          top: padding,
                                          left: padding,
                                          right: padding),
                                      decoration: BoxDecoration(
                                        color: editBg,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            left: 15.0,
                                            right: 15,
                                            top: 10,
                                            bottom: 10),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: TextFormField(
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: inputFont,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                keyboardType:
                                                    TextInputType.phone,
                                                textInputAction:
                                                    TextInputAction.done,
                                                controller: searchAmount,
                                                decoration: new InputDecoration(
                                                  isDense: true,
                                                  border: InputBorder.none,
                                                  contentPadding:
                                                      EdgeInsets.only(left: 10),
                                                  counterText: "",
                                                  label: Text(
                                                      "Search plan by amount"),
                                                ),
                                                maxLength: 5,
                                                onFieldSubmitted: (val) {
                                                  if (val.toString().length ==
                                                      0) {
                                                    showToastMessage(
                                                        "enter the amount");
                                                    return;
                                                  }
                                                  onSearchTextChanged(
                                                      val.toString());
                                                },
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                var res = searchAmount.text
                                                    .toString();
                                                if (res.toString().length ==
                                                    0) {
                                                  showToastMessage(
                                                      "enter the amount");
                                                  return;
                                                }
                                                onSearchTextChanged(
                                                    res.toString());
                                              },
                                              child: Icon(Icons.search),
                                            ),
                                            SizedBox(
                                              width: 10,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    _buildPlanTabs(),
                                    Divider(),
                                    Expanded(
                                      child: (showSearchResult)
                                          ? (mobilePlansFiltered.length == 0)
                                              ? Center(
                                                  child: Text("No plan found"),
                                                )
                                              : _buildPlanFilterList()
                                          : (mobilePlans.length == 0)
                                              ? Container()
                                              : _buildPlanDetail(),
                                    )
                                  ],
                                ),
                              ))
                    ],
                  )));
  }

  Future getBBPSToken() async {
    setState(() {
      loading = true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response =
        await http.post(Uri.parse(generateTokenBbpsAPI), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        var status = data['status'];
        if (status.toString() == "1") {
          bbpsToken = data['bbps_token'].toString();

          if (widget.mobileNo != "") {
            setState(() {
              isPickContact = true;
              phoneController =
                  TextEditingController(text: "${widget.mobileNo}");
              if (widget.mobileNo.toString().length == 10) {
                getMobileDetails(widget.mobileNo);
              }
            });
          }
        } else {
          showToastMessage(somethingWrong);
        }
      });
    } else {
      setState(() {
        isPickContact = false;
      });
      showToastMessage(status500);
    }
  }

  Future getMobileDetails(mobile) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while we are fetching your details");
          });
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "token": "$bbpsToken",
      "mobile": "$mobile"
    };

    final response = await http.post(Uri.parse(fetchMobileDetail),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Mobile Plan : $data");

      setState(() {
        Navigator.pop(context);
        var status = data['status'];
        isPickContact = true;
        if (status.toString() == "1") {
          if (data['result'].toString() != "null") {
            var code = data['result']['code'];
            if (code.toString() == "200") {
              operatorFirstCode =
                  data['result']['payload']['operatorCode'].toString();
              operatorFirstName =
                  data['result']['payload']['operatorName'].toString();
              circleFirstName =
                  data['result']['payload']['circleName'].toString();
              circleFirstefID =
                  data['result']['payload']['circleRefID'].toString();
              getMobilePans(circleFirstefID, operatorFirstCode);
            } else {
              setState(() {
                showToastMessage(somethingWrong);
              });
            }
          } else {
            showToastMessage(somethingWrong);
          }
        } else {
          var code = data['message']['code'].toString();
          var status = data['message']['status'].toString();
          if (code.toString() == "600" && status.toString() == "FAILURE") {
            printMessage(screen, "CALLING CYRUS API");
            getOperatorsListForCyrus();
          }
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  Future getCyrusMobilePlans() async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while we are fetching mobile plans");
          });

      isPickContact = true;
    });

    var mobile = phoneController.text.toString();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    var body = {
      "circle_code": stateCode,
      "operator_code": operatorSecCode,
      "mobile": mobile,
    };

    final response = await http.post(Uri.parse(getMobileAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var result = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Cyrus Plan : $result");

      setState(() {
        Navigator.pop(context);
        if (result['status'].toString() == "1") {
          var data =
              Plans.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

          if (result['recharge_type'].length != 0) {
            for (int i = 0; i < result['recharge_type'].length; i++) {
              var value = result['recharge_type'][i].toString();

              rechargeTypes.add(value);
            }
            rechargeTypes.insert(0, "All");
          }
          if (result['plan_list'].length != 0) {
            for (int i = 0; i < result['plan_list'].length; i++) {
              var planName =
                  result['plan_list'][i]['recharge_amount'].toString();
              var price = result['plan_list'][i]['recharge_amount'].toString();
              var validity =
                  result['plan_list'][i]['recharge_validity'].toString();
              var talkTime =
                  result['plan_list'][i]['recharge_talktime'].toString();
              var validityDescription =
                  result['plan_list'][i]['recharge_short_desc'].toString();
              var packageDescription =
                  result['plan_list'][i]['recharge_long_desc'].toString();
              var planType = result['plan_list'][i]['recharge_type'].toString();

              MobilePlan mobPlan = new MobilePlan(
                planName: "$planName",
                price: "$price",
                validity: "$validity",
                talkTime: "$talkTime",
                validityDescription: "$validityDescription",
                packageDescription: "$packageDescription",
                planType: "$planType",
              );

              mobilePlans.add(mobPlan);
            }
          }
        } else {
          showToastMessage(result['message'].toString());
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  Future getMobilePans(circleId, operatorId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message: "Please wait, while we are fetching mobile plans");
          });
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "token": "$bbpsToken",
      "circleId": "$circleId",
      "operatorId": "$operatorId",
    };

    printMessage(screen, "Plan body : $body");

    final response = await http.post(Uri.parse(fetchMobilePlan),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        Navigator.pop(context);
        var status = data['status'];
        if (status.toString() == "1") {
          if (data['plan_list'].toString() != "null") {
            var code = data['plan_list']['code'];
            if (code.toString() == "200") {
              var plans = data['plan_list']['payload'][0]['circleWisePlanLists']
                  [0]['plansInfo'];

              if (data['planType'].length != 0) {
                for (int i = 0; i < data['planType'].length; i++) {
                  var value = data['planType'][i].toString();
                  rechargeTypes.add(value);
                }
                rechargeTypes.insert(0, "All");
              }

              if (plans.length != 0) {
                for (int i = 0; i < plans.length; i++) {
                  var planName = plans[i]['planName'].toString();
                  var price = plans[i]['price'].toString();
                  var validity = plans[i]['validity'].toString();
                  var talkTime = plans[i]['talkTime'].toString();
                  var validityDescription =
                      plans[i]['validityDescription'].toString();
                  var packageDescription =
                      plans[i]['packageDescription'].toString();
                  var planType = plans[i]['planType'].toString();

                  MobilePlan mobPlan = new MobilePlan(
                    planName: "$planName",
                    price: "$price",
                    validity: "$validity",
                    talkTime: "$talkTime",
                    validityDescription: "$validityDescription",
                    packageDescription: "$packageDescription",
                    planType: "$planType",
                  );

                  mobilePlans.add(mobPlan);
                }
              }
            } else {
              setState(() {
                showToastMessage(somethingWrong);
              });
            }
          } else {
            showToastMessage(somethingWrong);
          }
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

    getOperatorsList();
    getCircleList();
  }

  _buildPlanTabs() {
    return Container(
      height: 30,
      margin: EdgeInsets.only(left: 15, right: 25, top: 10, bottom: 0),
      child: ListView.builder(
          itemCount: rechargeTypes.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                var text = rechargeTypes[index].toString();
                setState(() {
                  typeIndex = index;
                });

                if (text.toString() == "All") {
                  setState(() {
                    showSearchResult = false;
                  });
                } else {
                  searchByType(rechargeTypes[index].toString());
                }
              },
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Text(
                  rechargeTypes[index].toString().toUpperCase(),
                  style: TextStyle(
                      color: (typeIndex == index) ? lightBlue : black,
                      fontSize: font14),
                  textAlign: TextAlign.center,
                ),
              )),
            );
          }),
    );
  }

  _buildPlanDetail() {
    return ListView.builder(
        itemCount: mobilePlans.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: gray)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0.0, top: 5, bottom: 5, right: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$plan",
                          style: TextStyle(color: lightBlack, fontSize: font11),
                        ),
                        Text(
                          "$rupeeSymbol ${mobilePlans[index].price}",
                          style: TextStyle(color: dotColor, fontSize: font14),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$validity",
                          style: TextStyle(color: lightBlack, fontSize: font12),
                        ),
                        Text(
                          "${mobilePlans[index].validity}",
                          style: TextStyle(
                              color: dotColor,
                              fontSize: font14,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      var planName = mobilePlans[index].planName;
                      var price = mobilePlans[index].price;
                      var validity = mobilePlans[index].validity;
                      var talkTime = mobilePlans[index].talkTime;
                      var validityDescription =
                          mobilePlans[index].validityDescription;
                      var packageDescription =
                          mobilePlans[index].packageDescription;
                      var planType = mobilePlans[index].planType;

                      var mobileNo = phoneController.text.toString();

                      _showPlan(
                          planName,
                          price,
                          validity,
                          talkTime,
                          validityDescription,
                          packageDescription,
                          planType,
                          mobileNo,
                          operatorFirstCode,
                          operatorFirstName,
                          circleFirstName,
                          circleFirstefID,
                          operatorSecCode,
                          stateCode,
                          operatorSecName,
                          billerImg,
                          stateName);
                    },
                    child: Text(
                      "$viewDeatil",
                      style: TextStyle(color: lightBlue, fontSize: font12),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                    decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: lightBlue)),
                    child: InkWell(
                      onTap: () {
                        var planName = mobilePlans[index].planName;
                        var price = mobilePlans[index].price;
                        var validity = mobilePlans[index].validity;
                        var talkTime = mobilePlans[index].talkTime;
                        var validityDescription =
                            mobilePlans[index].validityDescription;
                        var packageDescription =
                            mobilePlans[index].packageDescription;
                        var planType = mobilePlans[index].planType;

                        var mobileNo = phoneController.text.toString();

                        Map map = {
                          "planName": "$planName",
                          "price": "$price",
                          "validity": "$validity",
                          "talkTime": "$talkTime",
                          "validityDescription": "$validityDescription",
                          "packageDescription": "$packageDescription",
                          "planType": "$planType",
                          "mobileNo": "$mobileNo",
                          "operatorCode": "$operatorFirstCode",
                          "operatorName": "$operatorFirstName",
                          "circleName": "$circleFirstName",
                          "circleRefID": "$circleFirstefID",
                          "bbpsToken": "$bbpsToken",
                          "operatorSecCode": "$operatorSecCode",
                          "stateCode": "$stateCode",
                          "operatorSecName": "$operatorSecName",
                          "category": "$category",
                          "billerImg": "$billerImg",
                          "stateName": "$stateName",
                        };

                        //openMobilePayment(context, map);
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 4, bottom: 4),
                          child: Text(
                            "$buy",
                            style: TextStyle(
                              color: white,
                              fontSize: font14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          );
        });
  }

  _buildPlanFilterList() {
    return ListView.builder(
        itemCount: mobilePlansFiltered.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, bottom: 15),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: gray)),
            child: Padding(
              padding:
                  const EdgeInsets.only(left: 0.0, top: 5, bottom: 5, right: 0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$plan",
                          style: TextStyle(color: lightBlack, fontSize: font11),
                        ),
                        Text(
                          "$rupeeSymbol ${mobilePlansFiltered[index].price}",
                          style: TextStyle(color: dotColor, fontSize: font14),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$validity",
                          style: TextStyle(color: lightBlack, fontSize: font12),
                        ),
                        Text(
                          "${mobilePlansFiltered[index].validity}",
                          style: TextStyle(
                              color: dotColor,
                              fontSize: font14,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      var planName = mobilePlansFiltered[index].planName;
                      var price = mobilePlansFiltered[index].price;
                      var validity = mobilePlansFiltered[index].validity;
                      var talkTime = mobilePlansFiltered[index].talkTime;
                      var validityDescription =
                          mobilePlansFiltered[index].validityDescription;
                      var packageDescription =
                          mobilePlansFiltered[index].packageDescription;
                      var planType = mobilePlansFiltered[index].planType;

                      var mobileNo = phoneController.text.toString();

                      _showPlan(
                          planName,
                          price,
                          validity,
                          talkTime,
                          validityDescription,
                          packageDescription,
                          planType,
                          mobileNo,
                          operatorFirstCode,
                          operatorFirstName,
                          circleFirstName,
                          circleFirstefID,
                          operatorSecCode,
                          stateCode,
                          operatorSecName,
                          billerImg,
                          stateName);
                    },
                    child: Text(
                      "$viewDeatil",
                      style: TextStyle(color: lightBlue, fontSize: font12),
                    ),
                  ),
                  SizedBox(
                    width: 30,
                  ),
                  Container(
                    margin:
                        EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                    decoration: BoxDecoration(
                        color: lightBlue,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(color: lightBlue)),
                    child: InkWell(
                      onTap: () {
                        var planName = mobilePlansFiltered[index].planName;
                        var price = mobilePlansFiltered[index].price;
                        var validity = mobilePlansFiltered[index].validity;
                        var talkTime = mobilePlansFiltered[index].talkTime;
                        var validityDescription =
                            mobilePlansFiltered[index].validityDescription;
                        var packageDescription =
                            mobilePlansFiltered[index].packageDescription;
                        var planType = mobilePlansFiltered[index].planType;

                        var mobileNo = phoneController.text.toString();

                        Map map = {
                          "planName": "$planName",
                          "price": "$price",
                          "validity": "$validity",
                          "talkTime": "$talkTime",
                          "validityDescription": "$validityDescription",
                          "packageDescription": "$packageDescription",
                          "planType": "$planType",
                          "mobileNo": "$mobileNo",
                          "operatorCode": "$operatorFirstCode",
                          "operatorName": "$operatorFirstName",
                          "circleName": "$circleFirstName",
                          "circleRefID": "$circleFirstefID",
                          "bbpsToken": "$bbpsToken",
                          "operatorSecCode": "$operatorSecCode",
                          "stateCode": "$stateCode",
                          "operatorSecName": "$operatorSecName",
                          "category": "$category",
                          "billerImg": "$billerImg",
                          "stateName": "$stateName",
                        };

                        //openMobilePayment(context, map);
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 4, bottom: 4),
                          child: Text(
                            "$buy",
                            style: TextStyle(
                              color: white,
                              fontSize: font14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20,
                  )
                ],
              ),
            ),
          );
        });
  }

  searchByType(String text) async {
    mobilePlansFiltered.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    mobilePlans.forEach((userDetail) {
      if (userDetail.planType.toString().toLowerCase() == text.toLowerCase()) {
        mobilePlansFiltered.add(userDetail);
      }
    });

    setState(() {
      if (mobilePlansFiltered.length != 0) {
        showSearchResult = true;
      }
    });
  }

  onSearchTextChanged(String text) async {
    mobilePlansFiltered.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    mobilePlans.forEach((userDetail) {
      if (userDetail.price.toString() == text) {
        mobilePlansFiltered.add(userDetail);
      }
    });

    setState(() {
      if (mobilePlansFiltered.length != 0) {
        showSearchResult = true;
      }
    });
  }

  _buildContactSection() {
    return (_contacts.length == 0)
        ? Container()
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                (resentList.length == 0)
                    ? Container()
                    : Padding(
                        padding: const EdgeInsets.only(left: 40.0, top: 20),
                        child: Text(
                          "Recent Transactions",
                          style: TextStyle(
                              color: black, fontWeight: FontWeight.bold),
                        ),
                      ),
                (resentList.length == 0) ? Container() : _buildRecentTrans(),
                (myFilteredContacts.length != 0)
                    ? Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, top: 10, bottom: 10),
                        child: ListView.builder(
                          itemCount: myFilteredContacts.length,
                          shrinkWrap: true,
                          physics: ScrollPhysics(),
                          itemBuilder: (context, index) {
                            return (myFilteredContacts[index].name.toString() !=
                                    "null")
                                ? Padding(
                                    padding: const EdgeInsets.only(
                                        left: 10.0, right: 10),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            var number =
                                                myFilteredContacts[index].phone;
                                            setState(() {
                                              isPickContact = true;
                                              phoneController =
                                                  TextEditingController(
                                                      text:
                                                          "${number.toString()}");
                                              if (number.toString().length ==
                                                  10) {
                                                closeKeyBoard(context);
                                                getMobileDetails(
                                                    number.toString());
                                              }
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40,
                                                width: 40,
                                                decoration: BoxDecoration(
                                                    color: lightBlue,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: lightBlue,
                                                        width: 3)),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Image.asset(
                                                        'assets/user.png'),
                                                  ) /*Text(
                                        "${shortName(myFilteredContacts[index].name.toString())}",
                                        style: TextStyle(
                                            color: white,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                        textAlign: TextAlign.center,
                                      )*/
                                                  ,
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                myFilteredContacts[index].name,
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font16,
                                                    fontWeight:
                                                        FontWeight.w500),
                                              ),
                                              Spacer(),
                                              (myFilteredContacts[index]
                                                          .isMP
                                                          .toString() ==
                                                      "true")
                                                  ? Container(
                                                      child: Row(
                                                        children: [
                                                          SizedBox(
                                                            width: 10,
                                                          ),
                                                          Image.asset(
                                                            'assets/appM_logo.png',
                                                            height: 20,
                                                          ),
                                                          SizedBox(
                                                            width: 5,
                                                          ),
                                                          Text(
                                                            "Verified",
                                                            style: TextStyle(
                                                                color: green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    font13),
                                                          ),
                                                        ],
                                                      ),
                                                    )
                                                  : Container()
                                            ],
                                          ),
                                        ),
                                        Divider(),
                                      ],
                                    ),
                                  )
                                : Container();
                          },
                        ),
                      )
                    : Container(),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10),
                  child: Text(
                    "All Contacts",
                    style: TextStyle(color: black, fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 15.0, right: 15, top: 10, bottom: 10),
                  child: ListView.builder(
                    itemCount: _contacts.length,
                    shrinkWrap: true,
                    physics: ScrollPhysics(),
                    itemBuilder: (context, index) {
                      return (_contacts[index].displayName.toString() !=
                                  "null" &&
                              _contacts[index].phones?.length != 0)
                          ? Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: InkWell(
                                onTap: () {
                                  List<Item>? _items = _contacts[index].phones;

                                  if (_items?.length != 0) {
                                    String? number =
                                        _items?[0].value.toString();

                                    if (number.toString().contains("-")) {
                                      number = number?.replaceAll("-", "");
                                    }

                                    if (number.toString().contains(" ")) {
                                      number = number?.replaceAll(" ", "");
                                    }

                                    if (number.toString().contains("+")) {
                                      number = number.toString().substring(
                                          3, number.toString().length);
                                    }

                                    if (number.toString().length > 10) {
                                      number = number.toString().substring(
                                          1, number.toString().length);
                                    }

                                    setState(() {
                                      isPickContact = true;
                                      phoneController = TextEditingController(
                                          text: "${number.toString()}");
                                      if (number.toString().length == 10) {
                                        closeKeyBoard(context);
                                        getMobileDetails(number.toString());
                                      }
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: lightBlue,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: lightBlue, width: 3)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset('assets/user.png'),
                                        ) /*Text(
                                                "${shortName(_contacts[index].displayName.toString())}"
                                                    .toUpperCase(),
                                                style: TextStyle(
                                                    color: white,
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.bold),
                                                textAlign: TextAlign.center,
                                              )*/
                                        ,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10,
                                    ),
                                    Text(
                                      _contacts[index].displayName ?? "",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: font16,
                                          fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : Container();
                    },
                  ),
                )
              ],
            ),
          );
  }

  _showPlan(
      planName,
      price,
      validity,
      talkTime,
      validityDescription,
      packageDescription,
      planType,
      mobileNo,
      operatorCode,
      operatorName,
      circleName,
      circleRefID,
      operatorSecCode,
      stateCode,
      operatorSecName,
      billerImg,
      stateName) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: showPlanDetail(
                  planName: planName,
                  price: price,
                  validity: validity,
                  talkTime: talkTime,
                  validityDescription: validityDescription,
                  packageDescription: packageDescription,
                  planType: planType,
                  mobileNo: mobileNo,
                  operatorCode: operatorCode,
                  operatorName: operatorName,
                  circleName: circleName,
                  circleRefID: circleRefID,
                  bbpsToken: bbpsToken,
                  operatorSecCode: operatorSecCode,
                  stateCode: stateCode,
                  operatorSecName: operatorSecName,
                  billerImg: billerImg,
                  stateName: stateName),
            ));
  }

  Future getOperatorsList() async {
    setState(() {
      operatorNames.clear();
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "category": "$category",
    };

    final response = await http.post(Uri.parse(getBillerCategoryAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data =
          Operators.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      setState(() {
        operatorNames = data.billerName;

        if (operatorNames.length != 0) {
          for (int i = 0; i < operatorNames.length; i++) {
            var opName = operatorNames[i].billerName.toString();

            if (operatorFirstName.toLowerCase() == "bsnl") {
              operatorSecCode = "BSV";
              operatorSecName = "BSNL Recharge/Validity (RCV)";
              billerImg = "1629708795.jpg";
              break;
            } else if (operatorFirstName.toLowerCase() ==
                "VODAFONE".toLowerCase()) {
              operatorSecCode = "VF";
              operatorSecName = "VodafoneIdea";
              billerImg = "1629707063.webp";
              break;
            } else {
              if (opName.toLowerCase() == "$operatorFirstName".toLowerCase()) {
                operatorSecCode = operatorNames[i].operatorCode.toString();
                operatorSecName = operatorNames[i].billerName.toString();
                billerImg = operatorNames[i].icons.toString();
                break;
              }
            }
          }
        }
      });
    } else {
      setState(() {});
      showToastMessage(status500);
    }
  }

  Future getCircleList() async {
    setState(() {
      stateList.clear();
    });

    var userlocalState = await getlocState();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response = await http.post(Uri.parse(getCircleAPI), headers: headers);

    var data = Circles.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

    setState(() {
      stateList = data.stateList;

      if (stateList.length != 0) {
        for (int i = 0; i < stateList.length; i++) {
          var stateN = stateList[i].state.toString();
          if (stateN.toLowerCase() == "$circleFirstName".toLowerCase()) {
            stateName = stateList[i].state.toString();
            stateCode = stateList[i].code.toString();
            break;
          }
        }

        if (stateName.toString() == "") {
          printMessage(screen, "Operator State Name------->$circleFirstName");
          for (int i = 0; i < stateList.length; i++) {
            var stateN = stateList[i].state.toString();
            if (stateN.toString().toLowerCase() ==
                userlocalState.toString().toLowerCase()) {
              printMessage(screen, "<---------INSIDE------->");
              stateName = stateList[i].state.toString();
              stateCode = stateList[i].code.toString();
              break;
            }
          }
        }
      }
    });
  }

  _showOperatorList() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .6,
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          color: gray,
                          width: 50,
                          height: 5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, top: 20),
                        child: Text(
                          "Select your Operator",
                          style: TextStyle(
                              color: black,
                              fontSize: font16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Divider(
                        color: gray,
                      ),
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: operatorNames.length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          planList.clear();
                                          //rechargeTypes.clear();
                                          operatorSecName = operatorNames[index]
                                              .billerName
                                              .toString();

                                          operatorSecCode = operatorNames[index]
                                              .operatorCode
                                              .toString();

                                          billerImg = operatorNames[index]
                                              .icons
                                              .toString();

                                          Navigator.pop(context);
                                          _showStateList();
                                        });
                                      },
                                      child: Row(
                                        children: [
                                          SizedBox(
                                            width: 10,
                                          ),
                                          SizedBox(
                                            width: 36,
                                            height: 36,
                                            child: Image.network(
                                              "$imageSubAPI${operatorNames[index].icons}",
                                              width: 36,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 10,
                                          ),
                                          Text(
                                            operatorNames[index].billerName,
                                            style: TextStyle(
                                                color: black, fontSize: font15),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                  Divider()
                                ],
                              );
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  _showStateList() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .5,
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.0)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: Container(
                          color: gray,
                          width: 50,
                          height: 5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, top: 20),
                        child: Text(
                          "Select your Circle",
                          style: TextStyle(
                              color: black,
                              fontSize: font16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Divider(
                        color: gray,
                      ),
                      Expanded(
                        flex: 1,
                        child: ListView.builder(
                            itemCount: stateList.length,
                            shrinkWrap: true,
                            physics: ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          stateName =
                                              stateList[index].state.toString();
                                          stateCode =
                                              stateList[index].code.toString();
                                          Navigator.pop(context);
                                        });
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        child: Padding(
                                          padding: const EdgeInsets.all(12.0),
                                          child: Text(
                                            stateList[index].state,
                                            style: TextStyle(
                                                color: black, fontSize: font15),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Divider(),
                                  ],
                                ),
                              );
                            }),
                      ),
                    ],
                  ),
                )
              ],
            ));
  }

  Future<void> _askContactPermissions() async {
    PermissionStatus permissionStatus = await _getContactPermission();
    if (permissionStatus == PermissionStatus.granted) {
      refreshContacts();
    } else {
      setState(() {
        loading = false;
      });
      _handleInvalidPermissions(permissionStatus);
    }
  }

  Future<void> refreshContacts() async {
    var contacts = (await ContactsService.getContacts(
            withThumbnails: false, iOSLocalizedLabels: iOSLocalizedLabels))
        .toList();
    setState(() {
      _contacts.clear();
      _contacts = contacts;
      checkMpContacts();
    });
    setState(() {
      loading = false;
    });
  }

  Future<PermissionStatus> _getContactPermission() async {
    PermissionStatus permission = await Permission.contacts.status;
    if (permission != PermissionStatus.granted &&
        permission != PermissionStatus.permanentlyDenied) {
      PermissionStatus permissionStatus = await Permission.contacts.request();
      return permissionStatus;
    } else {
      return permission;
    }
  }

  void _handleInvalidPermissions(PermissionStatus permissionStatus) {
    if (permissionStatus == PermissionStatus.denied) {
      final snackBar = SnackBar(content: Text('Access to contact data denied'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (permissionStatus == PermissionStatus.permanentlyDenied) {
      final snackBar =
          SnackBar(content: Text('Contact data not available on device'));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

    setState(() {
      loading = false;
    });
  }

  _showContactList() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Wrap(
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * .9,
                  width: MediaQuery.of(context).size.width,
                  decoration: new BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.0)),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 4,
                        width: 50,
                        color: gray,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, top: 15),
                        child: Text(
                          "Select your contact",
                          style: TextStyle(
                              color: black,
                              fontSize: font16,
                              fontWeight: FontWeight.w700),
                        ),
                      ),
                      Divider(
                        color: gray,
                      ),
                      _searchContact(),
                      (showFiltedContact)
                          ? Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: _contactFilter.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return (_contactFilter[index]
                                                  .displayName
                                                  .toString() !=
                                              "null" &&
                                          _contactFilter[index]
                                                  .phones
                                                  ?.length !=
                                              0)
                                      ? ListTile(
                                          onTap: () {
                                            List<Item>? _items =
                                                _contactFilter[index].phones;

                                            if (_items?.length != 0) {
                                              String? number =
                                                  _items?[0].value.toString();

                                              if (number
                                                  .toString()
                                                  .contains("-")) {
                                                number =
                                                    number?.replaceAll("-", "");
                                              }

                                              if (number
                                                  .toString()
                                                  .contains(" ")) {
                                                number =
                                                    number?.replaceAll(" ", "");
                                              }

                                              if (number
                                                  .toString()
                                                  .contains("+")) {
                                                number = number
                                                    .toString()
                                                    .substring(
                                                        3,
                                                        number
                                                            .toString()
                                                            .length);
                                              }

                                              if (number.toString().length >
                                                  10) {
                                                number = number
                                                    .toString()
                                                    .substring(
                                                        1,
                                                        number
                                                            .toString()
                                                            .length);
                                              }

                                              setState(() {
                                                phoneController =
                                                    TextEditingController(
                                                        text:
                                                            "${number.toString()}");
                                                if (number.toString().length ==
                                                    10) {
                                                  closeKeyBoard(context);
                                                  getMobileDetails(
                                                      number.toString());
                                                }
                                              });
                                            }
                                            Navigator.pop(context);
                                          },
                                          leading: CircleAvatar(
                                              child: Text(_contactFilter[index]
                                                  .initials())),
                                          title: Text(_contactFilter[index]
                                                  .displayName ??
                                              ""),
                                        )
                                      : Container();
                                },
                              ),
                            )
                          : Expanded(
                              flex: 1,
                              child: ListView.builder(
                                itemCount: _contacts.length,
                                shrinkWrap: true,
                                physics: ScrollPhysics(),
                                itemBuilder: (context, index) {
                                  return (_contacts[index]
                                                  .displayName
                                                  .toString() !=
                                              "null" &&
                                          _contacts[index].phones?.length != 0)
                                      ? ListTile(
                                          onTap: () {
                                            List<Item>? _items =
                                                _contacts[index].phones;

                                            if (_items?.length != 0) {
                                              String? number =
                                                  _items?[0].value.toString();

                                              if (number
                                                  .toString()
                                                  .contains("-")) {
                                                number =
                                                    number?.replaceAll("-", "");
                                              }

                                              if (number
                                                  .toString()
                                                  .contains(" ")) {
                                                number =
                                                    number?.replaceAll(" ", "");
                                              }

                                              if (number
                                                  .toString()
                                                  .contains("+")) {
                                                number = number
                                                    .toString()
                                                    .substring(
                                                        3,
                                                        number
                                                            .toString()
                                                            .length);
                                              }

                                              if (number.toString().length >
                                                  10) {
                                                number = number
                                                    .toString()
                                                    .substring(
                                                        1,
                                                        number
                                                            .toString()
                                                            .length);
                                              }

                                              setState(() {
                                                phoneController =
                                                    TextEditingController(
                                                        text:
                                                            "${number.toString()}");

                                                if (number.toString().length ==
                                                    10) {
                                                  closeKeyBoard(context);
                                                  getMobileDetails(
                                                      number.toString());
                                                }
                                              });
                                            }
                                            Navigator.pop(context);
                                          },
                                          leading: CircleAvatar(
                                              child: Text(
                                                  _contacts[index].initials())),
                                          title: Text(
                                              _contacts[index].displayName ??
                                                  ""),
                                        )
                                      : Container();
                                },
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ));
  }

  _searchContact() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 15, right: 15, left: 15),
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: editBg)),
      child: Row(
        children: [
          SizedBox(
            width: 15,
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              style: TextStyle(color: black, fontSize: inputFont),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              controller: searchName,
              textCapitalization: TextCapitalization.characters,
              decoration: new InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                hintText: "Search contact by name",
                hintStyle: TextStyle(color: black),
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              maxLength: 20,
              onFieldSubmitted: (val) {
                onSearchNameChanged(val.toString());
              },
              onChanged: (val) {
                setState(() {
                  if (val.length == 0) {
                    showFiltedContact = false;
                  } else {
                    showFiltedContact = true;
                    onSearchNameChanged(val.toString());
                  }
                });
              },
            ),
          ),
          SizedBox(
            width: 15,
          )
        ],
      ),
    );
  }

  onSearchNameChanged(String text) async {
    _contactFilter.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    _contacts.forEach((userDetail) {
      if (userDetail.displayName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        _contactFilter.add(userDetail);
      }
    });

    setState(() {
      if (_contactFilter.length != 0) {
        showFiltedContact = true;
      }
    });
  }

  Future getRecentTransactions() async {
    setState(() {});

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "category": "$category",
    };

    final response = await http.post(Uri.parse(resentTransaction),
        body: jsonEncode(body), headers: headers);

    var data =
        RecentTransaction.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

    setState(() {
      var status = data.status;

      if (status.toString() == "1") {
        resentList = data.resentList;
      }
    });
  }

  _buildRecentTrans() {
    return ListView.builder(
        itemCount: resentList.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 20, right: 20, top: 10),
            padding: EdgeInsets.only(left: 10, right: 10, top: 4, bottom: 4),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: gray)),
            child: InkWell(
              onTap: () {
                setState(() {
                  var number = resentList[index].param;
                  phoneController =
                      TextEditingController(text: "${number.toString()}");
                  if (number.toString().length == 10) {
                    closeKeyBoard(context);
                    getMobileDetails(number.toString());
                  }
                });
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${resentList[index].param}",
                          style: TextStyle(
                              color: black,
                              fontSize: font14,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                        Text(
                          "${resentList[index].operatorName}",
                          style: TextStyle(
                              color: black,
                              fontSize: font14,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 4,
                        ),
                        Text(
                          (resentList[index].date.toString() == "null")
                              ? "NA"
                              : "${convertDateFormat(resentList[index].date.toString())}",
                          style: TextStyle(
                              color: lightBlack,
                              fontSize: font12,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    "$rupeeSymbol ${resentList[index].amount}",
                    style: TextStyle(
                        color: orange,
                        fontSize: font16,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                  SizedBox(
                    width: 4,
                  ),
                ],
              ),
            ),
          );
        });
  }

  String convertDateFormat(String dateTimeString) {
    DateFormat newDateFormat = DateFormat("dd/mm/yyyy");
    DateTime dateTime = DateFormat("dd/mm/yyyy hh:MM:ss").parse(dateTimeString);
    String selectedDate = newDateFormat.format(dateTime);
    return selectedDate;
  }

  checkMpContacts() async {
    for (int p = 0; p < _contacts.length; p++) {
      if (_contacts[p].phones!.length != 0) {
        var phone = _contacts[p].phones![0].value.toString();
        if (phone.toString().contains("-")) {
          phone = phone.replaceAll("-", "");
        }

        if (phone.toString().contains(" ")) {
          phone = phone.replaceAll(" ", "");
        }

        if (phone.toString().contains("+")) {
          phone = phone.toString().substring(3, phone.toString().length);
        }

        if (phone.toString().length > 10) {
          phone = phone.toString().substring(1, phone.toString().length);
        }

        if (phone.toString().length == 10) {
          var name = _contacts[p].displayName;
          MyContacts cont = new MyContacts(name: "$name", phone: "$phone");
          myContacts.add(cont);
        }
      }
    }

    saveContactCount(myContacts.length);

    int count = await getContactCount();

    if (count != 0) {
      checkMobile();
      if (count == myContacts.length) {
      } else {}
    }
  }

  Future checkMobile() async {
    var token = await getToken();
    try {
      var headers = {
        "Authorization": "$authHeader",
        "userToken": "$token",
        "Content-Type": "application/x-www-form-urlencoded"
      };

      var body = {"phoneData": myContacts};

      final jsonString = json.encode(body);

      final response = await http.post(Uri.parse(checkMobileAPI),
          body: jsonString, headers: headers);

      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        if (data['status'].toString() == "1") {
          var result =
              MpContacts.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          phoneListn = result.phoneList;

          for (int i = 0; i < phoneListn.length; i++) {
            var phone = phoneListn[i].keys.toString();
            var values = phoneListn[i].values;

            if (phone.toString().contains("("))
              phone = phone.replaceAll("(", "");

            if (phone.toString().contains(")"))
              phone = phone.replaceAll(")", "");

            for (int h = 0; h < myContacts.length; h++) {
              var myName = myContacts[h].name;
              var myPhone = myContacts[h].phone;

              if (myPhone == phone) {
                MyContacts cont = new MyContacts(
                    name: "$myName", phone: "$phone", isMP: "true");
                myFilteredContacts.add(cont);
                break;
              }
            }
          }
        }
      });

      setState(() {
        myFilteredContacts = myFilteredContacts.toSet().toList();
      });
    } catch (e) {
      printMessage(screen, "Error : ${e.toString()}");
    }
  }

  String shortName(name) {
    String sName = "";

    if (name.toString().contains(" ")) {
      var parts = name.toString().split(' ');
      var fChar = parts[0][0];
      var lChar = parts[1][0];
      sName = "$fChar$lChar";
    } else {
      sName = name.toString()[0];
    }

    return sName;
  }

  Future getOperatorsListForCyrus() async {
    setState(() {
      operatorNames.clear();
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "category": "$category",
    };

    final response = await http.post(Uri.parse(getBillerCategoryAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data =
          Operators.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

      setState(() {
        operatorNames = data.billerName;

        if (operatorNames.length != 0) {
          for (int i = 0; i < operatorNames.length; i++) {
            var opName = operatorNames[i].billerName.toString();

            if (operatorFirstName.toLowerCase() == "bsnl") {
              operatorSecCode = "BSV";
              operatorSecName = "BSNL Recharge/Validity (RCV)";
              billerImg = "1629708795.jpg";
              break;
            } else if (operatorFirstName.toLowerCase() ==
                "VODAFONE".toLowerCase()) {
              operatorSecCode = "VF";
              operatorSecName = "VodafoneIdea";
              billerImg = "1629707063.webp";
              break;
            } else {
              if (opName.toLowerCase() == "$operatorFirstName".toLowerCase()) {
                operatorSecCode = operatorNames[i].operatorCode.toString();
                operatorSecName = operatorNames[i].billerName.toString();
                billerImg = operatorNames[i].icons.toString();
                break;
              } else {
                operatorSecCode = "VF";
                operatorSecName = "VodafoneIdea";
                billerImg = "1629707063.webp";
              }
            }
          }
        }
      });
    } else {
      setState(() {});
      showToastMessage(status500);
    }

    getCircleListForCyrus();
  }

  Future getCircleListForCyrus() async {
    setState(() {
      stateList.clear();
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final response = await http.post(Uri.parse(getCircleAPI), headers: headers);

    var data = Circles.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

    var userStateName = await getState();
    var userlocalState = await getlocState();

    setState(() {
      stateList = data.stateList;

      if (stateList.length != 0) {
        for (int i = 0; i < stateList.length; i++) {
          var stateN = stateList[i].state.toString();
          if (stateN.toLowerCase() == "$circleFirstName".toLowerCase()) {
            stateName = stateList[i].state.toString();
            stateCode = stateList[i].code.toString();
            break;
          }
        }

        if (stateName.toString() == "") {
          for (int i = 0; i < stateList.length; i++) {
            if (userStateName.toString() == "null") {
              var stateN = stateList[i].state.toString();
              if (stateN.toLowerCase() == "$userlocalState".toLowerCase()) {
                stateName = stateList[i].state.toString();
                stateCode = stateList[i].code.toString();
                break;
              }
            } else {
              var stateN = stateList[i].state.toString();
              if (stateN.toLowerCase() == "$userStateName".toLowerCase()) {
                stateName = stateList[i].state.toString();
                stateCode = stateList[i].code.toString();
                break;
              }
            }
          }
        }
      }
    });

    getCyrusMobilePlans();
  }
}

class showPlanDetail extends StatelessWidget {
  final String planName,
      price,
      validity,
      talkTime,
      validityDescription,
      packageDescription,
      planType,
      mobileNo,
      operatorCode,
      operatorName,
      circleName,
      circleRefID,
      bbpsToken,
      operatorSecCode,
      stateCode,
      operatorSecName,
      billerImg,
      stateName;

  const showPlanDetail(
      {Key? key,
      required this.planName,
      required this.price,
      required this.validity,
      required this.talkTime,
      required this.validityDescription,
      required this.packageDescription,
      required this.planType,
      required this.mobileNo,
      required this.operatorCode,
      required this.operatorName,
      required this.circleName,
      required this.circleRefID,
      required this.bbpsToken,
      required this.operatorSecCode,
      required this.stateCode,
      required this.operatorSecName,
      required this.billerImg,
      required this.stateName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        Container(
            child: Column(
              children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(50.0)),
                    color: planBg,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 30.0, right: 30, top: 20),
                        child: Row(
                          children: [
                            Spacer(),
                            InkWell(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: Image.asset(
                                'assets/cancel.png',
                                height: 30,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "$rupeeSymbol ",
                            style: TextStyle(
                                color: black,
                                fontSize: font26,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${price}",
                            style: TextStyle(
                                color: black,
                                fontSize: 48,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      /*Text(
                        "2 GB/DAY PACK",
                        style: TextStyle(color: black, fontSize: font16),
                      ),*/
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30, top: 40),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Plan Name",
                          style: TextStyle(color: lightBlack, fontSize: font16),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "$planName",
                          style: TextStyle(color: black, fontSize: font16),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30, top: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Validity",
                          style: TextStyle(color: lightBlack, fontSize: font16),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "$validity",
                          style: TextStyle(color: black, fontSize: font16),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30, top: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Talk Time",
                          style: TextStyle(color: lightBlack, fontSize: font16),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "$rupeeSymbol $talkTime",
                          style: TextStyle(color: black, fontSize: font16),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.only(left: 30.0, right: 30, top: 20),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 1,
                        child: Text(
                          "Description",
                          style: TextStyle(color: lightBlack, fontSize: font16),
                        ),
                      ),
                      Expanded(
                        flex: 2,
                        child: Text(
                          "$packageDescription",
                          style: TextStyle(color: black, fontSize: font15),
                          textAlign: TextAlign.end,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 40,
                  margin:
                      EdgeInsets.only(left: 20, right: 20, top: 25, bottom: 25),
                  decoration: BoxDecoration(
                      color: lightBlue,
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      border: Border.all(color: lightBlue)),
                  child: InkWell(
                    onTap: () {
                      Map map = {
                        "planName": "$planName",
                        "price": "$price",
                        "validity": "$validity",
                        "talkTime": "$talkTime",
                        "validityDescription": "$validityDescription",
                        "packageDescription": "$packageDescription",
                        "planType": "$planType",
                        "mobileNo": "$mobileNo",
                        "operatorCode": "$operatorCode",
                        "operatorName": "$operatorName",
                        "circleName": "$circleName",
                        "circleRefID": "$circleRefID",
                        "bbpsToken": "$bbpsToken",
                        "operatorSecCode": "$operatorSecCode",
                        "stateCode": "$stateCode",
                        "operatorSecName": "$operatorSecName",
                        "category": "MOBILE PREPAID",
                        "billerImg": "$billerImg",
                        "stateName": "$stateName",
                      };

                     // openMobilePayment(context, map);
                    },
                    child: Center(
                      child: Text(
                        "$buy",
                        style: TextStyle(
                          color: white,
                          fontSize: font16,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
              color: white,
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 10,
                  blurRadius: 10,
                  offset: Offset(0, 1), // changes position of shadow
                ),
              ],
            )),
      ],
    );
  }
}
