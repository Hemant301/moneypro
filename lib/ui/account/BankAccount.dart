import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class BankAccount extends StatefulWidget {
  const BankAccount({Key? key}) : super(key: key);

  @override
  _BankAccountState createState() => _BankAccountState();
}

class _BankAccountState extends State<BankAccount>
    with SingleTickerProviderStateMixin {
  var screen = "Bank Account";

  final List<Tab> tabs = <Tab>[
    new Tab(text: "Primary Account"),
    new Tab(text: "Virtual Account"),
    new Tab(text: "Investor Account"),
  ];

  TabController? _tabController;
  int headerIndex = 0;

  var contactName;
  var fname;
  var lname;
  var panNo;
  var adhar;
  var name;
  var accountNo;
  var ifsc;
  var branch;

  var virtualAccountsId;
  var virtualAccountNumber;
  var virtualAccountIfscCode;

  var invVirtualAccount;
  var invIFSC;
  var invBankName;
  var invHolderName;
  var invBranch;
  var invAccountType;

  var loading = false;

  var isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);
    _tabController = new TabController(vsync: this, length: tabs.length);

    getUserDetails();
  }

  getUserDetails() async {
    contactName = await getContactName();
    fname = await getFirstName();
    lname = await getLastName();
    panNo = await getPANNo();
    adhar = await getAdhar();
    accountNo = await getAccountNumber();

    ifsc = await getIFSC();
    branch = await getBranchCity();

    virtualAccountsId = await getVirtualAccId();
    virtualAccountNumber = await getVirtualAccNo();
    virtualAccountIfscCode = await getVirtualAccIFSC();

    setState(() {
      if (contactName.toString() == "" || contactName.toString() == "null") {
        name = "$fname $lname";
      } else {
        name = "$contactName";
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: AppBar(
          elevation: 5,
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
          titleSpacing: -10,
          title: appLogo(),
          bottom: new TabBar(
            isScrollable: false,
            unselectedLabelColor: black,
            labelColor: lightBlue,
            labelStyle: TextStyle(fontSize: font14),
            indicatorSize: TabBarIndicatorSize.tab,
            indicator: new BubbleTabIndicator(
              indicatorHeight: 25.0,
              indicatorColor: white,
              tabBarIndicatorSize: TabBarIndicatorSize.tab,
              // Other flags
              // indicatorRadius: 1,
              // insets: EdgeInsets.all(1),
              // padding: EdgeInsets.all(10)
            ),
            tabs: tabs,
            controller: _tabController,
            onTap: (val) {
              printMessage(screen, "Tab on : $val");
              setState(() {
                headerIndex = val;
              });
              if (val == 0) {
              } else if (val == 1) {
                // UPI QR response here
                //getQRTransactions();
              } else if (val == 2) {
                // UPI QR response here
                if (!isDataLoaded) getInvestorKycStatus();
              }
            },
          )),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          _buildPrimaryAccount(),
          _buildVirtualAccount(),
          _buildInvestorAccount(),
        ],
      ),
    ));
  }

  _buildPrimaryAccount() {
    return Column(
      children: [
        appSelectedBanner(context, "recharge_banner.png", 150.0),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Name",
                  style: TextStyle(color: lightBlue, fontSize: font14),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "$name",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: lightBlue,
                      fontSize: font14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
          child: Divider(
            thickness: 0.5,
            color: gray,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Account No",
                  style: TextStyle(color: lightBlue, fontSize: font14),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "$accountNo",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: lightBlue,
                      fontSize: font14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
          child: Divider(
            thickness: 0.5,
            color: gray,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "IFSC Code",
                  style: TextStyle(color: lightBlue, fontSize: font14),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "$ifsc",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: lightBlue,
                      fontSize: font14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
          child: Divider(
            thickness: 0.5,
            color: gray,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Branch",
                  style: TextStyle(color: lightBlue, fontSize: font14),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "$branch",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: lightBlue,
                      fontSize: font14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
          child: Divider(
            thickness: 0.5,
            color: gray,
          ),
        ),
      ],
    );
  }

  _buildVirtualAccount() {
    return Column(
      children: [
        appSelectedBanner(context, "recharge_banner.png", 150.0),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Name",
                  style: TextStyle(color: lightBlue, fontSize: font14),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "$name",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: lightBlue,
                      fontSize: font14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
          child: Divider(
            thickness: 0.5,
            color: gray,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Virtual Id",
                  style: TextStyle(color: lightBlue, fontSize: font14),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "$virtualAccountsId",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: lightBlue,
                      fontSize: font14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
          child: Divider(
            thickness: 0.5,
            color: gray,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Virtual Account No",
                  style: TextStyle(color: lightBlue, fontSize: font14),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "$virtualAccountNumber",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: lightBlue,
                      fontSize: font14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
          child: Divider(
            thickness: 0.5,
            color: gray,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
          child: Row(
            children: [
              Expanded(
                flex: 2,
                child: Text(
                  "Virtual IFSC Code",
                  style: TextStyle(color: lightBlue, fontSize: font14),
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  "$virtualAccountIfscCode",
                  textAlign: TextAlign.end,
                  style: TextStyle(
                      color: lightBlue,
                      fontSize: font14,
                      fontWeight: FontWeight.w500),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
          child: Divider(
            thickness: 0.5,
            color: gray,
          ),
        ),
      ],
    );
  }

  _buildInvestorAccount() {
    return (loading)
        ? Center(
            child: circularProgressLoading(40.0),
          )
        : Column(
            children: [
              appSelectedBanner(context, "recharge_banner.png", 150.0),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Virtual Acc. No.",
                        style: TextStyle(color: lightBlue, fontSize: font14),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "$invVirtualAccount",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: lightBlue,
                            fontSize: font14,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
                child: Divider(
                  thickness: 0.5,
                  color: gray,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "IFSC Code",
                        style: TextStyle(color: lightBlue, fontSize: font14),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "$invIFSC",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: lightBlue,
                            fontSize: font14,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
                child: Divider(
                  thickness: 0.5,
                  color: gray,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Bank Name",
                        style: TextStyle(color: lightBlue, fontSize: font14),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "$invBankName",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: lightBlue,
                            fontSize: font14,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
                child: Divider(
                  thickness: 0.5,
                  color: gray,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Holder Name",
                        style: TextStyle(color: lightBlue, fontSize: font14),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "$invHolderName",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: lightBlue,
                            fontSize: font14,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
                child: Divider(
                  thickness: 0.5,
                  color: gray,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Branch",
                        style: TextStyle(color: lightBlue, fontSize: font14),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "$invBranch",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: lightBlue,
                            fontSize: font14,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
                child: Divider(
                  thickness: 0.5,
                  color: gray,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                child: Row(
                  children: [
                    Expanded(
                      flex: 2,
                      child: Text(
                        "Account Type",
                        style: TextStyle(color: lightBlue, fontSize: font14),
                      ),
                    ),
                    Expanded(
                      flex: 3,
                      child: Text(
                        "$invAccountType",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                            color: lightBlue,
                            fontSize: font14,
                            fontWeight: FontWeight.w500),
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15.0, right: 15, top: 0),
                child: Divider(
                  thickness: 0.5,
                  color: gray,
                ),
              ),
            ],
          );
  }

  Future getInvestorKycStatus() async {
    setState(() {
      loading = true;
    });

    var mobile = await getMobile();
    var pan = await getPANNo();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "mobile": mobile,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(investorKycStatusAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response statusCode : ${data}");

      setState(() {
        loading = false;
        isDataLoaded = true;
        invVirtualAccount = data['profile_data']['virtual_account'].toString();
        invIFSC = data['profile_data']['IFSC'].toString();
        invBankName = data['profile_data']['bank_name'].toString();
        invHolderName = data['profile_data']['holder_name'].toString();
        invBranch = data['profile_data']['branch'].toString();
        invAccountType = data['profile_data']['account_type'].toString();
      });
    } else {
      setState(() {
        loading = false;
        showToastMessage(status500);
      });
    }
  }
}
