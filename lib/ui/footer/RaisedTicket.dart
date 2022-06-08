import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class RaisedTicket extends StatefulWidget {
  final String txnId;
  final String amount;
  final String txnStatus;
  final String mode;
  final String opName;
  final String category;
  final String pgAmt;

  const RaisedTicket(
      {Key? key,
      required this.txnId,
      required this.amount,
      required this.txnStatus,
      required this.mode,
      required this.opName,
      required this.category,
      required this.pgAmt})
      : super(key: key);

  @override
  _RaisedTicketState createState() => _RaisedTicketState();
}

class _RaisedTicketState extends State<RaisedTicket> {
  var screen = "Raised Ticket";

  final msgController = TextEditingController();

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
  }

  @override
  void dispose() {
    msgController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(
        context,
        "assets/bbpslogo.png",
        70.0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            appSelectedBanner(context, "recharge_banner.png", 150.0),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 20, right: 20, bottom: 10),
              child: Row(
                children: [
                  Text(
                    transactionId,
                    style: TextStyle(color: black, fontSize: font16),
                  ),
                  Spacer(),
                  Text(
                    "${widget.txnId}",
                    style: TextStyle(color: black, fontSize: font16),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10, right: 20, bottom: 10),
              child: Row(
                children: [
                  Text(
                    "Amount",
                    style: TextStyle(color: black, fontSize: font16),
                  ),
                  Spacer(),
                  Text(
                    "$rupeeSymbol ${widget.amount}",
                    style: TextStyle(color: black, fontSize: font16),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10, right: 20, bottom: 10),
              child: Row(
                children: [
                  Text(
                    "Payment Mode",
                    style: TextStyle(color: black, fontSize: font16),
                  ),
                  Spacer(),
                  Text(
                    "${widget.mode}",
                    style: TextStyle(color: black, fontSize: font16),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10, right: 20, bottom: 10),
              child: Row(
                children: [
                  Text(
                    "Category",
                    style: TextStyle(color: black, fontSize: font16),
                  ),
                  Spacer(),
                  Text(
                    "${widget.category}",
                    style: TextStyle(color: black, fontSize: font16),
                  )
                ],
              ),
            ),
            Divider(),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20.0, top: 10, right: 20, bottom: 10),
              child: Row(
                children: [
                  Text(
                    "Operator Name",
                    style: TextStyle(color: black, fontSize: font16),
                  ),
                  Spacer(),
                  Text(
                    "${widget.opName}",
                    style: TextStyle(color: black, fontSize: font16),
                  )
                ],
              ),
            ),
            _buildMessageSection()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        height: 60,
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            InkWell(
              onTap: () {
                var text = msgController.text.toString();

                if (text == "") {
                  showToastMessage("enter description");
                  return;
                }

                printMessage(screen, "Discripition : $text");

                submitQuery(text);
              },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(top: 0, left: 30, right: 30, bottom: 10),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    submit.toUpperCase(),
                    style: TextStyle(fontSize: font15, color: white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ));
  }

  _buildMessageSection() {
    return Container(
      height: 90,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
      decoration: BoxDecoration(
          color: boxBg,
          borderRadius: BorderRadius.all(Radius.circular(20)),
          border: Border.all(color: boxBg)),
      child: TextFormField(
        style: TextStyle(color: lightBlue, fontSize: font15),
        keyboardType: TextInputType.multiline,
        textInputAction: TextInputAction.newline,
        textCapitalization: TextCapitalization.characters,
        controller: msgController,
        decoration: new InputDecoration(
          border: InputBorder.none,
          hintText: "enter description here",
          hintStyle: TextStyle(color: lightBlue),
          contentPadding: EdgeInsets.only(left: 20),
          counterText: "",
        ),
        maxLength: 200,
      ),
    );
  }

  Future submitQuery(text) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "token": token,
      "complain_type": "${widget.opName}",
      "txnid": "${widget.txnId}",
      "amount": "${widget.amount}",
      "payment_mode": "${widget.mode}",
      "category": "${widget.category}",
      "txn_status": "${widget.txnStatus}",
      "description": "$text",
      "payment_amount": "${widget.pgAmt}",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(bbpsComplainAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Transaction : $data");

      setState(() {
        Navigator.pop(context);

        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
          closeCurrentPage(context);
        } else {
          showToastMessage(data['message'].toString());
        }
      });
    } else {
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }
  }
}
