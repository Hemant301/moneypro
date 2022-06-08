import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:moneypro_new/ui/models/Banks.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/AppKeys.dart';
import 'package:moneypro_new/utils/AppKeys.dart';



class SelectBank extends StatefulWidget {
  const SelectBank({Key? key}) : super(key: key);

  @override
  _SelectBankState createState() => _SelectBankState();
}

class _SelectBankState extends State<SelectBank> {
  var screen = "Select Bank";

  var loading = false;

  List<BankList> bankList = [];
  List<BankList> bankListFiltered = [];
  List<BankList> popularBankList = [];

  final searchBankController = new TextEditingController();

  var showSearchResult = false;

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
    getBankList();
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
            body: (loading)
                ? Center(
                    child: circularProgressLoading(40.0),
                  )
                : ListView(children: [
                    Container(
                      margin:
                          EdgeInsets.only(top: padding, left: 20, right: 20),
                      decoration: BoxDecoration(
                        color: editBg,
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, top: 0, bottom: 0),
                        child: TextFormField(
                          style: TextStyle(color: black, fontSize: 14.sp),
                          keyboardType: TextInputType.text,
                          textInputAction: TextInputAction.done,
                          textCapitalization: TextCapitalization.characters,
                          controller: searchBankController,
                          decoration: new InputDecoration(
                            isDense: false,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 10),
                            counterText: "",
                            hintText: "Search bank",
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
                    (showSearchResult)
                        ? Container()
                        : Card(
                            elevation: 10,
                            margin: EdgeInsets.all(15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Padding(
                              padding:
                                  const EdgeInsets.only(left: 15.0, right: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15.0, top: 20),
                                    child: Text(
                                      "Popular banks",
                                      style: TextStyle(
                                          color: black,
                                          fontSize: font16.sp,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                  _buildPopularBank(),
                                  SizedBox(
                                    height: 20.h,
                                  ),
                                ],
                              ),
                            ),
                          ),
                    Card(
                      elevation: 10,
                      margin: EdgeInsets.all(15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.only(left: 15.0, right: 15),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 15.0, top: 20),
                                child: Text(
                                  "Other banks",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font16.sp,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              SizedBox(
                                height: 20.h,
                              ),
                              (showSearchResult)
                                  ? _buildSearchOtherBanks()
                                  : _buildOtherBanks(),
                              SizedBox(
                                height: 20.h,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]))));
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
        printMessage(screen, "Bank Response : $data");
        if (data['status'].toString() == "1") {
          var result =
              Banks.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

          bankList = result.data;
          bankList.sort((a, b) => a.bankName.compareTo(b.bankName));
        }

        if (bankList.length != 0) {
          setPopupalBanks();
        }
      }
    });
  }

  setPopupalBanks() {
    for (int i = 0; i < bankList.length; i++) {
      var bankName = bankList[i].bankName.toString();

      if (bankName.toString() == "Axis Bank Ltd") {
        BankList dState1 = new BankList(
            id: bankList[i].id,
            bankName: bankList[i].bankName,
            status: bankList[i].status,
            logo: bankList[i].logo,
            createdAt: bankList[i].createdAt,
            updatedAt: bankList[i].updatedAt);
        popularBankList.add(dState1);
      }

      if (bankName.toString() == "HDFC Bank Ltd") {
        BankList dState1 = new BankList(
            id: bankList[i].id,
            bankName: bankList[i].bankName,
            status: bankList[i].status,
            logo: bankList[i].logo,
            createdAt: bankList[i].createdAt,
            updatedAt: bankList[i].updatedAt);
        popularBankList.add(dState1);
      }

      if (bankName.toString() == "ICICI Bank Ltd.") {
        BankList dState1 = new BankList(
            id: bankList[i].id,
            bankName: bankList[i].bankName,
            status: bankList[i].status,
            logo: bankList[i].logo,
            createdAt: bankList[i].createdAt,
            updatedAt: bankList[i].updatedAt);
        popularBankList.add(dState1);
      }

      if (bankName.toString() == "Kotak Mahindra Bank Ltd") {
        BankList dState1 = new BankList(
            id: bankList[i].id,
            bankName: bankList[i].bankName,
            status: bankList[i].status,
            logo: bankList[i].logo,
            createdAt: bankList[i].createdAt,
            updatedAt: bankList[i].updatedAt);
        popularBankList.add(dState1);
      }

      if (bankName.toString() == "YES Bank Ltd.") {
        BankList dState1 = new BankList(
            id: bankList[i].id,
            bankName: bankList[i].bankName,
            status: bankList[i].status,
            logo: bankList[i].logo,
            createdAt: bankList[i].createdAt,
            updatedAt: bankList[i].updatedAt);
        popularBankList.add(dState1);
      }

      if (bankName.toString() == "Bank of Baroda") {
        BankList dState1 = new BankList(
            id: bankList[i].id,
            bankName: bankList[i].bankName,
            status: bankList[i].status,
            logo: bankList[i].logo,
            createdAt: bankList[i].createdAt,
            updatedAt: bankList[i].updatedAt);
        popularBankList.add(dState1);
      }

      if (bankName.toString() == "State Bank of India") {
        BankList dState1 = new BankList(
            id: bankList[i].id,
            bankName: bankList[i].bankName,
            status: bankList[i].status,
            logo: bankList[i].logo,
            createdAt: bankList[i].createdAt,
            updatedAt: bankList[i].updatedAt);
        popularBankList.add(dState1);
      }
    }

    popularBankList.sort((a, b) => a.bankName.compareTo(b.bankName));

    printMessage(screen, "Popular bank lenght : ${popularBankList.length}");
  }

  _buildPopularBank() {
    return AlignedGridView.count(
      crossAxisCount: 3,
      mainAxisSpacing: 20,
      crossAxisSpacing: 20,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            var bankName = popularBankList[index].bankName;
            var logo = popularBankList[index].logo;
            openAddNewAccount(context, bankName, logo);
          },
          child: Column(
            children: [
              SizedBox(
                width: 36.w,
                height: 36.h,
                child: Image.network(
                  "$bankIconUrl${popularBankList[index].logo}",
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Text(
                popularBankList[index].bankName,
                style: TextStyle(color: black, fontSize: font14.sp),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 5.h,
              ),
            ],
          ),
        );
      },
      itemCount: popularBankList.length,
    );
  }

  _buildOtherBanks() {
    return ListView.builder(
        itemCount: bankList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              var bankName = bankList[index].bankName;
              var logo = bankList[index].logo;
              openAddNewAccount(context, bankName, logo);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 36.w,
                      child: Image.network(
                        "$bankIconUrl${bankList[index].logo}",
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        bankList[index].bankName,
                        style: TextStyle(color: black, fontSize: font14.sp),
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        });
  }

  _buildSearchOtherBanks() {
    return ListView.builder(
        itemCount: bankListFiltered.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              var bankName = bankListFiltered[index].bankName;
              var logo = bankListFiltered[index].logo;
              openAddNewAccount(context, bankName, logo);
            },
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 36.w,
                      child: Image.network(
                        "$bankIconUrl${bankListFiltered[index].logo}",
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        bankListFiltered[index].bankName,
                        style: TextStyle(color: black, fontSize: font14.sp),
                      ),
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        });
  }

  onSearchTextChanged(String text) async {
    printMessage(screen, "Case 0 : $text");
    bankListFiltered.clear();
    if (text.isEmpty) {
      setState(() {});
      return;
    }

    bankList.forEach((userDetail) {
      if (userDetail.bankName
          .toString()
          .toLowerCase()
          .contains(text.toLowerCase())) {
        printMessage(screen, "Case 2 :");
        bankListFiltered.add(userDetail);
      }
    });

    setState(() {
      printMessage(screen, "Case 3 : ${bankListFiltered.length}");
      if (bankListFiltered.length != 0) {
        showSearchResult = true;
      }
    });
  }
}
