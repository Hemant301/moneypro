import 'package:flutter/material.dart';
import 'package:moneypro_new/ui/models/MiniStatement.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'dart:convert';

class AEPSMiniStatement extends StatefulWidget {
  final String response;

  const AEPSMiniStatement({Key? key, required this.response}) : super(key: key);

  @override
  _AEPSMiniStatementState createState() => _AEPSMiniStatementState();
}

class _AEPSMiniStatementState extends State<AEPSMiniStatement> {
  var screen = "AEPS Mini Statement";
  var loading = false;
  List<Passbook> passbook = [];
  var bankName = "ICIC Bank";

  var remainingBalance = 00.00;
  var refId = "";
  var rrnId = "";
  var isPassbookShow = false;
  var bankResponseMsg;

  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchUserAccountBalance();
    updateATMStatus(context);

    setState(() {
      var response = widget.response;

      var data = jsonDecode(response);

      if (data['data']['passbook'].toString() == "null") {
        setState(() {
          isPassbookShow = false;
        });
        bankResponseMsg = data['data']['bankResponseMsg'];
      } else {
        setState(() {
          isPassbookShow = true;
        });
        var result = MiniStatement.fromJson(jsonDecode(response));
        refId = result.data.partnerRefId;
        rrnId = result.data.rrn;
        passbook = result.data.passbook;
        bankName = result.data.bankName;
        bankResponseMsg = result.data.bankResponseMsg;
        remainingBalance = result.data.remainingBalance;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              elevation: 0,
              centerTitle: false,
              backgroundColor: white,
              brightness: Brightness.light,
              leading: IconButton(
                icon: Image.asset(
                  'assets/back_arrow.png',
                  height: 24,
                ),
                onPressed: () {
                  closeKeyBoard(context);
                  closeCurrentPage(context);
                },
              ),
              titleSpacing: 0,
              title: appLogo(),
              actions: [
                InkWell(
                  onTap: () {
                    shareTransReceipt(_printKey, "aeps");
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.asset(
                      'assets/share.png',
                      color: lightBlue,
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    downloadReceiptAsPDF(_printKey);
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Image.asset(
                      'assets/download_file.png',
                      color: lightBlue,
                    ),
                  ),
                ),
                SizedBox(
                  width: 10,
                )
              ],
            ),
            body: RepaintBoundary(
                key: _printKey,
                child: Container(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    color: white,
                    child: (isPassbookShow)
                        ? SingleChildScrollView(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: 30,
                                ),
                                Text(
                                  "Mini Statement",
                                  style: TextStyle(
                                      color: black,
                                      fontSize: font18,
                                      decoration: TextDecoration.underline),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25, bottom: 20),
                                  child: Text(
                                    "Avaiable Balance : $rupeeSymbol $remainingBalance",
                                    style: TextStyle(
                                        color: black,
                                        fontWeight: FontWeight.bold,
                                        fontSize: font16),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "Ref Id: $refId",
                                          style: TextStyle(
                                              color: black, fontSize: font14),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "Txn Id: $rrnId",
                                          style: TextStyle(
                                              color: black, fontSize: font14),
                                          textAlign: TextAlign.end,
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                                Divider(),
                                _buildPassbook(),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 25.0, right: 25),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Text(
                                          "Bank Msg : $bankResponseMsg",
                                          style: TextStyle(
                                              color: black, fontSize: font14),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : NoDataFound(text: "$bankResponseMsg")))));
  }

  _buildPassbook() {
    return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: passbook.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.only(left: 15, right: 15, top: 10),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                "${passbook[index].date}",
                                style:
                                    TextStyle(color: black, fontSize: font12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                "${passbook[index].narration}",
                                style:
                                    TextStyle(color: black, fontSize: font14),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        )),
                    Padding(
                      padding:
                          const EdgeInsets.only(left: 8.0, right: 8, top: 0),
                      child: Text(
                        "$rupeeSymbol ${passbook[index].amount} (${passbook[index].txnType})",
                        style: TextStyle(
                            color:
                                (passbook[index].txnType.toLowerCase() == "cr")
                                    ? green
                                    : red,
                            fontSize: font16),
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        });
  }
}
