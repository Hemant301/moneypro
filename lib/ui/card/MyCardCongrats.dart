import 'package:flutter/material.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Functions.dart';

class MyCardCongrats extends StatefulWidget {
  const MyCardCongrats({Key? key}) : super(key: key);

  @override
  _MyCardCongratsState createState() => _MyCardCongratsState();
}

class _MyCardCongratsState extends State<MyCardCongrats> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      backgroundColor: white,
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Container(
              height: 260,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.vertical(bottom: Radius.circular(50.0)),
                color: lightBlue,
              ),
              child: Column(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 15.0, right: 15, top: 25),
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
                  Column(
                    children: [
                      Text(
                        "Congratulations!",
                        style: TextStyle(
                            color: white,
                            fontSize: font26,
                            fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "You are approved for OneCard Lite!",
                        style: TextStyle(color: white, fontSize: font20),
                      )
                    ],
                  )
                ],
              ),
            ),
            Column(
              children: [
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 130.0),
                    child: Image.asset(
                      'assets/dualcard.png',
                      height: 260,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Row(
                  children: [
                    SizedBox(width: 20,),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Image.asset('assets/swipe_store.png', height: 54,),
                          Text(
                            "Swipe at store",
                            style:
                                TextStyle(color: lightBlue, fontSize: font16),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Image.asset('assets/pay_online.png', height: 54,),
                          Text(
                            "Pay online",
                            style:
                            TextStyle(color: lightBlue, fontSize: font16),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        children: [
                          Image.asset('assets/atm_withd.png', height: 54,),
                          Text(
                            "ATM withdrawal",
                            style:
                            TextStyle(color: lightBlue, fontSize: font16),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 20,),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                  child: Row(
                    children: [
                      Image.asset('assets/openfd.png'),
                      SizedBox(width: 10,),
                      Expanded(child: Text("Open a FD & get an assured Credit Card with 110% Credit Limit",
                      style: TextStyle(
                        color: black,
                        fontSize: font16
                      ),)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                  child: Row(
                    children: [
                      Image.asset('assets/fixedd.png'),
                      SizedBox(width: 10,),
                      Expanded(child: Text("Fixed Deposit at 6.5% with RBI regulated SBM Bank",
                        style: TextStyle(
                            color: black,
                            fontSize: font16
                        ),)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                  child: Row(
                    children: [
                      Image.asset('assets/cardfuture.png'),
                      SizedBox(width: 10,),
                      Expanded(child: Text("Build your credit score to get loans & credit cards in the future",
                        style: TextStyle(
                            color: black,
                            fontSize: font16
                        ),)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
                  child: Row(
                    children: [
                      Image.asset('assets/rewardscard.png'),
                      SizedBox(width: 10,),
                      Expanded(child: Text("Backed by a Powerful App, Exciting Rewards",
                        style: TextStyle(
                            color: black,
                            fontSize: font16
                        ),)),
                    ],
                  ),
                ),
              ],
            )
          ],
        ),
      ),
          bottomNavigationBar: InkWell(
            onTap: () {
             // openMyCardCongrats(context);
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
                  "Get OneCard Lite now!",
                  style: TextStyle(fontSize: font16, color: white),
                ),
              ),
            ),
          ),
    ));
  }
}
