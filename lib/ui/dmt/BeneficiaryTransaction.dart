import 'package:flutter/material.dart';
import 'package:moneypro_new/ui/models/CustomerTransaction.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class BeneficiaryTransaction extends StatefulWidget {
  final String custId;
  final String mobile;

  const BeneficiaryTransaction(
      {Key? key, required this.custId, required this.mobile})
      : super(key: key);

  @override
  _BeneficiaryTransactionState createState() => _BeneficiaryTransactionState();
}

class _BeneficiaryTransactionState extends State<BeneficiaryTransaction> {
  List<CustTransctionList> custTransctionList = [];

  var loading = false;

  var screen = "Customer Transaction";

  double moneyProBalc = 0.0;

  @override
  void initState() {
    super.initState();
    getCustomerTransaction();
    updateATMStatus(context);
    updateWalletBalances();
    fetchUserAccountBalance();
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
      moneyProBalc = wX + mX;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            backgroundColor: white,
            resizeToAvoidBottomInset: false,
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
                          height: 20,
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 10.0, right: 10, top: 5),
                            child: Text(
                              //"${formatDecimal2Digit.format(moneyProBalc)}",
                              "$moneyProBalc",
                              style: TextStyle(color: white, fontSize: font15),
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
                  child:
                  (custTransctionList.length == 0)
                      ? NoDataFound(text: 'No data found.')
                      : _buildTransactions(),
                )));
  }

  _buildTransactions() {
    return ListView.builder(
      itemCount: custTransctionList.length,
      shrinkWrap: true,
      scrollDirection: Axis.vertical,
      physics: ScrollPhysics(),
      itemBuilder: (context, index) {
        return InkWell(
          onTap: () {
            Map map = {
              "date": "${custTransctionList[index].date}",
              "transId": "${custTransctionList[index].transctionId}",
              "amount": "${custTransctionList[index].amount}",
              "mode": "${custTransctionList[index].mode}",
              "status": "${custTransctionList[index].status}",
              "mobile": "${widget.mobile}",
            };

            // openDMTTransactionReceipt(context, map);
          },
          child: Container(
            margin: EdgeInsets.only(top: 10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                color: white,
                borderRadius:
                BorderRadius.all(Radius.circular(20)),
                border: Border.all(color: gray)),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  Container(
                      height: 45,
                      width: 45,
                      decoration: BoxDecoration(
                        color: lightBlue, // border color
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(9.0),
                        child: Image.asset(
                          'assets/wallet_white.png',
                        ),
                      )),
                  SizedBox(
                    width: 5,
                  ),
                  Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Txn Id : ${custTransctionList[index].transctionId}",
                              style: TextStyle(
                                  color: black, fontSize: font15),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 10.0),
                            child: Text(
                              "Mode : ${custTransctionList[index].mode}",
                              style: TextStyle(
                                  color: black, fontSize: font13),
                              textAlign: TextAlign.left,
                            ),
                          )
                        ],
                      )),
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, top: 8),
                        child: Text(
                          "$rupeeSymbol ${custTransctionList[index].amount}",
                          style: TextStyle(
                              color: black, fontSize: font16),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 8.0, right: 8, bottom: 8),
                        child: Text(
                            "Debited",
                            style: TextStyle(
                                color: black, fontSize: font13)),
                      )
                    ],
                  ),
                  SizedBox(
                    width: 5,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future getCustomerTransaction() async {
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
      "customer_id": widget.custId,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(dmtTransctionCustomerAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Transaction : $data");

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          var result = CustomerTransaction.fromJson(
              jsonDecode(utf8.decode(response.bodyBytes)));
          custTransctionList = result.custTransctionList;
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    }else{
      setState(() {
        loading = false;
      });
      showToastMessage(status500);
    }


  }
}
