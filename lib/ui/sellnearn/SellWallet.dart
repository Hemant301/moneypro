import 'package:dotted_line/dotted_line.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/Constants.dart';
import '../../utils/CustomWidgets.dart';
import '../../utils/Functions.dart';

class SellWallet extends StatefulWidget {
  const SellWallet({Key? key}) : super(key: key);

  @override
  State<SellWallet> createState() => _SellWalletState();
}

class _SellWalletState extends State<SellWallet> {


  int selectedIndex = 1;

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
                child: Scaffold(
              appBar: appBarHome(context, "", 24.0.w),
              backgroundColor: boxBg,
                  body: SingleChildScrollView(
                    child: Column(
                      children: [
                        _buildWalletSection(),
                        Container(
                          margin: EdgeInsets.only(top: 15),
                          color: white,
                          width: MediaQuery.of(context).size.width,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20, bottom: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: RichText(
                                    text: TextSpan(
                                      children:[
                                        TextSpan(
                                          text: "Get payout in ",
                                          style: TextStyle(
                                            color: black,
                                            fontSize: font14.sp
                                          )
                                        ),
                                        TextSpan(
                                            text: "PayTm or Bank Account ",
                                            style: TextStyle(
                                                color: black,
                                                fontSize: font14.sp,
                                              fontWeight: FontWeight.bold
                                            )
                                        ),
                                        TextSpan(
                                            text: "in quickest time.",
                                            style: TextStyle(
                                                color: black,
                                                fontSize: font14.sp
                                            )
                                        ),
                                      ]
                                    ),
                                  ),
                                ),
                                InkWell(
                                  onTap: () {
                                    setState(() {
                                      openSellLeads(context);
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                                    decoration: BoxDecoration(
                                      color: lightBlue,
                                      borderRadius: BorderRadius.all(Radius.circular(25)),
                                    ),
                                    child: Center(
                                      child: Padding(
                                        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 8, bottom: 8),
                                        child: Text(
                                          "ADD LEAD NOW",
                                          style: TextStyle(fontSize: font16.sp, color: white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Row(
                          children: [
                            SizedBox(
                              width: 20.w,
                            ),
                            Expanded(
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = 1;
                                        });

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Payout",
                                          style: TextStyle(
                                              color: (selectedIndex == 1) ? lightBlue : black,
                                              fontSize: font15.sp,
                                              fontWeight: (selectedIndex == 1)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: (selectedIndex == 1) ? lightBlue : boxBg,
                                      thickness: 3,
                                    ),
                                  ],
                                )),
                            Expanded(
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = 2;
                                        });

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "Referral",
                                          style: TextStyle(
                                              color: (selectedIndex == 2) ? lightBlue : black,
                                              fontSize: font15.sp,
                                              fontWeight: (selectedIndex == 2)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: (selectedIndex == 2) ? lightBlue : boxBg,
                                      thickness: 3,
                                    ),
                                  ],
                                )),
                            Expanded(
                                child: Column(
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          selectedIndex = 3;
                                        });

                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          "History",
                                          style: TextStyle(
                                              color: (selectedIndex == 3) ? lightBlue : black,
                                              fontSize: font15.sp,
                                              fontWeight: (selectedIndex == 3)
                                                  ? FontWeight.bold
                                                  : FontWeight.normal),
                                        ),
                                      ),
                                    ),
                                    Divider(
                                      color: (selectedIndex == 3) ? lightBlue : boxBg,
                                      thickness: 3,
                                    ),
                                  ],
                                )),
                            SizedBox(
                              width: 20.w,
                            ),
                          ],
                        ),
                        (selectedIndex==1)?_buildBox1(bankBox):Container(),
                        (selectedIndex==2)?_buildBox1(arrowBoxBg):Container(),
                        (selectedIndex==3)?_buildBox1(gray):Container(),
                      ],
                    ),
                  ),
            )));
  }

  _buildWalletSection() {
    return Container(
      margin: EdgeInsets.only(left: 15, right: 15, top: 20),
      decoration: BoxDecoration(
        color: white,
        borderRadius: BorderRadius.all(Radius.circular(15)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 15.h,
          ),// 200963597
          Row(
            children: [
              SizedBox(
                width: 15.w,
              ),
              Expanded(
                  flex:1,
                  child: Row(
                children: [
                  Container(
                      height: 45.h,
                      width: 45.w,
                      decoration: BoxDecoration(
                        color: gray, // border color
                        shape: BoxShape.circle,
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Image.asset(
                          'assets/wallet_blue.png',
                          color: lightBlue,
                        ),
                      )),
                  SizedBox(
                    width: 10.w,
                  ),
                  InkWell(
                    onTap: (){

                    },
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "BALANCE",
                          style: TextStyle(color: lightBlack, fontSize: font14.sp),
                        ),
                        SizedBox(height: 3.h,),
                        Text("0.00",
                            style: TextStyle(
                                color: Colors.black,
                                fontSize: font22.sp,
                                fontWeight: FontWeight.bold)),
                      ],
                    ),
                  ),
                ],
              )),
              Expanded(
                  flex:1,
                  child: Row(
                    children: [
                      Container(
                          height: 45.h,
                          width: 45.w,
                          decoration: BoxDecoration(
                            color: gray, // border color
                            shape: BoxShape.circle,
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Image.asset(
                              'assets/transfer_rupee.png',
                              color: lightBlue,
                            ),
                          )),
                      SizedBox(
                        width: 10.w,
                      ),
                      InkWell(
                        onTap: (){

                        },
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "TOTAL EARNING",
                              style: TextStyle(color: lightBlack, fontSize: font14.sp),
                            ),
                            SizedBox(height: 3.h,),
                            Text("0.00",
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: font22.sp,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    ],
                  )),
            ],
          ),

          SizedBox(
            height: 15.h,
          ),
        ],
      ),
    );
  }

  _buildBox1(color){
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: color,
    );
  }
}
