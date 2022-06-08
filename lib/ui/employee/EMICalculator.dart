import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:moneypro_new/ui/models/EMIDetails.dart';
import 'package:moneypro_new/utils/Constants.dart';
import 'package:moneypro_new/utils/CustomWidgets.dart';
import 'package:moneypro_new/utils/Functions.dart';

class EMICalculator extends StatefulWidget {
  const EMICalculator({Key? key}) : super(key: key);

  @override
  _EMICalculatorState createState() => _EMICalculatorState();
}

class _EMICalculatorState extends State<EMICalculator> {
  TextEditingController loanAmtController = new TextEditingController();
  TextEditingController rateOfInterestController = new TextEditingController();
  TextEditingController tenureController = new TextEditingController();
  TextEditingController processingController = new TextEditingController();

  var screen = "EMI Calculator";

  DateTime currentDate = DateTime.now();
  final f = new DateFormat('dd-MM-yyyy');

  final yearFormat = new DateFormat('yyyy');
  var cDate;

  var selectCatPos;

  List<EMIDetails> emiDetails = [];

  var currentYear = "";
  var dobYear = "";

  String _emiResult = "";
  double princple = 0;
  double interest = 0.0, totalPay = 0.0, insuranceCharge = 0.0;
  var legalCharges = "";
  double processFee = 0.0;
  double weeklyAmt = 0.0;

  var showResult = false;

  @override
  void initState() {
    super.initState();
    setState(() {
      cDate = f.format(currentDate);
      currentYear = yearFormat.format(currentDate);
    });
    insertData();
  }

