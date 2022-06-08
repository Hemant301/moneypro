import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/Functions.dart';

class SwitchDates extends StatefulWidget {
  final int action;
  final String branchId;
  final String mobile;
  final String branchWallet;

  const SwitchDates(
      {Key? key,
      required this.action,
      required this.branchId,
      required this.mobile,
      required this.branchWallet})
      : super(key: key);

  @override
  State<SwitchDates> createState() => _SwitchDatesState();
}

class _SwitchDatesState extends State<SwitchDates> {
  DateTime currentFromDate = DateTime.now();
  DateTime currentToDate = DateTime.now();
  final f = new DateFormat('dd-MM-yyyy');
  final passDateFormat = new DateFormat('yyyy-MM-dd');

  var isFromDate = false;
  var isToDate = false;
  var cDate;

  var screen = "Switch Dates";

  @override
  void initState() {
    super.initState();
    setState(() {
      cDate = f.format(currentFromDate);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: Size(deviceWidth, deviceHeight),
        builder: () => SafeArea(
              child: Scaffold(
                backgroundColor: Colors.transparent.withOpacity(0.5),
                body: Column(
                  children: [
                    Expanded(flex: 1, child: Container()),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: white,
                          borderRadius: BorderRadius.all(Radius.circular(25)),
                          border: Border.all(color: white)),
                      child: Column(
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 20.0, bottom: 15),
                            child: Text(
                              "Search transaction by Date",
                              style: TextStyle(
                                  color: black,
                                  fontSize: font16,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, right: 20, bottom: 0),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      _selectFromDate(context);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: editBg,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          f.format(currentFromDate),
                                          style: TextStyle(
                                              color: black,
                                              fontSize: font14.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15.w,
                                ),
                                Expanded(
                                  flex: 1,
                                  child: InkWell(
                                    onTap: () {
                                      _selectToDate(context);
                                    },
                                    child: Container(
                                      width: MediaQuery.of(context).size.width,
                                      decoration: BoxDecoration(
                                        color: editBg,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(20)),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Text(
                                          f.format(currentToDate),
                                          style: TextStyle(
                                              color: black,
                                              fontSize: font14.sp),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: InkWell(
                              onTap: () {
                                printMessage(screen,
                                    "From Date : ${passDateFormat.format(currentFromDate)}");
                                printMessage(screen,
                                    "From Date : ${passDateFormat.format(currentToDate)}");

                                if (widget.action == 1) {
                                  closeParticularPage(
                                      context, "TransactionHistory");
                                  openTransactionHistory(
                                      context,
                                      "${passDateFormat.format(currentFromDate)}",
                                      "${passDateFormat.format(currentToDate)}");
                                }

                                if (widget.action == 2) {
                                  removeAllPages(context);
                                  openBranchTransactions(
                                      context,
                                      widget.branchId,
                                      widget.mobile,
                                      widget.branchWallet,
                                      "${passDateFormat.format(currentFromDate)}",
                                      "${passDateFormat.format(currentToDate)}");
                                }
                              },
                              child: Container(
                                width: MediaQuery.of(context).size.width,
                                margin: EdgeInsets.only(
                                    top: 0, left: 0, right: 0, bottom: 10),
                                decoration: BoxDecoration(
                                  color: lightBlue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(25)),
                                ),
                                child: Center(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text(
                                      submit.toUpperCase(),
                                      style: TextStyle(
                                          fontSize: font15, color: white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ));
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentFromDate,
        firstDate: DateTime(2019),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentFromDate) {
      setState(() {
        currentFromDate = pickedDate;
        isFromDate = true;
      });
    } else {
      setState(() {
        isFromDate = false;
      });
    }
  }

  Future<void> _selectToDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentToDate,
        firstDate: DateTime(2019),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentToDate) {
      setState(() {
        currentToDate = pickedDate;
        isToDate = true;
      });
    } else {
      isToDate = false;
    }
  }
}
