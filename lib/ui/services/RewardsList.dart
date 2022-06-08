import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/Reward.dart';
import 'package:moneypro_new/ui/models/WalletTransactions.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';



import 'package:scratcher/scratcher.dart';

class RewardsList extends StatefulWidget {
  const RewardsList({Key? key}) : super(key: key);

  @override
  _RewardsListState createState() => _RewardsListState();
}

class _RewardsListState extends State<RewardsList> {
  var loading = false;

  var screen = "Reward List";

  List<ComissionList> comissionList = [];

  bool isReload = false;
  bool isWalletReload = false;
  int pageWalletNo = 1;
  int walletTotalPage = 0;
  late ScrollController scrollWalletController;

  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();
    fetchUserAccountBalance();

    scrollWalletController = new ScrollController()
      ..addListener(_scrollWalletListener);

    getWalletTransactions(pageWalletNo);
  }

  void _scrollWalletListener() {
    if (pageWalletNo <= walletTotalPage) {
      if (scrollWalletController.position.extentAfter < 500) {
        setState(() {
          isReload = true;
          if (isReload) {
            isReload = false;
            pageWalletNo = pageWalletNo + 1;
            getWalletTransactionsOnScroll(pageWalletNo);
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
                ? Center(
                    child: circularProgressLoading(40.0),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Card(
                          margin: EdgeInsets.only(left: 10, right: 10, top: 8),
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(15.0),
                              child: Image.asset(
                                "assets/recharge_banner.png",
                                fit: BoxFit.fill,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        Expanded(
                          flex: 1,
                          child: GridView.count(
                              crossAxisCount: 2,
                              crossAxisSpacing: 5.0,
                              mainAxisSpacing: 5.0,
                              children:
                                  List.generate(comissionList.length, (index) {
                                return (comissionList[index].scratchSttatus ==
                                        0)
                                    ? Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                .8.w,
                                        decoration: BoxDecoration(
                                          color: white,
                                          borderRadius: BorderRadius.only(
                                            topRight: Radius.circular(25),
                                            topLeft: Radius.circular(25),
                                            bottomRight: Radius.circular(25),
                                            bottomLeft: Radius.circular(25),
                                          ),
                                        ),
                                        child: InkWell(
                                            onTap: () {
                                              cashbackPopup(
                                                  context,
                                                  comissionList[index]
                                                      .commission
                                                      .toString(),
                                                  comissionList[index]
                                                      .txnId
                                                      .toString());
                                            },
                                            child: Image.asset(
                                              'assets/scratchBanner.png',
                                            )))
                                    : Center(
                                        child: Card(
                                          elevation: 10,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                          ),
                                          child: Container(
                                              width: MediaQuery.of(context)
                                                  .size
                                                  .width,
                                              child: ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Column(
                                                    children: [
                                                      SizedBox(
                                                        height: 15.h,
                                                      ),
                                                      Text(
                                                        "Congrats You Won!",
                                                        style: TextStyle(
                                                            color: orange,
                                                            fontSize: 14.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Text(
                                                        "${comissionList[index].commission}",
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize: 32.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      Image.asset(
                                                        'assets/giftbox.png',
                                                        height: 50.h,
                                                      ),
                                                      SizedBox(
                                                        height: 10.h,
                                                      ),
                                                      Text(
                                                        "Cashback",
                                                        style: TextStyle(
                                                            color: black,
                                                            fontSize: font18.sp,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                      SizedBox(
                                                        height: 20.h,
                                                      ),
                                                    ],
                                                  ))),
                                        ),
                                      );
                              })),
                        ),
                      ],
                    ),
                  ))));
  }

  Future getWalletTransactions(pageWalletNo) async {
    setState(() {
      loading = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$token",
      "page": "$pageWalletNo",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(bbpsComissionListAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Wallet Transaction : $data");

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          var result =
              Reward.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          comissionList = result.comissionList;

          int r = result.comissionList.length;

          walletTotalPage = int.parse(data['total_pages'].toString());
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }
  }

  Future getWalletTransactionsOnScroll(pageWalletNo) async {
    setState(() {
      isWalletReload = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$token",
      "page": "$pageWalletNo",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(bbpsComissionListAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Wallet Transaction : $data");

      setState(() {
        isWalletReload = false;
        if (data['status'].toString() == "1") {
          var result =
          Reward.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          comissionList = result.comissionList;
        }
      });
    }else{
      setState(() {
        isWalletReload = false;
      });
      showToastMessage(status500);
    }


  }

  Future changeStickerStatus(txId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: "Please wait, update your status");
          });
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$token",
      "txn_id": "$txId",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(scratchStatusUpdateAPI),
        body: jsonEncode(body), headers: headers);

    var data = jsonDecode(utf8.decode(response.bodyBytes));

    printMessage(screen, "Wallet Transaction : $data");

    setState(() {
      Navigator.pop(context);
    });
  }
}
