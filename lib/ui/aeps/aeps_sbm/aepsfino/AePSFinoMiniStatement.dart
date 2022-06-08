import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:moneypro_new/ui/models/MiniStatement.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class AePSFinoMiniStatement extends StatefulWidget {
  final Map response;

  const AePSFinoMiniStatement({Key? key, required this.response})
      : super(key: key);

  @override
  State<AePSFinoMiniStatement> createState() => _AePSFinoMiniStatementState();
}

class _AePSFinoMiniStatementState extends State<AePSFinoMiniStatement> {
  List<Passbook> passbook = [];

  final GlobalKey<State<StatefulWidget>> _printKey = GlobalKey();

  var screen = "Mini Statement";

  var response;

  var isPassbookShow = false;

  var loading = false;

  var balanceamount = "";
  var ackno = "";
  var bankrrn = "";
  var message = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      loading = true;
    });
    setPassbookData();
  }

  setPassbookData() async {
    setState(() {
      response = widget.response;

      //var data = json.decode(response);
      var data = response;

      printMessage(screen, "Response : ${data}");

      if (data['response']['ministatement'].toString() == "null") {
        setState(() {
          isPassbookShow = false;
        });
      } else {
        setState(() {
          isPassbookShow = true;
        });
        var result = data['response']['ministatement'];

        balanceamount = data['response']['balanceamount'].toString();
        ackno = data['response']['ackno'].toString();
        bankrrn = data['response']['bankrrn'].toString();
        message = data['response']['message'].toString();

        if (result.length != 0) {
          for (int i = 0; i < result.length; i++) {
            var date = result[i]['date'];
            var txnType = result[i]['txnType'];
            var amount = result[i]['amount'];
            var narration = result[i]['narration'];

            Passbook p = new Passbook(
                date: date,
                txnType: txnType,
                amount: amount,
                narration: narration);

            passbook.add(p);
          }
        }

        printMessage(screen, "Pass book length : ${passbook.length}");
      }
    });

    setState(() {
      loading = false;
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
            body: (loading)
                ? Center(
                    child: circularProgressLoading(40.0),
                  )
                : RepaintBoundary(
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
                                        "Available Balance : $rupeeSymbol $balanceamount",
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
                                              "Ref Id: $ackno",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: font14),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Txn Id: $bankrrn",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: font14),
                                              textAlign: TextAlign.end,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    Divider(),
                                    _buildHeaderSection(),
                                    _buildPassbook(),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 25.0, right: 25),
                                      child: Row(
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Text(
                                              "Bank Msg : $message",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: font14),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : NoDataFound(text: "")))));
  }

  _buildPassbook1() {
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
                                "${passbook[index].date.toString()}",
                                style:
                                    TextStyle(color: black, fontSize: font12),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(0.0),
                              child: Text(
                                "${passbook[index].narration.toString()}",
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
                        "$rupeeSymbol ${passbook[index].amount.toString()} (${passbook[index].txnType.toString()})",
                        style: TextStyle(
                            color: (passbook[index]
                                        .txnType
                                        .toString()
                                        .toLowerCase() ==
                                    "cr")
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
                        flex: 2,
                        child: Text(
                          "${passbook[index].date}",
                          style: TextStyle(
                              color: black, fontSize: font14, fontWeight: FontWeight.normal),
                        )),
                    Expanded(
                        flex: 3,
                        child: Text(
                          "${passbook[index].narration}",
                          style: TextStyle(
                              color: black, fontSize: font14, fontWeight: FontWeight.normal),
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "$rupeeSymbol ${passbook[index].amount}",
                          style: TextStyle(
                              color: black, fontSize: font14, fontWeight: FontWeight.normal),
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "${passbook[index].txnType}",
                          style: TextStyle(
                              color: (passbook[index]
                                  .txnType
                                  .toString()
                                  .toLowerCase() ==
                                  "cr")
                                  ? green
                                  : red, fontSize: font14, fontWeight: FontWeight.normal),
                          textAlign: TextAlign.end,
                        )),
                    SizedBox(
                      width: 20,
                    ),
                  ],
                ),
                Divider(),
              ],
            ),
          );
        });
  }

  _buildHeaderSection() {
    return Container(
      color: lightBlue,
      margin: EdgeInsets.only(left: 20, right: 20),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: [
            SizedBox(
              width: 10,
            ),
            Expanded(
              flex: 2,
                child: Text(
              "Date",
              style: TextStyle(
                  color: white, fontSize: font14, fontWeight: FontWeight.bold),
            )),
            Expanded(
                flex: 3,
                child: Text(
              "Description",
              style: TextStyle(
                  color: white, fontSize: font14, fontWeight: FontWeight.bold),
            )),
            Expanded(
                flex: 1,
                child: Text(
              "Amount",
              style: TextStyle(
                  color: white, fontSize: font14, fontWeight: FontWeight.bold),
            )),
            Expanded(
                flex: 1,
                child: Text(
              "CR/DR",
              style: TextStyle(
                  color: white, fontSize: font14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.end,
            )),
            SizedBox(
              width: 20,
            ),
          ],
        ),
      ),
    );
  }
}
