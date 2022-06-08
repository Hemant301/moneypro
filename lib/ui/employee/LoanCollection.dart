import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class LoanCollection extends StatefulWidget {
  const LoanCollection({Key? key}) : super(key: key);

  @override
  _LoanCollectionState createState() => _LoanCollectionState();
}

class _LoanCollectionState extends State<LoanCollection> {
  var screen = "Loan Collection";
  TextEditingController loanIdController = new TextEditingController();
  final regularAmtController = TextEditingController();

  var isSearchShow = false;
  var showDetails = false;

  String borrowerId = "";
  String borrowerName = "";
  String mobile = "";
  String bazarName = "";
  String sanctionedAmnt = "";
  String disbursementAmnt = "";
  String disbursementDate = "";
  String paymentMode = "";
  String emiAmount = "";
  String emiDate = "";
  String dueStatus = "";
  double dueAmount = 0.0;

  @override
  void initState() {
    super.initState();
    updateATMStatus(context);
    fetchUserAccountBalance();
  }

  @override
  void dispose() {
    loanIdController.dispose();
    regularAmtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
      backgroundColor: white,
      appBar: appBarHome(context, "", 24.0),
      body: SingleChildScrollView(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                "assets/loan_banner.png",
                fit: BoxFit.fill,
                height: 200.h,
              ),
            ),
          ),
        ),
        Container(
          margin: EdgeInsets.only(top: padding, left: padding, right: padding),
          decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.only(
                left: 15.0, right: 15, top: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    style: TextStyle(color: black, fontSize: inputFont.sp),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: loanIdController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: new InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      counterText: "",
                      label: Text("Loan Id"),
                    ),
                    maxLength: 8,
                    onChanged: (val) {
                      if (val.length > 4) {
                        setState(() {
                          isSearchShow = true;
                        });
                      } else {
                        setState(() {
                          isSearchShow = false;
                        });
                      }
                    },
                  ),
                ),
                (isSearchShow)
                    ? InkWell(
                        onTap: () {
                          closeKeyBoard(context);
                          var loanId = loanIdController.text.toString();
                          getEmiDetails(loanId);
                        },
                        child: Icon(
                          Icons.search,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ),
        SizedBox(
          height: 10.h,
        ),
        (showDetails) ? _buildSetData() : Container(),
      ])),
      bottomNavigationBar: (showDetails)
          ? _buttonSections()
          : Container(
              height: 1.h,
            ),
    )));
  }

  Future getEmiDetails(loanId) async {
    try {
      setState(() {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return CustomAppDialog(message: pleaseWait);
            });
      });

      var header = {"Content-Type": "application/json"};

      final body = {"loan_app_id": "$loanId"};

      printMessage(screen, "body : $body");

      final response = await http.post(Uri.parse(loanSearchAPI),
          body: jsonEncode(body), headers: header);

      int statusCode = response.statusCode;

      if (statusCode == 200) {
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Response Loan : $data");

        setState(() {
          Navigator.pop(context);
          var status = data['status'].toString();
          if (status == "1") {
            showDetails = true;

            borrowerId = data['data']['loan_id'].toString();

            borrowerName = data['data']['borrower_name'].toString();

            mobile = data['data']['mobile'].toString();

            bazarName = data['data']['bazar_name'].toString();

            sanctionedAmnt = data['data']['sanctioned_amnt'].toString();

            disbursementAmnt = data['data']['disbursement_amnt'].toString();

            disbursementDate = data['data']['disbursement_date'].toString();

            paymentMode = data['data']['payment_mode'].toString();

            emiAmount = data['data']['emi_amount'].toString();

            dueStatus = data['due_status'].toString();

            emiDate = data['emi_date'].toString();

           var dueAmt = data['dueamount'].toString();

           if(dueAmt.toString().length!=0){
             dueAmount  = double.parse(dueAmt);
           }



          } else {
            showDetails = false;
            showToastMessage(data['message'].toString());
          }
        });
      } else {
        setState(() {
          Navigator.pop(context);
          showDetails = false;
        });
        showToastMessage(status500);
      }
    } catch (e) {
      printMessage(screen, "Error : ${e.toString()}");
    }
  }

  _buildSetData() {
    return Container(
      margin: EdgeInsets.only(top: 10, left: padding, right: padding),
      decoration: BoxDecoration(
        color: editBg,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 10.h,
          ),
          Row(
            children: [
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        "EMI Amount",
                        style: TextStyle(
                          color: lightBlack,
                          fontSize: font14.sp,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        "$rupeeSymbol $emiAmount",
                        style: TextStyle(
                            color: black,
                            fontSize: font20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        "Due Amount",
                        style: TextStyle(
                          color: lightBlack,
                          fontSize: font14.sp,
                        ),
                      ),
                    ),
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        "$rupeeSymbol $dueAmount",
                        style: TextStyle(
                            color: black,
                            fontSize: font20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  children: [
                    FittedBox(
                        fit: BoxFit.cover,
                        child: Text(
                          "Next EMI Date",
                          style: TextStyle(
                            color: lightBlack,
                            fontSize: font14.sp,
                          ),
                        )),
                    FittedBox(
                      fit: BoxFit.cover,
                      child: Text(
                        "$emiDate",
                        style: TextStyle(
                            color: black,
                            fontSize: font20.sp,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 5.w,
              ),
            ],
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text("Borrower Name",
                        style: TextStyle(
                          color: lightBlack,
                          fontSize: font16.sp,
                        ))),
                Expanded(
                    flex: 2,
                    child: Text(borrowerName,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text("Borrower Mobile",
                        style: TextStyle(
                          color: lightBlack,
                          fontSize: font16.sp,
                        ))),
                Expanded(
                    flex: 2,
                    child: Text(mobile,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text("Bazar Name",
                        style: TextStyle(
                          color: lightBlack,
                          fontSize: font16.sp,
                        ))),
                Expanded(
                    flex: 2,
                    child: Text(bazarName,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text("Sanctioned Amt",
                        style: TextStyle(
                          color: lightBlack,
                          fontSize: font16.sp,
                        ))),
                Expanded(
                    flex: 2,
                    child: Text("$rupeeSymbol $sanctionedAmnt",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text("Disburshement Amt",
                        style: TextStyle(
                          color: lightBlack,
                          fontSize: font16.sp,
                        ))),
                Expanded(
                    flex: 2,
                    child: Text("$rupeeSymbol $disbursementAmnt",
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 20.0, right: 20, top: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text("Disbursement Date",
                        style: TextStyle(
                          color: lightBlack,
                          fontSize: font16.sp,
                        ))),
                Expanded(
                    flex: 2,
                    child: Text(disbursementDate,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                        ))),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 20.0, right: 20, top: 10, bottom: 20),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text("Payment Mode",
                        style: TextStyle(
                          color: lightBlack,
                          fontSize: font16.sp,
                        ))),
                Expanded(
                    flex: 2,
                    child: Text(paymentMode,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          color: black,
                          fontSize: font16.sp,
                        ))),
              ],
            ),
          ),
        ],
      ),
    );
  }

  _buttonSections() {
    return Container(
      height: 50.h,
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                _showRegularPayment();
              },
              child: Container(
                height: 50.h,
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    regPay.toUpperCase(),
                    style: TextStyle(fontSize: font15.sp, color: white),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: InkWell(
              onTap: () {
                if (dueAmount>0.0) {
                  openOverPaymentDue(context, borrowerId);
                } else {
                  showToastMessage("No due");
                }
              },
              child: Container(
                height: 50.h,
                width: MediaQuery.of(context).size.width,
                margin:
                    EdgeInsets.only(top: 0, left: 10, right: 10, bottom: 10),
                decoration: BoxDecoration(
                  color: lightBlue,
                  borderRadius: BorderRadius.all(Radius.circular(25)),
                ),
                child: Center(
                  child: Text(
                    duePay.toUpperCase(),
                    style: TextStyle(fontSize: font15.sp, color: white),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _showRegularPayment() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (context) => Center(
          child: Wrap(
            children: [
              Container(
                margin: EdgeInsets.only(left: 20, right: 20),
                child: Center(
                  child: Container(
                    width: MediaQuery.of(context).size.width,

                    decoration: BoxDecoration(
                        color: white,
                        borderRadius: BorderRadius.all(Radius.circular(25)),
                        border: Border.all(color: white, width: 2.w)),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Regular Payment",
                          style: TextStyle(color: black, fontSize: font15.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Divider(
                          color: gray,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 10, left: 15, right: 15),
                          decoration: BoxDecoration(
                            color: editBg,
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                          ),
                          child: TextFormField(
                            style:
                            TextStyle(color: black, fontSize: font15.sp),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.done,
                            controller: regularAmtController,
                            decoration: new InputDecoration(
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 20),
                              counterText: "",
                              hintText: "enter amount",
                              hintStyle: TextStyle(color: black),
                              floatingLabelBehavior:
                              FloatingLabelBehavior.never,
                            ),
                            maxLength: 6,
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            var regAmt = regularAmtController.text.toString();

                            if (regAmt.length == 0) {
                              showToastMessage("Enter the amount");
                              return;
                            }
                            closeKeyBoard(context);
                            regularPaymentTask(regAmt);
                          },
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: lightBlue,
                              borderRadius: BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(top: 5.0, bottom: 5),
                                child: Text(
                                  submit.toUpperCase(),
                                  style: TextStyle(fontSize: font15.sp, color: white),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ));
  }

  Future regularPaymentTask(amount) async {
    try {
      setState(() {
        showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return CustomAppDialog(message: pleaseWait);
            });
      });

      var header = {"Content-Type": "application/json"};

      final body = {"loan_id": "$borrowerId", "amount": "$amount"};

      printMessage(screen, "body : $body");

      final response = await http.post(Uri.parse(regularPaymentAPI),
          body: jsonEncode(body), headers: header);

      int statusCode = response.statusCode;

      if(statusCode==200){
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Response Loan : $data");

        setState(() {
          Navigator.pop(context);
          Navigator.pop(context);
          var status = data['status'].toString();
          if (status == "1") {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return showMessageDialog(
                      message: data['message'].toString(), action: 0);
                });
          } else {
            showToastMessage(data['message'].toString());
          }
        });
      }else{
        setState(() {
          Navigator.pop(context);
          Navigator.pop(context);
        });
        showToastMessage(status500);
      }


    } catch (e) {
      printMessage(screen, "Error : ${e.toString()}");
    }
  }
}
