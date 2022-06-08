import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/BillerList.dart';
import 'package:moneypro_new/ui/models/Circles.dart';
import 'package:moneypro_new/ui/models/Operators.dart';
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

class DTHSelectNew extends StatefulWidget {
  final String category;
  final String searchBy;
  final String selectBy;
  const DTHSelectNew({Key? key,
    required this.category,
    required this.searchBy,
    required this.selectBy}) : super(key: key);

  @override
  _DTHSelectNewState createState() => _DTHSelectNewState();
}

class _DTHSelectNewState extends State<DTHSelectNew> {
  var screen = "DTH Recharge New";

  var loading = false;

  final searchController = new TextEditingController();

  var showSearchResult = false;

  List<ResentList> resentList = [];

  List<OperatorNames> operatorsNameList=[];
  List<OperatorNames> operatorsNameFiltered=[];

  var localState = "";


  @override
  void initState() {
    super.initState();
    generateJWTToken();
    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();
    getRecentTransactions();
  }

  updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();
    var walBalc = await getWelcomeAmt();
    var st = await getlocState();
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
      localState = st;
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
            backgroundColor: white,
            appBar: appBarHome(context, "assets/bbps_2.png", 24.0),
            body: (loading)
                ? Center(child: circularProgressLoading(40.0))
                : SingleChildScrollView(
              child: Column(
                children: [
                  (operatorsNameList.length == 0)
                      ? Container()
                      : _searchByBoard(),
                  (showSearchResult)
                      ? (operatorsNameFiltered.length == 0)
                      ? NoDataFound(text: "No result found")
                      : _buildFilteredtList()
                      : (operatorsNameList.length == 0)
                      ? NoDataFound(text: "No result found")
                      : _buildDefaultList(),
                ],
              ),
            ))));
  }

  Future generateJWTToken() async {
    setState(() {
     loading = true;
    });

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(jwtTokenAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      loading = false;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          var jwtToken = data['token'].toString();
          getOperatorsIds(jwtToken);
        } else {
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  Future getOperatorsIds(token) async {
    setState(() {
      loading = true;
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"user_token": "$userToken", "token": "$token"};

    final response = await http.post(Uri.parse(operatorListPrepaidAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        loading = false;
        printMessage(screen, "Operator Ids : $data");

        var icons="";

        for (int i = 0; i < data['data']['data'].length; i++) {
          var catName = data['data']['data'][i]['category'];
          if (catName.toString().toLowerCase()=="dth") {
            var billerName  = data['data']['data'][i]['name'];
            var operatorCode = data['data']['data'][i]['id'];
            var category = data['data']['data'][i]['category'];

            if(billerName.toString().toLowerCase()=="Airtel Digital TV".toLowerCase()){
              icons = "1637391607.png";
            }else if(billerName.toString().toLowerCase()=="Dish TV".toLowerCase()){
              icons = "1637390400.png";
            }else if(billerName.toString().toLowerCase()=="Sun Direct".toLowerCase()){
              icons = "1637390943.png";
            }else if(billerName.toString().toLowerCase()=="Tata Sky".toLowerCase()){
              icons = "1643363760.png";
            }else if(billerName.toString().toLowerCase()=="Videocon D2H".toLowerCase()){
              icons = "1637391403.png";
            }

            OperatorNames names  = new OperatorNames(
                billerName:billerName,
                operatorCode:operatorCode,
                category:category,
                icons:icons
            );

            operatorsNameList.add(names);


          }
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
              controller: searchController,
              textCapitalization: TextCapitalization.characters,
              enabled: true,
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

  _buildDefaultList() {
    return SingleChildScrollView(
      child: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
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
              Divider(),
              Padding(
                padding: const EdgeInsets.only(left: 40.0, top: 20),
                child: Text(
                  "All Biller",
                  style: TextStyle(color: black, fontWeight: FontWeight.bold),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0, right: 10, top: 10),
                child: ListView.builder(
                    itemCount: operatorsNameList.length,
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


                                /*Map map1 = {
                                  "billerId": "${billerList[index].billerId}",
                                  "billerName": "${billerList[index].billerName}",
                                  "paramName": "${billerList[index].paramName}",
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
                                  "position": "${billerList[index].position}",
                                  "minLimit": "${billerList[index].minLimit}",
                                  "maxLimit": "${billerList[index].maxLimit}",
                                  "category": "${widget.category}",
                                  "operatorSecCode": "$operatorSecCode",
                                  "stateCode": "$stateCode",
                                  "operatorSecName": "$operatorSecName",
                                  "billerImg": "${billerList[index].icon}",
                                  "dthCode": "$dthCode",
                                  "stateName": "$stateName",
                                  "inputNo":""
                                };*/


                                Map map = {
                                  "billerId": "${operatorsNameList[index].operatorCode}",
                                  "billerName": "${operatorsNameList[index].billerName}",
                                  "category": "${operatorsNameList[index].category}",
                                  "billerImg": "${operatorsNameList[index].icons}",
                                  "inputNo":"",
                                "stateName": "$localState",
                                  "minLimit":"50"
                                };

                                printMessage(screen, "Case 1 Map : ${map.toString()}");
                                openDTHRecharge(context, map);
                              },
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                  SizedBox(
                                    child: Image.network(
                                      "$billerIconUrl${operatorsNameList[index].icons}",
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
                                      operatorsNameList[index].billerName,
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
    );
  }

  _buildFilteredtList() {
    return Container(
      width: MediaQuery.of(context).size.width,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.vertical(top: Radius.circular(50.0)),
        color: white,
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
                  itemCount: operatorsNameFiltered.length,
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

                              Map map = {
                                "billerId": "${operatorsNameFiltered[index].operatorCode}",
                                "billerName": "${operatorsNameFiltered[index].billerName}",
                                "category": "${operatorsNameFiltered[index].category}",
                                "billerImg": "${operatorsNameFiltered[index].icons}",
                                "inputNo":"",
                                "stateName": "$localState",
                                "minLimit":"50"
                              };

                              printMessage(screen, "Case 2 Map : ${map.toString()}");
                              openDTHRecharge(context, map);
                            },
                            child: Row(
                              children: [
                                SizedBox(
                                  width: 10.w,
                                ),
                                SizedBox(
                                  child: Image.network(
                                    "$billerIconUrl${operatorsNameFiltered[index].icons}",
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
                                    operatorsNameFiltered[index].billerName,
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
    operatorsNameFiltered.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    operatorsNameList.forEach((userDetail) {
      if (userDetail.billerName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        printMessage(screen, "Case 2 :");
        operatorsNameFiltered.add(userDetail);
      }
    });

    setState(() {
      printMessage(screen, "Case 3 : ${operatorsNameFiltered.length}");
      if (operatorsNameFiltered.length != 0) {
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
    };

    printMessage(screen, "body : $body");

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
                var dthCode;
                var opName = resentList[index].operatorName.toString();
                var inputNo = resentList[index].param;

                printMessage(screen, "Oprator name : $opName");

                for (int k = 0; k < operatorsNameList.length; k++) {
                  var biName = operatorsNameList[k].billerName.toString();

                  printMessage(screen, "Oprator biName : $biName");

                  if (opName.toLowerCase() == biName.toLowerCase()) {

                    Map map = {
                      "billerId": "${operatorsNameList[k].operatorCode}",
                      "billerName": "${operatorsNameList[k].billerName}",
                      "category": "${operatorsNameList[k].category}",
                      "billerImg": "${operatorsNameList[k].icons}",
                      "inputNo":"$inputNo",
                      "stateName": "$localState",
                      "minLimit":"50"
                    };
                    printMessage(screen, "Case 3 Map : ${map.toString()}");
                    openDTHRecharge(context, map);
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
                              : "${convertDateFormat(resentList[index].date.toString())}",
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
