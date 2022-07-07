import 'dart:async';

import 'package:contacts_service/contacts_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/Circles.dart';
import 'package:moneypro_new/ui/models/MPContacts.dart';
import 'package:moneypro_new/ui/models/MobilePlan.dart';
import 'package:moneypro_new/ui/models/MyContacts.dart';
import 'package:moneypro_new/ui/models/NewMobilePlans.dart';
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

class MobileSelection extends StatefulWidget {
  final String mobileNo;

  const MobileSelection({Key? key, required this.mobileNo}) : super(key: key);

  @override
  _MobileSelectionState createState() => _MobileSelectionState();
}

class _MobileSelectionState extends State<MobileSelection> {
  var screen = "Mobile recharge new";

  TextEditingController phoneController = new TextEditingController();

  final searchAmount = new TextEditingController();
  final searchName = new TextEditingController();

  var loading = false;

  var iOSLocalizedLabels = false;

  List<ResentList> resentList = [];

  List<OperatorNames> operatorNames = [];

  int typeIndex = 0;

  var isPickContact = false;

  List<Contact> _contacts = [];
  List<Contact> _contactFilter = [];
  List<String> planType = [];

  List<MyContacts> myContacts = [];
  List<MyContacts> myFilteredContacts = [];
  List<Map<String, bool>> phoneListn = [];

  List<NewMobilePlans> mobilePlans = [];
  List<NewMobilePlans> mobilePlansFiltered = [];

  var showFiltedContact = false;

  var recentLoading = false;

  var isPlanVisible = false;

  String mainWallet = "";

  var billerImg = "";

  var circleName = "";
  var operatorName = "";
  var spKey = "";
  var cirCode = "";
  var operatorId = "";

  List<String> planTypies = [];

