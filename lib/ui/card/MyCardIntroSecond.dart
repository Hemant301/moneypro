import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class MyCardIntroSecond extends StatefulWidget {
  const MyCardIntroSecond({Key? key}) : super(key: key);

  @override
  _MyCardIntroSecondState createState() => _MyCardIntroSecondState();
}

class _MyCardIntroSecondState extends State<MyCardIntroSecond> {


  var screen  ="My Card Second";

  var role = "";

  @override
  void initState() {
    super.initState();
    getUserDetails();
  }

  getUserDetails()async{
    var r = await getRole();

    setState(() {
      role =r;
    });
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(child: Scaffold(
      backgroundColor: white,
      body: Stack(
        children: [
          Container(
            height: 180,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              borderRadius:
              BorderRadius.vertical(bottom: Radius.circular(20.0)),
              color: lightBlue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, top: 15),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          closeKeyBoard(context);
                          closeCurrentPage(context);
                        },
                        child: Icon(
                          Icons.arrow_back,
                          color: white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SingleChildScrollView(
            child: Column(
              children: [
                Card(
                  margin: EdgeInsets.only(left: 20, right: 20, top: 100),
                  elevation: 10,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        "assets/card_banner.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
                  child: Row(
                    children: [
                      Image.asset('assets/card_green.png', height: 50,),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Card with credit limit at 0% interest rate",
                              style: TextStyle(
                                color: black,
                                fontSize: font16,
                                fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "Get instant money at 0% interest & use for shopping or paying bills",
                              style: TextStyle(
                                  color: lightBlack,
                                  fontSize: font14,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
                  child: Row(
                    children: [
                      Image.asset('assets/card_green.png', height: 50,),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Pay back in 3 easy payments",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "Use money as per needs & payback in 3 easy interest free payments.",
                              style: TextStyle(
                                color: lightBlack,
                                fontSize: font14,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 40),
                  child: Row(
                    children: [
                      Image.asset('assets/card_green.png', height: 50,),
                      SizedBox(width: 10,),
                      Expanded(
                        flex: 1,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "1% Cashback on all transactions",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16,
                                  fontWeight: FontWeight.bold
                              ),
                            ),
                            SizedBox(height: 5,),
                            Text(
                              "Enjoy instant cashbacks on all spends",
                              style: TextStyle(
                                color: lightBlack,
                                fontSize: font14,
                              ),
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
      bottomNavigationBar: InkWell(
        onTap: () {
          openMyCardMobileVerify(context);
        },
        child: Container(
          height: 45,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 10, left: 25, right: 25, bottom: 10),
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Center(
            child: Text(
              "$continue_".toUpperCase(),
              style: TextStyle(fontSize: font16, color: white),
            ),
          ),
        ),
      ),
    ));
  }
}
