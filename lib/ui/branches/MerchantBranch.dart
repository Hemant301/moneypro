import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/Branches.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/AppKeys.dart';

class MerchantBranch extends StatefulWidget {
  final bool isManagerShow;

  const MerchantBranch({Key? key, required this.isManagerShow})
      : super(key: key);

  @override
  _MerchantBranchState createState() => _MerchantBranchState();
}

class _MerchantBranchState extends State<MerchantBranch> {
  var screen = "Merchant Branch";

  List<BranchList> branchLists = [];

  var loading = false;

  bool isBranchesReload = false;
  int pageBranches = 1;
  int branchesTotalPage = 0;
  late ScrollController scrollBranchesController;

  @override
  void initState() {
    super.initState();
    scrollBranchesController = new ScrollController()
      ..addListener(_scrollBranchesListener);
    updateATMStatus(context);
    getBranchList();
  }

  void _scrollBranchesListener() {
    if (pageBranches <= branchesTotalPage) {
      if (scrollBranchesController.position.extentAfter < 500) {
        setState(() {
          isBranchesReload = true;
          if (isBranchesReload) {
            isBranchesReload = false;
            pageBranches = pageBranches + 1;
            getQRTransactionsOnScroll(pageBranches);
          }
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              backgroundColor: white,
              appBar: appBarHome(context, "", 24.0.w),
              body: (loading)
                  ? Center(child: circularProgressLoading(40.0))
                  : RefreshIndicator(
                      onRefresh: () async{
                        getBranchListRefresh();
                        },
                      child: SingleChildScrollView(
                          controller: scrollBranchesController,
                          physics: AlwaysScrollableScrollPhysics(),
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (branchLists.length == 0)
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(15.0),
                                          child: Image.asset(
                                            "assets/merchant_branch.png",
                                            fit: BoxFit.fill,
                                          ),
                                        ),
                                      ),
                                (branchLists.length == 0)
                                    ? Container()
                                    : Padding(
                                        padding: const EdgeInsets.only(
                                            left: 20.0,
                                            right: 20,
                                            top: 20,
                                            bottom: 10),
                                        child: Text(
                                          "Branches",
                                          style: TextStyle(
                                              color: black,
                                              fontSize: font14.sp,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                (branchLists.length == 0)
                                    ? NoDataFound(text: '')
                                    : _buildBrachList(),
                              ])),
                    ),
            )));
  }

  _buildBrachList() {
    return ListView.builder(
        itemCount: branchLists.length,
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 60.w,
                      height: 60.h,
                      child: Image.network(
                        "$branchImgUrl${branchLists[index].photo}",
                        width: 60.w,
                        height: 60.h,
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: () {
                          openBranchTransactions(
                              context,
                              branchLists[index].id.toString(),
                              branchLists[index].mobile.toString(),
                              branchLists[index].branchWallet.toString(),
                              "",
                              "");
                        },
                        child: Padding(
                          padding: const EdgeInsets.only(left: 10.0, top: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("${branchLists[index].branchName}",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font15.sp,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(
                                height: 3,
                              ),
                              Text("${branchLists[index].mobile}",
                                  style: TextStyle(
                                      color: lightBlack, fontSize: font14.sp)),
                              SizedBox(
                                height: 3,
                              ),
                              Text("UPI Id : ${branchLists[index].branchQrId}",
                                  style: TextStyle(
                                      color: black, fontSize: font13.sp)),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                            "Total $rupeeSymbol ${branchLists[index].branchWallet}",
                            style: TextStyle(
                                color: green,
                                fontSize: font15.sp,
                                fontWeight: FontWeight.bold)),
                        SizedBox(
                          height: 5.h,
                        ),
                        (widget.isManagerShow)
                            ? Container()
                            : InkWell(
                                onTap: () {
                                  var amount = branchLists[index].branchWallet;
                                  var qrId = branchLists[index].branchQrId;
                                  var branchId = branchLists[index].id;
                                  var branchName =
                                      branchLists[index].branchName;
                                  var mobile = branchLists[index].mobile;
                                  var photo = branchLists[index].photo;
                                  openBranchWithdrawal(
                                      context,
                                      amount,
                                      qrId,
                                      branchId,
                                      branchName,
                                      mobile,
                                      photo,
                                      widget.isManagerShow);
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: lightBlue,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(30)),
                                      border: Border.all(color: lightBlue)),
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 12.0,
                                        right: 12,
                                        top: 4,
                                        bottom: 4),
                                    child: Center(
                                      child: FittedBox(
                                        fit: BoxFit.contain,
                                        child: Text(
                                          "Withdrawal",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: font13.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                      ],
                    )
                  ],
                ),
                Divider(),
              ],
            ),
          );
        });
  }

  Future getBranchList() async {
    setState(() {
      loading = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$token",
      "page": "1",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchListAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Branch : $data");

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          var result =
              Branches.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          branchLists = result.transctionList;
          branchesTotalPage = int.parse(data['total_pages'].toString());
        }
      });
    } else {
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }
  }

  Future getBranchListRefresh() async {
    setState(() {
      // loading = true;
      branchLists.clear();
      branchesTotalPage = 0;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": "$token",
      "page": "1",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchListAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Branch : $data");

      setState(() {
        //loading = false;
        if (data['status'].toString() == "1") {
          var result =
              Branches.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          branchLists = result.transctionList;
          branchesTotalPage = int.parse(data['total_pages'].toString());
        }
      });
    } else {
      setState(() {
        // loading = false;
      });
      showToastMessage(status500);
    }
  }

  Future getQRTransactionsOnScroll(page) async {
    setState(() {
      isBranchesReload = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {"token": token, "page": "$page"};

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchListAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      setState(() {
        isBranchesReload = false;
        if (data['status'].toString() == "1") {
          List<BranchList> branchListsNew = [];
          if (data['transction_list'].length != 0) {
            for (int i = 0; i < data['transction_list'].length; i++) {
              var id = data['transction_list'][i]['id'];
              var branchName = data['transction_list'][i]['branch_name'];
              var mobile = data['transction_list'][i]['mobile'];
              var managerName = data['transction_list'][i]['manager_name'];
              var branchWallet = data['transction_list'][i]['branch_wallet'];
              var photo = data['transction_list'][i]['photo'];
              var branchQrId = data['transction_list'][i]['branch_qrid'];

              BranchList pay = new BranchList(
                  id: id,
                  branchName: branchName,
                  mobile: mobile,
                  managerName: managerName,
                  branchWallet: branchWallet,
                  photo: photo,
                  branchQrId: branchQrId);

              branchListsNew.add(pay);
              branchLists.insertAll(branchLists.length, branchListsNew);
            }
          }
        }
      });
    } else {
      setState(() {
        isBranchesReload = false;
      });
      showToastMessage(status500);
    }
  }
}