  var showSearchResult = false;

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    updateWalletBalances();
    _askContactPermissions();
    getRecentTransactions();
    planType.clear();
    planType.insert(0, "All");
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
      double mWlet = wX + mX;
      //mainWallet = "${mWlet.toStringAsPrecision(2)}";
      mainWallet = formatDecimal2Digit.format(mWlet);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
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
                        padding: const EdgeInsets.only(
                            left: 10.0, top: 5, bottom: 5),
                        child: Wrap(
                          direction: Axis.horizontal,
                          children: [
                            Image.asset(
                              "assets/wallet.png",
                              height: 20.h,
                            ),
                            Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, right: 10, top: 5),
                                child: Text(
                                  //"${formatDecimal2Digit.format(mainWallet)}",
                                  "$mainWallet",
                                  style:
                                      TextStyle(color: white, fontSize: font15),
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
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          (isPlanVisible)
                              ? Container()
                              : appSelectedBanner(
                                  context, "recharge_banner.png", 150.0.h),
                          Container(
                            margin: EdgeInsets.only(
                                top: padding, left: padding, right: padding),
                            decoration: BoxDecoration(
                              color: editBg,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
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
                                          fontSize: inputFont.sp,
                                          fontWeight: FontWeight.bold),
                                      keyboardType: TextInputType.phone,
                                      textInputAction: TextInputAction.done,
                                      controller: phoneController,
                                      decoration: new InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        contentPadding:
                                            EdgeInsets.only(left: 10),
                                        counterText: "",
                                        label: Text("Phone number"),
                                      ),
                                      maxLength: 10,
                                      onChanged: (val) {
                                        if (val.length == 10) {
                                          closeKeyBoard(context);
                                          generateJWTToken(val.toString(), 1);
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
                                      height: 20.h,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 10.w,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          (isPlanVisible)
                              ? Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20, top: 15),
                                  child: Row(
                                    children: [
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: editBg,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                                bottom: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Operator",
                                                  style: TextStyle(
                                                      color: lightBlack,
                                                      fontSize: font13.sp),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Row(
                                                  children: [
                                                    (billerImg == "")
                                                        ? SizedBox(
                                                            width: 10.w,
                                                          )
                                                        : SizedBox(
                                                            height: 16.h,
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      right:
                                                                          8.0),
                                                              child:
                                                                  Image.network(
                                                                "$imageSubAPI${billerImg}",
                                                              ),
                                                            ),
                                                          ),
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "$operatorName",
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize:
                                                                font15.sp),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                      SizedBox(
                                        width: 10.w,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Container(
                                            decoration: BoxDecoration(
                                              color: editBg,
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(30)),
                                            ),
                                            padding: EdgeInsets.only(
                                                left: 15,
                                                right: 15,
                                                top: 5,
                                                bottom: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Circle",
                                                  style: TextStyle(
                                                      color: lightBlack,
                                                      fontSize: font13.sp),
                                                ),
                                                SizedBox(
                                                  height: 2.h,
                                                ),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      flex: 1,
                                                      child: Text(
                                                        "$circleName",
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize:
                                                                font12.sp),
                                                        maxLines: 1,
                                                        overflow:
                                                            TextOverflow.fade,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          )),
                                    ],
                                  ),
                                )
                              : Container(),
                          Expanded(
                            flex: 1,
                            child: (isPlanVisible)
                                ? Container(
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
                                          offset: Offset(0,
                                              1), // changes position of shadow
                                        ),
                                      ],
                                    ),
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
                                                        fontSize: inputFont.sp,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                    keyboardType:
                                                        TextInputType.phone,
                                                    textInputAction:
                                                        TextInputAction.done,
                                                    controller: searchAmount,
                                                    decoration:
                                                        new InputDecoration(
                                                      isDense: true,
                                                      border: InputBorder.none,
                                                      contentPadding:
                                                          EdgeInsets.only(
                                                              left: 10),
                                                      counterText: "",
                                                      label: Text(
                                                          "Search plan by amount"),
                                                    ),
                                                    maxLength: 5,
                                                    onFieldSubmitted: (val) {
                                                      if (val
                                                              .toString()
                                                              .length ==
                                                          0) {
                                                        showToastMessage(
                                                            "enter the amount");
                                                        return;
                                                      }
                                                      searchByAmount(
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
                                                    searchByAmount(
                                                        res.toString());
                                                  },
                                                  child: Icon(Icons.search),
                                                ),
                                                SizedBox(
                                                  width: 10.w,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        _buildPlanTabs(),
                                        Divider(),
                                        Expanded(
                                          child: (showSearchResult)
                                              ? (mobilePlansFiltered.length ==
                                                      0)
                                                  ? Center(
                                                      child:
                                                          Text("No plan found"),
                                                    )
                                                  : _buildPlanFilterList()
                                              : (mobilePlans.length == 0)
                                                  ? Container()
                                                  : _buildPlanDetail(),
                                        )
                                      ],
                                    ),
                                  )
                                : _buildContactSection(),
                          ),
                        ],
                      ))));
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
                                                generateJWTToken(number, 1);
                                              }
                                            });
                                          },
                                          child: Row(
                                            children: [
                                              Container(
                                                height: 40.h,
                                                width: 40.w,
                                                decoration: BoxDecoration(
                                                    color: lightBlue,
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                        color: lightBlue,
                                                        width: 3.w)),
                                                child: Center(
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Image.asset(
                                                        'assets/user.png'),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(
                                                width: 10.w,
                                              ),
                                              Text(
                                                myFilteredContacts[index].name,
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font16.sp,
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
                                                            width: 10.w,
                                                          ),
                                                          Image.asset(
                                                            'assets/appM_logo.png',
                                                            height: 20.h,
                                                          ),
                                                          SizedBox(
                                                            width: 5.w,
                                                          ),
                                                          Text(
                                                            "Verified",
                                                            style: TextStyle(
                                                                color: green,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                fontSize:
                                                                    font13.sp),
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
                                        generateJWTToken(number, 1);
                                      }
                                    });
                                  }
                                },
                                child: Row(
                                  children: [
                                    Container(
                                      height: 40.h,
                                      width: 40.w,
                                      decoration: BoxDecoration(
                                          color: lightBlue,
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                              color: lightBlue, width: 3.w)),
                                      child: Center(
                                        child: Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: Image.asset('assets/user.png'),
                                        ),
                                      ),
                                    ),
                                    SizedBox(
                                      width: 10.w,
                                    ),
                                    Text(
                                      _contacts[index].displayName ?? "",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: font16.sp,
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

  _showPlan(planType, price, validity, discription, operator, circle, number,
      operatorId) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: showPlanDetail(
                  planType: planType,
                  price: price,
                  validity: validity,
                  discription: discription,
                  operator: operator,
                  circle: circle,
                  billerImg: billerImg,
                  number: number,
                  spKey: spKey,
                  operatorId: operatorId),
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
                        height: 20.h,
                      ),
                      Container(
                        height: 4.h,
                        width: 50.w,
                        color: gray,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, top: 15),
                        child: Text(
                          "Select your contact",
                          style: TextStyle(
                              color: black,
                              fontSize: font16.sp,
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
                                                  generateJWTToken(number, 1);
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
                                                  generateJWTToken(number, 1);
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
      height: 50.h,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(25)),
          border: Border.all(color: editBg)),
      child: Row(
        children: [
          SizedBox(
            width: 15.w,
          ),
          Expanded(
            flex: 1,
            child: TextFormField(
              style: TextStyle(color: black, fontSize: inputFont.sp),
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
            width: 15.w,
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
    setState(() {
      loading = true;
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "category": "MOBILE PREPAID",
    };

    final response = await http.post(Uri.parse(resentTransaction),
        body: jsonEncode(body), headers: headers);

    var dd = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "DD recent : $dd");

    if (dd['status'].toString() == "1") {
      var data = RecentTransaction.fromJson(
          jsonDecode(utf8.decode(response.bodyBytes)));

      setState(() {
        var status = data.status;
        loading = false;
        if (status.toString() == "1") {
          resentList = data.resentList;
        }
      });
    }

    setState(() {
      loading = false;
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
                    generateJWTToken(number, 1);
                  }
                });
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

  Future generateJWTToken(mobile, action) async {
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

    final body = {};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(jwtTokenAPI),
        body: jsonEncode(body), headers: headers);
    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Response statusCode : ${data}");

    setState(() {
      var statusCode = response.statusCode;
      Navigator.pop(context);
      if (statusCode == 200) {
        if (data['status'].toString() == "1") {
          var jwtToken = data['token'].toString();
          if (action == 1) {
            getOperatorDetails(mobile, jwtToken);
          }
          if (action == 2) {
            getPlanDetails(jwtToken);
          }
          if (action == 3) {
            getOperatorsIds(jwtToken);
          }
        } else {
          showToastMessage(somethingWrong);
        }
      }
    });
  }

  Future getOperatorDetails(mobile, jwtToken) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message:
                    "Please wait, while we are fetching your operator details");
          });
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "token": "$jwtToken",
      "mobile": "$mobile"
    };

    printMessage(screen, "HLR Body : $body");

    final response = await http.post(Uri.parse(fetchOperatorAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Operator Details : $data");

      setState(() {
        Navigator.pop(context);

        if (data['status'].toString() == "1") {
          var status = data['status'].toString();
          if (status.toString() == "1") {
            setState(() {
              isPlanVisible = true;
              operatorName = data['optr'];
              circleName = data['circle'];
              spKey = data['spe_key'];
              cirCode = data['circle_code'];
              generateJWTToken(mobile, 2);
              getOperatorsList();
              generateJWTToken(mobile, 3);
            });
          } else {
            setState(() {
              isPlanVisible = false;
            });
          }
        } else if (data['status'].toString() == "2") {
          closeCurrentPage(context);
          openPayUMobilePlans(context, mobile, _contacts, spKey);
        } else {
          showToastMessage(somethingWrong);
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  Future getPlanDetails(jwtToken) async {
    print('jst called');
    setState(() {
      planTypies.clear();
      mobilePlans.clear();
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(
                message:
                    "Please wait, while we are fetching your plan details");
          });
    });

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$userToken",
      "spkey": "$spKey",
      "cir_code": "$cirCode"
    };
    // "user_token": "$userToken",
    // "token": "$jwtToken",
    // "circle": "$circleName",
    // "op": "$operatorName",
    final response = await http.post(Uri.parse(fetchPlanAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Plan Details : $body");
      printMessage(screen, "Plan Details : $data");

      setState(() {
        Navigator.pop(context);
        var status = data['status'].toString();
        if (status.toString() == "1") {
          List stringJson = data['plan_data'];
          List planList = data['plan'];

          // stringJson.forEach((key, value) {
          // planTypies.add(key);
          for (var i = 0; i < planList.length; i++) {
            planType.add(planList[i]['plan']);
          }

          for (int i = 0; i < stringJson.length; i++) {
            var rs = stringJson[i]['recharge_value'];
            var desc = stringJson[i]['recharge_description'];
            var validity = stringJson[i]['recharge_validity'];
            var last_update = stringJson[i]['last_update'];
            var plansT = stringJson[i]['recharge_short_description'];

            NewMobilePlans plans = new NewMobilePlans(
                rs: rs,
                desc: desc,
                validity: validity,
                last_update: last_update,
                planType: plansT);
            mobilePlans.add(plans);
          }
          // });

          printMessage(screen, "Plan Typies Length : ${planTypies.length}");

          if (planTypies.length != 0) planTypies.insert(0, "All");
        } else {}
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }

  _buildPlanTabs() {
    return Container(
      height: 30.h,
      margin: EdgeInsets.only(left: 15, right: 25, top: 10, bottom: 0),
      child: ListView.builder(
          itemCount: planType.length,
          shrinkWrap: true,
          scrollDirection: Axis.horizontal,
          physics: ScrollPhysics(),
          itemBuilder: (context, index) {
            return InkWell(
              onTap: () {
                var text = planType[index].toString();
                setState(() {
                  typeIndex = index;
                });

                if (text.toString() == "All") {
                  setState(() {
                    showSearchResult = false;
                  });
                } else {
                  searchByType(planType[index].toString());
                }
              },
              child: Center(
                  child: Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15),
                child: Text(
                  planType[index].toString().toUpperCase(),
                  style: TextStyle(
                      color: (typeIndex == index) ? lightBlue : black,
                      fontSize: font14.sp),
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
                    width: 15.w,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$plan",
                          style:
                              TextStyle(color: lightBlack, fontSize: font11.sp),
                        ),
                        Text(
                          "$rupeeSymbol ${mobilePlans[index].rs}",
                          style:
                              TextStyle(color: dotColor, fontSize: font14.sp),
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
                          style:
                              TextStyle(color: lightBlack, fontSize: font12.sp),
                        ),
                        Text(
                          "${mobilePlans[index].validity}",
                          style: TextStyle(
                              color: dotColor,
                              fontSize: font14.sp,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      var planType = mobilePlans[index].planType;
                      var price = mobilePlans[index].rs;
                      var validity = mobilePlans[index].validity;
                      var discription = mobilePlans[index].desc;
                      var number = phoneController.text.toString();

                      _showPlan(planType, price, validity, discription,
                          operatorName, circleName, number, operatorId);
                    },
                    child: Text(
                      "$viewDeatil",
                      style: TextStyle(color: lightBlue, fontSize: font12.sp),
                    ),
                  ),
                  SizedBox(
                    width: 30.w,
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
                        var mobileNo = phoneController.text.toString();

                        Map map = {
                          "planName": "${mobilePlans[index].planType}",
                          "price": "${mobilePlans[index].rs}",
                          "validity": "${mobilePlans[index].validity}",
                          "packageDescription": "${mobilePlans[index].desc}",
                          "operatorName": "$operatorName",
                          "circleName": "$circleName",
                          "billerImg": "$billerImg",
                          "mobileNo": "$mobileNo",
                          "operatorId": "$operatorId",
                          "spKey": "$spKey"
                        };

                        printMessage(screen, "1 : Map :${map.toString()}");

                        openMobilePaymentNew(context, map);
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 4, bottom: 4),
                          child: Text(
                            "$buy",
                            style: TextStyle(
                              color: white,
                              fontSize: font14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
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
                    width: 15.w,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "$plan",
                          style:
                              TextStyle(color: lightBlack, fontSize: font11.sp),
                        ),
                        Text(
                          "$rupeeSymbol ${mobilePlansFiltered[index].rs}",
                          style:
                              TextStyle(color: dotColor, fontSize: font14.sp),
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
                          style:
                              TextStyle(color: lightBlack, fontSize: font12.sp),
                        ),
                        Text(
                          "${mobilePlansFiltered[index].validity}",
                          style: TextStyle(
                              color: dotColor,
                              fontSize: font14.sp,
                              fontWeight: FontWeight.normal),
                        ),
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      var planType = mobilePlansFiltered[index].planType;
                      var price = mobilePlansFiltered[index].rs;
                      var validity = mobilePlansFiltered[index].validity;
                      var discription = mobilePlansFiltered[index].desc;

                      var number = phoneController.text.toString();

                      _showPlan(planType, price, validity, discription,
                          operatorName, circleName, number, operatorId);
                    },
                    child: Text(
                      "$viewDeatil",
                      style: TextStyle(color: lightBlue, fontSize: font12.sp),
                    ),
                  ),
                  SizedBox(
                    width: 30.w,
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
                        var mobileNo = phoneController.text.toString();

                        Map map = {
                          "planName": "${mobilePlansFiltered[index].planType}",
                          "price": "${mobilePlansFiltered[index].rs}",
                          "validity": "${mobilePlansFiltered[index].validity}",
                          "packageDescription":
                              "${mobilePlansFiltered[index].desc}",
                          "operatorName": "$operatorName",
                          "circleName": "$circleName",
                          "billerImg": "$billerImg",
                          "mobileNo": "$mobileNo",
                          "operatorId": "$operatorId",
                          "spKey": "$spKey",
                        };

                        printMessage(screen, "2 : Map :${map.toString()}");

                        openMobilePaymentNew(context, map);
                      },
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 15.0, right: 15, top: 4, bottom: 4),
                          child: Text(
                            "$buy",
                            style: TextStyle(
                              color: white,
                              fontSize: font14.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 20.w,
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
    print(mobilePlans[0].planType);
    for (var i = 0; i < mobilePlans.length; i++) {
      if (mobilePlans[i].planType.toString().toLowerCase() ==
          text.toLowerCase()) {
        mobilePlansFiltered.add(mobilePlans[i]);
      }
    }

    // mobilePlans.forEach((userDetail) {
    //   if (userDetail.planType.toString().toLowerCase() == text.toLowerCase()) {
    //     mobilePlansFiltered.add(userDetail);
    //   }
    // });

    setState(() {
      if (mobilePlansFiltered.length != 0) {
        showSearchResult = true;
      }
    });
  }

  searchByAmount(String text) async {
    mobilePlansFiltered.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    for (var i = 0; i < mobilePlans.length; i++) {
      if (mobilePlans[i].rs.toString() == text) {
        mobilePlansFiltered.add(mobilePlans[i]);
      }
    }
    // mobilePlans.forEach((userDetail) {
    //   if (userDetail.rs.toString() == text) {
    //     mobilePlansFiltered.add(userDetail);
    //   }
    // });

    setState(() {
      if (mobilePlansFiltered.length != 0) {
        showSearchResult = true;
      }
    });
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
      "category": "MOBILE PREPAID",
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

            if (operatorName.toLowerCase() == "bsnl") {
              billerImg = "1629708795.jpg";
              break;
            } else if (operatorName.toLowerCase() == "VODAFONE".toLowerCase()) {
              billerImg = "1629707063.webp";
              break;
            } else {
              if (opName.toLowerCase() == "$operatorName".toLowerCase()) {
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

  Future getOperatorsIds(token) async {
    setState(() {});

    var userToken = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"user_token": "$userToken", "token": "$token"};

    final response = await http.post(Uri.parse(operatorListPrepaidAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        printMessage(screen, "Operator Ids : $data");

        for (int i = 0; i < data['data']['data'].length; i++) {
          var name = data['data']['data'][i]['name'];
          if (operatorName.toLowerCase() == name.toString().toLowerCase()) {
            operatorId = data['data']['data'][i]['id'];
            printMessage(screen, "Operator Id is : $operatorId");
            break;
          }
        }
      });
    } else {
      setState(() {});
      showToastMessage(status500);
    }
  }
}

class showPlanDetail extends StatelessWidget {
  final String planType,
      price,
      validity,
      discription,
      operator,
      circle,
      billerImg,
      number,
      spKey,
      operatorId;

  const showPlanDetail(
      {Key? key,
      required this.planType,
      required this.price,
      required this.validity,
      required this.discription,
      required this.operator,
      required this.circle,
      required this.billerImg,
      required this.spKey,
      required this.number,
      required this.operatorId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: [
        ScreenUtilInit(
            designSize: Size(deviceWidth, deviceHeight),
            builder: () => Container(
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
                                    height: 30.h,
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
                                    fontSize: font26.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "${price}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: 48.sp,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 30.h,
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
                              style: TextStyle(
                                  color: lightBlack, fontSize: font16.sp),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "$planType",
                              style:
                                  TextStyle(color: black, fontSize: font16.sp),
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
                              style: TextStyle(
                                  color: lightBlack, fontSize: font16.sp),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "$validity",
                              style:
                                  TextStyle(color: black, fontSize: font16.sp),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    /*Padding(
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
                ),*/
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 30.0, right: 30, top: 20),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: Text(
                              "Description",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font16.sp),
                            ),
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              "$discription",
                              style:
                                  TextStyle(color: black, fontSize: font15.sp),
                              textAlign: TextAlign.end,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 40.h,
                      margin: EdgeInsets.only(
                          left: 20, right: 20, top: 25, bottom: 25),
                      decoration: BoxDecoration(
                          color: lightBlue,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          border: Border.all(color: lightBlue)),
                      child: InkWell(
                        onTap: () {
                          Map map = {
                            "planName": "$planType",
                            "price": "$price",
                            "validity": "$validity",
                            "packageDescription": "$discription",
                            "operatorName": "$operator",
                            "circleName": "$circle",
                            "billerImg": "$billerImg",
                            "mobileNo": "$number",
                            "operatorId": "$operatorId",
                            "spKey": "$spKey",
                          };
                          printMessage("screen", "3 : Map :${map.toString()}");
                          openMobilePaymentNew(context, map);
                        },
                        child: Center(
                          child: Text(
                            "$buy",
                            style: TextStyle(
                              color: white,
                              fontSize: font16.sp,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
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
                ))),
      ],
    );
  }
}
