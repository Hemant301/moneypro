import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/Favourites.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class FavouriteSenders extends StatefulWidget {
  const FavouriteSenders({Key? key}) : super(key: key);

  @override
  _FavouriteSendersState createState() => _FavouriteSendersState();
}

class _FavouriteSendersState extends State<FavouriteSenders> {
  var loading = false;

  List<CustomerList> customerList = [];

  var screen = "Favourite Bene";

  double moneyProBalc = 0.0;

  @override
  void initState() {
    super.initState();
    getAllFavourite();
    updateATMStatus(context);
    updateWalletBalances();
    fetchUserAccountBalance();
  }

  /*updateWalletBalances() async {
    var mpBalc = await getWalletBalance();
    var qrBalc = await getQRBalance();

    final inheritedWidget = StateContainer.of(context);

    inheritedWidget.updateMPBalc(value: mpBalc);
    if (mpBalc == null || mpBalc == 0) {
      mpBalc = 0;
      final inheritedWidget = StateContainer.of(context);
      inheritedWidget.updateMPBalc(value: mpBalc);
    }

    inheritedWidget.updateQRBalc(value: qrBalc);
    if (qrBalc == null || qrBalc == 0) {
      qrBalc = 0;
      final inheritedWidget = StateContainer.of(context);
      inheritedWidget.updateQRBalc(value: qrBalc);
    }

    setState(() {
      moneyProBalc = mpBalc;

      if (moneyProBalc.toString() == "") {
        moneyProBalc = "0.0";
      }
    });
  }*/

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
      moneyProBalc = wX + mX;
    });
  }

  @override
  Widget build(BuildContext context) {
    final InheritedWidget = StateContainer.of(context);
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
                    padding:
                        const EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
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
                              //"${formatDecimal2Digit.format(moneyProBalc)}",
                              "$moneyProBalc",
                              style: TextStyle(color: white, fontSize: font15.sp),
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
                : SingleChildScrollView(
                    child: (customerList.length == 0)
                        ? NoDataFound(
                            text: 'No data found',
                          )
                        : _buildSender()))));
  }

  _buildSender() {
    return ListView.builder(
      itemCount: customerList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            openBeneficiaryDetail(
                context,
                customerList[index].customerId.toString(),
                customerList[index].customerName.toString(),
                customerList[index].mobile.toString());
          },
          child: Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            decoration: BoxDecoration(
                color: white,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                border: Border.all(color: gray)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 10,
                  ),
                  Container(
                      height: 36.h,
                      width: 36.w,
                      decoration: BoxDecoration(
                        color: invBoxBg, // border color
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Image.asset(
                          'assets/user.png',
                          color: lightBlue,
                        ),
                      )),
                  SizedBox(
                    width: 10,
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10.h,
                          ),
                          Text(
                            "${customerList[index].customerName}",
                            style: TextStyle(color: black, fontSize: font15.sp),
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            "${customerList[index].mobile}",
                            style:
                                TextStyle(color: lightBlack, fontSize: font13.sp),
                          ),
                          SizedBox(
                            height: 10.h,
                          ),
                        ],
                      )),
                  Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: black,
                    size: 16,
                  ),
                  SizedBox(
                    width: 15,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future getAllFavourite() async {
    setState(() {
      loading = true;
    });

    var mechantId = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "m_id": mechantId,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtCustomerListFavAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response All Senders : $data");

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          var result =
              Favourites.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          customerList = result.customerList;
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
}
