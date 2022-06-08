import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'package:moneypro_new/utils/StateContainer.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:moneypro_new/utils/AppKeys.dart';


class DMTLanding extends StatefulWidget {
  const DMTLanding({Key? key}) : super(key: key);

  @override
  _DMTLandingState createState() => _DMTLandingState();
}

class _DMTLandingState extends State<DMTLanding> {
  var screen = "DMT landing";

  final searchController = new TextEditingController();

  final phoneController = new TextEditingController();

  var searchLoading = false;

  var isSearchCalled = false;

  Map customerDetail = {};

  @override
  void initState() {
    super.initState();
    getToken();
    updateATMStatus(context);
    updateWalletBalances();
    fetchUserAccountBalance();
  }



  updateWalletBalances() async{
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
  }

  @override
  void dispose() {
    searchController.dispose();
    phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final InheritedWidget = StateContainer.of(context);
    var moneyProBalc = InheritedWidget.mpBalc;
    var mproBalc = InheritedWidget.qrBalc;
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: AppBar(
        elevation: 0,
        centerTitle: false,
        backgroundColor: white,
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
          InkWell(
              onTap: (){
                //openYoutubeVdoPlayer(context,"a3bGXDRTw_Q");
              },
              child: Container(
                  height: 30.h,
                  margin: EdgeInsets.only(top: 14, left: 10, right: 10, bottom: 14),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)), border: Border.all(color: black)
                  ),
                  child: Row(
                    children: [
                      SizedBox(width: 10.w,),
                      Image.asset('assets/ic_youtube.png', width: 20.w,),
                      SizedBox(width: 4.w,),
                      Text("HELP VIDEOS", style: TextStyle(
                          color: black, fontSize: font12.sp
                      ),),
                      SizedBox(width: 10.w,),
                    ],
                  ))),
          Container(
            margin: EdgeInsets.all(10),
            decoration: BoxDecoration(
                color: walletBg,
                borderRadius: BorderRadius.all(Radius.circular(10)),
                border: Border.all(color: walletBg)),
            child: Padding(
              padding: const EdgeInsets.only(left: 10.0, top: 5, bottom: 5),
              child: Wrap(
                direction: Axis.horizontal,
                children: [
                  Image.asset(
                    "assets/wallet.png",
                    height: 20.h,
                  ),
                  Center(
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 10.0, right: 10, top: 5),
                      child: Text(
                        moneyProBalc,
                        style: TextStyle(color: white, fontSize: font15.sp),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
          body: Column(
            children: [
              Card(
                margin: EdgeInsets.only(left: 10, right: 10, top: 8),
                elevation: 10,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(15.0),
                    child: Image.asset(
                      "assets/banner_1.png",
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              Container(
                width: MediaQuery.of(context).size.width,

                margin: EdgeInsets.only(top: 30),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                      top: Radius.circular(50.0)),
                  color: white,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 10,
                      blurRadius: 10,
                      offset: Offset(
                          0, 1),
                    ),
                  ],
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(height: 20.h,),
                      Container(
                        height: 4.h,
                        width: 50.w,
                        color: gray,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                        child: Row(
                          children: [
                            Text(
                              moneyProDMT,
                              style: TextStyle(
                                  color: black,
                                  fontWeight: FontWeight.bold,
                                  fontSize: font16.sp),
                            ),
                            Spacer(),
                            Text(
                              howToUser,
                              style: TextStyle(
                                  color: orange,
                                  fontWeight: FontWeight.bold,
                                  fontSize: font16.sp),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 20),
                        child: Row(
                          children: [
                            Expanded(
                              flex:1,
                              child: InkWell(
                                onTap: (){
                                  openFavouriteBeneficiary(context);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 0, right: 0, left: 0),
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                      color: lightBlue,
                                      borderRadius: BorderRadius.all(Radius.circular(25)),
                                      border: Border.all(color: lightBlue)),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset('assets/dmtfavourite.png', height: 20.h,),
                                        SizedBox(width: 10.w,),
                                        Text(favourites,style: TextStyle(
                                            color: white,
                                            fontSize: font14.sp
                                        ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ),
                            SizedBox(width: 20.w,),
                            Expanded(
                              flex:1,
                              child: InkWell(
                                onTap: (){
                                  openDLTTransactions(context);
                                },
                                child: Container(
                                  width: MediaQuery.of(context).size.width,
                                  margin: EdgeInsets.only(top: 0, right: 0, left: 0),
                                  height: 50.h,
                                  decoration: BoxDecoration(
                                      color: dividerSplash,
                                      borderRadius: BorderRadius.all(Radius.circular(25)),
                                      border: Border.all(color: lightBlue)),
                                  child: Center(
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Image.asset('assets/dmtTrans.png', height: 20.h,),
                                        SizedBox(width: 10.w,),
                                        Text(transactions,style: TextStyle(
                                            color: lightBlue,
                                            fontSize: font14.sp
                                        ),)
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ),
                          ],
                        ),
                      ),
                      _buildSearchSection(),
                      _buildSearchResult(),
                      SizedBox(height: 20.h,)

                    ],
                  ),
                ),
              ),
            ],
          ),
          bottomNavigationBar: _buildButtonSection(),

    )));
  }

  _buildSearchSection() {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.only(top: 20, left: 15, right: 15),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(30)),
          border: Border.all(color: dividerSplash)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Icon(
              Icons.search,
            ),
          ),
          SizedBox(width: 4.w,),
          Expanded(
            flex: 1,
            child: TextFormField(
              textAlign: TextAlign.start,
              style: TextStyle(color: black, fontSize: inputFont.sp),
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              controller: searchController,
              decoration: new InputDecoration(
                border: InputBorder.none,
                counterText: "",
                floatingLabelBehavior: FloatingLabelBehavior.never,
                hintText: searchSender,
                hintStyle: TextStyle(
                  color: lightBlack,
                ),
              ),
              maxLength: 10,
              onFieldSubmitted: (val) {
                printMessage(screen, "Search Text : $val");
                searchSenderTask(val);
              },
            ),
          ),
          (searchLoading)
              ? Padding(
            padding: const EdgeInsets.only(right: 8.0),
            child: circularProgressLoading(20.0),
          )
              : Container(),
        ],
      ),
    );
  }

  _buildSearchResult(){
    return
      (isSearchCalled)
          ? InkWell(
        onTap: (){
          openBeneficiaryDetail(
              context,
              customerDetail['customer_id'].toString(),
              customerDetail['customer_name'].toString(),
              customerDetail['mobile'].toString());
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
                  width: 10.w,
                ),
                Container(
                    height: 36.h,
                    width: 36.w,
                    decoration: BoxDecoration(
                      color: invBoxBg,
                      shape: BoxShape.circle,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/user.png',
                        color: lightBlue,
                      ),
                    )),
                SizedBox(width: 10.w,),
                Expanded(
                    flex: 1,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 10.h,),
                        Text(
                          "${ customerDetail['customer_name'].toString()}",
                          style: TextStyle(
                              color: black, fontSize: font15.sp),
                          textAlign: TextAlign.start,
                        ),
                        Text(
                          "${ customerDetail['mobile'].toString()}",
                          style: TextStyle(color: lightBlack, fontSize: font13.sp),
                        ),
                        SizedBox(height: 10.h,),
                      ],
                    )),
                Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: black,
                  size: 16,
                ),
                SizedBox(
                  width: 15.w,
                ),
              ],
            ),
          ),
        ),
      ):Container();
  }

  _buildButtonSection() {
    return InkWell(
      onTap: () {
        _showAddSenderDialog();
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 0, left: 14, right: 15, bottom: 10),
        height: 50.h,
        decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(30)),
            border: Border.all(color: lightBlue)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  border: Border.all(color: white)),
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8, top: 4, bottom: 4),
                child: Text("+", style: TextStyle(
                  color: white
                ),),
              ),
            ),
            SizedBox(
              width: 10.w,
            ),
            Text(
              addASender,
              style: TextStyle(color: white, fontSize: font16.sp),
            )
          ],
        ),
      ),
    );
  }

  Future searchSenderTask(phone) async {
    setState(() {
      searchLoading = true;
    });

    var mechantId = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "m_id": mechantId,
      "phone": phone,
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(searchCustomerAPI),
        body: jsonEncode(body), headers: headers);
    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "IFSC Code : $data");

      setState(() {
        searchLoading = false;
        if (data['status'].toString() == "2") {
          showToastMessage(data['message'].toString());
          isSearchCalled = false;
        }
        if (data['status'].toString() == "1") {
          isSearchCalled = true;

          customerDetail['customer_id'] =
              data['customer']['customer_id'].toString();
          customerDetail['customer_name'] =
              data['customer']['customer_name'].toString();
          customerDetail['mobile'] = data['customer']['mobile'].toString();
          customerDetail['duration'] = data['customer']['duration'].toString();
          customerDetail['limit'] = data['customer']['limit'].toString();
          customerDetail['kyc'] = data['customer']['kyc'].toString();
        }
      });
    }else{
      setState(() {
        searchLoading = false;
      });
      showToastMessage(status500);
    }


  }

  _showAddSenderDialog() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Container(
          margin: EdgeInsets.only(left: 20, right: 20),
          child: Center(
            child: Container(
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: white,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                  border: Border.all(color: white, width: 2.w)),
              child: Wrap(
                children: [
                  Column(
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 40.0, bottom: 20),
                          child: Image.asset(
                            'assets/addInvestor.png',
                            height: 120.h,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Text(
                          "Add new sender",
                          style: TextStyle(
                              color: black,
                              fontSize: font18.sp,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(
                        height: 10.h,
                      ),
                      Container(
                        height: 45.h,
                        margin: EdgeInsets.only(
                            top: 15, left: padding, right: padding),
                        decoration: BoxDecoration(
                          color: editBg,
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Center(
                          child: TextFormField(
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.phone,
                            textCapitalization: TextCapitalization.characters,
                            textInputAction: TextInputAction.next,
                            controller: phoneController,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              counterText: "",
                              label: Text("Enter mobile number"),
                            ),
                            maxLength: 10,
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
                        child: Card(
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                          child: InkWell(
                            onTap: () {

                              var mobileNumber = phoneController.text.toString();

                              if (mobileNumber.length == 0) {
                                showToastMessage("Please enter Mobile Number");
                                return;
                              } else if (mobileNumber.length != 10) {
                                showToastMessage("Mobile number must 10 digits");
                                return;
                              } else if (!mobilePattern.hasMatch(mobileNumber)) {
                                showToastMessage(
                                    "Please enter valid Mobile Number");
                                return;
                              }
                              openAddSender(context, mobileNumber);

                            },
                            child: Container(
                              height: 40.h,
                              decoration: BoxDecoration(
                                  color: lightBlue,
                                  borderRadius:
                                  BorderRadius.all(Radius.circular(30)),
                                  border: Border.all(
                                      color: lightBlue, width: 1.w)),
                              child: Padding(
                                padding: const EdgeInsets.only(left: 30.0, right: 30),
                                child: Center(
                                  child: Text(
                                    "Proceed",
                                    style: TextStyle(
                                        color: white, fontSize: font15.sp),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(height: 20.h,)
                    ],
                  ),

                ],
              ),
            ),
          ),
        ));
  }
}
