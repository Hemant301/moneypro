import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/BillerList.dart';
import 'package:moneypro_new/ui/models/RecentTransaction.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:moneypro_new/utils/StateContainer.dart';

class RechargeSelection extends StatefulWidget {
  final String category;
  final String searchBy;
  final String selectBy;

  const RechargeSelection(
      {Key? key,
      required this.category,
      required this.searchBy,
      required this.selectBy})
      : super(key: key);

  @override
  _RechargeSelectionState createState() => _RechargeSelectionState();
}

class _RechargeSelectionState extends State<RechargeSelection> {
  var screen = "Recharge Selection";

  var loading = false;

  final searchController = new TextEditingController();

  List<BillerListElement> billerList = [];
  List<BillerListElement> billerListFilterd = [];

  List<BillerListElement> currentBillerList = [];

  var showSearchResult = false;

  List<ResentList> resentList = [];

  @override
  void initState() {
    super.initState();
    printMessage(screen, "Current State : $currentState");
    printMessage(screen, "category : ${widget.category}");
    getBillerList();
    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();
    getRecentTransactions();
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();
    double mX =0.0;
    double wX=0.0;

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
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(context, "assets/bbps_2.png", 24.0.w),
      body: (loading)
          ? Center(child: circularProgressLoading(40.0))
          : Stack(
              children: [
                (billerList.length == 0) ? Container() : _searchByBoard(),
                (showSearchResult)
                    ? (billerListFilterd.length == 0)
                        ? NoDataFound(text: "No result found")
                        : _buildFilteredtList()
                    : (billerList.length == 0)
                        ? NoDataFound(text: "No result found")
                        : _buildDefaultList(),
              ],
            ),
    )));
  }

  Future getBillerList() async {
    setState(() {
      loading = true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "category": "${widget.category}",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(billerListAPI),
        body: jsonEncode(body), headers: headers);


    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${data}");

      setState(() {
        loading = false;
        var status = data['status'];
        if (status.toString() == "1") {
          var result =
          BillerList.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          billerList = result.billerList;
          billerList.sort((a, b) => a.billerName.compareTo(b.billerName));

          if (widget.category.toString() == "ELECTRICITY") {
            for (int i = 0; i < billerList.length; i++) {
              if (currentState.toString().toLowerCase() ==
                  billerList[i].state.toString().toLowerCase()) {
                BillerListElement elements = new BillerListElement(
                  billerId: "${billerList[i].billerId}",
                  billerName: "${billerList[i].billerName}",
                  paramName: "${billerList[i].paramName}",
                  paramName1: "${billerList[i].paramName1}",
                  paramName2: "${billerList[i].paramName2}",
                  paramName3: "${billerList[i].paramName3}",
                  paramName4: "${billerList[i].paramName4}",
                  icon: "${billerList[i].icon}",
                  isAdhoc: "${billerList[i].isAdhoc}",
                  fetchOption: "${billerList[i].fetchOption}",
                  state: "${billerList[i].state}",
                  position: billerList[i].position,
                  minLimit: billerList[i].minLimit,
                  maxLimit: billerList[i].maxLimit,
                );
                currentBillerList.add(elements);
              }
            }
            currentBillerList.sort((a, b) => a.billerName.compareTo(b.billerName));
          }
          printMessage(screen, "Biller list : ${currentBillerList.length}");
        }
      });
    }else{
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }


  }

  _searchByBoard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.only(top: padding, left: padding, right: padding),
          decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15, top: 0, bottom: 0),
            child: TextFormField(
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              textCapitalization: TextCapitalization.characters,
              controller: searchController,
              decoration: new InputDecoration(
                isDense: false,
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 10),
                counterText: "",
                hintText: "Search your ${widget.searchBy}",
                floatingLabelBehavior: FloatingLabelBehavior.never,
              ),
              maxLength: 20,
              onChanged: (val) {
                if (val.length > 3) {
                  onSearchTextChanged(val.toString());
                }
                if (val.length == 0) {
                  setState(() {
                    showSearchResult = false;
                  });
                }
              },
              onFieldSubmitted: (val) {
                onSearchTextChanged(val.toString());
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: Text(
            "Select your ${widget.selectBy}",
            style: TextStyle(
                color: black, fontSize: font16.sp, fontWeight: FontWeight.w700),
          ),
        ),
      ],
    );
  }

  _buildSelectedBillerList() {
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(
            height: 20.h,
          ),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.only(left: 30.0, bottom: 20),
              child: Text(
                "Biller from $currentState",
                style: TextStyle(
                    color: black,
                    fontSize: font16.sp,
                    fontWeight: FontWeight.bold),
                textAlign: TextAlign.start,
              ),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
            child: ListView.builder(
                itemCount: currentBillerList.length,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: InkWell(
                          onTap: () {
                            FocusScope.of(context)
                                .requestFocus(new FocusNode());

                            var madatory = currentBillerList[index].fetchOption;
                            var name = currentBillerList[index].billerId;
                            Map map = {
                              "billerId":
                                  "${currentBillerList[index].billerId}",
                              "billerName":
                                  "${currentBillerList[index].billerName}",
                              "paramName":
                                  "${currentBillerList[index].paramName}",
                              "paramName_1":
                                  "${currentBillerList[index].paramName1}",
                              "paramName_2":
                                  "${currentBillerList[index].paramName2}",
                              "paramName_3":
                                  "${currentBillerList[index].paramName3}",
                              "paramName_4":
                                  "${currentBillerList[index].paramName4}",
                              "icon": "${currentBillerList[index].icon}",
                              "isAdhoc": "${currentBillerList[index].isAdhoc}",
                              "fetchOption":
                                  "${currentBillerList[index].fetchOption}",
                              "state": "${currentBillerList[index].state}",
                              "position":
                                  "${currentBillerList[index].position}",
                              "minLimit": "${billerList[index].minLimit}",
                              "maxLimit": "${billerList[index].maxLimit}",
                              "category": "${widget.category}",
                              "inputNo":""
                            };

                            if (madatory.toString().toLowerCase() ==
                                "MANDATORY".toLowerCase()) {
                              if (widget.category.toLowerCase() == "fastag") {
                                openFastagRecharge(context, map);
                              } else {
                                if(name.toString()=="WEST00000WBL75"){
                                  openWBElectricity(context, map);
                                }
                                else{
                                  openRechargeFetchYes(context, map);
                                }
                              }
                            } else {
                              openRechargeFetchNo(context, map);
                            }
                          },
                          child: Row(
                            children: [
                              SizedBox(
                                width: 10.w,
                              ),
                              SizedBox(
                                child: Image.network(
                                  "$billerIconUrl${currentBillerList[index].icon}",
                                  width: 36.w,
                                ),
                                width: 36.w,
                                height: 36.h,
                              ),
                              SizedBox(
                                width: 10.w,
                              ),
                              Expanded(
                                flex: 1,
                                child: Text(
                                  currentBillerList[index].billerName,
                                  style:
                                      TextStyle(color: black, fontSize: font15.sp),
                                ),
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
    );
  }

  _buildDefaultList() {
    return Column(
      children: [
        Expanded(
          child: Container(
            width: MediaQuery.of(context).size.width,
            margin: EdgeInsets.only(top: 130),
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
            ),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 20.h,
                  ),
                  Center(
                    child: Container(
                      color: gray,
                      width: 50.w,
                      height: 5.h,
                    ),
                  ),
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
                  (currentBillerList.length == 0)
                      ? Container()
                      : _buildSelectedBillerList(),
                  Padding(
                    padding: const EdgeInsets.only(left: 40.0, top: 20),
                    child: Text(
                      "All Biller",
                      style:
                          TextStyle(color: black, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                    child: ListView.builder(
                        itemCount: billerList.length,
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return Column(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: InkWell(
                                  onTap: () {
                                    FocusScope.of(context)
                                        .requestFocus(new FocusNode());


                                    var name = billerList[index].billerId;

                                    printMessage(screen, "Biller Name : $name");


                                    var madatory =
                                        billerList[index].fetchOption;
                                    Map map = {
                                      "billerId":
                                          "${billerList[index].billerId}",
                                      "billerName":
                                          "${billerList[index].billerName}",
                                      "paramName":
                                          "${billerList[index].paramName}",
                                      "paramName_1":
                                          "${billerList[index].paramName1}",
                                      "paramName_2":
                                          "${billerList[index].paramName2}",
                                      "paramName_3":
                                          "${billerList[index].paramName3}",
                                      "paramName_4":
                                          "${billerList[index].paramName4}",
                                      "icon": "${billerList[index].icon}",
                                      "isAdhoc": "${billerList[index].isAdhoc}",
                                      "fetchOption":
                                          "${billerList[index].fetchOption}",
                                      "state": "${billerList[index].state}",
                                      "position":
                                          "${billerList[index].position}",
                                      "minLimit":
                                          "${billerList[index].minLimit}",
                                      "maxLimit":
                                          "${billerList[index].maxLimit}",
                                      "category": "${widget.category}",
                                    "inputNo":""
                                    };

                                    if (madatory.toString().toLowerCase() ==
                                        "MANDATORY".toLowerCase()) {
                                      if (widget.category.toLowerCase() ==
                                          "fastag") {
                                        openFastagRecharge(context, map);
                                      } else {
                                        if(name.toString()=="WEST00000WBL75"){
                                          openWBElectricity(context, map);
                                        }
                                        else{
                                          openRechargeFetchYes(context, map);
                                        }
                                      }
                                    } else {
                                      openRechargeFetchNo(context, map);
                                    }
                                  },
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      SizedBox(
                                        child: Image.network(
                                          "$billerIconUrl${billerList[index].icon}",
                                          width: 36.w,
                                        ),
                                        width: 36.w,
                                        height: 36.h,
                                      ),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          billerList[index].billerName,
                                          style: TextStyle(
                                              color: black, fontSize: font15.sp),
                                        ),
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
            ),
          ),
        ),
      ],
    );
  }

  _buildFilteredtList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 130),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
        color: white,
        /*boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 10,
            blurRadius: 10,
            offset: Offset(0, 1), // changes position of shadow
          ),
        ],*/
      ),
      child: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20.h,
            ),
            Center(
              child: Container(
                color: gray,
                width: 50.w,
                height: 5.h,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
              child: ListView.builder(
                  itemCount: billerListFilterd.length,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: InkWell(
                            onTap: () {
                              FocusScope.of(context)
                                  .requestFocus(new FocusNode());

                              var madatory = billerListFilterd[index].fetchOption;
                              var name = billerListFilterd[index].billerId;
                              Map map = {
                                "billerId": "${billerListFilterd[index].billerId}",
                                "billerName": "${billerListFilterd[index].billerName}",
                                "paramName": "${billerListFilterd[index].paramName}",
                                "paramName_1":
                                    "${billerListFilterd[index].paramName1}",
                                "paramName_2":
                                    "${billerListFilterd[index].paramName2}",
                                "paramName_3":
                                    "${billerListFilterd[index].paramName3}",
                                "paramName_4":
                                    "${billerListFilterd[index].paramName4}",
                                "icon": "${billerListFilterd[index].icon}",
                                "isAdhoc": "${billerListFilterd[index].isAdhoc}",
                                "fetchOption":
                                    "${billerListFilterd[index].fetchOption}",
                                "state": "${billerListFilterd[index].state}",
                                "position": "${billerListFilterd[index].position}",
                                "minLimit": "${billerListFilterd[index].minLimit}",
                                "maxLimit": "${billerListFilterd[index].maxLimit}",
                                "category": "${widget.category}",
                              "inputNo":""
                              };

                              if (madatory.toString().toLowerCase() ==
                                  "MANDATORY".toLowerCase()) {
                                if (widget.category.toLowerCase() == "fastag") {
                                  openFastagRecharge(context, map);
                                } else {
                                  if(name.toString()=="WEST00000WBL75"){
                                    openWBElectricity(context, map);
                                  }
                                  else{
                                    openRechargeFetchYes(context, map);
                                  }
                                }
                              } else {
                                openRechargeFetchNo(context, map);
                              }
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10.w,
                                ),
                                SizedBox(
                                  child: Image.network(
                                    "$billerIconUrl${billerListFilterd[index].icon}",
                                    width: 36.w,
                                  ),
                                  width: 36.w,
                                  height: 36.h,
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Text(
                                    billerListFilterd[index].billerName,
                                    style: TextStyle(
                                        color: black, fontSize: font15.sp),
                                  ),
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
      ),
    );
  }

  onSearchTextChanged(String text) async {
    printMessage(screen, "Case 0 : $text");
    billerListFilterd.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    billerList.forEach((userDetail) {
      if (userDetail.billerName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        printMessage(screen, "Case 2 :");
        billerListFilterd.add(userDetail);
      }
    });

    setState(() {
      printMessage(screen, "Case 3 : ${billerListFilterd.length}");
      if (billerListFilterd.length != 0) {
        showSearchResult = true;
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
      "category": "${widget.category}",
      //"category": "MOBILE PREPAID",
    };

    printMessage(screen, "Recent body : $body");

    final response = await http.post(Uri.parse(resentTransaction),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response Settelment : $data");

    setState(() {
      if (data['status'].toString() == "1") {
        var result = RecentTransaction.fromJson(
            jsonDecode(utf8.decode(response.bodyBytes)));
        resentList = result.resentList;
      } else {
        printMessage(screen, "${data['message']}");
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
                var opName = resentList[index].operatorName;
                var inputNo = resentList[index].param;
                var name = resentList[index].operatorName;

                printMessage(screen, "OP NAME : $opName");

                for (int k = 0; k < billerList.length; k++) {
                  var biName = billerList[k].billerName.toString();
                  var biId = billerList[k].billerId.toString();
                  if (opName == biName || opName == biId) {
                    printMessage(
                        screen, "BILLER NAME : ${billerList[k].billerId}");
                    var madatory = billerList[k].fetchOption;
                    Map map = {
                      "billerId": "${billerList[k].billerId}",
                      "billerName": "${billerList[k].billerName}",
                      "paramName": "${billerList[k].paramName}",
                      "paramName_1": "${billerList[k].paramName1}",
                      "paramName_2": "${billerList[k].paramName2}",
                      "paramName_3": "${billerList[k].paramName3}",
                      "paramName_4": "${billerList[k].paramName4}",
                      "icon": "${billerList[k].icon}",
                      "isAdhoc": "${billerList[k].isAdhoc}",
                      "fetchOption": "${billerList[k].fetchOption}",
                      "state": "${billerList[k].state}",
                      "position": "${billerList[k].position}",
                      "minLimit": "${billerList[k].minLimit}",
                      "maxLimit": "${billerList[k].maxLimit}",
                      "category": "${widget.category}",
                      "inputNo":"$inputNo",
                    };

                    if (madatory.toString().toLowerCase() ==
                        "MANDATORY".toLowerCase()) {
                      if (widget.category.toLowerCase() == "fastag") {
                        openFastagRecharge(context, map);
                      } else {
                        if(name.toString()=="WEST00000WBL75"){
                          openWBElectricity(context, map);
                        }
                        else{
                          openRechargeFetchYes(context, map);
                        }
                      }
                    } else {
                      openRechargeFetchNo(context, map);
                    }
                    break;
                  }
                }
              },
              child: Row(
                children: [
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${resentList[index].param}",
                          style: TextStyle(
                              color: black,
                              fontSize: font14.sp,
                              fontWeight: FontWeight.bold,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                        Text(
                          "${resentList[index].operatorName}",
                          style: TextStyle(
                              color: black,
                              fontSize: font14.sp,
                              overflow: TextOverflow.ellipsis),
                          maxLines: 1,
                        ),
                        SizedBox(
                          height: 4.h,
                        ),
                        Text(
                          (resentList[index].date.toString() == "null")
                              ? "NA"
                              : "${(resentList[index].date.toString())}",
                          style: TextStyle(
                              color: lightBlack,
                              fontSize: font12.sp,
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
                        fontSize: font16.sp,
                        fontWeight: FontWeight.bold,
                        overflow: TextOverflow.ellipsis),
                    maxLines: 1,
                  ),
                  SizedBox(
                    width: 4.w,
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
}
