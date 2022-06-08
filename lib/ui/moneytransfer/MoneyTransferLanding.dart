import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/AccountList.dart';
import 'package:moneypro_new/ui/models/UPIUsers.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


import 'package:moneypro_new/utils/SharedPrefs.dart';

class MoneyTransferLanding extends StatefulWidget {
  const MoneyTransferLanding({Key? key}) : super(key: key);

  @override
  _MoneyTransferLandingState createState() => _MoneyTransferLandingState();
}

class _MoneyTransferLandingState extends State<MoneyTransferLanding> {
  var screen = "Money Transfer";

  TextEditingController searchController = new TextEditingController();

  int selectedIndex = 1;

  List<Datum> bankAccouts = [];
  List<UPIUserList> upiUsersList = [];

  List<Datum> bankAccoutsFiltered = [];
  List<UPIUserList> upiUsersListFiltered = [];

  var showFilteredBankAccount = false;
  var showFilteredUPIId = false;

  var loading = false;
  var upiLoading = false;

  double totalEarning = 0.0;

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    getAccountsList();
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
            body:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildSearchBox(),
              SizedBox(
                height: 10.h,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 20.w,
                  ),
                  Expanded(
                      child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = 1;
                          });

                          if (bankAccouts.length == 0) {
                            getAccountsList();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "Bank Account".toUpperCase(),
                            style: TextStyle(
                                color: (selectedIndex == 1) ? lightBlue : black,
                                fontSize: font15.sp,
                                fontWeight: (selectedIndex == 1)
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                      ),
                      Divider(
                        color: (selectedIndex == 1) ? blue : white,
                        thickness: 3,
                      ),
                    ],
                  )),
                  Expanded(
                      child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            selectedIndex = 2;
                          });

                          if (upiUsersList.length == 0) {
                            getUPIUserList();
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            "UPI ID".toUpperCase(),
                            style: TextStyle(
                                color: (selectedIndex == 2) ? lightBlue : black,
                                fontSize: font15.sp,
                                fontWeight: (selectedIndex == 2)
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                      ),
                      Divider(
                        color: (selectedIndex == 2) ? blue : white,
                        thickness: 3,
                      ),
                    ],
                  )),
                  SizedBox(
                    width: 20.w,
                  ),
                ],
              ),
              SizedBox(
                height: 10.h,
              ),
              (selectedIndex == 1)
                  ? (loading)
                      ? Center(
                          child: circularProgressLoading(40.0),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                          child: (bankAccouts.length == 0)
                              ? _emptyData()
                              : (showFilteredBankAccount)
                                  ? _buildBankRowFilteredSection()
                                  : _buildBankRowSection(),
                        ))
                  : (upiLoading)
                      ? Center(
                          child: circularProgressLoading(40.0),
                        )
                      : Expanded(
                          child: SingleChildScrollView(
                          child: (upiUsersList.length == 0)
                              ? _emptyData()
                              : (showFilteredUPIId)
                                  ? _buildUPIRowFilteredSection()
                                  : _buildUPIRowSection(),
                        )),
            ]),
            floatingActionButton: new FloatingActionButton(
                elevation: 0.0,
                child: new Icon(Icons.add_rounded),
                backgroundColor: lightBlue,
                onPressed: () {
                  if (selectedIndex == 1) {
                    openSelectBank(context);
                  } else {
                    openAddNewUPIId(context);
                  }
                }))));
  }

  _buildSearchBox() {
    return Container(
      margin: EdgeInsets.only(top: 15, left: padding, right: padding),
      decoration: BoxDecoration(
        color: editBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(0.0),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10, bottom: 10, right: 0),
              child: Icon(
                Icons.search,
                color: Colors.grey,
              ),
            ),
            Expanded(
                flex: 1,
                child: TextFormField(
                  style: TextStyle(color: black, fontSize: 14.sp),
                  keyboardType: TextInputType.text,
                  textCapitalization: TextCapitalization.characters,
                  textInputAction: TextInputAction.next,
                  controller: searchController,
                  decoration: new InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.only(left: 15),
                    counterText: "",
                    label: (selectedIndex == 1)
                        ? Text("Search bank account by name")
                        : Text("Search upi Id by name"),
                  ),
                  maxLength: 80,
                  onChanged: (val) {
                    if (val.length > 2) {
                      if (selectedIndex == 1) {
                        if (val != 0) {
                          onSearchBankAccount(val.toString());
                        } else {
                          setState(() {
                            showFilteredBankAccount = false;
                          });
                        }
                      }
                      if (selectedIndex == 2) {
                        if (val != 0) {
                          onSearchUPIid(val.toString());
                        } else {
                          setState(() {
                            showFilteredUPIId = false;
                          });
                        }
                      }
                    } else {
                      setState(() {
                        if (selectedIndex == 1) {
                          showFilteredBankAccount = false;
                        }
                        if (selectedIndex == 2) {
                          showFilteredUPIId = false;
                        }
                      });
                    }
                  },
                )),
          ],
        ),
      ),
    );
  }

  _emptyData() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 150.h,
          ),
          Image.asset(
            'assets/no_member.png',
            height: 210.h,
          ),
          Text(
            "No account added yet",
            style: TextStyle(
                color: black, fontSize: font16.sp, fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  _buildBankRowSection() {
    return (loading)
        ? Center(
            child: circularProgressLoading(40.0),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: ScrollPhysics(),
            itemCount: bankAccouts.length,
            itemBuilder: (context, index) {
              return Padding(
                padding:
                    EdgeInsets.only(top: 5, left: padding, right: padding),
                child: InkWell(
                  onTap: () {
                    var name = bankAccouts[index].accHolderName.toString();
                    var ifsc = bankAccouts[index].ifsc.toString();
                    var accNo = bankAccouts[index].accountNo.toString();
                    var logo = bankAccouts[index].logo.toString();
                    var status = bankAccouts[index].status.toString();
                    /*if(status.toString()=="1"){
                      openSendAccontMoney(context, name, ifsc, accNo, logo);
                    }else{
                      showToastMessage(notAuthoziePayment);
                    }*/
                    openSendAccontMoney(context, name, ifsc, accNo, logo);
                  },
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (bankAccouts[index].logo.toString() == "" ||
                              bankAccouts[index].logo.toString() == "null")
                          ? Image.asset(
                              'assets/bank.png',
                              height: 36.h,
                            )
                          : SizedBox(
                              width: 36.w,
                              height: 36.h,
                              child: Image.network(
                                "$bankIconUrl${bankAccouts[index].logo}",
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
                              "${bankAccouts[index].accHolderName}",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font14.sp,
                                  fontWeight: FontWeight.w500),
                            ),
                            Text(
                              "${bankAccouts[index].accountNo}",
                              style: TextStyle(
                                  color: lightBlack,
                                  fontSize: font12.sp,
                                  fontWeight: FontWeight.normal),
                            ),
                            Divider(),
                          ],
                        ),
                      ),
                      GestureDetector(
                        onTapDown: (TapDownDetails details) {
                          var accNo = bankAccouts[index].accountNo;
                          showPopupMenu(details.globalPosition, accNo);
                        },
                        child: Image.asset(
                          'assets/ic_dots.png',
                          height: 20.h,
                        ),
                      ),
                      SizedBox(
                        width: 10.w,
                      ),
                    ],
                  ),
                ),
              );
            });
  }

  _buildUPIRowSection() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: upiUsersList.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 15, left: padding, right: padding),
            child: InkWell(
              onTap: () {
                var name = upiUsersList[index].holderName;
                var id = upiUsersList[index].upiId;
                var status = upiUsersList[index].status;
                /*if(status.toString()=="1"){
                  openSendUPIMoney(context, name, id, false);
                }else{
                  showToastMessage(notAuthoziePayment);
                }*/
                openSendUPIMoney(context, name, id, false);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/upi_ar.png',
                    width: 24.w,
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
                          "${upiUsersList[index].upiId}",
                          style: TextStyle(
                              color: black,
                              fontSize: font14.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${upiUsersList[index].holderName}",
                          style: TextStyle(
                              color: lightBlack,
                              fontSize: font12.sp,
                              fontWeight: FontWeight.normal),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      var accNo = upiUsersList[index].upiId;
                      showPopupMenu(details.globalPosition, accNo);
                    },
                    child: Image.asset(
                      'assets/ic_dots.png',
                      height: 20.h,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildBankRowFilteredSection() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: bankAccoutsFiltered.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 15, left: padding, right: padding),
            child: InkWell(
              onTap: () {
                var name = bankAccoutsFiltered[index].accHolderName.toString();
                var ifsc = bankAccoutsFiltered[index].ifsc.toString();
                var accNo = bankAccoutsFiltered[index].accountNo.toString();
                var logo = bankAccoutsFiltered[index].logo.toString();
                var status = bankAccoutsFiltered[index].status.toString();
                /*if(status.toString()=="1"){
                  openSendAccontMoney(context, name, ifsc, accNo, logo);
                }else{
                  showToastMessage(notAuthoziePayment);
                }*/

                openSendAccontMoney(context, name, ifsc, accNo, logo);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (bankAccoutsFiltered[index].logo.toString() == "" ||
                          bankAccoutsFiltered[index].logo.toString() == "null")
                      ? Image.asset(
                          'assets/bank.png',
                          height: 24.h,
                        )
                      : SizedBox(
                          width: 36.w,
                          height: 36.h,
                          child: Image.network(
                            "$bankIconUrl${bankAccoutsFiltered[index].logo}",
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
                          "${bankAccoutsFiltered[index].accHolderName}",
                          style: TextStyle(
                              color: black,
                              fontSize: font16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${bankAccoutsFiltered[index].accountNo}",
                          style: TextStyle(
                              color: lightBlack,
                              fontSize: font14.sp,
                              fontWeight: FontWeight.normal),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      var accNo = bankAccoutsFiltered[index].accountNo;
                      showPopupMenu(details.globalPosition, accNo);
                    },
                    child: Image.asset(
                      'assets/ic_dots.png',
                      height: 20.h,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
            ),
          );
        });
  }

  _buildUPIRowFilteredSection() {
    return ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: upiUsersListFiltered.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.only(top: 15, left: padding, right: padding),
            child: InkWell(
              onTap: () {
                var name = upiUsersListFiltered[index].holderName;
                var id = upiUsersListFiltered[index].upiId;
                var status = upiUsersListFiltered[index].status;
                /*if(status.toString()=="1"){
                  openSendUPIMoney(context, name, id, false);
                }else{
                  showToastMessage(notAuthoziePayment);
                }*/
                openSendUPIMoney(context, name, id, false);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(
                    'assets/upi_ar.png',
                    width: 24.w,
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
                          "${upiUsersListFiltered[index].upiId}",
                          style: TextStyle(
                              color: black,
                              fontSize: font16.sp,
                              fontWeight: FontWeight.w500),
                        ),
                        Text(
                          "${upiUsersListFiltered[index].holderName}",
                          style: TextStyle(
                              color: lightBlack,
                              fontSize: font14.sp,
                              fontWeight: FontWeight.normal),
                        ),
                        Divider(),
                      ],
                    ),
                  ),
                  GestureDetector(
                    onTapDown: (TapDownDetails details) {
                      var accNo = upiUsersListFiltered[index].upiId;
                      showPopupMenu(details.globalPosition, accNo);
                    },
                    child: Image.asset(
                      'assets/ic_dots.png',
                      height: 20.h,
                    ),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                ],
              ),
            ),
          );
        });
  }

  Future getAccountsList() async {
    setState(() {
      loading = true;
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader"
    };

    final body = {
      "user_token": userToken,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(accountNumberListAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    setState(() {
      loading = false;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));
        printMessage(screen, "Bank Code : $data");
        if (data['status'].toString() == "1") {
          var result =
              AccountList.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          bankAccouts = result.data;
        }
      } else {
        setState(() {});
        showToastMessage(status500);
      }
    });
  }

  Future getInvestorEarning() async {
    var mobile = await getMobile();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "mobile": "$mobile",
    };

    printMessage(screen, "Investor Body : $body");

    final response = await http.post(Uri.parse(investorKycStatusAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Investor Response : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          var investorWallet = data['profile_data']['investment_wallet'];
          var investorEarning =
              data['profile_data']['investment_earning_wallet'];

          double earning = double.parse(
              data['profile_data']['investment_earning_wallet'].toString());
          totalEarning =
              double.parse(investorWallet) + double.parse(investorEarning);
        }
      }
    });
  }

  Future getUPIUserList() async {
    setState(() {
      upiLoading = true;
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader"
    };

    final body = {
      "user_token": userToken,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(upiListAPI),
        body: jsonEncode(body), headers: headers);



    int statusCode = response.statusCode;

    setState(() {
      upiLoading = false;
      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Bank Code : $data");
        if (data['status'].toString() == "1") {
          var result =
              UpiUsers.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          upiUsersList = result.data;
        }
      }else{
        setState(() {

        });
        showToastMessage(status500);
      }
    });
  }

  onSearchBankAccount(String text) async {
    printMessage(screen, "Case 0 : $text");
    bankAccoutsFiltered.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    bankAccouts.forEach((userDetail) {
      if (userDetail.accHolderName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        printMessage(screen, "Case 2 :");
        bankAccoutsFiltered.add(userDetail);
      }
    });

    setState(() {
      printMessage(screen, "Case 3 : ${bankAccoutsFiltered.length}");
      if (bankAccoutsFiltered.length != 0) {
        showFilteredBankAccount = true;
      }
    });
  }

  onSearchUPIid(String text) async {
    printMessage(screen, "Case 0 : $text");
    upiUsersListFiltered.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    upiUsersList.forEach((userDetail) {
      if (userDetail.holderName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        printMessage(screen, "Case 2 :");
        upiUsersListFiltered.add(userDetail);
      }
    });

    setState(() {
      printMessage(screen, "Case 3 : ${upiUsersListFiltered.length}");
      if (upiUsersListFiltered.length != 0) {
        showFilteredUPIId = true;
      }
    });
  }

  showPopupMenu(Offset globalPosition, accNo) {
    double left = globalPosition.dx;
    double top = globalPosition.dy;
    showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(left, top, 0, 0),
      items: [
        PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.history_rounded),
                SizedBox(
                  width: 4.w,
                ),
                Text("View History")
              ],
            ),
            value: '1'),
        /*PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.edit),
                SizedBox(
                  width: 4,
                ),
                Text("Edit")
              ],
            ),
            value: '2'),*/
        PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.delete_rounded),
                SizedBox(
                  width: 4.w,
                ),
                Text("Remove")
              ],
            ),
            value: '3'),
        /*PopupMenuItem<String>(
            child: Row(
              children: [
                Icon(Icons.share_rounded),
                SizedBox(
                  width: 4,
                ),
                Text("Share")
              ],
            ),
            value: '4'),*/
      ],
      elevation: 8.0,
    ).then<void>((itemSelected) {
      if (itemSelected == null) return;
      if (itemSelected == "1") {
        openBeneficialTransHistory(context, accNo);
      } else if (itemSelected == "2") {
        //code here
      } else if (itemSelected == "3") {
        //code here
      } else if (itemSelected == "4") {
        //code here
      }
    });
  }
}
