import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:moneypro_new/utils/Apis.dart';
import 'package:moneypro_new/utils/AppKeys.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';
import 'package:moneypro_new/utils/SharedPrefs.dart';

class Filtertransaction extends StatefulWidget {
  const Filtertransaction({Key? key}) : super(key: key);

  @override
  State<Filtertransaction> createState() => _FiltertransactionState();
}

class _FiltertransactionState extends State<Filtertransaction> {
  List qrResponse = [];
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: fromDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != fromDate) {
      setState(() {
        fromDate = picked;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: toDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != toDate) {
      setState(() {
        toDate = picked;
      });
    }
  }

  bool isLoading = false;
  int page = 1;
  ScrollController _scrollController = ScrollController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _scrollController.addListener(_scrollEvent);
  }

  void _scrollEvent() {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      setState(() {
        page = page + 1;
        getTodayScroolTransactions();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    print(fromDate);
    print(toDate);
    return Scaffold(
      appBar: AppBar(
        elevation: 4,
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
      ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(children: [
          SizedBox(
            height: 15,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                  onTap: () {
                    _selectDate(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        // color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'From date\n${(fromDate).toString().substring(0, 10)}',
                      textAlign: TextAlign.center,
                    ),
                  )),
              InkWell(
                  onTap: () {
                    _selectToDate(context);
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.blue),
                        // color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'To date\n${(toDate).toString().substring(0, 10)}',
                      textAlign: TextAlign.center,
                    ),
                  )),
              InkWell(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  getTodayTransactions();
                },
                child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10)),
                    child: Text(
                      'Filter',
                      style: TextStyle(color: Colors.white),
                    )),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Divider(),
          ),
          SizedBox(height: 10),
          isLoading == true ? CircularProgressIndicator() : Container(),
          qrResponse.isEmpty
              ? Text('No Data Found')
              : Column(
                  children: List.generate(
                      qrResponse.length,
                      (index) => Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, top: 0),
                            child: InkWell(
                              onTap: () {
                                print('branch0');
                              },
                              child: Container(
                                margin: EdgeInsets.only(top: 10),
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    color: white,
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(30)),
                                    border: Border.all(color: gray)),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Container(
                                          height: 45.h,
                                          width: 45.w,
                                          decoration: BoxDecoration(
                                            color: lightBlue, // border color
                                            shape: BoxShape.circle,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.all(9.0),
                                            child: Image.asset(
                                              'assets/wallet_white.png',
                                            ),
                                          )),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                      Expanded(
                                          flex: 1,
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Text(
                                                  "${qrResponse[index]['name']}",
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: font15.sp),
                                                  textAlign: TextAlign.left,
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 10.0),
                                                child: Text(
                                                  "${qrResponse[index]['date']} | ${qrResponse[index]['time']}",
                                                  style: TextStyle(
                                                      color: black,
                                                      fontSize: font13.sp),
                                                  textAlign: TextAlign.left,
                                                ),
                                              )
                                            ],
                                          )),
                                      Column(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8, top: 8),
                                            child: Text(
                                              "$rupeeSymbol ${qrResponse[index]['amount']}",
                                              style: TextStyle(
                                                  color: black,
                                                  fontSize: font16.sp),
                                            ),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 8.0, right: 8, bottom: 8),
                                            child: Text("Credited",
                                                style: TextStyle(
                                                    color: black,
                                                    fontSize: font13.sp)),
                                          )
                                        ],
                                      ),
                                      SizedBox(
                                        width: 5.w,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )),
                )
        ]),
      ),
    );
  }

  Future getTodayTransactions() async {
    var userToken = await getToken();

    var headers = {
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$userToken",
      "start_date": '${(fromDate).toString().substring(0, 10)}',
      "end_date": '${(toDate).toString().substring(0, 10)}',
      "page": "1"
    };

    printMessage('Filter', "body : $body");

    final response = await http.post(Uri.parse(qrSearchByDateAPI),
        body: body, headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage("filter", "Today Txn : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          setState(() {
            isLoading = false;
            qrResponse = data['qr_response'];
          });
        } else {
          Fluttertoast.showToast(msg: data['message']);
        }
      });
    } else {
      showToastMessage(status500);
    }
  }

  Future getTodayScroolTransactions() async {
    var userToken = await getToken();

    var headers = {
      "Authorization": "$authHeader",
    };

    final body = {
      "token": "$userToken",
      "start_date": '${(fromDate).toString().substring(0, 10)}',
      "end_date": '${(toDate).toString().substring(0, 10)}',
      'page': '$page'
    };

    printMessage('Filter', "body : $body");

    final response = await http.post(Uri.parse(qrSearchByDateAPI),
        body: body, headers: headers);

    int statusCode = response.statusCode;

    if (statusCode == 200) {
      var data = jsonDecode(utf8.decode(response.bodyBytes));

      printMessage("filter", "Today Txn : $data");

      setState(() {
        if (data['status'].toString() == "1") {
          setState(() {
            qrResponse.addAll(data['qr_response']);
          });
        } else {
          Fluttertoast.showToast(msg: data['message']);
        }
      });
    } else {
      showToastMessage(status500);
    }
  }
}
