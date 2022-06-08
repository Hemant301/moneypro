import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class WalletRecipt extends StatefulWidget {
  final Map map;

  const WalletRecipt({Key? key, required this.map}) : super(key: key);

  @override
  _WalletReciptState createState() => _WalletReciptState();
}

class _WalletReciptState extends State<WalletRecipt> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          backgroundColor: white,
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
      ),
          body: Column(
            children: [
              SizedBox(
                height: 30,
              ),
              Center(
                child: CircleAvatar(
                  backgroundColor: Colors.transparent,
                  radius: 40,
                  child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(40)),
                      child:
                      (widget.map['txnStatus'].toString().toLowerCase() == "success")?
                      Image.asset("assets/pin_alert.png")
                          : Image.asset("assets/failed.png")),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text(
                "Transaction ${widget.map['txnStatus']}",
                style: TextStyle(
                    color: black,
                    fontSize: 22,
                    fontWeight: FontWeight.w600),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                "$rupeeSymbol ${widget.map['txn_amnt'].toString()}",
                style: TextStyle(fontSize: font18, color: black),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 30,),
              Expanded(
                child: Container(

                  decoration: BoxDecoration(
                    borderRadius:
                    BorderRadius.vertical(top: Radius.circular(50.0)),
                    color: white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 10,
                        blurRadius: 10,
                        offset: Offset(0, 1), // changes position of shadow
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      Center(
                        child: Container(
                          color: gray,
                          width: 50,
                          height: 5,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 20.0, right: 30, left: 30),
                        child: Row(
                          children: [
                            Text(
                              "Date",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font13),
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              flex: 1,
                              child: Text(
                                "${widget.map['date']}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 25.0, right: 30, left: 30),
                        child: Row(
                          children: [
                            Text(
                              "Txn Type",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font13),
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              flex:1,
                              child: Text(
                                "${widget.map['type']}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 25.0, right: 30, left: 30),
                        child: Row(
                          children: [
                            Text(
                              "$transId",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font13),
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              flex:1,
                              child: Text(
                                "${widget.map['transId']}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 25.0, right: 30, left: 30),
                        child: Row(
                          children: [
                            Text(
                              "Remarks",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font13),
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              flex:1,
                              child: Text(
                                "${widget.map['heading']}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 25.0, right: 30, left: 30),
                        child: Row(
                          children: [
                            Text(
                              "Description",
                              style: TextStyle(
                                  color: lightBlack, fontSize: font13),
                            ),
                            SizedBox(width: 20,),
                            Expanded(
                              flex:1,
                              child: Text(
                                "${widget.map['description']}",
                                style: TextStyle(
                                    color: black,
                                    fontSize: font13,
                                    fontWeight: FontWeight.bold),
                                textAlign: TextAlign.end,
                              ),
                            )
                          ],
                        ),
                      ),


                      Container(
                        margin: EdgeInsets.only(left: 15, right: 15, bottom: 10,top: 20),
                        child: Image.asset(
                          'assets/wallet_banner.png',
                        ),
                      ),
                      Divider(
                        color: gray,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, top: 20),
                        child: Row(
                          children: [
                            Text(
                              "$customerCare",
                              style:
                              TextStyle(color: black, fontSize: font14),
                            ),
                            Spacer(),
                            Text(
                              "$merchantMob",
                              style: TextStyle(
                                  color: black, fontSize: font14),
                            )
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 15.0, right: 15, top: 5, bottom: 10),
                        child: Row(
                          children: [
                            Text(
                              "$customerEmail",
                              style: TextStyle(
                                  color: lightBlue, fontSize: font14),
                            ),
                            Spacer(),
                            Text(
                              "$mobileChar",
                              style: TextStyle(
                                  color: lightBlue, fontSize: font14),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
    ));
  }
}
