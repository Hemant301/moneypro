import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/ui/models/DuePayment.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:moneypro_new/utils/Functions.dart';

class OverPaymentDue extends StatefulWidget {
  final String loanId;

  const OverPaymentDue({Key? key, required this.loanId}) : super(key: key);

  @override
  _OverPaymentDueState createState() => _OverPaymentDueState();
}

class _OverPaymentDueState extends State<OverPaymentDue> {
  var screen = "Over Due list";

  var loading = false;

  List<DueList> dueList = [];

  final dueAmtController = TextEditingController();

  @override
  void initState() {
    super.initState();
    getDuePaymentList();
  }

  @override
  void dispose() {
    dueAmtController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () =>SafeArea(
        child: Scaffold(
            backgroundColor: white,
            appBar: appBarHome(context, "", 24.0.w),
            body: (loading)
                ? Center(
                    child: circularProgressLoading(40.0),
                  )
                : SingleChildScrollView(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
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
                                "assets/over_due_banner.png",
                                fit: BoxFit.fill,
                                height: 200.h,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20.h,
                        ),
                        (dueList.length == 0)
                            ? NoDataFound(text: "No Data found")
                            : _buildDueList()
                      ])))));
  }

  _buildDueList() {
    return ListView.builder(
        itemCount: dueList.length,
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              var id = dueList[index].id.toString();
              _showDuePayment(id);
            },
            child: Container(
              margin: EdgeInsets.only(left: 15, right: 15, bottom: 10),
              decoration: BoxDecoration(
                color: editBg,
                borderRadius: BorderRadius.all(Radius.circular(20)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: 20.w,
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Due Amount",
                            style:
                                TextStyle(color: lightBlack, fontSize: font14.sp),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "Due Date",
                            style:
                                TextStyle(color: lightBlack, fontSize: font14.sp),
                          )
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 2,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            "$rupeeSymbol ${dueList[index].dueamount}",
                            style: TextStyle(
                                color: black,
                                fontSize: font16.sp,
                                fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: 5.h,
                          ),
                          Text(
                            "${dueList[index].duedate}",
                            style: TextStyle(
                                color: black,
                                fontSize: font16.sp,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10.w,
                    ),
                    Icon(
                      Icons.arrow_forward_ios_sharp,
                      size: 16,
                      color: lightBlue,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future getDuePaymentList() async {
    try {
      setState(() {
        loading = true;
      });

      var header = {"Content-Type": "application/json"};

      final body = {"loan_id": "${widget.loanId}"};

      printMessage(screen, "body : $body");

      final response = await http.post(Uri.parse(dueListAPI),
          body: jsonEncode(body), headers: header);
      int statusCode = response.statusCode;

      if(statusCode==200){
        var data = jsonDecode(utf8.decode(response.bodyBytes));

        printMessage(screen, "Response Due : $data");

        setState(() {
          loading = false;
          var status = data['status'].toString();
          if (status == "1") {
            var result =
            DuePayment.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
            dueList = result.dueList;
          } else {
            showToastMessage(data['message'].toString());
          }
        });
      }else{
        setState(() {
          loading = false;
        });
        showToastMessage(status500);
      }


    } catch (e) {
      printMessage(screen, "Error : ${e.toString()}");
    }
  }

  _showDuePayment(id) {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        enableDrag: true,
        isDismissible: true,
        backgroundColor: Colors.transparent,
        builder: (context) => InkWell(
            onTap: () {
              //Navigator.of(context).pop();
            },
            child: Center(
              child: Wrap(
                children: [
                  Container(
                    margin: EdgeInsets.only(left: 20, right: 20),
                    width: MediaQuery.of(context).size.width,
                    decoration: BoxDecoration(
                      color: white,
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                    ),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20.h,
                        ),
                        Text(
                          "Due Payment",
                          style: TextStyle(color: black, fontSize: font15.sp),
                        ),
                        SizedBox(
                          height: 10.h,
                        ),
                        Divider(
                          color: gray,
                        ),
                        Container(
                          margin: EdgeInsets.only(top: 30, left: 15, right: 15),
                          decoration: BoxDecoration(
                              color: editBg,
                              borderRadius:
                              BorderRadius.all(Radius.circular(25)),
                              border: Border.all(color: editBg)),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 1,
                                child: TextFormField(
                                  style:
                                  TextStyle(color: black, fontSize: font15.sp),
                                  keyboardType: TextInputType.number,
                                  textInputAction: TextInputAction.done,
                                  controller: dueAmtController,
                                  decoration: new InputDecoration(
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(left: 20),
                                    counterText: "",
                                    hintText: "enter due amount",
                                    hintStyle: TextStyle(color: black),
                                    floatingLabelBehavior:
                                    FloatingLabelBehavior.never,
                                  ),
                                  maxLength: 6,
                                ),
                              ),
                              SizedBox(
                                width: 15.w,
                              )
                            ],
                          ),
                        ),
                        InkWell(
                          onTap: () {
                            var dueAmt = dueAmtController.text.toString();

                            if (dueAmt.length == 0) {
                              showToastMessage("Enter the amount");
                              return;
                            }
                            duePaymentTask(dueAmt, id);
                          },
                          child: Container(
                            height: 50.h,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.only(
                                top: 20, left: 10, right: 10, bottom: 10),
                            decoration: BoxDecoration(
                              color: lightBlue,
                              borderRadius:
                              BorderRadius.all(Radius.circular(25)),
                            ),
                            child: Center(
                              child: Text(
                                submit.toUpperCase(),
                                style:
                                TextStyle(fontSize: font15.sp, color: white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(height: 10.h),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }

  Future duePaymentTask(amount, id) async {
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

      final body = {
        "id": "$id",
        "amount": "$amount",
        "loan_id": "${widget.loanId}"
      };

      printMessage(screen, "body : $body");

      final response = await http.post(Uri.parse(duePaymentAPI),
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
                  return showMessageDialog(message: data['message'].toString(),action: 0);
                });
            dueList.clear();
            getDuePaymentList();
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
