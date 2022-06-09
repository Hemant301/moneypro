import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/Merchants.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:moneypro_new/utils/SharedPrefs.dart';

class MerchantList extends StatefulWidget {
  const MerchantList({Key? key}) : super(key: key);

  @override
  _MerchantListState createState() => _MerchantListState();
}

class _MerchantListState extends State<MerchantList> {
  var loading = false;

  var screen = "EmpMerchantList";

  List<MerchantDatum> merchantList = [];

  var dataMerchant;

  @override
  void initState() {
    super.initState();
    getMerchantList();
    updateATMStatus(context);
    fetchUserAccountBalance();
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
                    : SingleChildScrollView(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                            Card(
                              margin:
                                  EdgeInsets.only(left: 10, right: 10, top: 8),
                              elevation: 10,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(15.0),
                                  child: Image.asset(
                                    "assets/merchantlist_banner.jpg",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            _buildMerchant(),
                          ])))));
  }

  _buildMerchant() {
    return ListView.builder(
        itemCount: merchantList.length,
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        physics: ScrollPhysics(),
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 15),
            decoration: BoxDecoration(
                color: boxBg,
                borderRadius: BorderRadius.all(Radius.circular(30)),
                border: Border.all(color: boxBg)),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 10.0, right: 10, top: 10, bottom: 10),
              child: Row(
                children: [
                  Container(
                    height: 40.h,
                    width: 40.w,
                    decoration: BoxDecoration(
                        color: lightBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: lightBlue, width: 3.w)),
                    child: Center(
                        child: Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: Image.asset(
                        'assets/user.png',
                        color: white,
                      ),
                    )),
                  ),
                  SizedBox(
                    width: 10.w,
                  ),
                  Expanded(
                    flex: 3,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${merchantList[index].firstName} ${merchantList[index].lastName}",
                          style: TextStyle(color: black, fontSize: font15.sp),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "${merchantList[index].mobile}",
                          style: TextStyle(color: black, fontSize: font11.sp),
                          textAlign: TextAlign.start,
                        ),
                        SizedBox(
                          height: 5.h,
                        ),
                        InkWell(
                          onTap: () {
                            if (merchantList[index].investor.toLowerCase() ==
                                "yes") {
                              showToastMessage(
                                  "Investor KYC is already completed.");
                            } else {
                              openMerchantInvestorMobile(
                                  context,
                                  merchantList[index].mToken,
                                  merchantList[index].mobile);
                            }
                          },
                          child: Text(
                            "Investor KYC : ${merchantList[index].investor}",
                            style: TextStyle(color: black, fontSize: font14.sp),
                            textAlign: TextAlign.start,
                          ),
                        )
                      ],
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      openEmpViewMerchantQR(
                          context,
                          merchantList[index]
                              .mToken); //, merchantList[index].mobile);
                    },
                    child: Text(
                      "View QR",
                      style: TextStyle(color: black, fontSize: font14.sp),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  SizedBox(
                    width: 15.w,
                  ),
                ],
              ),
            ),
          );
        });
  }

  getMerchantList() async {
    setState(() {
      loading = true;
    });
    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
    };

    final body = {
      "token": token,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(marchantListEmpAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      dataMerchant = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "data : ${dataMerchant}");
      setState(() {
        if (dataMerchant['status'].toString() == "1") {
          var result =
              Merchants.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));

          var totalLength = result.merchantData.length;

          for (int i = 0; i < totalLength; i++) {
            var mobile = result.merchantData[i].mobile;
            getInvestorKycStatus(mobile, i, totalLength);
          }
        } else {
          loading = false;
          showToastMessage(dataMerchant['message'].toString());
        }
      });
    } else {
      setState(() {
        loading = false;
      });
      //showToastMessage(status500);
    }
  }

  Future getInvestorKycStatus(mobile, index, totalLength) async {
    setState(() {});

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
        if (dataMerchant['merchant_data'].length == totalLength) {
          loading = false;
        }

        var statusCode = response.statusCode;

        if (statusCode == 200) {
          String investor;
          String firstName = dataMerchant['merchant_data'][index]['first_name'];
          String lastName = dataMerchant['merchant_data'][index]['last_name'];
          String merchantId =
              dataMerchant['merchant_data'][index]['merchant_id'];
          String mToken = dataMerchant['merchant_data'][index]['m_token'];
          String email = dataMerchant['merchant_data'][index]['email'];
          String mobile = dataMerchant['merchant_data'][index]['mobile'];
          var qr = dataMerchant['merchant_data'][index]['qr'];
          var wpMsgStatus =
              dataMerchant['merchant_data'][index]['wp_msg_status'];

          if (data['status'].toString() == "1") {
            investor = "Yes";
          } else {
            investor = "No";
          }

          MerchantDatum mList = new MerchantDatum(
              firstName: firstName,
              lastName: lastName,
              merchantId: merchantId,
              mToken: mToken,
              email: email,
              mobile: mobile,
              qr: (qr.toString() == "null") ? "" : qr,
              investor: investor,
              wpMsgStatus: wpMsgStatus);

          merchantList.add(mList);
        }
      });
    } else {
      setState(() {
        loading = false;
      });
      // showToastMessage(status500);
    }
  }
}