  @override
  void dispose() {
    loanAmtController.dispose();
    rateOfInterestController.dispose();
    tenureController.dispose();
    processingController.dispose();
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
                "assets/emi_cal_banner.png",
                fit: BoxFit.fill,
                height: 210.h,
              ),
            ),
          ),
        ),
        Container(
          height: 50.h,
          margin: EdgeInsets.only(top: padding, left: padding, right: padding),
          decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15, top: 0, bottom: 0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    style: TextStyle(color: black, fontSize: inputFont.sp),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: loanAmtController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: new InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      counterText: "",
                      label: Text("Loan Amount"),
                    ),
                    maxLength: 7,
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 50.h,
          margin: EdgeInsets.only(top: 15, left: padding, right: padding),
          decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15, top: 0, bottom: 0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    style: TextStyle(color: black, fontSize: inputFont.sp),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.next,
                    controller: rateOfInterestController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: new InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      counterText: "",
                      label: Text("Rate of Interest (%)"),
                    ),
                    maxLength: 7,
                  ),
                ),
              ],
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20, top: 15),
          child: Row(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  decoration: BoxDecoration(
                      color: editBg,
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                      border: Border.all(color: editBg)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      value: selectCatPos,
                      style: TextStyle(color: black, fontSize: font16.sp),
                      items: emiTenure
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 20.0),
                            child: Text(
                              value,
                              style: TextStyle(color: black),
                            ),
                          ),
                        );
                      }).toList(),
                      hint: Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Select Tenure",
                          style: TextStyle(color: lightBlack, fontSize: font16.sp),
                        ),
                      ),
                      icon: Padding(
                        padding: const EdgeInsets.only(right: 15.0),
                        child: Icon(
                          // Add this
                          Icons.keyboard_arrow_down, // Add this
                          color: lightBlue, // Add this
                        ),
                      ),
                      onChanged: (value) {
                        setState(() {
                          selectCatPos = value!;
                          FocusScope.of(context).requestFocus(new FocusNode());
                        });
                      },
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 20.w,
              ),
              Expanded(
                flex: 1,
                child: Container(
                  height: 50.h,
                  decoration: BoxDecoration(
                    color: editBg,
                    borderRadius: BorderRadius.all(Radius.circular(30)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15.0, right: 15, top: 0, bottom: 0),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: TextFormField(
                            style: TextStyle(color: black, fontSize: inputFont.sp),
                            keyboardType: TextInputType.number,
                            textInputAction: TextInputAction.next,
                            controller: tenureController,
                            textCapitalization: TextCapitalization.characters,
                            decoration: new InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.only(left: 10),
                              counterText: "",
                              label: Text("Tenure (as $selectCatPos)"),
                            ),
                            maxLength: 2,
                            onChanged: (val) {
                              if (val.length == 2) {
                                closeKeyBoard(context);
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 5),
          child: Text(
            "Maximum allowed tenure is 3 year or its equivalent",
            style: TextStyle(
              color: lightBlack,
              fontSize: font11.sp,
            ),
          ),
        ),
        InkWell(
          onTap: () {
            _selectFromDate(context);
          },
          child: Container(
            height: 50.h,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: editBg,
              borderRadius: BorderRadius.all(Radius.circular(30)),
            ),
            margin: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 5),
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: Text(
                    (cDate.toString() == f.format(currentDate).toString())
                        ? "$dob"
                        : f.format(currentDate),
                    style: TextStyle(color: black, fontSize: font16.sp),
                  ),
                ),
                Spacer(),
                Image.asset(
                  'assets/calendar.png',
                  height: 24.h,
                ),
                SizedBox(
                  width: 15.w,
                ),
              ],
            ),
          ),
        ),
        Container(
          height: 50.h,
          margin: EdgeInsets.only(top: 10, left: padding, right: padding),
          decoration: BoxDecoration(
            color: editBg,
            borderRadius: BorderRadius.all(Radius.circular(30)),
          ),
          child: Padding(
            padding:
                const EdgeInsets.only(left: 15.0, right: 15, top: 0, bottom: 0),
            child: Row(
              children: [
                Expanded(
                  flex: 1,
                  child: TextFormField(
                    style: TextStyle(color: black, fontSize: inputFont.sp),
                    keyboardType: TextInputType.number,
                    textInputAction: TextInputAction.done,
                    controller: processingController,
                    textCapitalization: TextCapitalization.characters,
                    decoration: new InputDecoration(
                      isDense: true,
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.only(left: 10),
                      counterText: "",
                      label: Text("Processing fees %"),
                    ),
                    maxLength: 2,
                  ),
                ),
              ],
            ),
          ),
        ),
        (showResult) ? _buildShowResults() : Container()
      ])),
      bottomNavigationBar: _buildButton(),
    )));
  }

  Future<void> _selectFromDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(1947),
        lastDate: DateTime.now());
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
        dobYear = pickedDate.year.toString();
      });
      closeKeyBoard(context);
    }
  }

  insertData() {
    printMessage(screen, "Lenght : ${emiDetails.length}");

    emiDetails.insert(
        0, EMIDetails(year: "20", per1: "1.72", per2: "2.71", per3: "3.72"));
    emiDetails.insert(
        1, EMIDetails(year: "21", per1: "1.74", per2: "2.76", per3: "3.78"));
    emiDetails.insert(
        2, EMIDetails(year: "22", per1: "1.76", per2: "2.80", per3: "3.82"));
    emiDetails.insert(
        3, EMIDetails(year: "23", per1: "1.78", per2: "2.82", per3: "3.85"));
    emiDetails.insert(
        4, EMIDetails(year: "24", per1: "1.80", per2: "2.84", per3: "3.89"));
    emiDetails.insert(
        5, EMIDetails(year: "25", per1: "1.80", per2: "2.85", per3: "3.91"));
    emiDetails.insert(
        6, EMIDetails(year: "26", per1: "1.87", per2: "2.96", per3: "4.05"));
    emiDetails.insert(
        7, EMIDetails(year: "27", per1: "1.87", per2: "2.98", per3: "4.09"));
    emiDetails.insert(
        8, EMIDetails(year: "28", per1: "1.89", per2: "3.00", per3: "4.11"));
    emiDetails.insert(
        9, EMIDetails(year: "29", per1: "1.89", per2: "3.02", per3: "4.18"));
    emiDetails.insert(
        10, EMIDetails(year: "30", per1: "1.91", per2: "3.06", per3: "4.23"));
    emiDetails.insert(
        11, EMIDetails(year: "31", per1: "1.93", per2: "3.12", per3: "4.31"));
    emiDetails.insert(
        12, EMIDetails(year: "32", per1: "1.97", per2: "3.18", per3: "4.41"));
    emiDetails.insert(
        13, EMIDetails(year: "33", per1: "2.01", per2: "3.26", per3: "4.52"));
    emiDetails.insert(
        14, EMIDetails(year: "34", per1: "2.05", per2: "3.34", per3: "4.68"));
    emiDetails.insert(
        15, EMIDetails(year: "35", per1: "2.10", per2: "3.45", per3: "4.84"));
    emiDetails.insert(
        16, EMIDetails(year: "36", per1: "2.37", per2: "3.93", per3: "5.52"));
    emiDetails.insert(
        17, EMIDetails(year: "37", per1: "2.47", per2: "4.09", per3: "5.78"));
    emiDetails.insert(
        18, EMIDetails(year: "38", per1: "2.57", per2: "4.28", per3: "6.07"));
    emiDetails.insert(
        19, EMIDetails(year: "39", per1: "2.68", per2: "4.49", per3: "6.42"));
    emiDetails.insert(
        20, EMIDetails(year: "40", per1: "2.78", per2: "4.75", per3: "6.81"));
    emiDetails.insert(
        21, EMIDetails(year: "41", per1: "2.93", per2: "5.05", per3: "7.26"));
    emiDetails.insert(
        22, EMIDetails(year: "42", per1: "3.11", per2: "5.37", per3: "7.77"));
    emiDetails.insert(
        23, EMIDetails(year: "43", per1: "3.39", per2: "5.76", per3: "8.37"));
    emiDetails.insert(
        24, EMIDetails(year: "44", per1: "3.51", per2: "6.21", per3: "9.05"));
    emiDetails.insert(
        25, EMIDetails(year: "45", per1: "3.79", per2: "6.72", per3: "9.86"));
    emiDetails.insert(
        26, EMIDetails(year: "46", per1: "4.51", per2: "8.07", per3: "11.89"));
    emiDetails.insert(
        27, EMIDetails(year: "47", per1: "4.86", per2: "8.83", per3: "13.03"));
    emiDetails.insert(
        28, EMIDetails(year: "48", per1: "5.29", per2: "9.65", per3: "14.28"));
    emiDetails.insert(
        29, EMIDetails(year: "49", per1: "5.76", per2: "10.57", per3: "15.70"));
    emiDetails.insert(
        30, EMIDetails(year: "50", per1: "6.28", per2: "11.57", per3: "17.20"));
    emiDetails.insert(
        31, EMIDetails(year: "51", per1: "6.82", per2: "12.62", per3: "18.79"));
    emiDetails.insert(
        32, EMIDetails(year: "52", per1: "7.39", per2: "13.76", per3: "20.44"));
    emiDetails.insert(
        33, EMIDetails(year: "53", per1: "8.00", per2: "14.91", per3: "22.21"));
    emiDetails.insert(
        34, EMIDetails(year: "54", per1: "8.62", per2: "16.12", per3: "24.00"));
    emiDetails.insert(
        35, EMIDetails(year: "55", per1: "9.25", per2: "17.37", per3: "25.87"));
    emiDetails.insert(36,
        EMIDetails(year: "56", per1: "10.27", per2: "19.28", per3: "28.72"));
    emiDetails.insert(37,
        EMIDetails(year: "57", per1: "10.98", per2: "20.64", per3: "30.76"));
    printMessage(screen, "Lenght : ${emiDetails.length}");
  }

  _buildButton() {
    return InkWell(
      onTap: () {
        var amount = loanAmtController.text.toString();
        var rate = rateOfInterestController.text.toString();
        var tenure = tenureController.text.toString();
        var fee = processingController.text.toString();

        printMessage(screen, "dobYear : $dobYear");

        if (amount.length == 0) {
          showToastMessage("Enter the amount");
          return;
        } else if (double.parse(amount) == 0) {
          showToastMessage("Enter the amount");
          return;
        } else if (rate.length == 0) {
          showToastMessage("Enter the rate of interest");
          return;
        } else if (double.parse(rate) == 0) {
          showToastMessage("Enter the rate of interest");
          return;
        } else if (selectCatPos == null) {
          showToastMessage("Select your tenure");
          return;
        } else if (tenure.length == 0) {
          showToastMessage("Enter your tenure");
          return;
        } else if (dobYear.length == 0) {
          showToastMessage("Select your DOB");
          return;
        } else if (fee.length == 0) {
          showToastMessage("Enter processing fees");
          return;
        }

        calculateInterest(amount, rate, selectCatPos, tenure, fee);
      },
      child: Container(
        height: 45.h,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.only(top: 0, left: 25, right: 25, bottom: 10),
        decoration: BoxDecoration(
          color: lightBlue,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Center(
          child: Text(
            "Calculate".toUpperCase(),
            style: TextStyle(fontSize: font16.sp, color: white),
          ),
        ),
      ),
    );
  }

  calculateInterest(amount, rate, frequency, tenure, fee) {
    var age = int.parse(currentYear) - int.parse(dobYear);

    double n = 0;
    var percentage = "";



    if (age > 20 && age < 57) {
      String x = age.toString();

      var per1 = "", per2 = "", per3 = "";

      for (int i = 0; i < emiDetails.length; i++) {
        var y = emiDetails[i].year;
        if (x == y) {
          per1 = emiDetails[i].per1;
          per2 = emiDetails[i].per2;
          per3 = emiDetails[i].per3;
          break;
        }
      }

      if (frequency.toString() == "Yearly") {
        if (tenure == "1") {
          setState(() {
            n = 12;
            percentage = per1;
          });
        } else if (tenure == "2") {
          setState(() {
            n = 24;
            percentage = per2;
          });
        } else {
          setState(() {
            n = 36;
            percentage = per3;
          });
        }
      } else if (frequency.toString() == "Monthly") {
        n = double.parse(tenure);
        if (n<12) {
          setState(() {
            percentage = per1;
          });
        } else if (n>12 && n<24) {
          setState(() {
            percentage = per2;
          });
        } else {
          setState(() {
            percentage = per3;
          });
        }
      } /*else if (frequency.toString() == "Weekly") {
        double xx = double.parse(tenure);

        if (xx<52) {
          setState(() {
            n = xx;
            percentage = per1;
          });
        } else if (n>52 && n<104) {
          setState(() {
            n = xx;
            percentage = per2;
          });
        } else {
          setState(() {
            n = xx;
            percentage = per3;
          });
        }
      }*/

      double A = 0.0;
      princple = double.parse(amount);
      double r = double.parse(rate) / 12 / 100;


      A = (princple * r * pow((1 + r), n) / (pow((1 + r), n) - 1));

      _emiResult = A.toStringAsFixed(2);

      interest = (double.parse(_emiResult) * n) - princple;

      printMessage(screen, "EMI : ${(double.parse(_emiResult) ) }");
      printMessage(screen, "Principle : $princple");
      printMessage(screen, "INTEREST : $interest");

      totalPay = A * n;

      insuranceCharge = (princple * double.parse(percentage)) / 1000;

      insuranceCharge = insuranceCharge + (insuranceCharge / 100) * 18;

      weeklyAmt = double.parse(_emiResult)/4;


      if (princple <= 25000) {
        setState(() {
          legalCharges = "1050";
        });
      } else {
        setState(() {
          legalCharges = "2000";
        });
      }

      processFee = (princple / 100) * double.parse(fee);

      /*printMessage(screen, "EMI : ${_emiResult}");
      printMessage(screen, "Princple : ${princple}");
      printMessage(screen, "Interest : ${interest}");
      printMessage(screen, "Total Pay : ${totalPay}");
      printMessage(screen, "Insurance Charge : ${insuranceCharge}");
      printMessage(screen, "Legal Charge : ${legalCharges}");
      printMessage(screen, "Process Fee : ${processFee}");*/

      setState(() {
        showResult = true;
      });
    } else {
      printMessage(screen, "NO ENTERY");
      setState(() {
        showResult = false;
      });
      showToastMessage("Minimum age is 21 years and Maximum age is 57 years");
    }
  }

  _buildShowResults() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 25.0, top: 20),
            child: Text(
              "Results",
              style: TextStyle(
                  color: black,
                  fontSize: font16.sp,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25, top: 20, bottom: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "Monthly EMI",
                      style: TextStyle(color: lightBlack, fontSize: font14.sp),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "$rupeeSymbol $_emiResult",
                      style: TextStyle(
                          color: black,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    )),
              ],
            ),
          ),
          Divider(
            color: gray,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25, top: 20, bottom: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "Weekly EMI",
                      style: TextStyle(color: lightBlue, fontSize: font14.sp),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "$rupeeSymbol ${formatString.format(weeklyAmt)}",
                      style: TextStyle(
                          color: lightBlue,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    )),
              ],
            ),
          ),
          Divider(
            color: gray,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25, top: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "Principle",
                      style: TextStyle(color: lightBlack, fontSize: font14.sp),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "$rupeeSymbol $princple",
                      style: TextStyle(
                          color: black,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    )),
              ],
            ),
          ),
          Divider(
            color: gray,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25, top: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "Interest Paid",
                      style: TextStyle(color: lightBlack, fontSize: font14.sp),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "$rupeeSymbol ${formatNow.format(interest)}",
                      style: TextStyle(
                          color: black,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    )),
              ],
            ),
          ),
          Divider(
            color: gray,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25, top: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "Total Repayment",
                      style: TextStyle(color: lightBlack, fontSize: font14.sp),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "$rupeeSymbol ${formatNow.format(totalPay)}",
                      style: TextStyle(
                          color: black,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    )),
              ],
            ),
          ),
          Divider(
            color: gray,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25, top: 10, bottom: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        flex: 1,
                        child: Text(
                          "Insurance Charges",
                          style: TextStyle(color: lightBlack, fontSize: font14.sp),
                        )),
                    Expanded(
                        flex: 1,
                        child: Text(
                          "$rupeeSymbol ${formatNow.format(insuranceCharge)}",
                          style: TextStyle(
                              color: black,
                              fontSize: font14.sp,
                              fontWeight: FontWeight.bold),
                          textAlign: TextAlign.right,
                        )),
                  ],
                ),
                Text(
                  "(Including 18% GST)",
                  style: TextStyle(
                    color: lightBlack,
                    fontSize: font10,
                  ),
                )
              ],
            ),
          ),
          Divider(
            color: gray,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25, top: 10, bottom: 10),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "Legal Charges",
                      style: TextStyle(color: lightBlack, fontSize: font14.sp),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "$rupeeSymbol $legalCharges",
                      style: TextStyle(
                          color: black,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    )),
              ],
            ),
          ),
          Divider(
            color: gray,
          ),
          Padding(
            padding: const EdgeInsets.only(
                left: 25.0, right: 25, top: 10, bottom: 20),
            child: Row(
              children: [
                Expanded(
                    flex: 1,
                    child: Text(
                      "Processing Fees",
                      style: TextStyle(color: lightBlack, fontSize: font14.sp),
                    )),
                Expanded(
                    flex: 1,
                    child: Text(
                      "$rupeeSymbol ${formatNow.format(processFee)}",
                      style: TextStyle(
                          color: black,
                          fontSize: font14.sp,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.right,
                    )),
              ],
            ),
          ),
          Divider(
            color: gray,
          ),
        ],
      ),
    );
  }
}
