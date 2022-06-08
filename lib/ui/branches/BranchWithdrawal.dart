import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/AppKeys.dart';


class BranchWithdrawal extends StatefulWidget {
  final String ablAmt, qrId, branchName, mobile, photo;
  final int branchId;
  final bool isManagerShow;

  const BranchWithdrawal(
      {Key? key,
      required this.ablAmt,
      required this.qrId,
      required this.branchId,
      required this.branchName,
      required this.mobile,
      required this.photo,
      required this.isManagerShow})
      : super(key: key);

  @override
  _BranchWithdrawalState createState() => _BranchWithdrawalState();
}

class _BranchWithdrawalState extends State<BranchWithdrawal> {

  var screen = "Branch Withdrwl";

  var loading = false;

  TextEditingController amountController = new TextEditingController();

  var maxAmt;

  @override
  void initState() {
    super.initState();
    getMaxWithdrlAmt();
  }

  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
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
          Image.asset(
            'assets/faq.png',
            width: 24.w,
            color: orange,
          ),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
      body: (loading)
          ? Center(
              child: circularProgressLoading(40.0),
            )
          : SingleChildScrollView(
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(15.0),
                      child: Image.asset(
                        "assets/merchant_branch.png",
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20.h,
                  ),
                  Card(
                    margin: EdgeInsets.all(15),
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Padding(
                      padding: EdgeInsets.only(
                          top: 20, left: padding, right: padding, bottom: 20),
                      child: Container(
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                (widget.photo.toString() == "" ||
                                        widget.photo.toString() == "null")
                                    ? Image.asset(
                                        'assets/ic_branch_office.png',
                                        height: 30.h,
                                      )
                                    : SizedBox(
                                        width: 36.w,
                                        height: 36.h,
                                        child: Image.network(
                                          "$branchImgUrl${widget.photo.toString()}",
                                        ),
                                      ),
                                SizedBox(
                                  width: 10.w,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.branchName}",
                                        style: TextStyle(
                                            color: black,
                                            fontSize: font16.sp,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        "${widget.mobile}",
                                        style: TextStyle(
                                            color: lightBlack,
                                            fontSize: font14.sp,
                                            fontWeight: FontWeight.normal),
                                      ),
                                      SizedBox(
                                        height: 4.h,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  width: 10.w,
                                ),
                              ],
                            ),
                            Container(
                              height: 50.h,
                              width: MediaQuery.of(context).size.width,
                              margin: EdgeInsets.only(
                                  top: 15, left: 10, right: 10),
                              decoration: BoxDecoration(
                                color: editBg,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(30)),
                              ),
                              child: Center(
                                child: TextFormField(
                                  style: TextStyle(
                                      color: black, fontSize: 14.sp),
                                  keyboardType: TextInputType.number,
                                  textCapitalization:
                                      TextCapitalization.characters,
                                  textInputAction: TextInputAction.next,
                                  controller: amountController,
                                  decoration: new InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 20),
                                    counterText: "",
                                    label: Text("enter amount"),
                                  ),
                                  maxLength: 7,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: Text("Maximum amount you can withdarwal is $rupeeSymbol $maxAmt",
                              style: TextStyle(fontSize: font12.sp),),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ])),
      bottomNavigationBar: _buildButton(),
    )));
  }

  _buildButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
      child: InkWell(
        onTap: () {
          var amount = amountController.text.toString();

          if (amount.length == 0) {
            showToastMessage("enter mount");
            return;
          }
          double x = double.parse(amount);
          if (x <= 0) {
            showToastMessage("enter mount");
            return;
          }

          if (x >maxAmt) {
            showToastMessage("Maximum withdarwal amount is $rupeeSymbol $maxAmt");
            //return;
          }

          closeKeyBoard(context);
          withdrawalRequest(amount,widget.qrId, widget.branchId);
        },
        child: Container(
          height: 45.h,
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
          decoration: BoxDecoration(
            color: lightBlue,
            borderRadius: BorderRadius.all(Radius.circular(25)),
          ),
          child: Center(
            child: Text(
              "Withdrawal Money".toUpperCase(),
              style: TextStyle(fontSize: font14.sp, color: white),
            ),
          ),
        ),
      ),
    );
  }

  Future withdrawalRequest(amount, qrId, branchId) async {
    setState(() {
      showDialog(
          barrierDismissible: false,
          context: context,
          builder: (BuildContext context) {
            return CustomAppDialog(message: pleaseWait);
          });
    });

    var token = await getToken();
    var mId = await getMerchantID();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "user_token": token,
      "m_id": "$mId",
      "amount": "$amount",
      "qr_id": "$qrId",
      "branch_id": "$branchId"
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(branchQrWithdrawlReqAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Branch : $data");

      setState(() {
        Navigator.pop(context);
        if (data['status'].toString() == "1") {
          showToastMessage(data['message'].toString());
          removeAllPages(context);
          openMerchantBranch(context, widget.isManagerShow);
        }else{
          showToastMessage(data['message'].toString());
        }
      });
    }else{
      setState(() {
        Navigator.pop(context);
      });
      showToastMessage(status500);
    }


  }

  Future getMaxWithdrlAmt() async {
    setState(() {
      loading = true;
    });

    var token = await getToken();

    var headers = {
      "Content-Type": "application/json",
      "Authorization": "$authHeader",
    };

    final body = {
      "branch_id": "${widget.branchId}",
    };

    printMessage(screen, "body : $body");

    final response = await http.post(Uri.parse(singleBranchMaxWithdrawlAPI),
        body: jsonEncode(body), headers: headers);

    int statusCode = response.statusCode;

    if(statusCode==200){
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage(screen, "Response Branch : $data");

      setState(() {
        loading = false;
        if (data['status'].toString() == "1") {
          maxAmt = data['branch_total_single'];
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
